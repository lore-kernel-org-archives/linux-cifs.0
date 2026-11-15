Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794702917;
	b=SIMe+rx0MaOUvy6yce2G2nzqk4SnaBm9FKRGPGhUUwDCnRPrRmGESfcihYTYRb+3YeUy
	 t32qADpVWcQN+mp2Osg3EkZzwJm2oUPByM2U83wbp7687nPzN6KJ4uXpYNE42TyzyHfkS
	 9aQ10psn2Q8H6iX1Y4PmLB1KPocplwrBlNaLoXmycA+21Ytq1W3pjv0ITHPRMADPlOond
	 9SZcpcWpRahcRJkyXmWKx1Vucd6zhbiEGADWFCQW2ajxAivqTlkDKVP+e7+FQRikH1B7i
	 6Hvo9XKieMcYqLNZhI+/v3rKam+6M7F0b4N+jc0fYice1kJs1LD5SFV2Q9HkYifL0xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794702917;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=vDrv9Rfc66q0u11nw2Ofk2AFrGnK5EZJAdaXF/Wufrk=;
	b=Dc/QwAx2Jc4Ki6ZiHa+sexUmqYQG/7oVxYaTdPc1P3tuO7+iz0/Sdt11VlHGNH/W97mW
	 VdB9mYnPC/Nxb/eT0+BSYRIVCsjQ7AFWn3UjLRZL+BRNzuG+K6dhmg+46YoGwDQ1yJUSl
	 SnLKz97YFrWxc2upbKUvrv2z0bjM8JSF5AVYd9lG7QkNTEJ3v+GWMK/K0KX44v5ZwEy+d
	 BkGyoh7ybmXKHcX/G2sbPiw+cut5ptnWtX2WE49dEqbBrsofnPojvae9Ix2gieoAl2HJb
	 WjYTVcs13612FPbdPMm8uM6Uw+FiiNWtu8A2KGQFxUDaXr2axAFV+n+LPj5XDZZPVXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8pcmt9U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB5A606A339
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 00:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8pcmt9U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9E91F000C7
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 00:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794702917;
	bh=vDrv9Rfc66q0u11nw2Ofk2AFrGnK5EZJAdaXF/Wufrk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g8pcmt9UtOsFI1fo9CxKbYPTzvsqw0sWH9ACzZvlMR51axd53xpfjIJHW3wwBJjhq
	 FFVA3mzmsjlRj+C1s6krHEnLtpMM9pDtWlKfCuGdddXd+8WUIwYX2wkDUE+o5um/Xh
	 R0P0QjTTbmMouATSYvV06/vhD9iuQMomja4hTmI1n4CDHkYoU9Kyqw4CR/7f+hjdav
	 TqpEA9lxeek3+otYFVTutJ8EzMNvgyVLTFd9Q4uWVBUmqS7k5s62pNOnHkImiXi2tN
	 zwTgVauW/K3/DOfeSeC1qpC2kUx9GFCG1zN9cx3+ZdFSBcQ7EcZCyYzd49AIzAJlgS
	 Ofb4GYI4WnJCQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c5075fa7ed0so414223766b.2
        for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 16:35:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF7BT2mXNoKAXCmN89oF63jwm0XmfPS7c1neYZvQRtHEOs5amlMsCn/8dnGCeYCemNJkW1Wl8xvb0yK@vger.kernel.org
X-Gm-Message-State: APuU4Z/GlAUFjsO3nhdpM1hYkhlhwKP3ToWbyntQqpdGzI2OXd1kRz+W
	3OnKc5JX45Rkp2lFtE4vCIGC8bux5B+fq1K8JmtCxXAconrtPkoCPHEzxkEezi2MkLsGY37rlR3
	oLUBeT0LZbSxxJGB0LWvv+DI4DyyGNpA=
X-Received: by 2002:a17:906:c114:b0:c46:8913:d89d with SMTP id
 a640c23a62f3a-c50962ecaeemr500449966b.14.1794702915613; Sat, 14 Nov 2026
 16:35:15 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114-chipsatz-gutachten-geklingelt-81574928a5f4@brauner>
In-Reply-To: <20261114-chipsatz-gutachten-geklingelt-81574928a5f4@brauner>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 15 Nov 2026 09:35:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91kBcAJTwkP11gN2igRkv8w_4sFgyxbtiCDhkVeLgs7Q@mail.gmail.com>
X-Gm-Features: AclHuK8d_OZBXGk4HXH5KANpQvxUhIOawFDebvYhDrOGOjv-Cq0-UfMC5ZNXA8g
Message-ID: <CAKYAXd91kBcAJTwkP11gN2igRkv8w_4sFgyxbtiCDhkVeLgs7Q@mail.gmail.com>
Subject: Re: ksmbd: SET_INFO modifies frozen filesystems
To: Christian Brauner <brauner@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, Jan Kara <jack@suse.cz>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 14, 2026 at 6:38=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> I'm working on a freeze protection series and this is the part that
> affects ksmbd that I don't just want to fix myself.
Okay, I will fix them.
Thanks.
