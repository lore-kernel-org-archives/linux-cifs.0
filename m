Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793261994;
	b=qSpBwjIfGTfW7bGeJ2v6n1sKSeVaxIcjYqkbaChkZooCVQHC0G0n5DYTIOVIvL6yQqxr
	 N8ZdCA/rsjZ7DmFQiXltx8W3OuDDJXS2rc19fDDgvCqxHFH+TltzgQ01hLbDd8q6pfgGT
	 L9DDlBxCV/iV3/8qmG2KHwQfbtJiXtCyR1iZ4Z2iqIgCApHJYpWKeCEBrhR9DwtHyPBPP
	 Cpvw7o/Z0Yq7p1V7eZKw77mRtzL138HyiSDkmITlHUmVY/EnKBggE/dBiEp+hL2czjOiq
	 aZPYrBjXVxghkwsVPfee9Fe1wUo+Jxzes/4paA9FCnqYDAH9NHujNqSKW9hVFehbNgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793261994;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=kXOqiSQJA94Tx05bKB7kJ8VRta93p9NNx4w0EZdrfVc=;
	b=naxyKFtdJA/tPlFbCNiDxx6jDGEcXHk4WUb/NCIBfFKDFyffCUKL2zMLktRjECjjkh/b
	 8okK/U1mfgi6N2x1yN3N400UTVX3v52yW87yne/VT8/RrQzOhnLefDhj+t+XCFzyM4DOR
	 NEBJllRFsBNx1cOfZ1Zcx0SjyiXPKDtS+o7snkkAdi/16oSqteEir/abpZQ4PYZkIyWw0
	 fZUs8xOj28AmBWZRUy9wanMWIW7V9Q53tm6xWZsH+Xo2T3PpK+vT+ogE+yrGXVIhfwQvN
	 PtA9pA5FuXI2em4C907NnGEGF89j2yekPHC2+KSK3NzE5RxpFNxoA80lZJixnF0BvNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GK1lp0E2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81649606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 08:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GK1lp0E2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418B31F031E2
	for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 08:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793261994;
	bh=kXOqiSQJA94Tx05bKB7kJ8VRta93p9NNx4w0EZdrfVc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GK1lp0E2ZVQQN/J04RE4C/lvLxHibbe40AgtuYSwZPkAJOGVZSnqYAECnOY3lVD1l
	 +Eg4vQGaBO54lxKXVlbN207sUd3AX+qE9aVExH5GAhhhmFCCcIX5TP70lnJzUfjEtt
	 SFJA182NbneiLVG49jQVj7NXtW7bGV651KwzJwjNXvmX2xB8EHBBIaZ72GE6Cv5iSH
	 bAkiV/ykVppChRs/tQfp7Z5N5BPMJHQln07U120fJv+pE2Fn87e/tXGt9XOcelTmnc
	 JaxeRIZinDw59TN4d9PBNzQ5Aoy7M3mUYopDig1BhTuRWFeGUb03E/T9Pg9IApZiLM
	 4FSWuS6jKL32w==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c315869241fso284336966b.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Oct 2026 01:19:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxneYocjHzGnaaj8P78RUzdagq69jcd4gu5FkPvvAI62kZRZUt3KV7HrZaAGBvz9V+holpPYEx41inG@vger.kernel.org
X-Gm-Message-State: AFq9FYKC21leD9WHu2PhMGZt9tHaBKJ/tvCwdpF4+udCkPC4BwhjeTqW
	DHGdwmnfO8iNBKXTEXkcMhzEQV+KzB9XsLe99/bkg5CRAAUae5atxuqQtifQCNz1JpXgJ/RkNdR
	WDRwRMf22vp52x5QfO/EsbCAaaH3hjWw=
X-Received: by 2002:a17:906:7312:b0:c29:6400:ef8e with SMTP id
 a640c23a62f3a-c49bdfd2fc1mr411845666b.42.1793261992920; Thu, 29 Oct 2026
 01:19:52 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261029012803.222197-1-icb@fastmail.org>
In-Reply-To: <20261029012803.222197-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 Oct 2026 17:19:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_pq4_7MRnaLnKm=fz3BBTsY_+qagSo6jQZzdt-Z_EOsw@mail.gmail.com>
X-Gm-Features: AclHuK8JTTb6utrReJCmF_HwXNkxb--l1xkkIjG1hxGS7h3OLv0cKs-DFK7l2oY
Message-ID: <CAKYAXd_pq4_7MRnaLnKm=fz3BBTsY_+qagSo6jQZzdt-Z_EOsw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: revert fsids on durable reconnect and replay failure
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 29, 2026 at 10:28=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> On a durable handle reconnect or a request replay, smb2_open() switches
> to the SMB user's fsids before calling ksmbd_vfs_getattr(). If that call
> fails, the code jumps to err_out2 and skips ksmbd_revert_fsids() at
> err_out1. The user's credentials then stay installed on the shared ksmbd
> worker. Later work on that worker, including other users' requests, runs
> with the first user's fsuid, fsgid and supplementary groups.
> ksmbd_free_work_struct() also warns, because work->saved_cred is still
> set.
>
> Jump to err_out1 instead. No path is held at this point, so skipping the
> path_put() at err_out is correct.
>
> Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
> Fixes: bb8bf7eb13b5 ("ksmbd: add SMB3 request replay support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
