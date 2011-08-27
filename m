From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix the conflict between rwpidforward and rw
 mount options
Date: Sat, 27 Aug 2011 06:00:11 -0400
Message-ID: <20110827060011.55847806@tlielax.poochiereds.net>
References: <1314381783-5614-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314381783-5614-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 26 Aug 2011 22:03:03 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Both these options are started with "rw" - that's why the first one
> isn't switched on even if it is specified. Rename it to piforwardio
> to avoid the wrong matching.
> 
> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>


This seems like the wrong way to fix this. Isn't this a problem in
userspace code? It seems like fixing mount.cifs to handle this properly
would be a better fix, and we wouldn't need to change a mount option
(without warning) that's already in kernels that are in the field.

NAK from my point of view...

> ---
>  fs/cifs/README       |    2 +-
>  fs/cifs/cifs_fs_sb.h |    2 +-
>  fs/cifs/cifsfs.c     |    6 ++++--
>  fs/cifs/cifsglob.h   |    2 +-
>  fs/cifs/connect.c    |    8 ++++----
>  fs/cifs/file.c       |   10 +++++-----
>  6 files changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/cifs/README b/fs/cifs/README
> index c5c2c5e..a943855 100644
> --- a/fs/cifs/README
> +++ b/fs/cifs/README
> @@ -457,7 +457,7 @@ A partial list of the supported mount options follows:
>  		otherwise - read from the server. All written data are stored
>  		in the cache, but if the client doesn't have Exclusive Oplock,
>  		it writes the data to the server.
> -  rwpidforward  Forward pid of a process who opened a file to any read or write
> +  pidforwardio  Forward pid of a process who opened a file to any read or write
>  		operation on that file. This prevent applications like WINE
>  		from failing on read and write if we use mandatory brlock style.
>    acl   	Allow setfacl and getfacl to manage posix ACLs if server
> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> index 7260e11..2a74b6f 100644
> --- a/fs/cifs/cifs_fs_sb.h
> +++ b/fs/cifs/cifs_fs_sb.h
> @@ -41,7 +41,7 @@
>  #define CIFS_MOUNT_MF_SYMLINKS	0x10000 /* Minshall+French Symlinks enabled */
>  #define CIFS_MOUNT_MULTIUSER	0x20000 /* multiuser mount */
>  #define CIFS_MOUNT_STRICT_IO	0x40000 /* strict cache mode */
> -#define CIFS_MOUNT_RWPIDFORWARD	0x80000 /* use pid forwarding for rw */
> +#define CIFS_MOUNT_PIDFORWARD_IO 0x80000 /* use pid forwarding for rw */
>  #define CIFS_MOUNT_POSIXACL	0x100000 /* mirror of MS_POSIXACL in mnt_cifs_flags */
>  
>  struct cifs_sb_info {
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index f93eb94..1b16773 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -408,10 +408,12 @@ cifs_show_options(struct seq_file *s, struct vfsmount *m)
>  		seq_printf(s, ",setuids");
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_SERVER_INUM)
>  		seq_printf(s, ",serverino");
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> -		seq_printf(s, ",rwpidforward");
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_PIDFORWARD_IO)
> +		seq_printf(s, ",pidforwardio");
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL)
>  		seq_printf(s, ",forcemand");
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO)
> +		seq_printf(s, ",strictcache");
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_DIRECT_IO)
>  		seq_printf(s, ",directio");
>  	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NO_XATTR)
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 95dad9d..a37452d 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -200,7 +200,7 @@ struct smb_vol {
>  	bool fsc:1;	/* enable fscache */
>  	bool mfsymlinks:1; /* use Minshall+French Symlinks */
>  	bool multiuser:1;
> -	bool rwpidforward:1; /* pid forward for read/write operations */
> +	bool pidforwardio:1; /* pid forward for read/write operations */
>  	unsigned int rsize;
>  	unsigned int wsize;
>  	bool sockopt_tcp_nodelay:1;
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 633c246..2cadc34 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1401,8 +1401,8 @@ cifs_parse_mount_options(const char *mountdata, const char *devname,
>  			vol->server_ino = 1;
>  		} else if (strnicmp(data, "noserverino", 9) == 0) {
>  			vol->server_ino = 0;
> -		} else if (strnicmp(data, "rwpidforward", 4) == 0) {
> -			vol->rwpidforward = 1;
> +		} else if (strnicmp(data, "pidforwardio", 12) == 0) {
> +			vol->pidforwardio = 1;
>  		} else if (strnicmp(data, "cifsacl", 7) == 0) {
>  			vol->cifs_acl = 1;
>  		} else if (strnicmp(data, "nocifsacl", 9) == 0) {
> @@ -2759,8 +2759,8 @@ void cifs_setup_cifs_sb(struct smb_vol *pvolume_info,
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOSSYNC;
>  	if (pvolume_info->mand_lock)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_NOPOSIXBRL;
> -	if (pvolume_info->rwpidforward)
> -		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_RWPIDFORWARD;
> +	if (pvolume_info->pidforwardio)
> +		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_PIDFORWARD_IO;
>  	if (pvolume_info->cifs_acl)
>  		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_CIFS_ACL;
>  	if (pvolume_info->override_uid)
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 9f41a10..bfa7c26 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1352,7 +1352,7 @@ static int cifs_write_end(struct file *file, struct address_space *mapping,
>  	struct cifs_sb_info *cifs_sb = CIFS_SB(cfile->dentry->d_sb);
>  	__u32 pid;
>  
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_PIDFORWARD_IO)
>  		pid = cfile->pid;
>  	else
>  		pid = current->tgid;
> @@ -1579,7 +1579,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
>  	xid = GetXid();
>  	open_file = file->private_data;
>  
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_PIDFORWARD_IO)
>  		pid = open_file->pid;
>  	else
>  		pid = current->tgid;
> @@ -1729,7 +1729,7 @@ cifs_iovec_read(struct file *file, const struct iovec *iov,
>  	open_file = file->private_data;
>  	pTcon = tlink_tcon(open_file->tlink);
>  
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_PIDFORWARD_IO)
>  		pid = open_file->pid;
>  	else
>  		pid = current->tgid;
> @@ -1850,7 +1850,7 @@ static ssize_t cifs_read(struct file *file, char *read_data, size_t read_size,
>  	open_file = file->private_data;
>  	pTcon = tlink_tcon(open_file->tlink);
>  
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_PIDFORWARD_IO)
>  		pid = open_file->pid;
>  	else
>  		pid = current->tgid;
> @@ -2044,7 +2044,7 @@ static int cifs_readpages(struct file *file, struct address_space *mapping,
>  		goto read_complete;
>  
>  	cFYI(DBG2, "rpages: num pages %d", num_pages);
> -	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_RWPIDFORWARD)
> +	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_PIDFORWARD_IO)
>  		pid = open_file->pid;
>  	else
>  		pid = current->tgid;


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
