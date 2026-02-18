Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90ED431B838
	for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 12:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419068; cv=none; b=FH+cWTC4X0JKyMzIzhAuscy2XlL4a842zvoiV8zumrrpIMGVOS77k7mJcd7AGQj3jv0002zuEmdInK2mBdv4a9YJ/bmzs+ENY4lnn7Zn6iYelSfj6+Zowm4GhwL1dEVaLMFrO4P7owi+h9YZQtQ857Q+7MkI7BFRH+6dHGpo0EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419068; c=relaxed/simple;
	bh=ChJGVLy5mZGoflJKURgVEZ+7nwkwJ8e/WFaKFyRUSqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B5EVNHYVXVTTWGTqQxUwlr2rLtpYsMTwD4hWiD8vUPzMxCK2hcKS39mEb7PsABz5huqTDs/SKOStO0aLhi39uIqpMbdIKv9o5d28wb5FCj+cgHYB8KxizEjJLwLajUUd2OvCYJulHoR8c5J20GzV+bIl7zfDOV9mqXcX+iQA5EY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IYoCx87x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IYoCx87x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3503BC19424
	for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 12:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419068;
	bh=ChJGVLy5mZGoflJKURgVEZ+7nwkwJ8e/WFaKFyRUSqI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IYoCx87xvwRzzMYi/4b6MTLAPuPP2qJI1SEaL2YnvXAEAuJmmqzV5JWlb2AjI+l0T
	 qSVzpP57FMYb9BhlDbRX10gZxUstu9t4dXGiEl+vPsD7dR6tPZEBoJJYrXKqepWgHb
	 PcyI8wQXz+K2ExRYBli935ePXjKKG0OEoY9b5dNWptPhZw1xKWQIOtitlE3RNTe3DM
	 iwWx97enA1WhfTSVGoHZr0GHFkbTazJ2iJytg71vMbDjDCWgkZXOQ0qWtrZrF0MtuT
	 RxapbbRbmUrFEivpNS5IVUcPfnTZZmZvlib/H7H8kKk8FItTM3ok42lJiKcFaOxZCh
	 ANXi/1myR93xw==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-65a3527c5easo7718918a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Feb 2026 04:51:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUHuwx3nBu3jTL8kZsTYDOqdWE6rvH/XjCGyICOBIlk+F6bjpVzMIunVGpWR3xPk+sxIcJbLlT9JD0r@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5Gss3QlX2wJXvJEp6vDx1Qc0Ra1c1YjBg4AQtsqKCeVC7fwf5
	ldETkWpdXHAVPE5S64H/gRyNHcukWVsc5pRZUfPgRJqVjG9dZdaRv/A1rrsMo9hZrrCLc8LUYAI
	k7kOGvbU3+DWiPRoZ0ZYNqqfUzuAFuC8=
X-Received: by 2002:a17:907:6e87:b0:b8e:8874:8367 with SMTP id
 a640c23a62f3a-b903da4dc40mr93399466b.8.1771419066721; Wed, 18 Feb 2026
 04:51:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260218042829.68334-1-ebiggers@kernel.org>
In-Reply-To: <20260218042829.68334-1-ebiggers@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 18 Feb 2026 21:50:54 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8mqN8kf0KvKTaztPntQ9pGUKsBLZ-9rmtZ2F7P0T2=tg@mail.gmail.com>
X-Gm-Features: AaiRm51zi4rh83vQtzblcIzkx9fhf2J_4Hjb1j4TFHhrwKK5xpELUnocXHIP4aw
Message-ID: <CAKYAXd8mqN8kf0KvKTaztPntQ9pGUKsBLZ-9rmtZ2F7P0T2=tg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Compare MACs in constant time
To: Eric Biggers <ebiggers@kernel.org>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, linux-crypto@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 18, 2026 at 1:29=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> To prevent timing attacks, MAC comparisons need to be constant-time.
> Replace the memcmp() with the correct function, crypto_memneq().
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Applied it to #ksmbd-for-next-next.
Thanks!
