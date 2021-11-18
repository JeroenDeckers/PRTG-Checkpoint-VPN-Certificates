#! /bin/bash
echo "<prtg>"
gateways=($(cpca_client lscert -stat Valid -kind IKE | egrep 'Subject' | cut -d '=' -f 3 | cut -d ' ' -f 1))
for i in "${gateways[@]}"
do (
        echo "<result>"
        echo "<channel>"
        echo $i
        echo "</channel>"
        expiry_date=$(cpca_client search $i -stat Valid -kind IKE | grep Not_After | cut -d ':' -f 5,6,7)
        remaining_days=$((($(date +%s --date "$expiry_date")-$(date +%s))/(3600*24)))
        echo "<value>"
        echo $remaining_days
        echo "</value>"
        echo "<LimitMode>1</LimitMode>"
        echo "<LimitMinWarning>14</LimitMinWarning>"
        echo "<LimitMinError>7</LimitMinError>"
        echo "<CustomUnit>Days</CustomUnit>"
        echo "</result>"
)
done
echo "</prtg>"
