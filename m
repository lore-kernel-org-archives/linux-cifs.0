Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794702145;
	b=sjGs8Zo0o/30GLnkQscnruCxaYhRrEFlIYdNvI6kOz9Mw/cN02AF1TqFLmX6/SF38UTF
	 b+FeLppjcYrqkRGEWDQAfkOkto8p1LA+Jh69dQOl9paGbLufokB4L7wQEOL1oWSkuCCc8
	 wn1FS7bt+XmQ9jVKQYlmUGFEQdJpTzTXuSpwp4fmOb4ITEYaYEn5sgrxOrAzs8XELySXf
	 JVhkHUaUetPlSHexE9By+4ye7jFe93VlpPTpipoDN2NNoyEBdKPQj4/Ir3vUE5w3hZ4gJ
	 SF7TEAHORVIbCCsNn/MnZzPKgfm+8uwaU57YqwKsBzw5PbZgSxYVXwvFnA4enU1zeqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794702145;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=wCcIvzsuQGx469LziUohYtgxI/06BzX+ClZShOsYgGA=;
	b=HMd5ZJmkOGfYTyFAahr0diVuEU9KYzvJQc0GtbwyWHIROmkCy+D7jajfeyJvvGqcxnCS
	 B4hnJDazejm8kE+u3gU1Lz+iU0hJo7jDEsZ6qlyz/emQleYsrVLnf71WrgLZ3mXQ0Fmvq
	 MqHcwTBqTz/SRsOj3I6h6c/rGO23kPOffgM4UTcSGY4RcrXQ/RjNUkd/ejxdARoVfT4C0
	 hZIcUJxinNUZ86zb7bmD3qQ+T7yZ3xLrek4I8Q5yihFOTL6TkCRF+ExinY+J8o1iP3RYL
	 4QA2CEvVI+7yww+zuZ66xx3BD6+EO+LwtOrOX57x02qMf6o396WNG++dpq5TAy7+qwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPvFgnyZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546E7606A323
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 00:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPvFgnyZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AAE1F000C5
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 00:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794702145;
	bh=wCcIvzsuQGx469LziUohYtgxI/06BzX+ClZShOsYgGA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CPvFgnyZ5W27IwipTs1lpzasnMKBpDj2OYZEWrdZsQcmuR5GUK7QPFrcxO2YRCGcR
	 1OL/M2Vmj4vbmrVHaFCSlKAg45vBp7QIXxSj1jEzylpalMxFmgdaxUzgAjvt/eVTrb
	 uBWxd8s56c38p2ftsiP3bbM3II0ZVwT3TtJ9ZmZ0SAcVvgrZiUupBcOmBX+05II1Ai
	 sSTzmYWguMahfyw/V6AKrMhxlA6vRVW7hTOnYegLNAzdGzsGZgUP9ulwsGD4wwtqI4
	 ComjppMaYRmfxL6eRouSiVjd4+bzB6iB/+GmTuXlbMGpvnWgf7PCtoNIULFLaZPVPx
	 YWstHq4spjTDw==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d28f75d62so473951066b.0
        for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 16:22:25 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGutiBq2Obektsa5S2u8/6F3/ynDvUlXTrViRUapyXBMcmRTlmsXf7jZgW5skaxMT1Zj2S64p42aj6S@vger.kernel.org
X-Gm-Message-State: APuU4Z8XQvUoFDvjj1qckUiAZXswFBKWOCU/YrlqpEYsicOO/AnbODOI
	wYDc31vUS0B/9Q5pQlXuDEqAKtVgW1MxVotPtFTyFKNgepUi2Xhu3us/onmrKiVAprJke2qVhht
	etnaLTnw5M2Mm7CIH1lzlUcFkQVDVtBw=
X-Received: by 2002:a17:907:3d92:b0:c27:420b:7c79 with SMTP id
 a640c23a62f3a-c50964057a4mr574674866b.48.1794702143794; Sat, 14 Nov 2026
 16:22:23 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261114012736.639171-1-koray.fra@gmail.com> <20261114160332.2228435-1-icb@fastmail.org>
In-Reply-To: <20261114160332.2228435-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 15 Nov 2026 09:22:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_qe-dLq6o7XdJzG8orYiKRioAtfEsLjxj33Ca3=PzGjw@mail.gmail.com>
X-Gm-Features: AclHuK8sng4ajcW81oalTmmeANU3J1j-6EE0UYzK1YRlD-i3CkmDWMr44z7UGTs
Message-ID: <CAKYAXd_qe-dLq6o7XdJzG8orYiKRioAtfEsLjxj33Ca3=PzGjw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: decode and honor DOS attribute validity flags
To: Ian Bridges <icb@fastmail.org>
Cc: koray.fra@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 1:03=E2=80=AFAM Ian Bridges <icb@fastmail.org> wrot=
e:
>
> Hi,
>
> There is an existing bug that matters when enabling these checks.
>
> ksmbd stores DOS attributes and the client's creation time in
> user.DOSATTRIB. The xattr also contains flags saying which fields
> are valid. Currently, ndr_decode_dos_attr() reads the values but
> discards those flags.
>
> When the sparse or compression code updates an existing xattr,
> it writes the creation time back but sets only
> XATTR_DOSINFO_ATTRIB. The time is still on disk, but its validity
> flag is missing. This has not affected the reported creation time
> because ksmbd currently reads it without checking the flag.
>
> Your patch preserves the flags on future updates. However, the new
> read-side checks also apply to xattrs that ksmbd has already written.
> Those files will stop reporting their stored creation time.
>
> For example, with DOS attribute storage enabled:
>
> 1. On the unpatched server, create a file over SMB and set its
>    creation time to a date different from its filesystem birth time.
> 2. Make the file sparse. Its xattr retains the requested time, but
>    now has only XATTR_DOSINFO_ATTRIB set.
> 3. Upgrade to the patched server and reopen the file.
>
> The server now reports the filesystem birth time instead of the
> client's time. Directory listings change too. On a filesystem without
> birth time support, the fallback is ctime.
>
> The affected writers are fsctl_set_sparse() and
> __ksmbd_vfs_set_compression(). Their existing-xattr path differs from
> the no-xattr case in the commit message: it writes flags 0x01, not
> 0x51.
>
> I am not sure whether handling these old xattrs belongs in this patch
> or in a separate one. Namjae, what do you think?
Agreed. separate patch in the same series is fine, but the
compatibility handling should land together with the read-side checks
to avoid changing the creation time reported for existing files.

Thanks!
>
> Thanks,
> Ian
