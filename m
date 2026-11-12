Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522828;
	b=hJYwnclWgE4kYi2OEg/VFPwfJn/YXKnup49M+eurGvLpDMn4o7zqiGngMUM1SE8XoNhI
	 7iqPp34vJvZDJOotllt/5qqxspFvVKHgXNgADBQo0g78VLmqay/fy88g7Nz+ZCz20cEbq
	 H7AjRuWwD18FRMnR1okaanWKo2Ke+mCghntGkBjDRzk+TNjMfYTpQPadKS90aothkG7Cs
	 Xx8gGosmNtePkT6WDG03NqBPaRd71xRLLsqEJQqupLeCxEyxfXXxA7hZLBr8ftNfTO4eV
	 EZdlhPLCgagCljqyOv4sUq0MzO/PoKGuaRz91611SQZ+Jpdz/Xi/r6y8xm7sGvO/bXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522828;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=pNEn1GU6+1iildeKPZ1PBLMTIFpNYF0T6jPgUs9CnGI=;
	b=alzsZH9cL7CTJiDpYHebCngpJI0n1wNZhwKRbrLDsFwR4ATDZ2JWFa88V7pbv73s0mGh
	 a3yog/9JjqvnXPzLg4k4DGh/ZJCTL6wBSEQCUxafZplqKOOAt0a8J0WJ/MA8x98RRKqy7
	 4Z1wpO/iL9WAgJJsU/2/3nmLPqzgX7AjFHkK7Ty+/NSh3i9zlBx+ETZYPww1ReIX9XvAf
	 cnYNHPj4TjwaLfuVteq/ElXiSlohPTjuPQ/SIJSWY55cyjkGX3zxJWBweBdJBqJzgcwAV
	 /g4X+CKW3Tu9edSVfqxjlJmedjuAMh+Ia6smbrA6xxPwRRvaddzpiyW8PgrpHuVqiug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QlPaxm9e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46DB606A331
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 22:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QlPaxm9e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 709761F000C5
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 22:33:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794522828;
	bh=pNEn1GU6+1iildeKPZ1PBLMTIFpNYF0T6jPgUs9CnGI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QlPaxm9enbHbJLh+jwcI9fl8/fsMqRLsVjWQWtwsq3p7LieVb0xHryu0HOIxAESjf
	 4/hQimQiRJgjPlh8IpWPDnDJ9Po1bqhd/Bloig5NipOh/g1toBzygP9C7nVKhKogJD
	 Y1Djmch/2FFhnrGF9dDrR5nyaCpOLUxwcKiOp7lJy/ae1XxQto9yl3uVkc/kctdQvT
	 kOEJqr1PnPne8zaqKIv6zsA6CMTCenkWiwWMxC1EU+ZPEdb3AfuFYxyd46sWAjqw1H
	 8J3w85iFkGhvwITIhLpQdau0uvvmG8H+QbimfU1ZKhG+OAbFOoOTwpM08T0J+w688K
	 WnSuDwlYa2KGg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4322d310e7so40710766b.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 14:33:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGmndBuQSXv0s+vZjSeabHstjHqVyIDNWSjRhlVHuZDpMazLRgUhy1sM03WeY2a4qPAfw/58x7agF/b@vger.kernel.org
X-Gm-Message-State: APuU4Z9CtFLED9VmkHGN95RnWqiBmvn1NLV4gFrEuvvN2BmfecE0x3Dy
	3fQYHRdrsuytW4EH0H6ZjcyNOUN9fVUAj/Jqau233aq3ATkLepx7BO/Um/SBt6iCR6v3QTIYM70
	KxQSyKdn4+OhLALuJUGL5zJ3luDsH+A4=
X-Received: by 2002:a17:906:c14e:b0:c34:83c0:b92b with SMTP id
 a640c23a62f3a-c509631747amr46327666b.23.1794522827158; Thu, 12 Nov 2026
 14:33:47 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112194744.47047-1-mike.michalo@gmail.com> <20261112205551.1668102-1-icb@fastmail.org>
In-Reply-To: <20261112205551.1668102-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 13 Nov 2026 07:33:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9DFfHMje35Ttag9dQiDsQmCd6QrAwC6SHF57PeE_ysFA@mail.gmail.com>
X-Gm-Features: AclHuK-vxVe_X6RT1ZSqcHueQtLc9XnzLHj6z1KurZyaylGVLEQUXucTCRZVtvM
Message-ID: <CAKYAXd9DFfHMje35Ttag9dQiDsQmCd6QrAwC6SHF57PeE_ysFA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: sign the last response of a compound that ends early
To: Ian Bridges <icb@fastmail.org>
Cc: mike.michalo@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 5:56=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> I tested this with the ksmbd code from ksmbd-for-next. I sent a signed
> compound of two ECHOs whose second NextCommand covers only that
> command, so the compound ends early. Before the patch, the first
> response carried a signature that did not verify and the second was
> not signed. With the patch, both responses are signed and verify. A
> normal signed compound gives the same result as before, and the
> connection keeps working in both cases. smbtorture gives the same
> results as without the patch, and KASAN reports nothing.
>
> Reviewed-by: Ian Bridges <icb@fastmail.org>
> Tested-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
