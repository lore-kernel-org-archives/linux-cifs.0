From: VALETTE Eric RD-MAPS-REN <eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org>
Subject: Re: Linux 3.2.17 and netapp 8.1
Date: Mon, 14 May 2012 18:06:09 +0200
Message-ID: <4FB12D71.3040403@orange.com>
References: <4FB0FDDA.5080604@orange.com> <20120514120159.2f6de2fa@corrin.poochiereds.net>
Reply-To: eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120514120159.2f6de2fa-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 05/14/2012 06:01 PM, Jeff Layton wrote:
> On Mon, 14 May 2012 14:43:06 +0200
> VALETTE Eric RD-MAPS-REN<eric2.valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org>  wrote:
>
>> Hi,
>>
>> Middle of next week, a netapp filer was replaced by a new netapp FAS
>> 3270 with 8.1 firmware. While previously I had no problem accessing,=
 all
>> the share, now, my log is full of CIFS errors preventing me to acces=
s my
>> own content:
>>
>> Mount options:
>>
>> domain=3DZZZZ,credentials=3D/xxxx/xxxx/.sambaShareId,uid=3Dyyyyy,gid=
=3Dzzz,iocharset=3Dutf8,noserverino
>> 0 0
>>
>> Is there any known problem with this netapp firmware?
>>
>> Note that I have other shares on different using different netapp
>> machine with older firmware that work like a charm.
>>
>> -- eric
>>
>>
>>          ___________________________________________________________=
_____
>> [  315.788485] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D=
34
>> [  315.788493] Bad SMB: : dump of 48 bytes of data at 0xffff88012304=
5c00
>> [  315.788501]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
>> \xffffffff S M B 2 . . . . . . .
>> [  315.788508]  00000000 00000000 00000000 19db0040 . . . . . . . . =
=2E .
>> . . @ . \xffffffdb .
>> [  315.788518]  00220800 c400020a 02000000 00003800 . . " . . . .
>> \xffffffc4 . . . . . 8 . .
>> [  315.791476] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D=
35
>> [  315.791481] Bad SMB: : dump of 48 bytes of data at 0xffff88012304=
5dc0
>> [  315.791489]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
>> \xffffffff S M B 2 . . . . . . .
>> [  315.791495]  00000000 00000000 00000000 19db0040 . . . . . . . . =
=2E .
>> . . @ . \xffffffdb .
>> [  315.791502]  00230800 c400020a 02000000 00003800 . . # . . . .
>> \xffffffc4 . . . . . 8 . .
>> [  315.791577] CIFS VFS: Unexpected lookup error -5
>> [  315.794489] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D=
36
>> [  315.794495] Bad SMB: : dump of 48 bytes of data at 0xffff880126a8=
fb80
>> [  315.794503]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
>> \xffffffff S M B 2 . . . . . . .
>> [  315.794510]  00000000 00000000 00000000 19db0040 . . . . . . . . =
=2E .
>> . . @ . \xffffffdb .
>> [  315.794516]  00240800 c400020a 02000000 00003800 . . $ . . . .
>> \xffffffc4 . . . . . 8 . .
>> [  315.794542] CIFS VFS: Unexpected lookup error -5
>> [  315.797494] CIFS VFS: RFC1001 size 248 smaller than SMB for mid=3D=
37
>> [  315.797500] Bad SMB: : dump of 48 bytes of data at 0xffff8801115c=
5880
>> [  315.797507]  f8000000 424d53ff 00000032 80018800 . . . \xfffffff8
>> \xffffffff S M B 2 . . . . . . .
>> [  315.797514]  00000000 00000000 00000000 19db0040 . . . . . . . . =
=2E .
>> . . @ . \xffffffdb .
>> [  315.797521]  00250800 c400020a 02000000 00003800 . . % . . . .
>> \xffffffc4 . . . . . 8 . .
>> [  315.797542] CIFS VFS: Unexpected lookup error -5
>>
> I'm not sure, but just to confirm -- that's almost certainly an OnTap
> bug. Those messages mean that the filer is sending back SMB responses
> that have lengths in them that go beyond the end of the frame.
>
> It's almost certainly a similar problem to that reported here:
>
>      https://bugzilla.samba.org/show_bug.cgi?id=3D8914
>
> In the past, netapp has not shown much interest in interoperating wit=
h
> clients other than windows. Perhaps though if enough paying customers
> complain they'd be willing to fix it.
>
> I'm also not opposed to sensible workarounds in the client for these
> sorts of bugs, as long as they aren't too invasive or risky. At the e=
nd
> of the day though, these are server side bugs and the real fix for th=
is
> problem would have to be done there.
>
Just too follow my own post: Ontrack 8.1 implements SMB 2.1 and in my=20
traces I see "S M B 2 ". I'm just curious if we do not try to parse=20
SMB2.1 protocol via CIFS and if ontrack has been correctly configured.

Anyone capable to test with 8.1 on the list?

--=20
Eric Valette
=46rance Telecom
Recherche&  Developpement
Middleware et Plateformes Avanc=C3=A9es
Architecte Livebox et Set Top Box
t=C3=A9l : (+33) 2 99 12 45 71
m=C3=A9l :<mailto:Eric2.Valette-C0LM0jrOve7QT0dZR+AlfA@public.gmane.org>
