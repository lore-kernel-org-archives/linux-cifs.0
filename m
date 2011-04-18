From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add rwpidforward mount option
Date: Mon, 18 Apr 2011 15:59:58 +0400
Message-ID: <BANLkTin6Oh-hrNzOXizQRYcW-8Xq5jVgLA@mail.gmail.com>
References: <1303127379-6708-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303127379-6708-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/18 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Add rwpidforward mount option that switches that switches on a mode w=
hen we
> forward pid of a process who opened a file to any read and write oper=
ation.
>
> This can prevent applications like WINE from failing on read or write=
 operation
> on a previously locked file region from the same file descriptor if w=
e use
> mandatory brlock style. This happens because during a run of WINE pro=
gram two
> processes work on the same file descriptor:
> 1) WINE-server does open and lock;
> 2) WINE-application does read and write.
>
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
> =A0fs/cifs/README =A0 =A0 =A0 | =A0 =A03 ++
> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 =A08 ++++++
> =A0fs/cifs/cifsproto.h =A0| =A0 21 ++++++++-------
> =A0fs/cifs/cifssmb.c =A0 =A0| =A0 31 +++++++++++++++-------
> =A0fs/cifs/connect.c =A0 =A0| =A0 =A05 +++
> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A04 +-
> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 69 ++++++++++++++++++++++++++++++=
++++++++-----------
> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 10 ++++---
> =A0fs/cifs/link.c =A0 =A0 =A0 | =A0 =A06 ++--
> =A010 files changed, 113 insertions(+), 45 deletions(-)
>
> diff --git a/fs/cifs/README b/fs/cifs/README
> index 4a3ca0e..33f4ba0 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -457,6 +457,9 @@ A partial list of the supported mount options fol=
lows:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0otherwise - read from the server. All =
written data are stored
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0in the cache, but if the client doesn'=
t have Exclusive Oplock,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0it writes the data to the server.
> + =A0rwpidforward =A0Forward pid of a process who opened a file to an=
y read or write
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 operation on that file. This revent app=
lication like WINE
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 from failing on read and write if we us=
e mandatory brlock style.
> =A0 acl =A0 =A0 =A0 =A0 =A0Allow setfacl and getfacl to manage posix =
ACLs if server
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0supports them. =A0(default)
> =A0 noacl =A0 =A0 =A0 =A0Do not allow setfacl and getfacl calls on th=
is mount
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 1ef54ab..867ae15 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -43,6 +43,7 @@
> =A0#define CIFS_MOUNT_MF_SYMLINKS 0x10000 /* Minshall+French Symlinks=
 enabled */
> =A0#define CIFS_MOUNT_MULTIUSER =A0 0x20000 /* multiuser mount */
> =A0#define CIFS_MOUNT_STRICT_IO =A0 0x40000 /* strict cache mode */
> +#define CIFS_MOUNT_RWPIDFORWARD =A0 =A0 =A0 =A00x80000 /* use pid fo=
rwarding for rw */
>
> =A0struct cifs_sb_info {
> =A0 =A0 =A0 =A0struct rb_root tlink_tree;
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index fb6a2ad..9d07558 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -460,6 +460,10 @@ cifs_show_options(struct seq_file *s, struct vfs=
mount *m)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",nocase");
> =A0 =A0 =A0 =A0if (tcon->retry)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",hard");
> + =A0 =A0 =A0 if (tcon->unix_ext)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",unix");
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",nounix");
> =A0 =A0 =A0 =A0if (cifs_sb->prepath)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",prepath=3D%s", cifs_sb=
->prepath);
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
> @@ -468,6 +472,10 @@ cifs_show_options(struct seq_file *s, struct vfs=
mount *m)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",setuids");
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",serverino");
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",rwpidforward");
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",forcemand");
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0seq_printf(s, ",directio");
> =A0 =A0 =A0 =A0if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 76c4dc7..28e975c 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -335,18 +335,19 @@ extern int CIFSSMBFlush(const int xid, struct c=
ifs_tcon *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const int smb_file_id)=
;
>
> =A0extern int CIFSSMBRead(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, unsig=
ned int count,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 lseek, unsi=
gned int *nbytes, char **buf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *return_buf_type);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const=
 __u32 netpid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int count, con=
st __u64 lseek,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, c=
har **buf, int *return_buf_type);
> =A0extern int CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const=
 unsigned int count,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 lseek, unsi=
