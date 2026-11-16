Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794828981;
	b=0DrjxwWkv7AAwlzAxKY4ZDMuaQ/B3ah6H3YFWxp1vakRzspRkEn4Ld70gCRwe3JjzaNy
	 oubfprT07mNThbzEP2Kp+yeW0oEiNVb9sMJMn2czcR+giTB0t77Z9YIF5UmItKjZJJudb
	 OtZFKMq64dgesJlY+IEyd23LGds1cJ3gdPG/wPYRxppqpNGtbSiiWfb4m0Id3/rJHuRnh
	 27y8MQtLLUEf1MmiluEJ6SPBtK5bARH7UBM0Sxyit0MJKLc0x3xBqdZKyFW+8BurS5Bo6
	 jFWaeN+LIPUXV7kpmEzJrwRSpNt6x6wNBDg/mCp7DoR1WCtHKkdm3Zr7iu5vbDCJyHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794828981;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ftA2JByeFr1zVyGnVBan/rtISppxPrWqNY+56v5QRJc=;
	b=P8Ah6r9AtMF4Q6hGA7B1o06JgzWR3YY3tvItGkLm5SocqdARnH4Y1fAMaGIKkmDAZ4d9
	 GcYfM3nfXiKnMfrA2RKb22Bt/gKTfbwCw5enfOEaoPqRttPHFSvuYQ0KiwycnRzvk4qj0
	 fTBZpZO/Jsskt/C+HPrE90Vy9SL9RiwHqY1H1500dUm0jtOqho7rau2Z/cXe03NXkFEVv
	 bw/ZpMQTLWfI96jj/f3qIvwoH+0Mp5y26wBXIGbQMn0r+AgPrExEqpIcuxK3166TO3SUh
	 XYJG0mc63x1XIJFj5Ab2t2ygQMUy/8UenIzyDpXT+quqc6/Hp4+EpBURXhxlnvPq53Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L9EcVBpp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13005606A31C
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 11:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L9EcVBpp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53331F000C6
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 11:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794828980;
	bh=ftA2JByeFr1zVyGnVBan/rtISppxPrWqNY+56v5QRJc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=L9EcVBppBBPQg1aXp/BJuxPl3i8yvFGvEMrlC0smxoPm3tSheKH9d3YvHrskMf6Fe
	 SEe3jf83/uskhIZCxMFx3OunHTOoU4aKF60kI6Ur3gOFLo6YCbU5u46Rg4xCpXVr19
	 C+zm55RCWv2GjnBZMNbSgCWvNSVtw+6/NFEVqxneVl+Giz7NecLBH5loGsRd13eDkV
	 jA2kfqW50p5OrqWG6gYIe25XHpa/x0V2R24F7PxbfoDP730+Ra5BLZLtbJCEYI1V+b
	 f0x7MPW/LKYo8q0gXFZaoejLguM9362BovUB0qeKh1bMNB+2Mtfy+bK5u0ikNzEChF
	 ZoKKHJRbXVouw==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-679a2b5fe87so3248041d50.3
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 03:36:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErEfIkf6g/d9oUbOi5onQMzC9VdYi6yCxfvbhiopa3d8svkpg/5qzTOwK5OzpuHjBBkCdmp6YBHAb1PX@vger.kernel.org
X-Gm-Message-State: APuU4Z8kjjaca0tYmLmIvFdfc9thzkxJp9nKERr5z8hH9xWuPBzuyVB8
	luu1vMQlZ2uCbyTc3ISlUOOnB6z3ggUf9xMdk/+evXdMZtOln3fFbpoMew4SHVyUus1jJIdabxE
	Ww0DKHmlhjXeZK4xsaiQ/nZ+BiWhjl7g=
X-Received: by 2002:a05:690e:1383:b0:67d:b7ed:26f8 with SMTP id
 956f58d0204a3-67db7ed32c2mr1205204d50.36.1794828980027; Mon, 16 Nov 2026
 03:36:20 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115155308.415734-1-koray.fra@gmail.com> <20261115155308.415734-2-koray.fra@gmail.com>
 <20261116021448.2485495-1-icb@fastmail.org>
In-Reply-To: <20261116021448.2485495-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 16 Nov 2026 20:36:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OPEuHith1jxfLVgM5tPkBwhqoSCoAPP+8a2bRf1+H2Q@mail.gmail.com>
X-Gm-Features: AclHuK9Oe1gt6dpIFRw0z1dP8OWylUMkNp7cQRJP7XjUyQxRUzC9P_JwGdC5ByQ
Message-ID: <CAKYAXd9OPEuHith1jxfLVgM5tPkBwhqoSCoAPP+8a2bRf1+H2Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ksmbd: decode version 3 fields in ndr_decode_dos_attr()
To: Ian Bridges <icb@fastmail.org>
Cc: koray.fra@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 16, 2026 at 11:14=E2=80=AFAM Ian Bridges <icb@fastmail.org> wro=
te:
>
> Hi,
>
> On Sun, Nov 15, 2026 at 04:53:08PM +0100, koraynilay wrote:
> > When decoding a version 3 user.DOSATTRIB xattr, ndr_decode_dos_attr()
> > discards ea_size, size, alloc_size, and change_time into NULL. When the
> > xattr is subsequently rewritten, ndr_encode_dos_attr() writes zeros for
> > these fields, clobbering their existing values on disk.
>
> I tested this on top of 1/2. A version 3 xattr keeps its flags and its
> size fields when ksmbd rewrites it. Without the series the rewrite
> cleared the creation time flag and zeroed the sizes. smbtorture gives
> the same results as without the series, and KASAN reports nothing.
>
> Reviewed-by: Ian Bridges <icb@fastmail.org>
> Tested-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
