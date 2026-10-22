Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792669708;
	b=rRnqMMKf2WwsNKY+pS58YvLpZkCpFjEQJlAeYjPWSs7l1yTtFNFjTJKT0zN/xKINgqSV
	 su5XbwuukgYk/ABrufYf02bNieJ7ppMNRys7IKQTtMYQU8hmE/xlyonVuLXUVhUqFma8H
	 6beA00rXMfITGZcewfG49H2OM5XSyjoB0lSg6VWEUgJEwRa/gvvQm7yDej2IddSqQh2bE
	 kFA0x/5Z3Wny2KgYDSqU+2ljkeVobhD2Pj8pbN6D0cC7UQiL7gzsA7xip/Tub6necGamQ
	 Dxbsin94qve5aqm2KuhaquXwiA/hjvhLU2s4u9SVHElozAmDn77Ke7tVkeHIqjVCW6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792669708;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Oh7rrgGUJ4JtljrvDgVPIYGbh4nki2Q2qiaFyL6YTYc=;
	b=w7i+cPfvlabg/9rROm4sdqvCQZUBn1+YiE8xAWx9rQV+kImSbLw/1RYRnOhmiPGKummb
	 tWfv64Kw03Cy1jwq+IbQHGfIFEh4SkLyn4GxOsfkQ3XlUcdrnbGm/GEO1a+WseSqlaZ56
	 b836JqpHcSAv51W/94UhvWnTBhUOLPNOvDwP0osaQXH8bJnYBQnd+0q/0RjecqYebkm0E
	 91pA6FnERGEydIqjQ3XfRKOG8gYjdhOTsSbljKd0Ubk9kCPkIgjXLdVljwoiHnyZUMdBZ
	 RiO8XJq6CVaG4Rx+ER9SvnL0RbmF+Vy5edgIA6Ivmf3PZbfOGYkioXmrdTxq6WZc/nQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7jW3z7G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0D5606A320
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7jW3z7G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F9D1F000C5
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 11:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792669708;
	bh=Oh7rrgGUJ4JtljrvDgVPIYGbh4nki2Q2qiaFyL6YTYc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=A7jW3z7GJlsaRW5WpTm2sDkx3AsgrMcmbFo9DSA8T/7Z27lSmp2o9LE0GvmTiAUSw
	 dUdqD6LkpORGJvNREWB7+i0ruhksdfvclfc7vhMBkcc5H6tLbz6WH12uuKwHVwe4z8
	 yicOcN1ugL61374GReyN8YCR6TaaeYCytVrkwcKem7ckoT0uzGRJg0oeodpCoPBuPS
	 o+K1WX4BrvyRi9UFPltUhGFq6mAg+vNCVoq1B7Uc7gmFunBOnrClS8okF0hgnrFMNh
	 sH0aKZfD0WYxh2YRxezAeFcY/tnstVV03X70XYbB1KAnhJ0M7QXDYq1Vp5W37ayjl6
	 VHBhGQ9ZauPbw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2acc1e170cso251515166b.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 04:48:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxgDsB7Bq9NIURYJpb9xm6Ls+t3Kb/amB381Fy7eRT8bY7j6EtkfciJA3CyustKGRIV8Nkzfk9y0nxt@vger.kernel.org
X-Gm-Message-State: AFq9FYJkR0mOUcb44AP7l2l9wJ1H8yTi2DCvvnO+XSEUNz+hPH2vvQhG
	eKN4ycjCtObY2J/W8Ke2ozDB3Tp4XqmDvr5ntZJkGsLdkkRDeUaI3Is4Ngtk04t2408t3UjqUQO
	0w4+49aJGb3CEZZg+Sw98Zr5TqX5OWww=
X-Received: by 2002:a17:907:3cc5:b0:c40:231:6eab with SMTP id
 a640c23a62f3a-c467961c72bmr533703966b.16.1792669706666; Thu, 22 Oct 2026
 04:48:26 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021115400.30885-1-mike.michalo@gmail.com>
In-Reply-To: <20261021115400.30885-1-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Oct 2026 20:48:14 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9_B=QvrmzV-40HGwt=tuw8nZC2ZhgjrrAgOJFhGBKo2w@mail.gmail.com>
X-Gm-Features: AclHuK9_GGVxl8eUb066-OANBotXn2OW_iZaRg71kLZYQ9bJ0MjX7XK_lH9Uwks
Message-ID: <CAKYAXd9_B=QvrmzV-40HGwt=tuw8nZC2ZhgjrrAgOJFhGBKo2w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: restore Kerberos logins with released ksmbd-tools
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 8:54=E2=80=AFPM Michail Andreas Michalopoulos
<mike.michalo@gmail.com> wrote:
>
> Commit a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets
> expire") added a __u64 session_expiry field to struct
> ksmbd_spnego_authen_response, growing it from 156 to 168 bytes.
> ipc_validate_msg() requires the response to have exactly that size, so
> the 156-byte response of every released ksmbd-tools, up to 3.5.7, is
> dropped and Kerberos session setup fails with STATUS_LOGON_FAILURE.
> The other way round, kernels without that commit, including the stable
> trees, drop the 168-byte response of current ksmbd-tools master, and
> ksmbd-tools has no way to tell which layout a kernel expects.
>
> Pass the expiry in the reserved area of the embedded struct
> ksmbd_login_response instead. ksmbd-tools releases with that area
> (3.4.4 and later) allocate the response zeroed and never write to it,
> so they send an expiry of 0, which ksmbd already treats as no expiry.
> The response is 156 bytes again, so it works with those releases, and
> every kernel also accepts a response that sets the expiry. Use two
> __u32 halves, as the reserved area is only 4-byte aligned.
>
> Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets ex=
pire")
> Cc: stable@vger.kernel.org
> Closes: https://lore.kernel.org/all/CAO+rqLhpPvY0NLrAnZjFXz0gOXnA6zsXxK8x=
CgtA42XUkSsAeg@mail.gmail.com/
> Assisted-by: LLM
> Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
