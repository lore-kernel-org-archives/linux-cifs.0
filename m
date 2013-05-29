From: Waiman Long <waiman.long@hp.com>
Subject: Re: [PATCH 0/3 v3] dcache: make it more scalable on large system
Date: Wed, 29 May 2013 16:37:21 -0400
Message-ID: <51A66701.6050104@hp.com>
References: <1369273048-60256-1-git-send-email-Waiman.Long@hp.com> <20130523094201.GA24543@dastard> <519E8B5F.3080905@hp.com> <20130527020903.GR29466@dastard> <51A624E2.3000301@hp.com> <1369844289.2769.146.camel@willson.li.ssimo.org> <20130529165603.GL6123@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Simo Sorce <simo@redhat.com>, Dave Chinner <david@fromorbit.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Layton <jlayton@redhat.com>,
	Miklos Szeredi <mszeredi@suse.cz>, Ian Kent <raven@themaw.net>,
	Sage Weil <sage@inktank.com>, Steve French <sfrench@samba.org>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>,
	"Norton, Scott J" <scott.norton@hp.com>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <autofs-owner@vger.kernel.org>
In-Reply-To: <20130529165603.GL6123@two.firstfloor.org>
Sender: autofs-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On 05/29/2013 12:56 PM, Andi Kleen wrote:
> On Wed, May 29, 2013 at 12:18:09PM -0400, Simo Sorce wrote:
>> To be honest a workload base on /etc/passwd or /etc/group is completely
>> artificial, in actual usage, if you really have  such access you use
>> nscd or sssd with their shared memory caches to completely remove most
>> of the file access.
> I don't fully agree at this point. A lot of things can be tuned away,
> but in practice we want things to perform well out of the box without
> needing all kinds of magic tuning that only
>
> Also this is just normal file access, nothing special about it.
> It simply has to scale. For all kinds of workloads.
>
> And it does, just d_path messes it up.

Just for clarification, the AIM7 workload is not affected by the current 
d_path() code, they are speed-limited by the lock contention in the 
dcache reference counting code. However, both the d_path() change and  
the dentry reference counting change are needed to to eliminate the 
overhead introduced by the use of the perf-record command.

Regards,
Longman
