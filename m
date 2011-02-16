From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix broken lanman (lm) auth code
Date: Wed, 16 Feb 2011 10:21:43 -0500
Message-ID: <20110216102143.362599dd@tlielax.poochiereds.net>
References: <1297811443-4848-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110216075346.2b69c431@tlielax.poochiereds.net>
	<AANLkTinVM2j9kVjreWy+Tk6VFONTo=zEj=s1k-07YViF@mail.gmail.com>
	<20110216100129.5f05c7e3@tlielax.poochiereds.net>
	<AANLkTinFs9zFOPV=4v8zTujxzyeS_y1o9W7in4or7L76@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinFs9zFOPV=4v8zTujxzyeS_y1o9W7in4or7L76-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 Feb 2011 09:06:08 -0600
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Feb 16, 2011 at 9:01 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Wed, 16 Feb 2011 08:46:03 -0600
> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Wed, Feb 16, 2011 at 6:53 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >> > On Tue, 15 Feb 2011 17:10:43 -0600
> >> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >> >
> >> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >>
> >> >>
> >> >> Fix lanman (lm) authentication code.
> >> >>
> >> >> Change lm response length back to 24 from 16.
> >> >> Parse lanmani mount option.
> >> >> Add code to add odd parity bit to each of the eight bytes of a =
DES key.
> >> >>
> >> >>
> >> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >> ---
> >> >> =A0fs/cifs/cifsglob.h | =A0 =A03 ++-
> >> >> =A0fs/cifs/connect.c =A0| =A0 =A03 +++
> >> >> =A0fs/cifs/sess.c =A0 =A0 | =A0 =A08 ++++----
> >> >> =A0fs/cifs/smbdes.c =A0 | =A0 19 ++++++++++++++++++-
> >> >> =A04 files changed, 27 insertions(+), 6 deletions(-)
> >> >>
> >> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> >> index 17afb0f..0b5c950 100644
> >> >> --- a/fs/cifs/cifsglob.h
> >> >> +++ b/fs/cifs/cifsglob.h
> >> >> @@ -710,7 +710,8 @@ require use of the stronger protocol */
> >> >> =A0#define =A0 CIFSSEC_MUST_SEAL =A00x40040 /* not supported ye=
t */
> >> >> =A0#define =A0 CIFSSEC_MUST_NTLMSSP =A0 =A0 =A0 0x80080 /* raw =
ntlmssp with ntlmv2 */
> >> >>
> >> >> -#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_SIGN | CIFSSEC_MAY_NTLM |=
 CIFSSEC_MAY_NTLMV2)
> >> >> +#define =A0 CIFSSEC_DEF (CIFSSEC_MAY_LANMAN | CIFSSEC_MAY_SIGN=
 | \
> >> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CIFSSEC_MAY_NTLM | CI=
=46SSEC_MAY_NTLMV2)
> >> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0^^^^^^^^^^^
> >> > =A0 =A0 =A0 =A0Won't this change enable lanman auth by default? =
Is that
> >> > =A0 =A0 =A0 =A0intended?
> >>
> >> I think it depends on what server sends in negprot response, the
> >> minimun dialect it supports.
> >> If the dialect is greater than Lanman2.1, the default auth mech fo=
r
> >> cifs client is NTLM (ntlmv1)
> >> if the dialect is less than or upto Lanman2.1, default auth mech f=
or
> >> cifs client is LANMAN (lm).
> >>
> >
> > Historically we've required that the admin
> > set /proc/fs/cifs/SecurityFlags to allow LANMAN auth before the cli=
ent
> > will allow it to be used. I'm not opposed to changing that, but the
> > description doesn't even mention anything about that.
> >
> > I think this ought to be a separate patch with a clearly described
> > reason, and probably doesn't belong in 2.6.38. It doesn't seem like
> > it's necessary to fix this bug.
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> I think that is still the case.  If we do not have the code,  we will=
 get error
>  CIFS VFS: mount failed weak security disabled in /proc/fs/cifs/Secur=
ityFlags
> and auth will fail even if admin did necessary to allow LANMAN.

=46or the record, I'm of the opinion that this secFlags stuff is far to=
o
convoluted for anyone's good. It's horribly confusing. I don't think
what you're saying is the case however:

=2E..global_secflags is initialized to CIFSSEC_DEF:

	unsigned int global_secflags =3D CIFSSEC_DEF;

=2E..then, if ses->overrideSecFlg is not set (which is the case if no
sec=3D option is set):

        /* if any of auth flags (ie not sign or seal) are overriden use=
 them */
        if (ses->overrideSecFlg & (~(CIFSSEC_MUST_SIGN | CIFSSEC_MUST_S=
EAL)))
                secFlags =3D ses->overrideSecFlg;  /* BB FIXME fix sign=
 flags? */
        else /* if override flags set only sign/seal OR them with globa=
l auth */
                secFlags =3D global_secflags | ses->overrideSecFlg;


=2E..now, secFlags ends up being global_secflags plus some optional
sign/seal flags. Then later:

                if ((secFlags & CIFSSEC_MAY_LANMAN) ||
                        (secFlags & CIFSSEC_MAY_PLNTXT))
                        server->secType =3D LANMAN;
                else {
                        cERROR(1, "mount failed weak security disabled"
                                   " in /proc/fs/cifs/SecurityFlags");
                        rc =3D -EOPNOTSUPP;
                        goto neg_err_exit;
                }

=2E..so, because CIFSSEC_MAY_LANMAN is now set by default, we'll not fa=
ll
into the else condition above and the mount will work by default when
it would have failed before, right? So the default behavior has
changed...or am I missing something?

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
