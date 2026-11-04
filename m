Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766651;
	b=ctZDLLEvDFsRRf3HBYFIIPH7+cKG8r2ZhiMUTmFn0wwewOs3kU9eZ1cwpRWDFld/MEoN
	 Hcj1LzFnOBKATyKwwmyG/poY6ufe+Zf4wToa79rb4QUXauKtPKfL0MWo/r6wVNMb3vlhK
	 j3WHANkTRbJFzr9LepCOMVZuh91VKuJfsq8cAtYx5y5RVP+h0l/tVjZSka6xMq/kk+z7P
	 VsneXTonMn67S9MaY2kAkNMSP7sGTjMZ40qFZ901KEKUS2R0OH++tQGuy35vrGGl0RiOx
	 DZ740hjkfOh3HY7vwS8fDBvrtJrdVVdboYg6KbkvXSzfR4lD6A8G5VRBmVAOHl4Q7fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766651;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ZpNcQj24yuMM3GQtiTzILqkIccl+qas6VuLsoUlL4Ug=;
	b=r0hLv/Go0FIi8OFHfwKZnJy3QfVkBE9/P+idYfNY1B7brUtA2P73zoEUydbAlZBz2hRO
	 hJmtIDdCwNXf0unlIvK+RM5wSnwrDYGLVTnPn4716f4CsIdCtCsVVYvMhA0HU7hjbLHGi
	 +qXF91qPHfSEAFpKgvEml7Kv29Ya9LS2cDzBCZY5AwRZVt4g+R4Ol5Aps1OgXluxalYn7
	 Yl93B0E7qF3zF1B2LYKS0Sz9bFtd7CVQL6awTukzJggHoODOF7R20gyvS/HXnn3LwMajX
	 UNvqo7NhmJLBzjjaxtlwbwx9Nhdk9nNTKQ0zIZ0Uj01eu727U+GF80dPdM0amvWzcBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S6eMCrzx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8006A606A328
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 04:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S6eMCrzx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE881F00A02
	for <linux-cifs@vger.kernel.org>; Wed,  4 Nov 2026 04:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793766651;
	bh=ZpNcQj24yuMM3GQtiTzILqkIccl+qas6VuLsoUlL4Ug=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S6eMCrzxSqAOVgmsmosfiLt8SlqWRJYLyBn3xFly7Axbs+CcnPZ4suZp+uIys3Jgc
	 4PwgTbTlGU+uYOszuV8JP+quWKwBxKS0umYm/RwW51oNPRYy3PUiyHVWkOxVZxjgx4
	 iyfRVBNLA48avCLJMCo3K1GIR3vb4qV6CJQFbxTTr0vjQgzk8W7P81bBsbroB1LPs8
	 yBB7q/qVivwzcHqmmyFRbQkymuYXeNTeHnwepvXQh+s7v3pfcTjSLsX1p7wwCXwz46
	 CC8oUXW94stSS2g68YvdxCf9/IgebUmbDYhrb+JsOZwoZXblciB5A2GLh+57Fk5YtQ
	 PRfyBpOd6IrMg==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b56221d361so68696a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 20:30:51 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvByTXRTLrDQ6GIZHIknb5XSuk95N+jF30Bnu4y5M9nJkdf/Cevn6K3rCf5NLoRkp0HXUvt0zwvesvORI@vger.kernel.org
X-Gm-Message-State: APuU4Z+KnmK5ZZOUeTidBeFtWuueHZD8gCn5uVh6QvPQIalwiQSrxTN5
	c9+0Ek8iDLW7FYj0Fr5jbOGohXIy8nuxog15iqLkQCHCqYZT+rfAKMypWSXCMwfOH/rDzIMfJzv
	aTk4wjWFsQvdgb1+P6iuF5yTexp1adiU=
X-Received: by 2002:a05:6402:a505:10b0:6aa:e46b:2ca with SMTP id
 4fb4d7f45d1cf-6b4d5537ae9mr7019046a12.30.1793766649804; Tue, 03 Nov 2026
 20:30:49 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261103111453.84804-1-mike.michalo@gmail.com>
 <20261103111453.84804-3-mike.michalo@gmail.com> <20261103171742.18816-1-icb@fastmail.org>
 <A37137ED-872A-4969-A1BD-C23E9B523EDD@gmail.com>
In-Reply-To: <A37137ED-872A-4969-A1BD-C23E9B523EDD@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 4 Nov 2026 13:30:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8ozh-WT+iSLspeZ_h2PM3xLSK4c22EsDD+53z7nbzieg@mail.gmail.com>
X-Gm-Features: AclHuK_UFq3A83cRJ7DhTEK66pNCvFNRdlhviHK4gv1kJtzRQYyXpFPlKH59ijQ
Message-ID: <CAKYAXd8ozh-WT+iSLspeZ_h2PM3xLSK4c22EsDD+53z7nbzieg@mail.gmail.com>
Subject: Re: [PATCH 2/2] ksmbd: add AES-GMAC signing support
To: mixalhs <mike.michalo@gmail.com>
Cc: Ian Bridges <icb@fastmail.org>, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, ematsumiya@suse.de, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 4, 2026 at 2:57=E2=80=AFAM mixalhs <mike.michalo@gmail.com> wro=
te:
>
> Hi Ian,
> Thank you for the careful analysis and the reproducer.
>
> You=E2=80=99re right: in the multichannel branch of smb2_sess_setup() the=
 binding
> request is never verified with Session.SigningKey, and with AES-GMAC t
> hat turns the existing signing oracle into nonce reuse.
> Namjae, please don=E2=80=99t apply this version. I was unaware of this.
> I=E2=80=99ll send a v2 that first verifies binding requests with the sess=
ion signing
> key before they are processed or any response is signed with it, and
> check whether legitimate binding can also reuse a nonce under
> the session key.
Okay, I will check v2 patches.
Thanks!
