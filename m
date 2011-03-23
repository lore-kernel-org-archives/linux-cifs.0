From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #9)
Date: Wed, 23 Mar 2011 13:37:27 -0500
Message-ID: <AANLkTi=tp6xKkech-AGqAVQQCVHNtwQPxCkLNLowP2Cv@mail.gmail.com>
References: <1300722168-29155-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110323142909.1aab266b@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110323142909.1aab266b-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Mar 23, 2011 at 1:29 PM, Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org> =
wrote:
> On Mon, 21 Mar 2011 10:42:48 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> rb tree search and insertion routines.
>>
>> A SID which needs to be mapped, is looked up in one of the rb trees
>> depending whether SID is either owner or group SID.
>> If found in the tree, a (mapped) id from that node is assigned to
>> uid or gid as appropriate. =A0If upcall returns an error, mapping
>> is retried after a timeout period but the default uid and gid are
>> uid and gid off of superblock respectively.
>>
>> Otherwise, an node is inserted in the tree and a mapping id for
>> that SID is looked-up with the help of Winbind via upcall mechanism.
>> If, for whatever reasons, winbind calls return error, SID for an
>> owner is mapped to 'nobody' and SID for a group is mapped to 'nogrou=
p'.
>>
>> To map a SID, which can be either a Owner SID or a Group SID, key
>> description starts with the string "os" or "gs" followed by SID conv=
erted
>> to a string. Without "os" or "gs", cifs.upcall does not know whether
>> SID needs to be mapped to either an uid or a gid.
>>
>> Nodes in rb tree as fields to prevent multiple upcalls for
>> a SID. =A0Adding and removing nodes is done within global locks.
>> shrinker routine does not prune a node if mapping for that node
>> is either pending or or node was recently created (before timeout
>> period expires and node could be purged). The timeout period should
>> be long enough at least for an upcall to return back to cifs.
>>
>> For now, cifs.upcall is only used to map a SID to an id (uid or gid)=
 but
>> it would be used to obtain an SID (string) for an id.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c | =A0322 ++++++++++++++++++++++++++++++++++++++=
+++++++++++----
>> =A0fs/cifs/cifsacl.h | =A0 24 ++++
>> =A02 files changed, 322 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index c60bb90..972aa12 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -54,7 +54,31 @@ static const struct cifs_sid sid_authusers =3D {
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (time_after(psidid->time + SID_MAP_EXPI=
RE, jiffies) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_bit(S=
ID_ID_PENDING, &psidid->state) ||
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (nr_to_sca=
n =3D=3D 0) || (*nr_del =3D=3D nr_to_scan))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++(*nr_rem);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rb_erase(tmp, root);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++(*nr_del);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +}
>>
>> =A0/*
>> =A0 * Run idmap cache shrinker.
>> @@ -62,11 +86,24 @@ static const struct cred *root_cred;
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
>> +
>> =A0static struct shrinker cifs_shrinker =3D {
>> =A0 =A0 =A0 .shrink =3D cifs_idmap_shrinker,
>> =A0 =A0 =A0 .seeks =3D DEFAULT_SEEKS,
>> @@ -92,7 +129,6 @@ cifs_idmap_key_destroy(struct key *key)
>> =A0 =A0 =A0 kfree(key->payload.data);
>> =A0}
>>
>> -static
>> =A0struct key_type cifs_idmap_key_type =3D {
>> =A0 =A0 =A0 .name =A0 =A0 =A0 =A0=3D "cifs.cifs_idmap",
>> =A0 =A0 =A0 .instantiate =3D cifs_idmap_key_instantiate,
>> @@ -101,6 +137,218 @@ struct key_type cifs_idmap_key_type =3D {
>> =A0 =A0 =A0 .match =A0 =A0 =A0 =3D user_match,
>> =A0};
>>
>> +static struct cifs_sid_id *
>> +id_rb_lookup(struct rb_root *root, struct cifs_sid *sidptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct rb_node **sparent, struct rb_node *=
**slinkto)
>> +{
>> + =A0 =A0 int rc;
>> + =A0 =A0 struct cifs_sid_id *lsidid;
>> + =A0 =A0 struct rb_node *node =3D root->rb_node;
>> + =A0 =A0 struct rb_node *parent =3D NULL;
>> + =A0 =A0 struct rb_node **linkto =3D &(root->rb_node);
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
>> + =A0 =A0 if (sparent && slinkto) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 *sparent =3D parent;
>> + =A0 =A0 =A0 =A0 =A0 =A0 *slinkto =3D linkto;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return NULL;
>> +}
>> +
>> +static struct cifs_sid_id *
>> +id_rb_add(struct rb_root *root, struct cifs_sid *sidptr, bool *sidm=
ap,
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sid_id **psidid)
>> +{
>> + =A0 =A0 struct cifs_sid_id *lsidid;
>> + =A0 =A0 struct rb_node *parent;
>> + =A0 =A0 struct rb_node **linkto;
>> +
>> + =A0 =A0 lsidid =3D id_rb_lookup(root, sidptr, &parent, &linkto);
>> + =A0 =A0 if (!lsidid) { /* node did not happen to get added, so add=
 it */
