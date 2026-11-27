Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795758274;
	b=q/zbi2f5Z7ivw8h1/qpyBVcZ6PeMVMSta1TVeptglzQ7MVW4LbCo8OnyTUCiF7o2LYpB
	 tU58d3hxFvVtZSeIuxJyvhW/ukzBYOXvVHgvoScZlurOKXCxhlWn8K+Y34CsBUZS7vAEb
	 EMmIsooh01xY+fcW/0GHpd3kZtUQAyb3yva1HPpSQqWDjN4sGrJx5WFkoVl79UCQiHxDX
	 dxfnm2K75MynJN3jLY+F2/16JtBDl0s+ihNqE4rtdzKpd3zL2WyiVImCF4GPJF+RglT/w
	 tTqruBheTcB/HtC5RCPmPQBhJ5QSJUN7CuoPQF2Wqw9+3t31g+VNpms6bL5QeqjvAbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795758274;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=BX1eyM7k6tbC4BgpQxYOnwqhZ8IL4aMrB7su+PfCurw=;
	b=21ctJ0ovP/zmEq/pE3s1ivOGzUX5+4hXBFto1x3WUWfzQuMmOVm0X9+wN6gj1KYKZ7mT
	 WJjrPvWJNDrR1TTPCwTtqo3A8t/QAQnZ8NaDUmQRTsHikMvF7nmMlqNsoY2tLeF73UMW6
	 ETJ73DsV/cQx3ivwe0H7B1NfGX3oNRLQVyXUDJUbxigw/qLD/Gl8QgsPDCuoQFi/9osPu
	 5OwTHS1XeANq/JlXKk6+J07pXZXoZp7ZgMUBx8/nkTF9YfmlQPKTg3puW0D0NM7m9mD6+
	 il1B32mKid1A0asZI5JuwWDaOtuxsvm5u8YVPMx3fK1t4HtiH4WsLDJ8Xs+Y3GBIlMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kb+XraTy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C866606A31C
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 05:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Kb+XraTy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC2B81F00899
	for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 05:44:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795758273;
	bh=BX1eyM7k6tbC4BgpQxYOnwqhZ8IL4aMrB7su+PfCurw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Kb+XraTyOA6F+DCpI8lYAF9r2S40tvfmKkeB48w2r8BBsmw6Z6brrcKNHyh8HW8pf
	 GSoQpRFVYICgFTcBP8CJlrHxQ4ExJ3+378e9XQgvz8pAQ8fMhcwBVzZgp/TWSRCwhj
	 QDzB8keR8pc3GsWyccK+2YYTSJgxoSZOGEQ4n8+OAyRXA9EW+Rf0zUL/EX6o+r2/b6
	 6gwumtX989YxeZdYileiggUlyBeCAMC0ULh5tuSbljSj2/MoaoXAMV4rDfmltFKvb9
	 bqImt+ZcuYWmSojaOBOqTwg8DwUbtNhstKD7Q+HiPDxbFGwDufRI/1WZm2APhoQEXP
	 jZ0VNMd7SqhFg==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6ba380cd8dbso10363260a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 21:44:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFgUktRQAlLdepreDoQYbxYakVyofRJEEFkk73YO2x/JwIpmgxVKExkYW32P6QQsEz1fa3PL4QwiUyM@vger.kernel.org
X-Gm-Message-State: APuU4Z96WgwocpcsUJeluuowtUglhwMnFIG6bLdutGGHKVe2145QYZet
	ywsOm2LfzUViqFXAGTDtiCJ/SqfacI61JNR37y6Xe52coQNG+7+UMYuaU67H3hvpCWGHi3iizfd
	FdxbXKYYBFhjUqI9qmk94nf42lHO4LCM=
X-Received: by 2002:a05:6402:e05:b0:6b4:9919:b54 with SMTP id
 4fb4d7f45d1cf-6ba37f04a34mr17014468a12.42.1795758272309; Thu, 26 Nov 2026
 21:44:32 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119103805.29514-1-research@rootsys.at> <cover.1795701726.git.research@rootsys.at>
 <77bf8917c216359ba7fa0d837688b98d3e1a798b.1795701726.git.research@rootsys.at>
In-Reply-To: <77bf8917c216359ba7fa0d837688b98d3e1a798b.1795701726.git.research@rootsys.at>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 27 Nov 2026 14:44:20 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_3xM8VrYeFJo4oLdaR4OOxFCNNdoyGrwSbBho-RCgVhw@mail.gmail.com>
X-Gm-Features: Aa3M54p9LgI3OLKzYcevEbGHvjKCij4zOgZ4wWompEzUlfhXGEXQV7vdxleohPQ
Message-ID: <CAKYAXd_3xM8VrYeFJo4oLdaR4OOxFCNNdoyGrwSbBho-RCgVhw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ksmbd: refuse session setup without encryption
 when it is mandatory
To: RootSys GmbH Research <team@rootsys.at>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>, Ian Bridges <icb@fastmail.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	RootSys GmbH Research <research@rootsys.at>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> @@ -2658,6 +2658,17 @@ int smb2_sess_setup(struct ksmbd_work *work)
>         rsp->SecurityBufferLength =3D 0;
>
>         ksmbd_conn_lock(conn);
> +       /*
> +        * MS-SMB2 3.3.5.5: when encryption is mandatory, a connection th=
at
> +        * cannot encrypt gets no session. SMB 3.0 and 3.0.2 connections =
always
> +        * negotiate encryption then, see init_smb3_0_server().
> +        */
> +       if (server_conf.flags & KSMBD_GLOBAL_FLAG_SMB2_ENCRYPTION &&
> +           !smb3_encryption_negotiated(conn)) {
I think this still lets clients through when they don=E2=80=99t support
encryption. The above comment says SMB 3.0/3.0.2 always negotiate it,
but that=E2=80=99s just the server advertising the capability. it doesn=E2=
=80=99t mean
the client offered it. In mandatory mode, smb3_encryption_negotiated()
still returns true when conn->cli_cap lacks the bit. Could we check
conn->cli_cap for these dialects? For SMB 3.1.1, the selected cipher
should be enough.

> +               rc =3D -EKEYREJECTED;
> +               goto out_err;
> +       }
> +
>         if (!req->hdr.SessionId) {
>                 /* Bound abandoned SessionId-zero authentication exchange=
s. */
>                 if (ksmbd_too_many_session_setups(conn)) {
> --
> 2.43.0
>
