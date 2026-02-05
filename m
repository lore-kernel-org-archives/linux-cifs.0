Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED6A13A244
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 00:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770251913; cv=none; b=RMk/4S1hohMu64oRDltT+s0TwUZirDxGWyP0AuSVoWt2OovGpwHP1RRS8W4t1bQ4GQzeWTWwGrONlg5vgcyqj7OK21hz/YiL1gCaY37nYVZjZ1bsEgO8BhYJQChoilmYPNbGIrZrUN0d4r9Ud1bw0yKTLA81uAATpvBitZHS0/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770251913; c=relaxed/simple;
	bh=+a4nidgfFaCoFca3mcn2cJExAPTlfk87g7q+Mh9VSho=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lmU5GG7kdJQ64Y29NY0LAzNptREeCbkLbhRQf4k5V4UKq15WSj41YSJ2WZCNUxcKgH0hA8g8aHzXUZpjjD8QyIJKQ9hUWtz/8HfkwyfZKckGb4x5vrVsaGNp+OPTTw2qS7LHEP89AQkayeCcgWTKRwS7YKiDG6Xv9sdBo0MuDMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B50tG9/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B50tG9/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66860C4AF09
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 00:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770251913;
	bh=+a4nidgfFaCoFca3mcn2cJExAPTlfk87g7q+Mh9VSho=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B50tG9/077nldiCga5MWFBVCZommaIRpY54grguMgH9S8C1ka9WJ74i7piX2QZj4x
	 FaqJljsRmBlSfUtPAhbsYFF+We20/nqz1tehT5wkHldDtS8eOfVdahJJgeXtue6P6x
	 PI32ALbkCLEewWQ1ubHUaQCnremgWXxTBxR+2LtWzifx2kKG76RMs4ea12cwUU54uf
	 tOaCjF7i9Cu9/8NfSGG7KSSQ0TDIXVTTmBY13abEEcfLiLub7omzo/NQTaLY2rU1bB
	 TiFwOxExmx4i4D/pTtGm4bLy+vwK1kkQ+wb/QNBVak2/P47gvHybNnuvdsh4z95CPp
	 CMd4lRebjyv9A==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b8845cb580bso58812866b.3
        for <linux-cifs@vger.kernel.org>; Wed, 04 Feb 2026 16:38:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXGR/LrPCyw9M5nuM6lKfQiiBvK59GfzlihADVJxHLBK1AdwxCTWijMeVLFXvCTKzv30TAwUuOQvVz0@vger.kernel.org
X-Gm-Message-State: AOJu0YwmycXTzGf+YsK8aGjyWxaKPfVlplhHxSEZud+tbOsFnIakL+at
	nEC1XvWVQjloOL6qNXa6eXIiaH8gN9fIPXsFWFALrHw1FL1Dq6JJz1ch+LMcsWBj26VLJYn0wed
	zjdggsiFxzksfZVjFpexzVxlOsbokw00=
X-Received: by 2002:a17:907:9405:b0:b8e:5e2:79fe with SMTP id
 a640c23a62f3a-b8e9f0a7b29mr343960266b.15.1770251911905; Wed, 04 Feb 2026
 16:38:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260204230643.387345-1-henrique.carvalho@suse.com>
In-Reply-To: <20260204230643.387345-1-henrique.carvalho@suse.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 5 Feb 2026 09:38:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9SMURYO5HNLh_tZfju=OnYiGqdLuDmRr4gnDZkb2bQ_w@mail.gmail.com>
X-Gm-Features: AZwV_QgLbCcVWeIxytf8GRNtA0kX3BqLBfCf2VKNeHyaBf9a5ELyU_fsEOxI_LE
Message-ID: <CAKYAXd9SMURYO5HNLh_tZfju=OnYiGqdLuDmRr4gnDZkb2bQ_w@mail.gmail.com>
Subject: Re: [PATCH] smb: server: fix leak of active_num_conn in ksmbd_tcp_new_connection()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 8:10=E2=80=AFAM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> On kthread_run() failure in ksmbd_tcp_new_connection(), the transport is
> freed via free_transport(), which does not decrement active_num_conn,
> leaking this counter.
>
> Replace free_transport() with ksmbd_tcp_disconnect().
>
> Fixes: 0d0d4680db22e ("ksmbd: add max connections parameter")
> Cc: stable@vger.kernel.org
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
Looks good to me:)
Applied it to #ksmbd-for-next-next.
Thanks!
