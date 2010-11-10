From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set
 acls [try #3]
Date: Wed, 10 Nov 2010 06:28:01 -0600
Message-ID: <AANLkTik8FLi0WAT06S+jcYQGqyqjqVWxWabkBFQHpEv4@mail.gmail.com>
References: <1289341528-3675-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101110071936.162c988c@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101110071936.162c988c-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Nov 10, 2010 at 6:19 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, =A09 Nov 2010 16:25:28 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Modify get/set_cifs_acl* calls to reutrn error code and percolate th=
e
>> error code up to the caller.
>>
>> Even though, function cifs_acl_to_fattr() now returns a return code,
>> it is not yet handled by the caller of cifs_acl_to_fattr().
>> I would suggest to make that change, a part of another patch.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c =A0 | =A0 44 ++++++++++++++++++++++++++--------=
----------
>> =A0fs/cifs/cifsproto.h | =A0 =A02 +-
>> =A02 files changed, 27 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index c9b4792..cf53f7d 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -560,7 +560,7 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(str=
uct cifs_sb_info *cifs_sb,
>> =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
>>
>> =A0 =A0 =A0 if (IS_ERR(tlink))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ERR_CAST(tlink);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ERR_CAST doesn't do anything but recas=
t the pointer. Don't you want to return here?

Yes, my bad. Will fix this.

>
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> =A0 =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tlink_tcon(tlink), fid, &p=
ntsd, pacllen);
>> @@ -568,7 +568,9 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(str=
uct cifs_sb_info *cifs_sb,
>>
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>>
>> - =A0 =A0 cFYI(1, "GetCIFSACL rc =3D %d ACL len %d", rc, *pacllen);
>> + =A0 =A0 cFYI(1, "%s: rc =3D %d ACL len %d", __func__, rc, *pacllen=
);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> =A0 =A0 =A0 return pntsd;
>> =A0}
>>
>> @@ -583,7 +585,7 @@ static struct cifs_ntsd *get_cifs_acl_by_path(st=
ruct cifs_sb_info *cifs_sb,
>> =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
>>
>> =A0 =A0 =A0 if (IS_ERR(tlink))
>> - =A0 =A0 =A0 =A0 =A0 =A0 return NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 ERR_CAST(tlink);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0and here?
>>
>> =A0 =A0 =A0 tcon =3D tlink_tcon(tlink);
>> =A0 =A0 =A0 xid =3D GetXid();
>> @@ -591,18 +593,17 @@ static struct cifs_ntsd *get_cifs_acl_by_path(=
struct cifs_sb_info *cifs_sb,
>> =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, READ_CONT=
ROL, 0,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&fid, &oplock, NULL, =
cifs_sb->local_nls,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_fla=
gs & CIFS_MOUNT_MAP_SPECIAL_CHR);
>> - =A0 =A0 if (rc) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "Unable to open file to get ACL"=
);
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>> + =A0 =A0 if (!rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fid, &=
pntsd, pacllen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBClose(xid, tcon, fid);
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, tcon, fid, &pntsd, pacllen);
>> - =A0 =A0 cFYI(1, "GetCIFSACL rc =3D %d ACL len %d", rc, *pacllen);
>> -
>> - =A0 =A0 CIFSSMBClose(xid, tcon, fid);
>> - out:
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>> =A0 =A0 =A0 FreeXid(xid);
>> +
>> + =A0 =A0 cFYI(1, "%s: rc =3D %d ACL len %d", __func__, rc, *pacllen=
);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> =A0 =A0 =A0 return pntsd;
>> =A0}
>>
>> @@ -695,7 +696,7 @@ static int set_cifs_acl(struct cifs_ntsd *pnntsd=
, __u32 acllen,
>> =A0}
>>
>> =A0/* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mo=
de bits */
>> -void
>> +int
>> =A0cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr=
 *fattr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode, const char *pat=
h, const __u16 *pfid)
>> =A0{
>> @@ -711,13 +712,17 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb=
, struct cifs_fattr *fattr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pntsd =3D get_cifs_acl(cifs_sb, inode, p=
ath, &acllen);
>>
>> =A0 =A0 =A0 /* if we can retrieve the ACL, now parse Access Control =
Entries, ACEs */
>> - =A0 =A0 if (pntsd)
>> + =A0 =A0 if (IS_ERR(pntsd)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(pntsd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: error %d getting sec desc",=
 __func__, rc);
>> + =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D parse_sec_desc(pntsd, acllen, fat=
tr);
>> - =A0 =A0 if (rc)
>> - =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "parse sec desc failed rc =3D %d",=
 rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(pntsd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "parse sec desc =
failed rc =3D %d", rc);
>> + =A0 =A0 }
>>
>> - =A0 =A0 kfree(pntsd);
>> - =A0 =A0 return;
>> + =A0 =A0 return rc;
>> =A0}
>>
>> =A0/* Convert mode bits to an ACL so we can update the ACL on the se=
rver */
>> @@ -736,7 +741,10 @@ int mode_to_acl(struct inode *inode, const char=
 *path, __u64 nmode)
>> =A0 =A0 =A0 /* Add three ACEs for owner, group, everyone getting rid=
 of
>> =A0 =A0 =A0 =A0 =A0other ACEs as chmod disables ACEs and set the sec=
urity descriptor */
>>
>> - =A0 =A0 if (pntsd) {
>> + =A0 =A0 if (IS_ERR(pntsd)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(pntsd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: error %d getting sec desc",=
 __func__, rc);
>> + =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* allocate memory for the smb header,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set security descriptor request s=
ecurity descriptor
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parameters, and secuirty descript=
or itself */
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 7ed69b6..6ed59af 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -130,7 +130,7 @@ extern int cifs_get_file_info_unix(struct file *=
filp);
>> =A0extern int cifs_get_inode_info_unix(struct inode **pinode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char *sea=
rch_path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct super_block *sb, =
int xid);
>> -extern void cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
>> +extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_=
fattr *fattr, struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *=
path, const __u16 *pfid);
>> =A0extern int mode_to_acl(struct inode *inode, const char *path, __u=
64);
>
>
> Ok, so to be clear...the decision is to continue ignoring errors from
> cifs_acl_to_fattr in cifs_get_inode_info?

Yes. I would like to keep the scope of this patch to return back errors=
=2E
Will spend time on handling return code in cifs_acl_to_fattr and
in mode_to_acl.

>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