>> + =A0 =A0 =A0 =A0 =A0 =A0 *sidmap =3D false;
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&(*psidid)->sid, sidptr, sizeof(str=
uct cifs_sid));
>> + =A0 =A0 =A0 =A0 =A0 =A0 set_bit(SID_ID_PENDING, &(*psidid)->state)=
;
>> + =A0 =A0 =A0 =A0 =A0 =A0 set_bit(SID_ID_UNMAPPED, &(*psidid)->state=
);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 rb_link_node(&(*psidid)->rbnode, parent, l=
inkto);
>> + =A0 =A0 =A0 =A0 =A0 =A0 rb_insert_color(&(*psidid)->rbnode, root);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return lsidid;
>> +}
>> +
>> +static struct cifs_sid_id *
>> +id_rb_search(struct rb_root *root, struct cifs_sid *sidptr, bool *s=
idmap)
>> +{
>> + =A0 =A0 struct cifs_sid_id *lsidid;
>> +
>> + =A0 =A0 lsidid =3D id_rb_lookup(root, sidptr, NULL, NULL);
>> + =A0 =A0 if (lsidid) { /* node found */
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(SID_ID_UNMAPPED, &(lsidid)->s=
tate) &&
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 !time_afte=
r((lsidid)->retry + SID_MAP_RETRY,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 jiffies)) { /* unmapped SID */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!test_and_set_bit(SID_=
ID_PENDING, &(lsidid)->state))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *sidmap =3D=
 false; /* get to retry mapping */
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return lsidid;
>> +}
>> +
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
>> +static int
>> +cifs_sid_pending_wait(void *unused)
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
>> + =A0 =A0 unsigned long id;
>> + =A0 =A0 bool sidmap =3D true;
>> + =A0 =A0 char *strptr;
>> + =A0 =A0 struct key *idkey;
>> + =A0 =A0 const struct cred *saved_cred;
>> + =A0 =A0 struct cifs_sid_id *psidid =3D NULL;
>> + =A0 =A0 struct cifs_sid_id *epsidid =3D NULL;
>> +
>> + =A0 =A0 if (sidtype !=3D SIDOWNER && sidtype !=3D SIDGROUP)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
>> +
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 id =3D cifs_sb->mnt_uid;

Jeff, quick comment, id is not uninitialized. It is initialized here,
in case upcall fails.

