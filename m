From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/19] cifs: remove rfc1002 header from all smb2 requests
Date: Thu, 16 Nov 2017 17:16:31 -0800
Message-ID: <CAKywueR5Y8G2otmABHiEPm4vNFT0y-9sBx1YWT8zNqL4+vVwNA@mail.gmail.com>
References: <20171102070312.18903-1-lsahlber@redhat.com> <87r2t8j0nc.fsf@suse.com>
 <87o9ocixio.fsf@suse.com> <CAN05THRX2dDBVA7+aCYnatYpm0EEH=iPdcwE40BSROOPmCPkcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAN05THRX2dDBVA7+aCYnatYpm0EEH=iPdcwE40BSROOPmCPkcg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2017-11-08 16:48 GMT-08:00 ronnie sahlberg <ronniesahlberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Thanks.
>
> It is the __u8 Buffer[1] in the structure that is causing it.
> I will resend after I fix it and audit all other Buffer[1] in the
> request structures.
>
> Any particular reason we don't use  __u8 Buffer[0] instead?
>
>
>
> On Thu, Nov 9, 2017 at 1:46 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wro=
te:
>> I've looked at a network trace: after the patches when doing a setinfo
>> on the same file, the netbios length is 1 byte bigger and thus probably
>> wrong (server replies with a OBJECT_NAME_COLLISION error).
>>
>> --
>> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
>> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
>> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG =
N=C3=BCrnberg)
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

It is because a buffer of size 1 is included in StructureSize field of
PDUs, so we need to send at least 1 byte. Having it in the structure
preventing us to allocate extra unused 1 byte e.g. for a READ request.
We can probably clean it as well.

--
Best regards,
Pavel Shilovsky
