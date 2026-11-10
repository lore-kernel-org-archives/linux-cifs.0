Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794320930;
	b=NDKnyBJt3zby5bBz13xQiMUb+vKiSJw29coRuMPNE7bDsnnwPPFDS9TWbHaGWpIh+Ybb
	 +dunyiUO+ZnQtvT8f8/HBzEy5vcYB4k+BSf6W8Ad/4Frk1UpwIxNh/21jeDGFZ749tCqx
	 VVogCRNu03ZUFELxeiGv4upSiq4XRyuzWz4eJrUU3Qz5SnFQ4HiohUVCtKKsrtDZ4GBkT
	 8UvF0Io1hCgKYigp4YwatGMqvps2OQqyr5nION3AQE630nLYkNNQFzQ9Nan9RkuRUsM1N
	 pw36cTCtCz7dcg5t79q2EZ9b4ZIfxfGeamwnAtmxB770m/hQWndyO5PAOCi+W95TvEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320930;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=hTplsrgAQ9xqtxIf9pTXzacL7isLuWlgFx6IOikQwU0=;
	b=axNF2XwILBFX89VlpzVabxo6mtm+y3ku9jyrpCty56nb2df3wNQnb4mLNI07wy2YDatU
	 qZPwq8IDRcCr6qMvXO3ABnLXZtYuFpqc9LqBKQIxMn6xncbn76Jc7rY1EnimkvWH6PUGi
	 4nBlgniqDV21sXQq/JZwAjawEWJREQvm/OrASMtx3PhS+G6ed6fR8Z2qAsB+Chdj1O61q
	 gIW8oNxUrckA1eR89/h6MYRsKiZWdVBdvAGeE9hevm63CJUEaoCv+xr2liySpgmTIB/2R
	 R56yHrgIIeE2hbEJ1+it1A2XVQQkc3J2ruUdXL24x8IPZsZw//LodQfghOPDs/YyFGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feMvmicr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B15606A332
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feMvmicr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42711F0089F
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794320928;
	bh=hTplsrgAQ9xqtxIf9pTXzacL7isLuWlgFx6IOikQwU0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=feMvmicr7zLGaL1Pc6AjRarPmItbQ/xVekZhQ/wehNoRzBuhRf6uzH/w0dfgvUxjS
	 8q3xneSal1QDc7X8ki+9MW6/lHBwxCJXACiGJFvc/ZYM00B99kvu9adBarDLlnhjI/
	 fOIpOJXUHxAYR5fPR869O8/V6CgO4wvvSi1PQtKhqFhnhK071ZZuJeAS6Oa8RbnY5h
	 S7JjvkzPGXKpwSnJ6HS6bh1P/MT9Qd2ihfegHMSHe/BK1kKukgSS+HdjUrVLTx+Ugv
	 stOa/pfBs5mse+tjz1rbCJo1Fi/Asv7XCoLX5/m2EQruvyvpkPIBII4CwCWl9M+yaC
	 /7dtTe6ytWVCw==
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67c05273c38so2480693d50.1
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 06:28:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFgJjlX/xN8167w9CBHSmzynTeHRczUvDVUQ5MXi5JayuUHHBTk6LxXmoXySeWU2FRrBQKiPB8Jjtqd@vger.kernel.org
X-Gm-Message-State: APuU4Z8KMnhlrtrWxoebMYxQWEIz735pKg/o5EGMFM+/OM9/2QribfHL
	B0uLDKAIkI8H2a5VpCjege5EdW4nF9WJ0T5/na28kmfqa2P9HW9wruuEf1Ao57DLrWxd6ZY3/ML
	oVf3HL+uxaTZq17FfMODVuMtNxtg9PAE=
X-Received: by 2002:a05:690e:134f:b0:67b:fbde:ba7a with SMTP id
 956f58d0204a3-67c568bcbd7mr1639184d50.85.1794320928054; Tue, 10 Nov 2026
 06:28:48 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109195813.24238-1-mike.michalo@gmail.com>
In-Reply-To: <20261109195813.24238-1-mike.michalo@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Nov 2026 23:28:34 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-YAkeXs8K_EJyWFqOSFJ8XHWSt4A4D6BtD2uqVp6Bnug@mail.gmail.com>
X-Gm-Features: AclHuK9sFG4Af_a2IuBl1KesEPg4xBLh7HHkfluv2QH0-NYqb7AYPRPkVA2LPBM
Message-ID: <CAKYAXd-YAkeXs8K_EJyWFqOSFJ8XHWSt4A4D6BtD2uqVp6Bnug@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: refuse reauthentication of an expired session as
 another user
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: stfrench@microsoft.com, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 4:58=E2=80=AFAM Michail Andreas Michalopoulos
<mike.michalo@gmail.com> wrote:
>
> When a Kerberos session expires, its owner can reauthenticate it. For an
> NTLM reauthentication, ntlm_authenticate() only compares the new user wit=
h
> sess->user when the session is still valid. An expired session is in
> SMB2_SESSION_IN_PROGRESS during the reauthentication, so it takes the
> other branch and simply sets sess->user to the new user:
>
> - the session's open files, tree connects and other state, created under
>   the original user's identity, now belong to whichever user just
>   authenticated, and a later Kerberos reauthentication is compared
>   against that user rather than the original one;
> - the original struct ksmbd_user is overwritten without being freed.
>
> krb5_authenticate() already refuses a different user in this case, and
> the valid-session branch of ntlm_authenticate() does too. Do the same for
> an expired session: compare with the existing user and refuse a different
> one with -EKEYREJECTED, freeing the newly looked-up user either way.
>
> An AI assistant was used to find and fix this and as an independent
> reviewer.
>
> Fixes: a47634cd729b ("ksmbd: expire SMB sessions when Kerberos tickets ex=
pire")
> Cc: stable@vger.kernel.org
> Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Applied it to #ksmbd-for-next.
Thanks!
