use utf8;
package Forum::Schema::Result::Thread;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Forum::Schema::Result::Thread

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
use POSIX;
use Date::Parse;
use Date::Format;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<thread>

=cut

__PACKAGE__->table("thread");

=head1 ACCESSORS

=head2 thread_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 topic_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 thread_title

  data_type: 'text'
  is_nullable: 0

=head2 thread_created_date

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 topic_owner

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 status

  data_type: 'varchar'
  default_value: 'active'
  is_nullable: 1
  size: 16

=head2 thread_content

  data_type: 'longtext'
  is_nullable: 0

=head2 last_post_time

  data_type: 'timestamp'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 thread_image

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "thread_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "topic_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "thread_title",
  { data_type => "text", is_nullable => 0 },
  "thread_created_date",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "topic_owner",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "status",
  {
    data_type => "varchar",
    default_value => "active",
    is_nullable => 1,
    size => 16,
  },
  "thread_content",
  { data_type => "longtext", is_nullable => 0 },
  "last_post_time",
  {
    data_type => "timestamp",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "thread_image",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</thread_id>

=back

=cut

__PACKAGE__->set_primary_key("thread_id");

=head1 RELATIONS

=head2 posts

Type: has_many

Related object: L<Forum::Schema::Result::Post>

=cut

__PACKAGE__->has_many(
  "posts",
  "Forum::Schema::Result::Post",
  { "foreign.post_thread_id" => "self.thread_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 topic

Type: belongs_to

Related object: L<Forum::Schema::Result::Topic>

=cut

__PACKAGE__->belongs_to(
  "topic",
  "Forum::Schema::Result::Topic",
  { topic_id => "topic_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 topic_owner

Type: belongs_to

Related object: L<Forum::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "topic_owner",
  "Forum::Schema::Result::User",
  { user_id => "topic_owner" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07025 @ 2012-08-16 07:18:23
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:E73KPAdcl4gir+NqV0zgoQ

sub date_diff{
    my $dbTime = str2time( shift->get_column('last_post_time') );
    
    my $diff = time() - $dbTime;
}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
