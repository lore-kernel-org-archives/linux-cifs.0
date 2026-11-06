Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793961926;
	b=L1HRfqNC9S86b+Dg7GBxOkIyq1rDqacyYxL59EpJ3q6sUzYEr3PDCE95UZBnIBG5dXqF
	 zy7JRheaEorjjb0+ujSHcf9AqTmVVmWEsj9JEkY3m67lRXYZuoFZY8/shEdmct+TZvD4I
	 uNk/X8t/UYUYebel2hhTTNprajLwKdsTiWGLnxKyml1hUJ76ONj/VW+Y0jAjNMOur836V
	 mxUxh5kXwgZRT8IHBabUWVpN8IRi3/DSoyMPp2sgsjKdwNGAEriTp1Xq4Fm5Bjp4Npipc
	 CWOX+GlOVqNe0wd6AlNyVR1n4bqPOXHnq/OCLslTTK1UcsYG3GWdLzruWQTsjEJ1cGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793961926;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=W5cUQZWfaC3MxgiZhu2mJSrd0Wxis+9ZPmTNrRYPwYk=;
	b=rAmB8ITVEVutgkeMjdKX0SaTaFmX/BjSt4Chnc+k8cu5AB3Ed7Vs9EG3dvapIR7F1Ad6
	 P0HMyBxB1OdnpMoIBG2L6ppZvS0UiD41hEhofjm5Zn3swYRZV7Ssrefb34fliRJ1vpu0R
	 zJCdCdm8Vp2OTyUnexJyW6ooTcFaM8Z9OV8jedF5C9o8e58WOkqARxzeKF3oCsiAFBoZs
	 VCQ8gMIYKqt5X3uk4794HTq6F1SmLhqIXdlBH4/jp/uyB9TUFWIPNIO+y4AlVx5aHr1Pe
	 gR2Hlvph1SnkBe85+wU4zVfPOLfFzi6TZnlrnCBPPUwiyStyPjpDbH50aS723tCf54Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="CA/mpxxb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C3C606A32C
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 10:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CA/mpxxb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A4A1F008A7
	for <linux-cifs@vger.kernel.org>; Fri,  6 Nov 2026 10:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793961925;
	bh=W5cUQZWfaC3MxgiZhu2mJSrd0Wxis+9ZPmTNrRYPwYk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CA/mpxxbb4zkwHztG9icljyJgTPbLYK6Ipv4X7oxHpISSEScpKKIj2+gTsvI+/pvi
	 njCW4N7pIO7tUpmnFwSsHzT+eQrPRR/XScD/m70ZruHrGSzdhfsmby3sLucE7EsObW
	 EqeLa0+w8wdvSwcN6Adj+6+ScjKRBTBpuXoY3Bp28jPQ4EoYsvQ/iANjJHwYs8pWof
	 /sOrMQEnqccCQ8y+GL0DbKN2+GgFVYedb4IW9fA1XWsx6tNTqFJza0A6FWOct/wbmz
	 5vTQ2wh8EptmLCpJoGq8ed/mxJA1cwcIVw/RxAzEhCfLkx2uspc4ejOT9YImPhY24U
	 oURdWOm9irl3Q==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c445c95d553so63518866b.1
        for <linux-cifs@vger.kernel.org>; Fri, 06 Nov 2026 02:45:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBzt/IHmAOgKmD85nkHyOfEhKVi89hjSwTtel/aD6VsYWOfzzj355jgRKkIY2Y9LeWwdkdnJSxrSoxIA@vger.kernel.org
X-Gm-Message-State: APuU4Z94lF7amWMxeWFyAo36poN8/cKRgQn9hHGLhpFqPLHIuYibnEKr
	HAcDNmJwkrRLU3NygQnph0B5NKg3ktsLxmRyI/1Uqxgbnow0ZojjlOeY36KxKhipWefl8KA/ZHj
	VbH4/dF0OLTPI218x9zBahI834OyDLUk=
X-Received: by 2002:a17:907:8687:b0:c48:a838:c16d with SMTP id
 a640c23a62f3a-c4d34c333bdmr171008566b.30.1793961924247; Fri, 06 Nov 2026
 02:45:24 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106035345.728454-1-icb@fastmail.org>
In-Reply-To: <20261106035345.728454-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 6 Nov 2026 19:45:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9fstqtRHh8+Y1zkr47oq4F4nf99uU2tTuMcP0peXwnCQ@mail.gmail.com>
X-Gm-Features: AclHuK-F7Fk6JKUwAbLJL6bh1AEPNA8rMK8qFFA9dFT4E9PsNSTqxxOOf25b8yc
Message-ID: <CAKYAXd9fstqtRHh8+Y1zkr47oq4F4nf99uU2tTuMcP0peXwnCQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] ksmbd: exclude metadata-only opens from sharing checks
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 6, 2026 at 12:53=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> ksmbd includes opens that hold no data, execute or delete access in
> sharing checks. Such a metadata-only open without sharing can block
> later reads, writes and deletes. A metadata-only stream open can also
> block deleting the file.
>
> Patch 1 fixes the general sharing check. Patch 2 fixes the stream delete
> check added in v7.2. They are separate so patch 1 can be backported
> without the stream helper. Patch 2 uses the helper patch 1 adds.
>
> This series was developed with LLM assistance.
>
> ---
> Changes in v2:
> - Use disposition-implied access in both sharing checks. This covers
>   Namjae's READ_CONTROL plus FILE_OVERWRITE case and named streams.
> - Keep the requested access on the returned handle.
> - Leave the attribute-only pairing rule and Time Machine AFP_AfpInfo
>   synthesis unchanged.
> - Treat FILE_SUPERSEDE as writing because ksmbd implements it by
>   truncating, although MS-FSA grants DELETE.
>
> This differs from my reply to v1, which proposed changing only the
> truncate path and leaving patch 2 unchanged.
>
> v1: https://lore.kernel.org/linux-cifs/20261104183702.192452-1-icb@fastma=
il.org/
>
> Ian Bridges (2):
>   ksmbd: skip metadata-only opens in sharing checks
>   ksmbd: skip metadata-only stream opens in the delete check
Can you check Sashiko's review comments ?

https://sashiko.dev/#/patchset/20261106035345.728454-1-icb%40fastmail.org

Thanks.
