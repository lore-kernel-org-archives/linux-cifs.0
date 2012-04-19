From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS shares keep hanging with VirtualBox
Date: Thu, 19 Apr 2012 15:19:13 -0500
Message-ID: <CAH2r5muAnRf-cNbE2WH6a1fZmX+diti+bbtCK-iju7wdKm7L8g@mail.gmail.com>
References: <20120419173627.GA4337@pervalidus>
	<20120419135151.6745d624@corrin.poochiereds.net>
	<20120419194357.GA4574@pervalidus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= <fredlwm-fLz7/M+a0ZzR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419194357.GA4574@pervalidus>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Apr 19, 2012 at 2:43 PM, Fr=E9d=E9ric L. W. <fredlwm-fLz7/M+a0ZxNg+MwTxZMZA@public.gmane.org=
t> wrote:
> On Thu, Apr 19, 2012 at 01:51:51PM -0400, Jeff Layton wrote:
>>
>> On Thu, 19 Apr 2012 14:36:27 -0300 Fr=E9d=E9ric L. W. Meunier wrote:
>>
>> > I use VirtualBox (4.1.12) on Windows 7 Ultimate SP1. The guest is =
Linux
>> > (kernel 3.3.2, cifs-utils 5.3), which I boot directly from a parti=
tion.
>> >
>> > If I use CIFS to access the Windows partitions, the connections
>> > constantly hang and the applications to access it deadlock until k=
illed.
>>
>> Looks like the server just isn't responding to echo requests. Sniffi=
ng
>> the traffic between client and server might be good to confirm that:
>>
>> =A0 =A0 https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#W=
ire_Captures
>>
>> Are you connecting to the CIFS server in windows 7 with this? Or som=
e
>> other VMware SMB server thingy?
>
> Yes. It's the same computer. I use VirtualBox in Windows 7 to boot
> Linux, which is installed in the same hard drive. Then, in Linux, I u=
se
> CIFS to have access to the Windows 7 partitions.
>
> I captured a log with 'tcpdump', but I don't think it's of any use. I=
t
> stopped logging at 16:01 but the hang happened after that. It didn't =
log
> anything from the problematic 'ls', 'kill -9' and 'umount /mnt/ntfs2'=
=2E

Maybe capture a log (with netmon on wireshark) on the windows side
to see what the trace shows.

Presumably some odd networking issue with virtual box, but
may  be useful to see which command fails/timesout by
looking at dmesg output on the client (running the
test after enabling /proc/fs/cifs/cifsFYI setting it
to 7 e.g.).

At least with the server returning maxmpx of 50, it is less
likely to be the bug with too many outstanding requests.



--=20
Thanks,

Steve
