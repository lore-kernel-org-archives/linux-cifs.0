From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/15] cifs: move close processing from cifs_close to
 cifsFileInfo_put
Date: Thu, 7 Oct 2010 07:07:26 -0400
Message-ID: <20101007070726.0ef1b1a8@barsoom.rdu.redhat.com>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com>
	<1286394857-32541-13-git-send-email-jlayton@redhat.com>
	<4CAD71A7.20808@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CAD71A7.20808-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 07 Oct 2010 12:37:19 +0530
Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:

> On 10/07/2010 01:24 AM, Jeff Layton wrote:
> > Now that it's feasible for a cifsFileInfo to outlive the filp under
> > which it was created, move the close processing into cifsFileInfo_put.
> > 
> > This means that the last user of the filehandle always does the actual
> > on the wire close call. This also allows us to get rid of the closePend
> > flag from cifsFileInfo. If we have an active reference to the file
> > then it's never going to have a close pending.
> > 
> > cifs_close is converted to simply put the filehandle.
> > 
> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/cifsglob.h |    1 -
> >  fs/cifs/file.c     |  187 +++++++++++++++++-----------------------------------
> >  fs/cifs/misc.c     |   10 ---
> >  3 files changed, 60 insertions(+), 138 deletions(-)
> > 
> 
> > -/* Release a reference on the file private data */
> > +/*
> > + * Release a reference on the file private data. This may involve closing
> > + * the filehandle out on the server.
> > + */
> >  void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
> >  {
> > -	if (atomic_dec_and_test(&cifs_file->count)) {
> > -		cifs_put_tlink(cifs_file->tlink);
> > -		dput(cifs_file->dentry);
> > -		kfree(cifs_file);
> > +	struct cifsTconInfo *tcon = tlink_tcon(cifs_file->tlink);
> > +	struct cifsInodeInfo *cifsi = CIFS_I(cifs_file->dentry->d_inode);
> > +	struct cifsLockInfo *li, *tmp;
> > +
> > +	write_lock(&cifs_file_list_lock);
> > +	if (!atomic_dec_and_test(&cifs_file_list_lock)) {
> > +		write_unlock(&cifs_file_list_lock);
> > +		return;
> > +	}
> > +
> > +	/* remove it from the lists */
> > +	list_del(&cifs_file->flist);
> > +	list_del(&cifs_file->tlist);
> > +
> > +	if (list_empty(&cifsi->openFileList)) {
> > +		cFYI(1, "closing last open instance for inode %p",
> > +			cifs_file->dentry->d_inode);
> > +		cifsi->clientCanCacheRead = false;
> > +		cifsi->clientCanCacheAll  = false;
> > +	}
> > +	write_unlock(&cifs_file_list_lock);
> > +
> > +	if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
> > +		int xid, rc;
> > +
> > +		xid = GetXid();
> > +		rc = CIFSSMBClose(xid, tcon, cifs_file->netfid);
> > +		FreeXid(xid);
> > +	}
> > +
> > +	/* Delete any outstanding lock records. We'll lose them when the file
> > +	 * is closed anyway.
> > +	 */
> > +	mutex_lock(&cifs_file->lock_mutex);
> > +	list_for_each_entry_safe(li, tmp, &cifs_file->llist, llist) {
> > +		list_del(&li->llist);
> > +		kfree(li);
> >  	}
> > +	mutex_unlock(&cifs_file->lock_mutex);
> > +
> > +	cifs_put_tlink(cifs_file->tlink);
> > +	dput(cifs_file->dentry);
> > +	kfree(cifs_file);
> >  }
> >  
> >  int cifs_open(struct inode *inode, struct file *file)
> > @@ -542,79 +582,11 @@ reopen_error_exit:
> >  
> >  int cifs_close(struct inode *inode, struct file *file)
> >  {
> > -	int rc = 0;
> > -	int xid, timeout;
> > -	struct cifs_sb_info *cifs_sb;
> > -	struct cifsTconInfo *pTcon;
> > -	struct cifsFileInfo *pSMBFile = file->private_data;
> > -
> > -	xid = GetXid();
> > -
> > -	cifs_sb = CIFS_SB(inode->i_sb);
> > -	pTcon = tlink_tcon(pSMBFile->tlink);
> > -	if (pSMBFile) {
> > -		struct cifsLockInfo *li, *tmp;
> > -		write_lock(&cifs_file_list_lock);
> > -		pSMBFile->closePend = true;
> > -		if (pTcon) {
> > -			/* no sense reconnecting to close a file that is
> > -			   already closed */
> > -			if (!pTcon->need_reconnect) {
> > -				write_unlock(&cifs_file_list_lock);
> > -				timeout = 2;
> > -				while ((atomic_read(&pSMBFile->count) != 1)
> 
> This portion of code which induces manual delay seems missing. While I'm
> not sure about the practical significance of this code, explaining why
> we do not need this in the change log would help?
> 

This is the part of the code that I was particularly keen to eliminate.

To my understanding the idea was that the code would set the closePend
flag and then wait a "little while" until the count had gone to 0. The
closePend flag would prevent the find_*_file interfaces from picking
that filehandle, and the "little while" would help ensure that the
current users of it would finish with it. Eventually though (in 2s) the
code gives up and just destroys the cifsFileInfo anyway even though the
refcount is still high.

Needless to say, that's not a particularly robust scheme. It's possible
the refcount went high just before the server went offline but before
closePend was set. 2s may not be enough to prevent a use-after-free.

It also had the problem that the actual users of the filehandle had to
deal with the fact that the closePend flag could be set while they were
using it. Then what do they do?

The patch I'm proposing moves this to a real refcounted scheme where
the last user closes out the filehandle on the server. Far simpler and
more certain not to cause these sorts of problems.

> 
> > -					&& (timeout <= 2048)) {
> > -					/* Give write a better chance to get to
> > -					server ahead of the close.  We do not
> > -					want to add a wait_q here as it would
> > -					increase the memory utilization as
> > -					the struct would be in each open file,
> > -					but this should give enough time to
> > -					clear the socket */
> > -					cFYI(DBG2, "close delay, write pending");
> > -					msleep(timeout);
> > -					timeout *= 4;
> > -				}
> > -				if (!pTcon->need_reconnect &&
> > -				    !pSMBFile->invalidHandle)
> > -					rc = CIFSSMBClose(xid, pTcon,
> > -						  pSMBFile->netfid);
> > -			} else
> > -				write_unlock(&cifs_file_list_lock);
> > -		} else
> > -			write_unlock(&cifs_file_list_lock);
> > -
> > -		/* Delete any outstanding lock records.
> > -		   We'll lose them when the file is closed anyway. */
> > -		mutex_lock(&pSMBFile->lock_mutex);
> > -		list_for_each_entry_safe(li, tmp, &pSMBFile->llist, llist) {
> > -			list_del(&li->llist);
> > -			kfree(li);
> > -		}
> > -		mutex_unlock(&pSMBFile->lock_mutex);
> > +	cifsFileInfo_put(file->private_data);
> > +	file->private_data = NULL;
> >  
> > -		write_lock(&cifs_file_list_lock);
> > -		list_del(&pSMBFile->flist);
> > -		list_del(&pSMBFile->tlist);
> > -		write_unlock(&cifs_file_list_lock);
> > -		cifsFileInfo_put(file->private_data);
> > -		file->private_data = NULL;
> > -	} else
> > -		rc = -EBADF;
> > -
> > -	read_lock(&cifs_file_list_lock);
> > -	if (list_empty(&(CIFS_I(inode)->openFileList))) {
> > -		cFYI(1, "closing last open instance for inode %p", inode);
> > -		/* if the file is not open we do not know if we can cache info
> > -		   on this inode, much less write behind and read ahead */
> > -		CIFS_I(inode)->clientCanCacheRead = false;
> > -		CIFS_I(inode)->clientCanCacheAll  = false;
> > -	}
> > -	read_unlock(&cifs_file_list_lock);
> > -	if ((rc == 0) && CIFS_I(inode)->write_behind_rc)
> > -		rc = CIFS_I(inode)->write_behind_rc;
> > -	FreeXid(xid);
> > -	return rc;
> > +	/* return code from the ->release op is always ignored */
> > +	return 0;
> >  }
> >  
> 
> 
> -- 
> Suresh Jayaraman


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
