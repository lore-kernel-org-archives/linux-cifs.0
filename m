From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #11)
Date: Tue, 29 Mar 2011 10:23:37 -0500
Message-ID: <AANLkTimSVQTr_4gkgo4LOoJ-9bszWknz69ERzPEbTtq5@mail.gmail.com>
References: <1301343901-28531-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110329093015.315caf36@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110329093015.315caf36-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Mar 29, 2011 at 8:30 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Mon, 28 Mar 2011 15:25:01 -0500
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
>> uid or gid as appropriate. =A0If unmapped, an upcall is attempted to
>> map the SID to an id. =A0If upcall is successful, node is marked as
>> mapped. =A0If upcall fails, node stays marked as unmapped and a mapp=
ing
>> is attempted again during next resolution.
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
>> =A0fs/cifs/cifsacl.c | =A0298 ++++++++++++++++++++++++++++++++++++++=
++++++++++-----
>> =A0fs/cifs/cifsacl.h | =A0 22 ++++
>> =A02 files changed, 296 insertions(+), 24 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index c60bb90..5b2ef73 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -54,7 +54,30 @@ static const struct cifs_sid sid_authusers =3D {
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
>> @@ -62,9 +85,21 @@ static const struct cred *root_cred;
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
>> @@ -92,7 +127,6 @@ cifs_idmap_key_destroy(struct key *key)
>> =A0 =A0 =A0 kfree(key->payload.data);
>> =A0}
>>
>> -static
>> =A0struct key_type cifs_idmap_key_type =3D {
>> =A0 =A0 =A0 .name =A0 =A0 =A0 =A0=3D "cifs.cifs_idmap",
>> =A0 =A0 =A0 .instantiate =3D cifs_idmap_key_instantiate,
>> @@ -101,6 +135,196 @@ struct key_type cifs_idmap_key_type =3D {
>> =A0 =A0 =A0 .match =A0 =A0 =A0 =3D user_match,
>> =A0};
>>
>> +static void
>> +id_rb_insert(struct rb_root *root, struct cifs_sid *sidptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_sid_id **psidid)
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 memcpy(&(*psidid)->sid, sidptr, sizeof(struct cifs_sid));
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
>> + =A0 =A0 char *strptr;
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
>> + =A0 =A0 spin_unlock(cidlock);
>> +
>> + =A0 =A0 if (!psidid) { /* node does not exist, allocate one & atte=
mpt adding */
>> + =A0 =A0 =A0 =A0 =A0 =A0 npsidid =3D kzalloc(sizeof(struct cifs_sid=
_id), GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!npsidid)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(cidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D id_rb_search(cidtree, psid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (psidid) { /* node happened to get inse=
rted meanwhile */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(npsidid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid =3D npsidid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id_rb_insert(cidtree, psid=
, &psidid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(cidlock);
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (!test_bit(SID_ID_MAPPED, &psidid->state)) { /* SID not=
 mapped */
>
> =A0 =A0 =A0 =A0^^^ nit: maybe just do:
>
> =A0 =A0 =A0 =A0if (test_bit(SID_ID_MAPPED...
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>
> =A0 =A0 =A0 =A0...or something. That would allow you to reduce the in=
dentation
> =A0 =A0 =A0 =A0of the code below and make it easier to read.
>

Will make this change.

>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!test_and_set_bit(SID_ID_PENDING, &psi=
did->state)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(psidid->sidstr, '\0=
', SIDLEN);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNE=
R)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(ps=
idid->sidstr, "%s", "os:");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(ps=
idid->sidstr, "%s", "gs:");
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strptr =3D psidid->sidstr =
+ strlen(psidid->sidstr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sid_to_str(psid, strptr);
>> +
>
> Would it be better to do the string handling above before you insert
> this struct into the tree? In the case where this thing can't be mapp=
ed,
> then you're going to have to re-convert the sid on every pass through
> this function. Just doing that once would make more sense, IMO...
>

Will address it.

> I wonder too...once this thing is mapped, then the above string will
> never be used again, will it? If so, would it be best to release that
> memory instead of keeping it around in the cache?

I think kmalloc the memory for string when node is allocated and free i=
t
once SID is mapped?  The string is really not needed at all once
a SID is mapped.

>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 saved_cred =3D override_cr=
eds(root_cred);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 idkey =3D request_key(&cif=
s_idmap_key_type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 psidid->sidstr, "");
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (IS_ERR(idkey)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->id=
 =3D cid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%=
s: Can't map SID to an id", __func__);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->id=
 =3D
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 *(unsigned long *)idkey->payload.value;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 psidid->ti=
me =3D jiffies;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 set_bit(SI=
D_ID_MAPPED, &psidid->state);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(id=
key);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 revert_creds(saved_cred);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_PENDING, =
&psidid->state);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up_bit(&psidid->state=
, SID_ID_PENDING);
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* either an existing no=
de with SID mapped (in which
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* case we would not wai=
t) or a node whose SID is
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* being mapped by someb=
ody else (in which case, we
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* would end up waiting)=
=2E
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_on_bit(&psidid=
->state, SID_ID_PENDING,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 sidid_pending_wait, TASK_INTERRUPTIBLE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%=
s: sidid_pending_wait interrupted %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 __func__, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (sidtype =3D=3D SIDOWNER)
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_uid =3D psidid->id;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_gid =3D psidid->id;
>> +
>> + =A0 =A0 return 0;
>> +}
>> +
>
> So let's consider the case where we have a directory with a lot of
> files in it that are owned by a user that can't be mapped. Someone do=
es
> a "ls -l" in that dir.
>
> Presumably, on every stat() call we'll call into this routine to map
> the SID to a unix uid. The MAPPED bit will never be set though, so
> we'll always call request_key().
>
> cifs.upcall will generally negatively instantiate the key with a 1s
> timeout. I think if request-key doesn't find a match (indicating that
> no one set up request-key.conf) then it negatively instantiates the k=
ey
> with a 60s timeout.
>
> Is that reasonable behavior here?
>

Not sure I understand the negative instantiation of key with a timeout.
I had a timeout field in some of the earlier patch versions whrere re-m=
apping
for an unmapped SID is attempted only after that timeout expires

> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
