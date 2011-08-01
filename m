From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] cifs: Add data structures and functions for uid/gid
 to SID mapping (try #2)
Date: Mon, 1 Aug 2011 16:24:00 -0500
Message-ID: <CAH2r5mtiHm42CfMUQT9BHm8bmnf_8X7eULQM7kFUQEb9Eutztg@mail.gmail.com>
References: <1312231791-18010-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312231791-18010-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 1, 2011 at 3:49 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Add data structures and functions necessary to map a uid and gid to S=
ID.
> These functions are very similar to the ones used to map a SID to uid=
 and gid.
> This time, instead of storing sid to id mapping sorted on sid value,
> id to sid is stored, sorted on id.
> A cifs upcall sends an id (uid or gid) and expects a SID structure
> in return, if mapping was done successfully.
>
> Changed the return code of failed id to sid mapping to EINVAL.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsacl.c =A0| =A0198 ++++++++++++++++++++++++++++++++++++=
++++++++++++++++
> =A0fs/cifs/cifsglob.h | =A0 =A04 +
> =A02 files changed, 202 insertions(+), 0 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index 21de1d6..b7e723a 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -91,9 +91,76 @@ cifs_idmap_shrinker(struct shrinker *shrink, struc=
t shrink_control *sc)
> =A0 =A0 =A0 =A0shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> =A0 =A0 =A0 =A0spin_unlock(&sidgidlock);
>
> + =A0 =A0 =A0 root =3D &siduidtree;
> + =A0 =A0 =A0 spin_lock(&uidsidlock);
> + =A0 =A0 =A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> + =A0 =A0 =A0 spin_unlock(&uidsidlock);
> +
> + =A0 =A0 =A0 root =3D &sidgidtree;
> + =A0 =A0 =A0 spin_lock(&gidsidlock);
> + =A0 =A0 =A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
> + =A0 =A0 =A0 spin_unlock(&gidsidlock);
> +
> =A0 =A0 =A0 =A0return nr_rem;
> =A0}
>
> +static void
> +sid_rb_insert(struct rb_root *root, unsigned long cid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sid_id **psidid, char *type=
str)
> +{
> + =A0 =A0 =A0 char *strptr;
> + =A0 =A0 =A0 struct rb_node *node =3D root->rb_node;
> + =A0 =A0 =A0 struct rb_node *parent =3D NULL;
> + =A0 =A0 =A0 struct rb_node **linkto =3D &(root->rb_node);
> + =A0 =A0 =A0 struct cifs_sid_id *lsidid;
> +
> + =A0 =A0 =A0 while (node) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lsidid =3D rb_entry(node, struct cifs_s=
id_id, rbnode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D node;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cid > lsidid->id) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_l=
eft);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cid < lsidid->id) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_r=
ight);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 (*psidid)->id =3D cid;
> + =A0 =A0 =A0 (*psidid)->time =3D jiffies - (SID_MAP_RETRY + 1);
> + =A0 =A0 =A0 (*psidid)->refcount =3D 0;
> +
> + =A0 =A0 =A0 sprintf((*psidid)->sidstr, "%s", typestr);
> + =A0 =A0 =A0 strptr =3D (*psidid)->sidstr + strlen((*psidid)->sidstr=
);
> + =A0 =A0 =A0 sprintf(strptr, "%ld", cid);
> +
> + =A0 =A0 =A0 clear_bit(SID_ID_PENDING, &(*psidid)->state);
> + =A0 =A0 =A0 clear_bit(SID_ID_MAPPED, &(*psidid)->state);
> +
> + =A0 =A0 =A0 rb_link_node(&(*psidid)->rbnode, parent, linkto);
> + =A0 =A0 =A0 rb_insert_color(&(*psidid)->rbnode, root);
> +}
> +
> +static struct cifs_sid_id *
> +sid_rb_search(struct rb_root *root, unsigned long cid)
> +{
> + =A0 =A0 =A0 struct rb_node *node =3D root->rb_node;
> + =A0 =A0 =A0 struct cifs_sid_id *lsidid;
> +
> + =A0 =A0 =A0 while (node) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 lsidid =3D rb_entry(node, struct cifs_s=
id_id, rbnode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cid > lsidid->id)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (cid < lsidid->id)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else /* node found */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return lsidid;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return NULL;
> +}
> +
> =A0static struct shrinker cifs_shrinker =3D {
> =A0 =A0 =A0 =A0.shrink =3D cifs_idmap_shrinker,
> =A0 =A0 =A0 =A0.seeks =3D DEFAULT_SEEKS,
> @@ -110,6 +177,7 @@ cifs_idmap_key_instantiate(struct key *key, const=
 void *data, size_t datalen)
>
> =A0 =A0 =A0 =A0memcpy(payload, data, datalen);
> =A0 =A0 =A0 =A0key->payload.data =3D payload;
> + =A0 =A0 =A0 key->datalen =3D datalen;
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> @@ -224,6 +292,120 @@ sidid_pending_wait(void *unused)
> =A0}
>
> =A0static int
> +id_to_sid(unsigned long cid, uint sidtype, struct cifs_sid *ssid)
> +{
> + =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 struct key *sidkey;
> + =A0 =A0 =A0 const struct cred *saved_cred;
> + =A0 =A0 =A0 struct cifs_sid *lsid;
> + =A0 =A0 =A0 struct cifs_sid_id *psidid, *npsidid;
> + =A0 =A0 =A0 struct rb_root *cidtree;
> + =A0 =A0 =A0 spinlock_t *cidlock;
> +
> + =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cidlock =3D &siduidlock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cidtree =3D &uidtree;
> + =A0 =A0 =A0 } else if (sidtype =3D=3D SIDGROUP) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cidlock =3D &sidgidlock;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cidtree =3D &gidtree;
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> +
> + =A0 =A0 =A0 spin_lock(cidlock);
> + =A0 =A0 =A0 psidid =3D sid_rb_search(cidtree, cid);
> +
> + =A0 =A0 =A0 if (!psidid) { /* node does not exist, allocate one & a=
ttempt adding */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 npsidid =3D kzalloc(sizeof(struct cifs_=
sid_id), GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!npsidid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 npsidid->sidstr =3D kmalloc(SIDLEN, GFP=
_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!npsidid->sidstr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(npsidid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(cidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D sid_rb_search(cidtree, cid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (psidid) { /* node happened to get i=
nserted meanwhile */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++psidid->refcount;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(npsidid->sidstr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(npsidid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D npsidid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sid_rb_insert(cidtree, =
cid, &psidid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sidtype =3D=3D SIDOWNER ? "oi:" : "gi:");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++psidid->refcount;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++psidid->refcount;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* If we are here, it is safe to access psidid and it=
s fields
> + =A0 =A0 =A0 =A0* since a reference was taken earlier while holding =
the spinlock.
> + =A0 =A0 =A0 =A0* A reference on the node is put without holding the=
 spinlock
> + =A0 =A0 =A0 =A0* and it is OK to do so in this case, shrinker will =
not erase
> + =A0 =A0 =A0 =A0* this node until all references are put and we do n=
ot access
> + =A0 =A0 =A0 =A0* any fields of the node after a reference is put .
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (test_bit(SID_ID_MAPPED, &psidid->state)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ssid, &psidid->sid, sizeof(struc=
t cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->time =3D jiffies; /* update ts =
for accessing */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto id_sid_out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (time_after(psidid->time + SID_MAP_RETRY, jiffies)) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto id_sid_out;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) =
{
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 saved_cred =3D override_creds(root_cred=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidkey =3D request_key(&cifs_idmap_key_=
type, psidid->sidstr, "");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(sidkey)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Can't map =
and id to a SID", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lsid =3D (struct cifs_s=
id *)sidkey->payload.data;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&psidid->sid, ls=
id,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidkey-=
>datalen < sizeof(struct cifs_sid) ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidkey-=
>datalen : sizeof(struct cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ssid, &psidid->s=
id,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidkey-=
>datalen < sizeof(struct cifs_sid) ?
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidkey-=
>datalen : sizeof(struct cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(SID_ID_MAPPED, =
&psidid->state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(sidkey);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(psidid->sidstr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->time =3D jiffies; /* update ts =
for accessing */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 revert_creds(saved_cred);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_PENDING, &psidid->stat=
e);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_bit(&psidid->state, SID_ID_PEND=
ING);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_on_bit(&psidid->state, SID_=
ID_PENDING,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidid_p=
ending_wait, TASK_INTERRUPTIBLE);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: sidid_pend=
ing_wait interrupted %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 --psidid->refcount;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(SID_ID_MAPPED, &psidid->st=
ate))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ssid, &psidid->s=
id, sizeof(struct cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -EINVAL;
> + =A0 =A0 =A0 }
> +id_sid_out:
> + =A0 =A0 =A0 --psidid->refcount;
> + =A0 =A0 =A0 return rc;
> +}
> +
> +static int
> =A0sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifs_fattr *fattr, uint sidtype=
)
> =A0{
> @@ -383,6 +565,10 @@ init_cifs_idmap(void)
> =A0 =A0 =A0 =A0spin_lock_init(&sidgidlock);
> =A0 =A0 =A0 =A0gidtree =3D RB_ROOT;
>
> + =A0 =A0 =A0 spin_lock_init(&uidsidlock);
> + =A0 =A0 =A0 siduidtree =3D RB_ROOT;
> + =A0 =A0 =A0 spin_lock_init(&gidsidlock);
> + =A0 =A0 =A0 sidgidtree =3D RB_ROOT;
> =A0 =A0 =A0 =A0register_shrinker(&cifs_shrinker);
>
> =A0 =A0 =A0 =A0cFYI(1, "cifs idmap keyring: %d\n", key_serial(keyring=
));
> @@ -422,6 +608,18 @@ cifs_destroy_idmaptrees(void)
> =A0 =A0 =A0 =A0while ((node =3D rb_first(root)))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rb_erase(node, root);
> =A0 =A0 =A0 =A0spin_unlock(&sidgidlock);
> +
> + =A0 =A0 =A0 root =3D &siduidtree;
> + =A0 =A0 =A0 spin_lock(&uidsidlock);
> + =A0 =A0 =A0 while ((node =3D rb_first(root)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(node, root);
> + =A0 =A0 =A0 spin_unlock(&uidsidlock);
> +
> + =A0 =A0 =A0 root =3D &sidgidtree;
> + =A0 =A0 =A0 spin_lock(&gidsidlock);
> + =A0 =A0 =A0 while ((node =3D rb_first(root)))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(node, root);
> + =A0 =A0 =A0 spin_unlock(&gidsidlock);
> =A0}
>
> =A0/* if the two SIDs (roughly equivalent to a UUID for a user or gro=
up) are
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 6255fa8..6b5e4a5 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -940,6 +940,10 @@ GLOBAL_EXTERN struct rb_root uidtree;
> =A0GLOBAL_EXTERN struct rb_root gidtree;
> =A0GLOBAL_EXTERN spinlock_t siduidlock;
> =A0GLOBAL_EXTERN spinlock_t sidgidlock;
> +GLOBAL_EXTERN struct rb_root siduidtree;
> +GLOBAL_EXTERN struct rb_root sidgidtree;
> +GLOBAL_EXTERN spinlock_t uidsidlock;
> +GLOBAL_EXTERN spinlock_t gidsidlock;
>
> =A0void cifs_oplock_break(struct work_struct *work);
> =A0void cifs_oplock_break_get(struct cifsFileInfo *cfile);

Should these global externs (and the three or four above)
be in the cifsacl ifdef? Might save a little bit of memory.




--=20
Thanks,

Steve
