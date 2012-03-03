From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Do not kmalloc under the flocks spinlock
Date: Sat, 3 Mar 2012 06:44:58 -0500
Message-ID: <20120303064458.605cc1ce@tlielax.poochiereds.net>
References: <1330761028-7511-1-git-send-email-piastry@etersoft.ru>
	<20120303064250.69eb7feb@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120303064250.69eb7feb-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, 3 Mar 2012 06:42:50 -0500
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Sat,  3 Mar 2012 10:50:28 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> 
> > Reorganize the code to make the memory already allocated before
> > spinlock'ed loop.
> > 
> > Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> > ---
> >  fs/cifs/file.c |   65 ++++++++++++++++++++++++++++++++++++++++++++-----------
> >  1 files changed, 52 insertions(+), 13 deletions(-)
> > 
> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> > index 4dd9283..c90f7f6 100644
> > --- a/fs/cifs/file.c
> > +++ b/fs/cifs/file.c
> > @@ -920,16 +920,26 @@ cifs_push_mandatory_locks(struct cifsFileInfo *cfile)
> >  	for (lockp = &inode->i_flock; *lockp != NULL; \
> >  	     lockp = &(*lockp)->fl_next)
> >  
> > +struct lock_to_push {
> > +	struct list_head llist;
> > +	__u64 offset;
> > +	__u64 length;
> > +	__u32 pid;
> > +	__u16 netfid;
> > +	__u8 type;
> > +};
> > +
> >  static int
> >  cifs_push_posix_locks(struct cifsFileInfo *cfile)
> >  {
> >  	struct cifsInodeInfo *cinode = CIFS_I(cfile->dentry->d_inode);
> >  	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
> >  	struct file_lock *flock, **before;
> > -	struct cifsLockInfo *lck, *tmp;
> > +	unsigned int count = 0, i = 0;
> >  	int rc = 0, xid, type;
> > +	struct list_head locks_to_send, *el;
> > +	struct lock_to_push *lck, *tmp;
> >  	__u64 length;
> > -	struct list_head locks_to_send;
> >  
> >  	xid = GetXid();
> >  
> > @@ -940,29 +950,51 @@ cifs_push_posix_locks(struct cifsFileInfo *cfile)
> >  		return rc;
> >  	}
> >  
> > +	lock_flocks();
> > +	cifs_for_each_lock(cfile->dentry->d_inode, before) {
> > +		if ((*before)->fl_flags & FL_POSIX)
> > +			count++;
> > +	}
> > +	unlock_flocks();
> > +
> >  	INIT_LIST_HEAD(&locks_to_send);
> >  
> > +	/* We can safely allocate count locks with holding lock_mutex. */
> > +	for (; i < count; i++) {
> > +		lck = kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
> > +		if (!lck) {
> > +			rc = -ENOMEM;
> > +			goto err_out;
> > +		}
> > +		list_add_tail(&lck->llist, &locks_to_send);
> > +	}
> > +
> > +	i = 0;
> > +	el = locks_to_send.next;
> >  	lock_flocks();
> >  	cifs_for_each_lock(cfile->dentry->d_inode, before) {
> > +		if (el == &locks_to_send) {
> > +			/* something is really wrong */
> > +			cERROR(1, "Can't push all brlocks!");
> > +			break;
> > +		}
> >  		flock = *before;
> > +		if ((flock->fl_flags & FL_POSIX) == 0)
> > +			continue;
> >  		length = 1 + flock->fl_end - flock->fl_start;
> >  		if (flock->fl_type == F_RDLCK || flock->fl_type == F_SHLCK)
> >  			type = CIFS_RDLCK;
> >  		else
> >  			type = CIFS_WRLCK;
> > -
> > -		lck = cifs_lock_init(flock->fl_start, length, type,
> > -				     cfile->netfid);
> > -		if (!lck) {
> > -			rc = -ENOMEM;
> > -			goto send_locks;
> > -		}
> > +		lck = list_entry(el, struct lock_to_push, llist);
> >  		lck->pid = flock->fl_pid;
> > -
> > -		list_add_tail(&lck->llist, &locks_to_send);
> > +		lck->netfid = cfile->netfid;
> > +		lck->length = length;
> > +		lck->type = type;
> > +		lck->offset = flock->fl_start;
> > +		i++;
> > +		el = el->next;
> >  	}
> > -
> > -send_locks:
> >  	unlock_flocks();
> >  
> >  	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
> > @@ -979,11 +1011,18 @@ send_locks:
> >  		kfree(lck);
> >  	}
> >  
> > +out:
> >  	cinode->can_cache_brlcks = false;
> >  	mutex_unlock(&cinode->lock_mutex);
> >  
> >  	FreeXid(xid);
> >  	return rc;
> > +err_out:
> > +	list_for_each_entry_safe(lck, tmp, &locks_to_send, llist) {
> > +		list_del(&lck->llist);
> > +		kfree(lck);
> > +	}
> > +	goto out;
> >  }
> >  
> >  static int
> 
> Looks fine. I would however like to see some comments in this function
> that explain why the list of locks won't change after you
> unlock_flocks(). It's fairly clear now, but in a year or two we won't
> remember. That can be done in a later patch though.
> 
> Reviewed-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Oh, and by the way -- this probably ought to go to stable as well. It
would be nice to add those comments there too.

Pavel, could you respin this patch and add that comment, my Reviewed-by
and Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org ?

Thanks,
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
