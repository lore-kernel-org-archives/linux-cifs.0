Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706832A1BF
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766977116; cv=none; b=bwdrb5hAiFcm00whA+9NfUamVCKiB0XjwIJyTmESoZJzzg4z9lUNzPjQZTWy0hulwo+dRhxgWNDpLLgHOnj3bxIxlubBIqS+MAtkyACGbsfDOHMSg2xOOTpwCWC+iDE9A5+JUkvavzJ2I4Uhads20ChP4Q9bCS84NTncLWiiBhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766977116; c=relaxed/simple;
	bh=Ri0wpBdIuUZ/4R5PVmvD9pEDUB8kReSZJRe5qvO9RLI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LwlFgjek5AaFJANtq/l3rfeaD3Jgni33PlBLSJCZxmKSaNAecdDigZdgsxv1QQ5XdJR5vqbcCv8CTSPpDRvVZEpvx+lu+HdWQhExA59kbsvdghQW14rNt/19cxfvjtvlFAXQMArp176kFv+fUWMXzn28vUcCPR/f1DjQEHSqWkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hF65Y4+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hF65Y4+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8F3C4AF10
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:58:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766977116;
	bh=Ri0wpBdIuUZ/4R5PVmvD9pEDUB8kReSZJRe5qvO9RLI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hF65Y4+5sMUUmfTYv+lYMPmQA9RjoSEYCF61vRW74y6heAN+gDqLTcW96eYhy1o3v
	 ZNkORJmafzGGClBI/UUywWBUyKhXKQduOi2OZK/rvzaI/XwvQOP0VX1vRe1LiYoG3X
	 3PzL66x4TNTJFNgwFKX7/wuD+TVN2OOlKIdcoyuyQgA8PA/QrijSALR+tf7/zNhRlz
	 T6s9sRSr4wy0uvCkwVYt5M8Y0SmG68a/w+mCXz/b75FFq/7LNvJZF8EueEcCQ3h4Tu
	 J0mh0KYdMLrz5atlrdbr59vJdFl5k9CZv62TUqHU1wkoEvmE1nsxCQaHGNgbZmBAco
	 zqNHYdWWVKe4Q==
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b7ffbf4284dso1133865466b.3
        for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 18:58:35 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXfxCU2tArHSS27dBC8Kjn6zNiL2SWyb3L6cW6XUjCwrdMtfRxlcR320LjNmSom01CNZ5ODUK0QrKqO@vger.kernel.org
X-Gm-Message-State: AOJu0YyBZx+7ZrFpzrQSEbBTggNJoTn4Ei0w0xneiKWGOOWRoimzWMPp
	Xkw86VMIv5YVJcJ45MraRbYI+Q1H/tlZuKw7ivsPN1C3zPkuz+NbnQkbo155b/ciL4Tw7+cNGKv
	pUGtYemGuA8qUET92JKuFrzTO0rhz//I=
X-Google-Smtp-Source: AGHT+IG6jppezIoOQ8FdNRZIB6E6J4N879smmTSgSrXt53MaZPWpEQqNVQJ6bsug0LVNNVgOr1yCBX4J8IpNNHxJAzk=
X-Received: by 2002:a17:907:d8c:b0:b72:6143:60c2 with SMTP id
 a640c23a62f3a-b803722fd2dmr3100261766b.51.1766977114610; Sun, 28 Dec 2025
 18:58:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251228145101.1010774-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251228145101.1010774-1-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 29 Dec 2025 11:58:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9Su4zWzAsh1DOyrYHwz+XKzOUpqsrMWCGKdEUorLgYyA@mail.gmail.com>
X-Gm-Features: AQt7F2olrhjna1mkIizsXpsfflG1OsmzfN0e9nhTnKXpmg3YEUIL6HCql5YEKe4
Message-ID: <CAKYAXd9Su4zWzAsh1DOyrYHwz+XKzOUpqsrMWCGKdEUorLgYyA@mail.gmail.com>
Subject: Re: [PATCH] smb/server: call ksmbd_session_rpc_close() on error path
 in create_smb2_pipe()
To: chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 28, 2025 at 11:52=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> When ksmbd_iov_pin_rsp() fails, we should call ksmbd_session_rpc_close().
>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
