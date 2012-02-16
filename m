From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 11:42:00 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202161139260.1268-100000@iolanthe.rowland.org>
References: <20120216162951.GF24986@google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Chris Ball <cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org>,
	David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Linux-pm mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, <keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120216162951.GF24986-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 16 Feb 2012, Tejun Heo wrote:

> Hello,
> 
> On Thu, Feb 16, 2012 at 10:27:28AM -0500, Jeff Layton wrote:
> > These should  all be freezable and we might even be able to get away
> > with WQ_UNBOUND for some of these.
> 
> In general, I would recommend specifying as few special attribute as
> possible.  If WQ_UNBOUND is necessary (large amount of CPU cycles
> consumed, extremely high concurrency), sure, but I think we're
> generally better off using as default attributes as possible.  It just
> makes things much easier later when we need to implement new features
> or update the implementation.
> 
> > I think we put most of these in system_nrt_wq because Tejun put an
> > earlier job into that queue when he converted it from slow_work and we
> > just cargo-cult copied that...
> > 
> > I'll spend some time looking at this in the next day or two, but I
> > suspect that the right answer is to just move these off of the "public"
> > workqueues altogether.
> 
> If freezing & nrt is everything necessary, just create
> system_nrt_freezable_wq and use that.

Here's my proposed patch.  If nobody objects, I'll submit it to Rafael
with an appropriate patch description.  Then anybody who wants can
convert over to the new workqueue.

Alan Stern



 block/genhd.c             |   10 +++++-----
 include/linux/workqueue.h |    4 ++++
 kernel/workqueue.c        |    7 ++++++-
 3 files changed, 15 insertions(+), 6 deletions(-)

Index: usb-3.3/block/genhd.c
===================================================================
--- usb-3.3.orig/block/genhd.c
+++ usb-3.3/block/genhd.c
@@ -1475,9 +1475,9 @@ static void __disk_unblock_events(struct
 	intv = disk_events_poll_jiffies(disk);
 	set_timer_slack(&ev->dwork.timer, intv / 4);
 	if (check_now)
-		queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
+		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
 	else if (intv)
-		queue_delayed_work(system_nrt_wq, &ev->dwork, intv);
+		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, intv);
 out_unlock:
 	spin_unlock_irqrestore(&ev->lock, flags);
 }
@@ -1521,7 +1521,7 @@ void disk_flush_events(struct gendisk *d
 	ev->clearing |= mask;
 	if (!ev->block) {
 		cancel_delayed_work(&ev->dwork);
-		queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
+		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
 	}
 	spin_unlock_irq(&ev->lock);
 }
@@ -1558,7 +1558,7 @@ unsigned int disk_clear_events(struct ge
 
 	/* uncondtionally schedule event check and wait for it to finish */
 	disk_block_events(disk);
-	queue_delayed_work(system_nrt_wq, &ev->dwork, 0);
+	queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, 0);
 	flush_delayed_work(&ev->dwork);
 	__disk_unblock_events(disk, false);
 
@@ -1595,7 +1595,7 @@ static void disk_events_workfn(struct wo
 
 	intv = disk_events_poll_jiffies(disk);
 	if (!ev->block && intv)
-		queue_delayed_work(system_nrt_wq, &ev->dwork, intv);
+		queue_delayed_work(system_nrt_freezable_wq, &ev->dwork, intv);
 
 	spin_unlock_irq(&ev->lock);
 
Index: usb-3.3/include/linux/workqueue.h
===================================================================
--- usb-3.3.orig/include/linux/workqueue.h
+++ usb-3.3/include/linux/workqueue.h
@@ -289,12 +289,16 @@ enum {
  *
  * system_freezable_wq is equivalent to system_wq except that it's
  * freezable.
+ *
+ * system_nrt_freezable_wq is equivalent to system_nrt_wq except that
+ * it's freezable.
  */
 extern struct workqueue_struct *system_wq;
 extern struct workqueue_struct *system_long_wq;
 extern struct workqueue_struct *system_nrt_wq;
 extern struct workqueue_struct *system_unbound_wq;
 extern struct workqueue_struct *system_freezable_wq;
+extern struct workqueue_struct *system_nrt_freezable_wq;
 
 extern struct workqueue_struct *
 __alloc_workqueue_key(const char *fmt, unsigned int flags, int max_active,
Index: usb-3.3/kernel/workqueue.c
===================================================================
--- usb-3.3.orig/kernel/workqueue.c
+++ usb-3.3/kernel/workqueue.c
@@ -253,11 +253,13 @@ struct workqueue_struct *system_long_wq
 struct workqueue_struct *system_nrt_wq __read_mostly;
 struct workqueue_struct *system_unbound_wq __read_mostly;
 struct workqueue_struct *system_freezable_wq __read_mostly;
+struct workqueue_struct *system_nrt_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
 EXPORT_SYMBOL_GPL(system_long_wq);
 EXPORT_SYMBOL_GPL(system_nrt_wq);
 EXPORT_SYMBOL_GPL(system_unbound_wq);
 EXPORT_SYMBOL_GPL(system_freezable_wq);
+EXPORT_SYMBOL_GPL(system_nrt_freezable_wq);
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/workqueue.h>
@@ -3833,8 +3835,11 @@ static int __init init_workqueues(void)
 					    WQ_UNBOUND_MAX_ACTIVE);
 	system_freezable_wq = alloc_workqueue("events_freezable",
 					      WQ_FREEZABLE, 0);
+	system_nrt_freezable_wq = alloc_workqueue("events_nrt_freezable",
+			WQ_NON_REENTRANT | WQ_FREEZABLE, 0);
 	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq ||
-	       !system_unbound_wq || !system_freezable_wq);
+	       !system_unbound_wq || !system_freezable_wq ||
+		!system_nrt_freezable_wq);
 	return 0;
 }
 early_initcall(init_workqueues);
