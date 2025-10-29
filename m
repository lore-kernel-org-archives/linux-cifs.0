Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15F22EDD70
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 03:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761710064; cv=none; b=UbBpTqAENZn8X/8P55tumA5/rv308rjvpqYrdoY9Z4S0P4nl6GHwq4mMi0u8r2sj0nG6Zz3FRS2QdaLzh/bYpWcZsiou7LQZLX0ae5+mHDEhw++MtYmFYNUR3mla/StGJ0KXQZmL5CqoxUbVzkGOWFON/AmvNv1Anse5K8xB3mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761710064; c=relaxed/simple;
	bh=HYJAyXlItEtkjmzWIn0q9UI8lYNLf+o5ecD9Qg13pjo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RWedFFgFa+d+NjxA+JL86vdKlr7oyU6/yLZMua/Lcm6fZEt1ou/Q0l9uH84QfWvRBh6lqESNP4q7YEX5lOU1w5n5BGRUTZYqYlrPi+PkxFKX2wCaPHB+ol0O6JROFSLv5hNY9cRWIMUmTu9UHquzft0T+uGbbIuaYjdiQGqgA48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FI0Hi7Ga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FI0Hi7Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB64C113D0
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 03:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761710064;
	bh=HYJAyXlItEtkjmzWIn0q9UI8lYNLf+o5ecD9Qg13pjo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FI0Hi7GapxlzHXfbyzhWVYjl9yWgO+dAl4IKfLskzmXxwsCnormdDUjeNFQ++uy/4
	 TKgdoXlw4a8tnsEUHt6ZkzL4ZYt4UKbflkn7qhlGNCU1urtfmZO0ErY+qw8mNa/A8A
	 bZ5/B0048JY1PoghtE6RtOPVYUH91Tx9eyFKbw22cgNytXK4GsjvHX36pJ1QwfPDiu
	 a+4+eWBJd/dkqrv6lrajnPbo9lyq0sY6uM0sUS8beqPfkzCr5opYc6RONmu1AkXiuQ
	 l0CLrpQo5mh7PNyk0TEDt1fbSK996aYQEZUetVQU9YdzZbZp/9JA+qmsW+VUFVTof0
	 DMBOn5GBvRBZA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b6d402422c2so1578038766b.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Oct 2025 20:54:24 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVcBa8A8F2/INgmcSJuNINIOg9Go7VPkuLmXEQL6TRx0JWlyVw1WiArq3NvQtozEYQLlA73MMSVznZH@vger.kernel.org
X-Gm-Message-State: AOJu0YxLXoaBDqHb/IlA4cBJ44/eMRCTuSp/vGXoQxhDlGQ0CjNiBUoq
	RRO5u4RdX4qFoMVVgCq4KVAzAcgwRd2Jrmr4WjmF+NHM9va5fHuhDuViZZedigkD9sNNXCTXI4X
	dAiZKdBT093W807sVpGuWwMLXTryv/oY=
X-Google-Smtp-Source: AGHT+IH1Ig8uBUA62ai5XaFqh72uxSbyVoSyAQJE4SoR1FB1FHmF36cUsplWrbcT/C2WQNvbzYtHWrnCxFTRxV4ocxo=
X-Received: by 2002:a17:907:5c9:b0:b6d:2d06:bd82 with SMTP id
 a640c23a62f3a-b703d2dae2amr143507366b.25.1761710063009; Tue, 28 Oct 2025
 20:54:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev> <20251027072206.3468578-5-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027072206.3468578-5-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 29 Oct 2025 12:54:10 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-KaTt1Y5gcsrWU9jrQNmyNcsmBy-XOht7L-xE=s8as7g@mail.gmail.com>
X-Gm-Features: AWmQ_bk1nzJ2ub4Y_TsifrvNWzStjgZ9baMyQE0dxpr4OIb-4PG9GqNh8QaFbTY
Message-ID: <CAKYAXd-KaTt1Y5gcsrWU9jrQNmyNcsmBy-XOht7L-xE=s8as7g@mail.gmail.com>
Subject: Re: [PATCH v4 19/24] smb/server: remove create_durable_reconn_req
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 4:23=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> The fields in struct create_durable_reconn_req and struct create_durable
> are exactly the same.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/server/smb2pdu.c |  6 +++---
>  fs/smb/server/smb2pdu.h | 12 ------------
>  2 files changed, 3 insertions(+), 15 deletions(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 6b3503c7bfaa..3e8344fa163b 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -2766,7 +2766,7 @@ static int parse_durable_handle_context(struct ksmb=
d_work *work,
>                 }
>                 case DURABLE_RECONN:
>                 {
> -                       struct create_durable_reconn_req *recon;
> +                       struct create_durable *recon;
>
>                         if (dh_info->type =3D=3D DURABLE_RECONN_V2 ||
>                             dh_info->type =3D=3D DURABLE_REQ_V2) {
> @@ -2776,12 +2776,12 @@ static int parse_durable_handle_context(struct ks=
mbd_work *work,
>
>                         if (le16_to_cpu(context->DataOffset) +
>                                 le32_to_cpu(context->DataLength) <
> -                           sizeof(struct create_durable_reconn_req)) {
> +                           sizeof(struct create_durable)) {
Please check the specification, Which structure name is correct?
thanks.
