From: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
Subject: Re: [PATCH 2/2 linux-next] cifs: Make big endian multiplex ID sequences
 monotonic on the wire
Date: Wed, 16 Oct 2013 09:39:26 -0700
Message-ID: <525EC13E.1080304@tpi.com>
References: <1381936190-67628-1-git-send-email-timg@tpi.com>	<1381936190-67628-2-git-send-email-timg@tpi.com> <CADT32e+hGPe5WpNk-Bh-GVotQM2+-J458D1GNaRp55s3vcQWSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+hGPe5WpNk-Bh-GVotQM2+-J458D1GNaRp55s3vcQWSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/16/2013 09:25 AM, Shirish Pargaonkar wrote:
> On Wed, Oct 16, 2013 at 10:09 AM, Tim Gardner <timg-l6nL5VImRDY@public.gmane.org> wrote:
>> The multiplex identifier (MID) in the SMB header is only
>> ever used by the client, in conjunction with PID, to match responses
>> from the server. As such, the endianess of the MID is not important.
>> However, When tracing packet sequences on the wire, protocol analyzers
>> such as wireshark display MID as little endian. It is much more informative
>> for the on-the-wire MID sequences to match debug information emitted by the
>> CIFS driver.  Therefore, one should write and read MID in the SMB header
>> assuming it is always little endian.
>>
>> Observed from wireshark during the protocol negotiation
>> and session setup:
>>
>>         Multiplex ID: 256
>>         Multiplex ID: 256
>>         Multiplex ID: 512
>>         Multiplex ID: 512
>>         Multiplex ID: 768
>>         Multiplex ID: 768
>>
>> After this patch on-the-wire MID values begin at 1 and increase monotonically.
>>
>> Introduce get_next_mid64() for the internal consumers that use the full 64 bit
>> multiplex identifier.
>>
>> Introduce the helpers get_mid() and compare_mid() to make the endian
>> translation clear.
>>
>> Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> Signed-off-by: Tim Gardner <timg-l6nL5VImRDY@public.gmane.org>
>> ---
>>
>> I'm looking at some of this code in excrutiating detail because I'm having trouble
>> with a backport of CIFS from 3.9.7 on an embedded 2.6.31 powerpc. Its failing the RawNTLMSSP
>> authentication and is almost certainly an endian issue. x86 on the same code base works
>> quite well. Am I making a rash assumption that CIFS in 3.9 stable worked on big endian ?
> 
> Do you have this commit  fdf96a907c1fbb93c633e2b7ede3b8df26d6a4c0 ?
> This might help if you do not have it in your code base.
> 

Yep - I found that one pretty early on. It solved a powerpc issue with
session startup to an x86 Linux CIFS server. The current failing session
startup is to an Apple 10.8.5 (Lion) server (serverNOS=@(#)PROGRAM:smbd
 PROJECT:smbx-136.20.1).

rtg
-- 
Tim Gardner timg-l6nL5VImRDY@public.gmane.org www.tpi.com
OR 503-601-0234 x102 MT 406-443-5357
