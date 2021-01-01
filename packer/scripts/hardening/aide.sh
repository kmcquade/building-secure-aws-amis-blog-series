#!/bin/sh
#####
# Lightly borrowed from: https://github.com/fcaviggia/hardened-centos7-kickstart/blob/master/config/hardening/hardened-centos.cfg#L318
# as well as the OpenSCAP remediation scripts
#
# 1. Initialize AIDE
# 2. Ensure Periodic execution of AIDE
# 3. Configure Weekly reports; notify root, and ensure proper permissions.
# 4. Configure AIDE to verify ACLs
# 5. Configure AIDE to Verify Extended Attributes
# 6. Configure AIDE to Use FIPS 140-2 for Validating Hashes

########################################
# AIDE Initialization
########################################
yum -y install aide
yum -y remove postfix
yum -y install sendmail

# AIDE Initialization
echo "Initializing AIDE database, this step may take quite a while!"
/usr/sbin/aide --init &> /dev/null

echo "AIDE database initialization complete."
cp /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

############ Periodic execution of AIDE

echo "05 4 * * * root /usr/sbin/aide --check" >> /etc/crontab

CRONTAB=/etc/crontab
CRONDIRS='/etc/cron.d /etc/cron.daily /etc/cron.weekly /etc/cron.monthly'

if [ -f /var/spool/cron/root ]; then
	VARSPOOL=/var/spool/cron/root
fi

if ! grep -qR '^.*\/usr\/sbin\/aide\s*\-\-check.*\|.*\/bin\/mail\s*-s\s*".*"\s*root@.*$' $CRONTAB $VARSPOOL $CRONDIRS; then
	echo '0 5 * * * /usr/sbin/aide  --check | /bin/mail -s "$(hostname) - AIDE Integrity Check" root@localhost' >> $CRONTAB
fi

chown root:root /etc/cron.weekly/aide-report
chmod 555 /etc/cron.weekly/aide-report
mkdir -p /var/log/aide/reports
chmod 700 /var/log/aide/reports

############
# Title     Configure AIDE to Verify Access Control Lists (ACLs)
# Rule      aide_verify_acls
aide_conf="/etc/aide.conf"

groups=$(grep "^[A-Z]\+" $aide_conf | grep -v "^ALLXTRAHASHES" | cut -f1 -d '=' | tr -d ' ' | sort -u)

for group in $groups
do
	config=$(grep "^$group\s*=" $aide_conf | cut -f2 -d '=' | tr -d ' ')

	if ! [[ $config = *acl* ]]
	then
		if [[ -z $config ]]
		then
			config="acl"
		else
			config=$config"+acl"
		fi
	fi
	sed -i "s/^$group\s*=.*/$group = $config/g" $aide_conf
done


############
# Title: Configure AIDE to Verify Extended Attributes
# Rule: aide_verify_ext_attributes

aide_conf="/etc/aide.conf"

groups=$(grep "^[A-Z]\+" $aide_conf | grep -v "^ALLXTRAHASHES" | cut -f1 -d '=' | tr -d ' ' | sort -u)

for group in $groups
do
	config=$(grep "^$group\s*=" $aide_conf | cut -f2 -d '=' | tr -d ' ')

	if ! [[ $config = *xattrs* ]]
	then
		if [[ -z $config ]]
		then
			config="xattrs"
		else
			config=$config"+xattrs"
		fi
	fi
	sed -i "s/^$group\s*=.*/$group = $config/g" $aide_conf
done

#####
# Additional try to pass the FIPS 140-2 Hash Validation test
/usr/bin/sed -i -e 's/^FIPSR.*/FIPSR = p+i+n+u+g+s+m+c+acl+selinux+xattrs+sha256/' /etc/aide.conf
#/usr/bin/sed -i -e 's/^NORMAL.*/NORMAL = FIPSR+sha512/' /etc/aide.conf

############
# Title: Configure AIDE to Use FIPS 140-2 for Validating Hashes
# Rule: aide_use_fips_hashes

aide_conf="/etc/aide.conf"

forbidden_hashes=(sha1 rmd160 sha256 whirlpool tiger haval gost crc32)

groups=$(grep "^[A-Z]\+" $aide_conf | cut -f1 -d ' ' | tr -d ' ' | sort -u)

for group in $groups
do
	config=$(grep "^$group\s*=" $aide_conf | cut -f2 -d '=' | tr -d ' ')

	if ! [[ $config = *sha512* ]]
	then
		config=$config"+sha512"
	fi

	for hash in ${forbidden_hashes[@]}
	do
		config=$(echo $config | sed "s/$hash//")
	done

	config=$(echo $config | sed "s/^\+*//")
	config=$(echo $config | sed "s/\+\++/+/")
	config=$(echo $config | sed "s/\+$//")

	sed -i "s/^$group\s*=.*/$group = $config/g" $aide_conf
done

