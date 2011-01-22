From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 1/3]] cifs: Add idmap data structures and defines (try
 #3)
Date: Sat, 22 Jan 2011 07:38:49 -0500
Message-ID: <20110122073849.444f59a6@tlielax.poochiereds.net>
References: <1295646253-21852-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110121170448.6850b176@tlielax.poochiereds.net>
	<AANLkTimi9_recGRQBtY86c23+5W=Vbwdi6EGwnmDkf1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimi9_recGRQBtY86c23+5W=Vbwdi6EGwnmDkf1c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 21 Jan 2011 23:49:33 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Jan 21, 2011 at 4:04 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Fri, 21 Jan 2011 15:44:13 -0600
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> A structure stored an rb tree is defined consisting of a SID and
> >> a id (either uid or gid) to which that SID is mapped.
> >>
> >> Added fields needed to store this defined data structures of a
> >> rb tree to a superblock and initialized them.
> >>
> >> There are two separate trees, one for SID/uid and another one for =
SID/gid.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifs_fs_sb.h | =A0 =A04 ++++
> >> =A0fs/cifs/cifsacl.h =A0 =A0| =A0 =A06 ++++++
> >> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 =A06 ++++++
> >> =A03 files changed, 16 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> >> index ac51cd2..4bd0680 100644
> >> --- a/fs/cifs/cifs_fs_sb.h
> >> +++ b/fs/cifs/cifs_fs_sb.h
> >> @@ -45,6 +45,10 @@
> >> =A0struct cifs_sb_info {
> >> =A0 =A0 =A0 struct rb_root tlink_tree;
> >> =A0 =A0 =A0 spinlock_t tlink_tree_lock;
> >> + =A0 =A0 struct rb_root uidtree;
> >> + =A0 =A0 spinlock_t siduidlock;
> >> + =A0 =A0 struct rb_root gidtree;
> >> + =A0 =A0 spinlock_t sidgidlock;
> >> =A0 =A0 =A0 struct tcon_link *master_tlink;
> >> =A0 =A0 =A0 struct nls_table *local_nls;
> >> =A0 =A0 =A0 unsigned int rsize;
> >> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> >> index c4ae7d0..6c26e7f 100644
> >> --- a/fs/cifs/cifsacl.h
> >> +++ b/fs/cifs/cifsacl.h
> >> @@ -74,6 +74,12 @@ struct cifs_wksid {
> >> =A0 =A0 =A0 char sidname[SIDNAMELENGTH];
> >> =A0} __attribute__((packed));
> >>
> >> +struct cifs_sid_id {
> >> + =A0 =A0 struct rb_node rbnode;
> >> + =A0 =A0 struct cifs_sid sid;
> >> + =A0 =A0 unsigned long id;
> >> +} __attribute__((packed));
> >> +
> >> =A0extern int match_sid(struct cifs_sid *);
> >> =A0extern int compare_sids(const struct cifs_sid *, const struct c=
ifs_sid *);
> >>
> >> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> >> index a8323f1..36182e3 100644
> >> --- a/fs/cifs/cifsfs.c
> >> +++ b/fs/cifs/cifsfs.c
> >> @@ -122,6 +122,12 @@ cifs_read_super(struct super_block *sb, void =
*data,
> >> =A0 =A0 =A0 spin_lock_init(&cifs_sb->tlink_tree_lock);
> >> =A0 =A0 =A0 cifs_sb->tlink_tree =3D RB_ROOT;
> >>
> >> + =A0 =A0 spin_lock_init(&cifs_sb->siduidlock);
> >> + =A0 =A0 cifs_sb->uidtree =3D RB_ROOT;
> >> +
> >> + =A0 =A0 spin_lock_init(&cifs_sb->sidgidlock);
> >> + =A0 =A0 cifs_sb->gidtree =3D RB_ROOT;
> >> +
> >> =A0 =A0 =A0 rc =3D bdi_setup_and_register(&cifs_sb->bdi, "cifs", B=
DI_CAP_MAP_COPY);
> >> =A0 =A0 =A0 if (rc) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(cifs_sb);
> >
> > Why do you need per-sb caches? The upcall isn't specific to a
> > particular superblock, so if you have more than one mount you'll ha=
ve
> > to do multiple upcalls for the same SID and have mutiple copies of =
the
> > same cifs_sid_id in various caches. It seems like a global cache wo=
uld
> > be better.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> Yes, I will change it to a per server structure instead of a per supe=
rblock.

Why a per-server cache though? Are you passing any information that's
specific to the server to the upcall? It looks to me like all you pass
is the SID. If two servers have files owned by the same SID, is there
any need for a separate upcall and separate cache entries for them?

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
