From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Linux CIFS client, Windows 2012 CIFS file server => files not found?
Date: Thu, 20 Aug 2015 15:23:03 -0500
Message-ID: <CAH2r5mtfjj6-XvPoGTSOA8Cd9-wOEpUd5xhYGJzMHbDYboQ-ZA@mail.gmail.com>
References: <55D5D6FF.1070207@gmail.com> <CAH2r5mv6k7Yw5My-k0b_c32y9QRv+3g-L=e3UagexXfpSMFnXA@mail.gmail.com>
 <55D62C59.4000903@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Kristian Rink <kawazu428-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55D62C59.4000903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Aug 20, 2015 at 2:36 PM, Kristian Rink <kawazu428-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Hi Steve;
>
> and first off, thanks loads for your feedback.
>
> Am 20.08.2015 um 18:11 schrieb Steve French:
>>
>> any chance you could send me a small capture file of each (preferably
>> the smallest possible reproduction scenario so the trace isn't big and
>> cluttered) so I can compare the two server's responses to see what
>> might be going on.
>
>
> Sure, it's easy to reproduce, and I ended up with two pcap files.

Last thing in the trace is a parallelized read with lots of reads in
flight at once which should be ok and I do see a response.

Two obvious things to ask:

1) What dialect are you using when you mount to Windows?  It looks
like SMB2.0 (and would be MUCH better to use SMB2.1 or SMB3 or
SMB3.02, or even CIFS when mounting to Windows, SMB2.0 is old and does
not support large reads/writes and it looks like it is failing )
rather than the default CIFS.  To NetApp you are mounting using CIFS
(not SMB2 or SMB3) which seems to work ok for your workload looking at
the trace.

Note that you should try the same dialect on both the mount to NetApp
and Windows to make the comparison easier:  e.g. after -o in the mount
command specify "vers=2.1" or "vers=3.0" (or don't specify any vers
(or "vers=1.0") and it should default to cifs)

2) Are there any things logged in the message log on the Linux client
(type "dmesg" to see what is logged) by cifs.ko during the failure on
running to Windows.   Does the status of the session show disconnected
at the end of the failure to Windows?   (See the "SMB session status"
and "TCP status" in the output of "cat /proc/fs/cifs/DebugData")


-- 
Thanks,

Steve
