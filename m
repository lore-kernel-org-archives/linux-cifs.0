Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792671431;
	b=ojsCQhE6EZ/nFT8XzB5nYhkereK3uc5I+xgShYQDygmLtl+mED1JcMPe9wr6LIfviY6p
	 u7wxGI/chHAjeoo48rhVEFvlr5CBjjmzjw6dwypB9qav/MnUkpudTfsyy75jj7csndE6V
	 YzVdj3vJd2mm1TX66pTiOVgsIGX2sOf6o1mRuN6USTTA94hPNvB0goTfG19+/NA8UbalU
	 JeE3vpKB0igdbVECvDHFYLBvvn0DIWHwiwqRxnjoZa6bwC0ih7pjTVvPvRqvyOeVYJ9xK
	 AIeK/bvqymj4M9dPGvG/sHpI2b1LAKSmik2fXogr/fe8ciqUNkfz2QeukZuRGY642WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792671431;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BM/ZpeI1cIgMEfNhy1yMJnOZfY9k/2QzMV/m5coXrmg=;
	b=qyQHbNvn3MLXhNwvuud1lkdV2yePScwic/OE4xCTNS8rUc4QapYris/ohc8okMjDb42a
	 deqj4VDbD7x9jlvrsPRo+bBXjwwAtEfcyKmfWKtq8xfEcUuX5ZZ5YpI+y+li9xs8pK0Bv
	 aF9v6RXm1ztegMotEg6h9YKsct4l4wAGQK8+rn08SHjlFAryqXAwU3WIT5jWT88SFE4bg
	 oXWlkVYjY51pV6HnMulIb/ajILXwN9IFFyNxUGt/DCjISUS8HziaEcl09BC+HzFdxqqVX
	 /GcWANGOcyKHoJ3jplAP+YsKeW+F6z55C7UstNvJt4rmV8fuyX8HVr8ECBaqC6zWz2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=euPlE8oP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00916606A323
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=euPlE8oP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9239B1F000C8
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 12:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792671430;
	bh=BM/ZpeI1cIgMEfNhy1yMJnOZfY9k/2QzMV/m5coXrmg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=euPlE8oPE6dTOzdJQS9SKTCUKW9chsyTWweUILjZNMB3iGMTNe42rNgSwDsBNGT6c
	 2972Rw5Ov7n+J6C5e0a24SesRwT1/aUtQCJLsUyCN/OFbtPnTbazxfjU8dHNWw7QRV
	 I1DuNqBN3TwRK3/AYqcdj8ZolBoDVotIE1j17UZs8wJwrKgdtBcl81EEf0GkY1L5ad
	 WVlryArRXzBHSWJs6sxxRTGRpTzmYGbVa/vYYFarVuAH9VJFmwDAl6cCaTt88FLjFb
	 lr0Uyr0N1wmuD4Ix7b0y5Kxz2jiuZdjs3Kt792nkiSr7ZSqMNCa5nn3purozm+Lfw9
	 NXaPZAz0b+DFA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c38ac26cc5dso275290966b.2
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 05:17:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByeamxFFQm0FxXm02FnM0WTHrKBPUAgNCn88KpJ3s1a/uiQABVWJMUFRUhkpW+1MAWzbiChYd14USGE@vger.kernel.org
X-Gm-Message-State: AFq9FYLuHUcWseMSgSnrrZmpw1PLQBrHssUYj6+u3Pf8wrVPYQAlYfT9
	jxbtZy11Ht4PHMqBz+JffmBZXKZZ8XZzx+Kg7iR+imN19xplKw44YCsUTCH4KrjFaz6RdyYlaAF
	SMq1Er/s7HNb6SYqf+/ZKOHg0eu/eRoU=
X-Received: by 2002:a17:907:72c2:b0:c2e:7fe7:288e with SMTP id
 a640c23a62f3a-c4679792b95mr489548666b.32.1792671429259; Thu, 22 Oct 2026
 05:17:09 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <BYAPR01MB383076AC412E19C48CFBEAE980662@BYAPR01MB3830.prod.exchangelabs.com>
In-Reply-To: <BYAPR01MB383076AC412E19C48CFBEAE980662@BYAPR01MB3830.prod.exchangelabs.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Oct 2026 21:16:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9yxvb6r+mtxbx2HSCzEFvxJqLaixtvfA6WuKPYThN9kw@mail.gmail.com>
X-Gm-Features: AclHuK8-Jh6mfAJkkpUjpVvOnI_Kzhn0tlBTf-KoHXsLwzjyKYtHPrQLRqJ-MO8
Message-ID: <CAKYAXd9yxvb6r+mtxbx2HSCzEFvxJqLaixtvfA6WuKPYThN9kw@mail.gmail.com>
Subject: Re: ZDI-CAN-33774: New Vulnerability Report
To: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>
Cc: "security@kernel.org" <security@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>, 
	"open list:KERNEL SMB3 SERVER (KSMBD" <linux-cifs@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 22, 2026 at 6:36=E2=80=AFAM zdi-disclosures@trendmicro.com
<zdi-disclosures@trendmicro.com> wrote:
>
> ZDI-CAN-33774: Linux Kernel KSMBD Protocol Dispatch Race Condition Remote=
 Code Execution Vulnerability
>
> -- CVSS -----------------------------------------
>
> 9.0: AV:N/AC:H/PR:N/UI:N/S:C/C:H/I:H/A:H
>
> -- ABSTRACT -------------------------------------
>
> Trend Micro's Zero Day Initiative has identified a vulnerability affectin=
g the following products:
> Linux - Kernel KSMBD
>
> -- VULNERABILITY DETAILS ------------------------
> * Version Tested:7.3-rc3
> * Platform Tested:debian trixie
>
> ---
>
> ### Analysis
>
> conn->ops is selected per-PDU at enqueue time but dereferenced at dequeue=
 time.
> It can lead to a 40-byte SMB1 buffer is parsed as a 64-byte SMB2 header w=
ithout length check and leak OOB read memory back to attacker.
> There is also a path to OOB write, smb2_set_info -> parse_sec_desc.
> The trigger requires race and guest share.
This issue has already been fixed. See:

https://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git/commit/?=
id=3D68f410faedaf6ee74d81e574733c50ebcc1bd8ed

Thanks.
