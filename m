From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Block: use a freezable workqueue for disk-event polling
Date: Fri, 17 Feb 2012 23:11:05 +0100
Message-ID: <201202172311.06246.rjw@sisk.pl>
References: <Pine.LNX.4.44L0.1202171615550.1194-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
	Steve French <sfrench@samba.org>, Chris Ball <cjb@laptop.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	David Airlie <airlied@linux.ie>,
	David Howells <dhowells@redhat.com>,
	"Linux-pm mailing list" <linux-pm@vger.kernel.org>,
	linux-cifs@vger.kernel.org, linux-mmc@vger.kernel.org,
	dri-devel@lists.freedesktop.org, keyrings@linux-nfs.org
To: Alan Stern <stern@rowland.harvard.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1202171615550.1194-100000@iolanthe.rowland.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Friday, February 17, 2012, Alan Stern wrote:
> This patch (as1519) fixes a bug in the block layer's disk-events
> polling.  The polling is done by a work routine queued on the
> system_nrt_wq workqueue.  Since that workqueue isn't freezable, the
> polling continues even in the middle of a system sleep transition.
> 
> Obviously, polling a suspended drive for media changes and such isn't
> a good thing to do; in the case of USB mass-storage devices it can
> lead to real problems requiring device resets and even re-enumeration.
> 
> The patch fixes things by creating a new system-wide, non-reentrant,
> freezable workqueue and using it for disk-events polling.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Tejun Heo <tj@kernel.org>
> CC: <stable@kernel.org>

Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks,
Rafael


> ---
> 
> I'm not sure who to send this patch to, since it is relevant to both
> the block and PM subsystems.  Jens, is it okay if Rafael takes it?
> 
> 
> 
>  block/genhd.c             |   10 +++++-----
>  include/linux/workqueue.h |    4 ++++
>  kernel/workqueue.c        |    7 ++++++-
>  3 files changed, 15 insertions(+), 6 deletions(-)
> 
> Index: usb-3.3/block/genhd.c
> ===================================================================
> --- usb-3.3.orig/block/genhd.c
> +++ usb-3.3/block/genhd.c
> @@ -1475,9 +1475,9 @@ static void __disk_unblock_events(struct
>  	intv = disk_events_poll_jiffies(disk);
>  	set_timer_slack(&ev->dwork.timer, intv / 4);
>  	if (check_now)
> -		queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
> +		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
>  	else if (intv)
> -		queue_delayed_work(system_nrt_wq, &ev->dwork, intv);
> +		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, intv);
>  out_unlock:
>  	spin_unlock_irqrestore(&ev->lock, flags);
>  }
> @@ -1521,7 +1521,7 @@ void disk_flush_events(struct gendisk *d
>  	ev->clearing |= mask;
>  	if (!ev->block) {
>  		cancel_delayed_work(&ev->dwork);
> -		queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
> +		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
>  	}
>  	spin_unlock_irq(&ev->lock);
>  }
> @@ -1558,7 +1558,7 @@ unsigned int disk_clear_events(struct ge
>  
>  	/* uncondtionally schedule event check and wait for it to finish */
>  	disk_block_events(disk);
> -	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
> +	queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
>  	flush_delayed_work(&ev->dwork);
>  	__disk_unblock_events(disk, false);
>  
> @@ -1595,7 +1595,7 @@ static void disk_events_workfn(struct wo
>  
>  	intv = disk_events_poll_jiffies(disk);
>  	if (!ev->block && intv)
> -		queue_delayed_work(system_nrt_wq, &ev->dwork, intv);
> +		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, intv);
>  
>  	spin_unlock_irq(&ev->lock);
>  
> Index: usb-3.3/include/linux/workqueue.h
> ===================================================================
> --- usb-3.3.orig/include/linux/workqueue.h
> +++ usb-3.3/include/linux/workqueue.h
> @@ -289,12 +289,16 @@ enum {
>   *
>   * system_freezable_wq is equivalent to system_wq except that it's
>   * freezable.
> + *
> + * system_nrt_freezable_wq is equivalent to system_nrt_wq except that
> + * it's freezable.
>   */
>  extern struct workqueue_struct *system_wq;
>  extern struct workqueue_struct *system_long_wq;
>  extern struct workqueue_struct *system_nrt_wq;
>  extern struct workqueue_struct *system_unbound_wq;
>  extern struct workqueue_struct *system_freezable_wq;
> +extern struct workqueue_struct *system_nrt_freezable_wq;
>  
>  extern struct workqueue_struct *
>  __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
> Index: usb-3.3/kernel/workqueue.c
> ===================================================================
> --- usb-3.3.orig/kernel/workqueue.c
> +++ usb-3.3/kernel/workqueue.c
> @@ -253,11 +253,13 @@ struct workqueue_struct *system_long_wq
>  struct workqueue_struct *system_nrt_wq __read_mostly;
>  struct workqueue_struct *system_unbound_wq __read_mostly;
>  struct workqueue_struct *system_freezable_wq __read_mostly;
> +struct workqueue_struct *system_nrt_freezable_wq __read_mostly;
>  EXPORT_SYMBOL_GPL(system_wq);
>  EXPORT_SYMBOL_GPL(system_long_wq);
>  EXPORT_SYMBOL_GPL(system_nrt_wq);
>  EXPORT_SYMBOL_GPL(system_unbound_wq);
>  EXPORT_SYMBOL_GPL(system_freezable_wq);
> +EXPORT_SYMBOL_GPL(system_nrt_freezable_wq);
>  
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/workqueue.h>
> @@ -3833,8 +3835,11 @@ static int __init init_workqueues(void)
>  					    WQ_UNBOUND_MAX_ACTIVE);
>  	system_freezable_wq = alloc_workqueue("events_freezable",
>  					      WQ_FREEZABLE, 0);
> +	system_nrt_freezable_wq = alloc_workqueue("events_nrt_freezable",
> +			WQ_NON_REENTRANT | WQ_FREEZABLE, 0);
>  	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq ||
> -	       !system_unbound_wq || !system_freezable_wq);
> +	       !system_unbound_wq || !system_freezable_wq ||
> +		!system_nrt_freezable_wq);
>  	return 0;
>  }
>  early_initcall(init_workqueues);
> 
> 
> 

