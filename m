From: Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs.ko + smb 3.0 + DFS fails (though direct mount succeeds)
Date: Tue, 20 Jun 2017 09:14:27 -0500
Message-ID: <CAJUwKM24-XrP3rMRTtv_=Fi3G5V3Fm+XsiKpdhS_PppFhr822Q@mail.gmail.com>
References: <CAJUwKM3-U2yRHB5O-R19wmzj1-yrO3sU_b8+xVCFaFwsZRWtTA@mail.gmail.com>
 <CAH2r5mvn_Z5B=kYza1gAr3SkPX+kwKmXBEXcTBL327zcW8FP-g@mail.gmail.com>
 <CAJUwKM25Kd-BHgPNXHkTtvYvK1Ad5uaLkooG6i4H+kawDL1ACg@mail.gmail.com> <mpsmv98ti7d.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsmv98ti7d.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks, Aur=C3=A9lien.

I can confirm that DFS + smb 3.0 works as expected on Ubuntu 17.04 +
ppa:canonical-kernel-team/ppa

# uname -rsov
Linux 4.11.0-7-generic #12-Ubuntu SMP Mon Jun 19 17:35:19 UTC 2017 GNU/Linu=
x


Hopefully these changes will be incorporated/backported into mainline
RedHat variants soon....

On Fri, Jun 16, 2017 at 4:06 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrot=
e:
> Hi Robin,
>
> Robin Blanchard <robin.blanchard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
>
>> Thanks, Steve.
>>
>> Given WannaCry (and its derivatives), many shops are disabling SMBv1
>> entirely (not necessarily a bad idea). Any idea as to when the
>> aforementioned fixes might be pushed downstream? I've tested Ubuntu
>> 17.04 with the same results (DFS fails with SMB > v1).
>>
>> Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
>> Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
>> CIFS VFS: cifs_mount failed w/return code =3D -38
>>
>> # uname -r
>> 4.10.0-22-generic
>
> Unless canonical has backported my changes you need at least linux 4.11.
>
> Cheers,
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)
