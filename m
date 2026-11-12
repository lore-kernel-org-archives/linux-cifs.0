Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794522865;
	b=eo03oe3sf/G7O08KgAUkuF4dBgJaUTPsAAE70skQ8lzFqJd+0WG9oerXm8fe+yaV4Lzm
	 ArEdDj5a0zD7mgzF/biPAFMEIzWJZcJ0Yi0Sa7fxWQSXxYKI8tbuWjmwFN1PWI0tgdfGI
	 kiWut3GsEefQmEWs6S/cEpVTjPiwnXR4r8xZAbPqEPhhdcM/jfLe+xAt9WzwDOVT1/Pfb
	 +jDYIKACck5JGp10awQfNiZsHidc+XRg8j0XyKwGyjhwrOmTZkBrZHJkSLcF5n5WrTrYK
	 lq7Nd6ekYX5Dc8epx1ss/xzMs2TdmMGM1DIG4FTDlACnE3CF2rI6Iycy6WIVj//g/4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794522865;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xGWAwNDnbQAoH+VcWS/eK1bc8gnUFywi2IqyuToUcKQ=;
	b=T+nj9TdXpc3sGDJPKR2schbx/pSPvr0BmLj+kGgwXi6iGGTs8xQq6/CLQ0kSja+VfES8
	 Ax8OKZ9/aYigcphxhWS59ER1NXHaSpeEEkQEVslGAHXnS8M+ot5gNqO4VPMMWZ6npMwFN
	 t896214GRoMXAAk1TjSIlegJiaAYtCfwTfgyoBDmP2zNn+ltCmuIaezliaMKRhsL8HAQu
	 dUDT6QVJMazFGBnnKj6JFuAiLrWx4PCGlbpSJPdmLymGISfforKyLKw5kj1mgkUDvwa6e
	 aME3RJ/m4meNOb5SF8fPS5lFIx4gP8vc8FSArfLTRYIuZc7KhjBjJYfPjo2VJUkWpIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2U5ZZm6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAEB606A321
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 22:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E2U5ZZm6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655631F000CE
	for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 22:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794522865;
	bh=xGWAwNDnbQAoH+VcWS/eK1bc8gnUFywi2IqyuToUcKQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=E2U5ZZm6jS8B4+jl80YtHjY4vgWgA2R8mTKPHpxwuyA5oK9Q+ZugRcJ4NBriynvOz
	 hjS0onr5yTTyNLmulKlpnexs6WqMXTLzUQLAwP1ZNqIQg6I+aobsX0OXjWUWfcvH3y
	 lZJT+mIRjhEeIn5XqEMLt6fylWHq51LGTGUhcjnXW0s1jOZH6+LvQMKw/8Dj1BdH1s
	 05Cq0jyjtd7dFftXd984daBsEKn+4r6nsxhrc+NacXIU3zZXwqPhUidhfWBntT55tB
	 roT2O5nP875Tnmq5tehni48fus36Jiv9f/O7sZfWFe9IUNUCKvQJDNWD3Wi5kAXUnR
	 GS4wJRr6/GUdQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso47274166b.0
        for <linux-cifs@vger.kernel.org>; Thu, 12 Nov 2026 14:34:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGkMRU0wSlLRLbMgwa5V8BrXFxzg/BR7/Pc3EhIc0GD7HrTLxCDQryhfKxR+2BRH5S6NXjkuXWnRKnk@vger.kernel.org
X-Gm-Message-State: APuU4Z8hQfaj/hBc506g0Pg9dWjOa+8sLzL4aXK2mu7LjJUl+A9IlG66
	MMhFRDxKqF2wM5Bvh3H+NvmfourVhJ5eIM5rAint1mrzBU+gZRPvizLC7acQeQ7dcDUAkVfAhrE
	lPnChwYsQ9EsMXvvPa5wklT0sJ0hekiU=
X-Received: by 2002:a17:907:7b8c:b0:c42:bc58:f21 with SMTP id
 a640c23a62f3a-c50963856f2mr54017766b.15.1794522864032; Thu, 12 Nov 2026
 14:34:24 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112111637.184045-1-koray.fra@gmail.com> <20261112182737.1659245-1-icb@fastmail.org>
In-Reply-To: <20261112182737.1659245-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 13 Nov 2026 07:34:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8k8uTW_rLRADHz9mA5VFm2RZj1v6r=H+jEF95912XTfQ@mail.gmail.com>
X-Gm-Features: AclHuK-zDwCv6-7jAZ86Bdbg7IgiGEAgY_lu7kOXMxGX-tXuRmxUNiiyyi_ewJs
Message-ID: <CAKYAXd8k8uTW_rLRADHz9mA5VFm2RZj1v6r=H+jEF95912XTfQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: fix negative timestamps being saved to disk
To: Ian Bridges <icb@fastmail.org>
Cc: koray.fra@gmail.com, pc@manguebit.org, senozhatsky@chromium.org, 
	tom@talpey.com, chenxiaosong@chenxiaosong.com, hyc.lee@gmail.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 13, 2026 at 3:27=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> Hi,
>
> On Thu, Nov 12, 2026 at 12:16:36PM +0100, koraynilay wrote:
> > When setting a timestamp before epoch 0, ksmbd converts it from NT
> > format to Unix format without normalizing it, leading to the nanosecond=
s
> > field to be saved (on-disk too) as a negative number, which leads to a
> > garbled stat command output and a reported +4 seconds in the timestamp.
>
> I tested this with the ksmbd code from ksmbd-for-next. Before the
> patch, setting an access or write time before 1970 with a fraction of
> a second stored the wrong time on disk. The stored time was about four
> seconds late, stat showed garbage for the fraction, and a query over
> SMB returned the wrong time too. With the patch, the time on disk and
> the time returned over SMB match the time that was set. Times after
> 1970, and whole seconds before it, behave as before. smbtorture gives
> the same results as without the patch, and KASAN reports nothing.
>
> Reviewed-by: Ian Bridges <icb@fastmail.org>
> Tested-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
