if [ -d "/usr/local/lib/tfenv/versions" ]; then
	echo "Detected old tfenv paths. Moving..."
	mv /usr/local/lib/tfenv/version{,s} /var/lib/tfenv/
	rm -r /usr/local/lib/tfenv
fi
if [ -d "/usr/lib/tfenv/versions" ]; then
	echo "Detected old tfenv paths. Moving..."
	mv /usr/lib/tfenv/version{,s} /var/lib/tfenv/
	rm -r /usr/lib/tfenv/version{,s}
fi

if ! getent group tfenv >/dev/null ; then
	echo "Adding group 'tfenv'"
	groupadd tfenv
fi
mkdir -p "/var/lib/tfenv/versions"
touch "/var/lib/tfenv/version"
chgrp -R tfenv "/var/lib/tfenv/versions" "/var/lib/tfenv/version"
chmod -R 775 "/var/lib/tfenv/versions" "/var/lib/tfenv/version"
echo '######################################'
echo '# In order to be able to install and change terraform versions as a non-root user, please add it to the group tfenv'
echo '#   sudo usermod -aG tfenv ${USER}'
echo '######################################'
