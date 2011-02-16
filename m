From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken lanman (lm) auth code
Date: Wed, 16 Feb 2011 10:34:03 -0500
Message-ID: <20110216103403.66aaacf6@tlielax.poochiereds.net>
References: <1297811443-4848-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110216075346.2b69c431@tlielax.poochiereds.net>
	<AANLkTinVM2j9kVjreWy+Tk6VFONTo=zEj=s1k-07YViF@mail.gmail.com>
	<20110216100129.5f05c7e3@tlielax.poochiereds.net>
	<AANLkTinFs9zFOPV=4v8zTujxzyeS_y1o9W7in4or7L76@mail.gmail.com>
	<20110216102143.362599dd@tlielax.poochiereds.net>
	<AANLkTikXabGo1kVeUZS430A0iawk5z0arkc-SrCW-hiR@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikXabGo1kVeUZS430A0iawk5z0arkc-SrCW-hiR-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Feb 2011 09:27:28 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Feb 16, 2011 at 9:21 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Wed, 16 Feb 2011 09:06:08 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Wed, Feb 16, 2011 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >> > On Wed, 16 Feb 2011 08:46:03 -0600
> >> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> On Wed, Feb 16, 2011 at 6:53 AM, Jeff Layton <jlayton-H+wXaHxf7aJhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >> >> > On Tue, 15 Feb 2011 17:10:43 -0600
> >> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> >> >
> >> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >> >>
> >> >> >>
> >> >> >> Fix lanman (lm) authentication code.
> >> >> >>
> >> >> >> Change lm response length back to 24 from 16.
> >> >> >> Parse lanmani mount option.
> >> >> >> Add code to add odd parity bit to each of the eight bytes of=
 a DES key.
> >> >> >>
> >> >> >>
> >> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar@gmail.c=
om>
> >> >> >> ---
> >> >> >> =A0fs/cifs/cifsglob.h | =A0 =A03 ++-
> >> >> >> =A0fs/cifs/connect.c =A0| =A0 =A03 +++
> >> >> >> =A0fs/cifs/sess.c =A0 =A0 | =A0 =A08 ++++----
> >> >> >> =A0fs/cifs/smbdes.c =A0 | =A0 19 ++++++++++++++++++-
> >> >> >> =A04 files changed, 27 insertions(+), 6 deletions(-)
> >> >> >>
> >> >> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> >> >> index 17afb0f..0b5c950 100644
> >> >> >> --- a/fs/cifs/cifsglob.h
> >> >> >> +++ b/fs/cifs/cifsglob.h
> >> >> >> @@ -710,7 +710,8 @@ require use of the stronger protocol */
> >> >> >> =A0#define =A0 CIFSSEC_MUST_SEAL =A00x40040 /* not supported=
 yet */
> >> >> >> =A0#define =A0 CIFSSEC_MUST_NTLMSSP =A0 =A0 =A0 0x80080 /* r=
aw ntlmssp with ntlmv2 */
> >> >> >>
> >> >> >> -#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTL=
M | CIFSSEC_MAY_NTLMV2)
> >> >> >> +#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_S=
IGN | \
> >> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSEC_MAY_NTLM |=
 CIFSSEC_MAY_NTLMV2)
> >> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
> >> >> > =A0 =A0 =A0 =A0Won't this change enable lanman auth by defaul=
t? Is that
> >> >> > =A0 =A0 =A0 =A0intended?
> >> >>
> >> >> I think it depends on what server sends in negprot response, th=
e
> >> >> minimun dialect it supports.
> >> >> If the dialect is greater than Lanman2.1, the default auth mech=
 for
> >> >> cifs client is NTLM (ntlmv1)
> >> >> if the dialect is less than or upto Lanman2.1, default auth mec=
h for
> >> >> cifs client is LANMAN (lm).
> >> >>
> >> >
> >> > Historically we've required that the admin
> >> > set /proc/fs/cifs/SecurityFlags to allow LANMAN auth before the =
client
> >> > will allow it to be used. I'm not opposed to changing that, but =
the
> >> > description doesn't even mention anything about that.
> >> >
> >> > I think this ought to be a separate patch with a clearly describ=
ed
> >> > reason, and probably doesn't belong in 2.6.38. It doesn't seem l=
ike
> >> > it's necessary to fix this bug.
> >> >
> >> > --
> >> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >> >
> >>
> >> I think that is still the case. =A0If we do not have the code, =A0=
we will get error
> >> =A0CIFS VFS: mount failed weak security disabled in /proc/fs/cifs/=
SecurityFlags
> >> and auth will fail even if admin did necessary to allow LANMAN.
> >
> > For the record, I'm of the opinion that this secFlags stuff is far =
too
> > convoluted for anyone's good. It's horribly confusing. I don't thin=
k
> > what you're saying is the case however:
> >
> > ...global_secflags is initialized to CIFSSEC_DEF:
> >
> > =A0 =A0 =A0 =A0unsigned int global_secflags =3D CIFSSEC_DEF;
> >
> > ...then, if ses->overrideSecFlg is not set (which is the case if no
> > sec=3D option is set):
> >
> > =A0 =A0 =A0 =A0/* if any of auth flags (ie not sign or seal) are ov=
erriden use them */
> > =A0 =A0 =A0 =A0if (ses->overrideSecFlg & (~(CIFSSEC_MUST_SIGN | CIF=
SSEC_MUST_SEAL)))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0secFlags =3D ses->overrideSecFlg; =A0=
/* BB FIXME fix sign flags? */
> > =A0 =A0 =A0 =A0else /* if override flags set only sign/seal OR them=
 with global auth */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0secFlags =3D global_secflags | ses->=
overrideSecFlg;
> >
> >
> > ...now, secFlags ends up being global_secflags plus some optional
> > sign/seal flags. Then later:
> >
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if ((secFlags & CIFSSEC_MAY_LANMAN) =
||
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(secFlags & CIFSSEC_=
MAY_PLNTXT))
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->secType =3D =
LANMAN;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0else {
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "mount fai=
led weak security disabled"
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 " in /proc/fs/cifs/SecurityFlags");
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D -EOPNOTSUPP;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto neg_err_exit;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> >
> > ...so, because CIFSSEC_MAY_LANMAN is now set by default, we'll not =
fall
> > into the else condition above and the mount will work by default wh=
en
> > it would have failed before, right? So the default behavior has
> > changed...or am I missing something?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> Jeff, I am saying I will undo the change in cifsglob.h that is
> submitted in this patch.
> With definition of CIFSSEC_DEF unchagned, all I will be fixing is
> allowing lanmani
> mount option and proper lm authentication (if admin allow lm auth in
> /proc/fs/cifs/SecurityFlags.
> So I would not be changing default behaviour as it exists right now.

Sorry about that -- our earlier replies crossed paths. I think that
sounds like the best thing to do.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
