Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793179310;
	b=1XjnhnWGBj352OHpoZ8OOGC9crWzPYbAL9r1R5gScO2gpTzN1wBCti3GOwVNt8/VFroh
	 sb0A2ODtSzDQLPua9mWC39+n7BpryU08gEA54H4inWnaEGSLLCthmr2Jx3BGDf7gNPlNW
	 qejsLgHpDbdc9kO8aac7pmS9bytZqiNxRL3OHYlpNKomZWUECTpO9LL2NwKGgcQT1h8Fi
	 1J+JGYhy2yvMnuSZEhAGmmQysPKHSag4kx4a54+FH6ywCGuTwUFYAHXrheRrV8r6BUZ5g
	 9F5FnGobGioOVMljnNi6iIvrVOfBQrSkA3363C65EeL+kiqLBFMjliV2PvWNyco0Yig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793179310;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=o0fsosZOYp7Iltbse45HXED8tfR0ddHeSh5Nzos0Djo=;
	b=KQmSX2K1NxEBWdhujocrkliGFyjnBoE92GrOPBcwupXVi+fDCJf1aMFBYT/HtkkMLoIs
	 hOxWg1XrKX3L0AtsuX55krV7xBgKUzb5PlpYZ2zOudALNc9RcjKOL1+40YalS4FAibLJ5
	 NeZJ1U3dWTL9zOuySnufQDZYRHlTtExfiQi82VMs2e0KzsOD9ROcNINVTlYRUqznZ/tqN
	 Qh/OdRLZ2CzCTcHfaglL+OGah2hG74uipMb6Fam4t92zXKGmEugTF42Us/sMYmxV5Xgp3
	 g+tKn2saTL4Y3P+fnMSavHxtdYenxusS38osQo3mC4LIjL47Ea3IlicAh/I2yGcLM/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AMpQNTls;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FE8606A327
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 09:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AMpQNTls
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142F01F031E3
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 09:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793179309;
	bh=o0fsosZOYp7Iltbse45HXED8tfR0ddHeSh5Nzos0Djo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AMpQNTlsTq80HIOtpUOXTa0Euc7qWviHRsrqMz4YhJmCw+N+QgsYsclBq+Cg/oYz8
	 aBStRRUNeRJRl/K1QmlPKrNZhNfaoqGIZol6TYp/KIaFa7ztdflULOvarlhLW+I3jf
	 OUtKZOkbzVYUpEy+hMi0dNyAeBkHnHTCaUpyDyKwJD3Q1Z0JTNnm3rCITGICZVkDoC
	 vfB8fyDFr8MWho5VUG6k3jXj1wsytBs8ONDQSghinoZ/4m1SLXC20ienV7Xl+3UNS3
	 LJVmTlcahChCNSCmWDDDkuOuQXWUqtm4sSS/vStfRni0Dd5SPJlLpbZsFSnjMTQe8+
	 rQ60exy7zRHAA==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c468bd799ecso89518166b.1
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 02:21:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx3SX2W2CNFQ8X/4Vg43jo+GWAQLCzyXL8HRYpshpoSb/F+3AXwgWIRYTou1x9ZDeylULFyZ7BIIOJU@vger.kernel.org
X-Gm-Message-State: AFq9FYJ0NqZR5/qhFV2u8Uun9o7jzMbT7K96aMEabNQbWG/Hse3fSxiI
	T8fUBlMpldVpprQFp6yAZN3OHObf835BjGLG9nFAgWXdoG+kWPG2IPY0uJICOEFCczGw5Ior4I3
	+z5Qt1Bk9yKL1MGDN7V/+mchdmIKlhMk=
X-Received: by 2002:a17:907:7211:b0:c2e:4e08:19ab with SMTP id
 a640c23a62f3a-c49bdf37143mr126307266b.16.1793179307707; Wed, 28 Oct 2026
 02:21:47 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261027152135.138259-1-icb@fastmail.org>
In-Reply-To: <20261027152135.138259-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 28 Oct 2026 18:21:35 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8nvApw4QPvHFT_M3V8BMS07bH20MFQmi=u+H-qmH_hGQ@mail.gmail.com>
X-Gm-Features: AclHuK97M9BYzX6VPIeWldyUJ41r1miiCZlAMSB4h7QWCrhli_kFhVXJLOrMVoc
Message-ID: <CAKYAXd8nvApw4QPvHFT_M3V8BMS07bH20MFQmi=u+H-qmH_hGQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix session reference leak on compounded SESSION_SETUP
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Steve French <stfrench@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 12:21=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> A compound request can place SESSION_SETUP after another command. That
> earlier command leaves a reference to its session in work->sess.
> smb2_sess_setup() then overwrites work->sess with the session it looks up
> or creates, and the dispatcher later puts work->sess only once. The
> inherited reference is never dropped. That leaks the session, together
> with its setup connection and socket, and every repeat of the compound
> leaks another.
>
>   unreferenced object (size 512):
>     __kmalloc_cache_noprof+0x32c/0x3a0
>     ksmbd_smb2_session_create+0xf6/0x9c0 [ksmbd]
>     smb2_sess_setup+0xda4/0x6280 [ksmbd]
>     handle_ksmbd_work+0x88c/0x1cb0 [ksmbd]
>
> Save the inherited session on entry. After the request has been
> processed, release it once, but only when smb2_sess_setup() has replaced
> work->sess with its own session or cleared it. Do this after
> ksmbd_conn_unlock() so the put does not run under srv_mutex. An error pat=
h
> may instead leave the inherited session in work->sess. Keep it there, so
> the dispatcher still puts it and the error response is still signed or
> encrypted with it as before.
>
> Fixes: 7aa8804c0b67 ("ksmbd: fix user-after-free from session log off")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
