From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH] cifs: Fix possible deadlock with cifs and work
 queues
Date: Thu, 20 Mar 2014 19:53:46 -0400
Message-ID: <20140320195346.0876e175@tlielax.poochiereds.net>
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
	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, uobergfe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
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
> The cifs system has several workqueues used in file.c and other places.
> One of them is used for completion of a read and to release the
> page_lock which wakes up the reader. There are several other workqueues
> that do various other tasks.
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
> 					      [ note, cifs_oplock_break() can
> 					        also call cifs_push_locks which takes
> 					        the lock with down_write() ]
> 
> 

Wait...why does the work running on CPU1 end up blocked on down_read()?
Is it really getting stuck on the down_write you mention?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
