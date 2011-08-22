From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] mount.cifs with "sec=ntlmv2" fails ("mount error(22):
 Invalid argument")
Date: Mon, 22 Aug 2011 14:49:09 -0500
Message-ID: <CADT32eJDccDJYTo+b_CQf_QAfOK-oVbFvBacpHmLamiC-hO=EQ@mail.gmail.com>
References: <4E527F5C.1090205@pre-sense.de>
	<CADT32eKLjbuUjY1=PS9Pqa5zWnHNcCcouzPHmTo3s+QO-9iQ4A@mail.gmail.com>
	<4E528B56.5070301@pre-sense.de>
	<CADT32eKhcCtNhi2Vd0xwnDR2ZrhMGbX2u-DE3Z3r5awwmd4dTw@mail.gmail.com>
	<4E52988A.8080103@pre-sense.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?ISO-8859-1?Q?Till_D=F6rges?= <doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E52988A.8080103-/hMagybUd5GoYr4blSSd5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Aug 22, 2011 at 12:57 PM, Till D=F6rges <doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org> =
wrote:
> On 22.08.2011 19:33, Shirish Pargaonkar wrote:
>
>> smb.conf options look fine. =A0I will have to spend some time on thi=
s.
>> But sec=3Dntlmv2/i works against a Windows server just fine, so some=
thing needs
>> to changed to make it work against Samba server, some bit in flags o=
r
>> flags2 field in cifs/smb header perhaps.
>
> For the sake of completeness. I just updated the Samba server from 3.=
5.4 to 3.6.0,
> but the behavior with sec=3Dntlmv2 (not working) and sec=3Dntlmssp (w=
orking) stays the same.
>
> If there's any information I can provide please let me know.
>
> Regards -- Till
> --
> Dipl.-Inform. Till D=F6rges =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0doerge=
s@pre-sense.de
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Te=
l. +49 - 40 - 244 2407 - 14
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Fa=
x =A0+49 - 40 - 244 2407 - 24
> PRESENSE Technologies GmbH =A0 =A0 =A0 =A0 =A0 =A0Sachsenstr. 5, D-20=
097 HH
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 USt-IdNr.: DE263765024
> Gesch=E4ftsf=FChrer/Managing Directors =A0 =A0 =A0 AG Hamburg, HRB 10=
7844
> Till D=F6rges =A0 =A0 =A0 =A0 =A0 J=FCrgen Sander =A0 =A0 =A0 =A0 =A0=
 =A0 =A0Axel Theilmann
>

sec=3Dntlmv2i works against Windows 2003 server.
Does not work against Windows 7, Windows 2008 server, and Samba.

sec=3Dntlmssp/i which uses ntlmv2, works against all of the above liste=
d
servers.

Looking into it.
