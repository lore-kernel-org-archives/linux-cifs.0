Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795563179;
	b=Ox8O2btqbnwnVS5SKkFj3/3fkkhh0L28iyeYIoTjXSd+0kwOyUDLVZ1yywZil0wk8F3g
	 rNClqNLlh6pkeYvdxqn5Rdk82sxF4CBcdw64GmZgpUKkGGtoBflxnFo9BZPVious5b8Bz
	 WQbKCDTHYL/wCEKAr5KhmuF/ToWQl43EC4u8bbh6rgSjhX6PRVwacLswLqxKEP1mdHC63
	 Gur6Zsl9feCefMS2G/KI6INSG3/jOghMhwBqrGyUhRbi5s27ddjouKuRSM92X4O03UMxl
	 gQFWe67PKFE0I4AAfQDNe4JRA7R+llvZwfcAeMWaOPG6MUY/JLAXcwYozTvyhMMq78w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563179;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=biO3B9Kl/OErjoAa33t6cDrrXZV7UDFM5oyQJ9E7oag=;
	b=PQZQWmCS5mJK5ZxUzS2dMr5Q90EXeYOc6hcO0w2DIn264eiWna644VkQJfGF1toesHL6
	 MLP7ULDzQMb78p2hpvGaIFG5uM0f0ZUDzGJqB0y+Ju3jaPB0aP3sxPTK7TzxfOf16ZlUZ
	 VEFbQmpZeia32HbxU1fzRs1PNWzmfm+JT6r4i40R8ESrtEItHDmGCWCuE8hgehuLlkEIi
	 i9/MUPCxkgVtTWDVx/VzuYMooCq+zfu1iXAAVkYZKrtp1GJ42jWMjEu2ZQMxG9Ul3zpSU
	 cVnA+8NbGVAIbqyX0aRr5nSUPBtcfPnt+zGOrUoeT0q9oeyiTr0KA53s7U58swY9z0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBL+0eAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDAA606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 23:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aBL+0eAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E211C1F000D0
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 23:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795563178;
	bh=biO3B9Kl/OErjoAa33t6cDrrXZV7UDFM5oyQJ9E7oag=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=aBL+0eAlBk0bY9QF3GNdwqiLBUJjNLzfZhlzuL390QMlbfJgBeLJSfgkkaDTNOtSr
	 YCvWCoO5YeRNNnZTMvULdhcKA+f1zSMNCU3OgOqkv1zs178PY4XRZadG+7hmaZWP1u
	 Ny2+IQWIbjgtoLo3kT8n90XfUUVEk1qaCrbvQLaJPi2rX9oY1pRHmWo3n5XvifBAN7
	 LiqecKsb+y9mDZOxmNO+vKUspKMzufU2AA+T6qvaMzI6/OALmsZu5jx/PtTJqyXJU+
	 whf+irEH2ogmZIhcD7OT3ApX7eRRnt25BxBCtwvEOn4GZ4jZu0lCTOLePDf1OCuyOU
	 mYKfNt+xyH6Fg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c50933bdf4bso999419166b.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 15:32:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGaj78UKiehhrgfczRDZsnia3G0lsGOgNJvqAxYHnuRdieoBU2NnzANT3+XpAikKs5A+9J2k/0fGPs7@vger.kernel.org
X-Gm-Message-State: APuU4Z9jt8T2TyTYHxKBfzkwjG2fzT97u1hDUGPDc1MCwPTKVeLc7bZs
	vuee0AdhNtNziKKk9vZxv9YPj4VGQCGthE1EV2cFh+1qT0kLAM/qAvU4zMRVVpRHTyI1r262xA6
	8O3CaRvDjY5EvT9Vsu7GkB7NF9mwpmJU=
X-Received: by 2002:a17:906:9c89:b0:c51:3b7a:f0b6 with SMTP id
 a640c23a62f3a-c513b7b053bmr1319019466b.3.1795563177553; Tue, 24 Nov 2026
 15:32:57 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124075613.469257-1-zhang.guodong@linux.dev> <20261124075613.469257-3-zhang.guodong@linux.dev>
In-Reply-To: <20261124075613.469257-3-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 25 Nov 2026 08:32:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8UDVSs_Nxsz7rcsjGrbKv=J-zdTm=Fidt8u_9Aek5VoA@mail.gmail.com>
X-Gm-Features: Aa3M54qvHh-lyDR0o-1PM3Iqbw134GeNLQilOubGkrFzqadgMzcOOniYLBr3n4I
Message-ID: <CAKYAXd8UDVSs_Nxsz7rcsjGrbKv=J-zdTm=Fidt8u_9Aek5VoA@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb/server: fix file name conversion on big-endian systems
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: tom@talpey.com, senozhatsky@chromium.org, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 4:56=E2=80=AFPM ZhangGuoDong <zhang.guodong@linux.d=
ev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> Use CPU byte order for temporary UTF-16 buffers to avoid incorrect
> file name conversion on big-endian architectures.
>
> Fixes: 0c180317c654 ("ksmbd: add support for surrogate pair conversion")
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!
