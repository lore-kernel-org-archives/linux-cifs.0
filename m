From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 0/3 v3] dcache: make it more scalable on large system
Date: Wed, 29 May 2013 14:46:40 -0400
Message-ID: <20130529184640.GA3243@fieldses.org>
References: <1369273048-60256-1-git-send-email-Waiman.Long@hp.com>
 <20130523094201.GA24543@dastard>
 <519E8B5F.3080905@hp.com>
 <20130527020903.GR29466@dastard>
 <51A624E2.3000301@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
Content-Disposition: inline
In-Reply-To: <51A624E2.3000301-VXdhtT5mjnY@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 29, 2013 at 11:55:14AM -0400, Waiman Long wrote:
> On 05/26/2013 10:09 PM, Dave Chinner wrote:
> >On Thu, May 23, 2013 at 05:34:23PM -0400, Waiman Long wrote:
> >>On 05/23/2013 05:42 AM, Dave Chinner wrote:
> >>>
> >>>What was it I said about this patchset when you posted it to speed
> >>>up an Oracle benchmark back in february? I'll repeat:
> >>>
> >>>"Nobody should be doing reverse dentry-to-name lookups in a quantity
> >>>sufficient for it to become a performance limiting factor."
> >>Thank for the comment, but my point is that it is the d_lock
> >>contention is skewing the data about how much spin lock contention
> >>had actually happened in the workload and it makes it harder to
> >>pinpoint problem areas to look at. This is not about performance, it
> >>is about accurate representation of performance data. Ideally, we
> >>want the overhead of turning on perf instrumentation to be as low as
> >>possible.
> >Right. But d_path will never be "low overhead", and as such it
> >shouldn't be used by perf.
> 
> The d_path() is called by perf_event_mmap_event() which translates
> VMA to its file path for memory segments backed by files. As perf is
> not just for sampling data within the kernel, it can also be used
> for checking access pattern in the user space. As a result, it needs
> to map VMAs back to the backing files to access their symbols
> information. If d_path() is not the right function to call for this
> purpose, what other alternatives do we have?

As Dave said before, is the last path component sufficient?  Or how
about an inode number?

--b.
