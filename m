Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793832232;
	b=maMxG2bG/1/5DEeSmeUk4iw57E5VWHxxC9LBNRifpUatzdNDWMOseBwpihzl90b0uAiI
	 OsCuk6yxZYdyD/waHyaHpQBZLgzUYtTLLJSPF/v43QkO/XysaKspGcwfI+x7dmeXSFtyv
	 hBr3sDz753nOJC/VGgzWOp00dP07M4AYM0YT/fxXAg1sMV/yiICZEEgYkR5G5e9a+mvR1
	 VeL25p8gHJE4wmKgKqwWn8TybEC2TOCA8Eg6JudKV1oAtYUOCIB8mqNknFXi76/4t1Nzu
	 Ih9ZF0UAqBc10BMWEe7YlQ2PARiLSZCOY49vgXaDb+ZvT8NtHVyq+7bJR8Bh8CHCkfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832232;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=2rkLY6y6+ClNNLzzESKqswesvWfc3fvsu05JVfc9L34=;
	b=kDwLBX7/9c/TEI0Bd0CrX9rZJgEmhEggIEm5FATQCBmSlJ8XE1Kb5IyLFTlYL3RnE5vt
	 U7DaA7EeyosfM87EBxIKldvl6BlX/zqX8QVcWmBF/QthOj0avXwf7/jBoLhi6DU7+t6yH
	 KjXA1v7Us+vTiirx98XGZ4RLTGoEyjLYC/+b/y6wEu+s1tQhxrYpUfYIeYNHmcSFHUo2N
	 Jheq0BlbaIHca72vLSImJx45HvGSFkIpz8LoMq8ryarUZ3M/HmtbeU7bmRFWU5az7gbbQ
	 VqAxdXM7ltGLs0gikget3Kgzv2fXQi0N5/taWC1Ymg3JraqzcXJwo3/pYyHIpqLeLMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtiVx2yc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE84E606A328
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 22:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mtiVx2yc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D071F00A02
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 22:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793832231;
	bh=2rkLY6y6+ClNNLzzESKqswesvWfc3fvsu05JVfc9L34=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mtiVx2yckBtGxjgyq2jK0ld8nk086LHroqX/mF1C9u60q5YnJHou+C4Gl2qEJh8Zl
	 EM54MwpQ2gbUuZ5RxO0VtMS+ASVwuXLfxwNO2b+Hx/dpAogqf/jRo0qsBeKIig/ml1
	 w/hL6lJpdUg7Zgd9jAsCIYvT07olqait9nrZOJiUa+rQ2O/r+kOSIkh+3a+4xiOxb7
	 9thLkwXKV65WPejzE76MZskqSduOgUDIYTwP/6EKL6Dz7t1aClBxDsnsiJ3K7JVdum
	 NBLdensF7OVFfCA335wlEIaD+3ElUeeQECTyTD1bPvyHetmzQjxl7Q1EMopmz8XiIu
	 xtvuAJH0woqzQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c4697404c2bso175709466b.2
        for <linux-cifs@vger.kernel.org>; Wed, 04 Nov 2026 14:43:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzrU5GsJFdcDDD1B2yW4hgTTdXADPNi4VwW/DALYLtIOBB97GHS8ClntdSS8Iv4b8ELoAak9Kk4JCPl@vger.kernel.org
X-Gm-Message-State: APuU4Z/VET8RmXBQekxrkncjofoiDqN28cR58kSk+Sqawgl1xy6TDqOG
	MGEVE6MY2cmojGRFRZNzqYdA9uhYUsxbIgQAQTq6MFTzdgseMVveY+iCMJbiCKyvnWo4xDEwV4W
	UOcDBwpIELoqV7XtSsV5DjdJWb1VIl3A=
X-Received: by 2002:a17:907:3e96:b0:c49:b9b9:26cc with SMTP id
 a640c23a62f3a-c4ca7a68457mr1455407166b.23.1793832230305; Wed, 04 Nov 2026
 14:43:50 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104185804.195058-1-icb@fastmail.org>
In-Reply-To: <20261104185804.195058-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 5 Nov 2026 07:43:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-Sfd91-Kic7rg-_Zfzip9HcRy6k8w=fTJ1skDonS9Z_Q@mail.gmail.com>
X-Gm-Features: AclHuK9EFmOzCcqJH386Xw40dE2d_X2dJooISE5fjAA1xzRZ3mqpcKFtb2l4oZY
Message-ID: <CAKYAXd-Sfd91-Kic7rg-_Zfzip9HcRy6k8w=fTJ1skDonS9Z_Q@mail.gmail.com>
Subject: Re: [PATCH v4] ksmbd: grant a caller what its groups and OWNER RIGHTS
 ACEs allow
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Aamir Ahmed <elb12345@hotmail.co.uk>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 3:58=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrote=
:
>
> smb_check_perm_dacl() does not match ACEs for the caller's Unix
> groups and refuses an owner named only by OWNER RIGHTS. These callers
> cannot use rights the DACL grants them under MS-DTYP 2.5.3.2.
>
> Match Unix group SIDs (S-1-22-2) against the caller's credentials. Use
> the ordered DACL result when the existing SID lookup and POSIX ACL
> fallback do not decide access. In that result, deny ACEs for the
> caller's groups limit what it grants, also for MAXIMUM_ALLOWED. Count
> only the exact OWNER RIGHTS SID in that result, since compare_sids()
> also matches shorter and longer SIDs, and return only file access
> rights. Preserve the refusal for non-inherit-only object deny ACEs,
> which ksmbd does not parse.
>
> MAXIMUM_ALLOWED still excludes group allow ACEs. Including them
> requires corresponding changes in smb2_open() to avoid breaking
> existing opens. An open relying on group grants can therefore still
> fail when it requests a maximal access reply. For the owner, that
> reply leaves out the rights of its groups.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
