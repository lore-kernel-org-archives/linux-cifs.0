From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Use mask of ACEs for SID Everyone to calculate
 all three permissions user, group, and other
Date: Wed, 5 Jan 2011 07:19:16 -0500
Message-ID: <20110105071916.386336a2@tlielax.poochiereds.net>
References: <1291669006-12102-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110104141130.2cec2a74@tlielax.poochiereds.net>
	<AANLkTikhkFnU0B+0JbUXwZvOfVdY_XB67oEaiyaajT0H@mail.gmail.com>
	<20110104143122.46627c31@tlielax.poochiereds.net>
	<AANLkTimT4AKX0HYCMcZiMXvXV-N0r23yGQ+oU=CDdi-w@mail.gmail.com>
	<20110104150934.3ba10652@tlielax.poochiereds.net>
	<AANLkTimoA4ZZuqtKGFEMgDs7No-LRxfV3MN_P6tYL1u6@mail.gmail.com>
	<20110104171045.55cf3fd2@tlielax.poochiereds.net>
	<AANLkTik2_e7+-ZQqxMHWi5x0Sk99Z_EMY=fRWX=oB9un@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTik2_e7+-ZQqxMHWi5x0Sk99Z_EMY=fRWX=oB9un-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 4 Jan 2011 16:19:26 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Jan 4, 2011 at 4:10 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Tue, 4 Jan 2011 14:27:45 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Tue, Jan 4, 2011 at 2:09 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
> >> > On Tue, 4 Jan 2011 13:51:41 -0600
> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> On Tue, Jan 4, 2011 at 1:31 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org=
> wrote:
> >> >> > On Tue, 4 Jan 2011 13:20:38 -0600
> >> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >> >
> >> >> >> On Tue, Jan 4, 2011 at 1:11 PM, Jeff Layton <jlayton@redhat.=
com> wrote:
> >> >> >> > On Mon, =A06 Dec 2010 14:56:46 -0600
> >> >> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> >> >> >
> >> >> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> If a DACL has entries for ACEs for SID Everyone and Authe=
nticated Users,
> >> >> >> >> factor in mask in respective entries during calculation o=
f permissions
> >> >> >> >> for all three, user, group, and other.
> >> >> >> >>
> >> >> >> >> http://technet.microsoft.com/en-us/library/bb463216.aspx
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmai=
l.com>
> >> >> >> >> ---
> >> >> >> >> =A0fs/cifs/cifsacl.c | =A0 13 +++++++++++--
> >> >> >> >> =A01 files changed, 11 insertions(+), 2 deletions(-)
> >> >> >> >>
> >> >> >> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> >> >> >> index c6ebea0..a520091 100644
> >> >> >> >> --- a/fs/cifs/cifsacl.c
> >> >> >> >> +++ b/fs/cifs/cifsacl.c
> >> >> >> >> @@ -43,9 +43,12 @@ static struct cifs_wksid wksidarr[NUM_=
WK_SIDS] =3D {
> >> >> >> >> =A0;
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> -/* security id for everyone */
> >> >> >> >> +/* security id for everyone/world system group */
> >> >> >> >> =A0static const struct cifs_sid sid_everyone =3D {
> >> >> >> >> =A0 =A0 =A0 1, 1, {0, 0, 0, 0, 0, 1}, {0} };
> >> >> >> >> +/* security id for Authenticated Users system group */
> >> >> >> >> +static const struct cifs_sid sid_authusers =3D {
> >> >> >> >> + =A0 =A0 1, 1, {0, 0, 0, 0, 0, 5}, {11} };
> >> >> >> >> =A0/* group users */
> >> >> >> >> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, =
0, 0, 0, 0, 5}, {} };
> >> >> >> >>
> >> >> >> >> @@ -367,7 +370,7 @@ static void parse_dacl(struct cifs_ac=
l *pdacl, char *end_of_acl,
> >> >> >> >> =A0 =A0 =A0 if (num_aces =A0> 0) {
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 umode_t user_mask =3D S_IRWXU=
;
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 umode_t group_mask =3D S_IRWX=
G;
> >> >> >> >> - =A0 =A0 =A0 =A0 =A0 =A0 umode_t other_mask =3D S_IRWXO;
> >> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 umode_t other_mask =3D S_IRWXU =
| S_IRWXG | S_IRWXO;
> >> >> >> >>
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 ppace =3D kmalloc(num_aces * =
sizeof(struct cifs_ace *),
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 GFP_KERNEL);
> >> >> >> >> @@ -392,6 +395,12 @@ static void parse_dacl(struct cifs_a=
cl *pdacl, char *end_of_acl,
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&other_mask);
> >> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sid=
s(&(ppace[i]->sid), &sid_authusers))
> >> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 access_flags_to_mode(ppace[i]->access_req,
> >> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
> >> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
> >> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&other_mask);
> >> >> >> >> +
> >> >> >> >>
> >> >> >> >> =A0/* =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy((void *)=
(&(cifscred->aces[i])),
> >> >> >> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 (void *)ppace[i],
> >> >> >> >
> >> >> >> > This looks like a harmless change...
> >> >> >> >
> >> >> >> > =A0 =A0Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >> >> >
> >> >> >>
> >> >> >> Jeff, Thanks.
> >> >> >>
> >> >> >> > I have real doubts however about the owner/group parts of =
the cifsacl
> >> >> >> > scheme. It sets the user and group mode bits without setti=
ng the user
> >> >> >> > and group owners to meaningful values. So, those permissio=
ns have no
> >> >> >> > basis in reality.
> >> >> >>
> >> >> >> With the sid to uid and gid mapping code using winbind in th=
e works,
> >> >> >> would that address these concerns?
> >> >> >>
> >> >> >
> >> >> > Yes, that would help some.
> >> >> >
> >> >> > That would give you the ability to present permissions that h=
ave some
> >> >> > basis in reality. You'll still have to figure out what to do =
when you
> >> >> > get a SID that can't be mapped for some reason.
> >> >>
> >> >> If we are using winbind, I do not see how this can happen.
> >> >> A SID perhaps could not be looked up but winbind, when asked,
> >> >> can/will always map a Owner SID to an uid and Group SID to a gi=
d.
> >> >>
> >> >
> >> > Ahh ok. Good to know. Still, we need a meaningful owner to set i=
t to
> >> > when the upcall fails. For instance, if the upcall isn't set up =
at
> >> > all...
> >> >
> >>
> >> I think at least two things can go against, either upcall is not s=
etup at all
> >> so an upcall fails or we run out of idmap range as specified in sm=
b.conf
> >> file for either uid or gid or both and so upcall fails.
> >>
> >
> > Yep. The reason for the failure doesn't matter much. What matters i=
s
> > what you do if it does. You'll need to set the uid or gid to someth=
ing.
> >
> > What will you set it to?
> >
>=20
> I think it should default to 0 (superuser).
>=20

That sounds a little dangerous. What if the mode bits indicate setuid?

rpc.idmapd generally maps users to "nobody" if no mapping can be found.
Something like that might be a safer default. It should probably be a
tunable setting too.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
