Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794578759;
	b=AwZSWIzLD6qhL9cck7NbjwFVBOCI6S1K/6w8x+ZZnjaTnXLSqCzPgP8k+4fglCg/piId
	 vqytjUtO/YKHhHul1okeqMS077I5BSVNismbm2mkkk//PhX52I46K2A7R8ihLRF7/yvP6
	 fqsIqXiNlriMYQahK8ntDe5I3ql5KcvostHBiCXxK6iIxs5xy8DbzkWn8Wpprdr2vZicx
	 BjP9esS1p//kN89mOWh4u8qFfzOMbYjjj6WNlEzfg0gQ4joNrZN5JW/tkbAqh8iGU4mK1
	 7NY8ntWLR4ByuV5D2zH7vQfbYUQWV2Tm5At5gvAOSAFWaFeEKAQvQs1jarhEr6W2NbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794578759;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=xJIkWIAhn6eaORk/+4XyI9QAEduquInk9Y+K2HPVW0w=;
	b=M+Cj5h2uehzo9VNNHDhqXOEgqd2RABBLBH4tLhqNQ/RTStN3bhrehCS7LKKANSwcjVmO
	 ghb9rI2gxsNOcIPFFCsRfgW893KgCJMH/oXDhXaF7nkeh7kdNrzIC3r6daCvP1X6GLSSI
	 gs5VWe2GaXDEbd1QihKK1Poc7V9DiK9gtPcXzpfJ7toPgYvAnEHxgoSwouSSVzE75GHxO
	 bGROEb0PZCOiSffUD0pEJOA7UMMlPqRJN3ExVLtkCWY1Jg2tGzId7hLgeUqlY1bxmFXh0
	 cdNooQcQEvF6GNpYeRgC3OtNDUIUKt6EV+ctLnMHRyjJD7XzXH4shIwyK/DUBn02EnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z+Dwdge5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9DF606A32E
	for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 14:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z+Dwdge5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8D31F000C6
	for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 14:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794578758;
	bh=xJIkWIAhn6eaORk/+4XyI9QAEduquInk9Y+K2HPVW0w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z+Dwdge5Ra+Qb4v3rNlLoPNWUPLho8Hjpe3H7Cd7446TKwVmY53/Uo2gVeICay5jL
	 IJ/ZZASdD4PafnFGIRF8GZjyanoN3m3gT9ZbpXEnUsIA6am2cFqhsom8R2A4QMhA53
	 cCN/9pQYm4s2cW81ZCfxm2U1iUshGauU7UmTlE8tqmYANbh5C49WD/UTgzjmF1RXgF
	 RUW3joqEuIUu0aReR2TyLo+S1quZ7kPKziL+HZfwcDrrOEsweao74OXe7q4nFdq09N
	 97GVQFnQVYs2692KRrvoIePh2X3/TeSuMRDE+aOuiuainYY/XEK8ePDFBUHnMQipxQ
	 ORNpPe2y/FRSA==
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6798eb0d190so706230d50.3
        for <linux-cifs@vger.kernel.org>; Fri, 13 Nov 2026 06:05:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGBuN3rfZx8d8+eMjJrAYPpPTItdJq1wbWbieE77eXc1T12ehuJlxK6QbwJEppvE60a8e2or8BHqoML@vger.kernel.org
X-Gm-Message-State: APuU4Z88gE71hoeZRhFGLaAtQKgLe6XN0R5vo7YlaVbqKc7RrYdnrkCk
	OlERJs8GBUibKNIftaFK9KH3ed0F/8XEHvmwBnZDjLCi/ScQm/8NAWSDO5bIWcgR4l1Cnjh03/2
	sSESgtFTJ3pRMrgae1RR6d9bKeUmSDdo=
X-Received: by 2002:a53:d484:0:b0:67b:e219:e623 with SMTP id
 956f58d0204a3-67d897c8837mr1245914d50.104.1794578758115; Fri, 13 Nov 2026
 06:05:58 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112185044.41571-1-mike.michalo@gmail.com>
In-Reply-To: <20261112185044.41571-1-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 13 Nov 2026 23:05:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9p4zt7Z5bQg_+0fW7cc3j2nF+vLkMAGUL-OVa04LfKTA@mail.gmail.com>
X-Gm-Features: AclHuK8zxv74vsD7TmQgCqfUvXEVQCah9Mc8SlG8GpqRrDyi4FeM2mxXWUWcfwA
Message-ID: <CAKYAXd9p4zt7Z5bQg_+0fW7cc3j2nF+vLkMAGUL-OVa04LfKTA@mail.gmail.com>
Subject: Re: [PATCH v7 0/8] ksmbd: verify session setup requests before
 signing with their key
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: stfrench@microsoft.com, icb@fastmail.org, senozhatsky@chromium.org, 
	tom@talpey.com, chenxiaosong@chenxiaosong.com, ematsumiya@suse.de, 
	lsahlber@redhat.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> Michail Andreas Michalopoulos (8):
>   ksmbd: verify the signature of session binding requests
>   ksmbd: sign with the negotiated SMB 3.1.1 signing algorithm
>   ksmbd: use the channel signing key for session setup on a bound
>     channel
>   ksmbd: refuse a binding request on a connection that is already a
>     channel
>   ksmbd: check a request before signing STATUS_NETWORK_SESSION_EXPIRED
>   ksmbd: use the current command's header for signing in a compound
>   ksmbd: consume the sequence number of a request on a failed session
>   ksmbd: account for the credits of a request on a failed session
Applied them to #ksmbd-for-next.
Thanks!
