From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Invoke id mapping functions (try #8 repost)
Date: Thu, 10 Mar 2011 11:52:05 -0600
Message-ID: <AANLkTimfBmS+1MjSGN6RKtjVLeqMJt_O9cBACakY6LRT@mail.gmail.com>
References: <1299645291-8133-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1299645291-8133-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 8, 2011 at 10:34 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> rb tree search and insertion routines.
>
> A SID which needs to be mapped, is looked up in one of the rb trees
> depending whether SID is either owner or group SID.
> If found in the tree, a (mapped) id from that node is assigned to
> uid or gid as appropriate. =A0If upcall returns an error, mapping
> is retried after a timeout period.
>
> Otherwise, an node is inserted in the tree and a mapping id for
> that SID is looked-up with the help of Winbind via upcall mechanism.
> If, for whatever reasons, winbind calls return error, SID for an
> owner is mapped to 'nobody' and SID for a group is mapped to 'nogroup=
'.
>
> To map a SID, which can be either a Owner SID or a Group SID, key
> description starts with the string "os" or "gs" followed by SID conve=
rted
> to a string. Without "os" or "gs", cifs.upcall does not know whether
> SID needs to be mapped to either an uid or a gid.
>
> Nodes in rb tree as fields to prevent multiple upcalls for
> a SID. =A0Adding and removing nodes is done within global locks.
> shrinker routine does not prune a node if mapping for that node
> is either pending or or node was recently created (before timeout
> period expires and node could be purged). The timeout period should
> be long enough at least for an upcall to return back to cifs.
>
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) =
but
> it would be used to obtain an SID (string) for an id.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsacl.c | =A0326 +++++++++++++++++++++++++++++++++++++++=
++++++++++----
> =A0fs/cifs/cifsacl.h | =A0 23 ++++
> =A02 files changed, 325 insertions(+), 24 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index fc1ec64..aea06ef 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -54,7 +54,31 @@ static const struct cifs_sid sid_authusers =3D {
> =A0/* group users */
> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0, =
5}, {} };
>
> -static const struct cred *root_cred;
> +const struct cred *root_cred;
> +
> +void
> +shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_rem,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *nr_del)
> +{
> + =A0 =A0 =A0 struct rb_node *node;
> + =A0 =A0 =A0 struct rb_node *tmp;
> + =A0 =A0 =A0 struct cifs_sid_id *psidid;
> +
> + =A0 =A0 =A0 node =3D rb_first(root);
> + =A0 =A0 =A0 while (node) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D node;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D rb_next(tmp);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D rb_entry(tmp, struct cifs_si=
d_id, rbnode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(psidid->time + SID_MAP_E=
XPIRE, jiffies) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_bi=
t(SID_ID_PENDING, &psidid->state) ||
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (nr_to_=
scan =3D=3D 0) || (*nr_del =3D=3D nr_to_scan))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++(*nr_rem);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(tmp, root);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++(*nr_del);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +}
>
> =A0/*
> =A0* Run idmap cache shrinker.
> @@ -62,11 +86,24 @@ static const struct cred *root_cred;
> =A0static int
> =A0cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t=
 gfp_mask)
> =A0{
> - =A0 =A0 =A0 /* Use a pruning scheme in a subsequent patch instead *=
/
> - =A0 =A0 =A0 cifs_destroy_idmaptrees();
> - =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 int nr_del =3D 0;
> + =A0 =A0 =A0 int nr_rem =3D 0;
> + =A0 =A0 =A0 struct rb_root *root;
> +
> + =A0 =A0 =A0 root =3D &uidtree;
> + =A0 =A0 =A0 spin_lock(&siduidlock);
> + =A0 =A0 =A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> + =A0 =A0 =A0 spin_unlock(&siduidlock);
> +
> + =A0 =A0 =A0 root =3D &gidtree;
> + =A0 =A0 =A0 spin_lock(&sidgidlock);
> + =A0 =A0 =A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> + =A0 =A0 =A0 spin_unlock(&sidgidlock);
> +
> + =A0 =A0 =A0 return nr_rem;
> =A0}
>
> +
> =A0static struct shrinker cifs_shrinker =3D {
> =A0 =A0 =A0 =A0.shrink =3D cifs_idmap_shrinker,
> =A0 =A0 =A0 =A0.seeks =3D DEFAULT_SEEKS,
> @@ -92,7 +129,6 @@ cifs_idmap_key_destroy(struct key *key)
> =A0 =A0 =A0 =A0kfree(key->payload.data);
> =A0}
>
> -static
> =A0struct key_type cifs_idmap_key_type =3D {
> =A0 =A0 =A0 =A0.name =A0 =A0 =A0 =A0=3D "cifs.cifs_idmap",
> =A0 =A0 =A0 =A0.instantiate =3D cifs_idmap_key_instantiate,
> @@ -101,6 +137,222 @@ struct key_type cifs_idmap_key_type =3D {
> =A0 =A0 =A0 =A0.match =A0 =A0 =A0 =3D user_match,
> =A0};
>
> +static struct cifs_sid_id *
> +id_rb_lookup(struct rb_root *root, struct cifs_sid *sidptr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct rb_node **sparent, struct rb_nod=
e ***slinkto)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct cifs_sid_id *lsidid;
> + =A0 =A0 =A0 struct rb_node *node =3D root->rb_node;
> + =A0 =A0 =A0 struct rb_node *parent =3D NULL;
> + =A0 =A0 =A0 struct rb_node **linkto =3D &(root->rb_node);
> +
> + =A0 =A0 =A0 while (node) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lsidid =3D rb_entry(node, struct cifs_s=
id_id, rbnode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D node;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D compare_sids(sidptr, &((lsidid)-=
>sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc > 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_l=
eft);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (rc < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_r=
ight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else /* node found */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return lsidid;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 if (sparent && slinkto) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *sparent =3D parent;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *slinkto =3D linkto;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return NULL;
> +}
> +
> +static struct cifs_sid_id *
> +id_rb_add(struct rb_root *root, struct cifs_sid *sidptr, bool *sidma=
p,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sid_id **psidid)
> +{
> + =A0 =A0 =A0 struct cifs_sid_id *lsidid;
> + =A0 =A0 =A0 struct rb_node *parent;
> + =A0 =A0 =A0 struct rb_node **linkto;
> +
> + =A0 =A0 =A0 lsidid =3D id_rb_lookup(root, sidptr, &parent, &linkto)=
;
> + =A0 =A0 =A0 if (!lsidid) { /* node did not happen to get added, so =
add it */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *sidmap =3D false;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&(*psidid)->sid, sidptr, sizeof(=
struct cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(SID_ID_PENDING, &(*psidid)->sta=
te);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(SID_ID_UNMAPPED, &(*psidid)->st=
ate);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_link_node(&(*psidid)->rbnode, parent=
, linkto);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_insert_color(&(*psidid)->rbnode, roo=
t);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return lsidid;
> +}
> +
> +static struct cifs_sid_id *
> +id_rb_search(struct rb_root *root, struct cifs_sid *sidptr, bool *si=
dmap)
> +{
> + =A0 =A0 =A0 struct cifs_sid_id *lsidid;
> +
> + =A0 =A0 =A0 lsidid =3D id_rb_lookup(root, sidptr, NULL, NULL);
> + =A0 =A0 =A0 if (lsidid) { /* node found */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(SID_ID_UNMAPPED, &(lsidid)=
->state) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !time_a=
fter((lsidid)->retry + SID_MAP_RETRY,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 jiffies)) { /* unmapped SID */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!test_and_set_bit(S=
ID_ID_PENDING, &(lsidid)->state))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *sidmap=
 =3D false; /* get to retry mapping */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return lsidid;
> +}
> +
> +static void
> +sid_to_str(struct cifs_sid *sidptr, char *sidstr)
> +{
> + =A0 =A0 =A0 int i;
> + =A0 =A0 =A0 unsigned long saval;
> + =A0 =A0 =A0 char *strptr;
> +
> + =A0 =A0 =A0 strptr =3D sidstr;
> +
> + =A0 =A0 =A0 sprintf(strptr, "%s", "S");
> + =A0 =A0 =A0 strptr =3D sidstr + strlen(sidstr);
> +
> + =A0 =A0 =A0 sprintf(strptr, "-%d", sidptr->revision);
> + =A0 =A0 =A0 strptr =3D sidstr + strlen(sidstr);
> +
> + =A0 =A0 =A0 for (i =3D 0; i < 6; ++i) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sidptr->authority[i]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "-%d", =
sidptr->authority[i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + str=
len(sidstr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 for (i =3D 0; i < sidptr->num_subauth; ++i) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 saval =3D le32_to_cpu(sidptr->sub_auth[=
i]);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "-%ld", saval);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + strlen(sidstr);
> + =A0 =A0 =A0 }
> +}
> +
> +static int
> +cifs_sid_pending_wait(void *unused)
> +{
> + =A0 =A0 =A0 schedule();
> + =A0 =A0 =A0 return signal_pending(current) ? -ERESTARTSYS : 0;
> +}
> +
> +static int
> +sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_fattr *fattr, uint sidtype)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 unsigned long id;
> + =A0 =A0 =A0 bool sidmap =3D true;
> + =A0 =A0 =A0 char *strptr;
> + =A0 =A0 =A0 char *sidstr;
> + =A0 =A0 =A0 struct key *idkey;
> + =A0 =A0 =A0 const struct cred *saved_cred;
> + =A0 =A0 =A0 struct cifs_sid_id *psidid =3D NULL;
> + =A0 =A0 =A0 struct cifs_sid_id *epsidid =3D NULL;
> +
> + =A0 =A0 =A0 if (sidtype !=3D SIDOWNER && sidtype !=3D SIDGROUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
> +
> + =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D cifs_sb->mnt_uid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&siduidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_search(&uidtree, psid,=
 &sidmap);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&siduidlock);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D cifs_sb->mnt_gid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&sidgidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_search(&gidtree, psid,=
 &sidmap);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&sidgidlock);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (!psidid) { /* node does not exist, allocate one & a=
ttempt adding */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 epsidid =3D kzalloc(sizeof(struct cifs_=
sid_id), GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!epsidid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&siduidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_add(&u=
idtree, psid, &sidmap, &epsidid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&siduidlock=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&sidgidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_add(&g=
idtree, psid, &sidmap, &epsidid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&sidgidlock=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (psidid) /* node happened to get add=
ed meanwhile */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(epsidid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D epsidid;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sidmap =3D=3D false) { /* node with unmapped SID */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidstr =3D kzalloc(SIDLEN, GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!sidstr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(sidstr, "%s", "=
os:");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(sidstr, "%s", "=
gs:");
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + strlen(sidstr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sid_to_str(psid, strptr);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 saved_cred =3D override_creds(root_cred=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 idkey =3D request_key(&cifs_idmap_key_t=
ype, sidstr, "");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(idkey))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Can't map =
SID to an id", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D *(unsigned long =
*)idkey->payload.value;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(idkey);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_UNMAPP=
ED, &psidid->state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->time =3D jiffies;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->retry =3D jiffies;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->id =3D id;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_PENDING, &psidid->stat=
e);

I think I am missing a call here
                    wake_up_bit(SID_ID_PENDING, &psidid->state);

Will wait for any other comments before re-posting this patch
with the above change (and any other posssible suggested changes).


> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 revert_creds(saved_cred);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(sidstr);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* either an existing node with SID m=
apped (in which case
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* we would not wait) or a node whose=
 SID is being mapped
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* by somebody else (in which case, w=
e would end up waiting).
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_on_bit(&psidid->state, SID_=
ID_PENDING,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_si=
d_pending_wait, TASK_INTERRUPTIBLE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: cifs_sid=
_pending_wait interrupted %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* No point in checking whether state=
 has bit SID_ID_UNMAPPED
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* set. If SID_ID_UNMAPPED state bit =
is not set, upcall must
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* have returned an error. =A0No poin=
t in making an upcall here
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* again right away, it is likely to =
fail.
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D psidid->id;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_uid =3D id;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_gid =3D id;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> =A0int
> =A0init_cifs_idmap(void)
> =A0{
> @@ -242,16 +494,24 @@ int compare_sids(const struct cifs_sid *ctsid, =
const struct cifs_sid *cwsid)
> =A0 =A0 =A0 =A0int num_subauth, num_sat, num_saw;
>
> =A0 =A0 =A0 =A0if ((!ctsid) || (!cwsid))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>
> =A0 =A0 =A0 =A0/* compare the revision */
> - =A0 =A0 =A0 if (ctsid->revision !=3D cwsid->revision)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 if (ctsid->revision !=3D cwsid->revision) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->revision > cwsid->revision)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0/* compare all of the six auth values */
> =A0 =A0 =A0 =A0for (i =3D 0; i < 6; ++i) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->authority[i] !=3D cwsid->aut=
hority[i])
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->authority[i] !=3D cwsid->aut=
hority[i]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->authority[i]=
 > cwsid->authority[i])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0/* compare all of the subauth values if any */
> @@ -260,12 +520,16 @@ int compare_sids(const struct cifs_sid *ctsid, =
const struct cifs_sid *cwsid)
> =A0 =A0 =A0 =A0num_subauth =3D num_sat < num_saw ? num_sat : num_saw;
> =A0 =A0 =A0 =A0if (num_subauth) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (i =3D 0; i < num_subauth; ++i) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->sub_auth[i] =
!=3D cwsid->sub_auth[i])
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->sub_auth[i] =
!=3D cwsid->sub_auth[i]) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cts=
id->sub_auth[i] > cwsid->sub_auth[i])
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 return -1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 return 1; /* sids compare/match */
> + =A0 =A0 =A0 return 0; /* sids compare/match */
> =A0}
>
>
> @@ -520,22 +784,22 @@ static void parse_dacl(struct cifs_acl *pdacl, =
char *end_of_acl,
> =A0#ifdef CONFIG_CIFS_DEBUG2
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dump_ace(ppace[i], end=
_of_acl);
> =A0#endif
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), pownersid))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), pownersid) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0access=
_flags_to_mode(ppace[i]->access_req,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ppace[i]->type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fattr->cf_mode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &user_mask);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), pgrpsid))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), pgrpsid) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0access=
_flags_to_mode(ppace[i]->access_req,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ppace[i]->type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fattr->cf_mode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &group_mask);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), &sid_everyone))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), &sid_everyone) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0access=
_flags_to_mode(ppace[i]->access_req,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ppace[i]->type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fattr->cf_mode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &other_mask);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), &sid_authusers))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppac=
e[i]->sid), &sid_authusers) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0access=
_flags_to_mode(ppace[i]->access_req,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ppace[i]->type,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fattr->cf_mode,
> @@ -613,10 +877,10 @@ static int parse_sid(struct cifs_sid *psid, cha=
r *end_of_acl)
>
>
> =A0/* Convert CIFS ACL to POSIX form */
> -static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_fattr *=
fattr)
> +static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pntsd, int acl_len, s=
truct cifs_fattr *fattr)
> =A0{
> - =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 int rc =3D 0;
> =A0 =A0 =A0 =A0struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
> =A0 =A0 =A0 =A0struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
> =A0 =A0 =A0 =A0char *end_of_acl =3D ((char *)pntsd) + acl_len;
> @@ -638,12 +902,26 @@ static int parse_sec_desc(struct cifs_ntsd *pnt=
sd, int acl_len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_to_cpu(pntsd->sacloffset), daclo=
ffset);
> =A0/* =A0 =A0 cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
> =A0 =A0 =A0 =A0rc =3D parse_sid(owner_sid_ptr, end_of_acl);
> - =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d parsing Owner SID=
", __func__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 rc =3D sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNE=
R);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Owner SID=
 to uid", __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0rc =3D parse_sid(group_sid_ptr, end_of_acl);
> - =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Owner SID=
 to gid", __func__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 rc =3D sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROU=
P);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Group SID=
 to gid", __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (dacloffset)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parse_dacl(dacl_ptr, end_of_acl, owner=
_sid_ptr,
> @@ -658,7 +936,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd=
, int acl_len,
> =A0 =A0 =A0 =A0memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_=
ptr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct cifs_sid=
)); */
>
> - =A0 =A0 =A0 return 0;
> + =A0 =A0 =A0 return rc;
> =A0}
>
>
> @@ -865,7 +1143,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, =
struct cifs_fattr *fattr,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D PTR_ERR(pntsd);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "%s: error %d getting sec de=
sc", __func__, rc);
> =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D parse_sec_desc(pntsd, acllen, fa=
ttr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D parse_sec_desc(cifs_sb, pntsd, a=
cllen, fattr);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(pntsd);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "parse sec d=
esc failed rc =3D %d", rc);
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index 025e943..5f075c0 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -39,6 +39,15 @@
> =A0#define ACCESS_ALLOWED 0
> =A0#define ACCESS_DENIED =A01
>
> +#define SIDOWNER 1
> +#define SIDGROUP 2
> +#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub author=
ities */
> +
> +#define SID_ID_PENDING 0
> +#define SID_ID_UNMAPPED 1
> +#define SID_MAP_EXPIRE 1000 /* enough for an upcall to return? */
> +#define SID_MAP_RETRY 100 /* retry mapping in case prior attempt fai=
led */
> +
> =A0struct cifs_ntsd {
> =A0 =A0 =A0 =A0__le16 revision; /* revision level */
> =A0 =A0 =A0 =A0__le16 type;
> @@ -74,6 +83,20 @@ struct cifs_wksid {
> =A0 =A0 =A0 =A0char sidname[SIDNAMELENGTH];
> =A0} __attribute__((packed));
>
> +struct cifs_sid_id {
> + =A0 =A0 =A0 struct rb_node rbnode;
> + =A0 =A0 =A0 struct cifs_sid sid;
> + =A0 =A0 =A0 unsigned long state;
> + =A0 =A0 =A0 unsigned long id;
> + =A0 =A0 =A0 unsigned long time;
> + =A0 =A0 =A0 unsigned long retry;
> +};
> +
> +#ifdef __KERNEL__
> +extern struct key_type cifs_idmap_key_type;
> +extern const struct cred *root_cred;
> +#endif /* KERNEL */
> +
> =A0extern int match_sid(struct cifs_sid *);
> =A0extern int compare_sids(const struct cifs_sid *, const struct cifs=
_sid *);
>
> --
> 1.6.0.2
>
>
