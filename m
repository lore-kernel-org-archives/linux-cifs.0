Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794322061;
	b=QuB81CwoBuYWvhrhEoDUiWTMqRFPnKCCmSAK6QZR+IEdtQRWQjeP004oRAYXs3mSBWEA
	 IA/NJoefqnRFdKiDylhGt7o/5zTgH8XO0JrWIJqjs8ugiakaA/JAq/LiT79rWdXj5cvHk
	 W17E9L2G1aIMBP6ROfXTUU4TVhqObfj3+nfPjhBe1gE7Bw7oCQFxb4LfO/t+qtgx112Hg
	 ZR6Z2ETDCH/p8HHrhI/e039ZHmqXzuuEeoKFM3zMm8yW18y2jnxrH4hbqvR8p0y7relyE
	 +BO2XjGGIVzy4ktF6uXB/vWRuqrxmE4sTEL/jPFACb98VaEl1qsP827ruYNAN+S4EZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794322061;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=KyXEQvhhvbYBNTKWxtCEeL0C1VjaH+7m5+BuhzMfTsA=;
	b=ZH3pPyZXy+Exiq9WG38XaCFLMXjHOQOHv26sJCUz80x7KhESZJta+a8O9iTz58vpuVa8
	 CE/kfS5Mu0erL0A+5L/AbtHdHFiSG/NynQFo6I2wSr6iK7BsoYi/+L2EixWGLUnboFFaa
	 s96yMRB9ZMyYbxRloMQXPH7FF+y1LayKuX4uXZ+nkhKIurhHl80ONyePmzScnhmNz55Nl
	 8oJ+FNTiGw9SbUyBPtbagEQkls6/8nxGeGHNDegY3IzsLb6VlcDWcJarB+zfIhCXwu7io
	 ywV6dYsvefYipap7ld41c7sieN8d7yMFn3cYbFAgXBQpR4PwR6G4xiiwocuCgTMhuNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyoJY1r4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00D760A2604
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hyoJY1r4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8235A1F00902
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794322060;
	bh=KyXEQvhhvbYBNTKWxtCEeL0C1VjaH+7m5+BuhzMfTsA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hyoJY1r44Hfo4INbPlsaEsvNsouafEabkAWIXoqxv6HldmSF9wgi92NBH9mO/NXqP
	 7ZS4K7tjFi+7pjONpCukTAKCDhaBwUkA8kiRvoF7yHAfX41EIIMigvkiei33wXssX4
	 uzQcPUOQQDArgOnHRU0t5I19+eV/gAVW69lHZO3tXsRtYJiHFAebh44T5BS4Vwb0XR
	 Q/NcabtsfRtTGr8c9BgE7i1Iq0aGQJao3PTPHEQQ1ApkndV6sueCbjGi1Zyuyh+FmF
	 9DhXQUflheQoiGd84kl7TIBUb+cNwy6/tFV7HQXfEIyMoYTdNqW1ZVyHtB/wECog78
	 Kv8e2HrnDUwbA==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so3269014a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 06:47:40 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFGlLk8ra1U8XW9PvLbAd/WhEj13Fq7TqPaJZuD1bhagdLC2vyJD67A9qYHr+ZE8u1KtKJfM226uLRL@vger.kernel.org
X-Gm-Message-State: APuU4Z9yHVGcW4TCrszh0mJ/m1N642ma0SEhm3EGxpHPtG5HQlvAsRNA
	fO6z2FM51nH/4BQieh2SxPft3oBe5vy84oAjgy9gyBLi+3DO+XPmtjuarCGweLdYFzqQD5SA9vi
	WkVS5zsC1SV1j+TzdonAIyDcmY+NrOW0=
X-Received: by 2002:aa7:d582:0:b0:6b4:16fb:b9ba with SMTP id
 4fb4d7f45d1cf-6b756b05b75mr1604589a12.36.1794322059147; Tue, 10 Nov 2026
 06:47:39 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAKYAXd-Jo-ObBDs-AdGfaM+QmDsot3gj1g0oJiyDKczoUDg2TA@mail.gmail.com>
 <20261109194144.22814-1-mike.michalo@gmail.com> <20261109194144.22814-3-mike.michalo@gmail.com>
In-Reply-To: <20261109194144.22814-3-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Nov 2026 23:47:27 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9FgSFui-RLdywqyciBdxcU8_xZkfxap+qQK=evVqNYqA@mail.gmail.com>
X-Gm-Features: AclHuK88dHBDDOu7sgSeVl2Sdnz_lJKjB9tYyeuwVC2odqDlQh0fO1-02CBID9E
Message-ID: <CAKYAXd9FgSFui-RLdywqyciBdxcU8_xZkfxap+qQK=evVqNYqA@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: stfrench@microsoft.com, icb@fastmail.org, senozhatsky@chromium.org, 
	tom@talpey.com, chenxiaosong@chenxiaosong.com, ematsumiya@suse.de, 
	lsahlber@redhat.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> +void ksmbd_sign_smb3_pdu(struct ksmbd_conn *conn, __le16 signing_algorithm,
> +                        char *key, struct kvec *iov, int n_vec, char *sig)
>  {
>         struct aes_cmac_key cmac_key __cleanup(aes_cmac_zeroize_key);
>         struct aes_cmac_ctx cmac_ctx;
>         int i;
>
> +       if (signing_algorithm == SIGNING_ALG_HMAC_SHA256_LE) {
> +               u8 mac[SHA256_DIGEST_SIZE];
We can use SMB2_HMACSHA256_SIZE.
