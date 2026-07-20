Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF583019DC
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 05:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784523852; cv=none; b=Y8ZUWp/n/EjrWOPppdruEhh7px+5EAJMyyO3JjY2n2nV2Xp66Ca2Prwz0q6GkVPX2boo2+Dqh2I2sq9Z0+79YZAK7TymT2dr+bCECjn/cwV0uTJgSqRD7oLTDUIZ8lcf8ErRAPZeG/USIi8o1cbGlb23J8VdnxenW3w7702n0ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784523852; c=relaxed/simple;
	bh=mg9HSy8buKlL/+ICMmP8SmerAN1vf0JM8syN5Bs5b90=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MnCZMyw6HXps1PVKEpFprSxzuVzJatz04eEtgK0qmbAqMmwOrBVBnb2G4DytJZSIolvKXM1hE2eMHpWtHYTAdamPAJdtrhEbfIi+/eu/jbHcfpEbdDRrdB0eGZYC6x/X6UsZX9yGuSuegsLiZf/cjQCBd5QzTNnTe/AFnNVlmAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KcjaYYZo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KcjaYYZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEDE1F00A3A
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jul 2026 05:04:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784523851;
	bh=7pT8l9PAc87qhwG2+e3OF8W0ehO72hAQueIiJI/zcPo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KcjaYYZotJjaqY8wVN0jI8aGhwiCM0BE6ZOFRcWjub+kdXnWlSdOSAR+1jZWO3sDc
	 tTs9T8H3b7qhkKU4zGd+o9aUG2XcoC3i0gsYRbSt7wQ7G4tmcW3RuW72orRLGdxE3i
	 di+rHarpKBQmVGzj2avQBWZgzQz53oQI/poJo1LPvEzysm8XeBux/VHOwmVnvFR+eH
	 fXxEjUsg1yw7RjeoRS6fRpTAyL/1CBXzGDIZqi08tHWoQX+vauxgS40vrVlnT+3x+0
	 JzvB8/h6ZY8Ql3bPbQwOsLO6GJtOt/jJLzB2Dq+33/aq3KukL63CtSEQZUIHonqPDO
	 GmiqPd5MAIKgg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6983d3dae7aso5041392a12.0
        for <linux-cifs@vger.kernel.org>; Sun, 19 Jul 2026 22:04:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RplOqtZy6DzysmajpPm0MZIaCiufN304/hYaPMVT1VAvMA6Vj1hXtdaahd4FadCXBpAum7K2rvQJqsF@vger.kernel.org
X-Gm-Message-State: AOJu0YwEwMpdO4E5RGLCAettyYB2zV2dyEBnlJj2BOPuCl/g9gypgNSH
	EPZIAsz3h/HZ5WKGiiSH70ddQvIanyRLirNI2n8G/DkRQ0tESxMjDyMNXJe3shMFcHWLq76mxbk
	DTYS9RmmHlwjgXDftMSadqsKmTbGS7Yk=
X-Received: by 2002:a17:907:d406:b0:c12:a556:6713 with SMTP id
 a640c23a62f3a-c1692493296mr747719266b.31.1784523850090; Sun, 19 Jul 2026
 22:04:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1784258165.git.tanze@kylinos.cn> <a5a362d962c22a0f447c1398db5256be5399488c.1784258165.git.tanze@kylinos.cn>
In-Reply-To: <a5a362d962c22a0f447c1398db5256be5399488c.1784258165.git.tanze@kylinos.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 20 Jul 2026 14:03:58 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-iOpGsVBb3phdDVsNGf0doEzhHuKENB-cqHFc+AD8fFg@mail.gmail.com>
X-Gm-Features: AUfX_mxJbT64FjeFsiM5fUmn_wwP78FPWeX-gb5IAVPvm0UEQOSmT_qcUXrmwl8
Message-ID: <CAKYAXd-iOpGsVBb3phdDVsNGf0doEzhHuKENB-cqHFc+AD8fFg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 7/9] ksmbd: support security.xfstests EAs
To: Ze Tan <tanze@kylinos.cn>
Cc: sfrench@samba.org, pc@manguebit.org, sprasad@microsoft.com, 
	tom@talpey.comm, senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 2159b45c80a6..da3d5c217577 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -2650,11 +2650,21 @@ static bool ksmbd_is_security_capability_ea_name(const char *name,
>                !strncmp(name, XATTR_NAME_CAPS, name_len);
>  }
>
> +static bool ksmbd_is_security_xfstests_ea_name(const char *name,
> +                                              size_t name_len)
> +{
> +       return name_len == sizeof(XATTR_SECURITY_PREFIX "xfstests") - 1 &&
> +              !strncmp(name, XATTR_SECURITY_PREFIX "xfstests", name_len);
Is it appropriate to special-case an xfstests-only xattr name in ksmbd?
Could the security namespace support be implemented using a general,
well-defined policy instead?
Thanks.
