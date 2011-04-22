From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #17)
Date: Fri, 22 Apr 2011 07:17:18 -0500
Message-ID: <BANLkTinUCs2azcB-oi6EfUejTmDiqphO0A@mail.gmail.com>
References: <1303395351-26687-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110422074330.75236825@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422074330.75236825-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Apr 22, 2011 at 6:43 AM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> =
wrote:
> On Thu, 21 Apr 2011 09:15:51 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> rb tree search and insertion routines.
>>
>> A SID which needs to be mapped, is looked up in one of the rb trees
>> depending on whether SID is either owner or group SID.
>> If found in the tree, a (mapped) id from that node is assigned to
>> uid or gid as appropriate. =A0If unmapped, an upcall is attempted to
>> map the SID to an id. =A0If upcall is successful, node is marked as
>> mapped. =A0If upcall fails, node stays marked as unmapped and a mapp=
ing
>> is attempted again only after an arbitrary time period has passed.
>>
>> To map a SID, which can be either a Owner SID or a Group SID, key
>> description starts with the string "os" or "gs" followed by SID conv=
erted
>> to a string. Without "os" or "gs", cifs.upcall does not know whether
>> SID needs to be mapped to either an uid or a gid.
>>
>> Nodes in rb tree have fields to prevent multiple upcalls for
>> a SID. =A0Searching, adding, and removing nodes is done within globa=
l locks.
>> Whenever a node is either found or inserted in a tree, a reference
>> is taken on that node.
>> Shrinker routine prunes a node if it has expired but does not prune
>> an expired node if its refcount is not zero (i.e. sid/id of that nod=
e
>> is_being/will_be accessed).
>> Thus a node, if its SID needs to be mapped by making an upcall,
>> can safely stay and its fields accessed without shrinker pruning it.
>>
>> Every time an existing mapped node is accessed or mapping is attempt=
ed,
>> its timestamp is updated to prevent it from getting erased or a
>> to prevent multiple unnecessary repeat mapping retries respectively.
>>
>> For now, cifs.upcall is only used to map a SID to an id (uid or gid)=
 but
