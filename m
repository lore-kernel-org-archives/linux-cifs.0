Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792571418;
	b=Ls4A5+wEBnzBUeCKY+mce4I9XtNnWfCjk2VCbHyUSnNEcE3+3UrMp7J7n3TfeEaJFysK
	 /po1peiXyn88bOMGvXJloTYoiLlZ1hjwWKpvsf2/Dl2G3jkqfbZDZCNGRbzQg0nBgMwSb
	 L039LZdOPrZqgNDQIb+Rq9NIT2A8TXs2QV8enoxQ9Yy7Ip1VEIzkcyhUsebX0hzBPAK6i
	 rEIwF2/y1wqlRGQ92LHROvxMhL7NeXMz5eILAzqffZ3n5RVkHcSnFKLFnS24pJZMqqj1J
	 ChyzhQqzEgfiRkLeAUZPySytriU+vy/n9OqPcWz9FjPazxr4HYsPOdgDbgmYjqKzxoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792571418;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=daJSZil5n4VKhtV/BGLtgxMfG8vLxWHwI3VJfceP2Zs=;
	b=bnYclgrlEeKmZXVe6EkQQYX16BW4iRudFrUstrRtT7rXpQRmZ65veue6AxHlGtSLBS03
	 snWomn5AV984h8xSFoMcRIpzQfipWU6+f0wYNkPEIfHOknThNuzlsXbFsyFeRkyNTOvXP
	 HW7KVSMYE72m8cbSC36mBJqTKxx/8NAILNPQTtICh+zT69HnTT0XUg0q38ICssj54nMBE
	 0OGtcl4QJUesRmXE5VfNpGfYEO6aqKT6KxEvJlkASKIchFEYxR1yxNRWiuulDmAKNHcBs
	 Mp+f+ZNB7Ddg0OP4E6+BOblKpIg90lyHYJu0riPJkdJw91wp86P5IctYVCpJdl136VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R1K8I16m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC2F606A319
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 08:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R1K8I16m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233801F000CD
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792571418;
	bh=daJSZil5n4VKhtV/BGLtgxMfG8vLxWHwI3VJfceP2Zs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=R1K8I16m5QIXnKdFcFS7p+8DL+piLpoeshmNpNS8PMCCDyo8U/QA1boCUOTt9iECo
	 7mMp694G9bFvVTTAtOYW8XcZ+bGMezqX8Pba1SHjx9XYiQ6gz6LCIYMNfe+1slORXK
	 YkSq+3BPLVPHRqcMqy9gaL+rK154xwbcPhW194c6NtE38hfjOC1R4hSkNtzkf4lw03
	 6Z9jgxOrhVWkHp20kTVzO/GIUZEV8E4msTKvmAHp9NvlZ71VagkfEC5dKpyhTI6tWc
	 Px2e4YjSB77PaD4tTXD0n/Merbp9Zrok/Dpo9LxIC6NdcEbmvDacnPFRige8mle+sU
	 MHQgLrXj6KK1Q==
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67990a45e02so413388d50.3
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 01:30:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByWr/uwVd9zSMv3l789JZbig2LUUqfeIfnNP6wZuQVxT1CKb5dmK8QhDGRsfj2x4wlERN2hI3BOEo9G@vger.kernel.org
X-Gm-Message-State: AFq9FYK8LWGcuzo2+mlVEVUeI2HZpSTRw37Jh/uavwBxSV+gNVI03TfJ
	WdfOrQWQiUv7bL4rdOC7phf2oyiCnuv0Sb0GveOfKW1Y6BCdkNJ6LGZfg/Sxn/pv4xLiy9inavp
	YGiGtw64JDp0IXy+KF7U9sON7Tol83AA=
X-Received: by 2002:a05:690e:4841:b0:677:d023:49e3 with SMTP id
 956f58d0204a3-67a0e4df714mr703207d50.65.1792571417409; Wed, 21 Oct 2026
 01:30:17 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021070257.127209-1-zhang.guodong@linux.dev>
In-Reply-To: <20261021070257.127209-1-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 17:30:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-oPKCzA+oURpDfhWkRoxiO=uk-65ZLn1hBz791Ztny7g@mail.gmail.com>
X-Gm-Features: AclHuK9fnkj5ASQmzQaQRFjgKcvqsL_Ta3g4FEHyPFtSwav9-kBLGjH5HOpbqys
Message-ID: <CAKYAXd-oPKCzA+oURpDfhWkRoxiO=uk-65ZLn1hBz791Ztny7g@mail.gmail.com>
Subject: Re: [PATCH] smb/server: replace deprecated system workqueues
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: pc@manguebit.org, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 4:03=E2=80=AFPM ZhangGuoDong <zhang.guodong@linux.d=
ev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> Queueing the lease break timer on system_wq triggers the following warnin=
g:
>
>   workqueue: work func lease_break_timer [ksmbd] enqueued on deprecated w=
orkqueue. Use system_{percpu|dfl}_wq instead.
>
> The oplock break timer and TCP transmit work also use deprecated system
> queues.
>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!
