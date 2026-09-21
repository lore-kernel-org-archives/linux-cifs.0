Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D40F35E1CC
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 05:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789969506; cv=none; b=eCJO1O1BSwoxFDgDOMgLkdR09Bf8D6k4GkRMolsM9F3iBk7wjGoAnCzQqdHeKFaZrFAbnNiCR9ut+mRvfjgxqHxPGWQ/LuDUfbrBVjI2SOJu6rVTU+OhTlvSEcv2uCEIzygsv7DAdpYYWfWVX/fcW1tsmVBbTyvI4HM0nY8kL6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789969506; c=relaxed/simple;
	bh=u2QN2Kk7CAHgFMwjZvSJrK+XtCLXwmmeZC3Y3YrAisc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VjLS32H0VC2pHD3esMgZA87JZjXfyGjdg+7eol03bIVrUnqLjVDLzUB6iCHECcAHNpYuvjI86XfYwt/K2GwpsoSfA79ct+9vo+0BF22nSxPoodnMJp5n68jxdlTAjrM2Ws8StNXQ47c04trDXuHmqtulvsVGXc5hrxg4miuI3rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gpLyD6mk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gpLyD6mk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532421F000FF
	for <linux-cifs@vger.kernel.org>; Mon, 21 Sep 2026 05:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789969505;
	bh=u2QN2Kk7CAHgFMwjZvSJrK+XtCLXwmmeZC3Y3YrAisc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gpLyD6mkic+Iuxx8dxVTMulx4MvaZ9h66Y5FsYeB9de3hNepvlSBkTdU4pXSj8J63
	 r4KrGufoowKYC4ejMHQ+3ezquERuEx7Nasr55LEdaIACg/Sb3eJukOvpbs45sv8GDw
	 voiuTjv/zqMn+qtEXn7wNwqx5xPNI1XC0UR+HaQYb97Py6OjrdHFUjI0lveN5ZeUms
	 5GgYNjcCPjUzTv3SWKn5uXdPQZTBmq2m2QCtMtZJv4HD/H3Ysdrgrbor8bvJ3wSmo2
	 9UzuUTJnt15bC0PRnymogl6eAdbkSZrIxXovCItiv4SWHqJedw50yCMaJu0cBOLWFw
	 JZ6kb65jeoxjw==
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a67fa7a64eso3948078a12.1
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 22:45:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwWf2P1TLk5kFtHOX/vPxbqP9VO+52MmmHWErLXP519B2xZwWUhFf7Cx3u9FQefXlc+WiIlU2Mpzdm+@vger.kernel.org
X-Gm-Message-State: AFuF++lPd01tzH/E8BUTaHyo2NoL9/ngA/AuNfT3DdcZwkMl5UM7+/fp
	XS+2HZ64HdpCPcC8fIhEaZFtfadm0vqHRqu29+vgU4k4o3+jTIWd/2+nvtCBhVyAJoOnQP+ejSC
	UFFNIZl7/yRqeW1KAXzTrHBGVn9rx2OU=
X-Received: by 2002:a05:6402:5488:b0:6a5:d8f0:dc12 with SMTP id
 4fb4d7f45d1cf-6aa564f41ccmr6656525a12.14.1789969503981; Sun, 20 Sep 2026
 22:45:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921014130.147229-1-zhang.guodong@linux.dev> <20260921014130.147229-2-zhang.guodong@linux.dev>
In-Reply-To: <20260921014130.147229-2-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 21 Sep 2026 14:44:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9KE9PSi61z-PN0e3WLNNOxx8UW5QfQjq=qrOaJT2zVdA@mail.gmail.com>
X-Gm-Features: AcwNN1W9Jw_WBwepa92xD-oGNFSfwM6A0lldc-9U7xWkhrcHtfyT0Ax_Qe__Q3U
Message-ID: <CAKYAXd9KE9PSi61z-PN0e3WLNNOxx8UW5QfQjq=qrOaJT2zVdA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] smb/server: update POSIX extension specification references
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:41=E2=80=AFAM ZhangGuoDong <zhang.guodong@linux.=
dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> The POSIX extension specifications have now been published:
> https://smb3posix.org/
>
> Suggested-by: Paulo Alcantara <pc@manguebit.org>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!
