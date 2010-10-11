From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH] handle extended attribute name cifsacl to generate cifs
 acl blob
Date: Sun, 10 Oct 2010 21:15:05 -0500
Message-ID: <AANLkTinKtWpwYtMsDUUTQJM1UncazGzXb3N6VaiYmJ1N@mail.gmail.com>
References: <1286460207-4024-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101009164217.2c098abb@corrin.poochiereds.net>
	<AANLkTinxQpaHdLx+Zr=caMqVW0Qz2Xiom5NOqp8DbxWE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinxQpaHdLx+Zr=caMqVW0Qz2Xiom5NOqp8DbxWE-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Oct 9, 2010 at 3:42 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, =A07 Oct 2010 09:03:27 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Add extended attribute name system.cifsacl
>>
>> Get/generate cifs/ntfs acl blob and hand over to the invoker however
>> it wants to parse/process it.
>>
>> Stop generating cifs/ntfs acl blob for xattr name system.posix_acl_a=
ccess
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>> =A0fs/cifs/xattr.c | =A0 64 +++++++++++++++++++++++++++++++++++++---=
---------------
>> =A01 files changed, 43 insertions(+), 21 deletions(-)
>>
>> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
>> --- a/fs/cifs/xattr.c
>> +++ b/fs/cifs/xattr.c
<snip>
>> +static int
>> +get_cifs_acl(int xid, struct cifsTconInfo *pTcon, char *full_path,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *ea_value, size_t siz=
e, struct nls_table *nls_cp)
>> +{
>> + =A0 =A0 __u16 fid;
>> + =A0 =A0 int rc;
>> + =A0 =A0 int oplock =3D 0;
>> + =A0 =A0 unsigned int acllen =3D 0;
>> + =A0 =A0 struct cifs_ntsd *pacl =3D NULL;
>> +
>> + =A0 =A0 rc =3D CIFSSMBOpen(xid, pTcon, full_path, FILE_OPEN, GENER=
IC_READ,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, &fid, &oplock, NULL, nl=
s_cp, 0);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: file open error: %d", __fun=
c__, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
> =A0 =A0 =A0 =A0^^^^
> Hmm possible oplock break. Wouldn't it be better to see if you alread=
y
> have a readable filehandle before you do this?

Yes - absolutely need to check for matching file handle

>> + =A0 =A0 rc =3D CIFSSMBGetCIFSACL(xid, pTcon, fid, &pacl, &acllen);
>> + =A0 =A0 CIFSSMBClose(xid, pTcon, fid);
>> + =A0 =A0 if (rc) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1, "%s: get acl error: %d", __func_=
_, rc);
>> + =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> + =A0 =A0 }
>> +
>> + =A0 =A0 if (ea_value) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 if (acllen > size) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(pacl);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ERANGE;
>> + =A0 =A0 =A0 =A0 =A0 =A0 }
>> + =A0 =A0 =A0 =A0 =A0 =A0 memcpy(ea_value, pacl, acllen);
>> + =A0 =A0 =A0 =A0 =A0 =A0 kfree(pacl);
>> + =A0 =A0 }
>> +
>> + =A0 =A0 return acllen;
>> +}
>> +
>> =A0int cifs_setxattr(struct dentry *direntry, const char *ea_name,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const void *ea_value, size_t value_s=
ize, int flags)
>> =A0{
>> @@ -277,27 +314,6 @@ ssize_t cifs_getxattr(struct dentry *direntry, =
const char *ea_name,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>local_nls,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb-=
>mnt_cifs_flags &
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
>> -#ifdef CONFIG_CIFS_EXPERIMENTAL
>> - =A0 =A0 =A0 =A0 =A0 =A0 else if (cifs_sb->mnt_cifs_flags & CIFS_MO=
UNT_CIFS_ACL) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u16 fid;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int oplock =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifs_ntsd *pacl =3D=
 NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 buflen =3D 0;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (experimEnabled)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIF=
SSMBOpen(xid, pTcon, full_path,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 FILE_OPEN, GENERIC_READ, 0, &fid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 &oplock, NULL, cifs_sb->local_nls,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 cifs_sb->mnt_cifs_flags &
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* else rc is EOPNOTSUPP f=
rom above */
>> -
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIF=
SSMBGetCIFSACL(xid, pTcon, fid, &pacl,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &buflen);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSMBClo=
se(xid, pTcon, fid);
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> - =A0 =A0 =A0 =A0 =A0 =A0 }
>> -#endif /* EXPERIMENTAL */
>> =A0#else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "query POSIX ACL not supported y=
et");
>> =A0#endif /* CONFIG_CIFS_POSIX */
>> @@ -313,6 +329,12 @@ ssize_t cifs_getxattr(struct dentry *direntry, =
const char *ea_name,
>> =A0#else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "query POSIX default ACL not sup=
ported yet");
>> =A0#endif
>> +#ifdef CONFIG_CIFS_EXPERIMENTAL
>> + =A0 =A0 } else if (strncmp(ea_name, CIFS_ACL_XATTR,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlen(CIF=
S_ACL_XATTR)) =3D=3D 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D get_cifs_acl(xid, p=
Tcon, full_path, ea_value,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 buf_size, cifs_sb->local_nls);
>> +#endif /* CONFIG_CIFS_EXPERIMENTAL */
>> =A0 =A0 =A0 } else if (strncmp(ea_name,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_XATTR_TRUSTED_PREFIX, XATTR_TRU=
STED_PREFIX_LEN) =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Trusted xattr namespace not sup=
ported yet");
>
> I'd probably prefer not to see this new code wrapped in experimental
> tags. I don't think that adds any real value, especially not with
> something as simple as this.

I agree - seems low risk as well.

--
Thanks,

Steve



--=20
Thanks,

Steve
