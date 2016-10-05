#!/bin/bash
echo "Hostname: '$Hostname'"
echo "Email: '$Email'"
echo "OrganizationName: '$OrganizationName'"
echo "OrganizationalUnitName: '$OrganizationalUnitName'"
echo "LocalityName: '$LocalityName'"
echo "Country: '$Country'"

python df_redis_owner_update.py example.com test@example.com testOrg unit company UA
#$Hostname $Email $OrganizationName $OrganizationalUnitName $LocalityName $Country


