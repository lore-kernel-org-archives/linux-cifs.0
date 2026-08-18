Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F453FB07A
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039265; cv=none; b=C3yTVVuVSRSVFtiKtRV+wVtjavgPiddfW8CvBshMy7qpBchFQWSf/Dd8pb+O6ka79PxJw6/9+f5TUZzwyempn5ZXKTLgpzL9fnc/JTuvqwm+ZjQLmWImXHLAxo1Zq0J7/XWAGUR3fjb94AnOAT3fXTQSMFw/BE6OluDA6nX4WZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039265; c=relaxed/simple;
	bh=/2G73Adu2vLBI3aXG8fJWfFYMZL05rxfMquc7OyuULw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=avWKVLOC7b8d+5pVVcH0DF/VGVTJVPybF9b+InrqBIAjU4WdMNDIcbJVXcOFUuD2B3WyAqWDqp/hzGUNOYFpBNvwR5wZV4yI9dnzMNX9n45LH31m0vW9SYCefhyrMUCMekw2Pi8c+P9hpgq6XPe/Ydv+VNtHhbgPvPyngWSaIvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03ADE1F00A3D
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:47:44 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so450677866b.1
        for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 00:47:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq6Q1ouggT2GLeO0mvVi6zQ8KM5ALUshDM2SIbDJO1PuEC3VKUnQTyzHga3DMXYflj4RyZ8tXnR60u9@vger.kernel.org
X-Gm-Message-State: AOJu0YxEKMwk+u9odWPrSMCWOetn8IYIbFdocNzaSc4K1massCYMK1fS
	zdtEOL/oA+qkOUP+hhUpeYNmxHtGTg9SyeaJ8fyyiqU3e88Zl6sTBBzO1RhJLTCuv6LC0e3xb39
	eP2z/rzOq3pLdaontCcY2KpCHZqE1Obc=
X-Received: by 2002:a17:907:9806:b0:c12:74af:51f3 with SMTP id
 a640c23a62f3a-c2129a9a404mr1426518366b.6.1787039261640; Tue, 18 Aug 2026
 00:47:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812130152.2861834-1-thuth@redhat.com> <20260812130152.2861834-5-thuth@redhat.com>
 <CAKYAXd_yLTgWFBv_ygYvbBdQcp3Z=pZ7F0A=_c8qdXWTLGdi1w@mail.gmail.com> <779785af-8700-42ee-a0f2-562343af6db2@redhat.com>
In-Reply-To: <779785af-8700-42ee-a0f2-562343af6db2@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 16:47:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8SbS9W1UniQF9xgMyOf5azGfkZ8QyE31xkSLu-bjoxcA@mail.gmail.com>
X-Gm-Features: AcwNN1XPDktVIenDPKgPWXVob29-Z7eH7L0lxB8ms3qK1v6EgZtgvUgNIc1PEE0
Message-ID: <CAKYAXd8SbS9W1UniQF9xgMyOf5azGfkZ8QyE31xkSLu-bjoxcA@mail.gmail.com>
Subject: Re: [PATCH 4/5] smb: client: Clear sensitive stack data in smb1encrypt.c
To: Thomas Huth <thuth@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 18, 2026 at 3:33=E2=80=AFPM Thomas Huth <thuth@redhat.com> wrot=
e:
>
> On 18/08/2026 07.58, Namjae Jeon wrote:
> > On Wed, Aug 12, 2026 at 10:13=E2=80=AFPM Thomas Huth <thuth@redhat.com>=
 wrote:
> >>
> >> From: Thomas Huth <thuth@redhat.com>
> >>
> >> Make sure to not leak signature data via the stack, clear it
> >> with memzero_explicit() before leaving the function.
> >>
> >> To avoid that we have to introduce "goto"-cleanup here, we re-arrange
> >> the code a little bit (and drop the commented cifs_dump_mem debug
> >> code that looks like a leftover from very early days).
> >>
> >> Signed-off-by: Thomas Huth <thuth@redhat.com>
> >> ---
> >>   fs/smb/client/smb1encrypt.c | 19 +++++++++----------
> >>   1 file changed, 9 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
> >> index bf10fdeeedcab..c9eb68f04e7b0 100644
> >> --- a/fs/smb/client/smb1encrypt.c
> >> +++ b/fs/smb/client/smb1encrypt.c
> >> @@ -81,6 +81,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP=
_Server_Info *server,
> >>          else
> >>                  memcpy(cifs_pdu->Signature.SecuritySignature, smb_sig=
nature, 8);
> >>
> >> +       memzero_explicit(smb_signature, sizeof(smb_signature));
> >>          return rc;
> >>   }
> >>
> >> @@ -126,15 +127,13 @@ int cifs_verify_signature(struct smb_rqst *rqst,
> >>          rc =3D cifs_calc_signature(rqst, server, what_we_think_sig_sh=
ould_be);
> >>          cifs_server_unlock(server);
> > The MD5 context in  cifs_calc_signature()  may remain uncleared when
> > __cifs_calc_signature()  fails.
> >
> > rc =3D __cifs_calc_signature(...);
> >                                                 =E2=94=83
> > memzero_explicit(&ctx, sizeof(ctx));
> My plan was to handle that via a __cleanup() function, too, but I need to
> get that merged first:
>
>   https://lore.kernel.org/lkml/20260813134953.979481-7-thuth@redhat.com/
Okay.
Thanks.
