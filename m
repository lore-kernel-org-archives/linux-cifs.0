Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755199;
	b=VNUqORrX4GcE8hZN1QR6W/fp2YHvxwwUfLihAqQqbq4mYJVeD+qR4gRKAl4WAKTCbzNl
	 PIEl8kMKffKzRE6+WE+fe5LNU2aYS3NsyXsolmV6b2uq7Y5UQvpDNdtSh/z2mSX5zxABF
	 t3/BAsEn7pqvbIVnTtNSUnqC2BZU8XkXHhBhALw3dLokb+/SdOVAXMXVzQnj7ixPEC835
	 5iq0A09DpUqm8zjwyzCAVS7/FRLsMhExfsWn0BHHrWj0gUnbzA5ejm4JwhIwjC0ru69bf
	 WeNYT5FcRTwdNtTSLpOYamsA9A9l2tSmkHfaXz9EhARBhIZoSxA6GMn3kV8EMDT1jQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755199;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=+SGkZ6YqczPiCOlTioLJEjqnj82oV5Ygp/OrD9QA7gA=;
	b=s8BPc24me9NMa1ok2JRlImMKpQyy+9C/8gOlxi+2vPjuhMp2BbrxtKhk7gZc3HmQeKsu
	 cvj7Z7Gfg5ibJGMbWFpWrHlNpio/0CmAyvvsBuByLBrtNgFkjpA4x+BTN0R8/XIx/YkNO
	 iet+qnQpFwhbMREcV0PT+AP3aTI9A1ppdbBH0S3T/9SmIVHhe1OEOf15sNxUZOL0KyRKx
	 /RjWQrBMlV2DBa3yJBka+jGbqBu6jaqL+m0pu4OelJXhr/ji37XJeio78NY9gLxvcvR7m
	 F+sbWsb5RMq0LWNHQGKZFYs8s2MAQY6eH9pe4kXRMWOn0SA8IsJdMdeUaHnRnCqKboQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gIu3e2wc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3227606A31B
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gIu3e2wc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2511F00A02
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 01:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793755198;
	bh=+SGkZ6YqczPiCOlTioLJEjqnj82oV5Ygp/OrD9QA7gA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gIu3e2wc1+0B6aCCehzbC5/v+nwqu8BMIh79d3JNDtL+war5qkqxud5vwmP+j8X6J
	 N/hCBzQkKWCQjXvmDr9csk70CYvowtfdrnzxcxR0bmOsJ0YK2ZgEAg9/+s4fbj34SV
	 rUQGKB24sD8UGr1gD1ukWfCm733VzztqQVEZ0ogks2htzSIbNrCe9a05iWNML5Tyck
	 LDpXwWW+ylDAOqdKY3p7YzgbRElyTlQv8roXaev8UJKykPq1XkqRJDb0p8CUWR3Idk
	 2z79YjL/OrzXPJRdPcLMwWwGDydI9gxw5gIxU3ByyMYvIxqI5O766twxTQGYHxpIpA
	 UKVCFqS1d0b/g==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4cdc606b47so28165566b.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 17:19:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwML95SYtIHd1qEihERGkaGA8S66SutRI6+g0STUFx62m8LkcGTKslUytvaG5sgnGMPRnQ6ZaUL/xYJ@vger.kernel.org
X-Gm-Message-State: APuU4Z+L0hU5/Yc9IGlLPPwqDqN3UQW/JMYJNB9UX4EAm11lhTV769Vq
	xjefEsjunFqqOeZt1CczM4VEy1UPhjouml7LW1XbYeQf6AmQmg6oOqzh8q5qwxWS3SpT8BId5Nk
	7eKjhgwT/c6LwkP+LxjB8hXwyWieUKlM=
X-Received: by 2002:a17:907:7251:b0:c2e:7e0a:572f with SMTP id
 a640c23a62f3a-c4ca7a78115mr1226146566b.21.1793755196978; Tue, 03 Nov 2026
 17:19:56 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261104010725.50071-1-icb@fastmail.org>
In-Reply-To: <20261104010725.50071-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 4 Nov 2026 10:19:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_xB-2c=19qaNkAqB9a9rKsthGy4pCtJg+QW+J6Z23Q8g@mail.gmail.com>
X-Gm-Features: AclHuK_Bycuo6k6xqyfgYfs9kW_s7ULR8f3X9DKqkyxSOsZjljuAgVj2aIvMmkM
Message-ID: <CAKYAXd_xB-2c=19qaNkAqB9a9rKsthGy4pCtJg+QW+J6Z23Q8g@mail.gmail.com>
Subject: Re: ksmbd: refactor security descriptor handling?
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 10:07=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> Hi Namjae,
Hi Ian,
>
> Would you be open to a refactor of the security descriptor (SD)
> handling in fs/smb/server/smbacl.c?
>
> Since February 2025 smbacl.c has taken 24 fixes for bounds checking,
> sizing and SID validation, 20 of them this year. Several readers walk
> the SD bytes independently, each with its own validation
> (parse_sec_desc() and parse_dacl(), smb_inherit_dacl(),
> smb_check_perm_dacl() and build_sec_desc()), and the QUERY_INFO reply
> is sized by an estimate and then written ACE by ACE.
>
> Roughly, the plan would be
>  - One decoder, one encoder and one decoded type. The decoder checks
>    the whole SD once and returns a structure that callers read and
>    build from, without handling SD bytes themselves. The encoder
>    computes the exact size first and bounds every write by it.
>  - QUERY_INFO, SET_INFO and inheritance moved onto them one caller at
>    a time. The access check stays as it is.
>  - Current behaviour kept, apart from rejecting a malformed SD before
>    it is stored or used. Everything stays inside fs/smb/server.
>
> I would test it with KUnit tests next to the existing smbacl tests,
> smbtorture's smb2.acls tests, and by comparing each converted path
> against the unmodified module. I would also check the decoder and the
> encoder with CBMC, a bounded model checker, for memory safety on every
> SD up to a fixed size, and can share the harnesses.
>
> If you are open to it, I would send a prototype as an RFC series. Is
> anyone already working in this area, or is there anything you would
> like done differently?
This sounds like a great idea. I=E2=80=99d been thinking about doing this
myself, but haven=E2=80=99t had the time. I=E2=80=99d be very grateful if y=
ou could
take it on. Please go ahead and send an RFC series.

Thanks!
>
> Thanks,
> Ian
