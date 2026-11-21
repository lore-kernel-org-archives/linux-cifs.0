Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795220993;
	b=jrTx6vDiNUQEFzqSsCWpJzc30EDj1x2OeKfmjWhfMbfRb6OZ6llgEAjnW7ebKXLIiJ0J
	 fQRywDtLmUKoD07Zr+jEctCWg19KVgVXj1SOK9Oq7XuXHvVOR+/lNO/pmz5xPz+QXyKrj
	 QpNUDc4BoK0gUDmnRozUNdi2MRnweN7yJqxzAUC3h3iNEv/XLMd1rsq8nT7JPkYCyiL6U
	 68SNGQ+NAl17iz/LK0vUkig0cEphjMJ93DjVHIUxX9vR6Vq+mP0o9cSt7cBR+/P726FYe
	 2KRMYqlbkHw8SqaRybNBPPpiy2C3FBxh+NvKtrm3dd/uVCQ6/5e455ofyOb2bxEZmHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795220993;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=rD7rpVjyDNmPoXFf48R53o3A1muaq1HYLrGi/n8jnLQ=;
	b=u0rwN76pz9A8BFDbNngTXA7lJ0yC36moYW+Af+r8dw/JZvGlvwOUCL8bWdLYxbf7YRtm
	 oaQKIs6+CODfg8DE3fp0OvyqC/KbkpqZph32RSP2QcrIb+n1m2k7Jbf7NWVFb5giPclVj
	 6Ez+3PHu0sqr5n151mrSw//lHyaUIU5WlEPeOhNr0sxHjlsCiDcgzft8LwNKQRfOHOUaL
	 VRcSA8ZqNq+fn/HQn73VmivB6Aw9J/EYa5S7q/BQ3Gyyj9B5Ra3vMsY9bY4cz0dT2wp/Y
	 MKSpCMUgv5nhgcnXU2GdvR7qpU+on2NkZxa8Sh8Fn7jxCoaAHtlQgOVUkuV30vwlBrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VoS50GYo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A54606A6BB
	for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 00:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VoS50GYo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3C91F000E0
	for <linux-cifs@vger.kernel.org>; Sat, 21 Nov 2026 00:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795220992;
	bh=rD7rpVjyDNmPoXFf48R53o3A1muaq1HYLrGi/n8jnLQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VoS50GYoz23WScli6OCrp42uoHzt0bSQGlahzkogaCoa8UR883PfS997g1VhGOemb
	 omAUOjA4Nf0X0OqCDviwY/JzfotusUP6WjNa3lqJDY+ihoDasF00d8NCWPdJha2i5t
	 78L6SrETey3o6UscVz+u7vm1/3ytBWjt0WnQZtaiK2eb003Z0HvDjckheuSHierV7y
	 +gzlFMpmnV4V/h73CFpKv83szNdhG/xiLZcy8I1YGIQ0wDfqSmvSlaeb3sCaYvIQF3
	 ZDpI2nmBHRj8QQf7RSlSjQcq32YF0YxQzKYZHyR3ELsfWuixpCd0C8+4yBDDl/riap
	 soaBFAb7Y0UYg==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6b8b20b2538so1787104a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 16:29:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFu9eSStpkaOy82k3+xJFbtMtghxoLaEJBnHJphSpns9OhcxKu5vKKvmomR++Kp2naFSp0kxSO3ZwpD@vger.kernel.org
X-Gm-Message-State: APuU4Z8iYOnAg85zbLV0lXCve4dmpPuzjO/0qB6DCthCddTDq/MayDqt
	NCbTcBYknCSXAMSXLeD1APhvpzmN2kocprOtlpOWHtII3swaGmo8IFDIB3XnqzSLYu38eD4tjSz
	NjlncUJO9X5408NiKThdFBMmlDO4L81w=
X-Received: by 2002:aa7:cd65:0:b0:6b5:823f:3462 with SMTP id
 4fb4d7f45d1cf-6ba37e83f29mr2483897a12.19.1795220991152; Fri, 20 Nov 2026
 16:29:51 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120163436.15296-1-icb@fastmail.org>
In-Reply-To: <20261120163436.15296-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 21 Nov 2026 09:29:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd--8hWBZByqGjt3d8E65uJSS8iyc_VgucMvXuE99MRNhQ@mail.gmail.com>
X-Gm-Features: Aa3M54qE1Zkgvchom1ErPwtXwjTD47R_3zEhhGyatIfGzxipZ6T7uhWeq9rzynY
Message-ID: <CAKYAXd--8hWBZByqGjt3d8E65uJSS8iyc_VgucMvXuE99MRNhQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: check the ACEs after an NFS mode ACE in a DACL
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 21, 2026 at 1:34=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> An allow ACE with SID S-1-5-88-3-<mode> supplies the POSIX mode
> directly, and parse_dacl() stops walking the ACEs at the first one.
> The same walk checks each ACE and maps its generic rights, so the ACEs
> after the NFS mode ACE are neither checked nor mapped. set_info_sec()
> still stores the entire DACL and the request succeeds, but part of
> that DACL can have no effect.
>
> Continue checking the remaining ACEs and mapping their generic rights,
> while preserving the mode from the first NFS mode ACE.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
