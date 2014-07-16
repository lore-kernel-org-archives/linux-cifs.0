From: Christian Lutz <christian.lutz-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Subject: Re: Question on Active Directory Authentication
Date: Wed, 16 Jul 2014 09:43:26 +0200
Message-ID: <53C62D1E.1050407@muenchen.de>
References: <53B6A3ED.9060805@muenchen.de> <zarafa.53bd23f4.13c0.46a6a8115b51d1f3@zarafa.ed-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Tobias Doerffel <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <zarafa.53bd23f4.13c0.46a6a8115b51d1f3-Re+uX9gtWIdJ209wn1+v+yQaj01YtLkH@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Tobias,

this was the intention of my question because with other security=20
options it didn't work but we were searching for a method to so without=
=20
kerberos. In our deployment I would suggest to use kerberos but it's no=
t=20
easy to deploy a working configuration to 15.000 Linux Clients within=20
days (which is the actual problem).

Thanks for your hints.

Regards
Christian


Am 09.07.2014 13:13, schrieb Tobias Doerffel:
> Hi Christian,
>
> I never used the NTLM security options but I would guess that they wo=
uldn't work that way as they still require usernames and passwords. Krb=
5 is the only security method where you can use an existing credential =
information in form of a Kerberos ticket.
>
> Best regards
>
> Tobias Doerffel
>
>
> --
> Dipl.-Inf. Tobias Doerffel
>
> -----------------------------------------------
> EDC Electronic Design Chemnitz GmbH
> Technologie-Campus 4, 09126 Chemnitz
>
> Gesch=E4ftsf=FChrer: Dr.-Ing. Steffen Heinz
>                   Dipl.-Ing. Andr=E9 Lange
> Tel.:            +49 371 52 45 90
> Fax.:            +49 371 52 45 910
> E-Mail:          info-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org
>
> Sitz der Gesellschaft: Chemnitz
> HRB 23986, Amtsgericht Chemnitz
> USTID: DE258181725
> -----------------------------------------------
>
>
