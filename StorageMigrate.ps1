# set the VC server, cluster that you are migrating from and the Target Datastore name

$VirtualCentre = "VCServer"
$SourceCluster = "SourceCluster"
$TargetDS = "TargetDatastore"
$maxParallel = 3

# Connect to virtual center

connect-viserver $VirtualCentre

#Get a list of VMs in the cluster to migrate

$VMs= get-cluster -name $SourceCluster | get-vm

$vms=$VMs.name

#start the migration loop doing 1 VM at a time stoping if there is an error and emailing out

foreach ($vm in $VMs) 
{
move-vm -VM $VM -Datastore $TargetDS -DiskStorageFormat 'Thin' -RunAsync

    do

    {

        sleep 5

    } 
  
    while((Get-Task -Status Running | where{$_.Name -eq 'RelocateVM_Task'}).Count -gt $maxParallel)

}
