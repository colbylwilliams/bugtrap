#!/bin/bash

# c0lby:

source root_plist_utility.sh

##########################################################
##############  Create New Root.plist file  ##############
##########################################################


PreparePreferenceFile

	# AddNewPreferenceGroup 	-t "About"

		AddNewTitleValuePreference  -k "VersionNumber" 	-d "${versionNumber}" 	-t "Version"

		AddNewTitleValuePreference  -k "BuildNumber" 	-d "${buildNumber}" 	-t "Build"


	AddNewPreferenceGroup 	-t "Diagnostics Key"
		AddNewStringNode 	-e "FooterText" 	-v "${copyright}"


	AddNewTitleValuePreference  -k "UserReferenceKey" 	-d ""  	-t ""