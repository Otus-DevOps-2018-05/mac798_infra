#!/usr/bin/perl
use JSON;
use Data::Dumper;

my %output_data = ( all => {children =>["app", "db", "ungrouped"]}, app => [], db => [], ungrouped =>[], _meta =>  {hostvars => {}} );


$gce_json = `gcloud compute instances list --format=json`;

$gce_data = decode_json($gce_json);

$destination_env = "stage";

@possible_env = ('prod','stage','development');

#print Dumper($gce_data);

foreach my $inst (@$gce_data) {
  my $name = $inst->{name};
  my $ext_ip = undef;
  if ($destination_env && ! grep( /^$destination_env$/, @{$inst->{tags}{items}})) {
    next;
  }

  foreach my $acfg (@{$inst->{networkInterfaces}[0]{accessConfigs}}) {
    if ($acfg->{type} eq 'ONE_TO_ONE_NAT'){
      $ext_ip = $acfg->{natIP};
      last;
    }
  }
  my $int_ip = $inst->{networkInterfaces}[0]{networkIP};
  my $add_to_ungroupped = 1;
  foreach my $dest_tag (@{$inst->{tags}{items}}) {
    if (grep( /$dest_tag/, @possible_env)) {
      next;
    }
    push @{$output_data{$dest_tag}}, $name;
    $add_to_ungroupped = 0;
  }
  if ($add_to_ungroupped) {
    push @{$output_data{ungrouped}}, $name;
  }

  my($mtype) = ($inst->{machineType} =~ m#/machineTypes/(.*)$#);
  my($zone) = ($inst->{zone} =~ m#/zones/(.*)$#);

  %{$output_data{_meta}{hostvars}{$name}} =
    (
      ansible_host => $ext_ip?$ext_ip:$int_ip,
      internal_ip => $int_ip,
      zone => $zone,
      mtype => $mtype
    );
}

print JSON->new->utf8->pretty->encode(\%output_data),"\n";
