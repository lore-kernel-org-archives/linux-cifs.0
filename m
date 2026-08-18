Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3240620125F
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787032700; cv=none; b=Ee1Y5UN4XB8cowT7Y9SiElhmNlQRveZ9aKpOO88ynmshik5sm6w42eU4MdZ3Sf3idHCuBoaaAkijY9gkt+OZ57CIed/2qp3zzu23Y2jIJViXR8RGItrpor/P5lmYkOGnRRHNDISAZtRs3UWe/AcLhvzx7Ts2YOwqZ0YrFzy4Uzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787032700; c=relaxed/simple;
	bh=hddMWXv1qf+znQHts46gFsdX7g3y6ckt1waRUz87QJg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ApQH4l2IFneIwz7adDWl+Z14a/0j461Zn8n4gLxvj4BC/vGP7pyGbQczAOIc9CPiW8gmnI8F+SGiO++7Io4vI6T/WnZnRZNpo6TtyrvCm2JZXM+XD3pgXU2i5AuQ45BijsZj31zmVczRBVG35nV/9GCv4E9voH7/tyfg0wtSbM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5w+XsOi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5w+XsOi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1831F00ACA
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 05:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787032698;
	bh=dJd7vw8Z8O9OwrzZIAudHcT0tNv0/sG2ikY5whsxl3g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G5w+XsOiKtmuyNEl3i8Imv5/2ESbCtP56hL4hBhQTm7XyAl5AaMRTlry4xtmWiJbz
	 INhy8QH6by4GNdS5iRReTQJORsn8EXMgtDbrgGnyJqmssWW/S9yxm1u7B4ZI1JgLPr
	 HLEb4zpyvP+/VQwuJKIkXIDgBsdF3FMN7WY4TbGulo6WIzJjDgleEf5DMRcb39fo+n
	 STvffUGhSMZo6+iDda72W+dYa32ATSlbofsipI7cYhQB1DTtsplGw2wL098mTXqdm1
	 MatrKejTPkuyFvS4MF1cHo/gsEC3BxcBmEWu5qNb3ahhb3pVKagUCl/+p04tDrDN/h
	 zD5JTlrYx3j6g==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a0a4a28cbdso7166302a12.3
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 22:58:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RogoVGFSviP4KrDqcS6Xn5kJaGtEWQXrdT8WCoAMzq6x/FO3813PVG4O/NAhef3kS0SKnon5OT29s4h@vger.kernel.org
X-Gm-Message-State: AOJu0YzViXLam/Ouai3H4eFWFdwq9GAn11wKPl6DmMdqlB7ywIqOJtyU
	Br6rROa09YPVqC03lwcgrbHnKU+5+hEBdO74Os035zcGWfd2nan+4ONU2xDF9421+CaaHUuoFfR
	ly3h0uL9rFguFkpQWJ3moyXe86nMfOGg=
X-Received: by 2002:a05:6402:350c:b0:6a1:7ccd:5203 with SMTP id
 4fb4d7f45d1cf-6a38a8d7a6cmr14118710a12.2.1787032697523; Mon, 17 Aug 2026
 22:58:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812130152.2861834-1-thuth@redhat.com> <20260812130152.2861834-5-thuth@redhat.com>
In-Reply-To: <20260812130152.2861834-5-thuth@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Aug 2026 14:58:05 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_yLTgWFBv_ygYvbBdQcp3Z=pZ7F0A=_c8qdXWTLGdi1w@mail.gmail.com>
X-Gm-Features: AcwNN1Uc_VT63NZbX-iBHXQBen9cevLhm1usT4mG6LVn8TFJFp7yg9ABdBn8gz4
Message-ID: <CAKYAXd_yLTgWFBv_ygYvbBdQcp3Z=pZ7F0A=_c8qdXWTLGdi1w@mail.gmail.com>
Subject: Re: [PATCH 4/5] smb: client: Clear sensitive stack data in smb1encrypt.c
To: Thomas Huth <thuth@redhat.com>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 10:13=E2=80=AFPM Thomas Huth <thuth@redhat.com> wro=
te:
>
> From: Thomas Huth <thuth@redhat.com>
>
> Make sure to not leak signature data via the stack, clear it
> with memzero_explicit() before leaving the function.
>
> To avoid that we have to introduce "goto"-cleanup here, we re-arrange
> the code a little bit (and drop the commented cifs_dump_mem debug
> code that looks like a leftover from very early days).
>
> Signed-off-by: Thomas Huth <thuth@redhat.com>
> ---
>  fs/smb/client/smb1encrypt.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)
>
> diff --git a/fs/smb/client/smb1encrypt.c b/fs/smb/client/smb1encrypt.c
> index bf10fdeeedcab..c9eb68f04e7b0 100644
> --- a/fs/smb/client/smb1encrypt.c
> +++ b/fs/smb/client/smb1encrypt.c
> @@ -81,6 +81,7 @@ int cifs_sign_rqst(struct smb_rqst *rqst, struct TCP_Se=
rver_Info *server,
>         else
>                 memcpy(cifs_pdu->Signature.SecuritySignature, smb_signatu=
re, 8);
>
> +       memzero_explicit(smb_signature, sizeof(smb_signature));
>         return rc;
>  }
>
> @@ -126,15 +127,13 @@ int cifs_verify_signature(struct smb_rqst *rqst,
>         rc =3D cifs_calc_signature(rqst, server, what_we_think_sig_should=
_be);
>         cifs_server_unlock(server);
The MD5 context in  cifs_calc_signature()  may remain uncleared when
__cifs_calc_signature()  fails.

rc =3D __cifs_calc_signature(...);
                                               =E2=94=83
memzero_explicit(&ctx, sizeof(ctx));
