use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Forum';
use Forum::Controller::showthread;

ok( request('/showthread')->is_success, 'Request should succeed' );
done_testing();
