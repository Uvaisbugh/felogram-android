[CmdletBinding()]
param(
    [string]$SdkPath = $env:ANDROID_HOME,
    [string]$JavaPath = $env:JAVA_HOME,
    [string]$Task = ':TMessagesProj_App:assembleAfatDebug',
    [ValidateSet('arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64', 'all')]
    [string]$Abi = 'arm64-v8a',
    [switch]$PreflightOnly,
    [switch]$AllowSdkDownload
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path -Parent $PSScriptRoot
if (-not $SdkPath) { $SdkPath = Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
if (-not $JavaPath) {
    $javaCommand = Get-Command java -ErrorAction Stop
    $JavaPath = Split-Path -Parent (Split-Path -Parent $javaCommand.Source)
}
$javaExe = Join-Path $JavaPath 'bin\java.exe'
$wrapperJar = Join-Path $projectRoot 'gradle\wrapper\gradle-wrapper.jar'
$requiredPaths = @{
    'Java executable' = $javaExe
    'Gradle wrapper' = $wrapperJar
    'SDK 36' = Join-Path $SdkPath 'platforms\android-36\android.jar'
    'Build tools 36' = Join-Path $SdkPath 'build-tools\36.0.0\aapt2.exe'
    'NDK 27.2.12479018' = Join-Path $SdkPath 'ndk\27.2.12479018\source.properties'
    'CMake 3.22.1' = Join-Path $SdkPath 'cmake\3.22.1\bin\cmake.exe'
    'Media submodule' = Join-Path $projectRoot 'TMessagesProj_Modules\media\core_settings.gradle'
    'JLatexMath submodule' = Join-Path $projectRoot 'TMessagesProj\lib\jlatexmath\jlatexmath\build.gradle'
}
$missing = @()
foreach ($item in $requiredPaths.GetEnumerator() | Sort-Object Key) {
    $present = Test-Path -LiteralPath $item.Value
    Write-Output ('{0}: {1}' -f $item.Key, $(if ($present) { 'present' } else { 'missing' }))
    if (-not $present) { $missing += $item.Key }
}
if ($missing.Count -gt 0) {
    $canDownload = $AllowSdkDownload -and @($missing | Where-Object {
        $_ -notin @('SDK 36', 'Build tools 36', 'NDK 27.2.12479018', 'CMake 3.22.1')
    }).Count -eq 0
    if (-not $canDownload) {
        throw ('Missing prerequisites: ' + ($missing -join ', ') + '. See docs/BUILD_WINDOWS_HOST.md.')
    }
    Write-Output 'Gradle may download missing SDK components using existing accepted SDK licenses.'
}
if ($PreflightOnly) { return }

$previousJava = $env:JAVA_HOME
$previousAndroid = $env:ANDROID_HOME
$previousGradle = $env:GRADLE_USER_HOME
Push-Location $projectRoot
try {
    $env:JAVA_HOME = $JavaPath
    $env:ANDROID_HOME = $SdkPath
    if (-not $env:GRADLE_USER_HOME) {
        $env:GRADLE_USER_HOME = Join-Path $projectRoot '.gradle-user-home'
    }
    $abiArguments = @()
    if ($Abi -ne 'all') {
        $abiArguments = @(
            "-Pandroid.injected.build.abi=$Abi",
            "-DfelogramBuildAbi=$Abi",
            '--init-script', (Join-Path $PSScriptRoot 'single-abi.gradle')
        )
    }
    & $javaExe -classpath $wrapperJar org.gradle.wrapper.GradleWrapperMain $Task @abiArguments `
        --no-daemon --max-workers=2 '-Dorg.gradle.jvmargs=-Xmx4g -XX:MaxMetaspaceSize=1g -Dfile.encoding=UTF-8' `
        --console=plain
    if ($LASTEXITCODE -ne 0) { throw "Gradle failed with exit code $LASTEXITCODE." }
    if ($Task -eq ':TMessagesProj_App:assembleAfatDebug') {
        $apkPath = Join-Path $projectRoot 'TMessagesProj_App\build\intermediates\apk\afat\debug\app.apk'
        if (-not (Test-Path -LiteralPath $apkPath)) {
            throw 'Gradle completed but the tested APK output location is missing; inspect the AGP listing redirect.'
        }
        Write-Output "APK: $apkPath"
        Write-Output ('SHA-256: ' + (Get-FileHash -LiteralPath $apkPath -Algorithm SHA256).Hash)
    }
} finally {
    Pop-Location
    $env:JAVA_HOME = $previousJava
    $env:ANDROID_HOME = $previousAndroid
    $env:GRADLE_USER_HOME = $previousGradle
}
