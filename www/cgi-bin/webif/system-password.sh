#!/usr/bin/webif-page
<? 
. /usr/lib/webif/webif.sh

HTTPD_CONF=/etc/httpd.conf

if ! empty "$FORM_submit" ; then
	SAVED=1
	validate <<EOF
string|FORM_pw1|@TR<<Password>>|required min=5|$FORM_pw1
EOF
	equal "$FORM_pw1" "$FORM_pw2" || {
		[ -n "$ERROR" ] && ERROR="${ERROR}<br />"
		ERROR="${ERROR}@TR<<Passwords do not match>><br />"
	}
	
fi

header "System" "Password" "@TR<<Password>>" '' "$SCRIPT_NAME"

if [ "$SAVED" == "1" -a "$ERROR" == "" ] ; then

    case "$REMOTE_USER" in
        admin)
            sed  -e "s|$rootdir/:$FORM_account:.*$|$rootdir/:$FORM_account:$FORM_pw1|" -i $HTTPD_CONF
            ;;
        *)
            ERROR="${ERROR}You can't change password for remote user $REMOTE_USER<br/>"
            ;;
    esac
fi

display_form <<EOF
start_form|@TR<<Password Change>>
field|@TR<<Account>>:
text|account|$REMOTE_USER
field|@TR<<New Password>>:
password|pw1
field|@TR<<Confirm Password>>:
password|pw2
submit|submit|Change password
end_form
EOF

footer ?>

<!--
##WEBIF:name:System:250:Password
-->
