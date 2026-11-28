Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795828662;
	b=GUmXi9AagxAVrDHeWFtszfmuWo/Zb+c3f7cOPmfHkZWPudIgndZCPxxGEAEIf/EcEqJH
	 dWCRPuKV+g65+ox3xm9O4kB+uVqz9DPmlv1kXpFYFfE5k9ZbixqWER8dgTjPKkelGcQEL
	 pKH7/H7rSCz+xgNYsOKg0mksMnrVcMRtajMzd1umpK5l4jDdRb8hBKcNPFJVhIdOwcL4r
	 FDjfS8bLAkpTvct9PD6Hl75hMRIeSlO4vIHYO9/iMjhAyCxnv4hv1vLRjNz8ocajDKSjY
	 ah0jXc9ZbqfROtj64YWH5CdoOO0JAKShtQSubrtHh7f2IhtnS+Gzs/Vi8JvcBzah7Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795828662;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ynYpBMFbnjt1BZ3puDYcCNO837G+Oo0nRDEUrJjBmwA=;
	b=k2JTiZqBtwqQ0PsEngvXOn+6xGocdVLQi/QJYCIXTWiX3UMGMGEBNk5AUglIhCO2r8jS
	 1hgJ8ZFGj60yPva/e3CujYa4hJnum3nodpbwCqAVgUHFpd7OwP9xqaEH+Kpd51+XZylKH
	 Q1l+0GLDQDmyoFNiSeXIA0nGTCF40vv3RDzN79/3ji6OlLCbYFCC8imiCjUSxTqS5cVER
	 8G2YkNuUHyBxEmG+YH3BxJ8Jop+2oxBrMTWzef34aBcsycXZTY71LbgFFB1KqaipmSGLk
	 /Nipy/YzViOgBqPfZJUkiqLrixs423GbhmTGFOwLi8o1yaVKpheAMs+W9ptrWZDGDBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fknHhXfK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6BB606A324
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fknHhXfK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F6E1F00925
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 01:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795828662;
	bh=ynYpBMFbnjt1BZ3puDYcCNO837G+Oo0nRDEUrJjBmwA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fknHhXfKVkJOJtN4EUHQe0uCE0r0o4h4teyp+31+R0yo5r9nzyYzWzWF6YH7CpY1F
	 w3MA/7cIGbzLsBiTiQCx07IcSV5GfW9MzE4Yk4CS8YOay32MR5EY8y3+cPoED1epbv
	 T0+M6jWFfdDANAo04Lvn3rPWDm224OUNGNxtUmmc44X+yqHShw3mCw16SsIrXC2PcP
	 3Ho1EV9UsIZEPH5epP+mhi+bPm2UwfsN+15qm739+sWqNmH7IFn2LXC6esiDSt/QgG
	 JL3vN++Azd8ggesX34Lb7d8ONhqb+XWn2E2bSwzLoKyiAImdw7rDkUIzKJAA8xee1P
	 NV7vQiZyh2BDg==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4322d310e7so464965866b.0
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 17:17:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErH/z2cvdgWY43KEjDcY2Y79doO/N+v9//B4UjACZuKtLxcGlnRw2NbA3a980Up06WPK5u48mT0kgWtV@vger.kernel.org
X-Gm-Message-State: APuU4Z/hO85WXbz+/KTS8j7L7vCmCysXQiIHG0rHlv3QqFs8FGqX6HDz
	GnSfLRwX7UnIqS7gkbNrOCKg34JpPLVJM/s6rqAuGkJLnQ8VQTijVm7DAuYbOkgDkkxb/KN/hzT
	pLud/eevfrroa3un7Dny+Q1XJ6HVi0iw=
X-Received: by 2002:a17:906:f59d:b0:c31:5bb8:4b3b with SMTP id
 a640c23a62f3a-c513a47d551mr2219289266b.2.1795828660929; Fri, 27 Nov 2026
 17:17:40 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261128003913.1684555-1-icb@fastmail.org>
In-Reply-To: <20261128003913.1684555-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 10:17:28 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9As9f-7Q=F7CJBqcF7qCdbwnFeQYQ0HytdU5wTvBPuag@mail.gmail.com>
X-Gm-Features: Aa3M54oxvdO9s8JRrz7L-H09Rdnc8vxQ05eSOl7Ki45QmXcG_h5g_M20FbFOIH4
Message-ID: <CAKYAXd9As9f-7Q=F7CJBqcF7qCdbwnFeQYQ0HytdU5wTvBPuag@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: don't create a missing stream for FILE_OVERWRITE
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 28, 2026 at 9:39=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> An open of a named stream that does not exist fails with
> STATUS_OBJECT_NAME_NOT_FOUND only for FILE_OPEN. With FILE_OVERWRITE
> the stream is created and the open succeeds. MS-FSA 2.1.5.1.2 fails
> both dispositions when the stream is not found. Fail FILE_OVERWRITE the
> same way. FILE_OVERWRITE_IF still creates the stream.
>
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
