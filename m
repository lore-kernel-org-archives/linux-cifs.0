From: Christian Lutz <christian.lutz-EnyPcy3oyxIb1SvskN2V4Q@public.gmane.org>
Subject: Re: Question on Active Directory Authentication
Date: Wed, 09 Jul 2014 13:05:59 +0200
Message-ID: <53BD2217.1030304@muenchen.de>
References: <53B6A3ED.9060805@muenchen.de> <zarafa.53bbd04a.78cf.1d5ae9d4134672c1@zarafa.ed-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Tobias Doerffel <tobias.doerffel-2LT3hlbiLj/X2ID+q72mRQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <zarafa.53bbd04a.78cf.1d5ae9d4134672c1-Re+uX9gtWIdJ209wn1+v+yQaj01YtLkH@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Tobias,

thanks for your answer.

Is this only possible with krb5 security or does any of the ntlm*=20
security options support this method?

Regards
Christian


Am 08.07.2014 13:04, schrieb Tobias Doerffel:
> Hi Christian,
>
> you could indeed use krb5 authentication (and possibly in combination=
 with the multiuser option) so you can build whatever mechanism you lik=
e for getting the required kerberos ticket for the user.  Once you have=
 the ticket you should be able to access the shares independent of the =
account name specifications. You have to configure your AD server such =
that it provides credentials for the UPN. Advantage: you don't have to =
deal with possible limitations in the CIFS implementation on the client=
 side.
>
> Best regards
>
> Tobias Doerffel
>
>
> -----Urspr=FCngliche Nachricht-----
>
> Hi everybody,
>
> just one simple question regarding the authentication of users in the=
 mount options: Is it possible to authenticate a user with his userPrin=
cipalName attribute and a password or are there any more dependencies t=
o get this to work (i. e. krb5 or other security options)?
>
> Example: mount -t cifs //server/share /mnt -o username=3Dmy.upn.prefi=
x@domain.name.tld,password=3DPASSWORD
>
> The only working solution was with the default sAMAccountName Attribu=
te.
>
> Background:
> We are building a new fileservice for Windows and Linux Clients. The =
users are stored in Active Directory. The username (sAMAccountName) is =
a random string created by the Server itself. The only login attribute =
the user knows is his UPN (which is also the mailaddress in our case).
>
>
> Thanks in advance
> Christian
>
> ---------------------------------
>
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
