Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A8E944F
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 00:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763427403; cv=none; b=S+TfxNUUXPzgO+yMieOErQksQSGPovr4aQ6tsKekfh60U5IL9tR2PQHuGATF8qPiF/QYRDxYsofZRya708YKTfx7NjUbriRiBLX6O6BkezDp/pTekFnio6JLOdv2dUgz4C5n/FuDK8SJV7mdH7yrG9R+XEy5ksHJGhxFnJLSBtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763427403; c=relaxed/simple;
	bh=EhRvEKA9wsUl3d/ytkctMCvw+xK5SQChI+CyRvPpfOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fIP7Suo3lnu77WfNNaIPTVIADjFI19VSyEobdZtyQcFb+7hPMUD8e/hKwHYpYv7mdS03J5UB/lHD0vGk9EzpQKCD8Rv9+wy3EDl3Nrje9QQ7ZKW22ZjY+GdgmUJo2ZNyV6f7hALhEuWXZpI/VFbWYlE1g2MP/XgfRlPZCQnDnu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ToAS+SVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ToAS+SVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D898C4AF0F
	for <linux-cifs@vger.kernel.org>; Tue, 18 Nov 2025 00:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763427402;
	bh=EhRvEKA9wsUl3d/ytkctMCvw+xK5SQChI+CyRvPpfOE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ToAS+SVl/bh8t3QFNc4lLHfs4jMmOZZyPOUuRWGYLbQpKhQTcwzxksKi7tbG1CboH
	 UyP5xAWsky08IfHysf9S2B87lOe1boYe2Ri5BMvXMYK+TT5g+Z7E0IQitNSWzFJEJh
	 kMlOttkyrxqW3M46aUDURjZblV38+MWfwDF376TeOgQo6YohPavVxUCEf77HhE78sU
	 1scoeSHFy/z36XcHddNKtaqq44bKYeCsEeGcH2feEJLCk86UYvTplFizYgNf4fw0pe
	 s6eU/DbTj4P7FGeiFguoo9tgKq7Bi0EqNHbddClFw3Bn22kUfqiHTzGVVZbMPaA3zU
	 EBGiTytuH4ulg==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-64320b9bb4bso4314791a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 17 Nov 2025 16:56:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVJjIaiqFjGdp0YQyCPX3lfx2ghyn9az3ldjdLsVnfqGaH4QBEoMMK3u3zQTT663yjNA9APS4GrtOq7@vger.kernel.org
X-Gm-Message-State: AOJu0Yybs9S/iHxR5QTWFeUTrZFg4fuQQOGN4RLRKsWDwtdV7tPB7z6K
	YTdN3/NdApNtdEIvSdJk75EvwCx0fo1OrklzfdrzgIEITlvkJgUcNiHQWNd11RcQFe3rTMwg4b3
	ldu36bf8DOVh23J5hrNJO4kFNoB46o88=
X-Google-Smtp-Source: AGHT+IGHUTnsFaxroJyYoH8y0OWDzIYvYpd8iOXYto4bLn5lfNO+9pj1p3pcvuUPzlYEJwzqZeih64KTvmDtDbjKVbE=
X-Received: by 2002:a05:6402:5256:b0:643:11fc:7115 with SMTP id
 4fb4d7f45d1cf-644fe9b1b6emr1439615a12.11.1763427400612; Mon, 17 Nov 2025
 16:56:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev> <20251117112838.473051-2-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251117112838.473051-2-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 18 Nov 2025 09:56:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+aNHGp+DuLudxG63-Ay0GQtLDjk5KR_9APvH2i=c0TQ@mail.gmail.com>
X-Gm-Features: AWmQ_bkB-oeJ2AAPitGC3UmP8ws-bbjtSAezPOXN5P6U9jzeBubcRjPen2oibVg
Message-ID: <CAKYAXd-+aNHGp+DuLudxG63-Ay0GQtLDjk5KR_9APvH2i=c0TQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/1] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2025 at 8:29=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Modify the following places:
>
>   - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
>   - Remove MIN_FS_ATTR_INFO_SIZE definition
>   - Introduce MAX_FS_NAME_LEN
>   - max_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE=
_INFO) + MAX_FS_NAME_LEN
>   - min_len of FileFsAttributeInformation -> sizeof(FILE_SYSTEM_ATTRIBUTE=
_INFO)
>   - SMB2_QFS_attr(): memcpy(..., min_len)
>
> Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.
>
> I have tested the relevant code related to FILE_SYSTEM_ATTRIBUTE_INFO (Li=
nk[1]).
>
> Link[1]: https://chenxiaosong.com/en/FILE_SYSTEM_ATTRIBUTE_INFO.html
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Tested-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