gned int *nbytes,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *buf, const =
char __user *ubuf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const=
 __u32 netpid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned int coun=
t, const __u64 lseek,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, c=
onst char *buf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char __user *ubuf=
, const int long_op);
> =A0extern int CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const=
 unsigned int count,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 offset, uns=
igned int *nbytes,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, const=
 int nvec, const int long_op);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const=
 __u32 netpid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned int coun=
t, const __u64 offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, s=
truct kvec *iov, const int nvec,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
> =A0extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon *=
tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const unsigned char *s=
earchName, __u64 *inode_number,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0const struct nls_table=
 *nls_codepage,
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 3291770..890897c 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1380,8 +1380,8 @@ openRetry:
>
> =A0int
> =A0CIFSSMBRead(const int xid, struct cifs_tcon *tcon, const int netfi=
d,
> - =A0 =A0 =A0 =A0 =A0 const unsigned int count, const __u64 lseek, un=
signed int *nbytes,
> - =A0 =A0 =A0 =A0 =A0 char **buf, int *pbuf_type)
> + =A0 =A0 =A0 =A0 =A0 const __u32 netpid, const unsigned int count, c=
onst __u64 lseek,
> + =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, char **buf, int *pbuf_typ=
e)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D -EACCES;
> =A0 =A0 =A0 =A0READ_REQ *pSMB =3D NULL;
> @@ -1407,6 +1407,9 @@ CIFSSMBRead(const int xid, struct cifs_tcon *tc=
on, const int netfid,
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
>
> + =A0 =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
> + =A0 =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16)=
);
> +
> =A0 =A0 =A0 =A0/* tcon and ses pointer are checked in smb_init */
> =A0 =A0 =A0 =A0if (tcon->ses->server =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ECONNABORTED;
> @@ -1484,10 +1487,10 @@ CIFSSMBRead(const int xid, struct cifs_tcon *=
tcon, const int netfid,
>
>
> =A0int
> -CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
> - =A0 =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, co=
nst char *buf,
> - =A0 =A0 =A0 =A0 =A0 =A0const char __user *ubuf, const int long_op)
> +CIFSSMBWrite(const int xid, struct cifs_tcon *tcon, const int netfid=
,
> + =A0 =A0 =A0 =A0 =A0 =A0const __u32 netpid, const unsigned int count=
, const __u64 offset,
> + =A0 =A0 =A0 =A0 =A0 =A0unsigned int *nbytes, const char *buf, const=
 char __user *ubuf,
> + =A0 =A0 =A0 =A0 =A0 =A0const int long_op)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D -EACCES;
> =A0 =A0 =A0 =A0WRITE_REQ *pSMB =3D NULL;
> @@ -1516,6 +1519,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon *=
tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(void **) &pSMBr);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> +
> + =A0 =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
> + =A0 =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16)=
);
> +
> =A0 =A0 =A0 =A0/* tcon and ses pointer are checked in smb_init */
> =A0 =A0 =A0 =A0if (tcon->ses->server =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ECONNABORTED;
> @@ -1603,10 +1610,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon =
*tcon,
> =A0}
>
> =A0int
> -CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
> - =A0 =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
> - =A0 =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, st=
ruct kvec *iov,
> - =A0 =A0 =A0 =A0 =A0 =A0int n_vec, const int long_op)
> +CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon, const int netfi=
d,
> + =A0 =A0 =A0 =A0 =A0 =A0 const __u32 netpid, const unsigned int coun=
t, const __u64 offset,
> + =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, struct kvec *iov, int=
 n_vec,
