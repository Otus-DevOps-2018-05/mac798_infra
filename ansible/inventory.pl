#!/usr/bin/perl
use JSON;
my %output_data = ( all => {children =>["app", "db", "ungrouped"]}, app => [], db => [], ungrouped =>[], _meta =>  {hostvars => {}} );

my @lines = split( /[\r\n]+/, `gcloud compute instances list` );
 shift @lines;
 
foreach my $record (@lines) {
  my @fields = split /\s+/, $record;
  $name = $fields[0];
  $ext_ip = $fields[$#fields-1];
  if ($name =~ m/-app/) {
    push @{$output_data{app}}, $name;
  } elsif ($name =~ m/-db/) {
    push @{$output_data{db}}, $name;
  } else {
    push @{$output_data{ungrouped}}, $name;
  }
  %{$output_data{_meta}{hostvars}{$name}} = ( ansible_host => $ext_ip );
}

print JSON->new->utf8->pretty->encode(\%output_data),"\n";
