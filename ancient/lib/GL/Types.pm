package GL::Types;
use v5.42;
use strictures 2;
use const;
use object;
use File::Spec ();
use UUID       qw( parse uuid0 uuid4 );

our $VERSION   = '0.0.1';
our $AUTHORITY = 'cpan:bclawsie';

our $ROLE_TEST          = const::c(1);
our $ROLE_NORMAL        = const::c(2);
our $ROLE_ADMIN         = const::c(3);
our $STATUS_UNCONFIRMED = const::c(1);
our $STATUS_ACTIVE      = const::c(2);
our $STATUS_INACTIVE    = const::c(3);

object::register_type('DB', sub ($v) { $v isa 'DBIx::Connector' });

object::register_type('Key', sub ($v) { $v =~ m/^[\da-fA-F]{32}$/x });

object::register_type(
  'Role',
  sub ($v) {
    $ROLE_TEST == $v || $ROLE_NORMAL == $v || $ROLE_ADMIN == $v;
  }
);

object::register_type(
  'Status',
  sub ($v) {
    $STATUS_UNCONFIRMED == $v || $STATUS_ACTIVE == $v || $STATUS_INACTIVE == $v;
  }
);

object::register_type('Uuid', sub ($v) { my $bin; parse($v, $bin) == 0 });

object::register_type('UnixTime', sub ($v) { int($v) > 176_875_351_8 });

object::define(
  'GL::Meta',
  'ctime:UnixTime:readonly:default(0)',
  'id:Uuid:required:readonly',
  'mtime:UnixTime:default(0)',
  'role:Role:readonly:default(' . $ROLE_TEST . ')',
  'signature:Uuid:default(\'' . uuid0 . '\')',
  'status:Status:default(' . $STATUS_ACTIVE . ')',
);

object::define(
  'GL::Runtime',
  'api_version:Str:readonly:default(\'v0\')',
  'db:DB:required',
  'default_role:Role:readonly:default(' . $ROLE_TEST . ')',
  'get_key:CodeRef:required:readonly',
  'encryption_key_version:Uuid:required:readonly',
  'mode:readonly:default(\'test\')',
  'repository_base:Str:readonly:default(\'' . File::Spec->tmpdir . '\')',
  'signing_key:Uuid:default(\'' . uuid4 . '\')',
);

object::define('GL::Crypt::Key', 'value:Key:required:readonly');

__END__
