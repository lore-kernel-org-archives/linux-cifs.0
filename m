From: Steve French <smfrench@gmail.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 14:02:09 -0500
Message-ID: <CAH2r5msrKqmMY4=NP4VvOYNMerB-+Cu+6ba4+0fZcFEqFmcdYw@mail.gmail.com>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan>
	<20110815064734.403b630f@corrin.poochiereds.net>
	<alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
	<alpine.DEB.2.02.1108151357200.32349@p34.internal.lan>
	<alpine.DEB.2.02.1108171515050.5877@p34.internal.lan>
	<3300.1313637592@jrobl>
	<alpine.DEB.2.02.1108180632000.10458@p34.internal.lan>
	<alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
	<alpine.DEB.2.02.1108180821440.7903@p34.internal.lan>
	<20110818091140.385a9455@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
	<20110818130408.71c55b96@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108181314310.7903@p34.internal.lan>
	<CAH2r5mvNkUWh0rYTbTEWmUPiRsxUbmrGNpTOaebiG0CCKRfA1g@mail.gmail.com>
	<alpine.DEB.2.02.1108181331180.7903@p34.internal.lan>
	<CAH2r5msTpKdxwpgG+-3-gkkr5h7Ox1tL86q3LyTBMd1V8WS7aQ@mail.gmail.com>
	<alpine.DEB.2.02.1108181413030.7903@p34.internal.lan>
	<20110818145257.035a38e9@barsoom.rdu.redhat.com>
	<alpine.DEB.2.02.1108181452080.7903@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton@samba.org>,
	"J. R. Okajima" <hooanon05@yahoo.co.jp>,
	Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1108181452080.7903@p34.internal.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Aug 18, 2011 at 1:54 PM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Thu, 18 Aug 2011, Jeff Layton wrote:
>
>> On Thu, 18 Aug 2011 14:18:15 -0400 (EDT)
>> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>>
>>>
>>
>> Like I said, read performance with cifs.ko just plain sucks currently.
>>
>> Don't look for cifs.ko to achieve anywhere near NFS' performance unless
>> you jump through some very odd hoops (like multithreading your workload
>> in userspace, etc). cifs.ko just doesn't do a good job of keeping the
>> pipe "stuffed" as most calls are handled synchronously. A single task
>> can only handle one call on the wire in most cases. The exception here
>> is writes, but that just recently changed...
>>
>> Reads are done using relatively small buffers and then copied to
>> pagecache. Part of what I'm working on will be to allow for much larger
>> reads directly into the pagecache. That should also help performance
>> significantly.

As Jeff notes, large file sequential read of one file at a time is going
to be cifs kernel client's worst case.   An earlier cifs async patchset
(prototype) showed dramatic improvements so it is not
inherent in the protocol and I am looking forward to seeing
Jeff's patches for this.

With multiple processes reading/writing cifs does pretty well
(since the worst case serialization is in cifs_readpages,
coupled with the relatively small buffer size on reads), as long as
you are accessing various files at one time.   I have seen
cifs beat nfs on broader tests such as dbench when lots of activity on the
wire from multiple processes - but meant to do a dbench run
on recent kernels to compare.   Would be interesting to compare
dbench now (with e.g. more than 30 processes) on nfs mount to
cifs mount.


-- 
Thanks,

Steve
