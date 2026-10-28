Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793189076;
	b=LZ3Ocp5TsFumNLAm3SiPAxnzIV8T1dZd4r8fx79hLih5G+az/5wrqXC2/gYziveaAwqv
	 q4mfnsbCdnLXEe+qVe5BpQR40WiGDwwMVhmxWtKXgsMf2VM/gEuq2sICVirtZKCb4pNJx
	 oRw2+sBoUvZxoe8celfgCc//duVzdSE8arBBATsHnl56njIrfaw6oWIKLZhdntpGfBquF
	 M83QYH8TDy+oAFaZcFJUeTcmq9oUZfu+ZdAEPyFallGn6NFgGFq8gCGFwy1Nt2w80Pm5y
	 yTVPPGTVDFGxj70RNpt6gUzaYDpUhNHpnFkN/gkr8r3b8BWt3j6U1mko+TZZsreUrAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793189076;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=0E+KQnN4HyFW/arQzwHlg5y2aXSuNq27FTpVp1Rn45c=;
	b=Yf8a7Ek4CO7sDyS6qz6l925h2pLCcm9+jTxmpFCuJSze2L5BX3VftBWjDrGq1139mZdK
	 z3yzhr2h5v3/jGPKHkjws7QQlJcRs7k93EAoSTJH+EA7ezVe0tUWiJqcpXUIjBdU9XdrO
	 qeRSEcOb0yc6NxypF2oy/HCqZzwaRx516W+QZsLJkmCyA3/gBqUJKkJr4xCf8/AgXT1Uk
	 7e2+nkCTaTO7t/BjXAtVwvl6q/xyXyuV52Fa0kpqF0tfrHoW00Y6mdzl5a/ujQqdAGdPd
	 ZFAo8Os+QNxK2USMEn9UjWS8AN9vmX4yFcMAayS9P2PdupAcLO9E7GTgeJYXHIFA25Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvkRfbjU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731BB606A31D
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 12:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CvkRfbjU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB5B1F031E0
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 12:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793189075;
	bh=0E+KQnN4HyFW/arQzwHlg5y2aXSuNq27FTpVp1Rn45c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CvkRfbjU3SfRWQOtdPPV5jGudkOU78KUeR7AZIZZdUKNky5faWGpDQE7zPyS3ie4/
	 tuN0r5ubSRJwtKU1CTZgHkr/UcH+eHmhe5+DqEfyMpCbGyVymvib/aFoUeKEsIXEAJ
	 iHzsZb7aC/CuxirlDeT1XoFVgFp7dwg/7jNZt6GRG324LzTTxRXoIXbLq7Cjnf5D7H
	 DBN44oGkcsFE5seuJYUCoGFlkY32wDVd/iHMtSKxYty9kdSWK1Xw6dxJjhEAVr1Q7A
	 wH97JyiXGrJWLjeugvpanIvxvTH/q2Q5uvLNnONgpCYAHXwMn1QJ6w0y8ljyhJw8c7
	 VAkuNVnbCPy9g==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c37b612635bso109427166b.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 05:04:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx8dbWYHua1Dp500mKVv1fazq7tDQM0Vu+X1Y8H6jlHNRwYLuFnaXVFlsVkf9xdertnKwbI9NwBwrr4@vger.kernel.org
X-Gm-Message-State: AFq9FYItkPHRneUkXkJY3NhKRjjrIoRX4jpZ8dvMgkCVjjlS0JOyi6In
	9B+d0PoIot3bICIz1Vm29/da/jg4Jadb8ikHP7suLE///L9lSRzI9oYd7WlXT7Hti/z+Mtf6gbs
	fmCVz9EJeQgD98cIjbbBT8VeQwY+xICU=
X-Received: by 2002:a17:907:cb88:b0:c40:80eb:c544 with SMTP id
 a640c23a62f3a-c49bdda7123mr179996766b.4.1793189073972; Wed, 28 Oct 2026
 05:04:33 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 28 Oct 2026 21:04:22 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9pbMrBHmSH7SSj3GkGqtPJkFTek0+MFcpyELReTE_qUA@mail.gmail.com>
X-Gm-Features: AclHuK8N0PsGjJsaJNMA5vL3XjNKHvSiDgzmxoiSwLy1P98IH155__Zp5wQQG2M
Message-ID: <CAKYAXd9pbMrBHmSH7SSj3GkGqtPJkFTek0+MFcpyELReTE_qUA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] smb/server: change notify support
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 25, 2026 at 5:35=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> v1->v2:
> - Patch #04 #07: fix LAST_WRITE and LAST_ACCESS notify event mappings.
> - Patch #04 #08 #09 #11 #12: limit notify event memory per open.
> - Add patch #13: support change notify for named streams.
>
> v1: https://lore.kernel.org/linux-cifs/20260926090518.78547-1-chenxiaoson=
g@chenxiaosong.com/
>
> TODO: The KUnit test cases are still being modified.
>
> To test this feature, the following patches need to be applied to cifs-ut=
ils and kernel smb client:
>   - cifs-utils: https://chenxiaosong.com/lkml/cifs-utils-parse-notify
>   - kernel smb client: https://chenxiaosong.com/lkml/cifs-improve-notify
>
> The complete kernel client and server patches are also available at the f=
ollowing link:
> https://chenxiaosong.com/repo/linux/ksmbd-change-notify
>
> ChenXiaoSong (13):
>   smb/server: move change notify handling into notify.c
>   smb/server: add more validation for change notify requests
>   smb/server: add debug type for change notify
>   smb/server: support non-recursive directory change watches
>   smb/server: support recursive directory change watches
>   smb/server: keep notify watches on file handles
>   smb/server: save simple notify events
>   smb/server: save old names for rename notify events
>   smb/server: match rename notify events
>   smb/server: encode notify events
>   smb/server: send notify events to the client
>   smb/server: break directory leases before sending notify events
>   smb/server: support change notify for named streams
Can you check the review comments from sashiko ?

https://sashiko.dev/#/patchset/20261025083450.212604-1-chenxiaosong%40chenx=
iaosong.com

Thanks.
