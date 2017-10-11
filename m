From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Does linux smb2 client supports DFS capability?
Date: Wed, 11 Oct 2017 09:42:12 -0700
Message-ID: <CACyXjPzwUx4T7DnvtX55PrtAE9Tj1iPryZNhfStDWkGW3JrDDg@mail.gmail.com>
References: <FBFAFA79-EEBE-4F0F-B898-19D2A8096E62@nutanix.com>
 <mpsk2a4l69q.fsf@suse.com> <B4C283AF-91A2-435A-85A6-DAE11A90DB6D@nutanix.com>
 <mpszi8x9a8i.fsf@aaptelpc.suse.de> <CAH2r5muEvnMZT9L-hvO-7o=fsaRU28KZEJA+3dgzmNyn4nVH5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Hemanth Thummala <hemanth.thummala-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5muEvnMZT9L-hvO-7o=fsaRU28KZEJA+3dgzmNyn4nVH5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 11, 2017 at 7:25 AM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> If you are checking if the SMB3 DFS enablement has been added to your
> kernel (if your kernel is older than version 4.11), you could look to
> see if the equivalent of this patch (it is part of a small series of
> DFS related patches, but would be one of the more visible ones in the
> series)
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit=
/fs/cifs?id=3D9d49640a21bffd730a6ebf2a0032e022f7caf84a
>
>
> On Wed, Oct 11, 2017 at 6:47 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wr=
ote:
>> Hi,
>>
>> Hemanth Thummala <hemanth.thummala-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org> writes:
>>> If so, Can you please let me know (or point me a link) the version of c=
ifs-utils in which support is available.
>>> I have tested with cifs-util-6.2 version. This doesn=E2=80=99t have the=
 DFS support.
>>
>> cifs-util only contains the source code of the the mount.cifs program,
>> which doesn't do much. The SMB client code lives in the cifs kernel
>> module. To use DFS with SMB2 you need to use linux kernel v4.11 or
>> newer.
>>
>> Cheers,

I think their real interest is in the CIFS FS getting DFS referrals if
STATUS_PATH_NOT_COVERED is returned on a CREATE.

When I last looked the client could not do that.

--=20
Regards,
Richard Sharpe
(=E4=BD=95=E4=BB=A5=E8=A7=A3=E6=86=82=EF=BC=9F=E5=94=AF=E6=9C=89=E6=9D=9C=
=E5=BA=B7=E3=80=82--=E6=9B=B9=E6=93=8D)
