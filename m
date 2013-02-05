From: Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org>
Subject: Re: Read speed
Date: Tue, 05 Feb 2013 12:12:22 -0500
Message-ID: <51113D76.80609@kickflop.net>
References: <51105F16.8070603@kickflop.net> <CAH2r5mvbbuo9e30kuRFp9eegJqq_9HLR9=oaGvFqyMi-aBKXTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mvbbuo9e30kuRFp9eegJqq_9HLR9=oaGvFqyMi-aBKXTQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thank you for the thorough reply, Steve. It's nice to
read of the progress in 2012, but RHEL 6.3 and what is
supported there is what we have to work with. It is the
latest supported version, as you surely know, so it
seems like we'll have to wait quite awhile before
getting the module's read performance increases.

We're dealing with 9 US sites, nightly time window (which
we're exceeding) for transferring large amounts of data
over 1.5Mbps links).

Back to the drawing board.

Thanks again.

On 2/4/2013 9:03 PM, Steve French wrote:
> You will need a more recent kernel (probably based on the 3.2 kernel
> or later, 3.2 was released a year or so ago) to see the dramatic
> improvements in cifs read speeds (with the redesign of the read code
> to add more parallelism on i/o to the same file) although RedHat may
> have backported some of Jeff's excellent performance improvements to
> some of the older distros.  See slides 21 through 26 of my
> presentation at
>
>   http://www.snia.org/sites/default/files2/SDC2012/presentations/Revisions/SteveFrench_Linux_CIFS-SMB2-year-in-review-revision.pdf
>
> Slides 23 and 24 list the cifs performance and functional enhancements
> by kernel release.  Buffered, sequential read (e.g. file copy from a
> server) got much faster in 3.2 kernel, especially to Samba and other
> server which support the Unix extensions (due to support for larger
> i/o sizes than 64K).
>
> Similarly note that cifs write speed was dramatically improved
> starting at kernel version 3.0 (1.5 to 2 years ago) due to the
> addition of more async parallelism to the design of the cifs write
> code (writing to the server from the cifs client) by making the i/o
> sizes larger and allowing more async dispatch of writes (previously to
> use a network interface fully you would need to be reading and or
> writing to multiple different files simultaneously).
>
> On Mon, Feb 4, 2013 at 7:23 PM, Jeff Blaine <jblaine-GbE5gUWZ6k7k1uMJSBkQmQ@public.gmane.org> wrote:
>> Hi,
>>
>> On a RHEL 6.3 box talking to a Windows 7 Enterprise box,
>> I am seeing approximately 1/4th the speed with mount.cifs
>> as I am with smbclient 'get'. RHEL 6.3 currently has
>> CIFS 1.68.
>>
>> After about a half hour of reading forum threads for the
>> last few years, it seems this is very well known and has
>> been the case for a long time.
>>
>> I have tried using CIFSMaxBufSize=61440 with rsize=61140
>> at mount-time and it doesn't really buy me much.
>>
>> Is there any sort of public-facing summary of the state of
>> the read performance issues. I saw no mention of it in the
>> BUGS section of the mount.cifs man page or in the README for
>> the kernel module.
>>
>> Is the cause known?
>>
>> Has already been fixed since 1.68 by chance? If so,
>> what assembly of pieces will overcome the issue? Should
>> I just open a RHEL bug through our support channel and
>> get them involved in this effort somehow?
>>
>> Any guidance would be welcome at this point.
>>
>> Jeff
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
