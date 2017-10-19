From: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CIFS backporting for kernel 2.6, SMB2/3 dialect support
Date: Thu, 19 Oct 2017 19:50:22 +1000
Message-ID: <CAN05THSWsUsLPYOF8x0BwX2B7NivaateQZ51pqdP-06qOmkW6A@mail.gmail.com>
References: <DB6PR0301MB237377DF7009AFA00637913B944D0@DB6PR0301MB2373.eurprd03.prod.outlook.com>
 <mpsh8uvtsgf.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Chris Davies <chris.davies-fcHNbCilqsSHXe+LvDLADg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsh8uvtsgf.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Concur with  Aur=C3=A9lien.

2.6.32 is VERY old and there are several core kernel APIs that have
changed significantly between 2.6 and current kernels.
For example the whole iovector API for how buffers are handled changed
dramatically. And there are other dramatic API  changes too.

As a lot of distros do ship "old-ish" (but not as old as 2.6) kernels
but with modern CIFS, it is not impossible but it is far far from
being trivial.
Especially since 2.6.32 is so old that you will have to write a whole
bunch of translation wrappers to accomodate the
kernel API changes that cifs.ko need to interface to.


Unless you are willing to dedicate resources to a big port, and
continued support,
It is possible but will require significant effort and likely
significant cost, both to backport it as well as supporting it.
I would just stick with 2.6.32 and SMB1 for now until you get to the
point where you can upgrade the whole distro/kernel to a more recent
varient.



regards
ronnie sahlberg


On Thu, Oct 19, 2017 at 7:09 PM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrot=
e:
> Hi Chris,
>
> Chris Davies <chris.davies-fcHNbCilqsSHXe+LvDLADg@public.gmane.org> writes:
>> Hi folks, I'm hoping to achieve SMB2.0+ dialect support for CentOS 6 cli=
ents (currently with CIFS 1.68).  Has anyone done a backport of newer CIFS =
versions for use in production? Was it trivial?
>
> According to wikipedia CenOS 6 is based on kernel 2.6.32. This is
> *old*. Adding SMBv2 support required large refactoring efforts and
> kernel APIs are often changing so I expect backporting to be very hard
> unfortunately.
>
> Cheers,
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
