From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Kernel 3.0: Instant kernel crash when mounting CIFS (also crashes
 with linux-3.1-rc2
Date: Thu, 18 Aug 2011 09:15:36 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1108180914180.7903@p34.internal.lan>
References: <alpine.DEB.2.02.1108150506310.7571@p34.internal.lan> <alpine.LNX.2.00.1108151117480.19668@swampdragon.chaosbits.net> <20110815064734.403b630f@corrin.poochiereds.net> <alpine.DEB.2.02.1108150653200.7571@p34.internal.lan>
 <alpine.DEB.2.02.1108151357200.32349@p34.internal.lan> <alpine.DEB.2.02.1108171515050.5877@p34.internal.lan> <3300.1313637592@jrobl> <alpine.DEB.2.02.1108180632000.10458@p34.internal.lan> <alpine.DEB.2.02.1108180807070.7903@p34.internal.lan>
 <alpine.DEB.2.02.1108180821440.7903@p34.internal.lan> <20110818091140.385a9455@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
	Jesper Juhl <jj@chaosbits.net>, linux-kernel@vger.kernel.org,
	Alan Piszcz <ap@solarrain.com>,
	Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110818091140.385a9455@barsoom.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org



On Thu, 18 Aug 2011, Jeff Layton wrote:

> On Thu, 18 Aug 2011 08:22:44 -0400 (EDT)
> Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>> Justin.
>>
>
> To be clear -- incoming in this case is reads or writes?
Reading from the CIFS share (Windows 7).

>
> Up until 3.0 cifs.ko didn't parallelize writes from a single thread. In
> 3.0 I added a patchset to increase the allowable wsize and to allow the
> kernel to issue writes in parallel.
Ahh, good to know, have not tried writes yet.

>
> Reads still suffer from the same problem however. I'm working on a
> patchset that should do the same thing for them, but it requires a
> fairly substantial overhaul of the receive codepaths.
Ok, that explains it then, thanks.

One other item, the rsync is currently running, what does mean/what option
would fix it/make the error go away?

[ 3730.897554] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3755.727255] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3760.509489] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3760.786650] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3762.854706] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3763.052163] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3764.962962] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3765.460372] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3765.855425] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3767.677672] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3781.958450] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3800.493896] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3805.911191] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3806.121384] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3817.356127] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3825.148050] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3833.687886] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3834.199746] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3834.448342] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3866.848508] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3867.126729] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3868.428427] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3872.206396] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3872.812745] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3877.655580] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3880.718684] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3880.769545] CIFS VFS: did not end path lookup where expected namelen is 0
[ 3882.026917] CIFS VFS: did not end path lookup where expected namelen is 0

Justin.
