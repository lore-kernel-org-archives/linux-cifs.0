From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add wine mount option
Date: Sun, 10 Apr 2011 15:28:15 +0400
Message-ID: <BANLkTi=0t1e1ed0XsY0EXwF9saWJqmgMyw@mail.gmail.com>
References: <1302190937-7274-1-git-send-email-piastry@etersoft.ru>
	<20110408100109.6b296bc7@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110408100109.6b296bc7-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/8 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Thu, =A07 Apr 2011 19:42:17 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Add wine mount option that switches on WINE-capability mode - forwar=
d
>> pid of a process who opened a file to any read and write operation
>> even if the file descriptor was inherited by another process.
>>
>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
>
> What problem does this solve? Why should we do this? If it's a
> reasonable thing to do, perhaps we needn't use a mount option for thi=
s
> and can turn it on unconditionally. To my knowledge the pid isn't
> really used much by the server, is it? I suppose it could if there we=
re
> FID conflicts, but does that ever happen?

Sorry for being unclear in the description.

In WINE there are wine-server and wine-application. The first opens
files and sets brlocks, the second - reads and writes. Wine-server
sends fd to wine-application to perform read and write, but
wine-server and wine-application are two different processes with
different pids. And then wine-application does reads or writes on
locked region with fd it needs to set pid of process that and opened a
file and set locks (wine-server). Otherwise, a operation fails.

As for servers - Samba and Windows 7 servers does pid check. The only
way where Samba doesn't do brlock check during read or write request
processing is 'strict locking =3D auto' (by default) and a file is
oplocked.

We should not use this mode always, because in this case when we open
a file and do fork a child process will get access on the locked
region - I don't think that we need it.

As for strict_io and mand_lock mode - both is necessary for get WINE
application work correctly.

Anyway, I will provide the right description with the try #2 soon.

>
>
>> ---
>> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
>> =A0fs/cifs/cifsfs.c =A0 =A0 | =A0 =A08 ++++++
>> =A0fs/cifs/cifsproto.h =A0| =A0 21 ++++++++-------
>> =A0fs/cifs/cifssmb.c =A0 =A0| =A0 31 +++++++++++++++-------
>> =A0fs/cifs/connect.c =A0 =A0| =A0 =A07 +++++
>> =A0fs/cifs/dir.c =A0 =A0 =A0 =A0| =A0 =A04 +-
>> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 69 +++++++++++++++++++++++++++++=
+++++++++-----------
>> =A0fs/cifs/inode.c =A0 =A0 =A0| =A0 10 ++++---
>> =A0fs/cifs/link.c =A0 =A0 =A0 | =A0 =A06 ++--
>> =A09 files changed, 112 insertions(+), 45 deletions(-)
>>
>> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
>> index 1ef54ab..7a24eb3 100644
>> --- a/fs/cifs/cifs_fs_sb.h
>> +++ b/fs/cifs/cifs_fs_sb.h
>> @@ -43,6 +43,7 @@
>> =A0#define CIFS_MOUNT_MF_SYMLINKS =A0 =A0 =A0 0x10000 /* Minshall+Fr=
ench Symlinks enabled */
>> =A0#define CIFS_MOUNT_MULTIUSER 0x20000 /* multiuser mount */
>> =A0#define CIFS_MOUNT_STRICT_IO 0x40000 /* strict cache mode */
>> +#define CIFS_MOUNT_WINE_MODE 0x80000 /* use pid forwarding for wine=
 apps */
>>
>> =A0struct cifs_sb_info {
>> =A0 =A0 =A0 struct rb_root tlink_tree;
>> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
>> index fb6a2ad..f4ec759 100644
>> --- a/fs/cifs/cifsfs.c
>> +++ b/fs/cifs/cifsfs.c
>> @@ -460,6 +460,10 @@ cifs_show_options(struct seq_file *s, struct vf=
smount *m)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",nocase");
>> =A0 =A0 =A0 if (tcon->retry)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",hard");
>> + =A0 =A0 if (tcon->unix_ext)
>> + =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",unix");
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",nounix");
>> =A0 =A0 =A0 if (cifs_sb->prepath)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",prepath=3D%s", cifs_sb->=
prepath);
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_POSIX_PATHS)
>> @@ -468,6 +472,10 @@ cifs_show_options(struct seq_file *s, struct vf=
smount *m)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",setuids");
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",serverino");
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_WINE_MODE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",wine");
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
>> + =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",forcemand");
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 seq_printf(s, ",directio");
>> =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
>> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
>> index 76c4dc7..28e975c 100644
>> --- a/fs/cifs/cifsproto.h
>> +++ b/fs/cifs/cifsproto.h
>> @@ -335,18 +335,19 @@ extern int CIFSSMBFlush(const int xid, struct =
cifs_tcon *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int smb_file_id);
>>
>> =A0extern int CIFSSMBRead(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, unsigned=
 int count,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 lseek, unsigne=
d int *nbytes, char **buf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 int *return_buf_type);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const __=
u32 netpid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int count, const =
__u64 lseek,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, char=
 **buf, int *return_buf_type);
