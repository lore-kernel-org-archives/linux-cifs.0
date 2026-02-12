Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521FE262A6
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 23:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770938422; cv=none; b=rHbG1LIMarHcql271Ld/VevmsXgz5vO2dBYpFV0Nl0cskfYsswx7IkzS60tFDOs6tw+Sa8om7C1pXhJpKJgBCUf/vW0+a5/ghFaSYu6hr6J4hb4/AlpR64o8b5/IrwRNU62HSuOOXfpU2679XVxJLL9yjT0qYUGz3QPEEl2uSqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770938422; c=relaxed/simple;
	bh=Tm0bOX0x2EVuyzfsnCycoBmlvuXytnXm/iy4XTQJjRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gUoftKW2f+HSewl1jpfnnItqdxn0olHdrNGuXd7KpSvA2xLe5/7TXuVE/lFvGo+qf25QEUfs5cM3eWhNASgEbopSWLEYbwDnpHhv+gj3JNGsRKIbzKT/3gE7QtMSA7ChRsE/LBYIaofBKeEW06Y43eKFkibUG11+OjQi/5smfkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z9lPN7Dh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z9lPN7Dh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1842C4AF09
	for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 23:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770938421;
	bh=Tm0bOX0x2EVuyzfsnCycoBmlvuXytnXm/iy4XTQJjRQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Z9lPN7DhpH1jcKYeyhr7jXrda/6JGg5r4NDPqNQHALxN2U6avHldtLMr/NcFMnVoX
	 i7E6smpkbCM7pqAkNnaprxH7oXuyx3zcIMPwdFsd7VgyDtA8Pka9XuqlwnzWE/RlUt
	 5tKd/T0v+h+DYVq9a4GfoJfOaUWtOHkLPtXhScmnSJf6IIR2aQMsqgTazUt94HxTUW
	 kCWLS0W/WqXUV0Lnp/0O0G5NDnek3vRhOOR+z7MFD5ouRE07fwWNwSo0jle0NKskWw
	 PUtNGOc/dWIlNbpJTNgkR5k789xkFq1xp7TzQlpOlA+2t3t7Bf/STAloc69mqpJ62B
	 ghb7IfmiVvhHQ==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b8845cb580bso45267566b.3
        for <linux-cifs@vger.kernel.org>; Thu, 12 Feb 2026 15:20:21 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX5ESEA/ATOhjpXPHUa9UTzSzCDgSBCYkXj+huPf46auEsA/FfK5BgKTzt3Jzf+i92HnJvfyLbujlBf@vger.kernel.org
X-Gm-Message-State: AOJu0YzvV3WQ+bQJn8aR/7xrsHjngZXKSDRlehMKrpm9+XUhtF2j+6Ve
	bKStBr7p/LJ9r3k7vGjM/17jg9ZN2y9jDIbXsedsDY9SD87Y8xGQVueaO0vUh2EOtkzoF9G6Er4
	Nl3s01Qg1bde5F65Et8R0zoP2oe8IrFg=
X-Received: by 2002:a17:907:7b91:b0:b8f:7014:48fc with SMTP id
 a640c23a62f3a-b8face62507mr28327766b.57.1770938420436; Thu, 12 Feb 2026
 15:20:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260211045533.2936005-1-nichen@iscas.ac.cn>
In-Reply-To: <20260211045533.2936005-1-nichen@iscas.ac.cn>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 13 Feb 2026 08:20:08 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-_pECL102aT+8drzonEeMSyzTAa+g6KqpnChkpT=uLGA@mail.gmail.com>
X-Gm-Features: AZwV_Qg_cdtV3cmRS67-Sc4kKiHXEaSM4KmTyU-Y7eNbJuWjr1jL0XlwkkvQaNY
Message-ID: <CAKYAXd-_pECL102aT+8drzonEeMSyzTAa+g6KqpnChkpT=uLGA@mail.gmail.com>
Subject: Re: [PATCH] smb: server: Remove duplicate include of misc.h
To: Chen Ni <nichen@iscas.ac.cn>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org, senozhatsky@chromium.org, 
	tom@talpey.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 1:56=E2=80=AFPM Chen Ni <nichen@iscas.ac.cn> wrote:
>
> Remove duplicate inclusion of misc.h in server.c to clean up
> redundant code.
>
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Applied it to #ksmbd-for-next-next.
Thanks.
