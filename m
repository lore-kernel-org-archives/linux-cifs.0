From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS shares keep hanging with VirtualBox
Date: Thu, 19 Apr 2012 21:10:01 -0500
Message-ID: <CAH2r5mu8krM=a4FhaEJnuSFfzUkxP5AxJ89eidFHUOKPVzvnPQ@mail.gmail.com>
References: <20120419173627.GA4337@pervalidus>
	<20120419135151.6745d624@corrin.poochiereds.net>
	<20120419194357.GA4574@pervalidus>
	<CAH2r5muAnRf-cNbE2WH6a1fZmX+diti+bbtCK-iju7wdKm7L8g@mail.gmail.com>
	<20120419233906.GB4574@pervalidus>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?ISO-8859-1?B?RnLpZOlyaWMgTC4gVy4=?= <fredlwm-fLz7/M+a0ZzR7s880joybQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120419233906.GB4574@pervalidus>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Apr 19, 2012 at 6:39 PM, Fr=E9d=E9ric L. W. <fredlwm-fLz7/M+a0ZxNg+MwTxZMZA@public.gmane.org=
t> wrote:
> On Thu, Apr 19, 2012 at 03:19:13PM -0500, Steve French wrote:
>> On Thu, Apr 19, 2012 at 2:43 PM, Fr=E9d=E9ric L. W. wrote:
>> >
>> > I captured a log with 'tcpdump', but I don't think it's of any use=
=2E It
>> > stopped logging at 16:01 but the hang happened after that. It didn=
't log
>> > anything from the problematic 'ls', 'kill -9' and 'umount /mnt/ntf=
s2'.
>>
>> Maybe capture a log (with netmon on wireshark) on the windows side
>> to see what the trace shows.
>>
>> Presumably some odd networking issue with virtual box, but
>> may =A0be useful to see which command fails/timesout by
>> looking at dmesg output on the client (running the
>> test after enabling /proc/fs/cifs/cifsFYI setting it
>> to 7 e.g.).
>>
>> At least with the server returning maxmpx of 50, it is less
>> likely to be the bug with too many outstanding requests.
>
> I noticed that if I change the connection in VirtualBox from NAT to
> Bridged Adapter, the hangs don't occur (at least after about 2h).
>
> Are you still interested in a log from Windows in NAT mode, where the
> hangs happen, or this is definitely an issue / "feature" in VirtualBo=
x ?
>
> What I don't know is if CIFS could do anything to exit gracefully
> instead of deadlocking the application trying to access the share.

I would love to investigate in more detail (obviously if easy cifs
changes can lessen or resolve strange networking problems, we are
all for it) but I have other problems with virtualbox setup at the mome=
nt
that make it hard for me to see whether I run into the same issue.

--=20
Thanks,

Steve
