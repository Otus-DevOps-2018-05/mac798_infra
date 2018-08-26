#!/usr/bin/perl
use JSON;
use Data::Dumper;

my %output_data = ( all => {children =>["app", "db", "ungrouped"]}, app => [], db => [], ungrouped =>[], _meta =>  {hostvars => {}} );


$gce_json = `gcloud compute instances list --format=json`;

$gce_data = decode_json($gce_json);

#print Dumper($gce_data);

foreach my $inst (@$gce_data) {
  my $name = $inst->{name};
  my $ext_ip = undef;

  foreach my $acfg (@{$inst->{networkInterfaces}[0]{accessConfigs}}) {
    if ($acfg->{type} eq 'ONE_TO_ONE_NAT'){
      $ext_ip = $acfg->{natIP};
      last;
    }
  }
  my $int_ip = $inst->{networkInterfaces}[0]{networkIP};
  my $group = "ungrouped";
  foreach my $instTag (@{$inst->{tags}{items}}) {
    if ($instTag =~ m/reddit.*-db/) {
      $group = 'db';
      last;
    } elsif ($instTag =~ m/reddit.*-app/) {
      $group = 'app';
      last;
    }
  }
  push @{$output_data{$group}}, $name;

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
