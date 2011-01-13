From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Use mask of ACEs for SID Everyone to calculate all
 three permissions user, group, and other
Date: Thu, 13 Jan 2011 14:45:59 -0600
Message-ID: <AANLkTin6t6qoQe7weUkKwNHBPvXkSEbQ9-b16+5A_HpE@mail.gmail.com>
References: <1291669006-12102-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110104141130.2cec2a74@tlielax.poochiereds.net>
	<AANLkTikhkFnU0B+0JbUXwZvOfVdY_XB67oEaiyaajT0H@mail.gmail.com>
	<20110104143122.46627c31@tlielax.poochiereds.net>
	<AANLkTimT4AKX0HYCMcZiMXvXV-N0r23yGQ+oU=CDdi-w@mail.gmail.com>
	<20110104150934.3ba10652@tlielax.poochiereds.net>
	<AANLkTik38rcit3PJc1d0WU7+kS4a39UTaQ6TuRN+H_if@mail.gmail.com>
	<20110113104834.1583ec39@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110113104834.1583ec39-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Jan 13, 2011 at 9:48 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 13 Jan 2011 09:26:59 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Jan 4, 2011 at 2:09 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> > On Tue, 4 Jan 2011 13:51:41 -0600
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Tue, Jan 4, 2011 at 1:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> >> > On Tue, 4 Jan 2011 13:20:38 -0600
>> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >> >
>> >> >> On Tue, Jan 4, 2011 at 1:11 PM, Jeff Layton <jlayton-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org=
m> wrote:
>> >> >> > On Mon, =A06 Dec 2010 14:56:46 -0600
>> >> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >> >> >
>> >> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> >> >>
>> >> >> >>
>> >> >> >> If a DACL has entries for ACEs for SID Everyone and Authent=
icated Users,
>> >> >> >> factor in mask in respective entries during calculation of =
permissions
>> >> >> >> for all three, user, group, and other.
>> >> >> >>
>> >> >> >> http://technet.microsoft.com/en-us/library/bb463216.aspx
>> >> >> >>
>> >> >> >>
>> >> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.=
com>
>> >> >> >> ---
>> >> >> >> =A0fs/cifs/cifsacl.c | =A0 13 +++++++++++--
>> >> >> >> =A01 files changed, 11 insertions(+), 2 deletions(-)
>> >> >> >>
>> >> >> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> >> >> >> index c6ebea0..a520091 100644
>> >> >> >> --- a/fs/cifs/cifsacl.c
>> >> >> >> +++ b/fs/cifs/cifsacl.c
>> >> >> >> @@ -43,9 +43,12 @@ static struct cifs_wksid wksidarr[NUM_WK=
_SIDS] =3D {
>> >> >> >> =A0;
>> >> >> >>
>> >> >> >>
>> >> >> >> -/* security id for everyone */
>> >> >> >> +/* security id for everyone/world system group */
>> >> >> >> =A0static const struct cifs_sid sid_everyone =3D {
>> >> >> >> =A0 =A0 =A0 1, 1, {0, 0, 0, 0, 0, 1}, {0} };
>> >> >> >> +/* security id for Authenticated Users system group */
>> >> >> >> +static const struct cifs_sid sid_authusers =3D {
>> >> >> >> + =A0 =A0 1, 1, {0, 0, 0, 0, 0, 5}, {11} };
>> >> >> >> =A0/* group users */
>> >> >> >> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0,=
 0, 0, 0, 5}, {} };
