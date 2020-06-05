(*
	Create a Virtual Copy of the image

	Created by Daniele Ugoletti
*)
use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions

tell the application "Capture One 20"
	-- guess if we work with session or catalog
	set tehDocumentId to (id of (current document))
	set theDocumentIdLength to length of tehDocumentId
	set theDocumentCatalog to characters (theDocumentIdLength - 9) thru -1 of tehDocumentId as string

	if theDocumentCatalog is ".cocatalog" then
		set isSession to false
	else
		set isSession to true
	end if

	set theSource to primary variant

	-- check if a image is sselected
	if theSource is equal to missing value then
		set theDialogText to "Please select a image or variant."
		display dialog theDialogText buttons {"Ok"} default button "Ok"
		return
	end if

	-- check if the image is offline
	if not (exists file of (parent image of theSource)) then
		set theDialogText to "Virtual Copy does not work with offline file."
		display dialog theDialogText buttons {"Ok"} default button "Ok"
		return
	end if

	set theFilePath to path of (parent image of theSource)
	copy adjustments theSource


	-- create the sym link
	set theBashScript to "#!/bin/bash
fullfilename=" & quoted form of theFilePath & "
filename=$(basename \"$fullfilename\")
dirname=$(dirname \"$fullfilename\")
fname=\"${filename%.*}\"
ext=\"${filename##*.}\"

cd \"$dirname\"
i=1
while [[ -e \"$fname-$i.$ext\" || -L \"$fname-VC$i.$ext\" ]] ; do
   let i++
done
ln -s \"$filename\" \"$fname-VC$i.$ext\"
echo \"$dirname/$fname-VC$i.$ext\""

	set theNewImage to do shell script theBashScript

	if not isSession then
		-- import the file and select it
		tell the (current document)
			import source theNewImage
			delay 2
			set theDest to (item 1 of variants)
		end tell
	else
		delay 2
		repeat with theVariant in (every variant of current document)
			set theVariantPath to path of ((parent image) of theVariant)
			if theVariantPath is theNewImage then
				set theDest to theVariant
				exit repeat
			end if
		end repeat
	end if

	-- apply adjustments
	select variant theDest
	apply adjustments theDest

	-- copy metadata
	set (crop of theDest) to (crop of theSource)
	set (color tag of theDest) to (color tag of theSource)
	set (rating of theDest) to (rating of theSource)
	set (contact address of theDest) to (contact address of theSource)
	set (contact city of theDest) to (contact city of theSource)
	set (contact country of theDest) to (contact country of theSource)
	set (contact creator of theDest) to (contact creator of theSource)
	set (contact creator job title of theDest) to (contact creator job title of theSource)
	set (contact email of theDest) to (contact email of theSource)
	set (contact phone of theDest) to (contact phone of theSource)
	set (contact postal code of theDest) to (contact postal code of theSource)
	set (contact state of theDest) to (contact state of theSource)
	set (contact website of theDest) to (contact website of theSource)
	set (content category of theDest) to (content category of theSource)
	set (content description of theDest) to (content description of theSource)
	set (content description writer of theDest) to (content description writer of theSource)
	set (content headline of theDest) to (content headline of theSource)
	set (content subject codes of theDest) to (content subject codes of theSource)
	set (content supplemental categories of theDest) to (content supplemental categories of theSource)
	set (Getty original filename of theDest) to (Getty original filename of theSource)
	set (Getty parent MEID of theDest) to (Getty parent MEID of theSource)
	set (Getty personalities of theDest) to (Getty personalities of theSource)
	set (image city of theDest) to (image city of theSource)
	set (image country of theDest) to (image country of theSource)
	set (image country code of theDest) to (image country code of theSource)
	set (image intellectual genre of theDest) to (image intellectual genre of theSource)
	set (image location of theDest) to (image location of theSource)
	set (image scenes of theDest) to (image scenes of theSource)
	set (image state of theDest) to (image state of theSource)
	set (status copyright notice of theDest) to (status copyright notice of theSource)
	set (status instructions of theDest) to (status instructions of theSource)
	set (status job identifier of theDest) to (status job identifier of theSource)
	set (status provider of theDest) to (status provider of theSource)
	set (status rights usage terms of theDest) to (status rights usage terms of theSource)
	set (status source of theDest) to (status source of theSource)
	set (status title of theDest) to (status title of theSource)

	-- copy LCC and Lens Correction
	set (lens correction of theDest) to (lens correction of theSource)
	set (LCC color cast of theDest) to (LCC color cast of theSource)
	set (LCC dust removal of theDest) to (LCC dust removal of theSource)
	set (LCC uniform light of theDest) to (LCC uniform light of theSource)
	set (LCC uniform light amount of theDest) to (LCC uniform light amount of theSource)

	-- copy keywords
	repeat with theKeyword in (keywords of theSource)
		theKeyword apply keyword to variants
	end repeat
end tell