>> it would be used to obtain an SID for an id.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c | =A0321 ++++++++++++++++++++++++++++++++++++++=
+++++++++++----
>> =A0fs/cifs/cifsacl.h | =A0 24 ++++
>> =A02 files changed, 321 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index 061fc3a..b01921f 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -54,7 +54,33 @@ static const struct cifs_sid sid_authusers =3D {
>> =A0/* group users */
>> =A0static const struct cifs_sid sid_user =3D {1, 2 , {0, 0, 0, 0, 0,=
 5}, {} };
>>
>> -static const struct cred *root_cred;
>> +const struct cred *root_cred;
>> +
>> +static void
>> +shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_rem=
,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *nr_del)
>> +{
>> + =A0 =A0 struct rb_node *node;
>> + =A0 =A0 struct rb_node *tmp;
>> + =A0 =A0 struct cifs_sid_id *psidid;
>> +
>> + =A0 =A0 node =3D rb_first(root);
>> + =A0 =A0 while (node) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 tmp =3D node;
>> + =A0 =A0 =A0 =A0 =A0 =A0 node =3D rb_next(tmp);
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D rb_entry(tmp, struct cifs_sid_i=
d, rbnode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (nr_to_scan =3D=3D 0 || *nr_del =3D=3D =
nr_to_scan)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++(*nr_rem);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(jiffies, ps=
idid->time + SID_MAP_EXPIRE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 && psidid->refcount =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(t=
mp, root);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++(*nr_del=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++(*nr_rem=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +}
>>
>> =A0/*
>> =A0 * Run idmap cache shrinker.
>> @@ -62,9 +88,21 @@ static const struct cred *root_cred;
>> =A0static int
>> =A0cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_=
t gfp_mask)
>> =A0{
>> - =A0 =A0 /* Use a pruning scheme in a subsequent patch instead */
>> - =A0 =A0 cifs_destroy_idmaptrees();
>> - =A0 =A0 return 0;
>> + =A0 =A0 int nr_del =3D 0;
>> + =A0 =A0 int nr_rem =3D 0;
>> + =A0 =A0 struct rb_root *root;
>> +
>> + =A0 =A0 root =3D &uidtree;
>> + =A0 =A0 spin_lock(&siduidlock);
>> + =A0 =A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
>> + =A0 =A0 spin_unlock(&siduidlock);
>> +
>> + =A0 =A0 root =3D &gidtree;
>> + =A0 =A0 spin_lock(&sidgidlock);
>> + =A0 =A0 shrink_idmap_tree(root, nr_to_scan, &nr_rem, &nr_del);
>> + =A0 =A0 spin_unlock(&sidgidlock);
>> +
>> + =A0 =A0 return nr_rem;
>> =A0}
>>
>> =A0static struct shrinker cifs_shrinker =3D {
>> @@ -92,7 +130,6 @@ cifs_idmap_key_destroy(struct key *key)
>> =A0 =A0 =A0 kfree(key->payload.data);
>> =A0}
>>
>> -static
>> =A0struct key_type cifs_idmap_key_type =3D {
>> =A0 =A0 =A0 .name =A0 =A0 =A0 =A0=3D "cifs.cifs_idmap",
>> =A0 =A0 =A0 .instantiate =3D cifs_idmap_key_instantiate,
>> @@ -101,6 +138,216 @@ struct key_type cifs_idmap_key_type =3D {
>> =A0 =A0 =A0 .match =A0 =A0 =A0 =3D user_match,
>> =A0};
>>
>> +static void
>> +sid_to_str(struct cifs_sid *sidptr, char *sidstr)
>> +{
>> + =A0 =A0 int i;
>> + =A0 =A0 unsigned long saval;
>> + =A0 =A0 char *strptr;
>> +
>> + =A0 =A0 strptr =3D sidstr;
>> +
>> + =A0 =A0 sprintf(strptr, "%s", "S");
>> + =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> +
>> + =A0 =A0 sprintf(strptr, "-%d", sidptr->revision);
>> + =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> +
>> + =A0 =A0 for (i =3D 0; i < 6; ++i) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (sidptr->authority[i]) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "-%d", sid=
ptr->authority[i]);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + strlen=
(sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 for (i =3D 0; i < sidptr->num_subauth; ++i) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 saval =3D le32_to_cpu(sidptr->sub_auth[i])=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 sprintf(strptr, "-%ld", saval);
>> + =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D sidstr + strlen(sidstr);
>> + =A0 =A0 }
>> +}
>> +
>> +static void
>> +id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sid_id **psidid, char *typestr=
)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 char *strptr;
>> + =A0 =A0 struct rb_node *node =3D root->rb_node;
>> + =A0 =A0 struct rb_node *parent =3D NULL;
>> + =A0 =A0 struct rb_node **linkto =3D &(root->rb_node);
>> + =A0 =A0 struct cifs_sid_id *lsidid;
>> +
>> + =A0 =A0 while (node) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 lsidid =3D rb_entry(node, struct cifs_sid_=
id, rbnode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 parent =3D node;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D compare_sids(sidptr, &((lsidid)->si=
d));
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_left=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (rc < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_righ=
t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 memcpy(&(*psidid)->sid, sidptr, sizeof(struct cifs_sid));
>> + =A0 =A0 (*psidid)->time =3D jiffies - (SID_MAP_RETRY + 1);
>> + =A0 =A0 (*psidid)->refcount =3D 0;
> =A0 =A0 =A0 =A0^^^^^^^^^^^^
> =A0 =A0 =A0 =A0nit: if you initialize the refcount to 1, then you won=
't need
> =A0 =A0 =A0 =A0to increment it after insertion into the tree.
>> +

Jeff, yes, I could do that. I thought the code will be consistent

++psid->refcount;
spin_unlock(cidlock);

everywhere.

>> + =A0 =A0 sprintf((*psidid)->sidstr, "%s", typestr);
>> + =A0 =A0 strptr =3D (*psidid)->sidstr + strlen((*psidid)->sidstr);
>> + =A0 =A0 sid_to_str(&(*psidid)->sid, strptr);
>> +
>> + =A0 =A0 clear_bit(SID_ID_PENDING, &(*psidid)->state);
>> + =A0 =A0 clear_bit(SID_ID_MAPPED, &(*psidid)->state);
>> +
>> + =A0 =A0 rb_link_node(&(*psidid)->rbnode, parent, linkto);
>> + =A0 =A0 rb_insert_color(&(*psidid)->rbnode, root);
>> +}
>> +
>> +static struct cifs_sid_id *
>> +id_rb_search(struct rb_root *root, struct cifs_sid *sidptr)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 struct rb_node *node =3D root->rb_node;
>> + =A0 =A0 struct rb_node *parent =3D NULL;
>> + =A0 =A0 struct rb_node **linkto =3D &(root->rb_node);
>> + =A0 =A0 struct cifs_sid_id *lsidid;
>> +
>> + =A0 =A0 while (node) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 lsidid =3D rb_entry(node, struct cifs_sid_=
id, rbnode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 parent =3D node;
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D compare_sids(sidptr, &((lsidid)->si=
d));
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc > 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_left=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (rc < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 linkto =3D &(node->rb_righ=
t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else /* node found */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return lsidid;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return NULL;
>> +}
>> +
>> +static int
>> +sidid_pending_wait(void *unused)
>> +{
>> + =A0 =A0 schedule();
>> + =A0 =A0 return signal_pending(current) ? -ERESTARTSYS : 0;
>> +}
>> +
>> +static int
>> +sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_fattr *fattr, uint sidtype)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 unsigned long cid;
>> + =A0 =A0 struct key *idkey;
>> + =A0 =A0 const struct cred *saved_cred;
>> + =A0 =A0 struct cifs_sid_id *psidid, *npsidid;
>> + =A0 =A0 struct rb_root *cidtree;
>> + =A0 =A0 spinlock_t *cidlock;
>> +
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cid =3D cifs_sb->mnt_uid; /* default uid, =
in case upcall fails */
>> + =A0 =A0 =A0 =A0 =A0 =A0 cidlock =3D &siduidlock;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cidtree =3D &uidtree;
>> + =A0 =A0 } else if (sidtype =3D=3D SIDGROUP) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cid =3D cifs_sb->mnt_gid; /* default gid, =
in case upcall fails */
>> + =A0 =A0 =A0 =A0 =A0 =A0 cidlock =3D &sidgidlock;
>> + =A0 =A0 =A0 =A0 =A0 =A0 cidtree =3D &gidtree;
>> + =A0 =A0 } else
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
>> +
>> + =A0 =A0 spin_lock(cidlock);
>> + =A0 =A0 psidid =3D id_rb_search(cidtree, psid);
>> +
>> + =A0 =A0 if (!psidid) { /* node does not exist, allocate one & atte=
mpt adding */
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 npsidid =3D kzalloc(sizeof(struct cifs_sid=
_id), GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!npsidid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 npsidid->sidstr =3D kmalloc(SIDLEN, GFP_KE=
RNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!npsidid->sidstr) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(npsidid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(cidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_search(cidtree, psid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (psidid) { /* node happened to get inse=
rted meanwhile */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++psidid->refcount;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(npsidid->sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(npsidid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D npsidid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id_rb_insert(cidtree, psid=
, &psidid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sidtype =3D=3D SIDOWNER ? "os:" : "gs:");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++psidid->refcount;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 ++psidid->refcount;
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 /*
>> + =A0 =A0 =A0* If we are here, it is safe to access psidid and its f=
ields
>> + =A0 =A0 =A0* since a reference was taken earlier while holding the=
 spinlock.
>> + =A0 =A0 =A0*/
>> + =A0 =A0 if (test_bit(SID_ID_MAPPED, &psidid->state)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cid =3D psidid->id;
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid->time =3D jiffies; /* update ts for=
 accessing */
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto sid_to_id_out;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (time_after(psidid->time + SID_MAP_RETRY, jiffies))
>> + =A0 =A0 =A0 =A0 =A0 =A0 goto sid_to_id_out;
>> +
>> + =A0 =A0 if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 saved_cred =3D override_creds(root_cred);
>> + =A0 =A0 =A0 =A0 =A0 =A0 idkey =3D request_key(&cifs_idmap_key_type=
, psidid->sidstr, "");
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(idkey))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Can't map SID=
 to an id", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cid =3D *(unsigned long *)=
idkey->payload.value;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->id =3D cid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(SID_ID_MAPPED, &ps=
idid->state);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(idkey);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(psidid->sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 revert_creds(saved_cred);
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid->time =3D jiffies; /* update ts for=
 accessing */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Note that here you're setting the time=
stamp after the
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(possible) upcall. Is that what you wa=
nt? That means
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0that your next retry attempt will be S=
ID_MAP_RETRY
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0jiffies after this call returned, not =
after it was
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0initiated. If the upcall takes a long =
time to return
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0then you may end up delaying retries f=
or quite some time.

Yes, I wanted to be that way. I was thinking then either if the entry
gets successfully mapped, it would stay (as it is valid and likely
to get accessed e.g. Group SIDs) for the duration of SID_MAP_EXPIRE
or the mapping was successful, we want to wait for the duration
of SID_MAP_RETRY since it failed i.e. upcall returns with an error,
to re-attempt.

>
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_PENDING, &psidid->state);
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up_bit(&psidid->state, SID_ID_PENDING=
);
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_on_bit(&psidid->state, SID_ID_=
PENDING,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidid_pend=
ing_wait, TASK_INTERRUPTIBLE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: sidid_pending=
_wait interrupted %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 __func__, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 --psidid->refcount;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0So you're incrementing=
 the refcount while
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0holding a lock, but de=
crementing it without
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0one. That's a rather o=
dd set of locking rules.
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0If it is safe to do it=
 this way, it deserves a
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0comment explaining why=
 (maybe somewhere near
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0the field declaration)=
=2E

I will add a comment. Yes it is odd. But we are accessing other
fields of psidid without holding lock. The refcount is guarading
from the node/psidid ptr from disappearing, so I felt it safe to
decrement the count without holding the spinlock.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(SID_ID_MAPPED, &psidid->state=
))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cid =3D psidid->id;
>> + =A0 =A0 }
>> +
>> +sid_to_id_out:
>> + =A0 =A0 --psidid->refcount;
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_uid =3D cid;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_gid =3D cid;
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> =A0int
>> =A0init_cifs_idmap(void)
>> =A0{
>> @@ -242,16 +489,24 @@ int compare_sids(const struct cifs_sid *ctsid,=
 const struct cifs_sid *cwsid)
>> =A0 =A0 =A0 int num_subauth, num_sat, num_saw;
>>
>> =A0 =A0 =A0 if ((!ctsid) || (!cwsid))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>>
>> =A0 =A0 =A0 /* compare the revision */
>> - =A0 =A0 if (ctsid->revision !=3D cwsid->revision)
>> - =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 if (ctsid->revision !=3D cwsid->revision) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->revision > cwsid->revision)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 /* compare all of the six auth values */
>> =A0 =A0 =A0 for (i =3D 0; i < 6; ++i) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->authority[i] !=3D cwsid->author=
ity[i])
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->authority[i] !=3D cwsid->author=
ity[i]) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->authority[i] > =
cwsid->authority[i])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 /* compare all of the subauth values if any */
>> @@ -260,12 +515,16 @@ int compare_sids(const struct cifs_sid *ctsid,=
 const struct cifs_sid *cwsid)
>> =A0 =A0 =A0 num_subauth =3D num_sat < num_saw ? num_sat : num_saw;
>> =A0 =A0 =A0 if (num_subauth) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 for (i =3D 0; i < num_subauth; ++i) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->sub_auth[i] !=3D=
 cwsid->sub_auth[i])
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid->sub_auth[i] !=3D=
 cwsid->sub_auth[i]) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ctsid-=
>sub_auth[i] > cwsid->sub_auth[i])
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 return 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 return -1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 return 1; /* sids compare/match */
>> + =A0 =A0 return 0; /* sids compare/match */
>> =A0}
>>
>>
>> @@ -520,22 +779,22 @@ static void parse_dacl(struct cifs_acl *pdacl,=
 char *end_of_acl,
>> =A0#ifdef CONFIG_CIFS_DEBUG2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dump_ace(ppace[i], end_o=
f_acl);
>> =A0#endif
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), pownersid))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), pownersid) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_f=
lags_to_mode(ppace[i]->access_req,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&user_mask);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), pgrpsid))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), pgrpsid) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_f=
lags_to_mode(ppace[i]->access_req,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&group_mask);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), &sid_everyone))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), &sid_everyone) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_f=
lags_to_mode(ppace[i]->access_req,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&other_mask);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), &sid_authusers))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (compare_sids(&(ppace[i=
]->sid), &sid_authusers) =3D=3D 0)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_f=
lags_to_mode(ppace[i]->access_req,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ppace[i]->type,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fattr->cf_mode,
>> @@ -613,10 +872,10 @@ static int parse_sid(struct cifs_sid *psid, ch=
ar *end_of_acl)
>>
>>
>> =A0/* Convert CIFS ACL to POSIX form */
>> -static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_fattr *fat=
tr)
>> +static int parse_sec_desc(struct cifs_sb_info *cifs_sb,
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pntsd, int acl_len, stru=
ct cifs_fattr *fattr)
>> =A0{
>> - =A0 =A0 int rc;
>> + =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
>> =A0 =A0 =A0 struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
>> =A0 =A0 =A0 char *end_of_acl =3D ((char *)pntsd) + acl_len;
>> @@ -638,12 +897,26 @@ static int parse_sec_desc(struct cifs_ntsd *pn=
tsd, int acl_len,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_to_cpu(pntsd->sacloffset), daclo=
ffset);
>> =A0/* =A0 cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
>> =A0 =A0 =A0 rc =3D parse_sid(owner_sid_ptr, end_of_acl);
>> - =A0 =A0 if (rc)
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d parsing Owner SID", =
__func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> + =A0 =A0 rc =3D sid_to_id(cifs_sb, owner_sid_ptr, fattr, SIDOWNER);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Owner SID to=
 uid", __func__, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 rc =3D parse_sid(group_sid_ptr, end_of_acl);
>> - =A0 =A0 if (rc)
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Owner SID to=
 gid", __func__, rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> + =A0 =A0 rc =3D sid_to_id(cifs_sb, group_sid_ptr, fattr, SIDGROUP);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Group SID to=
 gid", __func__, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>>
>> =A0 =A0 =A0 if (dacloffset)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 parse_dacl(dacl_ptr, end_of_acl, owner_s=
id_ptr,
>> @@ -658,7 +931,7 @@ static int parse_sec_desc(struct cifs_ntsd *pnts=
d, int acl_len,
>> =A0 =A0 =A0 memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_pt=
r,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct cifs_sid))=
; */
>>
>> - =A0 =A0 return 0;
>> + =A0 =A0 return rc;
>> =A0}
>>
>>
>> @@ -865,7 +1138,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,=
 struct cifs_fattr *fattr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(pntsd);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: error %d getting sec desc=
