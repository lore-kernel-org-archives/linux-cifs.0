From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to iocharset
 (try #2)
Date: Sat, 29 Oct 2011 22:15:21 -0500
Message-ID: <CAH2r5mscbS44h5eg6DWZLUR-bTb-0W4Jhx+NabOP-5DeRBxNpg@mail.gmail.com>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319134919-4300-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Shirish,
Would you fix the sparse warning from your patch?
Remember to run sparse with make ie add
                      C=3D1  CF=3D"-D__CHECK_ENDIAN__"
to your make (see below)

  CHECK   fs/cifs/smbencrypt.c
fs/cifs/smbencrypt.c:216:37: warning: incorrect type in argument 1
(different base types)
fs/cifs/smbencrypt.c:216:37:    expected restricted __le16 [usertype] *=
<noident>
fs/cifs/smbencrypt.c:216:37:    got unsigned short *<noident>


On Thu, Oct 20, 2011 at 1:21 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Re-posting a patch originally posted by Oskar Liljeblad after
> rebasing on 3.2.
>
>
> Modify cifs to assume that the supplied password is encoded according
> to iocharset. =A0Before this patch passwords would be treated as
> raw 8-bit data, which made authentication with Unicode passwords impo=
ssible
> (at least passwords with characters > 0xFF).
>
> The previous code would as a side effect accept passwords encoded wit=
h
> ISO 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =A0Softwar=
e which
> relies on that will no longer support password chars > 0x7F unless it=
 also
> uses iocharset=3Diso8859-1. =A0(mount.cifs does not care about the en=
coding so
> it will work as expected.)
>
> Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Tested-by: A <nimbus1_03087-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>

--=20
Thanks,

Steve
