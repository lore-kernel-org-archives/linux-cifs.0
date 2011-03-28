From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Invoke id mapping functions (try #10)
Date: Mon, 28 Mar 2011 14:11:14 -0500
Message-ID: <AANLkTikQPJe7oCOvyP960tyKXroPJM1jU9wbdfQCJpFC@mail.gmail.com>
References: <1300986024-7221-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110328150234.21613793@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110328150234.21613793-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Mar 28, 2011 at 2:02 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 24 Mar 2011 12:00:24 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>
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
>
> That default seems reasonable, I think...
>
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
>> + =A0 =A0 if (!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (!test_bit(SID_ID_MAPPED, &psidid->stat=
e)) {
>
> Overall this looks a lot better. The above however is a bit
> questionable. Every time you find an entry in the tree, you then mark
> it PENDING and check to see if it's MAPPED.
>
> These entries are never going to go from being MAPPED to not. Would i=
t
> instead make more sense to check whether it's MAPPED first, and only
> then try to set the PENDING bit?
>
> if (!test_bit(SID_ID_MAPPED, &psidid->state) &&
> =A0 =A0!test_and_set_bit(SID_ID_PENDING, &psidid->state)) {
> =A0 =A0 =A0 =A0/* construct the entry */
> } else {
> =A0 =A0/* wait on the PENDING bit */
> }
>
> The reason for this would be to minimize the times that you're going =
to
> set the PENDING bit, and force other threads to serialize behind it.
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* node with unmapped SID =
*/
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
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(SID_ID_PENDING, &psidid->state);
>> + =A0 =A0 =A0 =A0 =A0 =A0 wake_up_bit(&psidid->state, SID_ID_PENDING=
);
>> + =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* either an existing node with SID mapp=
ed (in which case
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* we would not wait) or a node whose SI=
D is being mapped by
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0* somebody else (in which case, we woul=
d end up waiting).
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D wait_on_bit(&psidid->state, SID_ID_=
PENDING,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidid_pend=
ing_wait, TASK_INTERRUPTIBLE);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "%s: sidid_pending=
_wait interrupted %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __func__, =
rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 }
>> +
>> +
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>

Jeff, Thanks.
yes, that is correct. Testing for a mapped id before attempting to
do map it if not, makes sense.
Will respin and resubmit the patch.

Regards,

Shirish
