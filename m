Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6527119E7D8;
	Thu, 22 Aug 2024 11:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724327743; cv=none; b=ZPeHhpg4bCrLd0CHcZ+UXMv76MpoSZUkw+jPaRyWO3NA4EQfcoj63rhHrCqEvwuBJk1Hmv4HoAzYBwp1XcN3zlX6jt5EQefKnKQE5xEvp3I1a9di1aDdR7pwe0eeNPAJVI1LvbQscgRzBAHn1C26Iecv49wrUTOJYt/M3uiwneQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724327743; c=relaxed/simple;
	bh=xyyYSHlpETdxXpgwIpg+3WZM1dT9wVjT8Zwh1foGbqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nDLnhfaMkmsNj2BQDBFKnRefDxsTNj0VzjY/PyVwRmsowp4RhbKf0FIy9jBmrbpwCgCYstk1fY0OJGobB0FcXgnS3xQngF5yJHnQeb1d//3tCMPEK1bKK07tOyd0IxQ4Pr97QV62VTAc7S0oLT8AdQBPxOkkD/bRjEGSr3dBHsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RbE8IaIh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RbE8IaIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2CEC4AF13;
	Thu, 22 Aug 2024 11:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724327743;
	bh=xyyYSHlpETdxXpgwIpg+3WZM1dT9wVjT8Zwh1foGbqg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RbE8IaIh+qFR9m9mAiPJstYgtt1NZV6+n4Jcm/DYWkuj6jDGnv/0x9TiO0zRRqZRN
	 NQHl4hGFT17ykVyEIyHaGDT3KhFyo9/5erjyDe4C1jDuOsM832eTf72jKTF6S7RRZl
	 rVvWqI+d/8Ydtb/CKOy5w9Ww+KsLta4VBJP92WeKtRo7PaTAVygJOBr07kYoqRlbZY
	 92wso2zAsnPvRZ4gsXKzHItGIy6/7ie6Itp8nQ5fvSGH9tPUSCDkiQOYvo4mA6mWZB
	 nCcfXBF/l5aDryBRY9JTSVy3DmiFzBFYBWhHtzLaJ29MxktVQa53ZfGK4qyo9IOE4t
	 KhvGILOv99yfw==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5334a8a1b07so1016442e87.1;
        Thu, 22 Aug 2024 04:55:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVQXkbBLWTBq0TXHYFOFTlxnIhBBLAdYpi35JU7ddzSW611wS2raLRN3V/fAjm33OBY5rFfzaHednQN@vger.kernel.org, AJvYcCVv+hhCfHgez4mwx6rtXXC8MlmR6Gjs3V3dVwMkQ1H7yvReulgLVfSiwbuiIcI9AHZe7ZKuV3cxAbcUa6U8@vger.kernel.org
X-Gm-Message-State: AOJu0YyhJeAuFJ+cVwfnJPD3VFARmTitdJ893vL8BrZj8aT8dUNeef9A
	Xih8n6EzetSrlC6RVdq8BcBJS8CJ8CyeUlbBZGsvANKsQM2V1lrFf4EmMKc9FYjzlYvCjrBbVXA
	4dpUWTxn1ptnCmXIRZLmviAzLpO4=
X-Google-Smtp-Source: AGHT+IE1gy1iDsFbXQ02n/87I53EUf1zm9XfxU3SKWRARAL0monG66bMYMWqjeqi6UB73LrbwRHcIAQYMivYiiBFuYQ=
X-Received: by 2002:a05:6512:2244:b0:530:aa09:b6bf with SMTP id
 2adb3069b0e04-5334fc0027amr1076551e87.24.1724327741295; Thu, 22 Aug 2024
 04:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240822082101.391272-1-chenxiaosong@chenxiaosong.com> <20240822082101.391272-9-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20240822082101.391272-9-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Aug 2024 20:55:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8-FmNH9gxGJniVNEXOpTYH8bD8Z0wHTjDN87WBDjYnOQ@mail.gmail.com>
Message-ID: <CAKYAXd8-FmNH9gxGJniVNEXOpTYH8bD8Z0wHTjDN87WBDjYnOQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] smb/client: rename cifs_acl to smb_acl
To: chenxiaosong@chenxiaosong.com
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	chenxiaosong@kylinos.cn, liuzhengyuan@kylinos.cn, huhai@kylinos.cn, 
	liuyun01@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 22, 2024 at 5:23=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wro=
te:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Preparation for moving acl definitions to new common header file.
>
> Use the following shell command to rename:
>
>   find fs/smb/client -type f -exec sed -i \
>     's/struct cifs_acl/struct smb_acl/g' {} +
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Looks good to me.
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Thanks.
