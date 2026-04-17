Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB1B262FC0
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 02:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776394033; cv=none; b=IuQMnlC/uUgJERoa0sCJRp3Dkj6ikduC0ZL8t0+BxwcTd/maEvDdMkjLheLseUbJuOoIOq/mExNwhewpvH/zgnPQC/MtY0q9TO2Vm4QnknfgpWs49WL3Ejl8YnCvmliGRf3jUiwiAgRxi/xCjD3HhSusFnF/bTa7ApKZ3dk4W9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776394033; c=relaxed/simple;
	bh=ag30l3ZtgL468KA3t+V/54BIptC5Ir8/kedwWC6NrEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=To0cTOqFPbc4lP9WCZowmByErBXxyU+/3Cd6iv9Fs4PUxDxdvtHNBfkfm18hZU3yQdpvV2U47XII+apgMQr95x1mE7+V0nt0AR0kcsnfaLqBqc5SnW4saCfN0ar40yrWlrLITMxO0IhbgogrlstnQYQHUvuhA07KV2MhRdQ54rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5fngzlY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5fngzlY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1A6C2BCB5
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 02:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776394033;
	bh=ag30l3ZtgL468KA3t+V/54BIptC5Ir8/kedwWC6NrEU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U5fngzlY1zgzop3mljeI2ezz9/vYkufvhLv0EgVM/TsGEr1M5DISNUTrlqtRAKOkZ
	 m9f6nWfDTzjJED1Y0fIC8UY1FIEIqkAusbeajlnydUbN4oAiLvyVSpWF+gkmxWnxfx
	 oFWv1Ieyizs0RNUk7hqjiEEo/ZixcwEk147vc0lSGC2/yTEkhgg3TIR9SqU7YR1/dt
	 jDuKG1FgIsCvhvBDXs+7pBavbhKBu9ODCCXvilnAujak6Ah0tF4JylWa4+zO6ViSGf
	 Ku7pSgRgmB+Ihj2ceP5QYJvpZL2VvPvTDUH4/JTOQdeR2F0GzRzPh8F/EQA1r3ftD6
	 o7eIbgqpS94nw==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b9c01854477so44997666b.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 19:47:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/Myf1gtaLRM/90QJIt/M5d6HjqqJosQN+RSod1iegJT5tmLdCP9X3sr73LCycrTa+aVwtbhDzllr49@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8+EhBqLStv7k0GfS0Jtw/hrzCQCypRBTNpc/lE/wrtS35PlTj
	HE+ESWwPba23t9sThMKplrY3XtCVeiA07BRtl8IDIdpeQWgVz1PcvWHRCNmHqLrWD6jSFTKd0Pk
	hWAjs849DHJ35xMeMoRpBMoMWyo7xUA8=
X-Received: by 2002:a17:906:c145:b0:b94:1df4:3525 with SMTP id
 a640c23a62f3a-ba41bad0123mr47054066b.1.1776394031997; Thu, 16 Apr 2026
 19:47:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416200439.2987930-1-michael.bommarito@gmail.com>
In-Reply-To: <20260416200439.2987930-1-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 17 Apr 2026 11:46:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd94w_Mi0gzAKrHiMnV2LsVk-Rzo6JcGtXNbEJZG4xXF4Q@mail.gmail.com>
X-Gm-Features: AQROBzBRonctEOhm_0Xni-0WQTv6zF5MG4w8OvP7PAUiLUDZd7Fz8lsWruW5q94
Message-ID: <CAKYAXd94w_Mi0gzAKrHiMnV2LsVk-Rzo6JcGtXNbEJZG4xXF4Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 5:05=E2=80=AFAM Michael Bommarito
<michael.bommarito@gmail.com> wrote:
>
> Another one on the smbd side this time. smb_inherit_dacl() trusts
> the on-disk num_aces value from the parent directory's DACL xattr
> and uses it to size a heap allocation:
>
>   aces_base =3D kmalloc(sizeof(struct smb_ace) * num_aces * 2, ...);
>
> num_aces is a u16 read from le16_to_cpu(parent_pdacl->num_aces)
> without checking that it is consistent with the declared pdacl_size.
> An authenticated client that can set a crafted DACL on a parent
> directory can declare num_aces =3D 65535 while providing minimal actual
> ACE data.  This causes a ~2.6 MB allocation (not kzalloc, so
> uninitialized) that the subsequent loop only partially populates, and
> may also overflow the three-way size_t multiply on 32-bit kernels.
>
> Additionally, the ACE walk loop uses the weaker
> offsetof(struct smb_ace, access_req) minimum size check rather than
> the minimum valid on-wire ACE size, and does not reject ACEs whose
> declared size is below the minimum.
>
> Reproduced the ACE walk OOB under UML + KASAN by constructing a
> 12-byte DACL (smb_acl(8) + 4-byte undersized ACE with size=3D4,
> num_aces=3D1).  The old 4-byte guard passes, then reading
> ace->access_req at offset 4 within the ACE triggers:
>
>   BUG: KASAN: slab-out-of-bounds in kcifs3_test_inherit_dacl_old
>   Read of size 4 at addr ... by task mount.nfs4/220
There is no kcifs3_test_inherit_dacl_old function in ksmbd. How did
you reproduce the problem?
