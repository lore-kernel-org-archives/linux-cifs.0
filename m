From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Wait for writebacks to complete before attempting
 write.
Date: Tue, 4 Mar 2014 10:16:16 -0500
Message-ID: <20140304101616.7b59faae@tlielax.poochiereds.net>
References: <1393859506-10889-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393859506-10889-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon,  3 Mar 2014 15:11:46 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Problem reported in Red Hat bz 1040329 for strict writes where we cache
> only when we hold oplock and write direct to the server when we don't.
> 
> When we receive an oplock break, we first change the oplock value for
> the inode in cifsInodeInfo->oplock to indicate that we no longer hold
> the oplock before we enqueue a task to flush changes to the backing
> device. Once we have completed flushing the changes, we return the
> oplock to the server.
> 
> There are 2 ways here where we can have data corruption
> 1) While we flush changes to the backing device as part of the oplock
> break, we can have processes write to the file. These writes check for
> the oplock, find none and attempt to write directly to the server.
> These direct writes made while we are flushing from cache could be
> overwritten by data being flushed from the cache causing data
> corruption.
> 2) While a thread runs in cifs_strict_writev, the machine could receive
> and process an oplock break after the thread has checked the oplock and
> found that it allows us to cache and before we have made changes to the
> cache. In that case, we end up with a dirty page in cache when we
> shouldn't have any. This will be flushed later and will overwrite all
> subsequent writes to the part of the file represented by this page.
> 
> Before making any writes to the server, we need to confirm that we are
> not in the process of flushing data to the server and if we are, we
> should wait until the process is complete before we attempt the write.
> We should also wait for existing writes to complete before we process
> an oplock break request which changes oplock values.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/cifsfs.c    | 14 +++++++++-
>  fs/cifs/cifsglob.h  |  9 +++++++
>  fs/cifs/cifsproto.h |  3 +++
>  fs/cifs/file.c      | 32 ++++++++++++++++++++---
>  fs/cifs/misc.c      | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++--
>  5 files changed, 126 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 849f613..6d5cf79 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -253,6 +253,11 @@ cifs_alloc_inode(struct super_block *sb)
>  	cifs_set_oplock_level(cifs_inode, 0);
>  	cifs_inode->delete_pending = false;
>  	cifs_inode->invalid_mapping = false;
> +	clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cifs_inode->flags);
> +	clear_bit(CIFS_INODE_PENDING_WRITERS, &cifs_inode->flags);
> +	clear_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cifs_inode->flags);
> +	mutex_init(&cifs_inode->writers_lock);
> +	cifs_inode->writers = 0;
>  	cifs_inode->vfs_inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
>  	cifs_inode->server_eof = 0;
>  	cifs_inode->uniqueid = 0;
> @@ -731,19 +736,26 @@ static ssize_t cifs_file_aio_write(struct kiocb *iocb, const struct iovec *iov,
>  				   unsigned long nr_segs, loff_t pos)
>  {
>  	struct inode *inode = file_inode(iocb->ki_filp);
> +	struct cifsInodeInfo *cinode = CIFS_I(inode);
>  	ssize_t written;
>  	int rc;
>  
> +	written = cifs_get_writer(cinode);
> +	if (written)
> +		return written;
> +
>  	written = generic_file_aio_write(iocb, iov, nr_segs, pos);
>  
>  	if (CIFS_CACHE_WRITE(CIFS_I(inode)))
> -		return written;
> +		goto out;
>  
>  	rc = filemap_fdatawrite(inode->i_mapping);
>  	if (rc)
>  		cifs_dbg(FYI, "cifs_file_aio_write: %d rc on %p inode\n",
>  			 rc, inode);
>  
> +out:
> +	cifs_put_writer(cinode);
>  	return written;
>  }
>  
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index f918a99..1a3a88d 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1096,6 +1096,15 @@ struct cifsInodeInfo {
>  	unsigned int epoch;		/* used to track lease state changes */
>  	bool delete_pending;		/* DELETE_ON_CLOSE is set */
>  	bool invalid_mapping;		/* pagecache is invalid */
> +	unsigned long flags;
> +#define CIFS_INODE_PENDING_OPLOCK_BREAK 0 /* oplock break in progress */
> +#define CIFS_INODE_PENDING_WRITERS 1 	/* Writing operations in progress */
> +#define CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2 2 /*

nit: please align the values for readability. Probably also good to
wrap them in parenthesis -- e.g. "(1)".

> +					     * We have received a request to
> +					     * downgrade oplock to L2 oplock
> +					     */
> +	struct mutex writers_lock;

I don't see any reason to use a mutex here. There are no critical
sections that sleep AFAICT. Why not use a spinlock which would be
smaller (4 bytes vs. 40 bytes on my x86_64 box)?

In fact, you could even consider just using the i_lock for this (though
I'd understand if you wanted to use your own).

> +	unsigned int writers;		/* Number of writers on this inode */
>  	unsigned long time;		/* jiffies of last update of inode */
>  	u64  server_eof;		/* current file size on server -- protected by i_lock */
>  	u64  uniqueid;			/* server inode number */
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 2c29db6..fa41676 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -127,6 +127,9 @@ extern u64 cifs_UnixTimeToNT(struct timespec);
>  extern struct timespec cnvrtDosUnixTm(__le16 le_date, __le16 le_time,
>  				      int offset);
>  extern void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock);
> +extern int cifs_get_writer(struct cifsInodeInfo *cinode);
> +extern void cifs_put_writer(struct cifsInodeInfo *cinode);
> +extern void cifs_done_oplock_break(struct cifsInodeInfo *cinode);
>  extern int cifs_unlock_range(struct cifsFileInfo *cfile,
>  			     struct file_lock *flock, const unsigned int xid);
>  extern int cifs_push_mandatory_locks(struct cifsFileInfo *cfile);
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index 5a5a872..5a94d7b 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2580,12 +2580,20 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  	ssize_t written;
>  
> +	written = cifs_get_writer(cinode);
> +	if (written)
> +		return written;
> +
>  	if (CIFS_CACHE_WRITE(cinode)) {
>  		if (cap_unix(tcon->ses) &&
>  		(CIFS_UNIX_FCNTL_CAP & le64_to_cpu(tcon->fsUnixInfo.Capability))
> -		    && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0))
> -			return generic_file_aio_write(iocb, iov, nr_segs, pos);
> -		return cifs_writev(iocb, iov, nr_segs, pos);
> +		  && ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_NOPOSIXBRL) == 0)) {
> +			written = generic_file_aio_write(
> +					iocb, iov, nr_segs, pos);
> +			goto out;
> +		}
> +		written = cifs_writev(iocb, iov, nr_segs, pos);
> +		goto out;
>  	}
>  	/*
>  	 * For non-oplocked files in strict cache mode we need to write the data
> @@ -2605,6 +2613,8 @@ cifs_strict_writev(struct kiocb *iocb, const struct iovec *iov,
>  			 inode);
>  		cinode->oplock = 0;
>  	}
> +out:
> +	cifs_put_writer(cinode);
>  	return written;
>  }
>  
> @@ -3616,6 +3626,13 @@ static int cifs_launder_page(struct page *page)
>  	return rc;
>  }
>  
> +static int
> +cifs_oplock_break_wait(void *unused)
> +{
> +	schedule();
> +	return signal_pending(current) ? -ERESTARTSYS : 0;
> +}
> +

This wait will just be used from cifs_oplock_break(), right? Since
that's a workqueue job, then we don't expect any signals there. I think
there's no need for checking signal_pending(). Just calling schedule()
is probably fine.

>  void cifs_oplock_break(struct work_struct *work)
>  {
>  	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
> @@ -3625,6 +3642,14 @@ void cifs_oplock_break(struct work_struct *work)
>  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
>  	int rc = 0;
>  
> +	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
> +			cifs_oplock_break_wait, TASK_UNINTERRUPTIBLE);
> +
> +	if (test_bit(CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2, &cinode->flags)) 
> +		cifs_set_oplock_level(cinode, OPLOCK_READ);
> +	else
> +		cifs_set_oplock_level(cinode, 0);
> +
>  	if (!CIFS_CACHE_WRITE(cinode) && CIFS_CACHE_READ(cinode) &&
>  						cifs_has_mand_locks(cinode)) {
>  		cifs_dbg(FYI, "Reset oplock to None for inode=%p due to mand locks\n",
> @@ -3661,6 +3686,7 @@ void cifs_oplock_break(struct work_struct *work)
>  							     cinode);
>  		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
>  	}
> +	cifs_done_oplock_break(cinode);
>  }
>  
>  /*
> diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
> index 2f9f379..55b26bd 100644
> --- a/fs/cifs/misc.c
> +++ b/fs/cifs/misc.c
> @@ -466,8 +466,22 @@ is_valid_oplock_break(char *buffer, struct TCP_Server_Info *srv)
>  				cifs_dbg(FYI, "file id match, oplock break\n");
>  				pCifsInode = CIFS_I(netfile->dentry->d_inode);
>  
> -				cifs_set_oplock_level(pCifsInode,
> -					pSMB->OplockLevel ? OPLOCK_READ : 0);
> +				set_bit(CIFS_INODE_PENDING_OPLOCK_BREAK,
> +					&pCifsInode->flags);
> +
> +				/*
> +				 * Set flag if the server downgrades the oplock
> +				 * to L2 else clear.
> +				 */
> +				if (pSMB->OplockLevel)
> +					set_bit(
> +					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
> +					   &pCifsInode->flags);
> +				else
> +					clear_bit(
> +					   CIFS_INODE_DOWNGRADE_OPLOCK_TO_L2,
> +					   &pCifsInode->flags);
> +
>  				queue_work(cifsiod_wq,
>  					   &netfile->oplock_break);
>  				netfile->oplock_break_cancelled = false;
> @@ -551,6 +565,62 @@ void cifs_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock)
>  		cinode->oplock = 0;
>  }
>  
> +static int
> +cifs_oplock_break_wait(void *unused)
> +{
> +	schedule();
> +	return signal_pending(current) ? -ERESTARTSYS : 0;
> +}
> +
> +/*
> + * We wait for oplock breaks to be processed before we attempt to perform
> + * writes.
> + */
> +int cifs_get_writer(struct cifsInodeInfo *cinode)
> +{
> +	int rc;
> +
> +start:
> +	rc = wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK,
> +				   cifs_oplock_break_wait, TASK_KILLABLE);
> +	if (rc)
> +		return rc;
> +
> +	mutex_lock(&cinode->writers_lock);
> +	if (!cinode->writers)
> +		set_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
> +	cinode->writers++;
> +	/* Check to see if we have started servicing an oplock break */
> +	if (test_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags)) {
> +		cinode->writers--;
> +		if (cinode->writers == 0) {
> +			clear_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
> +			wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS);
> +		}
> +		mutex_unlock(&cinode->writers_lock);
> +		goto start;
> +	}
> +	mutex_unlock(&cinode->writers_lock);
> +	return 0;
> +}
> +
> +void cifs_put_writer(struct cifsInodeInfo *cinode)
> +{
> +	mutex_lock(&cinode->writers_lock);
> +	cinode->writers--;
> +	if (cinode->writers == 0) {
> +		clear_bit(CIFS_INODE_PENDING_WRITERS, &cinode->flags);
> +		wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS);
> +	}
> +	mutex_unlock(&cinode->writers_lock);
> +}
> +
> +void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
> +{
> +	clear_bit(CIFS_INODE_PENDING_OPLOCK_BREAK, &cinode->flags);
> +	wake_up_bit(&cinode->flags, CIFS_INODE_PENDING_OPLOCK_BREAK);
> +}
> +
>  bool
>  backup_cred(struct cifs_sb_info *cifs_sb)
>  {

Looks good otherwise, and definitely something we need to fix since
it's a data corruptor. The final version of this should probably go to
stable for that reason...
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
