use v5.42;
use strictures 2;
use English                 qw(-no_match_vars);
use Test2::V0               qw( done_testing is note ok subtest );
use Test2::Tools::Compare   qw( like );
use Test2::Tools::Exception qw( lives );
use UUID                    qw( uuid4 );

use GL::Runtime ();

subtest 'test db' => sub {
  my $rt = GL::Runtime->new(GL::Runtime::for_test)->build;

  ok(
    lives {
      is('test', $rt->mode);
      my $c = $rt->db->run(
        ping => sub {
          $_->selectrow_array('select count(*) from user');
        }
      );
      is(0, $c);
    },
  ) or note($EVAL_ERROR);

  done_testing;
};

subtest 'development db' => sub {
  my $rt = GL::Runtime->new(GL::Runtime::for_development)->build;

  ok(
    lives {
      is('development', $rt->mode);
      my $c = $rt->db->run(
        ping => sub {
          $_->selectrow_array('select count(*) from user');
        }
      );
    },
  ) or note($EVAL_ERROR);

  done_testing;
};

subtest 'get_key' => sub {
  my $rt = GL::Runtime->new(GL::Runtime::for_test)->build;

  ok(
    lives {
      ok($rt->get_key->($rt->encryption_key_version) isa 'GL::Crypt::Key');
    },
  ) or note($EVAL_ERROR);

  ok(
    lives {
      my $caught = false;
      try {
        $rt->get_key->(uuid4);
      }
      catch ($e) {
        like($e, qr/bad key_version/);
        $caught = true;
      }
      ok($caught);
    },
  ) or note($EVAL_ERROR);

  done_testing;
};

done_testing;

__END__
