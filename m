From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: Linux 3.2.17 and netapp 8.1
Date: Mon, 14 May 2012 12:18:24 -0400
Message-ID: <20120514121824.273198a9@corrin.poochiereds.net>
References: <4FB0FDDA.5080604@orange.com>
	<20120514120159.2f6de2fa@corrin.poochiereds.net>
	<4FB12D71.3040403@orange.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FB12D71.3040403-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 14 May 2012 18:06:09 +0200
VALETTE Eric RD-MAPS-REN <eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org> wrote:

> On 05/14/2012 06:01 PM, Jeff Layton wrote:
> > On Mon, 14 May 2012 14:43:06 +0200
> > VALETTE Eric RD-MAPS-REN<eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org>  wrote:
> >
> >> Hi,
> >>
> >> Middle of next week, a netapp filer was replaced by a new netapp FAS
> >> 3270 with 8.1 firmware. While previously I had no problem accessing, all
> >> the share, now, my log is full of CIFS errors preventing me to access my
> >> own content:
> >>
> >> Mount options:
> >>
> >> domain=ZZZZ,credentials=/xxxx/xxxx/.sambaShareId,uid=yyyyy,gid=zzz,iocharset=utf8,noserverino
> >> 0 0
> >>
> >> Is there any known problem with this netapp firmware?
> >>
> >> Note that I have other shares on different using different netapp
> >> machine with older firmware that work like a charm.
> >>
> >> -- eric
> >>
> >>
> >>          ________________________________________________________________
> >> [  315.788485] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=34
> >> [  315.788493] Bad SMB: : dump of 48 bytes of data at 0xffff880123045c00
> >> [  315.788501]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
> >> \xffffffff S M B 2 . . . . . . .
> >> [  315.788508]  00000000 00000000 00000000 19db0040 . . . . . . . . . .
> >> . . @ . \xffffffdb .
> >> [  315.788518]  00220800 c400020a 02000000 00003800 . . " . . . .
> >> \xffffffc4 . . . . . 8 . .
> >> [  315.791476] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=35
> >> [  315.791481] Bad SMB: : dump of 48 bytes of data at 0xffff880123045dc0
> >> [  315.791489]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
> >> \xffffffff S M B 2 . . . . . . .
> >> [  315.791495]  00000000 00000000 00000000 19db0040 . . . . . . . . . .
> >> . . @ . \xffffffdb .
> >> [  315.791502]  00230800 c400020a 02000000 00003800 . . # . . . .
> >> \xffffffc4 . . . . . 8 . .
> >> [  315.791577] CIFS VFS: Unexpected lookup error -5
> >> [  315.794489] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=36
> >> [  315.794495] Bad SMB: : dump of 48 bytes of data at 0xffff880126a8fb80
> >> [  315.794503]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
> >> \xffffffff S M B 2 . . . . . . .
> >> [  315.794510]  00000000 00000000 00000000 19db0040 . . . . . . . . . .
> >> . . @ . \xffffffdb .
> >> [  315.794516]  00240800 c400020a 02000000 00003800 . . $ . . . .
> >> \xffffffc4 . . . . . 8 . .
> >> [  315.794542] CIFS VFS: Unexpected lookup error -5
> >> [  315.797494] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=37
> >> [  315.797500] Bad SMB: : dump of 48 bytes of data at 0xffff8801115c5880
> >> [  315.797507]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
> >> \xffffffff S M B 2 . . . . . . .
> >> [  315.797514]  00000000 00000000 00000000 19db0040 . . . . . . . . . .
> >> . . @ . \xffffffdb .
> >> [  315.797521]  00250800 c400020a 02000000 00003800 . . % . . . .
> >> \xffffffc4 . . . . . 8 . .
> >> [  315.797542] CIFS VFS: Unexpected lookup error -5
> >>
> > I'm not sure, but just to confirm -- that's almost certainly an OnTap
> > bug. Those messages mean that the filer is sending back SMB responses
> > that have lengths in them that go beyond the end of the frame.
> >
> > It's almost certainly a similar problem to that reported here:
> >
> >      https://bugzilla.samba.org/show_bug.cgi?id=8914
> >
> > In the past, netapp has not shown much interest in interoperating with
> > clients other than windows. Perhaps though if enough paying customers
> > complain they'd be willing to fix it.
> >
> > I'm also not opposed to sensible workarounds in the client for these
> > sorts of bugs, as long as they aren't too invasive or risky. At the end
> > of the day though, these are server side bugs and the real fix for this
> > problem would have to be done there.
> >
> Just too follow my own post: Ontrack 8.1 implements SMB 2.1 and in my 
> traces I see "S M B 2 ". I'm just curious if we do not try to parse 
> SMB2.1 protocol via CIFS and if ontrack has been correctly configured.
> 
> Anyone capable to test with 8.1 on the list?
> 

No, it's SMB1. The protocol version header is actually "0xff S M B".
For SMB2, it would be "0xfe S M B".

The '2' there is from the "Command" field that immediately follows the
protocol version. The command is SMB_COM_TRANSACTION2, which is 0x32.
It just happens that the ASCII code for '2' is 0x32.

Cheers,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
