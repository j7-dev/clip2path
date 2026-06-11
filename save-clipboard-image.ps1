# clip2path — https://github.com/j7-dev/clip2path
# Saves the current clipboard image to the given path as PNG.
# The clipboard content is read-only here and never modified.

param(
    [Parameter(Mandatory)]
    [string]$Path
)

Add-Type -AssemblyName System.Windows.Forms, System.Drawing

$img = [System.Windows.Forms.Clipboard]::GetImage()
if ($img) {
    $img.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
    $img.Dispose()
}
