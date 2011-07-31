From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: patch status
Date: Sun, 31 Jul 2011 16:29:17 -0500
Message-ID: <CAH2r5mt1QaDH_YVumTavDccVZCRaK_cct9VOAfe8A-nwvhH-=Q@mail.gmail.com>
References: <CAH2r5mtRqCQQiwSuzUv9tjGnmfb9jtqo0odZPrUYyGMBBPor6w@mail.gmail.com>
	<20110728092259.3717b890@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110728092259.3717b890-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Have finished reviewing all of your patches that I saw in your
http://git.kernel.org/?p=3Dlinux/kernel/git/jlayton/linux.git;a=3Dshort=
log;h=3Drefs/heads/cifs-3.1

looking at Pavel's now.  Will probably request upstream merge of the cu=
rrent
eight patches first.

On Thu, Jul 28, 2011 at 8:22 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Thu, 28 Jul 2011 08:07:50 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> Reviewed and merged
>> =A0 =A0 =A0 cifs: advertise the right receive buffer size to the ser=
ver
>> =A0 =A0 =A0 cifs: trivial: goto out here is unnecessary
>> =A0 =A0 =A0 cifs: don't start signing too early
>> =A0 =A0 =A0 cifs: fix name parsing in CIFSSMBQAllEAs
>>
>> am currently looking at the oplock refcounting patch, and Pavel's
>> demultiplex simplification series, the on to the others.
>>
>> --
>> Thanks,
>>
>> Steve
>
> Thanks, If you're not going to take this patch that I sent back in
> March, then I'd appreciate an official "NAK", preferably with the
> reasoning, so I can stop carrying it in my tree:
>
> =A0 =A0cifs: remove unneeded variable initialization in cifs_reconnec=
t_tcon
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
