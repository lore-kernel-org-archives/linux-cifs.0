Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDEA189B84
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 02:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776218759; cv=none; b=Y4Nw2zbiiwIRy4SkuIoWlJ6TL7HlbdhGMPepCXseJO7GR8uJzZCrCW4JIP8g19NGyBgBAVP9LmslhU8kPo0aAjDpTYoQPluXsCUKqiB2VY1xVD/CzmTplEGH/uT4kabLb+5oNioyk0hNGuGj2jCNQ35G/66Q6xx2WSbFCmEvOVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776218759; c=relaxed/simple;
	bh=ZRAPSS779XlvSrcDbAnAYpBjhtSu2NTgxiO1w/TXAbY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TpSlROQUf1q76sctHNHC1whrMpLvWrYULYNQxLYs5+EG0Pp1oLVN2FiYQv6eMX5XQGKUi3YBOF38qE1eKJVwtH8TDKGZpEQvxSEdFUATi86N6JbZMWPVEyuBLLFPfHB7wSTTkN3a2kkU48w3TiiuSPeUeDrjPtMjjXDqswUHLrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyLiJ5re; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyLiJ5re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA37FC4AF0B
	for <linux-cifs@vger.kernel.org>; Wed, 15 Apr 2026 02:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776218758;
	bh=ZRAPSS779XlvSrcDbAnAYpBjhtSu2NTgxiO1w/TXAbY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=gyLiJ5re7ez32jpagsSGWzStuD1Mg2TwIDQcMsrQtroQCpdgLRghns5SClBDP8k7L
	 y4MoZLkk+GIuLkNbLKFiHbzp8MGhkuk3F60ruy4ivlO4BIEkQJEpEyaBtH3gl6tCpY
	 99AZQypuPzb2o9yeFJW3cKOUX2fvvd+kehZWn9qgPMU37z95Qo3Eq7l3l6rCf7oOh/
	 qQVKH9YWEM46M0B/dUk5OPfEcVFH43xexIaEKiE/cc3h0wTx5TPulDL2OSJyfttcOs
	 s9jgBS+HWrnI1XwXKRLp8DjQLGv6JLX9Xyp1U79tFiJ9cDKnnGjjncGMy/FJUIYD1G
	 2mrPp4zRmnDbw==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-65c0891f4e9so10556830a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 19:05:58 -0700 (PDT)
X-Gm-Message-State: AOJu0YzFjdSlMWvVxyyoL/Yp+gXe1Lc+jteyn+4g2EwT69TlPGCWH+a0
	HPZYGLKzI8hNzmgUbhPr//77UoLK/CvHkQ4Vo0OAayDYWyG8FPMPZcLWf8w7EIhH4m1EMfh2BTN
	BXeWWKKJFuwiqX94iEzHL6fGfKnWRQJM=
X-Received: by 2002:a05:6402:613:b0:671:8ba1:e8ab with SMTP id
 4fb4d7f45d1cf-6718ba1e9a7mr3948658a12.1.1776218757351; Tue, 14 Apr 2026
 19:05:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260414191533.1467353-1-michael.bommarito@gmail.com> <20260414191533.1467353-3-michael.bommarito@gmail.com>
In-Reply-To: <20260414191533.1467353-3-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 15 Apr 2026 11:05:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-pXiJy4S05C_s6sqz6FtnCeCh6Q2c4B7tPuHseA94mkQ@mail.gmail.com>
X-Gm-Features: AQROBzDVcTh38pxAIFoU8LssRoT-lh6vuP27HlEXphQNJLuEscIkchrpbrrRx9s
Message-ID: <CAKYAXd-pXiJy4S05C_s6sqz6FtnCeCh6Q2c4B7tPuHseA94mkQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] ksmbd: reject negative ngroups in ksmbd_alloc_user()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
> index a3183fe5c536..c62e2bf0ebef 100644
> --- a/fs/smb/server/mgmt/user_config.c
> +++ b/fs/smb/server/mgmt/user_config.c
> @@ -56,8 +56,8 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
>                 goto err_free;
>
>         if (resp_ext) {
> -               if (resp_ext->ngroups > NGROUPS_MAX) {
> -                       pr_err("ngroups(%u) from login response exceeds max groups(%d)\n",
> +               if (resp_ext->ngroups < 0 || resp_ext->ngroups > NGROUPS_MAX) {
> +                       pr_err("ngroups(%d) from login response exceeds max groups(%d)\n",
With the previous patch ("ksmbd: cap response sizes in
ipc_validate_msg()"), negative ngroups is now rejected early in IPC
validation.
However, ksmbd_alloc_user() still needs an explicit negative check ?

>                                         resp_ext->ngroups, NGROUPS_MAX);
>                         goto err_free;
>                 }
> --
> 2.53.0
