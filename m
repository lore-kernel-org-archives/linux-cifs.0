From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Big performance improvements seen with cifs async write patches
 even over localhost
Date: Fri, 27 May 2011 12:09:30 -0500
Message-ID: <BANLkTikCUy-R16_QhuwNtynP9mXd9zFDNQ@mail.gmail.com>
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

Note that Samba defaults to negotiating a 128K write size but sending
"min receivefile size" in smb.conf to a larger value will allow larger
writes.   I see slightly better performance on the simple dd test over
localhost network interface with larger wsize of 512K than I do with
the default (128K).   I haven't measured the ideal wsize yet but
presumably it will vary depending on network and disk speed and server
load.

> Very nice ! Now where's my encrypted transport Steve ? :-) :-)

First cleanup patch is in (which gracefully handles failing mounts
when server requires encryption and client can't do it).    The 2nd
part - the NTLMSSP negotiation inside setfsunixinfo wasn't too bad and
I plan to send out for review within a few days.  I haven't written
the piece which uses these credentials to do the encryption yet.



-- 
Thanks,

Steve