", __func__, rc);
>> =A0 =A0 =A0 } else {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D parse_sec_desc(pntsd, acllen, fattr=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D parse_sec_desc(cifs_sb, pntsd, acll=
en, fattr);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pntsd);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "parse sec des=
c failed rc =3D %d", rc);
>> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
>> index c4ae7d0..4aee974 100644
>> --- a/fs/cifs/cifsacl.h
>> +++ b/fs/cifs/cifsacl.h
>> @@ -39,6 +39,15 @@
>> =A0#define ACCESS_ALLOWED =A0 =A0 =A0 0
>> =A0#define ACCESS_DENIED =A0 =A0 =A0 =A01
>>
>> +#define SIDOWNER 1
>> +#define SIDGROUP 2
>> +#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub autho=
rities */
>> +
>> +#define SID_ID_MAPPED 0
>> +#define SID_ID_PENDING 1
>> +#define SID_MAP_EXPIRE (3600 * HZ) /* map entry expires after one h=
our */
>> +#define SID_MAP_RETRY (300 * HZ) =A0 /* wait 5 minutes for next att=
empt to map */
>> +
>> =A0struct cifs_ntsd {
>> =A0 =A0 =A0 __le16 revision; /* revision level */
>> =A0 =A0 =A0 __le16 type;
>> @@ -74,6 +83,21 @@ struct cifs_wksid {
>> =A0 =A0 =A0 char sidname[SIDNAMELENGTH];
>> =A0} __attribute__((packed));
>>
>> +struct cifs_sid_id {
>> + =A0 =A0 unsigned int refcount;
>> + =A0 =A0 unsigned long id;
>> + =A0 =A0 unsigned long time;
>> + =A0 =A0 unsigned long state;
>> + =A0 =A0 char *sidstr;
>> + =A0 =A0 struct rb_node rbnode;
>> + =A0 =A0 struct cifs_sid sid;
>> +};
>> +
>> +#ifdef __KERNEL__
>> +extern struct key_type cifs_idmap_key_type;
>> +extern const struct cred *root_cred;
>> +#endif /* KERNEL */
>> +
>> =A0extern int match_sid(struct cifs_sid *);
>> =A0extern int compare_sids(const struct cifs_sid *, const struct cif=
s_sid *);
>>
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>
