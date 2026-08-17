Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B58165F1A
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 01:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786930727; cv=none; b=bZp3YUUzzjCyZJOUNRMzexa+HZVR0oir87C+lqu0gKAdXI+qmA2Zd4f2swJ1BdR1Ktas6/R6XSSbvW0QFpyVOizr/RIlPauJP4DMCIBtW41QmGc7UzVPUJy+fZ//JgvUuLoAAfGMUY/tONSPiApcOUXDX1LMHMeSJ0D86sgL5OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786930727; c=relaxed/simple;
	bh=IEk3iFCiffR+hncrzZGZwyMyjvNR1CunCJZIRVwbMpU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KP4d04h4JXjl5gwbbo+VYpLAG9DpW2dZhZKX17XfSjV8kutAVaEyh2TFLd63eofXXm9E1CEwohSNAndwIDEOxbij2mHkwq02+zqUOf452gTNELYnW/UH72kFsf1u12/rNYRarFNihsiO2bQlfBIcQugrqX2Vf8jvFU5mHnXc4lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aZ4IPt9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aZ4IPt9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 510A81F00A3A
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 01:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786930726;
	bh=k19HOP10WjFP6meu00arMJuKC4Kdi/iVcaEBt9nwedI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aZ4IPt9NfNAcHKqXPfU2FFHdb7Qx96JyVjEojoyc0wN+5qrBuymIpqaN/uptsjdvP
	 t/yoNsVvEy7wQcit8kWJ84xNC3cBrzmusW9Py5oByoAcWSaU8LS/jfIWAOw5pm4M13
	 sGKmYfjTkEEwogXb6bPnE4qvYBifzGRguFxo+KFTiqYjJCzRALbGi5SCea8vJeNtA8
	 24Dg9pseUWoivj34fxY2WkFfPzvYKNgFagbLi8MG3YrhUoILVww+yH1prEKqDhJo9w
	 OVS0UFNdsWFlCEIW01pHAZU3vBuxquGZdHKfJ6fR5C0wSvvHe6xthPNPRmBBjXQb74
	 SNO4U/sdcCwfw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15cd3fd760so340703166b.2
        for <linux-cifs@vger.kernel.org>; Sun, 16 Aug 2026 18:38:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqtjU2dh196NDsPZP5fRWKxQYCXdIXWCyyDodxe3O/mxrnOhd4whKLrhbPqFtnWKfMTV4Hmw6Ugw+I1@vger.kernel.org
X-Gm-Message-State: AOJu0YwJpzyUCciqYmo4IwoOENGkuClZm9HR1FmurO87RRKBeLbPn8pd
	Vhgm/e/+M47L597KDlHodOK1IubXGC5QEqY+F6EcNHFTM9DtshIXvRSy1zKPiVhciaqdNCw3aOo
	5k6j36ewAzGlNxQ3kAMe4Vn6srj1cgtA=
X-Received: by 2002:a17:907:980a:b0:c20:eea4:267c with SMTP id
 a640c23a62f3a-c212a8b725amr927898166b.30.1786930725028; Sun, 16 Aug 2026
 18:38:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
 <20260812103945.82495-1-2122295973@qq.com> <tencent_4A67129F3CE9202D7F81A4FF94115D64DB0A@qq.com>
In-Reply-To: <tencent_4A67129F3CE9202D7F81A4FF94115D64DB0A@qq.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 17 Aug 2026 10:38:31 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9XHJSNfrFr+F8thNxFnXqGGcKpS1b1qR4DNuu82+j_VQ@mail.gmail.com>
X-Gm-Features: AcwNN1XeN30b5RjJp3AuspFs_Um10jOeneyZrG_Z6RP4Ul4bQtyz6oZhGNWbL6U
Message-ID: <CAKYAXd9XHJSNfrFr+F8thNxFnXqGGcKpS1b1qR4DNuu82+j_VQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ksmbd: bound smb_check_perm_dacl() ACE walks by
 DACL size
To: Hang Nan <2122295973@qq.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 12, 2026 at 7:40=E2=80=AFPM Hang Nan <2122295973@qq.com> wrote:
>
> smb_check_perm_dacl() validates that the DACL fits inside the NT
> security descriptor, but then bounds its two ACE walks by the
> remaining NTSD length (acl_size) rather than the DACL's declared
> size (pdacl_size).
>
> When pdacl->size is smaller than the trailing NTSD buffer, bytes
> after the declared DACL boundary - still inside the stored security
> descriptor - are parsed as ACEs during access checks.  A crafted
> DACL can place an access-granting ACE beyond pdacl->size, and the
> current code accepts it during SMB2_CREATE access validation, while
> parse_dacl() and smb_inherit_dacl() stop at pdacl_size.
>
> Bound both ACE walks by pdacl_size to match the DACL boundary
> semantics used elsewhere in the server.
>
> Validation (KUnit, UML, x86_64, KASAN; first KUnit tests for
> fs/smb/server, see follow-up patch):
> - ksmbd_dacl_walk_must_stop_at_declared_size (semantic harness):
>   with the current code the ACE placed after pdacl->size is
>   selected and access is granted; with the fix the same sample
>   is denied (EACCES).
> - ksmbd_smb_check_perm_dacl_boundary (drives the real function):
>   passes with the fix; fails with the fix reverted (rc =3D=3D 0).
> - ksmbd-for-next-next (rebased, base e9d76059ff03), x86_64
>
> Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()"=
)
> Signed-off-by: Hang Nan <2122295973@qq.com>
Applied it to #ksmbd-for-next-next.
Thanks!
