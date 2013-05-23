From: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 0/3 v3] dcache: make it more scalable on large system
Date: Thu, 23 May 2013 17:34:23 -0400
Message-ID: <519E8B5F.3080905@hp.com>
References: <1369273048-60256-1-git-send-email-Waiman.Long@hp.com> <20130523094201.GA24543@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>,
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
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130523094201.GA24543@dastard>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/23/2013 05:42 AM, Dave Chinner wrote:
> On Wed, May 22, 2013 at 09:37:25PM -0400, Waiman Long wrote:
>> Change log:
>>
>> v2->v3
>>   - Fix the RCU lock problem found by Al Viro.
>>   - Rebase the code to the latest v3.10-rc1 linux mainline.
>>   - Remove patch 4 which may be problematic if the dentry is deleted.
>>   - Rerun performance measurement using 3.10-rc1 kernel.
>>
>> v1->v2
>>   - Include performance improvement in the AIM7 benchmark results because
>>     of this patch.
>>   - Modify dget_parent() to avoid taking the lock, if possible, to further
>>     improve AIM7 benchmark results.
>>
>> During some perf-record sessions of the kernel running the high_systime
>> workload of the AIM7 benchmark, it was found that quite a large portion
>> of the spinlock contention was due to the perf_event_mmap_event()
>> function itself. This perf kernel function calls d_path() which,
>> in turn, call path_get() and dput() indirectly. These 3 functions
>> were the hottest functions shown in the perf-report output of
>> the _raw_spin_lock() function in an 8-socket system with 80 cores
>> (hyperthreading off) with a 3.10-rc1 kernel:
> What was it I said about this patchset when you posted it to speed
> up an Oracle benchmark back in february? I'll repeat:
>
> "Nobody should be doing reverse dentry-to-name lookups in a quantity
> sufficient for it to become a performance limiting factor."

Thank for the comment, but my point is that it is the d_lock contention 
is skewing the data about how much spin lock contention had actually 
happened in the workload and it makes it harder to pinpoint problem 
areas to look at. This is not about performance, it is about accurate 
representation of performance data. Ideally, we want the overhead of 
turning on perf instrumentation to be as low as possible.


>
> And that makes whatever that tracepoint is doing utterly stupid.
> Dumping out full paths in a tracepoint is hardly "low overhead", and
> that tracepoint should be stomped on from a great height. Sure,
> print the filename straight out of the dentry into a tracepoint,
> but repeated calculating the full path (probably for the same set of
> dentries) is just a dumb thing to do.
>
> Anyway, your numbers show that a single AIM7 microbenchmark goes
> better under tracing the specific mmap event that uses d_path(), but
> the others are on average a little bit slower. That doesn't convince
> me that this is worth doing. Indeed, what happens to performance
> when you aren't tracing?
>
> Indeed, have you analysed what makes that
> microbenchmark contend so much on the dentry lock while reverse
> lookups are occuring? Dentry lock contention does not necessarily
> indicate a problem with the dentry locks, and without knowing why
> there is contention occuring (esp. compared to the other benchmarks)
> we can't really determine if this is a good solution or not...

What made it contend so much was the large number of CPUs available in 
my test system which is a 8-socket Westmere EX machines with 80 cores. 
As perf was collecting data from every core, the threads will 
unavoidably bump into each other to translate dentries back to the full 
paths. The current code only allows one CPU in the d_path() critical 
path. My patch will allow all of them to be in the critical path 
concurrently.

The upcoming Ivy-Bridge EX can have up to 15 cores per socket. So even a 
4-socket machine will have up to 60 cores or 120 virtual CPUs if 
hyperthreading is turned on.
> IOWs, you need more than one microbenchmark that interacts with
> some naive monitoring code to justify the complexity these locking
> changes introduce....
The first patch can also independently improve the performance of a 
number of AIM7 workloads including almost 7X improvement in the short 
workload. More detailed information of these types of performance 
benefit was discussed in the patch description of the first patch. I 
will try to collect more performance improvement data on other workloads 
too.

Thank for the review.
Longman
