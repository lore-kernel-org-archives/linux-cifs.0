From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Add missed forcemand mount option
Date: Tue, 27 Mar 2012 14:24:31 -0400
Message-ID: <20120327142431.0ae743ea@tlielax.poochiereds.net>
References: <1332867075-3231-1-git-send-email-piastry@etersoft.ru>
	<20120327130715.39682caa@tlielax.poochiereds.net>
	<CAKywueT3Hoce-HrR14KamF2rhW4rjb-8PodejLEABNdmVZAhfA@mail.gmail.com>
	<CAKywueTvjM4UMsF9WG40cbM6mbbsbLg0j0OG304PdHnBPkehXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueTvjM4UMsF9WG40cbM6mbbsbLg0j0OG304PdHnBPkehXg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 27 Mar 2012 22:20:24 +0400
Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:

> 27 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 21:17 =D0=BF=D0=BE=
=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Pavel Shil=
ovsky
> <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> > 27 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2012=C2=A0=D0=B3. 21:07 =D0=BF=D0=
=BE=D0=BB=D1=8C=D0=B7=D0=BE=D0=B2=D0=B0=D1=82=D0=B5=D0=BB=D1=8C Jeff La=
yton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB:
> >> On Tue, 27 Mar 2012 20:51:15 +0400
> >> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >>
> >>> The 'forcemand' form of 'forcemandatorylock' mount option was mis=
sed
> >>> when the code moved to use the standard token parser. Return it b=
ack.
> >>>
> >>> Also fix a comment style in the parser.
> >>>
> >>> Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
> >>> ---
> >>> =C2=A0fs/cifs/connect.c | =C2=A0 =C2=A07 +++++--
> >>> =C2=A01 files changed, 5 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> >>> index 26327ea..7e4775c 100644
> >>> --- a/fs/cifs/connect.c
> >>> +++ b/fs/cifs/connect.c
> >>> @@ -140,6 +140,7 @@ static const match_table_t cifs_mount_option_=
tokens =3D {
> >>> =C2=A0 =C2=A0 =C2=A0 { Opt_nobrl, "nobrl" },
> >>> =C2=A0 =C2=A0 =C2=A0 { Opt_nobrl, "nolock" },
> >>> =C2=A0 =C2=A0 =C2=A0 { Opt_forcemandatorylock, "forcemandatoryloc=
k" },
> >>> + =C2=A0 =C2=A0 { Opt_forcemandatorylock, "forcemand" },
> >>
> >> This looks fine.
> >>
> >>> =C2=A0 =C2=A0 =C2=A0 { Opt_setuids, "setuids" },
> >>> =C2=A0 =C2=A0 =C2=A0 { Opt_nosetuids, "nosetuids" },
> >>> =C2=A0 =C2=A0 =C2=A0 { Opt_dynperm, "dynperm" },
> >>> @@ -1397,9 +1398,11 @@ cifs_parse_mount_options(const char *mount=
data, const char *devname,
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case Opt_nobrl:
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 vol->nobrl =3D =C2=A01;
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /* turn off mandatory locking in mode
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 /*
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* turn off mandatory locking in mode
> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0* if remote locking is turned off since the
> >>> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* local vfs will do advisory */
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0* local vfs will do advisory
> >>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0*/
> >>
> >> This doesn't look like it's related but just a comment cleanup?
> >
> > Yes - just a cleanup!
> >
>=20
> seems like I needed to exclude this out of the patch and respin but i=
t
> has been already merged into master.
>=20

That's fine -- not a big deal...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
