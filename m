From: Simo Sorce <simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/3 v3] dcache: make it more scalable on large system
Date: Wed, 29 May 2013 12:18:09 -0400
Message-ID: <1369844289.2769.146.camel@willson.li.ssimo.org>
References: <1369273048-60256-1-git-send-email-Waiman.Long@hp.com>
	 <20130523094201.GA24543@dastard> <519E8B5F.3080905@hp.com>
	 <20130527020903.GR29466@dastard>  <51A624E2.3000301@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Miklos Szeredi <mszeredi-AlSwsSmVLrQ@public.gmane.org>, Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>,
	Sage Weil <sage-4GqslpFJ+cxBDgjK7y7TUQ@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Trond Myklebust <Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
	Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, autofs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	"Chandramouleeswaran, Aswin" <aswin-VXdhtT5mjnY@public.gmane.org>,
	"Norton, Scott J" <scott.norton-VXdhtT5mjnY@public.gmane.org>,
	Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
To: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51A624E2.3000301-VXdhtT5mjnY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 2013-05-29 at 11:55 -0400, Waiman Long wrote:

> My patch set consists of 2 different changes. The first one is to avoid 
> taking the d_lock lock when updating the reference count in the 
> dentries. This particular change also benefit some other workloads that 
> are filesystem intensive. One particular example is the short workload 
> in the AIM7 benchmark. One of the job type in the short workload is 
> "misc_rtns_1" which calls security functions like getpwnam(), 
> getpwuid(), getgrgid() a couple of times. These functions open the 
> /etc/passwd or /etc/group files, read their content and close the files. 
> It is the intensive open/read/close sequence from multiple threads that 
> is causing 80%+ contention in the d_lock on a system with large number 
> of cores.

To be honest a workload base on /etc/passwd or /etc/group is completely
artificial, in actual usage, if you really have  such access you use
nscd or sssd with their shared memory caches to completely remove most
of the file access.
I have no beef on the rest but repeated access to Nsswitch information
is not something you need to optimize at the file system layer and
should not be brought up as a point in favor.

Simo.

-- 
Simo Sorce * Red Hat, Inc * New York
