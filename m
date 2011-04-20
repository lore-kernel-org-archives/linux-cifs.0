From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #16)
Date: Wed, 20 Apr 2011 14:10:15 -0400
Message-ID: <20110420141015.5b65bb8e@tlielax.poochiereds.net>
References: <1303219269-31144-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110420130752.06d6397d@corrin.poochiereds.net>
	<BANLkTimyAx0YmYFuXPT0CdfdD4CYJDD7rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimyAx0YmYFuXPT0CdfdD4CYJDD7rw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 20 Apr 2011 12:27:31 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Apr 20, 2011 at 12:07 PM, Jeff Layton <jlayton-vpEMnDpepFvY2uhgrK1nQg@public.gmane.org=
t> wrote:
> > On Tue, 19 Apr 2011 08:21:09 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> rb tree search and insertion routines.
> >>
> >> A SID which needs to be mapped, is looked up in one of the rb tree=
s
> >> depending whether SID is either owner or group SID.
> >> If found in the tree, a (mapped) id from that node is assigned to
> >> uid or gid as appropriate. =C2=A0If unmapped, an upcall is attempt=
ed to
> >> map the SID to an id. =C2=A0If upcall is successful, node is marke=
d as
> >> mapped. =C2=A0If upcall fails, node stays marked as unmapped and a=
 mapping
> >> is attempted again only after an arbitrary time period has passed.
> >>
> >> To map a SID, which can be either a Owner SID or a Group SID, key
> >> description starts with the string "os" or "gs" followed by SID co=
nverted
> >> to a string. Without "os" or "gs", cifs.upcall does not know wheth=
er
> >> SID needs to be mapped to either an uid or a gid.
> >>
> >> Nodes in rb tree have fields to prevent multiple upcalls for
> >> a SID. =C2=A0Adding and removing nodes is done within global locks=
=2E
> >> Shrinker routine prunes a node if it has expired but does not prne
> >> an expired node if its refcount is not zero (i.e. sid of that node
> >> is being mapped via an upcall).
> >> Every time an existing node is accessed, its timestamp is updated
> >> to prevent it from getting erased.
> >>
> >> For now, cifs.upcall is only used to map a SID to an id (uid or gi=
d) but
> >> it would be used to obtain an SID for an id.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsacl.c | =C2=A0332 ++++++++++++++++++++++++++++++=
+++++++++++++++++++----
> >> =C2=A0fs/cifs/cifsacl.h | =C2=A0 25 ++++
> >> =C2=A02 files changed, 333 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> index cad8d9b..bbc29b8 100644
> >> --- a/fs/cifs/cifsacl.c
> >> +++ b/fs/cifs/cifsacl.c
> >
> > [...]
> >
> >> + =C2=A0 =C2=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0* Shrinker could be accessing this entry but=
 it will not
> >> + =C2=A0 =C2=A0 =C2=A0* get erased at this point in time and to ma=
ke it stay further,
> >> + =C2=A0 =C2=A0 =C2=A0* pretty soon we will take a reference on it=
 only to
> >> + =C2=A0 =C2=A0 =C2=A0* release the reference only after upcall re=
turns (or we are
> >> + =C2=A0 =C2=A0 =C2=A0* woken up), however longer that upcall may =
take to return.
> >> + =C2=A0 =C2=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 if (!test_and_set_bit(SID_ID_PENDING, &psidid->sta=
te)) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* paidid and its fiel=
ds are being accessed sans spinlock */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ++psidid->refcount;
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Huh? You're =
incrementing and decrementing the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0refcount wit=
hout any locking at all? What prevents the
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0shrinker fro=
m finding the entry just before you bump
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0the refcount=
 and wiping it out anyway?
> >
>=20
> Becaue we just updated the timestamp so shrinker will not evict the
> entry at least for the duration of  SID_MAP_EXPIRE.
> The refcount is to account for an lenghty upcall.
>=20

Making assumptions on timing like this is a recipe for difficult to
find bugs.

Why not increment the refcount as soon as you find the entry? Who's to
say that there won't be delays that prevent the increment from
happening before 1s is gone. That sort of thing can happen in a
preemptable kernel once you're outside of critical sections.

I think you need some clear locking rules around this refcount, and
ensure that there's never a window where the shrinker could delete the
object while it's still in use.

> >> +struct cifs_sid_id {
> >> + =C2=A0 =C2=A0 unsigned int refcount;
> >> + =C2=A0 =C2=A0 unsigned long id;
> >> + =C2=A0 =C2=A0 unsigned long time;
> >> + =C2=A0 =C2=A0 unsigned long retry;
> >
> > Why, exactly do we need "time" and "retry"? Wouldn't one timestamp
> > field do here?
> >
>=20
> One timestamp is to make an entry eligible for eviction and the other
> one is to attempt mapping again if previous attempt to map a sid had
> failed.
>=20

I think these can be condensed into one. The retry timestamp will be
unused once the upcall succeeds, and "time" doesn't really have any
meaning until the upcall succeeds.

> >> + =C2=A0 =C2=A0 unsigned long state;
> >> + =C2=A0 =C2=A0 char *sidstr;
> >> + =C2=A0 =C2=A0 struct rb_node rbnode;
> >> + =C2=A0 =C2=A0 struct cifs_sid sid;
> >> +};
> >> +
> >

--=20
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
