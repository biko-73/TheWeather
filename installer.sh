#!/bin/sh
##############################################################################################################
##
## Command: wget https://raw.githubusercontent.com/biko-73/TheWeather/main/installer.sh -O - | /bin/sh
##
##############################################################################################################

MY_IPK_PY2="enigma2-plugin-extensions-theweather-py2_2.3_all.ipk"
MY_IPK_PY3="enigma2-plugin-extensions-theweather-py2-py3_2.4_r2_all.ipk"

MY_DEB_PY2="enigma2-plugin-extensions-theweather-v2.3-py2.deb"
MY_DEB_PY3=""

PACKAGE_DIR='TheWeather/main'

MY_MAIN_URL="https://raw.githubusercontent.com/biko-73/"

PYTHON_VERSION=$(python -c 'import sys; print(sys.version_info[0])')

if which dpkg > /dev/null 2>&1; then
	if [ "$PYTHON_VERSION" -eq "2" ]; then
		MY_FILE=$MY_DEB_PY2
	else
		MY_FILE=$MY_DEB_PY3
	fi;
else
	if [ "$PYTHON_VERSION" -eq "2" ]; then
		MY_FILE=$MY_IPK_PY2
	else
		MY_FILE=$MY_IPK_PY3
	fi;
fi

if [ -z "$MY_FILE" ]; then
	echo ''
	echo '************************************************************'
	echo '**          NO SUITBLE VERSION FOUND ON SERVER            **'
	echo '************************************************************'
	echo ''
	exit 0
fi

MY_URL=$MY_MAIN_URL$PACKAGE_DIR'/'$MY_FILE
MY_TMP_FILE="/tmp/"$MY_FILE

echo ''
echo '************************************************************'
echo '**                         STARTED                        **'
echo '************************************************************'
echo "**                 Uploaded by: Biko_73                   **"
echo "**  https://www.tunisia-sat.com/forums/threads/4257963/   **"
echo "************************************************************"
echo ''

rm -f $MY_TMP_FILE > /dev/null 2>&1

MY_SEP='============================================================='
echo $MY_SEP
echo 'Downloading '$MY_FILE' ...'
echo $MY_SEP
echo ''
wget -T 2 $MY_URL -P "/tmp/"

if [ -f $MY_TMP_FILE ]; then

	echo ''
	echo $MY_SEP
	echo 'Installation started'
	echo $MY_SEP
	echo ''
	if which dpkg > /dev/null 2>&1; then
		apt-get install --reinstall $MY_TMP_FILE -y
	else
		opkg install --force-reinstall $MY_TMP_FILE
	fi
	MY_RESULT=$?

	rm -f $MY_TMP_FILE > /dev/null 2>&1

	echo ''
	echo ''
	if [ $MY_RESULT -eq 0 ]; then
		echo "   >>>>   SUCCESSFULLY INSTALLED   <<<<"
		echo ''
		echo "   >>>>         RESTARING         <<<<"
		if which systemctl > /dev/null 2>&1; then
			sleep 2; systemctl restart enigma2
		else
			init 4; sleep 4; init 3;
		fi
	else
		echo "   >>>>   INSTALLATION FAILED !   <<<<"
	fi;
	echo ''
	echo '**************************************************'
	echo '**                   FINISHED                   **'
	echo '**************************************************'
	echo ''
	exit 0
else
	echo ''
	echo "Download failed !"
	exit 1
fi