>> >> >> >>
>> >> >> >> @@ -367,7 +370,7 @@ static void parse_dacl(struct cifs_acl =
*pdacl, char *end_of_acl,
>> >> >> >> =A0 =A0 =A0 if (num_aces =A0> 0) {
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 umode_t user_mask =3D S_IRWXU;
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 umode_t group_mask =3D S_IRWXG;
>> >> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 umode_t other_mask =3D S_IRWXO;
>> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 umode_t other_mask =3D S_IRWXU | =
S_IRWXG | S_IRWXO;
>> >> >> >>
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ppace =3D kmalloc(num_aces * si=
zeof(struct cifs_ace *),
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 GFP_KERNEL);
>> >> >> >> @@ -392,6 +395,12 @@ static void parse_dacl(struct cifs_acl=
 *pdacl, char *end_of_acl,
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&other_mask);
>> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(=
&(ppace[i]->sid), &sid_authusers))
>> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 a=
ccess_flags_to_mode(ppace[i]->access_req,
>> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&other_mask);
>> >> >> >> +
>> >> >> >>
>> >> >> >> =A0/* =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy((void *)(&=
(cifscred->aces[i])),
>> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 (void *)ppace[i],
>> >> >> >
>> >> >> > This looks like a harmless change...
>> >> >> >
>> >> >> > =A0 =A0Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >> >
>> >> >>
>> >> >> Jeff, Thanks.
>> >> >>
>> >> >> > I have real doubts however about the owner/group parts of th=
e cifsacl
>> >> >> > scheme. It sets the user and group mode bits without setting=
 the user
>> >> >> > and group owners to meaningful values. So, those permissions=
 have no
>> >> >> > basis in reality.
>> >> >>
>> >> >> With the sid to uid and gid mapping code using winbind in the =
works,
>> >> >> would that address these concerns?
>> >> >>
>> >> >
>> >> > Yes, that would help some.
>> >> >
>> >> > That would give you the ability to present permissions that hav=
e some
>> >> > basis in reality. You'll still have to figure out what to do wh=
en you
>> >> > get a SID that can't be mapped for some reason.
>> >>
>> >> If we are using winbind, I do not see how this can happen.
>> >> A SID perhaps could not be looked up but winbind, when asked,
>> >> can/will always map a Owner SID to an uid and Group SID to a gid.
>> >>
>> >
>> > Ahh ok. Good to know. Still, we need a meaningful owner to set it =
to
>> > when the upcall fails. For instance, if the upcall isn't set up at
>> > all...
>> >
>> >> >
>> >> > The real solution is to get rid of client-side permissions enfo=
rcement
>> >> > altogether. The server is the only place that they can be relia=
bly
>> >> > enforced.
>> >>
>> >> I can see when changing mode or group or owner for an object,
>> >> client should just be a conduit for that action (i.e. dispatch a
>> >> fabricated DACL) and server is the one that should decide to enfo=
rce
>> >> the change.
>> >
>> > Agreed.
>> >
>> >> But cifs client nonetheless needs to calculate and set mode and f=
ill in
>> >> uid and gid for an inode since none of these values (mode, uid, a=
nd gid)
>> >> exist at the equivalent object on the server.
>> >>
>> >
>> > Well, you need to have something to return in a stat() call. Those
>> > values do not necessarily have to be used to enforce permissions. =
Note
>> > the way that CIFS_MOUNT_NO_PERM is used.
>> >
>>
>> I think permission checking has to be done by the client.
>> What cifs/smb command can a client send to the server to verify
>> permissions?
>>
>
> There is no such call. How would you communicate to the server who
> the user actually *is* anyway? The only way to do this is to map user
> accesses to the appropriate credentials (aka multiuser mounts).
>
> I think it would be a good idea to step back and state exactly what
> you want to achieve with client-side permissions enforcement. The
> server is already going to enforce permissions according to the
> credentials used to access it.
>
> What exactly do you intend to protect with client-side enforcement?

Jeff, with client side permission checking/enforcment, as I understand,
we are checking for accesses (read, write, etc.). Is that correct or
is there more to that?

I think it easy when a user wants to either change owner or group or
mode of an object, client just needs to prepare a DACL and let
server decide the action.

With permission checking, since we can't forward such a request
to the server, a client has to act on that request.

The uid and gid of an object should be based on the DACL of the
file at the server, irrespective of the credentials of the session.
That way each session has a uniform view of the share.

If owner and group based in the DACL can't be mapped to a
uid and gid on the client, it should default to something like
nobody and nogroup.

If the owner can be mapped, then user permissions are calculated
as per ACE(s) in the DACL but if owner can't be mapped, they
should default to no permissions
Same applies to group permissions.
Other permissions should be calculated as per ACE(s) in the DACL.

Every uid/fsuid on the client is treated as an authenticated user (SID)
as far as that file object is considered.
So the permission checking for accesses for that uid/fsuid is as per
SID of the authenticated/credential'ed user of that SMB session.
If authenticated user's SID happens to be owner of the file object,
user permissions are checked, if it happens to be group (owner) of
the file object, group permissions are checked and if not,
other permissions are checked.

With multisession mounts, as per I understand, we would be
checking with respective session's authenticated user's SID
instead of a single SMB session's credential'ed SID (all the time).

>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
