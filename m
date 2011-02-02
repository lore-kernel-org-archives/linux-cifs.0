From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions
Date: Wed, 2 Feb 2011 09:40:36 -0600
Message-ID: <AANLkTim9EEC7P8z1xNB176N+R++N7OSBE4GKAbtzg795@mail.gmail.com>
References: <1295995034-8771-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1295995034-8771-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 25, 2011 at 4:37 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> rb tree search and insertion routines.
>
> A SID which needs to be mapped, is looked up in one of the rb trees
> depending whether SID is either owner or group SID.
> If found in a tree, a (mapped) id from that node is assigned to
> uid or gid as appropriated.
>
> Otherwise, the SID is mapped and looked-up with the help of
> Winbind via upcall mechanism and a node with mapping is inserted
> in one of the caches while again making sure that the node does not e=
xist.
>
> To map a SID, which can be either a Owner SID or a Group SID, key
> description starts with the string "os" or "gs" followed by SID conve=
rted
> to a string. Without "os" or "gs", cifs.upcall does not know whether
> SID needs to be mapped to either an uid or a gid.
>
> For now, cifs.upcall is only used to map a SID to an id (uid or gid) =
but
> it would be used to obtain an SID (string) for an id.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsacl.c | =A0213 +++++++++++++++++++++++++++++++++++++++=
+++++++++----
> =A0fs/cifs/cifsacl.h | =A0 15 ++++
> =A02 files changed, 211 insertions(+), 17 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index b165496..2b5294d 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -99,6 +99,159 @@ struct key_type cifs_idmap_key_type =3D {
> =A0 =A0 =A0 =A0.match =A0 =A0 =A0 =3D user_match,
> =A0};
>
> +static unsigned long
> +id_rb_search(struct rb_root *root, struct cifs_sid *sidptr)
> +{
> + =A0 =A0 =A0 unsigned int nds =3D 0;
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 unsigned long id =3D 0;
> + =A0 =A0 =A0 struct rb_node *node =3D root->rb_node;
> + =A0 =A0 =A0 struct cifs_sid_id *sididptr;
> +
> + =A0 =A0 =A0 while (node) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ++nds;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sididptr =3D rb_entry(node, struct cifs=
_sid_id, rbnode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D compare_sids(sidptr, &sididptr->=
sid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_left;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 node =3D node->rb_right=
;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D sididptr->id;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return id;
> +}
> +
> +static void
> +id_rb_insert(struct rb_root *root, struct cifs_sid_id *new_sididptr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned long id)
> +{
> + =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 struct rb_node **new =3D &(root->rb_node), *parent =3D =
NULL;
> + =A0 =A0 =A0 struct cifs_sid_id *sididptr;
> +
> + =A0 =A0 =A0 while (*new) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sididptr =3D rb_entry(*new, struct cifs=
_sid_id, rbnode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 parent =3D *new;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D compare_sids(&sididptr->sid, &ne=
w_sididptr->sid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new =3D &((*new)->rb_le=
ft);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 new =3D &((*new)->rb_ri=
ght);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(new_sididptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }

Jeff, this change is not sufficient to avoid the race in id_rb_insert()=
?
If compare_sids returns 0, that means the node/mapping already exists
i.e. the first racing thread grabbed the lock and inserted the mapping,
so the second racing thread discovers that and returns without insertin=
g
that node?  All of this happening within spin lock?

> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 rb_link_node(&new_sididptr->rbnode, parent, new);
> + =A0 =A0 =A0 rb_insert_color(&new_sididptr->rbnode, root);
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
> +sid_to_id(struct cifs_sid *psid, struct cifs_fattr *fattr, uint sidt=
ype)
> +{
> + =A0 =A0 =A0 int rc =3D 0;
> + =A0 =A0 =A0 unsigned long id;
> + =A0 =A0 =A0 char *sidstr, *strptr;
> + =A0 =A0 =A0 struct key *idkey;
> + =A0 =A0 =A0 const struct cred *saved_cred;
> + =A0 =A0 =A0 struct cifs_sid_id *sididptr;
> +
> + =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&siduidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D id_rb_search(&uidtree, psid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&siduidlock);
> + =A0 =A0 =A0 } else if (sidtype =3D=3D SIDGROUP) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lock(&sidgidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D id_rb_search(&gidtree, psid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&sidgidlock);
> + =A0 =A0 =A0 } else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOENT;
> +
> + =A0 =A0 =A0 if (!id) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidstr =3D kzalloc(SIDLEN, GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!sidstr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sididptr =3D kzalloc(sizeof(struct cifs=
_sid_id), GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!sididptr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(sidstr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sprintf(sidstr, "%s", "=
os:");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (sidtype =3D=3D SIDGROUP)
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
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Can't reso=
lve SID to an uid", __func__);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id =3D *(unsigned long =
*)idkey->payload.value;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 key_put(idkey);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(&sididptr->sid, =
psid, sizeof(struct cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sididptr->id =3D id;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (sidtype =3D=3D SIDO=
WNER) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lo=
ck(&siduidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id_rb_i=
nsert(&uidtree, sididptr, id);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&siduidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_lo=
ck(&sidgidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 id_rb_i=
nsert(&gidtree, sididptr, id);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_un=
lock(&sidgidlock);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 revert_creds(saved_cred);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(sidstr);
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (sidtype =3D=3D SIDOWNER)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_uid =3D id;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fattr->cf_gid =3D id;
> +
> + =A0 =A0 =A0 return rc;
> +}
> +
> =A0int
> =A0init_cifs_idmap(void)
> =A0{
> @@ -240,16 +393,24 @@ int compare_sids(const struct cifs_sid *ctsid, =
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
> @@ -258,12 +419,16 @@ int compare_sids(const struct cifs_sid *ctsid, =
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
> @@ -514,22 +679,22 @@ static void parse_dacl(struct cifs_acl *pdacl, =
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
> @@ -608,9 +773,9 @@ static int parse_sid(struct cifs_sid *psid, char =
*end_of_acl)
>
> =A0/* Convert CIFS ACL to POSIX form */
> =A0static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_fattr *=
fattr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_fattr *fatt=
r)
> =A0{
> - =A0 =A0 =A0 int rc;
> + =A0 =A0 =A0 int rc =3D 0;
> =A0 =A0 =A0 =A0struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
> =A0 =A0 =A0 =A0struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
> =A0 =A0 =A0 =A0char *end_of_acl =3D ((char *)pntsd) + acl_len;
> @@ -632,12 +797,26 @@ static int parse_sec_desc(struct cifs_ntsd *pnt=
sd, int acl_len,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 le32_to_cpu(pntsd->sacloffset), daclo=
ffset);
> =A0/* =A0 =A0 cifs_dump_mem("owner_sid: ", owner_sid_ptr, 64); */
> =A0 =A0 =A0 =A0rc =3D parse_sid(owner_sid_ptr, end_of_acl);
> - =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d parsing Owner SID=
", __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 rc =3D sid_to_id(owner_sid_ptr, fattr, SIDOWNER);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Owner SID=
 to uid", __func__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0rc =3D parse_sid(group_sid_ptr, end_of_acl);
> - =A0 =A0 =A0 if (rc)
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Owner SID=
 to uid", __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 rc =3D sid_to_id(group_sid_ptr, fattr, SIDGROUP);
> + =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: Error %d mapping Group SID=
 to uid", __func__, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0if (dacloffset)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parse_dacl(dacl_ptr, end_of_acl, owner=
_sid_ptr,
> @@ -652,7 +831,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd=
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
> diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
> index c4ae7d0..d103ad3 100644
> --- a/fs/cifs/cifsacl.h
> +++ b/fs/cifs/cifsacl.h
> @@ -39,6 +39,10 @@
> =A0#define ACCESS_ALLOWED 0
> =A0#define ACCESS_DENIED =A01
>
> +#define SIDOWNER 1
> +#define SIDGROUP 2
> +#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub author=
ities */
> +
> =A0struct cifs_ntsd {
> =A0 =A0 =A0 =A0__le16 revision; /* revision level */
> =A0 =A0 =A0 =A0__le16 type;
> @@ -74,6 +78,17 @@ struct cifs_wksid {
> =A0 =A0 =A0 =A0char sidname[SIDNAMELENGTH];
> =A0} __attribute__((packed));
>
> +struct cifs_sid_id {
> + =A0 =A0 =A0 struct rb_node rbnode;
> + =A0 =A0 =A0 struct cifs_sid sid;
> + =A0 =A0 =A0 unsigned long id;
> +} __attribute__((packed));
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
