From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Percolate error up to the caller during get/set acls
Date: Tue, 9 Nov 2010 12:52:16 -0600
Message-ID: <AANLkTikgu1kS0hR3ENb6=v1YLOELR2tKomaAu7T_ViAm@mail.gmail.com>
References: <1289313302-31064-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101109124033.28393639@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101109124033.28393639-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 9, 2010 at 11:40 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Tue, =A09 Nov 2010 08:35:02 -0600
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Modify get/set_cifs_acl* calls to reutrn error code and percolate th=
e
>> error code up to the caller.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c | =A0 46 ++++++++++++++++++++++++++++++--------=
--------
>> =A01 files changed, 30 insertions(+), 16 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index c9b4792..003588a 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -568,8 +568,11 @@ static struct cifs_ntsd *get_cifs_acl_by_fid(st=
ruct cifs_sb_info *cifs_sb,
>>
>> =A0 =A0 =A0 cifs_put_tlink(tlink);
>>
>> - =A0 =A0 cFYI(1, "GetCIFSACL rc =3D %d ACL len %d", rc, *pacllen);
>> - =A0 =A0 return pntsd;
>> + =A0 =A0 cFYI(1, "%s: rc =3D %d ACL len %d", __func__, rc, *pacllen=
);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> + =A0 =A0 else
> =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0This else isn't needed
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 return pntsd;
>> =A0}
>>
>> =A0static struct cifs_ntsd *get_cifs_acl_by_path(struct cifs_sb_info=
 *cifs_sb,
>> @@ -591,19 +594,19 @@ static struct cifs_ntsd *get_cifs_acl_by_path(=
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
>> - =A0 =A0 return pntsd;
>> +
>> + =A0 =A0 cFYI(1, "%s: rc =3D %d ACL len %d", __func__, rc, *pacllen=
);
>> + =A0 =A0 if (rc)
>> + =A0 =A0 =A0 =A0 =A0 =A0 return ERR_PTR(rc);
>> + =A0 =A0 else
> =A0 =A0 =A0 =A0^^^^
> =A0 =A0 =A0 =A0Also not needed...
>
>> + =A0 =A0 =A0 =A0 =A0 =A0 return pntsd;
>> =A0}
>>
>> =A0/* Retrieve an ACL from the server */
>> @@ -711,12 +714,18 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb=
, struct cifs_fattr *fattr,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pntsd =3D get_cifs_acl(cifs_sb, inode, p=
ath, &acllen);
>>
>> =A0 =A0 =A0 /* if we can retrieve the ACL, now parse Access Control =
Entries, ACEs */
>> - =A0 =A0 if (pntsd)
>> + =A0 =A0 if (!pntsd)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: NULL sec desc", __func__);
> =A0 =A0 =A0 =A0^^^^^^^^
> =A0 =A0 =A0 =A0Will this ever be a null pointer? I don't think it wil=
l.
> =A0 =A0 =A0 =A0It's either going to be an ERR_PTR or a real cifs_ntsd=
=2E
> =A0 =A0 =A0 =A0I think that check isn't needed.

get_cifs_acl_by_pid/path can return NULL when the return thus

        if (IS_ERR(tlink))
                return NULL;

>
>> + =A0 =A0 else if (IS_ERR(pntsd)) {
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
>> =A0 =A0 =A0 return;
>> =A0}
>>
> =A0 =A0 =A0 =A0^^^^^
> Hmm, now that you're fixing this error, why not have it bubble up to
> cifs_get_inode_info too? It seems like cifs_acl_to_fattr could now
> return an int, and the caller should handle those errors.
>
>> @@ -736,7 +745,12 @@ int mode_to_acl(struct inode *inode, const char=
 *path, __u64 nmode)
>> =A0 =A0 =A0 /* Add three ACEs for owner, group, everyone getting rid=
 of
>> =A0 =A0 =A0 =A0 =A0other ACEs as chmod disables ACEs and set the sec=
urity descriptor */
>>
>> - =A0 =A0 if (pntsd) {
>> + =A0 =A0 if (!pntsd)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: NULL sec desc", __func__);
> =A0 =A0 =A0 =A0^^^^^^^^
> =A0 =A0 =A0 =A0Again, this pointer will never be NULL. This can be re=
moved.
>
>> + =A0 =A0 else if (IS_ERR(pntsd)) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(pntsd);
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: error %d getting sec desc",=
 __func__, rc);
>> + =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* allocate memory for the smb header,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set security descriptor request s=
ecurity descriptor
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0parameters, and secuirty descript=
or itself */
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
