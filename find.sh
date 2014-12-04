find . -name project.pbxproj | awk '{print "echo " $1 "; grep Users " $1}' | bash

