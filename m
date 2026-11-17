Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794911723;
	b=Vn8TXGkE88Vdf/n8hI67dEsFreB1+SZspXSBXJ1d0PS4XHJk3lAzIOJOfvI2U3rQPR9+
	 D4jfAI/ZbkyrEUWdQvaAXBO6uIjQ6bgrgvNQpREvm35hayoXQQIvOxp5Inyfe4XHubPzz
	 mikMNI/Y0eCrh1MIbu+R0WNztKRsduf0jhPwzF7lcTGHvt9EYCyiWBPYteoOj+0sWkk8V
	 IKEdUv7t9pKdxPHHTbiR0YPZWYajFqfRh+YjHD8bOn4UbVyoMMgK+jfO+RH+5xG01Hlj/
	 WXT8j7y11Cf7S+EFDjzmBZAUKgv1fZS2BO3zI2GwKRO4QoOBpCr0HmrgDW8V42Yo+Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794911723;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=IHGUzUmVk5oe5rUf0aoyRCacAxahSMOILQF7dcXB8Sc=;
	b=xtUgfcmTLN2tEjblCnpDNjAZOZqpaWeEI4lM+t2cNbnx4eM2PJClwzhFLdYs47c3uPi2
	 KoTgpGCfa99dTPhWpZB9XdX9vvxvWonwYDYGYFMX0MnOOEwh2TDo8xRQyrvuod8Z3xyCy
	 ny1n4PSe5ej0IDxkrBA/+1yOaiA8q0LlC4vDGsTRWLRc9ds9PeyTh0Bmka740kefi92Na
	 4JxUhpjRRZDoaVoLwUnwZfPeUEAN1Wmlji/RBwu043o85cImPsgvmzafLYdHFFylJaZtY
	 EQb1yPlmWnGUspMW8ab/2qwhA/WIwr/maTbmQe8dxERbmXxOcNaPo1lw3Jjxyg/klrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a1lrPGZl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB9F606A32C
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 10:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a1lrPGZl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF8E1F000C6
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 10:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794911722;
	bh=IHGUzUmVk5oe5rUf0aoyRCacAxahSMOILQF7dcXB8Sc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=a1lrPGZltx+6LgllY7n+YDfYeHSA3UrljsIPJEnL3vb59HUx+Tdjo6qq12fOy0qRm
	 MdpJM/jJjcXgUEuQcquzspq0HSmFoOGARAI146Kin1drUQYRTIJnSL/osqIJQpf1HV
	 Ootc3EjbQZd+XwNpCl8StG1LEHPtnSyimhJCd4ea4/Gd+IshOvK1YJTrb77+CLuO0O
	 vQh/IKQc9VT1LfhiyLFBilO03YPNmyOnQevuMSaEUa1Ui9bc/f22ze5Nj6xe13Wi6L
	 gnC2mjfLQmfKeI4cU2kXtvTx3cbWsWqxNIY55DNRoe1QFYbrGTkPs2NKKMOLG6XuNY
	 Rdxaz/R1U6/7g==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c50cc8e0f84so327810566b.1
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 02:35:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHY1RVZY2wc96S0L8OpAPY7/qfWJ11psghXEcsNRoBtSFLtgkIRpHnrHXcsQAO8uEkn8bdexVjDR0bf@vger.kernel.org
X-Gm-Message-State: APuU4Z+ZiJufEbPcHxnWMbCtN5qZ+lArYvIK4NIauUmvLT/T2zwlJi/4
	oFHCQZdv+5j7b/2Gya/B5iHfbV76hDDrhiYskmHt7X6Wc730Yrj1Mm13/kFtQTaUs/6NISZpnag
	PMY9dSS6BPYz2+dOWQ6bX1zWTRZFdhBw=
X-Received: by 2002:a17:907:3e05:b0:c50:475d:9804 with SMTP id
 a640c23a62f3a-c50963dd2b0mr1122566566b.13.1794911721220; Tue, 17 Nov 2026
 02:35:21 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261117042341.4023597-1-hj351016@gmail.com>
In-Reply-To: <20261117042341.4023597-1-hj351016@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 17 Nov 2026 19:35:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd96-RaGbakDedW5eOgmV8JUhAF0_25qXLk2YimiT4wngw@mail.gmail.com>
X-Gm-Features: AclHuK_hFq9ocfYBKpY7Vyublut8aeIAWeKtr66oToFWJPZgIzp2Rcdnoj4Eya4
Message-ID: <CAKYAXd96-RaGbakDedW5eOgmV8JUhAF0_25qXLk2YimiT4wngw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: reject SMB2 read on a file opened without read access
To: Hyunjung Ko <hj351016@gmail.com>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 17, 2026 at 1:23=E2=80=AFPM Hyunjung Ko <hj351016@gmail.com> wr=
ote:
>
> smb2_create_open_flags() maps a DesiredAccess that has FILE_EXECUTE but n=
o
> FILE_READ_DATA (e.g. FILE_EXECUTE | FILE_WRITE_DATA) to O_WRONLY, since
> FILE_READ_DESIRED_ACCESS_LE does not include FILE_EXECUTE_LE. The resulti=
ng
> file is opened without FMODE_READ, yet fp->daccess still carries
> FILE_EXECUTE_LE.
>
> ksmbd_vfs_read() only checks fp->daccess & (FILE_READ_DATA_LE |
> FILE_EXECUTE_LE), so such a handle passes the access check and reaches
> kernel_read(), which hits WARN_ON_ONCE(!(file->f_mode & FMODE_READ)) in
> __kernel_read(). A remote client can therefore trigger a kernel warning (=
and
> a crash under panic_on_warn) by opening a file for execute+write and issu=
ing
> a read.
>
> Reject the read when the underlying file was not opened for reading.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hyunjung Ko <hj351016@gmail.com>
Thanks for the patch. The same change has already been applied as
commit 2fd145f8865b ("ksmbd: refuse to read a handle that is not open
for reading").

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/f=
s/smb/server?id=3D2fd145f8865bb1a6c38a3dc68fa44290008789d8
