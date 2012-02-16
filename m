From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: system_nrt_wq, system suspend, and the freezer
Date: Thu, 16 Feb 2012 09:41:34 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1202160930010.1268-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux-pm mailing list <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-mmc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, <keyrings-6DNke4IJHB0gsBAKwltoeQ@public.gmane.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Chris Ball <cjb-2X9k7bc8m7Mdnm+yROfE0A@public.gmane.org>, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Folks:

I recently uncovered a bug in the block layer.  It uses a workqueue to
periodically probe removable drives for media or other state changes,
and the workqueue it uses is system_nrt_wq.

The bug is that system_nrt_wq is not freezable, so it keeps on running
even while the system is in the process of suspending or hibernating.  
Doing I/O to a suspended drive doesn't work well and in some cases
causes nasty problems.  Obviously these polls need to stop during a 
suspend transition.

A search through the kernel shows that system_nrt_wq is also used in a
few other subsystems:

./fs/cifs/cifssmb.c:	queue_work(system_nrt_wq, &rdata->work);
./fs/cifs/cifssmb.c:	queue_work(system_nrt_wq, &wdata->work);
./fs/cifs/misc.c:				queue_work(system_nrt_wq,
./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &server->echo, SMB_ECHO_INTERVAL);
./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &tcp_ses->echo, SMB_ECHO_INTERVAL);
./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,
./fs/cifs/connect.c:	queue_delayed_work(system_nrt_wq, &cifs_sb->prune_tlinks,

./drivers/mmc/core/host.c:		queue_work(system_nrt_wq, &host->clk_gate_work);

./drivers/gpu/drm/drm_crtc_helper.c:		queue_delayed_work(system_nrt_wq, delayed_work, DRM_OUTPUT_POLL_PERIOD);
./drivers/gpu/drm/drm_crtc_helper.c:		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, DRM_OUTPUT_POLL_PERIOD);
./drivers/gpu/drm/drm_crtc_helper.c:		queue_delayed_work(system_nrt_wq, &dev->mode_config.output_poll_work, 0);

./security/keys/gc.c:		queue_work(system_nrt_wq, &key_gc_work);
./security/keys/gc.c:	queue_work(system_nrt_wq, &key_gc_work);
./security/keys/gc.c:	queue_work(system_nrt_wq, &key_gc_work);
./security/keys/gc.c:		queue_work(system_nrt_wq, &key_gc_work);
./security/keys/key.c:			queue_work(system_nrt_wq, &key_gc_work);

My question to all of you: Should system_nrt_wq be made freezable, or 
should I create a new workqueue that is both freezable and 
non-reentrant?  And if I do, which of the usages above should be 
converted to the new workqueue?

Thanks,

Alan Stern
