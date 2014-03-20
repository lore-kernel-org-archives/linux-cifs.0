From: Jeffrey Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Thu, 20 Mar 2014 15:28:33 -0400
Message-ID: <20140320152833.216d81a0@tlielax.poochiereds.net>
References: <20140319151252.16ed3ac6@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	Clark Williams <williams-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Luis Claudio R. Goncalves" <lclaudio-+PBNgV5/840@public.gmane.org>,
	Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>,
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140319151252.16ed3ac6-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 19 Mar 2014 15:12:52 -0400
Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org> wrote:

> We just had a customer report a deadlock in their 3.8-rt kernel.
> Looking into this, it is very possible to have the same deadlock in
> mainline in Linus's tree as it stands today.
> 
> It is much easier to deadlock in the -rt kernel because reader locks
> are serialized, where a down_read() can block another down_read(). But
> because rwsems are fair locks, if a writer is waiting, a new reader
> will then block. This means that if it is possible for a reader to
> deadlock another reader, this can happen if a write comes along and
> blocks on a current reader. That will prevent another reader from
> running, and if that new reader requires to wake up a reader that owns
> the lock, you have your deadlock.
> 
> Here's the situation with CIFS and workqueues:
> 
> The cifs system has several workqueues used in file.c and other
> places. One of them is used for completion of a read and to release
> the page_lock which wakes up the reader. There are several other
> workqueues that do various other tasks.
> 
> A holder of the reader lock can sleep on a page_lock() and expect the
> reader workqueue to wake it up (page_unlock()). The reader workqueue
> takes no locks so this does not seem to be a problem (but it is).
> 
> The other workqueues can take the rwsem for read or for write. But our
> issue that we tripped over was that it grabs it for read (remember in
> -rt readers are serialized). But this can also happen if a separate
> writer is waiting on the lock as that would cause a reader to block on
> another reader too.
> 
> All the workqueue callbacks are executed on the same workqueue:
> 
> 	queue_work(cifsiod_wq, &rdata->work);
> 	[...]
> 	queue_work(cifsiod_wq, &cfile->oplock_break);
> 
> Now if the reader workqueue callback is queued after one of these
> workqueues that can take the rwsem, we can hit a deadlock. The
> workqueue code looks to be able to prevent deadlocks of these kinds,
> but I do not totally understand the workqueue scheduled work structure
> and perhaps if the kworker thread structure blocks hard it wont move
> works around.
> 
> Here's what we see:
> 
> 	rdata->work is scheduled after cfile->oplock_break
> 
> 	CPU0						CPU1
> 	----						----
> 
>   do_sync_read()
>     cifs_strict_readv()
>       down_read(cinode->lock_sem);
>       generic_file_aio_read()
>         __lock_page_killable()
>           __wait_on_bit_lock()
> 
>        * BLOCKED *
> 
> 						process_one_work()
> 						  cifs_oplock_break()
> 						    cifs_has_mand_locks()
> 						      down_read(cinode->lock_sem);
> 
> 						   * BLOCKED *
> 
> 					      [ note,
> cifs_oplock_break() can also call cifs_push_locks which takes
> 					        the lock with
> down_write() ]
> 
> 
> But we noticed that the rdata->work was queued to run under the same
> workqueue task and this work is to wake up the owner of the semaphore.
> But because the workqueue task is blocked waiting on that lock, it
> will never wake it up.
> 
> My question to Tejun is, if we create another workqueue, to add the
> rdata->work to, would that prevent the above problem? Or what other
> fixes can we do?
> 
> This is only compiled tested, we have not given it to our customer
> yet.
> 
> Signed-off-by: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> 

Cc'ing Pavel since he wrote most of the lock pushing code...

Nice analysis! I think eventually we'll need to overhaul this code not
to use rw semaphores, but that's going to take some redesign. (Wonder
if we could change it to use seqlocks or something?)

Out of curiousity, does this eventually time out and unwedge itself?
Usually when the server doesn't get a response to an oplock break in
around a minute or so it gives up and allows the thing that caused the
oplock break to proceed anyway. Not great for performance but it out to
eventually make progress due to that.

In any case, this looks like a reasonable fix for now, but I suspect you
can hit similar problems in the write codepath too. What may be best is
turn this around and queue the oplock break to the new workqueue
instead of the read completion job.

> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 849f613..6656058 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -86,6 +86,7 @@ extern mempool_t *cifs_req_poolp;
>  extern mempool_t *cifs_mid_poolp;
>  
>  struct workqueue_struct	*cifsiod_wq;
> +struct workqueue_struct	*cifsiord_wq;
>  
>  #ifdef CONFIG_CIFS_SMB2
>  __u8 cifs_client_guid[SMB2_CLIENT_GUID_SIZE];
> @@ -1199,9 +1200,15 @@ init_cifs(void)
>  		goto out_clean_proc;
>  	}
>  
> +	cifsiord_wq = alloc_workqueue("cifsiord",
> WQ_FREEZABLE|WQ_MEM_RECLAIM, 0);
> +	if (!cifsiord_wq) {
> +		rc = -ENOMEM;
> +		goto out_destroy_wq;
> +	}
> +
>  	rc = cifs_fscache_register();
>  	if (rc)
> -		goto out_destroy_wq;
> +		goto out_destroy_rwq;
>  
>  	rc = cifs_init_inodecache();
>  	if (rc)
> @@ -1249,6 +1256,8 @@ out_destroy_inodecache:
>  	cifs_destroy_inodecache();
>  out_unreg_fscache:
>  	cifs_fscache_unregister();
> +out_destroy_rwq:
> +	destroy_workqueue(cifsiord_wq);
>  out_destroy_wq:
>  	destroy_workqueue(cifsiod_wq);
>  out_clean_proc:
> @@ -1273,6 +1282,7 @@ exit_cifs(void)
>  	cifs_destroy_inodecache();
>  	cifs_fscache_unregister();
>  	destroy_workqueue(cifsiod_wq);
> +	destroy_workqueue(cifsiord_wq);
>  	cifs_proc_clean();
>  }
>  
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index c0f3718..75d1941 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1561,6 +1561,7 @@ void cifs_oplock_break(struct work_struct
> *work); 
>  extern const struct slow_work_ops cifs_oplock_break_ops;
>  extern struct workqueue_struct *cifsiod_wq;
> +extern struct workqueue_struct *cifsiord_wq;
>  
>  extern mempool_t *cifs_mid_poolp;
>  
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index f3264bd..ca04a2e 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1571,7 +1571,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
>  		rdata->result = -EIO;
>  	}
>  
> -	queue_work(cifsiod_wq, &rdata->work);
> +	queue_work(cifsiord_wq, &rdata->work);
>  	DeleteMidQEntry(mid);
>  	add_credits(server, 1, 0);
>  }
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 8603447..b74bf61 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1742,7 +1742,7 @@ smb2_readv_callback(struct mid_q_entry *mid)
>  	if (rdata->result)
>  		cifs_stats_fail_inc(tcon, SMB2_READ_HE);
>  
> -	queue_work(cifsiod_wq, &rdata->work);
> +	queue_work(cifsiord_wq, &rdata->work);
>  	DeleteMidQEntry(mid);
>  	add_credits(server, credits_received, 0);
>  }



-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
