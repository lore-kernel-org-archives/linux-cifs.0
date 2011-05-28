From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Big performance improvements seen with cifs async write patches
 even over localhost
Date: Sat, 28 May 2011 12:21:55 -0500
Message-ID: <BANLkTik1vW-PnEiaSfLnr0pWhr_rFLTowQ@mail.gmail.com>
References: <BANLkTinVOaFwkCf33iKNk8GjqiiBEF5N3w@mail.gmail.com>
	<20110527164702.GB28520@samba2>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110527164702.GB28520@samba2>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, May 27, 2011 at 11:47 AM, Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, May 27, 2011 at 12:14:19AM -0500, Steve French wrote:
>> Did some informal testing of Jeff Layton's cifs async_write patch set
>> tonight (recent kernel). Copying 700MB sequentially was 20% faster
>> from cifs kernel client to Samba 3.6 with his patches - even mounted
>> over localhost (where network latency is a much smaller issue) and
>> with a slow laptop drive!
>>
>> I was simply doing
>>
>> time dd if=/dev/zero of=/mnt/null bs=1M count=700
>>
>> repeated 4 times each way (with old module, and with same code with
>> Jeff's cifs async write code builtin), deleting the target file in
>> between each run.
>>
>> I am looking forward to trying this over GigE tomorrow to servers with
>> faster disks.
>
> Very nice ! Now where's my encrypted transport Steve ? :-) :-)
>
> Jeremy.

Did some additional informal testing with this (current mainline vs.
cifs from 2.6.39) and the results are even better.

Mounted over GiGE to midrange desktop system from my laptop.  Copying
2.5GB to the server was 88% faster with current mainline.   Repeated
the test 3 times each way.  Current mainline cifs averaged 98.9 MB/s
for sequential file copy vs. 52.6 MB/s (for 2.6.39 and older).

stevef@stevef-laptop:~$ time dd if=/dev/zero of=/mnt/null bs=1M count=2500
2500+0 records in
2500+0 records out
2621440000 bytes (2.6 GB) copied, 26.3095 s, 99.6 MB/s

real	0m27.201s
user	0m0.000s
sys	0m3.340s




-- 
Thanks,

Steve
