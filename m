From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #11)
Date: Tue, 29 Mar 2011 11:37:41 -0400
Message-ID: <20110329113741.5287c306@tlielax.poochiereds.net>
References: <1301343901-28531-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110329093015.315caf36@tlielax.poochiereds.net>
	<AANLkTimSVQTr_4gkgo4LOoJ-9bszWknz69ERzPEbTtq5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimSVQTr_4gkgo4LOoJ-9bszWknz69ERzPEbTtq5-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 29 Mar 2011 10:23:37 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, Mar 29, 2011 at 8:30 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Mon, 28 Mar 2011 15:25:01 -0500
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
> >> is attempted again during next resolution.
> >>
> >> To map a SID, which can be either a Owner SID or a Group SID, key
> >> description starts with the string "os" or "gs" followed by SID co=
nverted
> >> to a string. Without "os" or "gs", cifs.upcall does not know wheth=
er
> >> SID needs to be mapped to either an uid or a gid.
> >>
> >> Nodes in rb tree as fields to prevent multiple upcalls for
> >> a SID. =C2=A0Adding and removing nodes is done within global locks=
=2E
> >> shrinker routine does not prune a node if mapping for that node
> >> is either pending or or node was recently created (before timeout
> >> period expires and node could be purged). The timeout period shoul=
d
> >> be long enough at least for an upcall to return back to cifs.
> >>
> >> For now, cifs.upcall is only used to map a SID to an id (uid or gi=
d) but
> >> it would be used to obtain an SID (string) for an id.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsacl.c | =C2=A0298 ++++++++++++++++++++++++++++++=
++++++++++++++++++-----
> >> =C2=A0fs/cifs/cifsacl.h | =C2=A0 22 ++++
> >> =C2=A02 files changed, 296 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> >> index c60bb90..5b2ef73 100644
> >> --- a/fs/cifs/cifsacl.c
> >> +++ b/fs/cifs/cifsacl.c
> >> @@ -54,7 +54,30 @@ static const struct cifs_sid sid_authusers =3D =
{
> >> =C2=A0/* group users */
> >> =C2=A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, =
0, 0, 5}, {} };
> >>
> >> -static const struct cred *root_cred;
> >> +const struct cred *root_cred;
> >> +
> >> +static void
> >> +shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_r=
em,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 int *nr_del)
> >> +{
> >> + =C2=A0 =C2=A0 struct rb_node *node;
> >> + =C2=A0 =C2=A0 struct rb_node *tmp;
> >> + =C2=A0 =C2=A0 struct cifs_sid_id *psidid;
> >> +
> >> + =C2=A0 =C2=A0 node =3D rb_first(root);
> >> + =C2=A0 =C2=A0 while (node) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 tmp =3D node;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 node =3D rb_next(tmp);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 psidid =3D rb_entry(tm=
p, struct cifs_sid_id, rbnode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (time_after(psidid-=
>time + SID_MAP_EXPIRE, jiffies) ||
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 (nr_to_scan =3D=3D 0) || (*nr_del =3D=3D=
 nr_to_scan))
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ++(*nr_rem);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rb_erase(tmp, root);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ++(*nr_del);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +}
> >>
> >> =C2=A0/*
> >> =C2=A0 * Run idmap cache shrinker.
> >> @@ -62,9 +85,21 @@ static const struct cred *root_cred;
> >> =C2=A0static int
> >> =C2=A0cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan,=
 gfp_t gfp_mask)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 /* Use a pruning scheme in a subsequent patch inst=
ead */
> >> - =C2=A0 =C2=A0 cifs_destroy_idmaptrees();
> >> - =C2=A0 =C2=A0 return 0;
> >> + =C2=A0 =C2=A0 int nr_del =3D 0;
> >> + =C2=A0 =C2=A0 int nr_rem =3D 0;
> >> + =C2=A0 =C2=A0 struct rb_root *root;
> >> +
> >> + =C2=A0 =C2=A0 root =3D &uidtree;
> >> + =C2=A0 =C2=A0 spin_lock(&siduidlock);
> >> + =C2=A0 =C2=A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_d=
el);
> >> + =C2=A0 =C2=A0 spin_unlock(&siduidlock);
> >> +
> >> + =C2=A0 =C2=A0 root =3D &gidtree;
> >> + =C2=A0 =C2=A0 spin_lock(&sidgidlock);
> >> + =C2=A0 =C2=A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_d=
el);
> >> + =C2=A0 =C2=A0 spin_unlock(&sidgidlock);
> >> +
> >> + =C2=A0 =C2=A0 return nr_rem;
> >> =C2=A0}
> >>
> >> =C2=A0static struct shrinker cifs_shrinker =3D {
> >> @@ -92,7 +127,6 @@ cifs_idmap_key_destroy(struct key *key)
> >> =C2=A0 =C2=A0 =C2=A0 kfree(key->payload.data);
> >> =C2=A0}
> >>
> >> -static
> >> =C2=A0struct key_type cifs_idmap_key_type =3D {
> >> =C2=A0 =C2=A0 =C2=A0 .name =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D "cifs.ci=
fs_idmap",
> >> =C2=A0 =C2=A0 =C2=A0 .instantiate =3D cifs_idmap_key_instantiate,
> >> @@ -101,6 +135,196 @@ struct key_type cifs_idmap_key_type =3D {
> >> =C2=A0 =C2=A0 =C2=A0 .match =C2=A0 =C2=A0 =C2=A0 =3D user_match,
> >> =C2=A0};
> >>
> >> +static void
> >> +id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cifs_sid_id **p=
sidid)
> >> +{
> >> + =C2=A0 =C2=A0 int rc;
> >> + =C2=A0 =C2=A0 struct rb_node *node =3D root->rb_node;
> >> + =C2=A0 =C2=A0 struct rb_node *parent =3D NULL;
> >> + =C2=A0 =C2=A0 struct rb_node **linkto =3D &(root->rb_node);
> >> + =C2=A0 =C2=A0 struct cifs_sid_id *lsidid;
> >> +
> >> + =C2=A0 =C2=A0 while (node) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lsidid =3D rb_entry(no=
de, struct cifs_sid_id, rbnode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 parent =3D node;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D compare_sids(si=
dptr, &((lsidid)->sid));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc > 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 linkto =3D &(node->rb_left);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 node =3D node->rb_left;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (rc < 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 linkto =3D &(node->rb_right);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 node =3D node->rb_right;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 memcpy(&(*psidid)->sid, sidptr, sizeof(struct cifs=
_sid));
> >> + =C2=A0 =C2=A0 clear_bit(SID_ID_PENDING, &(*psidid)->state);
> >> + =C2=A0 =C2=A0 clear_bit(SID_ID_MAPPED, &(*psidid)->state);
> >> +
> >> + =C2=A0 =C2=A0 rb_link_node(&(*psidid)->rbnode, parent, linkto);
> >> + =C2=A0 =C2=A0 rb_insert_color(&(*psidid)->rbnode, root);
> >> +}
> >> +
> >> +static struct cifs_sid_id *
> >> +id_rb_search(struct rb_root *root, struct cifs_sid *sidptr)
> >> +{
> >> + =C2=A0 =C2=A0 int rc;
> >> + =C2=A0 =C2=A0 struct rb_node *node =3D root->rb_node;
> >> + =C2=A0 =C2=A0 struct rb_node *parent =3D NULL;
> >> + =C2=A0 =C2=A0 struct rb_node **linkto =3D &(root->rb_node);
> >> + =C2=A0 =C2=A0 struct cifs_sid_id *lsidid;
> >> +
> >> + =C2=A0 =C2=A0 while (node) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lsidid =3D rb_entry(no=
de, struct cifs_sid_id, rbnode);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 parent =3D node;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D compare_sids(si=
dptr, &((lsidid)->sid));
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (rc > 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 linkto =3D &(node->rb_left);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 node =3D node->rb_left;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else if (rc < 0) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 linkto =3D &(node->rb_right);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 node =3D node->rb_right;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else /* node found *=
/
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return lsidid;
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 return NULL;
> >> +}
> >> +
> >> +static void
> >> +sid_to_str(struct cifs_sid *sidptr, char *sidstr)
> >> +{
> >> + =C2=A0 =C2=A0 int i;
> >> + =C2=A0 =C2=A0 unsigned long saval;
> >> + =C2=A0 =C2=A0 char *strptr;
> >> +
> >> + =C2=A0 =C2=A0 strptr =3D sidstr;
> >> +
> >> + =C2=A0 =C2=A0 sprintf(strptr, "%s", "S");
> >> + =C2=A0 =C2=A0 strptr =3D sidstr + strlen(sidstr);
> >> +
> >> + =C2=A0 =C2=A0 sprintf(strptr, "-%d", sidptr->revision);
> >> + =C2=A0 =C2=A0 strptr =3D sidstr + strlen(sidstr);
> >> +
> >> + =C2=A0 =C2=A0 for (i =3D 0; i < 6; ++i) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (sidptr->authority[=
i]) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sprintf(strptr, "-%d", sidptr->authority[i]);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 strptr =3D sidstr + strlen(sidstr);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 for (i =3D 0; i < sidptr->num_subauth; ++i) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 saval =3D le32_to_cpu(=
sidptr->sub_auth[i]);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(strptr, "-%ld"=
, saval);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 strptr =3D sidstr + st=
rlen(sidstr);
> >> + =C2=A0 =C2=A0 }
> >> +}
> >> +
> >> +static int
> >> +sidid_pending_wait(void *unused)
> >> +{
> >> + =C2=A0 =C2=A0 schedule();
> >> + =C2=A0 =C2=A0 return signal_pending(current) ? -ERESTARTSYS : 0;
> >> +}
> >> +
> >> +static int
> >> +sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct cifs_fattr *fat=
tr, uint sidtype)
> >> +{
> >> + =C2=A0 =C2=A0 int rc;
> >> + =C2=A0 =C2=A0 unsigned long cid;
> >> + =C2=A0 =C2=A0 char *strptr;
> >> + =C2=A0 =C2=A0 struct key *idkey;
> >> + =C2=A0 =C2=A0 const struct cred *saved_cred;
> >> + =C2=A0 =C2=A0 struct cifs_sid_id *psidid, *npsidid;
> >> + =C2=A0 =C2=A0 struct rb_root *cidtree;
> >> + =C2=A0 =C2=A0 spinlock_t *cidlock;
> >> +
> >> + =C2=A0 =C2=A0 if (sidtype =3D=3D SIDOWNER) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cid =3D cifs_sb->mnt_u=
id; /* default uid, in case upcall fails */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cidlock =3D &siduidloc=
k;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cidtree =3D &uidtree;
> >> + =C2=A0 =C2=A0 } else if (sidtype =3D=3D SIDGROUP) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cid =3D cifs_sb->mnt_g=
id; /* default gid, in case upcall fails */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cidlock =3D &sidgidloc=
k;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cidtree =3D &gidtree;
> >> + =C2=A0 =C2=A0 } else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return -ENOENT;
> >> +
> >> + =C2=A0 =C2=A0 spin_lock(cidlock);
> >> + =C2=A0 =C2=A0 psidid =3D id_rb_search(cidtree, psid);
> >> + =C2=A0 =C2=A0 spin_unlock(cidlock);
> >> +
> >> + =C2=A0 =C2=A0 if (!psidid) { /* node does not exist, allocate on=
e & attempt adding */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 npsidid =3D kzalloc(si=
zeof(struct cifs_sid_id), GFP_KERNEL);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!npsidid)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return -ENOMEM;
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(cidlock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 psidid =3D id_rb_searc=
h(cidtree, psid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (psidid) { /* node =
happened to get inserted meanwhile */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_unlock(cidlock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 kfree(npsidid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 psidid =3D npsidid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 id_rb_insert(cidtree, psid, &psidid);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_unlock(cidlock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (!test_bit(SID_ID_MAPPED, &psidid->state)) { /*=
 SID not mapped */
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^ nit: maybe just do:
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0if (test_bit(SID_ID_MAPPED...
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out;
> >
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0...or something. That would allow you to=
 reduce the indentation
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0of the code below and make it easier to =
read.
> >
>=20
> Will make this change.
>=20
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!test_and_set_bit(=
SID_ID_PENDING, &psidid->state)) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 memset(psidid->sidstr, '\0', SIDLEN);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (sidtype =3D=3D SIDOWNER)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(psidid->sidstr, "%s", "os:");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sprintf(psidid->sidstr, "%s", "gs:");
> >> +
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 strptr =3D psidid->sidstr + strlen(psidid->sidstr);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 sid_to_str(psid, strptr);
> >> +
> >
> > Would it be better to do the string handling above before you inser=
t
> > this struct into the tree? In the case where this thing can't be ma=
pped,
> > then you're going to have to re-convert the sid on every pass throu=
gh
> > this function. Just doing that once would make more sense, IMO...
> >
>=20
> Will address it.
>=20
> > I wonder too...once this thing is mapped, then the above string wil=
l
> > never be used again, will it? If so, would it be best to release th=
at
> > memory instead of keeping it around in the cache?
>=20
> I think kmalloc the memory for string when node is allocated and free=
 it
> once SID is mapped?  The string is really not needed at all once
> a SID is mapped.
>=20

I think so too. This cache can possibly grow to be rather large, so you
ought to be as efficient as possible with memory (that's a good goal
anyway). It might even be worthwhile to make your own slabcache for
these entries, but that can be done in a later patch once the need is
demonstrated.

> >
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 saved_cred =3D override_creds(root_cred);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 idkey =3D request_key(&cifs_idmap_key_type,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 psidid->sidstr, "");
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (IS_ERR(idkey)) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 psidid->id =3D cid;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: Can't map SID to an id", _=
_func__);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 } else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 psidid->id =3D
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 *(unsigned =
long *)idkey->payload.value;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 psidid->time =3D jiffies;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 set_bit(SID_ID_MAPPED, &psidid->state);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 key_put(idkey);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 revert_creds(saved_cred);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 clear_bit(SID_ID_PENDING, &psidid->state);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 wake_up_bit(&psidid->state, SID_ID_PENDING);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 } else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /*
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* either an existing node with SID mapped (in which
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* case we would not wait) or a node whose SID is
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* being mapped by somebody else (in which case, we
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0* would end up waiting).
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0*/
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D wait_on_bit(&psidid->state, SID_ID_PENDING,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 sidid_pendi=
ng_wait, TASK_INTERRUPTIBLE);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (rc) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cFYI(1, "%s: sidid_pending_wait interru=
pted %d",
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __func__, r=
c);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return rc;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 }
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (sidtype =3D=3D SIDOWNER)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_uid =3D psid=
id->id;
> >> + =C2=A0 =C2=A0 else
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 fattr->cf_gid =3D psid=
id->id;
> >> +
> >> + =C2=A0 =C2=A0 return 0;
> >> +}
> >> +
> >
> > So let's consider the case where we have a directory with a lot of
> > files in it that are owned by a user that can't be mapped. Someone =
does
> > a "ls -l" in that dir.
> >
> > Presumably, on every stat() call we'll call into this routine to ma=
p
> > the SID to a unix uid. The MAPPED bit will never be set though, so
> > we'll always call request_key().
> >
> > cifs.upcall will generally negatively instantiate the key with a 1s
> > timeout. I think if request-key doesn't find a match (indicating th=
at
> > no one set up request-key.conf) then it negatively instantiates the=
 key
> > with a 60s timeout.
> >
> > Is that reasonable behavior here?
> >
>=20
> Not sure I understand the negative instantiation of key with a timeou=
t.
> I had a timeout field in some of the earlier patch versions whrere re=
-mapping
> for an unmapped SID is attempted only after that timeout expires
>=20

I believe it works something like this...

When the upcall returns an error without instantiating the key, the
kernel negatively instantiates the key with a 60s timeout. The
cifs.upcall program however will instead negatively instantiate the key
with a 1s timeout.

When there's a negative key in cache, request_key will return an error
(-ENOKEY, I think) without doing the upcall. That's generally a good
thing. We don't want to bog down the box by forcing it to keep forking
new upcall processes that aren't going to work.

The question here is -- what behavior do you want on subsequent
request_key invocations when one fails? How long do you want to wait
before allowing a new upcall in this situation?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
