Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1B82F7455
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 04:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769056763; cv=none; b=rIkoGALqI9+hStQJCDDQmUbWP5DiFqHDpufPS3W0+qbYlBRHJ1RS2vDJwppHOEFETJfsSe7Bwh18mWtIxp1Md8Rrj03qhERgAFaErJ0k7ltLFjslZDU80A5i5IV56IGJgT+ZbQDuZEGbnESFQKXtGgslVhXIIrVpDk10kOQqlP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769056763; c=relaxed/simple;
	bh=fDqAGxji++BWAUpi6px6M3aZsyp/Qc/208yYVvF7ptc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dm3zF0nne6unQp9QS7Ll+KgWdpFV0pYvuAir5VpWHm6jCKrqU9OGNAESMrnWQU3ws3FZFKWW/Vcm5WLvBy3AT4CMveq08S+Xx5emVvXZwiFMwQJeFCdGZtiRbWYWqJ2MRPt8S0wC3vpVIH09WHCw3opFalhfup9ymznea558c5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VwZet5vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VwZet5vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF16C19422
	for <linux-cifs@vger.kernel.org>; Thu, 22 Jan 2026 04:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769056763;
	bh=fDqAGxji++BWAUpi6px6M3aZsyp/Qc/208yYVvF7ptc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VwZet5vdXEYTvfAcBrTzWhHh+lkDaUK2c3bfHELrF7PGUlFHFfxTViTzlIAk/Egtg
	 UvL7ydbS9cLLXalKq0ZPUzoQAmo2kI3HjfWGDcNshBGedrGaaJDjLMMZz1i/JGuXxc
	 SkpHNJFXuCGALSSl3JwHAHEoNWss0lgCSAOlXNiR0Y58Hj9GcGkW+fsTC11EqTu95h
	 J+dhtXPe2diWdlHb4i5JQfeg/KuTDwXliAGkcCibIqle0hABX6e4rGTXIzQ6Uv1to5
	 NnU9PvmWND55SBNZL2lRPN257DXmY/Bky18Qocql1t/gZFybFTz/sLfrXiUZIEtcfd
	 0/ovTWxX0pXuA==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b87f00ec06aso91367466b.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Jan 2026 20:39:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCURQCc1naZyKpcdcknCqXi7IuFu9jiwpL9rOf74H0E6J4GYy9w1jssBZ/BdZkprbUVYbsJPM84Hwt0W@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+N+slD3b76ZDwDKz1O1s4/oEbaunruu37H5DLY3ovyksyjXCd
	iZE25ETaopsD538QwyeOD3HDX3MsPIZMMydybmLZJKydwaY7Zz07pMveJhdxOD4Qvt+EPpQn0ZR
	bEpH6PlDRJ0yLYqKxe6lxu1uZTDjLoVc=
X-Received: by 2002:a17:907:1b25:b0:b87:d09c:1825 with SMTP id
 a640c23a62f3a-b88002350aemr557590666b.13.1769056761666; Wed, 21 Jan 2026
 20:39:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260122021015.1954-2-qikeyu2017@gmail.com>
In-Reply-To: <20260122021015.1954-2-qikeyu2017@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Jan 2026 13:39:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9B2zLEfxWKfCGEEgBPA91N=fUR_7zDmntv=Bp0zD_7wg@mail.gmail.com>
X-Gm-Features: AZwV_Qh9dl8ob2JneRcqNI8A8xMu17cD3Sx7b5zrZ3hXgH4Bmm5JusKfuDulJbM
Message-ID: <CAKYAXd9B2zLEfxWKfCGEEgBPA91N=fUR_7zDmntv=Bp0zD_7wg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate DataOffset in smb2_write_pipe()
To: Kery Qi <qikeyu2017@gmail.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	mmakassikis@freebox.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 11:10=E2=80=AFAM Kery Qi <qikeyu2017@gmail.com> wro=
te:
>
> The check of DataOffset in smb2_write_pipe() is insufficient. If
> DataOffset is 0 or smaller than offsetof(struct smb2_write_req, Buffer),
> data_buf will point to the SMB2 header instead of the actual data
> buffer, leading to out-of-bounds read.
How can out-of-bounds occur when the previous checks ensure that the
length does not exceed the request buffer?
