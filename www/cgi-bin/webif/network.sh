#!/usr/bin/webif-page
<?

tools=/www/cgi-bin/webif/tools

. /usr/lib/webif/webif.sh
. $tools/functions.sh

#

if [ "$FORM_store" != "" -o "$FORM_apply" != "" ] ; then

	uci_load network

	for interface in `config_foreach echo` ; do

		name="FORM_${interface}_type"
		value=${!name}
		uci_set "network" "${interface}" "type" "$value"

		name="FORM_${interface}_auto"
		value=${!name}
		uci_set "network" "${interface}" "auto" "$value"

		name="FORM_${interface}_ipaddr"
		value=${!name}
		validate "ip||||$value"
		if [ "$?" == "0" ] ; then
			uci_set "network" "${interface}" "ipaddr" "$value"
		fi

		name="FORM_${interface}_netmask"
		value=${!name}
		validate "netmask||||$value"
		if [ "$?" == "0" ] ; then
			uci_set "network" "${interface}" "netmask" "$value"
		fi

	done

	uci_commit network

	if [ "$FORM_apply" != "" ] ; then
		#/etc/init.d/lanc-net restart 1>&2
		echo "TODO"
	fi
fi

#

uci_load network

for interface in `config_foreach echo` ; do
	config_get auto $interface auto
	config_get type $interface type
	config_get ipaddr $interface ipaddr
	config_get netmask $interface netmask

	network_options="start_form|$interface @TR<<configuration>>
	field|@TR<<Connection Type>>
	select|${interface}_type|$type
	option|disabled|@TR<<Disabled>>
	option|static|@TR<<Static IP>>
	option|dhcp|@TR<<DHCP>>
	helpitem|Connection Type
	helptext|Helptext Connection Type#Static IP: IP address of the interface is statically set. DHCP: The interface will fetch its IP address from a dhcp server.
	field|Autostart|field_${interface}_autostart|hidden
	checkbox|${interface}_auto|$auto|1
	helpitem|Autostart
	helptext|Helptext Autostart#Configure and start interface on system startup.
	end_form

	start_form||${interface}_ip_settings|hidden
	field|@TR<<IP Address>>|field_${interface}_ipaddr|hidden
	text|${interface}_ipaddr|$ipaddr
	field|@TR<<Netmask>>|field_${interface}_netmask|hidden
	text|${interface}_netmask|$netmask
	helpitem|IP Settings
	helptext|Helptext IP Settings#Basic IP settings for available interfaces. For routing see 'Routes' tab.
	end_form"

	append forms "$network_options" "$N"

	###################################################################
	# set JavaScript
	javascript_forms="
		v = (isset('${interface}_type', 'static'));
		w = (isset('${interface}_type', 'dhcp'));
		set_visible('field_${interface}_autostart', v || w);
		set_visible('${interface}_ip_settings', v);
		set_visible('field_${interface}_ipaddr', v);
		set_visible('field_${interface}_netmask', v);"

	append js "$javascript_forms" "$N"

done

header "Network" "Interfaces" "@TR<<Network Configuration>>" ' onload="modechange()" ' "$SCRIPT_NAME"
#####################################################################
# modechange script
#
cat <<EOF
<script type="text/javascript" src="/webif.js"></script>
<script type="text/javascript">
<!--
function modechange()
{
	var v;
	$js

	hide('save');
	show('save');
}
-->
</script>

EOF

display_form <<EOF
onchange|modechange
$forms
start_form|Store/apply configuration
submit|store|Store
submit|apply|Store and apply
end_form
EOF

footer ?>

<!--
##WEBIF:name:Network:101:Interfaces
-->