>> =A0extern int CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const un=
signed int count,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 lseek, unsigne=
d int *nbytes,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char *buf, const cha=
r __user *ubuf,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const __=
u32 netpid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned int count, =
const __u64 lseek,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, cons=
t char *buf,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const char __user *ubuf, c=
onst int long_op);
>> =A0extern int CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const un=
signed int count,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const __u64 offset, unsign=
ed int *nbytes,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct kvec *iov, const in=
t nvec, const int long_op);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int netfid, const __=
u32 netpid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned int count, =
const __u64 offset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, stru=
ct kvec *iov, const int nvec,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const int long_op);
>> =A0extern int CIFSGetSrvInodeNumber(const int xid, struct cifs_tcon =
*tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const unsigned char *sea=
rchName, __u64 *inode_number,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 const struct nls_table *=
nls_codepage,
>> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
>> index 3291770..890897c 100644
>> --- a/fs/cifs/cifssmb.c
>> +++ b/fs/cifs/cifssmb.c
>> @@ -1380,8 +1380,8 @@ openRetry:
>>
>> =A0int
>> =A0CIFSSMBRead(const int xid, struct cifs_tcon *tcon, const int netf=
id,
>> - =A0 =A0 =A0 =A0 const unsigned int count, const __u64 lseek, unsig=
ned int *nbytes,
>> - =A0 =A0 =A0 =A0 char **buf, int *pbuf_type)
>> + =A0 =A0 =A0 =A0 const __u32 netpid, const unsigned int count, cons=
t __u64 lseek,
>> + =A0 =A0 =A0 =A0 unsigned int *nbytes, char **buf, int *pbuf_type)
>> =A0{
>> =A0 =A0 =A0 int rc =3D -EACCES;
>> =A0 =A0 =A0 READ_REQ *pSMB =3D NULL;
>> @@ -1407,6 +1407,9 @@ CIFSSMBRead(const int xid, struct cifs_tcon *t=
con, const int netfid,
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>>
>> + =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
>> + =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16));
>> +
>> =A0 =A0 =A0 /* tcon and ses pointer are checked in smb_init */
>> =A0 =A0 =A0 if (tcon->ses->server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ECONNABORTED;
>> @@ -1484,10 +1487,10 @@ CIFSSMBRead(const int xid, struct cifs_tcon =
*tcon, const int netfid,
>>
>>
>> =A0int
>> -CIFSSMBWrite(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
>> - =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, const=
 char *buf,
>> - =A0 =A0 =A0 =A0 =A0const char __user *ubuf, const int long_op)
>> +CIFSSMBWrite(const int xid, struct cifs_tcon *tcon, const int netfi=
d,
>> + =A0 =A0 =A0 =A0 =A0const __u32 netpid, const unsigned int count, c=
onst __u64 offset,
>> + =A0 =A0 =A0 =A0 =A0unsigned int *nbytes, const char *buf, const ch=
ar __user *ubuf,
>> + =A0 =A0 =A0 =A0 =A0const int long_op)
>> =A0{
>> =A0 =A0 =A0 int rc =3D -EACCES;
>> =A0 =A0 =A0 WRITE_REQ *pSMB =3D NULL;
>> @@ -1516,6 +1519,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon =
*tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (void **) &pSMBr);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
>> + =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16));
>> +
>> =A0 =A0 =A0 /* tcon and ses pointer are checked in smb_init */
>> =A0 =A0 =A0 if (tcon->ses->server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ECONNABORTED;
>> @@ -1603,10 +1610,10 @@ CIFSSMBWrite(const int xid, struct cifs_tcon=
 *tcon,
>> =A0}
>>
>> =A0int
>> -CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon,
>> - =A0 =A0 =A0 =A0 =A0const int netfid, const unsigned int count,
>> - =A0 =A0 =A0 =A0 =A0const __u64 offset, unsigned int *nbytes, struc=
t kvec *iov,
>> - =A0 =A0 =A0 =A0 =A0int n_vec, const int long_op)
>> +CIFSSMBWrite2(const int xid, struct cifs_tcon *tcon, const int netf=
id,
>> + =A0 =A0 =A0 =A0 =A0 const __u32 netpid, const unsigned int count, =
const __u64 offset,
>> + =A0 =A0 =A0 =A0 =A0 unsigned int *nbytes, struct kvec *iov, int n_=
vec,
>> + =A0 =A0 =A0 =A0 =A0 const int long_op)
>> =A0{
>> =A0 =A0 =A0 int rc =3D -EACCES;
>> =A0 =A0 =A0 WRITE_REQ *pSMB =3D NULL;
>> @@ -1630,6 +1637,10 @@ CIFSSMBWrite2(const int xid, struct cifs_tcon=
 *tcon,
>> =A0 =A0 =A0 rc =3D small_smb_init(SMB_COM_WRITE_ANDX, wct, tcon, (vo=
id **) &pSMB);
>> =A0 =A0 =A0 if (rc)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> +
>> + =A0 =A0 pSMB->hdr.Pid =3D cpu_to_le16((__u16)netpid);
>> + =A0 =A0 pSMB->hdr.PidHigh =3D cpu_to_le16((__u16)(netpid >> 16));
>> +
>> =A0 =A0 =A0 /* tcon and ses pointer are checked in smb_init */
>> =A0 =A0 =A0 if (tcon->ses->server =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ECONNABORTED;
>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> index 94e60c5..c540028 100644
>> --- a/fs/cifs/connect.c
>> +++ b/fs/cifs/connect.c
>> @@ -103,6 +103,7 @@ struct smb_vol {
>> =A0 =A0 =A0 bool noautotune:1;
>> =A0 =A0 =A0 bool nostrictsync:1; /* do not force expensive SMBflush =
on every sync */
>> =A0 =A0 =A0 bool fsc:1; =A0 =A0 /* enable fscache */
>> + =A0 =A0 bool wine_mode:1;
>> =A0 =A0 =A0 bool mfsymlinks:1; /* use Minshall+French Symlinks */
>> =A0 =A0 =A0 bool multiuser:1;
>> =A0 =A0 =A0 bool use_smb2:1; /* force smb2 use on mount instead of c=
ifs */
>> @@ -1362,6 +1363,10 @@ cifs_parse_mount_options(char *options, const=
 char *devname,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->server_ino =3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "noserverino",=
 9) =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->server_ino =3D 0;
>> + =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "wine", 4) =3D=3D=
 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->wine_mode =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->mand_lock =3D 1;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->strict_io =3D 1;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^^^^^
> This seems to do a lot more than what your description suggests.
>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "cifsacl", 7) =
=3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 vol->cifs_acl =3D 1;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else if (strnicmp(data, "nocifsacl", 9=
) =3D=3D 0) {
>> @@ -2643,6 +2648,8 @@ static void setup_cifs_sb(struct smb_vol *pvol=
ume_info,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_=
NOSSYNC;
>> =A0 =A0 =A0 if (pvolume_info->mand_lock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_=
NOPOSIXBRL;
>> + =A0 =A0 if (pvolume_info->wine_mode)
>> + =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_WI=
NE_MODE;
>> =A0 =A0 =A0 if (pvolume_info->cifs_acl)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_sb->mnt_cifs_flags |=3D CIFS_MOUNT_=
CIFS_ACL;
>> =A0 =A0 =A0 if (pvolume_info->override_uid)
>> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
>> index ab74179..6cdac98 100644
>> --- a/fs/cifs/dir.c
>> +++ b/fs/cifs/dir.c
>> @@ -446,7 +446,7 @@ int cifs_mknod(struct inode *inode, struct dentr=
y *direntry, int mode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdev->minor =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le64(MINOR(device_num=
ber));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, pTcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle, current->tgid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct win_dev),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, &bytes_written, (char=
 *)pdev,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, 0);
>> @@ -457,7 +457,7 @@ int cifs_mknod(struct inode *inode, struct dentr=
y *direntry, int mode,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pdev->minor =3D
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le64(MINOR(device_num=
ber));
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, pTcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fileHandle, current->tgid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof(struct win_dev),
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0, &bytes_written, (char=
 *)pdev,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, 0);
>> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> index 9c7f83f..635806f 100644
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
>> @@ -725,8 +725,8 @@ int cifs_lock(struct file *file, int cmd, struct=
 file_lock *pfLock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lo=
ck_type =3D CIFS_WRLCK;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBPosixLock(=
xid, tcon, netfid, 1 /* get */,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 length, pfLock,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 posix_lock_type, wait_flag);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 length, pfLock, posix_lock_type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 wait_flag);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 FreeXid(xid);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> @@ -797,8 +797,8 @@ int cifs_lock(struct file *file, int cmd, struct=
 file_lock *pfLock)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 posix_lock_type =3D CIFS=
_UNLCK;
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBPosixLock(xid, tcon, netfi=
d, 0 /* set */,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 length, pfLock,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 posix_lock_type, wait_flag);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 length, pfLock, posix_lock_type,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 wait_flag);
>> =A0 =A0 =A0 } else {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct cifsFileInfo *fid =3D file->priva=
te_data;
>>
>> @@ -866,6 +866,7 @@ static ssize_t cifs_write(struct cifsFileInfo *o=
pen_file,
>> =A0 =A0 =A0 unsigned int total_written;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 struct cifs_tcon *pTcon;
>> + =A0 =A0 __u32 netpid;
>> =A0 =A0 =A0 int xid;
>> =A0 =A0 =A0 struct dentry *dentry =3D open_file->dentry;
>> =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(dentry->d_inode);
>> @@ -877,6 +878,11 @@ static ssize_t cifs_write(struct cifsFileInfo *=
open_file,
>>
>> =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
>>
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_WINE_MODE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
>> +
>> =A0 =A0 =A0 xid =3D GetXid();
>>
>> =A0 =A0 =A0 for (total_written =3D 0; write_size > total_written;
>> @@ -901,8 +907,9 @@ static ssize_t cifs_write(struct cifsFileInfo *o=
pen_file,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* iov[0] is reserved fo=
r smb header */
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_base =3D (cha=
r *)write_data + total_written;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 iov[1].iov_len =3D len;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid, len,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 *poffset, &bytes_written, iov, 1, 0);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid, =
pTcon, open_file->netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0netpid, len, *poffset,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0&bytes_written, iov, 1, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc || (bytes_written =3D=3D 0)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (total_written)
>> @@ -1112,6 +1119,7 @@ static int cifs_writepages(struct address_spac=
e *mapping,
>> =A0 =A0 =A0 struct pagevec pvec;
>> =A0 =A0 =A0 int rc =3D 0;
>> =A0 =A0 =A0 int scanned =3D 0;
>> + =A0 =A0 __u32 netpid;
>> =A0 =A0 =A0 int xid;
>>
>> =A0 =A0 =A0 cifs_sb =3D CIFS_SB(mapping->host->i_sb);
>> @@ -1251,10 +1259,15 @@ retry_write:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cERROR(1=
, "No writable handles for inode");
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D -=
EBADF;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_s=
b->mnt_cifs_flags &
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MOUNT_WINE_MODE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 netpid =3D open_file->pid;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 netpid =3D current->tgid;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D C=
IFSSMBWrite2(xid, tcon, open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0bytes_to_write, offset,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_written, iov, n_iov,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A00);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0netpid, bytes_to_write,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0offset, &bytes_written,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0iov, n_iov, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifsFile=
Info_put(open_file);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> @@ -1567,6 +1580,7 @@ cifs_iovec_write(struct file *file, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 struct cifs_tcon *pTcon;
>> =A0 =A0 =A0 struct cifs_sb_info *cifs_sb;
>> =A0 =A0 =A0 int xid, rc;
>> + =A0 =A0 __u32 netpid;
>>
>> =A0 =A0 =A0 len =3D iov_length(iov, nr_segs);
>> =A0 =A0 =A0 if (!len)
>> @@ -1598,6 +1612,12 @@ cifs_iovec_write(struct file *file, const str=
uct iovec *iov,
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> =A0 =A0 =A0 open_file =3D file->private_data;
>> +
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_WINE_MODE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
>> +
>> =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
>> =A0 =A0 =A0 inode =3D file->f_path.dentry->d_inode;
>>
>> @@ -1625,7 +1645,7 @@ cifs_iovec_write(struct file *file, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite2(xid=
, pTcon, open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0cur_len, *poffset, &written,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0netpid, cur_len, *poffset, &written,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0to_send, npages, 0);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 } while (rc =3D=3D -EAGAIN);
>>
>> @@ -1723,6 +1743,7 @@ cifs_iovec_read(struct file *file, const struc=
t iovec *iov,
>> =A0 =A0 =A0 struct cifsFileInfo *open_file;
>> =A0 =A0 =A0 struct smb_com_read_rsp *pSMBr;
>> =A0 =A0 =A0 char *read_data;
>> + =A0 =A0 __u32 netpid;
>>
>> =A0 =A0 =A0 if (!nr_segs)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return 0;
>> @@ -1737,6 +1758,11 @@ cifs_iovec_read(struct file *file, const stru=
ct iovec *iov,
>> =A0 =A0 =A0 open_file =3D file->private_data;
>> =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
>>
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_WINE_MODE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
>> +
>> =A0 =A0 =A0 if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "attempting read on write only f=
ile instance");
>>
>> @@ -1753,7 +1779,7 @@ cifs_iovec_read(struct file *file, const struc=
t iovec *iov,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, =
pTcon, open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0cur_len, *poffset, &bytes_read,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0netpid, cur_len, *poffset, &bytes_read,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&read_data, &buf_type);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMBr =3D (struct smb_co=
m_read_rsp *)read_data;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (read_data) {
>> @@ -1835,6 +1861,7 @@ static ssize_t cifs_read(struct file *file, ch=
ar *read_data, size_t read_size,
>> =A0 =A0 =A0 char *current_offset;
>> =A0 =A0 =A0 struct cifsFileInfo *open_file;
>> =A0 =A0 =A0 int buf_type =3D CIFS_NO_BUFFER;
>> + =A0 =A0 __u32 netpid;
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> =A0 =A0 =A0 cifs_sb =3D CIFS_SB(file->f_path.dentry->d_sb);
>> @@ -1847,6 +1874,11 @@ static ssize_t cifs_read(struct file *file, c=
har *read_data, size_t read_size,
>> =A0 =A0 =A0 open_file =3D file->private_data;
>> =A0 =A0 =A0 pTcon =3D tlink_tcon(open_file->tlink);
>>
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_WINE_MODE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
>> +
>> =A0 =A0 =A0 if ((file->f_flags & O_ACCMODE) =3D=3D O_WRONLY)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "attempting read on write only f=
ile instance");
>>
>> @@ -1870,7 +1902,7 @@ static ssize_t cifs_read(struct file *file, ch=
ar *read_data, size_t read_size,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 break;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, =
pTcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0open_file->netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0open_file->netfid, netpid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0current_read_size, *poffset,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&bytes_read, &current_offset,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0&buf_type);
>> @@ -2008,6 +2040,7 @@ static int cifs_readpages(struct file *file, s=
truct address_space *mapping,
>> =A0 =A0 =A0 struct smb_com_read_rsp *pSMBr;
>> =A0 =A0 =A0 struct cifsFileInfo *open_file;
>> =A0 =A0 =A0 int buf_type =3D CIFS_NO_BUFFER;
>> + =A0 =A0 __u32 netpid;
>>
>> =A0 =A0 =A0 xid =3D GetXid();
>> =A0 =A0 =A0 if (file->private_data =3D=3D NULL) {
>> @@ -2029,6 +2062,11 @@ static int cifs_readpages(struct file *file, =
struct address_space *mapping,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto read_complete;
>>
>> =A0 =A0 =A0 cFYI(DBG2, "rpages: num pages %d", num_pages);
>> + =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_WINE_MODE)
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D open_file->pid;
>> + =A0 =A0 else
>> + =A0 =A0 =A0 =A0 =A0 =A0 netpid =3D current->tgid;
>> +
>> =A0 =A0 =A0 for (i =3D 0; i < num_pages; ) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned contig_pages;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct page *tmp_page;
>> @@ -2072,10 +2110,9 @@ static int cifs_readpages(struct file *file, =
struct address_space *mapping,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>>
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, =
pTcon,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0open_file->netfid,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0read_size, offset,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&bytes_read, &smb_read_data,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&buf_type);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0open_file->netfid, netpid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0read_size, offset, &bytes_read,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0&smb_read_data, &buf_type);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* BB more RC checks ? *=
/
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D -EAGAIN) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (smb_=
read_data) {
>> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
>> index adb6324..bafeae6 100644
>> --- a/fs/cifs/inode.c
>> +++ b/fs/cifs/inode.c
>> @@ -405,7 +405,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const un=
signed char *path,
>> =A0 =A0 =A0 if (rc =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int buf_type =3D CIFS_NO_BUFFER;
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Read header */
>> - =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid, curr=
ent->tgid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A024 /*=
 length */, 0 /* offset */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&byte=
s_read, &pbuf, &buf_type);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((rc =3D=3D 0) && (bytes_read >=3D 8)=
) {
>> @@ -1859,8 +1859,9 @@ cifs_set_file_size(struct inode *inode, struct=
 iattr *attrs,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "SetFSize for attrs rc =3D %d", =
rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((rc =3D=3D -EINVAL) || (rc =3D=3D -E=
OPNOTSUPP)) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned int bytes_writt=
en;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, p=
Tcon, nfid, 0, attrs->ia_size,
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 &bytes_written, NULL, NULL, 1);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIFSSMBWrite(xid, p=
Tcon, nfid, npid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 0, attrs->ia_size, &bytes_written,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 NULL, NULL, 1);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "Wrt seteof rc %=
d", rc);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> =A0 =A0 =A0 } else
>> @@ -1895,7 +1896,8 @@ cifs_set_file_size(struct inode *inode, struct=
 iattr *attrs,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 CIFS_MOUNT_MAP_SPECIAL_CHR);
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc =3D=3D 0) {
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 unsigned=
 int bytes_written;
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIF=
SSMBWrite(xid, pTcon, netfid, 0,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D CIF=
SSMBWrite(xid, pTcon, netfid,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 current->tgid, 0,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 attrs->ia_size,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, NULL,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 =A0 NULL, 1);
>> diff --git a/fs/cifs/link.c b/fs/cifs/link.c
>> index 3a097b6..7536104 100644
>> --- a/fs/cifs/link.c
>> +++ b/fs/cifs/link.c
>> @@ -203,7 +203,7 @@ CIFSCreateMFSymLink(const int xid, struct cifs_t=
con *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return rc;
>> =A0 =A0 =A0 }
>>
>> - =A0 =A0 rc =3D CIFSSMBWrite(xid, tcon, netfid,
>> + =A0 =A0 rc =3D CIFSSMBWrite(xid, tcon, netfid, current->tgid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFS_MF_SYMLINK_FILE=
_SIZE /* length */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 0 /* offset */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &bytes_written, buf,=
 NULL, 0);
>> @@ -250,7 +250,7 @@ CIFSQueryMFSymLink(const int xid, struct cifs_tc=
on *tcon,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -ENOMEM;
>> =A0 =A0 =A0 pbuf =3D buf;
>>
>> - =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid,
>> + =A0 =A0 rc =3D CIFSSMBRead(xid, tcon, netfid, current->tgid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MF_SYMLINK_FILE_=
SIZE /* length */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00 /* offset */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_read, &pbuf, &=
buf_type);
>> @@ -329,7 +329,7 @@ CIFSCheckMFSymlink(struct cifs_fattr *fattr,
>> =A0 =A0 =A0 }
>> =A0 =A0 =A0 pbuf =3D buf;
>>
>> - =A0 =A0 rc =3D CIFSSMBRead(xid, pTcon, netfid,
>> + =A0 =A0 rc =3D CIFSSMBRead(xid, pTcon, netfid, current->tgid,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CIFS_MF_SYMLINK_FILE_=
SIZE /* length */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00 /* offset */,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&bytes_read, &pbuf, &=
buf_type);
>
>
> --
> Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
>



--=20
Best regards,
Pavel Shilovsky.
