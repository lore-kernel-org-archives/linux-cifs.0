Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69F373F1070
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 11:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788001539; cv=none; b=Se4hflaR7Ro7WA0u4sXRs/udqH3c6pptgDCyi+FML0t36iRAgVS7qhyE4sCHIQJRaHk+djW5zT+rGSkEjGJElkpi/aEMubeXfNLoW3UVTSdILLkLeGDlWwLG3f4FTy8KKYPMbibL2O+JFWTMPhuHeTJuWe62gykn6pTjgwku49s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788001539; c=relaxed/simple;
	bh=w9w1pz03pUe8dQ7H+Rj/d9Xflv2r652sM1aBu+JYDwU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nh0zZs7FJfruZQpIqFTiuRVdoQB3zScwrS/c/Og+nMTr5r2Sh1usS6Zj1hB41JguWEuZAE4NtzIGqhhLAnVXT9Ipq3ONmZGItVWUd2SXMw28uEGPaxhPydjSNMcgm4DOR+lY0tnOu0y0PUjqsKnBjFSHbdxFxCgUJM8m1nssGVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLgMMVSX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLgMMVSX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFAC1F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788001538;
	bh=puPZMdIkJP3C8PUA5FySgubM/AYGo1Ot2TrdlcWeHaA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CLgMMVSX9Svd59osHW3uqzIP2Q0CbRh5lQiTCjmeC3N1GmObl7ffVINcjBpjReRTP
	 VryJHiNotVkJNlCbU4WhUFabEGjexKwe1/1F8fX7vjji7qesWWd5qb8tsEOuFFZlIP
	 aiTL2P4d40qNkwCYx7a/OIakAyfyY/gBFR0DQJGT0QNQj2XpAXTWJcmQBngojTNV3j
	 3vlDemVKG373osK/E/1zBOIKqR9H+c+XgcMynK9ibvcLotv3XjHFSk55n1S2UhHETK
	 7lhXf0nOamFi0t4DaI4NHEEdYfrbR+hdw86/kSosbQ24eLUm1UfG18Zfwi0ilEgu1C
	 bxKFNyuEMNBhA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2533d83e3bso306042366b.2
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 04:05:37 -0700 (PDT)
X-Gm-Message-State: AFuF++n4yX48f/vu0oc3nO+u31795xmAx/dnXcDMORzfTTIAPoZS85ZB
	MUk5Wzzp7qNHnA14y82h+87Wa3jsw42UhpSsSpizfGTdbojSlFMbauue9dKwB6oEuiyl5eEZa5G
	Hznb+uJSFPPsYIMawA4htVgMttR1Jt+U=
X-Received: by 2002:a17:907:9810:b0:c25:5114:c832 with SMTP id
 a640c23a62f3a-c2556bd290bmr926580966b.3.1788001536538; Sat, 29 Aug 2026
 04:05:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260829102217.6201-1-suruurism@gmail.com>
In-Reply-To: <20260829102217.6201-1-suruurism@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 20:05:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_DJSPjuhnW88+Lu4urkYUWRuZVofFUnidoJeRrZs8awQ@mail.gmail.com>
X-Gm-Features: AcwNN1VgGr2nuanjfRGfgLpsuYOTUHyfj0xL0gs0wT_7OEvJJyw2fUzBjiPCWuA
Message-ID: <CAKYAXd_DJSPjuhnW88+Lu4urkYUWRuZVofFUnidoJeRrZs8awQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix use-after-free in oplock break notification
To: Abdifatah Suruur <suruurism@gmail.com>
Cc: linux-cifs@vger.kernel.org, senozhatsky@chromium.org, tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 29, 2026 at 7:22=E2=80=AFPM Abdifatah Suruur <suruurism@gmail.c=
om> wrote:
>
> smb2_oplock_break_noti() reads opinfo->conn without any lock and
> dereferences it after two allocations which may sleep.  When the
> durable handle owning the oplock is disconnected, session_fd_check()
> clears opinfo->conn and drops its conn reference under ci->m_lock, and
> the last ksmbd_conn_put() frees the connection.  A break triggered by
> another connection that races with the teardown can then resurrect the
> freed connection: ksmbd_conn_get() is a plain atomic_inc, and the
> queued break work later dereferences the stale conn via
> ksmbd_conn_write(), a use-after-free reachable by any authenticated
> client holding a durable batch oplock.
>
> Select and pin the connection under ci->m_lock before the allocations,
> the same lock session_fd_check() uses to clear opinfo->conn, so a
> concurrent teardown either loses the race to the clear or keeps the
> connection alive until the notification work releases it.  Transfer the
> reference to the work item and release it on allocation failures.
>
> Fixes: b003086d7696 ("ksmbd: fix NULL-deref of opinfo->conn in oplock/lea=
se break notifiers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
I can not apply this patch...

Applying: ksmbd: fix use-after-free in oplock break notification
error: patch fragment without header at line 7: @@ -924,6 +924,32 @@
Patch failed at 0001 ksmbd: fix use-after-free in oplock break notification

>
> ---
>  fs/smb/server/oplock.c | 36 ++++++++++++++++++++++++++++--------
>  1 file changed, 28 insertions(+), 8 deletions(-)
>
> diff --git a/fs/smb/server/oplock.c b/fs/smb/server/oplock.c
> @@ -924,6 +924,32 @@
>         ksmbd_conn_put(conn);
>  }
>
> +/*
> + * Select and pin the connection used for an oplock break before doing a=
ny
> + * allocations which may sleep. opinfo->conn is cleared under ci->m_lock=
 by
> + * session_fd_check() when the durable handle owning the oplock is
> + * disconnected, and the last ksmbd_conn_put() frees the connection.
> + */
> +static struct ksmbd_conn *smb2_oplock_break_conn_get(struct oplock_info =
*opinfo)
> +{
> +       struct ksmbd_inode *ci;
> +       struct ksmbd_conn *conn;
> +
> +       if (!opinfo->o_fp)
> +               return NULL;
> +       ci =3D opinfo->o_fp->f_ci;
opinfo reference does not pin opinfo->o_fp or o_fp->f_ci. opinfo can
still be valid after o_fp has been freed by concurrent close, so
dereferencing opinfo->o_fp here may cause a use-after-free. How is
o_fp protected here?
