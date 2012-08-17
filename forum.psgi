use strict;
use warnings;

use Forum;

my $app = Forum->apply_default_middlewares(Forum->psgi_app);
$app;

