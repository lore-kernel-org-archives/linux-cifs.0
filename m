From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Use mask of ACEs for SID Everyone to calculate all
 three permissions user, group, and other
Date: Tue, 4 Jan 2011 14:27:45 -0600
Message-ID: <AANLkTimoA4ZZuqtKGFEMgDs7No-LRxfV3MN_P6tYL1u6@mail.gmail.com>
References: <1291669006-12102-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110104141130.2cec2a74@tlielax.poochiereds.net>
	<AANLkTikhkFnU0B+0JbUXwZvOfVdY_XB67oEaiyaajT0H@mail.gmail.com>
	<20110104143122.46627c31@tlielax.poochiereds.net>
	<AANLkTimT4AKX0HYCMcZiMXvXV-N0r23yGQ+oU=CDdi-w@mail.gmail.com>
	<20110104150934.3ba10652@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110104150934.3ba10652-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 4, 2011 at 2:09 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 4 Jan 2011 13:51:41 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Jan 4, 2011 at 1:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>> > On Tue, 4 Jan 2011 13:20:38 -0600
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> >> On Tue, Jan 4, 2011 at 1:11 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
>> >> > On Mon, =A06 Dec 2010 14:56:46 -0600
>> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>> >> >
>> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >> >>
>> >> >>
>> >> >> If a DACL has entries for ACEs for SID Everyone and Authentica=
ted Users,
>> >> >> factor in mask in respective entries during calculation of per=
missions
>> >> >> for all three, user, group, and other.
>> >> >>
>> >> >> http://technet.microsoft.com/en-us/library/bb463216.aspx
>> >> >>
>> >> >>
>> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
>
>> >> >> ---
>> >> >> =A0fs/cifs/cifsacl.c | =A0 13 +++++++++++--
>> >> >> =A01 files changed, 11 insertions(+), 2 deletions(-)
>> >> >>
>> >> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> >> >> index c6ebea0..a520091 100644
>> >> >> --- a/fs/cifs/cifsacl.c
>> >> >> +++ b/fs/cifs/cifsacl.c
>> >> >> @@ -43,9 +43,12 @@ static struct cifs_wksid wksidarr[NUM_WK_SI=
DS] =3D {
>> >> >> =A0;
>> >> >>
>> >> >>
>> >> >> -/* security id for everyone */
>> >> >> +/* security id for everyone/world system group */
>> >> >> =A0static const struct cifs_sid sid_everyone =3D {
>> >> >> =A0 =A0 =A0 1, 1, {0, 0, 0, 0, 0, 1}, {0} };
>> >> >> +/* security id for Authenticated Users system group */
>> >> >> +static const struct cifs_sid sid_authusers =3D {
>> >> >> + =A0 =A0 1, 1, {0, 0, 0, 0, 0, 5}, {11} };
>> >> >> =A0/* group users */
>> >> >> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0,=
 0, 0, 5}, {} };
>> >> >>
>> >> >> @@ -367,7 +370,7 @@ static void parse_dacl(struct cifs_acl *pd=
acl, char *end_of_acl,
>> >> >> =A0 =A0 =A0 if (num_aces =A0> 0) {
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 umode_t user_mask =3D S_IRWXU;
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 umode_t group_mask =3D S_IRWXG;
>> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 umode_t other_mask =3D S_IRWXO;
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 umode_t other_mask =3D S_IRWXU | S_I=
RWXG | S_IRWXO;
>> >> >>
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ppace =3D kmalloc(num_aces * sizeo=
f(struct cifs_ace *),
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GF=
P_KERNEL);
>> >> >> @@ -392,6 +395,12 @@ static void parse_dacl(struct cifs_acl *p=
dacl, char *end_of_acl,
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&other_mask);
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(p=
pace[i]->sid), &sid_authusers))
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 acce=
ss_flags_to_mode(ppace[i]->access_req,
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&other_mask);
>> >> >> +
>> >> >>
>> >> >> =A0/* =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy((void *)(&(ci=
fscred->aces[i])),
>> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (v=
oid *)ppace[i],
>> >> >
>> >> > This looks like a harmless change...
>> >> >
>> >> > =A0 =A0Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >> >
>> >>
>> >> Jeff, Thanks.
>> >>
>> >> > I have real doubts however about the owner/group parts of the c=
ifsacl
>> >> > scheme. It sets the user and group mode bits without setting th=
e user
>> >> > and group owners to meaningful values. So, those permissions ha=
ve no
>> >> > basis in reality.
>> >>
>> >> With the sid to uid and gid mapping code using winbind in the wor=
ks,
>> >> would that address these concerns?
>> >>
>> >
>> > Yes, that would help some.
>> >
>> > That would give you the ability to present permissions that have s=
ome
>> > basis in reality. You'll still have to figure out what to do when =
you
>> > get a SID that can't be mapped for some reason.
>>
>> If we are using winbind, I do not see how this can happen.
>> A SID perhaps could not be looked up but winbind, when asked,
>> can/will always map a Owner SID to an uid and Group SID to a gid.
>>
>
> Ahh ok. Good to know. Still, we need a meaningful owner to set it to
> when the upcall fails. For instance, if the upcall isn't set up at
> all...
>

I think at least two things can go against, either upcall is not setup =
at all
so an upcall fails or we run out of idmap range as specified in smb.con=
f
file for either uid or gid or both and so upcall fails.

>> >
>> > The real solution is to get rid of client-side permissions enforce=
ment
>> > altogether. The server is the only place that they can be reliably
>> > enforced.
>>
>> I can see when changing mode or group or owner for an object,
>> client should just be a conduit for that action (i.e. dispatch a
>> fabricated DACL) and server is the one that should decide to enforce
>> the change.
>
> Agreed.
>
>> But cifs client nonetheless needs to calculate and set mode and fill=
 in
>> uid and gid for an inode since none of these values (mode, uid, and =
gid)
>> exist at the equivalent object on the server.
>>
>
> Well, you need to have something to return in a stat() call. Those
> values do not necessarily have to be used to enforce permissions. Not=
e
> the way that CIFS_MOUNT_NO_PERM is used.
>
>> I think we had this conversation before so I will dig it up, but I a=
m
>> trying to figure out how and where client enforces permissions
>> (which it should not) other than when mode or user or group ids are
>> being changed.
>>
>
> See cifs_permission which eventually calls generic_permission, which
> uses the i_mode/i_uid/i_gid to determine whether access is allowed.
>
> The problem though is that cifs mounts use a single set of credential=
s
> by default. Unless we make multiuser mounts the default, we're sort o=
f
> stuck with this broken model for legacy reasons.
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
