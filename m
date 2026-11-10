Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794350740;
	b=wtXks+qnZ/TlmKd4px5LydkXcWAyzZlK5yjYjjnQ0SOQHbTFCcT5VnOniYlJjqEh2ZR1
	 yJ4bifsbhI4RPvdixOlzjIXpNUWyDv6Ezbxcjy/MuShsYHrqVk+D0YvvImtIliKV9X/+I
	 izYA9P4uVrw605t6JbMerjNjTXApD9pTwetrDpogpcEIL8m8McPH6tCdoXUkSJ0Q/5dV6
	 MsxiWLMrkl/Hg/xQZyG+wPh9G6ZgfWPY8sP8BrxbXAEd3/uflVQTg8H/IHBPOB+rrPB1S
	 qtNde/2os8wWuYbNfeFtsGrLdT2tN6dhC4IHwORdqMrEOMrTfdgVFGcaRsvxcI2wXxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794350740;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=gC/3PHdzb8aP0ix2BPwQKzApTe7iMnrik2lZtQnclVU=;
	b=DkoWkdvnHbY7A4YaDN+lhJouwnJ9bOiRwE+nxNYbBUjndTb6LLDnRIlxEEvq6r7cQeE4
	 HN2wrgp8Yl9ay0gzpS5Jis+Yi+AnfLgUkPPCrIkySQg5j9puSH16eGWLwW7CsATOKbd0q
	 bMcXd1C9dan5cR98oDJa+xX8KQyG1YmVd6WVTJQfJxn6t4ztEG0VGIVh+f0FBoLD5H7Es
	 Mw8xzA6dmsBm3PIE5hI1DjuuI8dFqiZTwVU6PdOz1g6AnA1sne1IzXEMfL9E78MjTYoM4
	 g6qYRMgfxciPdNpdfHkDiUrH8/bc4j6AimCKkyM39ExpZ6ffb4I6bGBdvzbdS+y7EBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTVCOboz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3440606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 22:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTVCOboz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981EF1F00A00
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 22:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794350739;
	bh=gC/3PHdzb8aP0ix2BPwQKzApTe7iMnrik2lZtQnclVU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OTVCObozu7kKU41N8mLmGziBG+p0WZgLBP7UXKn6Q29rjwIVKTwPEuo1ideQ0iuzc
	 hJs+XBjAMQaU6Pfzq28vm4OvbsqhhOweQqRb2dKorePycusEg+rRIaNWQ3h/D1vJQY
	 UTGxv7fYMFojLvMFLxUhb+24Sww2maLGk361Vzuwn5DMKVsXyjkn+J3J6AgnOZiyRz
	 eDH2DpPvzPyqQZ9wYHBSIc0dYKvr2KScrmg0YJjD0wZCxigT2UEBlefDUQw/XCcMRE
	 G3N9wbTqUX9FUFpFWGZitFpn1xy1mD3F1AIQKi/ji7pCGW8l7N5rJFdrD3AKPl3lMo
	 RqBfypYuf+j9w==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b587591414so3004765a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 14:45:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHN3itKEgadLFt5GYkFyqpXoRBCOG6Qv+HtYTMWFwq1saZvFcr7DwNo3pAEncawzPvAPJy9kKVdCGKZ@vger.kernel.org
X-Gm-Message-State: APuU4Z8BzPiogRukz/v5CSwCzNLL2xRQr3IBLUvTjBWSGdHnUx9aG+Jr
	7fUdzKhKTjoj3sOWruUYkES/NFSlnGh0ttCPmxslaTnaEuOOlje7WMmujtdo69PdBcTwjZ4Ff1j
	U9RrTZEye/JLo9Dq8h9gXgHdeJHWlAPo=
X-Received: by 2002:a17:907:1c98:b0:c41:b94c:4539 with SMTP id
 a640c23a62f3a-c506698cf92mr36479766b.6.1794350738210; Tue, 10 Nov 2026
 14:45:38 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261110161659.481208-1-koray.fra@gmail.com> <20261110195625.3211657-1-icb@fastmail.org>
In-Reply-To: <20261110195625.3211657-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 11 Nov 2026 07:45:26 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_vxYCEXAJPSH7i5+0Oeaz11P=7-vfA7yP-KO=z569vtA@mail.gmail.com>
X-Gm-Features: AclHuK-y36vPoMEWPglc_TrgPSNoOyYvTeFUVxPR0OlVDV5E9G5sltICxGqoAdQ
Message-ID: <CAKYAXd_vxYCEXAJPSH7i5+0Oeaz11P=7-vfA7yP-KO=z569vtA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set create_time to btime in ksmbd_vfs_fill_dentry_attrs()
To: koray.fra@gmail.com, Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	mmakassikis@freebox.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 11, 2026 at 4:56=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> Hi,
>
> On Tue, Nov 10, 2026 at 05:16:59PM +0100, koraynilay wrote:
> > ksmbd_vfs_fill_dentry_attrs() queries vfs_getattr() with STATX_BTIME,
> > but discards ksmbd_kstat->kstat->btime and unconditionally initializes
> > ksmbd_kstat->create_time to ksmbd_kstat->kstat->ctime.
>
> I tested this on a kernel whose fs/smb/server matches ksmbd-for-next,
> with files and a directory created on the server, so without the DOS
> attribute xattr. Before the patch, a directory listing reported their
> ctime as the creation time, while a query on the open file reported
> the btime. With the patch, both report the btime. A file created over
> SMB keeps its stored creation time in both. smbtorture gives the same
> results as without the patch, and KASAN reports nothing.
>
> Reviewed-by: Ian Bridges <icb@fastmail.org>
> Tested-by: Ian Bridges <icb@fastmail.org>
Applied this patch to #ksmbd-for-next.
Thanks!
