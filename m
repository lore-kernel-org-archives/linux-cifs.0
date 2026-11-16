Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837766;
	b=gQ7t+PDJ4IxD3YULGtB/nC2SM3yPpv2HI66szDDS07I5bywmLM2vIvVh29KBQKlnkk+i
	 +U3l+ByWU17AzxxeIzPgRMIgyrZb6BUeYilp3S/tpxwQtvK2PMRsFtAimtUe6qgEG6Md5
	 5Xki8KeHmnFn3UEguiTAPNTRBcQN3X7srz8PUnKCqDsTE/t8e+biZWUO2R0jdBhdyK+Xq
	 HI3FY3cejPSJz1h+R3gfBfQmv2gQwf0R1P9hVUriCINVxIvLXtFrWlrwG9keGXPA2EmD5
	 +a28ibn/pn1MLXX2duXMjaThtD7U6tx+0Na7GmqHOEyYKb5v11EMHI00sLTK3d/CprQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837766;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TJmPcX0jlQEhCukA/l5pSJzFcBRF+gLl1xeZVV+XUyc=;
	b=bszIMmuco4v6mt9NptoePffoWzz/qGHyUHKjeQ7EGxwZ5Hzl8ReaAFKED8l30NR7QnLi
	 9Z7YvUe1S3+zBEf/sylj39eDuXzSwruAIZOfIQrNG26XvJMrpGRZwbA6jWGqM0WWr+2Gc
	 HbbOqTT22wfff3LRA2UpFp5AobqMz0c5qzKVmO+q60l6qpfVkSEC1pnr+iz7PIkogR22/
	 +4DgSmHYmQUtrJ7n3c6P+oQwDVIb8/VHljXLLl6KUW/7KsXrX7m1DhgUnZRN7ubB584ys
	 hDSsNeogRlmZhfeTmpC5JP9JE0jK7g0erw3M1QiJEJS5JVqtSoOcBnq1oBUurmYMY2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=US+yckQj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235F1606A32A
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 14:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=US+yckQj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF27D1F000CA
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794837765;
	bh=TJmPcX0jlQEhCukA/l5pSJzFcBRF+gLl1xeZVV+XUyc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=US+yckQjfPhoBBZ2NFnM888mUhXibQLMeBwiTob/UcxyTEIWr4F/3I/OR9+eF97xo
	 7OgYsGjkTmrTN8KrZxswFtJgnxMU5JB0q/jSr69JajFA+8i+gMeIl1RoKOgDD363Jo
	 VnjMYpi9xMCAZs9CAdMtHHP1JFssgSlAW31NCHR2l0TU1oDx8DmeNA5lxnM52hCIJQ
	 cCqkbkpVmXxUBK68rlUMjr5HLLs6BD8tCMcJNYy9CvpncG4bXs9G+HypRNQ2KnvwPe
	 lonjPrv9OtCaSeBVh22DvP4VZ6AwR9gepfxZrEnNZX8uF+hPx+LajBNaMeGMUx4tuf
	 T2a1aVYNr8mFg==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6798af41644so2437449d50.2
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 06:02:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErExY6wNI23eWQfiseD3NjTl8SALmEBeOOZvn3dTkRtOX4+bod+XQbL1oAchol4nY+Y9beEciaavMXcz@vger.kernel.org
X-Gm-Message-State: APuU4Z/vwJlomOpwPdNpm8JEK86RQoyRW82dvDur/SC/nz4EVg/c/zD/
	F/vNeRqxt6dksuxxFp9fal6p9/wZPZiCxwUKasbeAGMwENjGAik15T9u165kR3w6QyX77P/Bu/M
	zzgPoFMWAEUZDm2vIJMpCepGy2lEB6T4=
X-Received: by 2002:a05:690e:bc4:b0:67d:ae02:45fc with SMTP id
 956f58d0204a3-67dae025d9cmr2328051d50.45.1794837764984; Mon, 16 Nov 2026
 06:02:44 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116124441.2521447-1-icb@fastmail.org>
In-Reply-To: <20261116124441.2521447-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 16 Nov 2026 23:02:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-RabFCYgURT4jcAuOPRUYqUfD443Y4+g5-bzjYnsLyyA@mail.gmail.com>
X-Gm-Features: AclHuK9Caz4wzvgmBauJMGfLXbVcdLp4mgFdfHci7iv10rOa0L_5dZXULXUOFAU
Message-ID: <CAKYAXd-RabFCYgURT4jcAuOPRUYqUfD443Y4+g5-bzjYnsLyyA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: read create context data at its DataOffset
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 9:44=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> ksmbd reads most create context data at a fixed offset instead of the
> client's DataOffset. When the data starts later, ksmbd reads padding or
> other bytes. For a security descriptor, zero padding can be parsed as
> having no DACL, so CREATE succeeds without applying the client's
> descriptor.
>
> Use DataOffset for security descriptor, extended attribute, lease,
> durable handle, POSIX and allocation size contexts. The context lookup
> already validates DataOffset and DataLength. Check each payload's
> minimum length and keep the existing parser checks. Add
> smb2_context_data() and a structure for the durable reconnect data, and
> remove the request structures that no longer have users. Contexts using
> the usual offset behave as before.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks.
