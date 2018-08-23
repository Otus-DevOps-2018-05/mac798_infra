#!/usr/bin/perl
use JSON;
my %output_data = ( all => {children =>["app", "db", "ungrouped"]}, app => [], db => [], ungrouped =>[], _meta =>  {hostvars => {}} );

my @lines = split( /[\r\n]+/, `gcloud compute instances list` );
my $header = shift @lines;
my @fields = split /\s+/, $header;

my $pos = 0;
my %offsets = ();

foreach my $field (@fields) {
    my $newpos = index $header, $field, $pos;
    $offsets{$field} = $newpos;
}

foreach my $record (@lines) {
    my %splittedRecord = ();
    foreach my $field (@fields) {
        my $sub = substr $record, $offsets{$field};
        my($val) = ( $sub =~ m/(\S*)(\s+|$)/);
        $splittedRecord{$field} = $val;
    }
  $name = $splittedRecord{NAME};;
  if ($name =~ m/-app/) {
    push @{$output_data{app}}, $name;
  } elsif ($name =~ m/-db/) {
    push @{$output_data{db}}, $name;
  } else {
    push @{$output_data{ungrouped}}, $name;
  }
  %{$output_data{_meta}{hostvars}{$name}} =
    (
      ansible_host => $splittedRecord{EXTERNAL_IP},
      internal_ip => $splittedRecord{INTERNAL_IP},
      zone => $splittedRecord{ZONE},
      mtype => $splittedRecord{MACHINE_TYPE}
    );
}

print JSON->new->utf8->pretty->encode(\%output_data),"\n";
