From: Christian Garling <christian.garling-JDaHaePr6SMW6PBduJaimg@public.gmane.org>
Subject: Re: cifs.ko + smb 3.0 + DFS fails (though direct mount succeeds)
Date: Fri, 16 Jun 2017 17:42:52 +0200
Message-ID: <CDE2E2CE-EE67-44AE-A0C8-D3AFF6EAAA01@cg-networks.de>
References: <CAJUwKM3-U2yRHB5O-R19wmzj1-yrO3sU_b8+xVCFaFwsZRWtTA@mail.gmail.com> <CAH2r5mvn_Z5B=kYza1gAr3SkPX+kwKmXBEXcTBL327zcW8FP-g@mail.gmail.com> <CAJUwKM25Kd-BHgPNXHkTtvYvK1Ad5uaLkooG6i4H+kawDL1ACg@mail.gmail.com> <mpsmv98ti7d.fsf@aaptelpc.suse.de>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?utf-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsmv98ti7d.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Aurelien,

I am running kernel 4.11.5 on an Ubuntu 16.04.2 system with cifs-utils 6.4 i=
n a test environment, connecting to a DFS share on a Windows Server 2008 R2 w=
ith SMBv2 / 2.1.

Wireshark sniffing on the Ubuntu system shows the request for the referral, a=
lso the response with the correct hostname of the fileserver holding the sha=
re. After that nothing happens and cifs-utils throws "Invalid argument". I d=
ont know what argument should be wrong. I also tried cifs-utils 6.7 from the=
 git repo with no luck.

I try to get it working for two weeks now, so any help is welcome :-)

A connection to the DFS share from a windows client instead works well.

Thanks in advance.

Regards, Christian=20



Von meinem iPhone gesendet

> Am 16.06.2017 um 11:06 schrieb Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>:
>=20
> Hi Robin,
>=20
> Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>=20
>> Thanks, Steve.
>>=20
>> Given WannaCry (and its derivatives), many shops are disabling SMBv1
>> entirely (not necessarily a bad idea). Any idea as to when the
>> aforementioned fixes might be pushed downstream? I've tested Ubuntu
>> 17.04 with the same results (DFS fails with SMB > v1).
>>=20
>> Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
>> Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
>> CIFS VFS: cifs_mount failed w/return code =3D -38
>>=20
>> # uname -r
>> 4.10.0-22-generic
>=20
> Unless canonical has backported my changes you need at least linux 4.11.
>=20
> Cheers,
>=20
> --=20
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=C3=
=BCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
