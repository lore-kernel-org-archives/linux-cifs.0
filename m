From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Data corruption problem
Date: Fri, 11 Feb 2011 06:53:18 -0500
Message-ID: <20110211065318.62f91a5b@tlielax.poochiereds.net>
References: <20110211051458.GD27051@solid-constructs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110211051458.GD27051-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 10 Feb 2011 23:14:59 -0600
Wayne Walker <wwalker-7+hyfkrzchDWTcdHvfGLfFaTQe2KTcn/@public.gmane.org> wrote:

> First, I'm not certain whether this is samba, the linux cifs driver, or
> something else.
> 
> During testing, one of my QA guys was running an inhouse program that
> generates pseudo-random, but fully recreatable, data and writes it to
> a file, the file is named with a name that is essentially the seed to
> the pseudo- random stream, so, given a filename, it can read the file
> and verify that the data is correct.
> 
> The file he created was on a CentOS 5.5 machine that was mounting a cifs
> share on another CentOS 5.5 host running samba.  After 150K individual
> files from 35 bytes to 9 GB, he created a 9 GB file that failed
> validation.  He ran the test again with the same seed and it succeeded.
> He ran it a 3rd time and it failed again.
> 
> He got me involved.  I found no useful messages (cifs, IO, kernel mem,
> network, or samba) in any logs on client or server anywhere near the
> times of the file creations.
> 
> I cmp'd the files.  Then used "od -A x -t a" with offsets and diffed the
> 3 files.  Each of the 2 failed files has a single block of 56K (57344) nuls.
> The 2 failed files have these at different points in the 2 files.  Each
> 56K nul block starts on an offset where x % 57344 == 0.
> 
> first file:
> >>> 519995392 / 57344.
> 9068.0 # matching 56K blocks before the one null 56K block
> 
> second file is certainly on a 1 K boundary, but I mislaid the diff data
> for it and it's taking forever for cmp to run to find the offset and
> verify that it's on a 56K boundary.  I'll follow up to this email
> tomorrow with the result of the cmp.
> 
> So, I searched the kernel source, expecting to find 56K in the sata
> driver code.  Instead the only place I found it that seemed relevant
> was:
> 
> 	./fs/cifs/README:  wsize default write size (default 57344)
> 
> I have since used cp to copy the file 4 times with tcpdump running at
> both ends.  All 4 times have worked properly.  Don't know if that is
> because tcpdump is slowing it down or if our test app could be at fault.
> Our test app is talking to the local file system and not with a block
> size of 56K, so I don't think it is our app.
> 
> Unfortunately, the tcpdumps at both ends are reporting the kernel
> dropping about 50% of the packets, so even if I can get it to fail,
> I'm still  unsure whether it's the client or the samba server, where
> client would still leave me choosing betweem our app and fs/cifs.
> 
> The only other thing I can think of is the ethernet devices, but since
> the packet is made up of 30+ ethernet frames, and being TCP there is
> a payload checksum, I can't see the network layers being the culprit,
> but just in case:
> 
> client w/ fs/cifs:
> 04:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5721 Gigabit Ethernet PCI Express (rev 11)
> 
> samba server:
> 01:01.0 Ethernet controller: Intel Corporation 82547GI Gigabit Ethernet Controller
> 03:02.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet Controller
> 
> A few questions:
> 
> 0. Anyone already know of a bug in fs/cifs or samba that has this
> symptom?
> 
> 1. Anyone know how to get the kernel to not drop the packets?
> 
> 2. Any other ideas on what I can do to gather more data to differentiate
> between bad-app, fs/cifs, samba, or other-element-in-the-chain?
> 
> Thank you for all the work you guys do!
> 

Did the close() or fsync() call return an error?

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
