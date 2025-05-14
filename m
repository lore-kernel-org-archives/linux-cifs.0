Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE411F666B
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 08:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747212325; cv=none; b=hLXLGJ+j4Ql4Bnfb8MscIBVIQjWHyFViwvIDbsiNFFBiLAFNqOn98iwKt9ZmhSnqgOx1C46fJINuxwBeEK8hfQByZwVkxa6txt9Ky96JFfxtHk0l7TbcaZl19Ekl3pnCo3Yd+XKn6neN2/AGbnkZ8/aka+70RxSamFJFsrObv5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747212325; c=relaxed/simple;
	bh=jGeLOn53PhBTlk5bXOKkomrLLpYcP+ee83wwv82SbLw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NGRa0t1pfim1yA2QX4uAXCw0IQDn79qE2tRvqqj6Ya97Mrk76CCBWYAhQVGWzNWFJWqdG0A0J1RbCsClAU5tk6rMIWWwlTpqZQmDWEmSeAsgNGLmGb1c28go2lNbUT38nZkpIK0XPHwFq/mnbkxSxMa8YC8crGmoQKAAA2VzeXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0LyEtfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0LyEtfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01594C4CEF2
	for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 08:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747212325;
	bh=jGeLOn53PhBTlk5bXOKkomrLLpYcP+ee83wwv82SbLw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=m0LyEtfCRPlfjh3S2TUYqeuZe5bciPtT37MYNW0napAshdAxBQUQFxAhT2WXeQTau
	 Y3lUKKB/QhLt34DPE+2fL8UQwzw7fnpD+h0MYBngmvB6OWHuVdiqZuqII3YQvKlJMF
	 0/dPJAGg92Rjb+RPsbcZK4h4Wh1UEkh3Hh+IYAYo6tPB0IH+KOaTWEA3sGbIS6M3hn
	 DRXLoFhhdSyZFRezbMVQY7axtvLrlspP4J0wOYmFvO57W9Byb0xVb2lvBUHjCZZJYc
	 INsjfRfmAjzagnGOzIbY5vZ4IdE51Av2U08yASlW2HBUeqWY7W4CEICOYE+aMIchly
	 thM2XvKLz3rvQ==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ad4d03700e6so337133466b.3
        for <linux-cifs@vger.kernel.org>; Wed, 14 May 2025 01:45:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHNe8IypFOJ00DmW+KPI97XIsW6+084j1LmflHwmS0iWnpFADaENkx3SKtT+PQILjshMhF3ZP/fWOr@vger.kernel.org
X-Gm-Message-State: AOJu0YwEXQ5WeJQga5PAOzMj/xEv/2kuITs6q+S+9B8Zy6EbSeUYdlGD
	4w4kes81BH/i3hr4EzzX8FvQDQzrbNkmSVWtP9x/hoy7cIfomarIBA/3WlPLUiuzYfMszV+jwMr
	QTWTm8l1fHmog8ReOwyckuMic0VE=
X-Google-Smtp-Source: AGHT+IGBIgSECR8jfSle8UMTYetj3XfKSYJpTmIfEXnbjbUX9VRyH/xK61Qcf265iLMNcgpfsAH/6XYYzver5JH2C4g=
X-Received: by 2002:a17:906:6a0c:b0:ad2:1cd6:aacf with SMTP id
 a640c23a62f3a-ad4f751b6a4mr237529866b.47.1747212323609; Wed, 14 May 2025
 01:45:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250514045407.118970-1-ebiggers@kernel.org>
In-Reply-To: <20250514045407.118970-1-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 14 May 2025 17:45:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_m9rrfO-enXOZJE0Wzb14+Jfwcx5U9sqCKTeomAm8q3Q@mail.gmail.com>
X-Gm-Features: AX0GCFv-w9AQVzolT9WfriaecoLPcXDRVKy3BXT8B_Waqx5QbIe4frL7De9q2Jc
Message-ID: <CAKYAXd_m9rrfO-enXOZJE0Wzb14+Jfwcx5U9sqCKTeomAm8q3Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: remove unnecessary softdep on crc32
To: Eric Biggers <ebiggers@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2025 at 1:54=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> ksmbd accesses crc32 using normal function calls (as opposed to e.g.
> the generic crypto infrastructure's name-based algorithm resolution), so
> there is no need to declare a module softdep.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
Applied it to #ksmbd-for-next-next.
Thanks!