> + =A0 =A0 =A0 =A0 =A0 =A0 const int long_op)
> =A0{
> =A0 =A0 =A0 =A0int rc =3D -EACCES;
> =A0 =A0 =A0 =A0WRITE_REQ *pSMB =3D NULL;
> @@ -1630,6 +1637,10 @@ CIFSSMBWrite2(const int xid, struct cifs_tcon =
*tcon,
> =A0 =A0 =A0 =A0rc =3D small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (=
void **) &pSMB);
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> +
> + =A0 =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
> + =A0 =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16)=
);
> +
> =A0 =A0 =A0 =A0/* tcon and ses pointer are checked in smb_init */
> =A0 =A0 =A0 =A0if (tcon->ses->server =3D=3D NULL)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ECONNABORTED;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 94e60c5..7eab9b2 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -103,6 +103,7 @@ struct smb_vol {
> =A0 =A0 =A0 =A0bool noautotune:1;
> =A0 =A0 =A0 =A0bool nostrictsync:1; /* do not force expensive SMBflus=
h on every sync */
> =A0 =A0 =A0 =A0bool fsc:1; =A0 =A0 /* enable fscache */
> + =A0 =A0 =A0 bool rwpidforward:1; /* pid forward for rw */
> =A0 =A0 =A0 =A0bool mfsymlinks:1; /* use Minshall+French Symlinks */
> =A0 =A0 =A0 =A0bool multiuser:1;
> =A0 =A0 =A0 =A0bool use_smb2:1; /* force smb2 use on mount instead of=
 cifs */
> @@ -1362,6 +1363,8 @@ cifs_parse_mount_options(char *options, const c=
har *devname,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->server_ino =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "noserverino=
", 9) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->server_ino =3D 0;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "rwpidforward=
", 4) =3D=3D 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->rwpidforward =3D 1=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "cifsacl", 7=
) =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0vol->cifs_acl =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else if (strnicmp(data, "nocifsacl",=
 9) =3D=3D 0) {
> @@ -2643,6 +2646,8 @@ static void setup_cifs_sb(struct smb_vol *pvolu=
me_info,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_NOSSYNC;
> =A0 =A0 =A0 =A0if (pvolume_info->mand_lock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_NOPOSIXBRL;
> + =A0 =A0 =A0 if (pvolume_info->rwpidforward)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT=
_RWPIDFORWARD;
> =A0 =A0 =A0 =A0if (pvolume_info->cifs_acl)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags |=3D CIFS_MOUN=
T_CIFS_ACL;
> =A0 =A0 =A0 =A0if (pvolume_info->override_uid)
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index ab74179..6cdac98 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -446,7 +446,7 @@ int cifs_mknod(struct inode *inode, struct dentry=
 *direntry, int mode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdev->minor =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le64(MINOR(device_n=
umber));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBWrite(xid, pTcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle, current->tg=
id,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct win_dev)=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, &bytes_written, (ch=
ar *)pdev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, 0);
> @@ -457,7 +457,7 @@ int cifs_mknod(struct inode *inode, struct dentry=
 *direntry, int mode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pdev->minor =3D
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cpu_to_le64(MINOR(device_n=
umber));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBWrite(xid, pTcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle, current->tg=
id,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof(struct win_dev)=
,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00, &bytes_written, (ch=
ar *)pdev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, 0);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9c7f83f..c70dfce 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -725,8 +725,8 @@ int cifs_lock(struct file *file, int cmd, struct =
file_lock *pfLock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0posix_=
lock_type =3D CIFS_WRLCK;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBPosixLoc=
k(xid, tcon, netfid, 1 /* get */,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 length, pfLock,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 posix_lock_type, wait_flag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 length, pfLock, posix_lock_type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 wait_flag);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0FreeXid(xid);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> @@ -797,8 +797,8 @@ int cifs_lock(struct file *file, int cmd, struct =
file_lock *pfLock)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0posix_lock_type =3D CI=
=46S_UNLCK;
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBPosixLock(xid, tcon, net=
fid, 0 /* set */,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 length, pfLock,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 posix_lock_type, wait_flag);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 length, pfLock, posix_lock_type,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 wait_flag);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct cifsFileInfo *fid =3D file->pri=
vate_data;
>
> @@ -866,6 +866,7 @@ static ssize_t cifs_write(struct cifsFileInfo *op=
en_file,
> =A0 =A0 =A0 =A0unsigned int total_written;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0struct cifs_tcon *pTcon;
> + =A0 =A0 =A0 __u32 netpid;
> =A0 =A0 =A0 =A0int xid;
> =A0 =A0 =A0 =A0struct dentry *dentry =3D open_file->dentry;
> =A0 =A0 =A0 =A0struct cifsInodeInfo *cifsi =3D CIFS_I(dentry->d_inode=
);
> @@ -877,6 +878,11 @@ static ssize_t cifs_write(struct cifsFileInfo *o=
pen_file,
>
> =A0 =A0 =A0 =A0pTcon =3D tlink_tcon(open_file->tlink);
>
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
> +
> =A0 =A0 =A0 =A0xid =3D GetXid();
>
> =A0 =A0 =A0 =A0for (total_written =3D 0; write_size > total_written;
> @@ -901,8 +907,9 @@ static ssize_t cifs_write(struct cifsFileInfo *op=
en_file,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* iov[0] is reserved =
for smb header */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov[1].iov_base =3D (c=
har *)write_data + total_written;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov[1].iov_len =3D len=
;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xi=
d, pTcon, open_file->netfid, len,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 *poffset, &bytes_written, iov, 1, 0);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xi=
d, pTcon, open_file->netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0netpid, len, *poffset,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0&bytes_written, iov, 1, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc || (bytes_written =3D=3D 0)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (total_written)
> @@ -1112,6 +1119,7 @@ static int cifs_writepages(struct address_space=
 *mapping,
> =A0 =A0 =A0 =A0struct pagevec pvec;
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int scanned =3D 0;
> + =A0 =A0 =A0 __u32 netpid;
> =A0 =A0 =A0 =A0int xid;
>
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(mapping->host->i_sb);
> @@ -1251,10 +1259,15 @@ retry_write:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR=
(1, "No writable handles for inode");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 -EBADF;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cif=
s_sb->mnt_cifs_flags &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_RWPIDFORWARD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 netpid =3D open_file->pid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 netpid =3D current->tgid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D=
 CIFSSMBWrite2(xid, tcon, open_file->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes_to_write, offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_written, iov, n_iov,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0netpid, bytes_to_write,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, &bytes_written,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov, n_iov, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifsFi=
leInfo_put(open_file);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> @@ -1567,6 +1580,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0struct cifs_tcon *pTcon;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0int xid, rc;
> + =A0 =A0 =A0 __u32 netpid;
>
> =A0 =A0 =A0 =A0len =3D iov_length(iov, nr_segs);
> =A0 =A0 =A0 =A0if (!len)
> @@ -1598,6 +1612,12 @@ cifs_iovec_write(struct file *file, const stru=
ct iovec *iov,
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> =A0 =A0 =A0 =A0open_file =3D file->private_data;
> +
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
> +
> =A0 =A0 =A0 =A0pTcon =3D tlink_tcon(open_file->tlink);
> =A0 =A0 =A0 =A0inode =3D file->f_path.dentry->d_inode;
>
> @@ -1625,7 +1645,7 @@ cifs_iovec_write(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBWrite2(x=
id, pTcon, open_file->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0cur_len, *poffset, &written,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0netpid, cur_len, *poffset, &written,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 to_send, npages, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} while (rc =3D=3D -EAGAIN);
>
> @@ -1723,6 +1743,7 @@ cifs_iovec_read(struct file *file, const struct=
 iovec *iov,
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> =A0 =A0 =A0 =A0struct smb_com_read_rsp *pSMBr;
> =A0 =A0 =A0 =A0char *read_data;
> + =A0 =A0 =A0 __u32 netpid;
>
> =A0 =A0 =A0 =A0if (!nr_segs)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return 0;
> @@ -1737,6 +1758,11 @@ cifs_iovec_read(struct file *file, const struc=
t iovec *iov,
> =A0 =A0 =A0 =A0open_file =3D file->private_data;
> =A0 =A0 =A0 =A0pTcon =3D tlink_tcon(open_file->tlink);
>
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
> +
> =A0 =A0 =A0 =A0if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "attempting read on write only=
 file instance");
>
> @@ -1753,7 +1779,7 @@ cifs_iovec_read(struct file *file, const struct=
 iovec *iov,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBRead(xid=
, pTcon, open_file->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_len, *poffset, &bytes_read,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0netpid, cur_len, *poffset, &bytes_read,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &read_data, &buf_type);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pSMBr =3D (struct smb_=
com_read_rsp *)read_data;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (read_data) {
> @@ -1835,6 +1861,7 @@ static ssize_t cifs_read(struct file *file, cha=
r *read_data, size_t read_size,
> =A0 =A0 =A0 =A0char *current_offset;
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> =A0 =A0 =A0 =A0int buf_type =3D CIFS_NO_BUFFER;
> + =A0 =A0 =A0 __u32 netpid;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
> @@ -1847,6 +1874,11 @@ static ssize_t cifs_read(struct file *file, ch=
ar *read_data, size_t read_size,
> =A0 =A0 =A0 =A0open_file =3D file->private_data;
> =A0 =A0 =A0 =A0pTcon =3D tlink_tcon(open_file->tlink);
>
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
> +
> =A0 =A0 =A0 =A0if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "attempting read on write only=
 file instance");
>
> @@ -1870,7 +1902,7 @@ static ssize_t cifs_read(struct file *file, cha=
r *read_data, size_t read_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBRead(xid=
, pTcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0open_file->netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0open_file->netfid, netpid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 current_read_size, *poffset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &bytes_read, &current_offset,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &buf_type);
> @@ -2008,6 +2040,7 @@ static int cifs_readpages(struct file *file, st=
ruct address_space *mapping,
> =A0 =A0 =A0 =A0struct smb_com_read_rsp *pSMBr;
> =A0 =A0 =A0 =A0struct cifsFileInfo *open_file;
> =A0 =A0 =A0 =A0int buf_type =3D CIFS_NO_BUFFER;
> + =A0 =A0 =A0 __u32 netpid;
>
> =A0 =A0 =A0 =A0xid =3D GetXid();
> =A0 =A0 =A0 =A0if (file->private_data =3D=3D NULL) {
> @@ -2029,6 +2062,11 @@ static int cifs_readpages(struct file *file, s=
truct address_space *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto read_complete;
>
> =A0 =A0 =A0 =A0cFYI(DBG2, "rpages: num pages %d", num_pages);
> + =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
> +
> =A0 =A0 =A0 =A0for (i =3D 0; i < num_pages; ) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned contig_pages;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct page *tmp_page;
> @@ -2072,10 +2110,9 @@ static int cifs_readpages(struct file *file, s=
truct address_space *mapping,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFSSMBRead(xid=
, pTcon,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0open_file->netfid,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0read_size, offset,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&bytes_read, &smb_read_data,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&buf_type);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0open_file->netfid, netpid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0read_size, offset, &bytes_read,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&smb_read_data, &buf_type);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* BB more RC checks ?=
 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D -EAGAIN)=
 {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (sm=
b_read_data) {
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index adb6324..bafeae6 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -405,7 +405,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const uns=
igned char *path,
> =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int buf_type =3D CIFS_NO_BUFFER;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* Read header */
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid, c=
urrent->tgid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 24 /*=
 length */, 0 /* offset */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &byte=
s_read, &pbuf, &buf_type);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((rc =3D=3D 0) && (bytes_read >=3D =
8)) {
> @@ -1859,8 +1859,9 @@ cifs_set_file_size(struct inode *inode, struct =
iattr *attrs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "SetFSize for attrs rc =3D %d"=
, rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((rc =3D=3D -EINVAL) || (rc =3D=3D =
-EOPNOTSUPP)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int bytes_wri=
tten;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid=
, pTcon, nfid, 0, attrs->ia_size,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 &bytes_written, NULL, NULL, 1);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid=
, pTcon, nfid, npid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 0, attrs->ia_size, &bytes_written,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 NULL, NULL, 1);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cFYI(1, "Wrt seteof rc=
 %d", rc);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0} else
> @@ -1895,7 +1896,8 @@ cifs_set_file_size(struct inode *inode, struct =
iattr *attrs,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0CIFS_MOUNT_MAP_SPECIAL_CHR);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsign=
ed int bytes_written;
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBWrite(xid, pTcon, netfid, 0,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D =
CIFSSMBWrite(xid, pTcon, netfid,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 current->tgid, 0,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0attrs->ia_size,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_written, NULL,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0NULL, 1);
> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
> index 3a097b6..7536104 100644
> --- a/fs/cifs/link.c
> +++ b/fs/cifs/link.c
> @@ -203,7 +203,7 @@ CIFSCreateMFSymLink(const int xid, struct cifs_tc=
on *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return rc;
> =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, tcon, netfid,
> + =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, tcon, netfid, current->tgid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MF_SYMLINK_FI=
LE_SIZE /* length */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00 /* offset */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_written, bu=
f, NULL, 0);
> @@ -250,7 +250,7 @@ CIFSQueryMFSymLink(const int xid, struct cifs_tco=
n *tcon,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
> =A0 =A0 =A0 =A0pbuf =3D buf;
>
> - =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid,
> + =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid, current->tgid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MF_SYMLINK_FILE_=
SIZE /* length */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 /* offset */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_read, &pbuf, &=
buf_type);
> @@ -329,7 +329,7 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0pbuf =3D buf;
>
> - =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, pTcon, netfid,
> + =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, pTcon, netfid, current->tgid,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MF_SYMLINK_FILE_=
SIZE /* length */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 /* offset */,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_read, &pbuf, &=
buf_type);
> --
> 1.7.1
>
>

Sorry - wrong description, will repost it.

--=20
Best regards,
Pavel Shilovsky.