>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&siduidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_search(&uidtree, psid, &s=
idmap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&siduidlock);
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 id =3D cifs_sb->mnt_gid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&sidgidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_search(&gidtree, psid, &s=
idmap);
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&sidgidlock);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (!psidid) { /* node does not exist, allocate one & atte=
mpt adding */
>> + =A0 =A0 =A0 =A0 =A0 =A0 epsidid =3D kzalloc(sizeof(struct cifs_sid=
_id), GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!epsidid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&siduidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_add(&uidt=
ree, psid, &sidmap, &epsidid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&siduidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&sidgidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_add(&gidt=
ree, psid, &sidmap, &epsidid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&sidgidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (psidid) /* node happened to get added =
meanwhile */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(epsidid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D epsidid;
>> + =A0 =A0 }
>> +
>
> This code is really hard to follow. The functions have names that don=
't
> really match what they do. For instance, id_rb_add actually does a
> search *then* and add if it doesn't find anything. There is also a lo=
t
> of unnecessary ** passing. There should be no need to pass a double
> pointer here. That makes the code unclear and is a red flag for later
> maintenance.
>
> This really should not be so complicated...
>
> Initialize the thing as PENDING before you try to insert it into the
> tree. Then search for an existing entry. If one is found, free the on=
e
> you just allocated and wait for that one's upcall to be completed.
>
> If one is not found, then the thread that allocated it should do the
> upcall. When it's done, then it wakes up anyone waiting for it to
> finish.
>
>> + =A0 =A0 if (sidmap =3D=3D false) { /* node with unmapped SID */
>> + =A0 =A0 =A0 =A0 =A0 =A0 memset(psidid->sidstr, '\0', SIDLEN);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(psidid->sidstr, "%=
s", "os:");
>> + =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(psidid->sidstr, "%=
s", "gs:");
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D psidid->sidstr + strlen(psidid-=
>sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 sid_to_str(psid, strptr);
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 saved_cred =3D override_creds(root_cred);
>> + =A0 =A0 =A0 =A0 =A0 =A0 idkey =3D request_key(&cifs_idmap_key_type=
, psidid->sidstr, "");
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(idkey))
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Can't map SID=
 to an id", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D *(unsigned long *)i=
dkey->payload.value;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(idkey);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_UNMAPPED,=
 &psidid->state);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid->time =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid->retry =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid->id =3D id;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^
> "id" is uninitialized if the upcall fails.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_PENDING, &psidid->state);
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up_bit(&psidid->state, SID_ID_PENDING=
);
>> + =A0 =A0 =A0 =A0 =A0 =A0 revert_creds(saved_cred);
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* either an existing node with SID mapp=
ed (in which case
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* we would not wait) or a node whose SI=
D is being mapped
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* by somebody else (in which case, we w=
ould end up waiting).
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_on_bit(&psidid->state, SID_ID_=
PENDING,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sid_p=
ending_wait, TASK_INTERRUPTIBLE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: cifs_sid_pend=
ing_wait interrupted %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 __func__, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* No point in checking whether state ha=
s bit SID_ID_UNMAPPED
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* set. If SID_ID_UNMAPPED state bit is =
not set, upcall must
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* have returned an error. =A0No point i=
n making an upcall here
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* again right away, it is likely to fai=
l.
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 id =3D psidid->id;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_uid =3D id;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_gid =3D id;
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>> =A0int
>> =A0init_cifs_idmap(void)
>> =A0{
>> @@ -242,16 +490,24 @@ int compare_sids(const struct cifs_sid *ctsid,=
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
>> @@ -260,12 +516,16 @@ int compare_sids(const struct cifs_sid *ctsid,=
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
>> @@ -520,22 +780,22 @@ static void parse_dacl(struct cifs_acl *pdacl,=
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
>> @@ -613,10 +873,10 @@ static int parse_sid(struct cifs_sid *psid, ch=
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
>> @@ -638,12 +898,26 @@ static int parse_sec_desc(struct cifs_ntsd *pn=
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
>> @@ -658,7 +932,7 @@ static int parse_sec_desc(struct cifs_ntsd *pnts=
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
>> @@ -865,7 +1139,7 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,=
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
>> index 025e943..555839e 100644
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
>> +#define SID_ID_PENDING 0
>> +#define SID_ID_UNMAPPED 1
>> +#define SID_MAP_EXPIRE 1000 /* enough for an upcall to return? */
>> +#define SID_MAP_RETRY 100 /* retry mapping in case prior attempt fa=
iled */
>> +
>> =A0struct cifs_ntsd {
>> =A0 =A0 =A0 __le16 revision; /* revision level */
>> =A0 =A0 =A0 __le16 type;
>> @@ -74,6 +83,21 @@ struct cifs_wksid {
>> =A0 =A0 =A0 char sidname[SIDNAMELENGTH];
>> =A0} __attribute__((packed));
>>
>> +struct cifs_sid_id {
>> + =A0 =A0 struct rb_node rbnode;
>> + =A0 =A0 struct cifs_sid sid;
>> + =A0 =A0 unsigned long state;
>> + =A0 =A0 unsigned long id;
>> + =A0 =A0 unsigned long time;
>> + =A0 =A0 unsigned long retry;
>> + =A0 =A0 char sidstr[SIDLEN];
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
