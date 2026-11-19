Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048503;
	b=npNVUPGRVoUXYZfhQRJG4nhQ7RAWg0536oQTkawl/P3792+AYVo/76teRIH0kM5E6T0N
	 Dazn15JNgGf3XPqhcAz45hmH4qOiLYp0/HpfO3kmNM4Xpiubc32wWiA7Z8bBqKjil58cI
	 cDAQg8sKCAsJqphNW7nxI0dNAfVwcwOMK9NVWSHYcR80+U/ZU/SvDDBTAzz7v3gyDiTk9
	 wQ196ovxkLSr7tvzSslMCKFlq/3Cx6gyRhHHKkMMvLV1CWJCT9Kz0lFYhp5lXaWbSfrpm
	 B4givPilH+9ggemrtivtqIM5mK4Ys+/es/yhaF2qFHwXX2edKv1c2rmKSrXGkU3kMSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048503;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=MBBdgGDR7k0GmtCp45XGw03/tk3C3N8PKF7SzK43N5U=;
	b=PzGDvocrRJoNMzgWY0utkwA03cpK0dUW+ypfbbekOGndQSzu9trWFtoFSOa3Sklw5McB
	 6j0uGgmlj7iYIQfQkZwZ4/T5mPQ4qWAr5Y0WsZR301XfFNRh+FHFtvE7ab4uzW+mQzYL+
	 k0i8iVjdNIBCH9Bnkg5+GWeey6mwO6yryEL/ZaPnymAYIaGfEcyL+RNErxD9EF2dVq+MN
	 VJ/vP3ZP1KvC+t1qBNa3P+0Ntp3hOnNC+pgxoC2kVd9UCsvW4gKI47Je7a0Mgg0Z/tqps
	 WGkNX6yyWXBvhLPKdWyJ6shhdnYXUfZ/8K4ZJayWBHIj3PT2dpiibrCRNhcElAQQ0KA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzdZfoOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CAC606A320
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 00:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzdZfoOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C781F000C6
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 00:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795048502;
	bh=MBBdgGDR7k0GmtCp45XGw03/tk3C3N8PKF7SzK43N5U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hzdZfoOz4qhWIzfgruDW1Kd+gft1453MXvX7LgOndhJMKzkuW7bajHsyoNI4vFFEy
	 35C3B7xRaej32NwRr0CIJIsPQlhjCgBOc/d9antnXYkHB4Ly+PjIF3vek2LprObnXZ
	 dA84J4lXBePzLxKz3NwVFD4e5nlB5V+RZgGD25rpRsD6I/LHJ1ytwQ2vQkAZJ82LVh
	 0p2NF/kSGjeYoKbo+H/nEtfQoRGSpzTx07vkJeCiuKb6T9DiiadItZAZ7BfD4er4jf
	 43BZbYwB2Z4s7Dk7uyz5MXBeatmUqbgiShw4HNaLmJ5w1tS8GL5hZQdY3lADZ0XMyO
	 kg7KLNwdyoG8g==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4cac7a7d3cso222133266b.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 16:35:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE8FbmVrw+tHEmx/fhO1MHkMh7AqCXpkIT/rXiWcu6iWp+h0kHyCUEHKIZhaZxkDrwRsQuZWXP2keR+@vger.kernel.org
X-Gm-Message-State: APuU4Z8/Ryy4WnfFiNSdU906Xk+89f9/pLWkK5bboAQzIy61PVnC4jET
	bEDZCbPEAv9Ad5h28ff+/5SDE1JAhW03SlOKaz9Iok1RIXe+ZxCSJAG1ib+D8Db5PCG49rN9yzt
	Yc4IOtdDKoi9R2j5M02qXpLpH444Ixmc=
X-Received: by 2002:a17:907:9811:b0:c2a:cf73:63fe with SMTP id
 a640c23a62f3a-c510debebf5mr392519766b.6.1795048501493; Wed, 18 Nov 2026
 16:35:01 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261118174000.76954-1-icb@fastmail.org>
In-Reply-To: <20261118174000.76954-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Nov 2026 09:34:48 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8FnWOeohb9gzST+x0oe6_QK_=JqXfqLKZYzzq6Z8EBzA@mail.gmail.com>
X-Gm-Features: AclHuK97zaeMYjWZZ83Hgsf-wGk-vKxVOO46xSw5KQzFmTQ4PV1AujEyr7nL6Xs
Message-ID: <CAKYAXd8FnWOeohb9gzST+x0oe6_QK_=JqXfqLKZYzzq6Z8EBzA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: clear DACL_PRESENT when the query omits the DACL
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -1077,8 +1077,9 @@ int build_sec_desc(const struct mnt_idmap *idmap,
>         pntsd->sacloffset = 0;
>         pntsd->revision = cpu_to_le16(1);
>         pntsd->type = cpu_to_le16(SELF_RELATIVE);
> +       /* DACL_PRESENT is set below when the DACL is requested */
>         if (ppntsd)
> -               pntsd->type |= ppntsd->type;
> +               pntsd->type |= ppntsd->type & ~cpu_to_le16(DACL_PRESENT);
ksmbd can set DACL_PROTECTED or DACL_AUTO_INHERITED as well as
DACL_PRESENT. But this patch only removes DACL_PRESENT.
Thanks.
