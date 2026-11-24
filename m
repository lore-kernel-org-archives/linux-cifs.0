Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795563159;
	b=UbbRr35QP7dBmKXk2ZMSNM7Omxa7Pr78mlVZ3TxOkru5+JEeoPx6WJxdQavoDbK0XHyA
	 n9yYFufZSL4p+IqTY7GcraIuFbtATiniUpEDYzsQ3lseicToZlpZEFGC7LjLVT7ZSVIog
	 KGiwV0In2pZweIxDDd7QfTjOq3mntQphPMTtU+ZqaeBPB5CHJ9R8hHTkiqwu/HjYlv49x
	 2a5c3ne4VL5VeC59hB5A3120/IAnCKN/3l/dIQ5nMVMKPlHCH4vgjTAEcJcmylW7RWWLo
	 VbizIo7Lz+9HhFn5VaAYoEv1BC8pA6j6NXNFL+fL2ZM0FW0/cpAZjFGIXyt/8hRO2iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563159;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=lfQAjb+6J2xALiZM6i0rUZxAcg/9jF48bIl2h88yndY=;
	b=PhMeCjb/9yWfJJs693rYj+N5uWcbJyQh2LcG/QpizkoOa+yDAmLBVMU9DaPE9IWxcHYm
	 KUQilmqtFeWpP83Z/D8hjL+mIt7bVXBtIlOXnnBRNTXGPZ0aOftdG3b/RRvdqfnaScDJj
	 5rPRvcNtdDwIm5HyibvatUaOwdbclbRp/JjVA0wx82kqXVyFL14Xo9mdqR/0fzGiQarK5
	 e7OF7crmUaXc0N5WD7xRKH7vcn31oKePd9w8lwwRmi9ifPdmygObC2OzkBU067jzKEixa
	 dlEwJj58CsSfdzFgOvV9V6NIRxI3wR3spkiiZ9UnsHs5o0DJbzRT00wXuUZ8U4CxQlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gPuPbpLj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1287606A31E
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 23:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gPuPbpLj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 861C91F000E1
	for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 23:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795563159;
	bh=lfQAjb+6J2xALiZM6i0rUZxAcg/9jF48bIl2h88yndY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gPuPbpLjk7YHonQVhtVQenmUgidxVmYpr+RoiL2xcu2Man4kiq1/bcCuaqcXQFLRM
	 RYdDQBj20YiIxkIIMifS7zkZpj7/Y+HtliRsQbQ3dfjlh31vg18am0OtLdKvuuzj33
	 zdqR4+fQP1a9hLKLaXiRctct63y0q+ylYwaMkiDW5Co93DbLo+OiHwrwyDdwhJPBZW
	 Jp5yOMsabXONSY8R6HGFSHwckl72VGns+sVDQQmZJv+1oFC9ymCwMfVTkg9M0EbY7y
	 oKZUxIcFh11KoYtTpAnsqC57pzPIYXhXkSy5edJjFNzOw65lFIQfSvUb+epS43PcV6
	 RZP4L1i2AWujw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c50ac25cdd4so672727466b.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Nov 2026 15:32:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF/9bIwbaFlXQ9j59XLJ9um1TTInFfCKZhI7CHE8Vk1ThpjvqWdXTVT1ST1gi9+N17DUAdnt6JnKRA8@vger.kernel.org
X-Gm-Message-State: APuU4Z9HHFIQ5ZizbyhYKThZvEP3UMCXQZx4JouN5CPlKstTFmeklNtm
	1htUQWaFBJLPr++belaIhMyQ4JncHkYbqc9iLeJu4qIBMo50IEgxnouPsUK73Rlp2GXaiO3Y+Ct
	x+6RuD1GRUKjOaW1c6owcJ5n12ypkVhM=
X-Received: by 2002:a17:907:2d91:b0:c51:982e:28bf with SMTP id
 a640c23a62f3a-c51982e29d1mr227865566b.40.1795563158133; Tue, 24 Nov 2026
 15:32:38 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261124075613.469257-1-zhang.guodong@linux.dev> <20261124075613.469257-2-zhang.guodong@linux.dev>
In-Reply-To: <20261124075613.469257-2-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 25 Nov 2026 08:32:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_ekTbkqXcnj-8vZTTeVPBaCbnw2bi1f9zWfVA_Dzr6_Q@mail.gmail.com>
X-Gm-Features: Aa3M54qUQFBsk7nN2pWF3fpIE5MPf7sFg3rqa-Twf6_HIpn9WB9u3Qt4gCrVWsA
Message-ID: <CAKYAXd_ekTbkqXcnj-8vZTTeVPBaCbnw2bi1f9zWfVA_Dzr6_Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] smb/server: fix little-endian values in diagnostic messages
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
> Convert to CPU byte order to avoid incorrect debug log
> on big-endian architectures.
>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!
