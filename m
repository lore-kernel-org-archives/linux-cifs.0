From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix NT_STATUS_ACCESS_DENIED for mounts with
 prefixpath option
Date: Sat, 27 Aug 2011 00:11:57 +0400
Message-ID: <CAKywueQQMuTA=xszQYr6sf5L+cZ_s56qrCiL8MqthWS-Xbxw5A@mail.gmail.com>
References: <1314341541-2476-1-git-send-email-piastry@etersoft.ru>
	<20110826073437.743c06a3@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110826073437.743c06a3-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/8/26 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Fri, 26 Aug 2011 10:52:21 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Reorganize code and make it send qpath info request only for a full
>> path (//server/share/prefixpath) rather than request for every path
>> compoment. In this case we end up with negative dentries for all
>> components except full one and we will instantiate them later if
>> such a mount is requested.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>> ---
>> =A0fs/cifs/cifsfs.c =A0| =A0123 +++++++++++++++++++++++++++++++-----=
-----------------
>> =A0fs/cifs/cifsfs.h =A0| =A0 =A03 +-
>> =A0fs/cifs/inode.c =A0 | =A0 =A07 ++-
>> =A0fs/cifs/readdir.c | =A0 =A09 +++-
>> =A04 files changed, 85 insertions(+), 57 deletions(-)
>>
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index 0435bb9..33a2e1e 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -95,14 +95,13 @@ mempool_t *smb2_mid_poolp;
>> =A0static struct kmem_cache *smb2_mid_cachep;
>> =A0#endif /* CONFIG_CIFS_SMB2 */
>>
>> -static int
>> +static void
>> =A0cifs_read_super(struct super_block *sb)
>> =A0{
>> - =A0 =A0 struct inode *inode;
>> - =A0 =A0 struct cifs_sb_info *cifs_sb;
>> - =A0 =A0 int rc =3D 0;
>> + =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(sb);
>>
>> - =A0 =A0 cifs_sb =3D CIFS_SB(sb);
>> + =A0 =A0 /* BB should we make this contingent on mount parm? */
>> + =A0 =A0 sb->s_flags |=3D MS_NODIRATIME | MS_NOATIME;
>>
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIXACL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 sb->s_flags |=3D MS_POSIXACL;
>> @@ -120,26 +119,6 @@ cifs_read_super(struct super_block *sb)
>> =A0 =A0 =A0 sb->s_bdi =3D &cifs_sb->bdi;
>> =A0 =A0 =A0 sb->s_blocksize =3D CIFS_MAX_MSGSIZE;
>> =A0 =A0 =A0 sb->s_blocksize_bits =3D 14; =A0 =A0 =A0/* default 2**14=
 =3D CIFS_MAX_MSGSIZE */
>> - =A0 =A0 inode =3D cifs_root_iget(sb);
>> -
>> - =A0 =A0 if (IS_ERR(inode)) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D PTR_ERR(inode);
>> - =A0 =A0 =A0 =A0 =A0 =A0 inode =3D NULL;
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_no_root;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 sb->s_root =3D d_alloc_root(inode);
>> -
>> - =A0 =A0 if (!sb->s_root) {
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -ENOMEM;
>> - =A0 =A0 =A0 =A0 =A0 =A0 goto out_no_root;
>> - =A0 =A0 }
>> -
>> - =A0 =A0 /* do that *after* d_alloc_root() - we want NULL ->d_op fo=
r root here */
>> - =A0 =A0 if (cifs_sb_master_tcon(cifs_sb)->nocase)
>> - =A0 =A0 =A0 =A0 =A0 =A0 sb->s_d_op =3D &cifs_ci_dentry_ops;
>> - =A0 =A0 else
>> - =A0 =A0 =A0 =A0 =A0 =A0 sb->s_d_op =3D &cifs_dentry_ops;
>>
>> =A0#ifdef CIFS_NFSD_EXPORT
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM) {
>> @@ -148,14 +127,7 @@ cifs_read_super(struct super_block *sb)
>> =A0 =A0 =A0 }
>> =A0#endif /* CIFS_NFSD_EXPORT */
>>
>> - =A0 =A0 return 0;
>> -
>> -out_no_root:
>> - =A0 =A0 cERROR(1, "cifs_read_super: get root inode failed");
>> - =A0 =A0 if (inode)
>> - =A0 =A0 =A0 =A0 =A0 =A0 iput(inode);
>> -
>> - =A0 =A0 return rc;
>> + =A0 =A0 sb->s_flags |=3D MS_ACTIVE;
>> =A0}
>>
>> =A0static void cifs_kill_sb(struct super_block *sb)
>> @@ -529,6 +501,17 @@ static const struct super_operations cifs_super=
_ops =3D {
>> =A0#endif
>> =A0};
>>
>> +static struct dentry *
>> +cifs_alloc_root(struct super_block *sb)
>> +{
>> + =A0 =A0 struct qstr q;
>> +
>> + =A0 =A0 q.name =3D "/";
>
> =A0 =A0 =A0 =A0I don't think you want a separator in the name. That s=
eems
> =A0 =A0 =A0 =A0like it should be "".
>

In this case I based it on d_alloc_root() function that fills name as
"/". Why this should be ""?

--=20
Best regards,
Pavel Shilovsky.
