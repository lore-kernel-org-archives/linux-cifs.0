Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794101483;
	b=k6OVooa7a4NpMoA4T/60cJNTImbhepUHC4TowZRnc5Q7NUU5lHJlX/pmOqNoic7Caobc
	 jePYgCuoISPJ4GfsL5BKYa9YFVAsHtH+sUZg2tpoqo4VrnHX/IPLC/eRQfLpeYGFv/KWi
	 LDaqyer4FVLeFGZ2ZZ0sX/uHlrlJAHHtTgEhB1chkgCZHaTjWx8Hbv1TS9XhVutmeMy8u
	 Kf4k3mlQLNq8JPck0XxK/P8+c4gTZaS6Qe9+NC3gRg/8hJI78XmJaSeOe40TK+MiFQAUm
	 e5xuoos5kR/Mi4U8MoUQHFyS13oHEDch7VQreyRiXq1TBjaSgbU3WFPHyicOZC6z2xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794101483;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=dM1vJ0OTbEs6tY2JexfLiPQVEjP+CijryoqT4IMo0+M=;
	b=L92F4Qk8SeiNMVN0LnnyPBpu16vzj0GXSxtyF9694338lshWd5yODopcpwCC0ealFE1l
	 vSd3zkt8Ef/rWtXnohDgL9hS9nLV2Xe3xlF0lBo4i1kZN6d498+z1MFY4kKwFw89cP+m+
	 NZSVC8htvPvkNCBX5q6lS80nugulZn1dqttvacV55iGTbuPUaRoTVIS9cc6pIEpA9HW78
	 lKOGSbbdf8jpKijHHyEP1FGF4jE58NYnIjXtQWX1BtcsaztHcBG9SC/PmFcW3ph64ipuE
	 QL575CdWP/r9Xhb6K7AFVW4Q89dxbnxwV9fCs0g4y7Cru7NhdLKC28VUsc+zZBtNxUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P0Minf6H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD3D606A331
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 01:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P0Minf6H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 607FB1F008A2
	for <linux-cifs@vger.kernel.org>; Sun,  8 Nov 2026 01:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794101482;
	bh=dM1vJ0OTbEs6tY2JexfLiPQVEjP+CijryoqT4IMo0+M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=P0Minf6HhPFoBhIOibmqA46xi4JB2RfwFpj84GGhJrnpDAHP5IWSFHnstgCwiot1v
	 hcsbx/6aneuHVFV0kpySI4TfsYReBqT6EWTGcfdd6Do3H/JjEEe9BQLb1nK6zawPfl
	 od7wrD5+czozvzQtSZldh6uV/rru0z8U/ls4ksdRPhHDe5otYHzIEfDqWJja7aYbjc
	 Ef/JEwaxwWkGL5tjT0QB+ejKPYYVDXgTHLKxsNE1HUQ9JnTdtCHWzJTOjmid8QvTib
	 ckaDvKUsny9wE9W6xIhJsgaMLpnyjzrhLmzU/qjFLrFs4updOLV93ucjUvV9kCNVwB
	 DFMAhmdNS7pdw==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c445c95d553so11260166b.1
        for <linux-cifs@vger.kernel.org>; Sat, 07 Nov 2026 17:31:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzyNmTmhkB30eD+xeS81K8Ln0a1gNk9lADU8/KAF+UfL/UZQkMz46WGLhuaUJvp1AwzBqTyM4lAZXqf@vger.kernel.org
X-Gm-Message-State: APuU4Z9O2Rom6dOeI39GzOmRhKwpHMIShyXRZfnXMCZzbKvOds1MwNUB
	3S+jODkrTQDxMGAvad0N/LBxBiz5I5MVo25n4/ylpXpc+da+yQUbtkjm+eu01poMDXRkWOpWz6N
	R5j7qKQjbWvXX3z29+dWdxYOAS65fbHo=
X-Received: by 2002:a17:907:60c9:b0:c42:24ea:3220 with SMTP id
 a640c23a62f3a-c4d6d78ca24mr29636066b.31.1794101481018; Sat, 07 Nov 2026
 17:31:21 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261107231941.1824289-1-icb@fastmail.org> <20261107231941.1824289-2-icb@fastmail.org>
In-Reply-To: <20261107231941.1824289-2-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 8 Nov 2026 10:31:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-jNcP61uk8wm2xq6dtuw4_Cf-r1WDdUHSBQLJzdkOF2w@mail.gmail.com>
X-Gm-Features: AclHuK8ZxwM_IDYFpU40-keF-dJrDcSMiQYEPa6fwW594x2Se9ShicBNQ9Tq1Mk
Message-ID: <CAKYAXd-jNcP61uk8wm2xq6dtuw4_Cf-r1WDdUHSBQLJzdkOF2w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ksmbd: evaluate the DACL in order for explicit
 access requests
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -1680,7 +1706,8 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
>                     !(ace->flags & INHERIT_ONLY_ACE))
>                         or_ace = true;
>                 if (!compare_sids(&sid_everyone, &ace->sid) ||
> -                   !compare_sids(&sid_authusers, &ace->sid))
> +                   (authusers &&
> +                    !compare_sids(&sid_authusers, &ace->sid)))
>                         others_ace = ace;
For a guest session, this can leave both found and others_ace clear,
allowing the POSIX ACL fallback to overwrite the ordered DACL result.
For example, consider a file whose DACL grants only FILE_READ_DATA to
Authenticated Users, with a named POSIX ACL entry granting rw to the
guest UID. An explicit FILE_WRITE_DATA check returns -EACCES on the
base tree, but succeeds after this patch. A preceding deny ACE for one
of the guest's groups can also be bypassed through this path.
Please retain the fact that an Authenticated Users ACE was present
when deciding whether to use the POSIX ACL fallback, while excluding
that ACE from the rights granted to the guest. This also affects
anonymous sessions and remains after applying patch 2/2.

Thanks.
