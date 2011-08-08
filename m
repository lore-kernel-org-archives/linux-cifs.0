From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Call id to SID mapping functions to change
 owner/group (try #2)
Date: Mon, 8 Aug 2011 07:32:49 -0500
Message-ID: <CADT32eKDYpWBozpVWuDHCFd=Bm8B6NLBgHyb3A0ukOu1JT_3Cg@mail.gmail.com>
References: <1312231807-18034-1-git-send-email-shirishpargaonkar@gmail.com>
	<CAH2r5muxeNd1E3uhoFuvAAigftc3Vta5joyd+h3Dvt18LYaKRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muxeNd1E3uhoFuvAAigftc3Vta5joyd+h3Dvt18LYaKRA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 1, 2011 at 4:19 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
> Mostly looks ok - but needs a few changes (see below).
>
> On Mon, Aug 1, 2011 at 3:50 PM, =A0<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>> Now build security descriptor to change either owner or group at the
>> server. =A0Initially security descriptor was built to change only
>> ACL, that functionality has been extended.
>>
>> When either an Owner or Group of a file object at the server is chan=
ged,
>> rest of security descriptor remains same (DACL etc.).
>>
>> To set security descriptor, it is essential to open that file
>> with WRITE_DAC as well as WRITE_OWNER (Take Ownership) permission bi=
ts.
>> Function set_cifs_acl_by_fid() has been removed since we can't be
>> sure how a file was opened for writing, a valid request can fail
>> if the file was not opened with two above mentioned permissions.
>
> The set_cifs_acl_by_fid is still needed (e.g. don't break oplock on s=
etacl
> due to reopening the file), but only for the setacl case can we
> reuse the handle (and why would find_readable_file have
> WRITE_DAC permission?), the setowner case requires
> the WRITE_DAC and WRITE_OWNER flags, so the set_cifs_acl
> function will have to distinguish the two cases.
>

I will change function set_cifs_acl to find a writable handle and
do basic testing wrt changing DACL. But even with that change,
we can't say even if a writable handle was found, the (writable)
file was opened with WRITE_DAC and/or WRITE_OWNER
access flags

> First we need to fix the case in existing code (if possible) where
> we have a file open and call set_cifs_acl - that looks like
> it is broken. =A0Then put your patch on top and will need to
> make sure we don't request too much permission on the
> cifs open (only WRITE_DAC, unless changing owner when
> we also need WRITE_OWNER). =A0We don't want to fail
> on the server on the open due to asking for too much.
>
>> It is the server that decides whether a set security descriptor with
>> either owner or group change succeeds or not.
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsacl.c =A0 | =A0148 ++++++++++++++++++++++++++++------=
-----------------
>> =A0fs/cifs/cifsproto.h | =A0 =A07 ++-
>> =A0fs/cifs/cifssmb.c =A0 | =A0 =A04 +-
>> =A0fs/cifs/inode.c =A0 =A0 | =A0 35 ++++++++----
>> =A0fs/cifs/xattr.c =A0 =A0 | =A0 =A02 +-
>> =A05 files changed, 111 insertions(+), 85 deletions(-)
>>
>> diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
>> index b7e723a..88a801a 100644
>> --- a/fs/cifs/cifsacl.c
>> +++ b/fs/cifs/cifsacl.c
>> @@ -904,7 +904,7 @@ static void parse_dacl(struct cifs_acl *pdacl, c=
har *end_of_acl,
>> =A0 =A0 =A0 =A0acl_size =3D sizeof(struct cifs_acl);
>>
>> =A0 =A0 =A0 =A0num_aces =3D le32_to_cpu(pdacl->num_aces);
>> - =A0 =A0 =A0 if (num_aces =A0> 0) {
>> + =A0 =A0 =A0 if (num_aces > 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t user_mask =3D S_IRWXU;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t group_mask =3D S_IRWXG;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0umode_t other_mask =3D S_IRWXU | S_IR=
WXG | S_IRWXO;
>> @@ -1066,52 +1066,82 @@ static int parse_sec_desc(struct cifs_sb_inf=
o *cifs_sb,
>> =A0 =A0 =A0 =A0else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "no ACL"); /* BB grant all or=
 default perms? */
>>
>> -/* =A0 =A0 cifscred->uid =3D owner_sid_ptr->rid;
>> - =A0 =A0 =A0 cifscred->gid =3D group_sid_ptr->rid;
>> - =A0 =A0 =A0 memcpy((void *)(&(cifscred->osid)), (void *)owner_sid_=
ptr,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct cifs_sid=
));
>> - =A0 =A0 =A0 memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_=
ptr,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct cifs_sid=
)); */
>> -
>> =A0 =A0 =A0 =A0return rc;
>> =A0}
>>
>> -
>> =A0/* Convert permission bits from mode to equivalent CIFS ACL */
>> =A0static int build_sec_desc(struct cifs_ntsd *pntsd, struct cifs_nt=
sd *pnntsd,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 inode *inode, __u64 nmode)
>> + =A0 =A0 =A0 __u32 secdesclen, __u64 nmode, uid_t uid, gid_t gid, i=
nt *aclflag)
>> =A0{
>> =A0 =A0 =A0 =A0int rc =3D 0;
>> =A0 =A0 =A0 =A0__u32 dacloffset;
>> =A0 =A0 =A0 =A0__u32 ndacloffset;
>> =A0 =A0 =A0 =A0__u32 sidsoffset;
>> =A0 =A0 =A0 =A0struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
>> + =A0 =A0 =A0 struct cifs_sid *nowner_sid_ptr, *ngroup_sid_ptr;
>> =A0 =A0 =A0 =A0struct cifs_acl *dacl_ptr =3D NULL; =A0/* no need for=
 SACL ptr */
>> =A0 =A0 =A0 =A0struct cifs_acl *ndacl_ptr =3D NULL; /* no need for S=
ACL ptr */
>>
>> - =A0 =A0 =A0 if ((inode =3D=3D NULL) || (pntsd =3D=3D NULL) || (pnn=
tsd =3D=3D NULL))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EIO;
>> -
>> - =A0 =A0 =A0 owner_sid_ptr =3D (struct cifs_sid *)((char *)pntsd +
>> + =A0 =A0 =A0 if (nmode !=3D NO_CHANGE_64) { /* chmod */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 owner_sid_ptr =3D (struct cifs_sid *)(=
(char *)pntsd +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_=
to_cpu(pntsd->osidoffset));
>> - =A0 =A0 =A0 group_sid_ptr =3D (struct cifs_sid *)((char *)pntsd +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_sid_ptr =3D (struct cifs_sid *)(=
(char *)pntsd +
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_=
to_cpu(pntsd->gsidoffset));
>> -
>> - =A0 =A0 =A0 dacloffset =3D le32_to_cpu(pntsd->dacloffset);
>> - =A0 =A0 =A0 dacl_ptr =3D (struct cifs_acl *)((char *)pntsd + daclo=
ffset);
>> -
>> - =A0 =A0 =A0 ndacloffset =3D sizeof(struct cifs_ntsd);
>> - =A0 =A0 =A0 ndacl_ptr =3D (struct cifs_acl *)((char *)pnntsd + nda=
cloffset);
>> - =A0 =A0 =A0 ndacl_ptr->revision =3D dacl_ptr->revision;
>> - =A0 =A0 =A0 ndacl_ptr->size =3D 0;
>> - =A0 =A0 =A0 ndacl_ptr->num_aces =3D 0;
>> -
>> - =A0 =A0 =A0 rc =3D set_chmod_dacl(ndacl_ptr, owner_sid_ptr, group_=
sid_ptr, nmode);
>> -
>> - =A0 =A0 =A0 sidsoffset =3D ndacloffset + le16_to_cpu(ndacl_ptr->si=
ze);
>> -
>> - =A0 =A0 =A0 /* copy security descriptor control portion and owner =
and group sid */
>> - =A0 =A0 =A0 copy_sec_desc(pntsd, pnntsd, sidsoffset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dacloffset =3D le32_to_cpu(pntsd->dacl=
offset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dacl_ptr =3D (struct cifs_acl *)((char=
 *)pntsd + dacloffset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacloffset =3D sizeof(struct cifs_nts=
d);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr =3D (struct cifs_acl *)((cha=
r *)pnntsd + ndacloffset);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr->revision =3D dacl_ptr->revi=
sion;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr->size =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ndacl_ptr->num_aces =3D 0;
>> +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D set_chmod_dacl(ndacl_ptr, owner=
_sid_ptr, group_sid_ptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 nmode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 sidsoffset =3D ndacloffset + le16_to_c=
pu(ndacl_ptr->size);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* copy sec desc control portion & own=
er and group sids */
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 copy_sec_desc(pntsd, pnntsd, sidsoffse=
t);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 *aclflag =3D CIFS_ACL_DACL;
>> + =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(pnntsd, pntsd, secdesclen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (uid !=3D NO_CHANGE_32) { /* chown =
*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 owner_sid_ptr =3D (str=
uct cifs_sid *)((char *)pnntsd +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(pnntsd->osidoffset));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 nowner_sid_ptr =3D kma=
lloc(sizeof(struct cifs_sid),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!nowner_sid_ptr)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return=
 -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_to_sid(uid, =
SIDOWNER, nowner_sid_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1=
, "%s: Mapping error %d for owner id %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 __func__, rc, uid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(=
nowner_sid_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return=
 rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(owner_sid_ptr, =
nowner_sid_ptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct cifs_sid));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(nowner_sid_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *aclflag =3D CIFS_ACL_=
OWNER;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (gid !=3D NO_CHANGE_32) { /* chgrp =
*/
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 group_sid_ptr =3D (str=
uct cifs_sid *)((char *)pnntsd +
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 le32_to_cpu(pnntsd->gsidoffset));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ngroup_sid_ptr =3D kma=
lloc(sizeof(struct cifs_sid),
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!ngroup_sid_ptr)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return=
 -ENOMEM;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_to_sid(gid, =
SIDGROUP, ngroup_sid_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1=
, "%s: Mapping error %d for group id %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 __func__, rc, gid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(=
ngroup_sid_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return=
 rc;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(group_sid_ptr, =
ngroup_sid_ptr,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 sizeof(struct cifs_sid));
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ngroup_sid_ptr);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *aclflag =3D CIFS_ACL_=
GROUP;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0return rc;
>> =A0}
>> @@ -1189,26 +1219,8 @@ struct cifs_ntsd *get_cifs_acl(struct cifs_sb=
_info *cifs_sb,
>> =A0 =A0 =A0 =A0return pntsd;
>> =A0}
>>
>> -static int set_cifs_acl_by_fid(struct cifs_sb_info *cifs_sb, __u16 =
fid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnntsd, u32 acllen)
>> -{
>> - =A0 =A0 =A0 int xid, rc;
>> - =A0 =A0 =A0 struct tcon_link *tlink =3D cifs_sb_tlink(cifs_sb);
>> -
>> - =A0 =A0 =A0 if (IS_ERR(tlink))
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return PTR_ERR(tlink);
>> -
>> - =A0 =A0 =A0 xid =3D GetXid();
>> - =A0 =A0 =A0 rc =3D CIFSSMBSetCIFSACL(xid, tlink_tcon(tlink), fid, =
pnntsd, acllen);
>> - =A0 =A0 =A0 FreeXid(xid);
>> - =A0 =A0 =A0 cifs_put_tlink(tlink);
>> -
>> - =A0 =A0 =A0 cFYI(DBG2, "SetCIFSACL rc =3D %d", rc);
>> - =A0 =A0 =A0 return rc;
>> -}
>> -
>> =A0static int set_cifs_acl_by_path(struct cifs_sb_info *cifs_sb, con=
st char *path,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnntsd, u32 acllen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnntsd, u32 acllen, =
int aclflag)
>> =A0{
>> =A0 =A0 =A0 =A0int oplock =3D 0;
>> =A0 =A0 =A0 =A0int xid, rc;
>> @@ -1222,7 +1234,7 @@ static int set_cifs_acl_by_path(struct cifs_sb=
_info *cifs_sb, const char *path,
>> =A0 =A0 =A0 =A0tcon =3D tlink_tcon(tlink);
>> =A0 =A0 =A0 =A0xid =3D GetXid();
>>
>> - =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_D=
AC, 0,
>> + =A0 =A0 =A0 rc =3D CIFSSMBOpen(xid, tcon, path, FILE_OPEN, WRITE_D=
AC | WRITE_OWNER, 0,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &fid, &oplock, NULL,=
 cifs_sb->local_nls,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_fl=
ags & CIFS_MOUNT_MAP_SPECIAL_CHR);
>> =A0 =A0 =A0 =A0if (rc) {
>> @@ -1230,7 +1242,7 @@ static int set_cifs_acl_by_path(struct cifs_sb=
_info *cifs_sb, const char *path,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto out;
>> =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 rc =3D CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, aclle=
n);
>> + =A0 =A0 =A0 rc =3D CIFSSMBSetCIFSACL(xid, tcon, fid, pnntsd, aclle=
n, aclflag);
>> =A0 =A0 =A0 =A0cFYI(DBG2, "SetCIFSACL rc =3D %d", rc);
>>
>> =A0 =A0 =A0 =A0CIFSSMBClose(xid, tcon, fid);
>> @@ -1242,21 +1254,18 @@ out:
>>
>> =A0/* Set an ACL on the server */
>> =A0int set_cifs_acl(struct cifs_ntsd *pnntsd, __u32 acllen,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct=
 inode *inode, const char *path)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct inode *inode, c=
onst char *path, int aclflag)
>> =A0{
>> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb)=
;
>> - =A0 =A0 =A0 struct cifsFileInfo *open_file;
>> - =A0 =A0 =A0 int rc;
>> -
>> - =A0 =A0 =A0 cFYI(DBG2, "set ACL for %s from mode 0x%x", path, inod=
e->i_mode);
>> -
>> - =A0 =A0 =A0 open_file =3D find_readable_file(CIFS_I(inode), true);
>> - =A0 =A0 =A0 if (!open_file)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return set_cifs_acl_by_path(cifs_sb, p=
ath, pnntsd, acllen);
>>
>> - =A0 =A0 =A0 rc =3D set_cifs_acl_by_fid(cifs_sb, open_file->netfid,=
 pnntsd, acllen);
>> - =A0 =A0 =A0 cifsFileInfo_put(open_file);
>> - =A0 =A0 =A0 return rc;
>> + =A0 =A0 =A0 cFYI(DBG2, "%s: set ACL for %s", __func__, path);
>> + =A0 =A0 =A0 /*
>> + =A0 =A0 =A0 =A0* Always open file by path. We do not know how a fi=
le was
>> + =A0 =A0 =A0 =A0* opened if we search and find a writable find hand=
le.
>> + =A0 =A0 =A0 =A0* WRITRE_DAC and WRITE_OWNER permissions are essent=
ial for
>> + =A0 =A0 =A0 =A0* changing ownership of a file at the server.
>> + =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 return set_cifs_acl_by_path(cifs_sb, path, pnntsd, acl=
len, aclflag);
>> =A0}
>>
>> =A0/* Translate the CIFS ACL (simlar to NTFS ACL) for a file into mo=
de bits */
>> @@ -1290,9 +1299,12 @@ cifs_acl_to_fattr(struct cifs_sb_info *cifs_s=
b, struct cifs_fattr *fattr,
>> =A0}
>>
>> =A0/* Convert mode bits to an ACL so we can update the ACL on the se=
rver */
>> -int mode_to_cifs_acl(struct inode *inode, const char *path, __u64 n=
mode)
>> +int
>> +id_mode_to_cifs_acl(struct inode *inode, const char *path, __u64 nm=
ode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid_t uid, gid_t gid)
>> =A0{
>> =A0 =A0 =A0 =A0int rc =3D 0;
>> + =A0 =A0 =A0 int aclflag =3D CIFS_ACL_DACL; /* default flag to set =
*/
>> =A0 =A0 =A0 =A0__u32 secdesclen =3D 0;
>> =A0 =A0 =A0 =A0struct cifs_ntsd *pntsd =3D NULL; /* acl obtained fro=
m server */
>> =A0 =A0 =A0 =A0struct cifs_ntsd *pnntsd =3D NULL; /* modified acl to=
 be sent to server */
>> @@ -1322,13 +1334,15 @@ int mode_to_cifs_acl(struct inode *inode, co=
nst char *path, __u64 nmode)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_sec_desc(pntsd, pnntsd, i=
node, nmode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D build_sec_desc(pntsd, pnntsd, s=
ecdesclen, nmode, uid, gid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &aclflag);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(DBG2, "build_sec_desc rc: %d", r=
c);
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Set the security d=
escriptor */
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D set_cifs_acl(pn=
ntsd, secdesclen, inode, path);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D set_cifs_acl(pn=
ntsd, secdesclen, inode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 path, aclflag);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(DBG2, "set_cifs_=
acl rc: %d", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>>
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 953f844..3c0e026 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -145,11 +145,12 @@ extern int cifs_get_inode_info_unix(struct ino=
de **pinode,
>> =A0extern int cifs_acl_to_fattr(struct cifs_sb_info *cifs_sb,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ci=
fs_fattr *fattr, struct inode *inode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const cha=
r *path, const __u16 *pfid);
>> -extern int mode_to_cifs_acl(struct inode *inode, const char *path, =
__u64);
>> +extern int id_mode_to_cifs_acl(struct inode *inode, const char *pat=
h, __u64,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 uid_t, gid_t);
>> =A0extern struct cifs_ntsd *get_cifs_acl(struct cifs_sb_info *, stru=
ct inode *,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0const char *, u32 *);
>> =A0extern int set_cifs_acl(struct cifs_ntsd *, __u32, struct inode *=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const =
char *);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const =
char *, int);
>>
>> =A0extern void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct c=
ifs_sb_info *cifs_sb);
>> @@ -419,7 +420,7 @@ extern int CIFSSMBSetEA(const int xid, struct ci=
fs_tcon *tcon,
>> =A0extern int CIFSSMBGetCIFSACL(const int xid, struct cifs_tcon *tco=
n,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0__u16 fid, struct cif=
s_ntsd **acl_inf, __u32 *buflen);
>> =A0extern int CIFSSMBSetCIFSACL(const int, struct cifs_tcon *, __u16=
,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *, __=
u32);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *, __=
u32, int);
>> =A0extern int CIFSSMBGetPosixACL(const int xid, struct cifs_tcon *tc=
on,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *searchName,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0char *acl_inf, const int buflen, cons=
t int acl_type,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 1a9fe7f..f393bf1 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -3467,7 +3467,7 @@ qsec_out:
>>
>> =A0int
>> =A0CIFSSMBSetCIFSACL(const int xid, struct cifs_tcon *tcon, __u16 fi=
d,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnts=
d, __u32 acllen)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pnts=
d, __u32 acllen, int aclflag)
>> =A0{
>> =A0 =A0 =A0 =A0__u16 byte_count, param_count, data_count, param_offs=
et, data_offset;
>> =A0 =A0 =A0 =A0int rc =3D 0;
>> @@ -3504,7 +3504,7 @@ setCifsAclRetry:
>>
>> =A0 =A0 =A0 =A0pSMB->Fid =3D fid; /* file handle always le */
>> =A0 =A0 =A0 =A0pSMB->Reserved2 =3D 0;
>> - =A0 =A0 =A0 pSMB->AclFlags =3D cpu_to_le32(CIFS_ACL_DACL);
>> + =A0 =A0 =A0 pSMB->AclFlags =3D cpu_to_le32(aclflag);
>>
>> =A0 =A0 =A0 =A0if (pntsd && acllen) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy((char *) &pSMBr->hdr.Protocol =
+ data_offset,
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index 9b018c8..7251f88 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -2106,6 +2106,8 @@ static int
>> =A0cifs_setattr_nounix(struct dentry *direntry, struct iattr *attrs)
>> =A0{
>> =A0 =A0 =A0 =A0int xid;
>> + =A0 =A0 =A0 uid_t uid =3D NO_CHANGE_32;
>> + =A0 =A0 =A0 gid_t gid =3D NO_CHANGE_32;
>> =A0 =A0 =A0 =A0struct inode *inode =3D direntry->d_inode;
>> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb)=
;
>> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsInode =3D CIFS_I(inode);
>> @@ -2156,13 +2158,25 @@ cifs_setattr_nounix(struct dentry *direntry,=
 struct iattr *attrs)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto cifs_setattr_exi=
t;
>> =A0 =A0 =A0 =A0}
>>
>> - =A0 =A0 =A0 /*
>> - =A0 =A0 =A0 =A0* Without unix extensions we can't send ownership c=
hanges to the
>> - =A0 =A0 =A0 =A0* server, so silently ignore them. This is consiste=
nt with how
>> - =A0 =A0 =A0 =A0* local DOS/Windows filesystems behave (VFAT, NTFS,=
 etc). With
>> - =A0 =A0 =A0 =A0* CIFSACL support + proper Windows to Unix idmappin=
g, we may be
>> - =A0 =A0 =A0 =A0* able to support this in the future.
>> - =A0 =A0 =A0 =A0*/
>> + =A0 =A0 =A0 if (attrs->ia_valid & ATTR_UID)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid =3D attrs->ia_uid;
>> +
>> + =A0 =A0 =A0 if (attrs->ia_valid & ATTR_GID)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 gid =3D attrs->ia_gid;
>> +
>> +#ifdef CONFIG_CIFS_ACL
>> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_CIFS_ACL) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (uid !=3D NO_CHANGE_32 || gid !=3D =
NO_CHANGE_32) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_mode_to_cifs=
_acl(inode, full_path, NO_CHANGE_64,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 uid, gid);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1=
, "%s: Setting id failed with error: %d",
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto c=
ifs_setattr_exit;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 } else
>> +#endif /* CONFIG_CIFS_ACL */
>> =A0 =A0 =A0 =A0if (!(cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SET_UID))
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0attrs->ia_valid &=3D ~(ATTR_UID | ATT=
R_GID);
>>
>> @@ -2171,15 +2185,12 @@ cifs_setattr_nounix(struct dentry *direntry,=
 struct iattr *attrs)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0attrs->ia_valid &=3D ~ATTR_MODE;
>>
>> =A0 =A0 =A0 =A0if (attrs->ia_valid & ATTR_MODE) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Mode changed to 0%o", attrs->=
ia_mode);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mode =3D attrs->ia_mode;
>> - =A0 =A0 =A0 }
>> -
>> - =A0 =A0 =A0 if (attrs->ia_valid & ATTR_MODE) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D 0;
>> =A0#ifdef CONFIG_CIFS_ACL
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_CIFS_ACL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mode_to_cifs_ac=
l(inode, full_path, mode);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D id_mode_to_cifs=
_acl(inode, full_path, mode,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 NO_CHANGE_32, NO_CHANGE_32);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(=
1, "%s: Setting ACL failed with error: %d",
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0__func__, rc);
>> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
>> index 2a22fb2..fde15b1 100644
>> --- a/fs/cifs/xattr.c
>> +++ b/fs/cifs/xattr.c
>> @@ -178,7 +178,7 @@ int cifs_setxattr(struct dentry *direntry, const=
 char *ea_name,
>> =A0#ifdef CONFIG_CIFS_ACL
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(pacl, ea_value=
, value_size);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D set_cifs_acl(p=
acl, value_size,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dirent=
ry->d_inode, full_path);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dirent=
ry->d_inode, full_path, CIFS_ACL_DACL);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D 0) /* f=
orce revalidate of the inode */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_=
I(direntry->d_inode)->time =3D 0;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0kfree(pacl);
>> --
>> 1.6.0.2
>>
>>
>
>
>
> --
> Thanks,
>
> Steve
>
