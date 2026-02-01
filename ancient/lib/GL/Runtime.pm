package GL::Runtime;
use v5.42;
use strictures 2;
use file;
use Carp            qw( croak );
use DBIx::Connector ();
use UUID            qw( uuid4 );

use GL::Types      ();
use GL::Crypt::Key ();

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

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

my $db_with = sub ($dbi) {
  my $dbh_pragmas = [
    'PRAGMA foreign_keys = OFF;',
    'PRAGMA journal_mode = WAL;',
    'PRAGMA synchronous = NORMAL',
  ];
  my $conn = DBIx::Connector->new(@{$dbi});
  $conn->mode('ping');
  my $dbh = $conn->dbh;
  for my $pragma (@{$dbh_pragmas}) {
    $dbh->do($pragma) || croak $!;
  }
  return $conn;
};

my $test_get_key = sub ($encryption_key_version) {
  my $m = {
    $encryption_key_version => GL::Crypt::Key->new(GL::Crypt::Key::rand),
    uuid4                   => GL::Crypt::Key->new(GL::Crypt::Key::rand),
    uuid4                   => GL::Crypt::Key->new(GL::Crypt::Key::rand),
  };
  return sub ($version) {
    return $m->{$version} // croak 'bad key_version';
  }
};

sub for_test {
  my $encryption_key_version = uuid4;
  return db                => $db_with->($dbi_with->(':memory:')),
    encryption_key_version => $encryption_key_version,
    get_key                => $test_get_key->($encryption_key_version);
}

sub for_development {
  my $encryption_key_version = uuid4;
  my $db_file                = $ENV{DB_FILE} || croak 'DB_FILE not set';
  return db                => $db_with->($dbi_with->($db_file)),
    encryption_key_version => $encryption_key_version,
    get_key                => $test_get_key->($encryption_key_version),
    mode                   => 'development';
}

sub build ($self) {
  if ($self->mode eq 'test') {
    my $schema_file = $ENV{SCHEMA}              || croak 'SCHEMA not set';
    my $schema      = file::slurp($schema_file) || croak $!;
    $self->db->txn(fixup => sub ($dbh) { $dbh->do($schema) });
  }
  elsif ($self->mode eq 'development') {
    my $db_file = $ENV{DB_FILE} || croak 'DB_FILE not set';
    if (-f $db_file) {
      my @tables = $self->db->dbh->tables;
      croak 'development db tables' if scalar @tables == 0;
    }
    else {
      my $db_dir = file::dirname($db_file);
      unless (-d $db_dir) {
        mkdir $db_dir || croak $!;
      }
      my $schema_file = $ENV{SCHEMA}              || croak 'SCHEMA not set';
      my $schema      = file::slurp($schema_file) || croak $!;
      $self->db->txn(fixup => sub ($dbh) { $dbh->do($schema) });
    }
  }
  else {
    croak 'unknown mode';
  }

  return $self;
}

__END__
