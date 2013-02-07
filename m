From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Writes greater than 64k fails with -ENOSPC
Date: Thu, 07 Feb 2013 14:22:04 +0530
Message-ID: <51136B34.30609@suse.com>
References: <5107BF75.704@suse.com> <20130129192913.4942c635@tlielax.poochiereds.net> <614F550557B82C44AC27C492ADA391AA044F2484@TK5EX14MBXC283.redmond.corp.microsoft.com> <20130130093729.736ad582@corrin.poochiereds.net> <614F550557B82C44AC27C492ADA391AA044F2E62@TK5EX14MBXC283.redmond.corp.microsoft.com> <510A3ECF.2080505@suse.com> <20130131062400.6aa8fb6d@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Tom Talpey <ttalpey-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130131062400.6aa8fb6d-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 01/31/2013 04:54 PM, Jeff Layton wrote:
> On Thu, 31 Jan 2013 15:22:15 +0530
> Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org> wrote:
> 
>> On 01/30/2013 09:36 PM, Tom Talpey wrote:
>>>> -----Original Message-----
>>>> From: Jeff Layton [mailto:jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org]
>>>> Sent: Wednesday, January 30, 2013 9:37 AM
>>>> To: Tom Talpey
>>>> Cc: Suresh Jayaraman; linux-cifs
>>>> Subject: Re: Writes greater than 64k fails with -ENOSPC
>>
>>>>
>>>> The spec is not 100% clear on whether servers are *required* to support
>>>> arbitrarily large writes up to the 128k limit. Clearly there are some that do
>>>> not, and a larger default is problematic against those servers.
>>>
>>> I'd be very interested to see traces of negotiate, large read and large write from such a server.
>>
>> I'm not sure whether I can share the complete trace (without customer's
>> permission) but I can get you the specific bits that might be
>> interesting. I have asked for a full trace (including negotiate protocol).
>>
>>
>> Thanks
>>
>>
> 
> We probably don't need the whole capture. Just the "Capabilities" and
> "MaxBufferSize" values from the NEGOTIATE would be enough...
> 

The commit ce91acb3acae26f4163c5a6f1f695d1a1e8d9009 did fix the problem.

Finally, got the packet capture too. From the NEGOTIATE response,
the MaxBufferSize was 65280 and CAP_LARGE_WRITEX (and LARGE_READX) had been set.

The complete Capabilities were

.... .... .... .... .... .... .... ...0 = Raw Mode: Read Raw and Write Raw are not supported
.... .... .... .... .... .... .... ..0. = MPX Mode: Read Mpx and Write Mpx are not supported
.... .... .... .... .... .... .... .1.. = Unicode: Unicode strings are supported
.... .... .... .... .... .... .... 1... = Large Files: Large files are supported
.... .... .... .... .... .... ...1 .... = NT SMBs: NT SMBs are supported
.... .... .... .... .... .... ..1. .... = RPC Remote APIs: RPC remote APIs are supported
.... .... .... .... .... .... .1.. .... = NT Status Codes: NT status codes are supported
.... .... .... .... .... .... 1... .... = Level 2 Oplocks: Level 2 oplocks are supported
.... .... .... .... .... ...0 .... .... = Lock and Read: Lock and Read is not supported
.... .... .... .... .... ..1. .... .... = NT Find: NT Find is supported
.... .... .... .... ...1 .... .... .... = Dfs: Dfs is supported
.... .... .... .... ..1. .... .... .... = Infolevel Passthru: NT information level request passthrough is supported
.... .... .... .... .1.. .... .... .... = Large ReadX: Large Read andX is supported
.... .... .... .... 1... .... .... .... = Large WriteX: Large Write andX is supported
.... .... .... ...0 .... .... .... .... = LWIO: LWIO ioctl/fsctl is not supported
.... .... 0... .... .... .... .... .... = UNIX: UNIX extensions are not supported
.... ..0. .... .... .... .... .... .... = Compressed Data: Compressed data transfer is not supported
..0. .... .... .... .... .... .... .... = Dynamic Reauth: Dynamic Reauth is not supported
0... .... .... .... .... .... .... .... = Extended Security: Extended security exchanges are not supported


I'm not sure whether restricting it to MaxBufferSize even in case CAP_LARGE_WRITEX was set would make sense..



-- 
Suresh Jayaraman
