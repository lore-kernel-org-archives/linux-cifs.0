From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Call id to SID mapping functions to change
 owner/group (try #3)
Date: Tue, 9 Aug 2011 12:56:18 -0500
Message-ID: <CAH2r5muG+JUpGWCeRt+vEvz-QE79zSP+bdRSDL-7_onUQBFXBw@mail.gmail.com>
References: <1312911217-22357-1-git-send-email-shirishpargonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1312911217-22357-1-git-send-email-shirishpargonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

You should break out the fix to incorrectly use find_readable_file
to change an acl (in existing code) rather than bundling it with the
new functions below.

On Tue, Aug 9, 2011 at 12:33 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Now build security descriptor to change either owner or group at the
> server. =A0Initially security descriptor was built to change only
> (D)ACL, that functionality has been extended.
>
> When either an Owner or a Group of a file object at the server is cha=
nged,
> rest of security descriptor remains same (DACL etc.).
>
> To set security descriptor, it is essential to open that file
> with permission bits of either WRITE_DAC if DACL is being modified or
> WRITE_OWNER (Take Ownership) if Owner or Group is being changed.
> Function set_cifs_acl_by_fid() has been removed since we can't be
> sure how a file was opened for writing, a valid request can fail
> if the file was not opened with two above mentioned permissions.
> We could have opted to add on WRITE_DAC and WRITE_OWNER permissions
> to file opens and then use that file handle but adding addtional
> permissions such as WRITE_DAC and WRITE_OWNER could cause an
> any open to fail.
>
> It is the server that decides whether a set security descriptor with
> either owner or group change succeeds or not.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/cifsacl.c =A0 | =A0156 ++++++++++++++++++++++++++---------=
----------------
> =A0fs/cifs/cifsproto.h | =A0 =A07 +-
> =A0fs/cifs/cifssmb.c =A0 | =A0 =A04 +-
> =A0fs/cifs/inode.c =A0 =A0 | =A0 35 ++++++++----
> =A0fs/cifs/xattr.c =A0 =A0 | =A0 =A02 +-
> =A05 files changed, 110 insertions(+), 94 deletions(-)
>
> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
> index b7e723a..aa4f5b5 100644
> --- a/fs/cifs/cifsacl.c
> +++ b/fs/cifs/cifsacl.c
> @@ -904,7 +904,7 @@ static void parse_dacl(struct cifs_acl *pdacl, ch=
ar *end_of_acl,
> =A0 =A0 =A0 =A0acl_size =3D sizeof(struct cifs_acl);
>
> =A0 =A0 =A0 =A0num_aces =3D le32_to_cpu(pdacl->num_aces);
> - =A0 =A0 =A0 if (num_aces =A0> 0) {
> + =A0 =A0 =A0 if (num_aces > 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t user_mask =3D S_IRWXU;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t group_mask =3D S_IRWXG;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t other_mask =3D S_IRWXU | S_IRW=
XG | S_IRWXO;
> @@ -1066,52 +1066,82 @@ static int parse_sec_desc(struct cifs_sb_info=
 *cifs_sb,
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "no ACL"); /* BB grant all or =
default perms? */
>
> -/* =A0 =A0 cifscred->uid =3D owner_sid_ptr->rid;
> - =A0 =A0 =A0 cifscred->gid =3D group_sid_ptr->rid;
> - =A0 =A0 =A0 memcpy((void *)(&(cifscred->osid)), (void *)owner_sid_p=
tr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct cifs_sid)=
);
> - =A0 =A0 =A0 memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_p=
tr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct cifs_sid)=
); */
> -
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -
> =A0/* Convert permission bits from mode to equivalent CIFS ACL */
> =A0static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_nts=
d *pnntsd,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
inode *inode, __u64 nmode)
> + =A0 =A0 =A0 __u32 secdesclen, __u64 nmode, uid_t uid, gid_t gid, in=
t *aclflag)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0__u32 dacloffset;
> =A0 =A0 =A0 =A0__u32 ndacloffset;
> =A0 =A0 =A0 =A0__u32 sidsoffset;
> =A0 =A0 =A0 =A0struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
> + =A0 =A0 =A0 struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
> =A0 =A0 =A0 =A0struct cifs_acl *dacl_ptr =3D NULL; =A0/* no need for =
SACL ptr */
> =A0 =A0 =A0 =A0struct cifs_acl *ndacl_ptr =3D NULL; /* no need for SA=
CL ptr */
>
> - =A0 =A0 =A0 if ((inode =3D=3D NULL) || (pntsd =3D=3D NULL) || (pnnt=
sd =3D=3D NULL))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
> -
> - =A0 =A0 =A0 owner_sid_ptr =3D (struct cifs_sid *)((char *)pntsd +
> + =A0 =A0 =A0 if (nmode !=3D NO_CHANGE_64) { /* chmod */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 owner_sid_ptr =3D (struct cifs_sid *)((=
char *)pntsd +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_t=
o_cpu(pntsd->osidoffset));
> - =A0 =A0 =A0 group_sid_ptr =3D (struct cifs_sid *)((char *)pntsd +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_sid_ptr =3D (struct cifs_sid *)((=
char *)pntsd +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_t=
o_cpu(pntsd->gsidoffset));
> -
> - =A0 =A0 =A0 dacloffset =3D le32_to_cpu(pntsd->dacloffset);
> - =A0 =A0 =A0 dacl_ptr =3D (struct cifs_acl *)((char *)pntsd + daclof=
fset);
> -
> - =A0 =A0 =A0 ndacloffset =3D sizeof(struct cifs_ntsd);
> - =A0 =A0 =A0 ndacl_ptr =3D (struct cifs_acl *)((char *)pnntsd + ndac=
loffset);
> - =A0 =A0 =A0 ndacl_ptr->revision =3D dacl_ptr->revision;
> - =A0 =A0 =A0 ndacl_ptr->size =3D 0;
> - =A0 =A0 =A0 ndacl_ptr->num_aces =3D 0;
> -
> - =A0 =A0 =A0 rc =3D set_chmod_dacl(ndacl_ptr, owner_sid_ptr, group_s=
id_ptr, nmode);
> -
> - =A0 =A0 =A0 sidsoffset =3D ndacloffset + le16_to_cpu(ndacl_ptr->siz=
e);
> -
> - =A0 =A0 =A0 /* copy security descriptor control portion and owner a=
nd group sid */
> - =A0 =A0 =A0 copy_sec_desc(pntsd, pnntsd, sidsoffset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dacloffset =3D le32_to_cpu(pntsd->daclo=
ffset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dacl_ptr =3D (struct cifs_acl *)((char =
*)pntsd + dacloffset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacloffset =3D sizeof(struct cifs_ntsd=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr =3D (struct cifs_acl *)((char=
 *)pnntsd + ndacloffset);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr->revision =3D dacl_ptr->revis=
ion;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr->size =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr->num_aces =3D 0;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D set_chmod_dacl(ndacl_ptr, owner_=
sid_ptr, group_sid_ptr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 nmode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidsoffset =3D ndacloffset + le16_to_cp=
u(ndacl_ptr->size);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy sec desc control portion & owne=
r and group sids */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 copy_sec_desc(pntsd, pnntsd, sidsoffset=
);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *aclflag =3D CIFS_ACL_DACL;
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(pnntsd, pntsd, secdesclen);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (uid !=3D NO_CHANGE_32) { /* chown *=
/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 owner_sid_ptr =3D (stru=
ct cifs_sid *)((char *)pnntsd +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(pnntsd->osidoffset));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nowner_sid_ptr =3D kmal=
loc(sizeof(struct cifs_sid),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!nowner_sid_ptr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_to_sid(uid, S=
IDOWNER, nowner_sid_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "%s: Mapping error %d for owner id %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 __func__, rc, uid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(n=
owner_sid_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(owner_sid_ptr, n=
owner_sid_ptr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(nowner_sid_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *aclflag =3D CIFS_ACL_O=
WNER;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (gid !=3D NO_CHANGE_32) { /* chgrp *=
/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_sid_ptr =3D (stru=
ct cifs_sid *)((char *)pnntsd +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(pnntsd->gsidoffset));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ngroup_sid_ptr =3D kmal=
loc(sizeof(struct cifs_sid),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ngroup_sid_ptr)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
-ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_to_sid(gid, S=
IDGROUP, ngroup_sid_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "%s: Mapping error %d for group id %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 __func__, rc, gid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(n=
group_sid_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
rc;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(group_sid_ptr, n=
group_sid_ptr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct cifs_sid));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ngroup_sid_ptr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *aclflag =3D CIFS_ACL_G=
ROUP;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 }
>
> =A0 =A0 =A0 =A0return rc;
> =A0}
> @@ -1189,31 +1219,15 @@ struct cifs_ntsd *get_cifs_acl(struct cifs_sb=
_info *cifs_sb,
> =A0 =A0 =A0 =A0return pntsd;
> =A0}
>
> -static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 f=
id,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnntsd, u32 acllen)
> -{
> - =A0 =A0 =A0 int xid, rc;
> - =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
> -
> - =A0 =A0 =A0 if (IS_ERR(tlink))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(tlink);
> -
> - =A0 =A0 =A0 xid =3D GetXid();
> - =A0 =A0 =A0 rc =3D CIFSSMBSetCIFSACL(xid, tlink_tcon(tlink), fid, p=
nntsd, acllen);
> - =A0 =A0 =A0 FreeXid(xid);
> - =A0 =A0 =A0 cifs_put_tlink(tlink);
> -
> - =A0 =A0 =A0 cFYI(DBG2, "SetCIFSACL rc =3D %d", rc);
> - =A0 =A0 =A0 return rc;
> -}
> -
> -static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, const =
char *path,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnntsd, u32 acllen)
> +/* Set an ACL on the server */
> +int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode, co=
nst char *path, int aclflag)
> =A0{
> =A0 =A0 =A0 =A0int oplock =3D 0;
> - =A0 =A0 =A0 int xid, rc;
> + =A0 =A0 =A0 int xid, rc, access_flags;
> =A0 =A0 =A0 =A0__u16 fid;
> =A0 =A0 =A0 =A0struct cifs_tcon *tcon;
> + =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> =A0 =A0 =A0 =A0struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
>
> =A0 =A0 =A0 =A0if (IS_ERR(tlink))
> @@ -1222,7 +1236,11 @@ static int set_cifs_acl_by_path(struct cifs_sb=
_info *cifs_sb, const char *path,
> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(tlink);
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> - =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_DA=
C, 0,
> + =A0 =A0 =A0 if (aclflag =3D=3D CIFS_ACL_OWNER || aclflag =3D=3D CIF=
S_ACL_GROUP)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_flags =3D WRITE_OWNER;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 access_flags =3D WRITE_DAC;
> + =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, access_f=
lags, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fid, &oplock, NULL, =
cifs_sb->local_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_fla=
gs & CIFS_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0if (rc) {
> @@ -1230,7 +1248,7 @@ static int set_cifs_acl_by_path(struct cifs_sb_=
info *cifs_sb, const char *path,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, acllen=
);
> + =A0 =A0 =A0 rc =3D CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, acllen=
, aclflag);
> =A0 =A0 =A0 =A0cFYI(DBG2, "SetCIFSACL rc =3D %d", rc);
>
> =A0 =A0 =A0 =A0CIFSSMBClose(xid, tcon, fid);
> @@ -1240,25 +1258,6 @@ out:
> =A0 =A0 =A0 =A0return rc;
> =A0}
>
> -/* Set an ACL on the server */
> -int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct =
inode *inode, const char *path)
> -{
> - =A0 =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> - =A0 =A0 =A0 struct cifsFileInfo *open_file;
> - =A0 =A0 =A0 int rc;
> -
> - =A0 =A0 =A0 cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inode=
->i_mode);
> -
> - =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_I(inode), true);
> - =A0 =A0 =A0 if (!open_file)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return set_cifs_acl_by_path(cifs_sb, pa=
th, pnntsd, acllen);
> -
> - =A0 =A0 =A0 rc =3D set_cifs_acl_by_fid(cifs_sb, open_file->netfid, =
pnntsd, acllen);
> - =A0 =A0 =A0 cifsFileInfo_put(open_file);
> - =A0 =A0 =A0 return rc;
> -}
> -
> =A0/* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mod=
e bits */
> =A0int
> =A0cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb, struct cifs_fattr =
*fattr,
> @@ -1290,9 +1289,12 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb=
, struct cifs_fattr *fattr,
> =A0}
>
> =A0/* Convert mode bits to an ACL so we can update the ACL on the ser=
ver */
> -int mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nm=
ode)
> +int
> +id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nmo=
de,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid_t uid, gid_t gid)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D 0;
> + =A0 =A0 =A0 int aclflag =3D CIFS_ACL_DACL; /* default flag to set *=
/
> =A0 =A0 =A0 =A0__u32 secdesclen =3D 0;
> =A0 =A0 =A0 =A0struct cifs_ntsd *pntsd =3D NULL; /* acl obtained from=
 server */
> =A0 =A0 =A0 =A0struct cifs_ntsd *pnntsd =3D NULL; /* modified acl to =
be sent to server */
> @@ -1322,13 +1324,15 @@ int mode_to_cifs_acl(struct inode *inode, con=
st char *path, __u64 nmode)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_sec_desc(pntsd, pnntsd, in=
ode, nmode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_sec_desc(pntsd, pnntsd, se=
cdesclen, nmode, uid, gid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &aclflag);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(DBG2, "build_sec_desc rc: %d", rc=
);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Set the security de=
scriptor */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D set_cifs_acl(pnn=
tsd, secdesclen, inode, path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D set_cifs_acl(pnn=
tsd, secdesclen, inode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 path, aclflag);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(DBG2, "set_cifs_a=
cl rc: %d", rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 8df28e9..c2b270c 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -145,11 +145,12 @@ extern int cifs_get_inode_info_unix(struct inod=
e **pinode,
> =A0extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cif=
s_fattr *fattr, struct inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const char=
 *path, const __u16 *pfid);
> -extern int mode_to_cifs_acl(struct inode *inode, const char *path, _=
_u64);
> +extern int id_mode_to_cifs_acl(struct inode *inode, const char *path=
, __u64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 uid_t, gid_t);
> =A0extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, struc=
t inode *,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0const char *, u32 *);
> =A0extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const c=
har *);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const c=
har *, int);
>
> =A0extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct ci=
fs_sb_info *cifs_sb);
> @@ -419,7 +420,7 @@ extern int CIFSSMBSetEA(const int xid, struct cif=
s_tcon *tcon,
> =A0extern int CIFSSMBGetCIFSACL(const int xid, struct cifs_tcon *tcon=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 fid, struct cifs=
_ntsd **acl_inf, __u32 *buflen);
> =A0extern int CIFSSMBSetCIFSACL(const int, struct cifs_tcon *, __u16,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *, __u=
32);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *, __u=
32, int);
> =A0extern int CIFSSMBGetPosixACL(const int xid, struct cifs_tcon *tco=
n,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *searchName,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *acl_inf, const int buflen, const=
 int acl_type,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index aac37d9..7efe40c 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -3467,7 +3467,7 @@ qsec_out:
>
> =A0int
> =A0CIFSSMBSetCIFSACL(const int xid, struct cifs_tcon *tcon, __u16 fid=
,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pntsd=
, __u32 acllen)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pntsd=
, __u32 acllen, int aclflag)
> =A0{
> =A0 =A0 =A0 =A0__u16 byte_count, param_count, data_count, param_offse=
t, data_offset;
> =A0 =A0 =A0 =A0int rc =3D 0;
> @@ -3504,7 +3504,7 @@ setCifsAclRetry:
>
> =A0 =A0 =A0 =A0pSMB->Fid =3D fid; /* file handle always le */
> =A0 =A0 =A0 =A0pSMB->Reserved2 =3D 0;
> - =A0 =A0 =A0 pSMB->AclFlags =3D cpu_to_le32(CIFS_ACL_DACL);
> + =A0 =A0 =A0 pSMB->AclFlags =3D cpu_to_le32(aclflag);
>
> =A0 =A0 =A0 =A0if (pntsd && acllen) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy((char *) &pSMBr->hdr.Protocol +=
 data_offset,
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index a7b2dcd..663c4e3 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2096,6 +2096,8 @@ static int
> =A0cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
> =A0{
> =A0 =A0 =A0 =A0int xid;
> + =A0 =A0 =A0 uid_t uid =3D NO_CHANGE_32;
> + =A0 =A0 =A0 gid_t gid =3D NO_CHANGE_32;
> =A0 =A0 =A0 =A0struct inode *inode =3D direntry->d_inode;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsInode =3D CIFS_I(inode);
> @@ -2146,13 +2148,25 @@ cifs_setattr_nounix(struct dentry *direntry, =
struct iattr *attrs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cifs_setattr_exit=
;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 /*
> - =A0 =A0 =A0 =A0* Without unix extensions we can't send ownership ch=
anges to the
> - =A0 =A0 =A0 =A0* server, so silently ignore them. This is consisten=
t with how
> - =A0 =A0 =A0 =A0* local DOS/Windows filesystems behave (VFAT, NTFS, =
etc). With
> - =A0 =A0 =A0 =A0* CIFSACL support + proper Windows to Unix idmapping=
, we may be
> - =A0 =A0 =A0 =A0* able to support this in the future.
> - =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (attrs->ia_valid & ATTR_UID)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid =3D attrs->ia_uid;
> +
> + =A0 =A0 =A0 if (attrs->ia_valid & ATTR_GID)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid =3D attrs->ia_gid;
> +
> +#ifdef CONFIG_CIFS_ACL
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (uid !=3D NO_CHANGE_32 || gid !=3D N=
O_CHANGE_32) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_mode_to_cifs_=
acl(inode, full_path, NO_CHANGE_64,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid, gid);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "%s: Setting id failed with error: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ci=
fs_setattr_exit;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 } else
> +#endif /* CONFIG_CIFS_ACL */
> =A0 =A0 =A0 =A0if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0attrs->ia_valid &=3D ~(ATTR_UID | ATTR=
_GID);
>
> @@ -2161,15 +2175,12 @@ cifs_setattr_nounix(struct dentry *direntry, =
struct iattr *attrs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0attrs->ia_valid &=3D ~ATTR_MODE;
>
> =A0 =A0 =A0 =A0if (attrs->ia_valid & ATTR_MODE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Mode changed to 0%o", attrs->i=
a_mode);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mode =3D attrs->ia_mode;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 if (attrs->ia_valid & ATTR_MODE) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D 0;
> =A0#ifdef CONFIG_CIFS_ACL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOU=
NT_CIFS_ACL) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mode_to_cifs_acl=
(inode, full_path, mode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_mode_to_cifs_=
acl(inode, full_path, mode,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NO_CHANGE_32, NO_CHANGE_32);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1=
, "%s: Setting ACL failed with error: %d",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0__func__, rc);
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 2a22fb2..fde15b1 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -178,7 +178,7 @@ int cifs_setxattr(struct dentry *direntry, const =
char *ea_name,
> =A0#ifdef CONFIG_CIFS_ACL
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(pacl, ea_value,=
 value_size);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D set_cifs_acl(pa=
cl, value_size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 direntr=
y->d_inode, full_path);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 direntr=
y->d_inode, full_path, CIFS_ACL_DACL);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D 0) /* fo=
rce revalidate of the inode */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_I=
(direntry->d_inode)->time =3D 0;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(pacl);
> --
> 1.6.0.2
>
>



--=20
Thanks,

Steve
