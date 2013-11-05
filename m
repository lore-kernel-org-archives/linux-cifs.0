From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: Re: Errors writing Large files to CIFS shares
Date: Tue, 5 Nov 2013 14:25:33 -0500
Message-ID: <20131105142533.2b9bd00e@tlielax.poochiereds.net>
References: <mailman.1277.1383636787.1861.linux-cifs-client@lists.samba.org>
	<CAHPMNWdLy7cfJdRGp=2-pUQqFO=PgUYT8E2_uW9koNdv1x_D_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Neil Sikka <neilsikka-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHPMNWdLy7cfJdRGp=2-pUQqFO=PgUYT8E2_uW9koNdv1x_D_g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 5 Nov 2013 10:23:41 -0800
Neil Sikka <neilsikka-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hello. I am running Debian 7.2, and I get errors writing "large"
> (32.5KB) files to shares mounted via CIFS. Writing "small" files to
> the remote share works. I am not sure if its relevant, but this share
> is mounted over a slow pptp connection. Here are some of the details
> of what I am running:
> 
> 3.2.0-4-amd64 #1 SMP Debian 3.2.51-1 x86_64 GNU/Linux
> 

3.2 is ancient history now ;)

> The Kernel log contains the following data:
> 
> [ 2243.047442] CIFS VFS: Server <IP_REMOVED> has not responded in 300
> seconds. Reconnecting...
> [ 2263.693713] CIFS VFS: sends on sock ffff88020e477d40 stuck for 15 seconds
> [ 2263.693721] CIFS VFS: Error -11 sending data on socket to server

Looks like you're losing connectivity to the server. I'd have a hard
look at your network connectivity. Maybe sniff traffic and see if you
can figure out what's happening on the wire.

> [ 2279.434990] INFO: task cp:4807 blocked for more than 120 seconds.
> [ 2279.434996] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 2279.435000] cp              D ffff88023fc93780     0  4807   4412 0x00000000
> [ 2279.435009]  ffff8802336281c0 0000000000000086 ffff8802239067f0
> ffff8802333a5650
> [ 2279.435017]  0000000000013780 ffff880235ba7fd8 ffff880235ba7fd8
> ffff8802336281c0
> [ 2279.435025]  ffffffff810135d2 ffffffff81066245 ffff880233348d70
> ffff88023fc93fd0
> [ 2279.435033] Call Trace:
> [ 2279.435045]  [<ffffffff810135d2>] ? read_tsc+0x5/0x14
> [ 2279.435052]  [<ffffffff81066245>] ? timekeeping_get_ns+0xd/0x2a
> [ 2279.435060]  [<ffffffff810b4afb>] ? lock_page+0x20/0x20
> [ 2279.435067]  [<ffffffff8134e141>] ? io_schedule+0x59/0x71
> [ 2279.435073]  [<ffffffff810b4b01>] ? sleep_on_page+0x6/0xa
> [ 2279.435078]  [<ffffffff8134e584>] ? __wait_on_bit+0x3e/0x71
> [ 2279.435085]  [<ffffffff810b4c3d>] ? wait_on_page_bit+0x6e/0x73
> [ 2279.435093]  [<ffffffff8105fcad>] ? autoremove_wake_function+0x2a/0x2a
> [ 2279.435100]  [<ffffffff810b4d15>] ? filemap_fdatawait_range+0x74/0x139
> [ 2279.435108]  [<ffffffff810b64c9>] ? filemap_write_and_wait+0x24/0x30
> [ 2279.435124]  [<ffffffffa063d3ce>] ? cifs_flush+0x20/0x50 [cifs]
> [ 2279.435132]  [<ffffffff810f922d>] ? filp_close+0x3b/0x6a
> [ 2279.435137]  [<ffffffff810f92ea>] ? sys_close+0x8e/0xcb
> [ 2279.435143]  [<ffffffff81354212>] ? system_call_fastpath+0x16/0x1b
> [ 2294.192963] CIFS VFS: sends on sock ffff88020e477d40 stuck for 15 seconds
> [ 2294.192971] CIFS VFS: Error -11 sending data on socket to server
> 
> I mounted the CIFS share using the following command:
> mount -t cifs //<IP_REMOVED>/share /mnt/net2/ -o username=<USERNAME_REMOVED>
> 
> I see many other people had this problem in the past (almost 4 years
> ago). A similar description can be found here:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=522867
> 
> That bug was marked as WONTFIX
> 
> Was there ever a workaround or resolution for this bug? I am obviously
> not running software from 2009 (like in that bugzilla post), so I
> would have thought this would have been resolved. Could this bug be a
> regression?
> 
> Thanks.
> 


-- 
Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
