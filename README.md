# Capture One Virtual Copy

In Capture One you can work with image variants, it's cool feature!
But when you start to organizing images in albums, every time that you put a image in a album all variants are on present.
You can use Smart Albums or solution like [Stacked Variants Album](https://forum.phaseone.com/En/viewtopic.php?f=70&t=32066) by Eric Nepean.

I don't like these solutions.

This script work in different way, but you have to change a bit your workflow, instead to use a "variant" feature you have to use a "Virtual Copy" script.

This script use a filesystem feature called [symbolic links](https://en.wikipedia.org/wiki/Symbolic_link). The symbolic links is like a copy of the file, but it does not take space, it's only few bytes. Capture One recognizes it how a new file.

When a "Virtual Copy" is created this happen under the hood:
- create symbolic links with original file in the same folder, with -VC(number) postfix, ie. DSCF5151-VC1.RAF, DSCF5151-VC2.RAF, DSCF5151-VC3.RAF, ...
- the new file is imported
- in the new file are copied the adjustments, metadata, color tag, stars and cropping.

At this point you can work on it and move in the album.

When you backup/restore the original file, backup also the symbolic links.

Are supported both catalog and session.

# Installation

## Capture One 20

- Open Capture One
- Select the menu "Scripts > Open script folder", a finder folder will be open
- Open the folder "CaptureOne 20"
- Copy the file Virtual Copy.applescript in scripts folder
- Select the menu "Scripts > Update Menu Scripts"

If you want the shortcut (⇧f2), open the terminal and paste this line:
```
defaults write com.captureone.captureone13 NSUserKeyEquivalents -dict-add "Virtual Copy" "$\\Uf705"
```

## Capture One 12

- Open Capture One
- Select the menu "Scripts > Open script folder", a finder folder will be open
- Open the folder "CaptureOne 12"
- Copy the file Virtual Copy.applescript in scripts folder
- Select the menu "Scripts > Update Menu Scripts"

If you want the shortcut (⇧f2), open the terminal and paste this line:
```
defaults write com.phaseone.captureone12 NSUserKeyEquivalents -dict-add "Virtual Copy" "$\\Uf705"
```

# Know issue

- in session the Virtual Copy isn't selected after the script run
- in session when you delete a Virtual Copy it disappears from Trash folder. You have to delete from file system.

# License

The MIT License (MIT). Please see [License File](LICENSE) for more information.

