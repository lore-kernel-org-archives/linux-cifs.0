From: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 17/21]fs:cifs:connect.c remove one to many l's in the
 word.
Date: Tue, 1 Mar 2011 15:28:24 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1103011526560.32580@pobox.suse.cz>
References: <1298614502-4114-1-git-send-email-justinmattock@gmail.com> <AANLkTimneD0d=qpTq2CMpfvjYuQC2kx1mf2ZnORG32KK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, sfrench@samba.org,
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <AANLkTimneD0d=qpTq2CMpfvjYuQC2kx1mf2ZnORG32KK@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 25 Feb 2011, Steve French wrote:

> merged into cifs-2.6.git

Doesn't seem to be in linux-next as of today. Is cifs tree not being=20
merged into linux-next?

>=20
> On Fri, Feb 25, 2011 at 12:15 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
> > The patch below removes an extra "l" in the word.
> >
> > Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
> >
> > ---
> > =A0fs/cifs/connect.c | =A0 =A02 +-
> > =A01 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index 8d6c17a..ea4a146 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -722,7 +722,7 @@ multi_t2_fnd:
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sock_release(csocket);
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0server->ssocket =3D NULL;
> > =A0 =A0 =A0 =A0}
> > - =A0 =A0 =A0 /* buffer usuallly freed in free_mid - need to free i=
t here on exit */
> > + =A0 =A0 =A0 /* buffer usually freed in free_mid - need to free it=
 here on exit */
> > =A0 =A0 =A0 =A0cifs_buf_release(bigbuf);
> > =A0 =A0 =A0 =A0if (smallbuf) /* no sense logging a debug message if=
 NULL */
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_small_buf_release(smallbuf);

--=20
Jiri Kosina
SUSE Labs, Novell Inc.
