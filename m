From: Waiman Long <waiman.long-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 0/3 v3] dcache: make it more scalable on large system
Date: Wed, 29 May 2013 16:23:02 -0400
Message-ID: <51A663A6.90904@hp.com>
References: <1369273048-60256-1-git-send-email-Waiman.Long@hp.com> <20130523094201.GA24543@dastard> <519E8B5F.3080905@hp.com> <20130527020903.GR29466@dastard> <51A624E2.3000301@hp.com> <20130529161358.GJ6123@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
	"Norton, Scott J" <scott.norton-VXdhtT5mjnY@public.gmane.org>
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130529161358.GJ6123-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/29/2013 12:13 PM, Andi Kleen wrote:
>> The d_path() is called by perf_event_mmap_event() which translates
>> VMA to its file path for memory segments backed by files. As perf is
>> not just for sampling data within the kernel, it can also be used
>> for checking access pattern in the user space. As a result, it needs
>> to map VMAs back to the backing files to access their symbols
>> information. If d_path() is not the right function to call for this
>> purpose, what other alternatives do we have?
> In principle it should be only called for new file mappings
> getting maped.  Do you really have that many new file mappings all
> the time? Or is this related to program startup?

The AIM7 benchmark that I used runs a large number of relatively short 
jobs. I think each time a new job is spawned, the file mappngs have to 
be redone again. It is probably not a big problem for long running 
processes.

>> My patch set consists of 2 different changes. The first one is to
>> avoid taking the d_lock lock when updating the reference count in
>> the dentries. This particular change also benefit some other
>> workloads that are filesystem intensive. One particular example is
>> the short workload in the AIM7 benchmark. One of the job type in the
>> short workload is "misc_rtns_1" which calls security functions like
>> getpwnam(), getpwuid(), getgrgid() a couple of times. These
>> functions open the /etc/passwd or /etc/group files, read their
>> content and close the files. It is the intensive open/read/close
>> sequence from multiple threads that is causing 80%+ contention in
>> the d_lock on a system with large number of cores. The MIT's
>> MOSBench paper also outlined dentry reference counting as a
> The paper was before Nick Piggin's RCU (and our) work on this.
> Modern kernels do not have dcache problems with mosbench, unless
> you run weird security modules like SMACK that effectively
> disable dcache RCU.

I had tried, but not yet able to run the MOSBench myself. Thank for 
letting me know that the dcache problem wrt MOSBench was fixed.

> BTW lock elision may fix these problems anyways, in a much
> simpler way.

I will certainly hope so. However, there will still be a lot of 
computers out there running pre-Haswell Intel chips. For them, locking 
is still a problem that need to be solved.

Regards,
Longman
