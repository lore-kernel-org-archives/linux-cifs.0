From: support@remsnet.de
Subject: Aw: Re: The patents and license issue from microsoft regarding SMB
 implementation(GPL)
Date: Wed, 28 Jan 2015 20:36:04 +0100
Message-ID: <trinity-63673316-8fb5-49fa-88fb-f49ec5171631-1422473764690@3capp-webde-bs25>
References: <000801d03aa1$92475b40$b6d611c0$@samsung.com>,
 <1422454054.32747.35.camel@samba.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary=abmobg-7186cbcd-a1b7-4a9e-9b30-2a0cf3678bf1
Cc: Namjae Jeon <namjae.jeon@samsung.com>, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
To: Simo <simo@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <1422454054.32747.35.camel@samba.org>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

--abmobg-7186cbcd-a1b7-4a9e-9b30-2a0cf3678bf1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> Gesendet: Mittwoch, 28. Januar 2015 um 15:07 Uhr
> Von: Simo <simo@samba.org>
> An: "Namjae Jeon" <namjae.jeon@samsung.com>
> Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
> Betreff: Re: The patents and license issue from microsoft regarding SMB =
implementation(GPL)
>
> On Wed, 2015-01-28 at 11:24 +0900, Namjae Jeon wrote:
> > Hi Folks,
> >=20
> > I am planning to develop smb server for Linux kernel.
> > Before starting on implemntation, want to clear patent related issue
> > to know if it is legal to develop or not.
>=20

legal : maybe - without sign patent licenses agreements : allmost not.

> I have no idea about legal implications, and you'll get no answers here
> for sure. Ask a lawyer. We can probably suggest a lawyer to consult with
> if your lawyer needs help.
>=20

- M$ owns most of the smb Protokoll patents as they developed them..

- SUN/oracle and its today owner have an Comercial KERNEL based smb server=
 implementaion=20
with solaris 10 and own a LOT of patents on that.

- humingbird , novel and other Imprementations owns some smb suff as well.=
.


> That said, an in kernel smb server is not really a bright idea, I would
> think hard before going there, Solaris tried, went nowhere quickly.
>=20
> Even if you get the SMB part of the protocols in kernel, you'll need so
> many userspace helpers it is not even funny.
> Better time would be spent analyzing what features in the kernel would
> make Samba faster and use Samba.
>=20
> Simo.
>=20
> > When referring to the SAMBA site
> > (https://www.samba.org/samba/PFIF/PFIF_history.html), I can see that t=
here are
> > a lot of legal obligations from the past. Like SAMBA, I also am just
> > referring the Microsoft SPEC, while the implementation is all together=
 different=20
> > due to obvious reasons (in-kernel implementation).


> > As there is already an in kernel CIFS client, maybe CIFS developers ha=
d the same
> > concern when developing CIFS client for Linux kernel ?

CIFS is m$ in clear words SMB protocoll based.
Therefore fall under the M$ license rules .

the Cifs client are an orign reverse engeneered software...

> > But I'm not sure about the actual violation part.
> > Maybe, I am wondering two problem.
> >  1. When referring the Microsoft patent list, CIFS(SMB) and SMB2.0,
> >     Microsoft have raised patent applications but this overall seems t=
o be
> >     about the implementation part. So, any implementation done on linu=
x
> >     with SMB specifications in mind and not following the approach of =
Microsoft
> >     should not infringe any patents ?

ask an very excelent patent laywer not samba-list=20
and get probably in Touch with samsung=C2=B4s laywers :)

> >  2. While Samba have shifted to the GPLv3 with their newer version, bu=
t
> >     I intend to make GPLv2.0 SMB server in kernel.
> >     So implementation for this should not cause any license issues ?
> >=20
> > Can you please help us in clearing the doubts ?
> >=20
> > Thanks.
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" =
in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20
> --=20
> Simo Sorce
>=20
>=20

regards
--abmobg-7186cbcd-a1b7-4a9e-9b30-2a0cf3678bf1
Content-Type: text/x-vcard; charset=utf-8
Content-Disposition: attachment; filename=addressbook.vcf

BEGIN:VCARD
VERSION:2.1
N:Venzke;Horst;;MR;;
FN:Horst  Venzke
ORG:Remsnet Consulting & Internet Services LTD
TITLE:IT Freelancer
TEL;PREF;WORK;VOICE:+49211310548830
TEL;HOME;VOICE:+49211310548830
TEL;PREF;HOME;CELL:+491578-4593592
TEL;WORK;FAX:+49211310548830
TEL;HOME;FAX:+49211310548839
ADR;HOME;ENCODING=QUOTED-PRINTABLE:;;Rather Str. 14;D=C3=BCsseldorf;;40476;Germany
LABEL;HOME;ENCODING=QUOTED-PRINTABLE:Rather Str. 14=0D=0A40476 D=C3=BCsseldorf=0D=0AGermany
ADR;WORK;ENCODING=QUOTED-PRINTABLE:;;Rather Str 14;D=C3=BCsseldorf;;40476;Germany
LABEL;WORK;ENCODING=QUOTED-PRINTABLE:Rather Str 14=0D=0A40476 D=C3=BCsseldorf=0D=0AGermany
BDAY:19660131
EMAIL;HOME;INTERNET:rnsklaus@web.de
EMAIL;WORK;INTERNET:info@remsnet.de
EMAIL;WORK;INTERNET:Horst.Venzke@remsnet.de
URL;PREF;HOME:www.remsnet.de
URL;WORK:www.remsnet.ws
URL;WORK:www.remsnet.org
URL;WORK:www.remsnet.tv
URL;WORK:www.remsnet.de
URL;WORK:www.remsnet.info
END:VCARD

--abmobg-7186cbcd-a1b7-4a9e-9b30-2a0cf3678bf1--
