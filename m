Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795087665;
	b=j04ueKAwkeaecCepI8jM7qaD3wo50c8lTN0U4jmo3JKmlMoRA9IQlecCCWoB2AndZ0J9
	 3QMcTHtlbxSVO65cOFrLekJCg4fU3uULU//AG7UkYqtZMJ7iwxcCvKHYPii+LJfWoS+4l
	 r/uicp3o2ts5fGkiKPMTB33AgdKu9JcY0ZMTyftJgst6V0ctMaBw8rdmC87Ry+jH2IhQ6
	 3x2W7GB2Oaet8GeFZcSPZNSkOpsV1YKHhcqW0qRFPTMi5OeRiKEcIPl39WvKSFKY/5r4V
	 m1EAISLgrJRrdq+q2RLgvT/FaXlMlH75PL1MckDxMUO7OR/vSfZpT5Kvk05yfTjQetQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795087665;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=C10/UwY0vgcLZUDt7ami1ayVX3pRMgH9t04Cv6vtLks=;
	b=AHDfrqviZIhKIqfeil2s6al/w6LZdLG0nfQqE1Vot3otFACyz83JB+aQuFpj2fsBavK5
	 mecU/GWwK/z01qh5A2YuWIJzIn/8SoY0LV/VO9Io3AoyWwm3rk8DUrIgOpuEqf+JVE471
	 KdjHaKQiuuA5x4WtOGI6YNeOmripsn/lcP+aS7U0oynlXvV9JMQOhRQ6ay39LvbPqbb3f
	 RlMA2sGmjUD/deVJiSwIa/3aGmKhpWYLv32wXlwJHAc2v+yd9knOF6Jn4hVlU7zTA/r5N
	 iXkF3MUGFk7wiCzdrFTod6Wb13UQNrlg7Sddr8SBiDLwSGTweII+FwFordl9swsK4Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uk3I7Lym;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 574BB606A324
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 11:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uk3I7Lym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0511F000C6
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 11:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795087665;
	bh=C10/UwY0vgcLZUDt7ami1ayVX3pRMgH9t04Cv6vtLks=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Uk3I7LymMiWuUB2KZvQkAIiIxL2Evti5+MkU3kJMuCbAoZ3Ys4zh6J39qyj/CuOeN
	 XfMuNy8J9gfXjzXHoO4RFdkahRNtpGlis8HRxP+nKoJhHl6kezaKdyPHAVClse+HVF
	 GzQr5scZZrKr5TPHpf6C6c8dER0nkI34kSCn+ZWAJ53wU0LrcW+6l6TlPRnbKhBFAT
	 KZETaAWmgOFH2R5Gigt3g/CH6s7exeCvZ7/tIGJ8ASZ2Tt/84U05yxmyfc+p4ZuVXw
	 b2lcOI1X/Xr3O7grfXLG89iD/GzCWVu9zR/o7jci1xvvQVtlNfsbObhqQ4ozJoyebH
	 UDuRJEAdGS7ag==
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b7ddb99db4so723037a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 03:27:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGXzwA1feom+agqbhcx8yIsHUnnKe+bNkuPubsmR2iGJtSauQm7XZPJq+IwQfPeuVpBInptY8lfx824@vger.kernel.org
X-Gm-Message-State: APuU4Z+4F/pm7MN+m0BLVFw6VtcrlOLl+cHbz35OnTeTE2mxGzXPdnkE
	vq6ekxz/X/hAsckegZv8zflLhvKLbciz9r/uE7i1r4pKVViDH8UqE1wBdvk+pnlZaPEVbFGvXRQ
	w7/4vyz5D38NxKfUeZu2ubrbDmT1BJOc=
X-Received: by 2002:a17:906:7946:b0:c50:d92b:6f40 with SMTP id
 a640c23a62f3a-c510e2d5928mr493622866b.20.1795087663605; Thu, 19 Nov 2026
 03:27:43 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261119065652.116074-1-icb@fastmail.org>
In-Reply-To: <20261119065652.116074-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 19 Nov 2026 20:27:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-WY1s-4rk37QZ1TKchby_+n1LD44tPiEVWPPQsVh-TUQ@mail.gmail.com>
X-Gm-Features: AclHuK8gH4_BlZQVcilNEIdLYT7RBGGX5b1cm_i5R1sumAtwAaGEqiEf_qqO1PY
Message-ID: <CAKYAXd-WY1s-4rk37QZ1TKchby_+n1LD44tPiEVWPPQsVh-TUQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: omit the DACL flags when the query omits the DACL
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 19, 2026 at 3:57=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> A client can query a file's owner or group without requesting its
> DACL. ksmbd leaves the DACL out of that reply but copies the control
> flags from the stored security descriptor.
>
> The reply then has DACL_PRESENT set with a zero DACL offset. That
> combination describes a NULL DACL, rather than saying that the client
> did not request DACL information. The reply can also claim that the
> omitted DACL is protected or auto-inherited. These flags are wrong only
> in the reply. The server still enforces the file's stored DACL.
>
> When the query omits the DACL, clear DACL_PRESENT,
> DACL_AUTO_INHERITED and DACL_PROTECTED from the copied flags. Preserve
> the other control bits, including those describing the owner or group.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
