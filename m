From: "Chen, Xianwen" <xianwen.chen-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: uid specified user can't access mounted Window share
Date: Tue, 8 Mar 2011 14:18:47 +0100
Message-ID: <AANLkTi=uPScCLyR2MbO0oTBSxMa2UXy7Kuf1gdcUu2bB@mail.gmail.com>
References: <AANLkTikh8+k3Yt5La0uPMnENGC-DXYqAAv5NCVau-803@mail.gmail.com>
	<AANLkTimYqnV8WOJ5EgfHsJs4C-DEU1x=rOy25iKO-J80@mail.gmail.com>
	<AANLkTikcLvoxuZo0MLAfkcrQt==eyywWxb-+98WRNhum@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikcLvoxuZo0MLAfkcrQt==eyywWxb-+98WRNhum-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Thanks a lot Steve! The problem is solved by adding
    file_mode=3D0777,dir_mode=3D0777
parameter. :)

Xianwen


On Mon, Mar 7, 2011 at 10:25 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
>
> Also, presumably you meant to separate the server export (UNC name)
> and local mount target (local directory path)
>
> mount.cifs //server/share =C2=A0 /media/h/ -o =C2=A0etc
>
> not
>
> mount.cifs //server/share/media/h/ -o =C2=A0etc.
>
> On Mon, Mar 7, 2011 at 3:22 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wro=
te:
> > If writes to that directory still fail when maximal permissions are
> > granted to local acces:
> >
> > mount.cifs //server/share/media/h/ -o
> > user=3Duser1,domain=3Ddmn,uid=3Duser1,file_mode=3D0777,dir_mode=3D0=
777
> >
> > or even disable permission checking on the client:
> >
> > mount.cifs //server/share/media/h/ -o user=3Duser1,domain=3Ddmn,uid=
=3Duser1,noperm
> >
> >
> > If those fail, then the issue is the permissions (access control) s=
et
> > on the server directory for that user, not client permissions. =C2=A0=
Be
> > careful about not leaving spaces between the comma separated items =
in
> > the mount option list (after -o separate parameters with commas).
> >
> > On Mon, Mar 7, 2011 at 3:02 AM, Chen, Xianwen <xianwen.chen@gmail.c=
om> wrote:
> >> Hi fellow Linuxers,
> >>
> >> I need some hints on granting access to a non-root user for mounte=
d
> >> Windows share.
> >>
> >> The share is mounted via
> >> =C2=A0mount.cifs //server/share/media/h/ -o user=3Duser1 domain=3D=
dmn uid=3Duser1
> >>
> >> However, user1 can't write to /media/h.
> >>
> >> Any comment will be appreciated!
> >>
> >> Xianwen
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >>
> >
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >
>
>
>
> --
> Thanks,
>
> Steve
