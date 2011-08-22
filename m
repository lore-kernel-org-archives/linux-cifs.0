From: =?UTF-8?B?VGlsbCBEw7ZyZ2Vz?= <doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org>
Subject: Re: [Samba] mount.cifs with "sec=ntlmv2" fails ("mount error(22):
 Invalid argument")
Date: Mon, 22 Aug 2011 19:57:30 +0200
Message-ID: <4E52988A.8080103@pre-sense.de>
References: <4E527F5C.1090205@pre-sense.de> <CADT32eKLjbuUjY1=PS9Pqa5zWnHNcCcouzPHmTo3s+QO-9iQ4A@mail.gmail.com> <4E528B56.5070301@pre-sense.de> <CADT32eKhcCtNhi2Vd0xwnDR2ZrhMGbX2u-DE3Z3r5awwmd4dTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eKhcCtNhi2Vd0xwnDR2ZrhMGbX2u-DE3Z3r5awwmd4dTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 22.08.2011 19:33, Shirish Pargaonkar wrote:

> smb.conf options look fine.  I will have to spend some time on this.
> But sec=3Dntlmv2/i works against a Windows server just fine, so somet=
hing needs
> to changed to make it work against Samba server, some bit in flags or
> flags2 field in cifs/smb header perhaps.

=46or the sake of completeness. I just updated the Samba server from 3.=
5.4 to 3.6.0,
but the behavior with sec=3Dntlmv2 (not working) and sec=3Dntlmssp (wor=
king) stays the same.

If there's any information I can provide please let me know.

Regards -- Till
--=20
Dipl.-Inform. Till D=C3=B6rges                  doerges-/hMagybUd5GoYr4blSSd5g@public.gmane.org
                                  Tel. +49 - 40 - 244 2407 - 14
                                  Fax  +49 - 40 - 244 2407 - 24
PRESENSE Technologies GmbH            Sachsenstr. 5, D-20097 HH
                                         USt-IdNr.: DE263765024
Gesch=C3=A4ftsf=C3=BChrer/Managing Directors       AG Hamburg, HRB 1078=
44
Till D=C3=B6rges           J=C3=BCrgen Sander              Axel Theilma=
nn
