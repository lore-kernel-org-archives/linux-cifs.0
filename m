From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/7 cifs] ntlm authentication and signing - Correct
 response length for ntlmv2 authentication without extended security
Date: Mon, 4 Oct 2010 19:19:35 -0400
Message-ID: <20101004191935.7cdd4e04@corrin.poochiereds.net>
References: <1285771128-23075-1-git-send-email-shirishpargaonkar@gmail.com>
	<20101004064130.04e0d1bb@tlielax.poochiereds.net>
	<AANLkTimKnOy1fiXkALOf7rthiR4YHYjGg+iaswg=kSaO@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimKnOy1fiXkALOf7rthiR4YHYjGg+iaswg=kSaO-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 4 Oct 2010 18:08:24 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Oct 4, 2010 at 5:41 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> > On Wed, 29 Sep 2010 09:38:48 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> Fix incorrect calculation of case sensitive response length in the
> >> ntlmv2 (without extended security) response.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/sess.c | =A0 11 +++++++----
> >> =A01 files changed, 7 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> >> index af18a50..9148fd8 100644
> >> --- a/fs/cifs/sess.c
> >> +++ b/fs/cifs/sess.c
> >> @@ -739,9 +739,6 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.CaseInsensitivePas=
swordLength =3D 0;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* =A0 =A0 =A0cpu_to_le16(LM2_SESS_KEY=
_SIZE); */
> >>
> >> - =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.CaseSensitivePasswor=
dLength =3D
> >> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_le16(sizeof(struc=
t ntlmv2_resp));
> >> -
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* calculate session key */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D setup_ntlmv2_rsp(ses, v2_sess_k=
ey, nls_cp);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> >> @@ -756,11 +753,17 @@ ssetup_ntlmssp_authenticate:
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->tilen > 0) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memcpy(bcc_ptr, ses->t=
iblob, ses->tilen);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bcc_ptr +=3D ses->tile=
n;
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.Case=
SensitivePasswordLength =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_l=
e16(sizeof(struct ntlmv2_resp) +
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 ses->tilen);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* we never did alloca=
te ses->domainName to free */
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(ses->tiblob);
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tiblob =3D NULL;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ses->tilen =3D 0;
> >> - =A0 =A0 =A0 =A0 =A0 =A0 }
> >> + =A0 =A0 =A0 =A0 =A0 =A0 } else
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pSMB->req_no_secext.Case=
SensitivePasswordLength =3D
> >> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_l=
e16(sizeof(struct ntlmv2_resp));
> >> +
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ses->capabilities & CAP_UNICODE) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (iov[0].iov_len % 2=
) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 *bcc_p=
tr =3D 0;
> >
> > Looks reasonable, but I think it would be clearer to just have a si=
ngle
> > place that sets CaseSensitivePasswordLength. If ses->tilen > 0, the=
n you
> > add the tilen to it...but tilen will never be less than 0, so there=
's
> > no need to have this inside that if block, right?
> >
> > --
> > Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
>=20
> I think the patch may be fine just the way it is. If the field alread=
y
> has little endian value,
> it may be an extra code to convert exiting value, add tilen, and stor=
e
> back little endian
> encoded value. That was my original thought behind this code.

I'm not sure I follow your logic. I was just saying that you could move
the setting of CaseSensitivePasswordLength outside of that if block
altogether and eliminate the else clause. That makes the code more
compact and readable.

=46or instance:

	pSMB->req_no_secext.CaseSensitivePasswordLength =3D
			cpu_to_le16(sizeof(struct ntlmv2_resp) + ses->tilen);
	if (ses->tilen > 0) {
		...etc...
	}

The else clause just exists for when ses->tilen =3D=3D 0, so there's no
need for an else clause there.

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
