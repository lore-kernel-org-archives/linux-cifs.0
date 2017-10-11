From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does linux smb2 client supports DFS capability?
Date: Wed, 11 Oct 2017 09:25:36 -0500
Message-ID: <CAH2r5muEvnMZT9L-hvO-7o=fsaRU28KZEJA+3dgzmNyn4nVH5Q@mail.gmail.com>
References: <FBFAFA79-EEBE-4F0F-B898-19D2A8096E62@nutanix.com>
 <mpsk2a4l69q.fsf@suse.com> <B4C283AF-91A2-435A-85A6-DAE11A90DB6D@nutanix.com> <mpszi8x9a8i.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Hemanth Thummala <hemanth.thummala-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpszi8x9a8i.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If you are checking if the SMB3 DFS enablement has been added to your
kernel (if your kernel is older than version 4.11), you could look to
see if the equivalent of this patch (it is part of a small series of
DFS related patches, but would be one of the more visible ones in the
series)

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/f=
s/cifs?id=3D9d49640a21bffd730a6ebf2a0032e022f7caf84a


On Wed, Oct 11, 2017 at 6:47 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrot=
e:
> Hi,
>
> Hemanth Thummala <hemanth.thummala-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org> writes:
>> If so, Can you please let me know (or point me a link) the version of ci=
fs-utils in which support is available.
>> I have tested with cifs-util-6.2 version. This doesn=E2=80=99t have the =
DFS support.
>
> cifs-util only contains the source code of the the mount.cifs program,
> which doesn't do much. The SMB client code lives in the cifs kernel
> module. To use DFS with SMB2 you need to use linux kernel v4.11 or
> newer.
>
> Cheers,
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)



--=20
Thanks,

Steve
