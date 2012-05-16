From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 3/5] CIFS: Separate protocol specific lock type
 handling
Date: Wed, 16 May 2012 14:25:00 -0400
Message-ID: <20120516142500.531aca81@tlielax.poochiereds.net>
References: <1337162254-13121-1-git-send-email-piastry@etersoft.ru>
	<1337162254-13121-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1337162254-13121-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 May 2012 13:57:32 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/cifsglob.h |    4 ++++
>  fs/cifs/file.c     |   40 ++++++++++++++++++++++++----------------
>  fs/cifs/smb1ops.c  |    5 +++++
>  3 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 0e06de1..6943448 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -164,6 +164,10 @@ struct smb_version_operations {
>  
>  struct smb_version_values {
>  	char		*version_string;
> +	__u32		large_lock_type;
> +	__u32		exclusive_lock_type;
> +	__u32		shared_lock_type;
> +	__u32		unlock_lock_type;
>  };
>  

It would probably be good to send your respin of my patchset so that we
can see what this one is based on...

>  struct smb_vol {
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 8d5d9c0..ac71f85 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -675,12 +675,13 @@ cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
>  			    struct cifsLockInfo **conf_lock)
>  {
>  	struct cifsLockInfo *li;
> +	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
>  
>  	list_for_each_entry(li, &cfile->llist, llist) {
>  		if (offset + length <= li->offset ||
>  		    offset >= li->offset + li->length)
>  			continue;
> -		else if ((type & LOCKING_ANDX_SHARED_LOCK) &&
> +		else if ((type & server->vals->shared_lock_type) &&
>  			 ((netfid == cfile->netfid && current->tgid == li->pid)
>  			 || type == li->type))
>  			continue;
> @@ -726,6 +727,7 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
>  	int rc = 0;
>  	struct cifsLockInfo *conf_lock;
>  	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
> +	struct TCP_Server_Info *server = tlink_tcon(cfile->tlink)->ses->server;
>  	bool exist;
>  
>  	mutex_lock(&cinode->lock_mutex);
> @@ -736,7 +738,7 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
>  		flock->fl_start = conf_lock->offset;
>  		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
>  		flock->fl_pid = conf_lock->pid;
> -		if (conf_lock->type & LOCKING_ANDX_SHARED_LOCK)
> +		if (conf_lock->type & server->vals->shared_lock_type)
>  			flock->fl_type = F_RDLCK;
>  		else
>  			flock->fl_type = F_WRLCK;
> @@ -1069,7 +1071,7 @@ cifs_push_locks(struct cifsFileInfo *cfile)
>  
>  static void
>  cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
> -		bool *wait_flag)
> +		bool *wait_flag, struct TCP_Server_Info *server)
>  {
>  	if (flock->fl_flags & FL_POSIX)
>  		cFYI(1, "Posix");
> @@ -1088,24 +1090,27 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
>  	    (~(FL_POSIX | FL_FLOCK | FL_SLEEP | FL_ACCESS | FL_LEASE)))
>  		cFYI(1, "Unknown lock flags 0x%x", flock->fl_flags);
>  
> -	*type = LOCKING_ANDX_LARGE_FILES;
> +	*type = server->vals->large_lock_type;
>  	if (flock->fl_type == F_WRLCK) {
>  		cFYI(1, "F_WRLCK ");
> +		*type |= server->vals->exclusive_lock_type;
>  		*lock = 1;
>  	} else if (flock->fl_type == F_UNLCK) {
>  		cFYI(1, "F_UNLCK");
> +		*type |= server->vals->unlock_lock_type;
>  		*unlock = 1;
>  		/* Check if unlock includes more than one lock range */
>  	} else if (flock->fl_type == F_RDLCK) {
>  		cFYI(1, "F_RDLCK");
> -		*type |= LOCKING_ANDX_SHARED_LOCK;
> +		*type |= server->vals->shared_lock_type;
>  		*lock = 1;
>  	} else if (flock->fl_type == F_EXLCK) {
>  		cFYI(1, "F_EXLCK");
> +		*type |= server->vals->exclusive_lock_type;
>  		*lock = 1;
>  	} else if (flock->fl_type == F_SHLCK) {
>  		cFYI(1, "F_SHLCK");
> -		*type |= LOCKING_ANDX_SHARED_LOCK;
> +		*type |= server->vals->shared_lock_type;
>  		*lock = 1;
>  	} else
>  		cFYI(1, "Unknown type of lock");
> @@ -1119,6 +1124,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
>  	__u64 length = 1 + flock->fl_end - flock->fl_start;
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> +	struct TCP_Server_Info *server = tcon->ses->server;
>  	__u16 netfid = cfile->netfid;
>  
>  	if (posix_lck) {
> @@ -1128,7 +1134,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
>  		if (!rc)
>  			return rc;
>  
> -		if (type & LOCKING_ANDX_SHARED_LOCK)
> +		if (type & server->vals->shared_lock_type)
>  			posix_lock_type = CIFS_RDLCK;
>  		else
>  			posix_lock_type = CIFS_WRLCK;
> @@ -1152,23 +1158,22 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
>  		flock->fl_type = F_UNLCK;
>  		if (rc != 0)
>  			cERROR(1, "Error unlocking previously locked "
> -				   "range %d during test of lock", rc);
> +				  "range %d during test of lock", rc);
>  		return 0;
>  	}
>  
> -	if (type & LOCKING_ANDX_SHARED_LOCK) {
> +	if (type & server->vals->shared_lock_type) {
>  		flock->fl_type = F_WRLCK;
>  		return 0;
>  	}
>  
>  	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
>  			 flock->fl_start, 0, 1,
> -			 type | LOCKING_ANDX_SHARED_LOCK, 0, 0);
> +			 type | server->vals->shared_lock_type, 0, 0);
>  	if (rc == 0) {
>  		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid,
>  				 length, flock->fl_start, 1, 0,
> -				 type | LOCKING_ANDX_SHARED_LOCK,
> -				 0, 0);
> +				 type | server->vals->shared_lock_type, 0, 0);
>  		flock->fl_type = F_RDLCK;
>  		if (rc != 0)
>  			cERROR(1, "Error unlocking previously locked "
> @@ -1307,6 +1312,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
>  	__u64 length = 1 + flock->fl_end - flock->fl_start;
>  	struct cifsFileInfo *cfile = (struct cifsFileInfo *)file->private_data;
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> +	struct TCP_Server_Info *server = tcon->ses->server;
>  	__u16 netfid = cfile->netfid;
>  
>  	if (posix_lck) {
> @@ -1316,7 +1322,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
>  		if (!rc || rc < 0)
>  			return rc;
>  
> -		if (type & LOCKING_ANDX_SHARED_LOCK)
> +		if (type & server->vals->shared_lock_type)
>  			posix_lock_type = CIFS_RDLCK;
>  		else
>  			posix_lock_type = CIFS_WRLCK;
> @@ -1380,11 +1386,13 @@ int cifs_lock(struct file *file, int cmd, struct file_lock *flock)
>  		"end: %lld", cmd, flock->fl_flags, flock->fl_type,
>  		flock->fl_start, flock->fl_end);
>  
> -	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag);
> -
> -	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
>  	cfile = (struct cifsFileInfo *)file->private_data;
>  	tcon = tlink_tcon(cfile->tlink);
> +
> +	cifs_read_flock(flock, &type, &lock, &unlock, &wait_flag,
> +			tcon->ses->server);
> +
> +	cifs_sb = CIFS_SB(file->f_path.dentry->d_sb);
>  	netfid = cfile->netfid;
>  	cinode = CIFS_I(file->f_path.dentry->d_inode);
>  
> diff --git a/fs/cifs/smb1ops.c b/fs/cifs/smb1ops.c
> index fa486f0..af48a8b 100644
> --- a/fs/cifs/smb1ops.c
> +++ b/fs/cifs/smb1ops.c
> @@ -20,6 +20,7 @@
>  #include "cifsglob.h"
>  #include "cifsproto.h"
>  #include "cifs_debug.h"
> +#include "cifspdu.h"
>  
>  /*
>   * An NT cancel request header looks just like the original request except:
> @@ -65,4 +66,8 @@ struct smb_version_operations smb1_operations = {
>  
>  struct smb_version_values smb1_values = {
>  	.version_string = SMB1_VERSION_STRING,
> +	.large_lock_type = LOCKING_ANDX_LARGE_FILES,
> +	.exclusive_lock_type = 0,
> +	.shared_lock_type = LOCKING_ANDX_SHARED_LOCK,
> +	.unlock_lock_type = 0,
>  };

Much cleaner than having a bunch of is_smb2 checks all over the place.

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
