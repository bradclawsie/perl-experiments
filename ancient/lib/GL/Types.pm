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

object::register_type('SHA256Hex', sub ($v) { $v =~ m/^[\da-f]{64}$/x });

object::register_type('Key', sub ($v) { $v =~ m/^[\da-fA-F]{32}$/x });

object::register_type('NonEmptyStr', sub ($v) { $v =~ m/^\S+$/x });

object::register_type('GL_Meta', sub ($v) { $v isa 'GL::Meta' });

object::register_type('GL_Crypt_Password',
  sub ($v) { $v isa 'GL::Crypt::Password' });

object::register_type('Password', sub ($v) { $v =~ m/\$argon2/x });

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

object::define('GL::Crypt::Key', 'value:Key:required:readonly');

object::define(
  'GL::Meta',
  'ctime:UnixTime:default(0)',
  'mtime:UnixTime:default(0)',
  'role:Role:readonly:default(' . $ROLE_TEST . ')',
  'signature:Uuid:default(\'' . uuid0 . '\')',
  'status:Status:default(' . $STATUS_ACTIVE . ')',
);

object::define(
  'GL::Org',
  'id:Uuid:required:readonly',
  'meta:GL_Meta:default(undef)',
  'name:NonEmptyStr:required:readonly',
  'owner:Uuid:default(\'' . uuid0 . '\')',
);

object::define('GL::Crypt::Password', 'value:Password:required:readonly');

object::define(
  'GL::Runtime',
  'api_version:Str:readonly:default(\'v0\')',
  'db:DB:required:readonly',
  'default_role:Role:readonly:default(' . $ROLE_TEST . ')',
  'get_key:CodeRef:required:readonly',
  'encryption_key_version:Uuid:required:readonly',
  'mode:readonly:default(\'test\')',
  'repository_base:Str:readonly:default(\'' . File::Spec->tmpdir . '\')',
  'signing_key:Uuid:default(\'' . uuid4 . '\')',
);

object::define(
  'GL::User',
  'display_name:NonEmptyStr:required',
  'display_name_digest:SHA256Hex:default(undef)',
  'ed25519_private:Str:default(undef)',
  'ed25519_public:Str:default(undef)',
  'ed25519_public_digest:SHA256Hex:default(undef)',
  'email:NonEmptyStr:required',
  'email_digest:SHA256Hex:default(undef)',
  'id:Uuid:required:readonly',
  'key_version:Uuid:default(undef)',
  'meta:Meta:default(undef)',
  'org:Uuid:default(\'' . uuid0 . '\')',
  'password:GL_Crypt_Password:default(undef)',
);

__END__
