package Forum::View::View;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    render_die => 1,
    ENCODING     => 'utf-8',
);

=head1 NAME

Forum::View::View - TT View for Forum

=head1 DESCRIPTION

TT View for Forum.

=head1 SEE ALSO

L<Forum>

=head1 AUTHOR

CentOS

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
