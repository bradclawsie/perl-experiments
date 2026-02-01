package GL::Runtime;
use v5.42;
use strictures 2;
use const;
use Carp qw( croak );
use UUID qw( uuid4 );

my $dbi_with = sub ($db) {
  return [
    'dbi:SQLite:dbname=' . $db,
    q{}, q{},
    {
      RaiseError                       => 1,
      PrintError                       => 0,
      AutoCommit                       => 1,
      sqlite_unicode                   => 1,
      sqlite_allow_multiple_statements => 1,
    },
  ];
};

my $test_get_key = sub ($encryption_key_version) {
  my $m = {
    $encryption_key_version => uuid4,
    uuid4 => uuid4,
    uuid4 => uuid4,
  };
  return sub ($version) {
    return $m->{$version} // croak 'bad key_version';
  }
};

sub for_test {
  my $encryption_key_version = uuid4;
  return 
    dbi => $dbi_with->(':memory:'),
    encryption_key_version => $encryption_key_version,
    get_key => $test_get_key->($encryption_key_version);
};

__END__
