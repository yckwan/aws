echo "AZ, ID, Name, PrivateIP, Profile, PublicIP, State, Type" >> ./ec2list.csv

for profile in `aws configure list-profiles --output text`
    do
        echo -e "\n***$profile***"
        for region in `aws ec2 describe-regions --profile $profile --output text | cut -f4`
            do
                echo -e "\nListing Instances in region:'$region'..."
                aws ec2 describe-instances --query "Reservations[*].Instances[*].{PublicIP:PublicIpAddress,ID:InstanceId,Type:InstanceType,State:State.Name,AZ:Placement.AvailabilityZone,PrivateIP:PrivateIpAddress,Profile:NetworkInterfaces[0].OwnerId,Name:Tags[0].Value}" --region $region --profile $profile | sed -E 's/,//g ;s/	/,/g' >> ./ec2list.csv
    done
done