From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 10:27:28 -0500
Message-ID: <20120216102728.230b99ba@poochiereds.net>
References: <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Tejun Heo <tj@kernel.org>, Steve French <sfrench@samba.org>,
	Chris Ball <cjb@laptop.org>, David Airlie <airlied@linux.ie>,
	David Howells <dhowells@redhat.com>,
	Linux-pm mailing list <linux-pm@vger.kernel.org>,
	<linux-cifs@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
	<dri-devel@lists.freedesktop.org>, <keyrings@linux-nfs.org>
To: Alan Stern <stern@rowland.harvard.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 16 Feb 2012 09:41:34 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> Folks:
> 
> I recently uncovered a bug in the block layer.  It uses a workqueue to
> periodically probe removable drives for media or other state changes,
> and the workqueue it uses is system_nrt_wq.
> 
> The bug is that system_nrt_wq is not freezable, so it keeps on running
> even while the system is in the process of suspending or hibernating.  
> Doing I/O to a suspended drive doesn't work well and in some cases
> causes nasty problems.  Obviously these polls need to stop during a 
> suspend transition.
> 
> A search through the kernel shows that system_nrt_wq is also used in a
> few other subsystems:
> 
> ./fs/cifs/cifssmb.c:	queue_work(system_nrt_wq, &rdata->work);
> ./fs/cifs/cifssmb.c:	queue_work(system_nrt_wq, &wdata->work);
> ./fs/cifs/misc.c:				queue_work(system_nrt_wq,
> ./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
> ./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &tcp_ses->echo, SMB_ECHO_INTERVAL);
> ./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
> ./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
> 

These should  all be freezable and we might even be able to get away
with WQ_UNBOUND for some of these.

I think we put most of these in system_nrt_wq because Tejun put an
earlier job into that queue when he converted it from slow_work and we
just cargo-cult copied that...

I'll spend some time looking at this in the next day or two, but I
suspect that the right answer is to just move these off of the "public"
workqueues altogether.

> ./drivers/mmc/core/host.c:		queue_work(system_nrt_wq, &host->clk_gate_work);
> 
> ./drivers/gpu/drm/drm_crtc_helper.c:		queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
> ./drivers/gpu/drm/drm_crtc_helper.c:		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
> ./drivers/gpu/drm/drm_crtc_helper.c:		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, 0);
> 
> ./security/keys/gc.c:		queue_work(system_nrt_wq, &key_gc_work);
> ./security/keys/gc.c:	queue_work(system_nrt_wq, &key_gc_work);
> ./security/keys/gc.c:	queue_work(system_nrt_wq, &key_gc_work);
> ./security/keys/gc.c:		queue_work(system_nrt_wq, &key_gc_work);
> ./security/keys/key.c:			queue_work(system_nrt_wq, &key_gc_work);
> 
> My question to all of you: Should system_nrt_wq be made freezable, or 
> should I create a new workqueue that is both freezable and 
> non-reentrant?  And if I do, which of the usages above should be 
> converted to the new workqueue?
> 
> Thanks,
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Jeff Layton <jlayton@poochiereds.net>
