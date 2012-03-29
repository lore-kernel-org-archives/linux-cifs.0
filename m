From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 3/5] CIFS: Separate protocol specific lock type
 handling
Date: Thu, 29 Mar 2012 15:34:10 -0400
Message-ID: <20120329153410.5fbe217b@corrin.poochiereds.net>
References: <1332848319-6483-1-git-send-email-piastry@etersoft.ru>
	<1332848319-6483-4-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1332848319-6483-4-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Mar 2012 15:38:37 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> ---
>  fs/cifs/file.c |   48 +++++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 37 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 2e541f0..6e72b1f 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -684,6 +684,30 @@ cifs_locks_delete_block(struct file_lock *waiter)
>  	unlock_flocks();
>  }
>  
> +static inline __u32
> +large_lock_type(void)
> +{
> +	return LOCKING_ANDX_LARGE_FILES;
> +}
> +
> +static inline __u32
> +exclusive_lock_type(void)
> +{
> +	return 0;
> +}
> +
> +static inline __u32
> +shared_lock_type(void)
> +{
> +	return LOCKING_ANDX_SHARED_LOCK;
> +}
> +
> +static inline __u32
> +unlock_lock_type(void)
> +{
> +	return 0;
> +}
> +

I assume that at some point you'll need to add a set of SMB2 equivalent
ops and then swap them in (probably at NEGOTIATE time)?

If so, would it make sense to bundle these up into a "struct
smb_protocol_operations" and hang it off the TCP_Server_Info? Then
you'd just turn the calls below into stuff like:

    server->proto_ops->large_lock_type

By doing that, it'll be easier to merge in SMB2 code without disturbing
the existing code as much. Also, if we find later that we need a new
set of ops for 2.1, 2.2, 2.3, etc, then we can simply drop in
replacement operations for them.

I think doing that will be more sound engineering than sprinkling
"is_smb2" checks all over the place...

>  static bool
>  __cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
>  			      __u64 length, __u8 type, __u16 netfid,
> @@ -695,7 +719,7 @@ __cifs_find_fid_lock_conflict(struct cifsFileInfo *cfile, __u64 offset,
>  		if (offset + length <= li->offset ||
>  		    offset >= li->offset + li->length)
>  			continue;
> -		else if ((type & LOCKING_ANDX_SHARED_LOCK) &&
> +		else if ((type & shared_lock_type()) &&
>  			 ((netfid == cfile->netfid && current->tgid == li->pid)
>  			 || type == li->type))
>  			continue;
> @@ -764,7 +788,7 @@ cifs_lock_test(struct cifsFileInfo *cfile, __u64 offset, __u64 length,
>  		flock->fl_start = conf_lock->offset;
>  		flock->fl_end = conf_lock->offset + conf_lock->length - 1;
>  		flock->fl_pid = conf_lock->pid;
> -		if (conf_lock->type & LOCKING_ANDX_SHARED_LOCK)
> +		if (conf_lock->type & shared_lock_type())
>  			flock->fl_type = F_RDLCK;
>  		else
>  			flock->fl_type = F_WRLCK;
> @@ -1141,24 +1165,27 @@ cifs_read_flock(struct file_lock *flock, __u32 *type, int *lock, int *unlock,
>  	    (~(FL_POSIX | FL_FLOCK | FL_SLEEP | FL_ACCESS | FL_LEASE)))
>  		cFYI(1, "Unknown lock flags 0x%x", flock->fl_flags);
>  
> -	*type = LOCKING_ANDX_LARGE_FILES;
> +	*type = large_lock_type();
>  	if (flock->fl_type == F_WRLCK) {
>  		cFYI(1, "F_WRLCK ");
> +		*type |= exclusive_lock_type();
>  		*lock = 1;
>  	} else if (flock->fl_type == F_UNLCK) {
>  		cFYI(1, "F_UNLCK");
> +		*type |= unlock_lock_type();
>  		*unlock = 1;
>  		/* Check if unlock includes more than one lock range */
>  	} else if (flock->fl_type == F_RDLCK) {
>  		cFYI(1, "F_RDLCK");
> -		*type |= LOCKING_ANDX_SHARED_LOCK;
> +		*type |= shared_lock_type();
>  		*lock = 1;
>  	} else if (flock->fl_type == F_EXLCK) {
>  		cFYI(1, "F_EXLCK");
> +		*type |= exclusive_lock_type();
>  		*lock = 1;
>  	} else if (flock->fl_type == F_SHLCK) {
>  		cFYI(1, "F_SHLCK");
> -		*type |= LOCKING_ANDX_SHARED_LOCK;
> +		*type |= shared_lock_type();
>  		*lock = 1;
>  	} else
>  		cFYI(1, "Unknown type of lock");
> @@ -1181,7 +1208,7 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
>  		if (!rc)
>  			return rc;
>  
> -		if (type & LOCKING_ANDX_SHARED_LOCK)
> +		if (type & shared_lock_type())
>  			posix_lock_type = CIFS_RDLCK;
>  		else
>  			posix_lock_type = CIFS_WRLCK;
> @@ -1209,19 +1236,18 @@ cifs_getlk(struct file *file, struct file_lock *flock, __u32 type,
>  		return 0;
>  	}
>  
> -	if (type & LOCKING_ANDX_SHARED_LOCK) {
> +	if (type & shared_lock_type()) {
>  		flock->fl_type = F_WRLCK;
>  		return 0;
>  	}
>  
>  	rc = CIFSSMBLock(xid, tcon, netfid, current->tgid, length,
>  			 flock->fl_start, 0, 1,
> -			 type | LOCKING_ANDX_SHARED_LOCK, 0, 0);
> +			 type | shared_lock_type(), 0, 0);
>  	if (rc == 0) {
>  		rc = CIFSSMBLock(xid, tcon, netfid, current->tgid,
>  				 length, flock->fl_start, 1, 0,
> -				 type | LOCKING_ANDX_SHARED_LOCK,
> -				 0, 0);
> +				 type | shared_lock_type(), 0, 0);
>  		flock->fl_type = F_RDLCK;
>  		if (rc != 0)
>  			cERROR(1, "Error unlocking previously locked "
> @@ -1369,7 +1395,7 @@ cifs_setlk(struct file *file,  struct file_lock *flock, __u32 type,
>  		if (!rc || rc < 0)
>  			return rc;
>  
> -		if (type & LOCKING_ANDX_SHARED_LOCK)
> +		if (type & shared_lock_type())
>  			posix_lock_type = CIFS_RDLCK;
>  		else
>  			posix_lock_type = CIFS_WRLCK;


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
