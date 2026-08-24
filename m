Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8FE395DBF
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787574368; cv=none; b=WspRv8sp4QWl+axhharSrgkWnSZJSKLtUE2ODekwkRSu0UYMJfRBmZPN6gDyw1ElGE12aZyffn7oqpdIFNgaysCafGzAc7QBmv8mLRvIW519k4UzT8b0X46+J/wmfmRNoFsbf6oJSdIk9XezifdL/PsYW7vzRyb+P2TQ0/oJN1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787574368; c=relaxed/simple;
	bh=j9aZZpCdgptJbt//i5RnBzvhBcYdoEc2Ws5J84COO0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W2MMq+telWTJf079oJGhK3aujuPvQl31pZuG7DG+qt5tzI9tYdjazcuLnSghwevE7V8azhlwDO1O4Ky1FvBzzADDb6HE88BEWaJM7/W+NSoIY1+1L+AU4+Vt5au2zdcAEPg5SxZJVBlsXOrdbCxh68UKczZpyZIUH5vC2cJWGq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=THVFcswt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="THVFcswt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C784A1F00A3D
	for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 12:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787574366;
	bh=mLvmuNmvwBKnMnppd+F9eiEG1bT77LTPk/OhrmvLLsQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=THVFcswtUUwZ1ttEeCATXSdZZXCjRBSRpVpyfDIGpedBhYc2YlkzDwAJF6jdg2Pp5
	 bUvFPLsTuQvi8wx9H16ldc7U/NYlu6n4KzTUOpi4zc7AsSSaWw1xCf7ORpKsQChqtJ
	 5q2/P/dn50ju0ILg+5SxLIOoM0A6kfblJxN7TJY9hQwRgmngghaVaAhrFHyyB0n1N0
	 Yt0/+vWUoj9G8vTAb3MXkMpJm4vGWJ+FojpIwdmWWlY2wvd7aHprvJ4jZv1Nr7k1DS
	 J6hZha7nOuMPll+QcSQLLZoQosvK6LcF5QEtk1+oavumBL5W/ElbSdvgR6rnpjxmY5
	 fNP6tgXy2jeeA==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15b1da6b82so358671366b.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Aug 2026 05:26:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpQizCuOcDD5g0LHpE9U32HXiEPQhKysc29KrRVwqkvfrq/dXCIkexh8hbYbRuATiWljU/gm2KPAAxd@vger.kernel.org
X-Gm-Message-State: AFuF++mBLMlWjcSZ8ly9KqZiRydgsOhvTOtb0H1izlle7zcjVbQZ/GL4
	sTjqRu1Wq4zdyKQIbWItbXQJQw6X6FgkX7ne8f8jE7Jjbc1s4EsS0BBuoaLS3+F0uFhlNewBXro
	i2Pr5hJatNOPyCyUEu2nuLC/fDUSFzaQ=
X-Received: by 2002:a17:907:c706:b0:c20:f913:9337 with SMTP id
 a640c23a62f3a-c246a657f9fmr3151002366b.20.1787574365467; Mon, 24 Aug 2026
 05:26:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260821135801.3790290-1-haa@amicon.ru> <20260824102248.178152-1-haa@amicon.ru>
 <20260824102248.178152-3-haa@amicon.ru>
In-Reply-To: <20260824102248.178152-3-haa@amicon.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 24 Aug 2026 21:25:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-ya+P8ed6LZ2mjZBYg39TFf5mAA0r5APbr=qgdTdLsfQ@mail.gmail.com>
X-Gm-Features: AcwNN1XLEiXmDkflQ6EnwWd-BrdE4FKdO9birCHT2WKEUPTiGc-BXV4tHwoTFm8
Message-ID: <CAKYAXd-ya+P8ed6LZ2mjZBYg39TFf5mAA0r5APbr=qgdTdLsfQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ksmbd: initialize FileSystemControlFlags in FS_CONTROL_INFORMATION
To: Aleksandr Khromov <haa@amicon.ru>
Cc: sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, rrv@amicon.ru
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 24, 2026 at 7:23=E2=80=AFPM Aleksandr Khromov <haa@amicon.ru> w=
rote:
>
> smb2_get_info_filesystem() reports 48 bytes for FS_CONTROL_INFORMATION,
> that is the whole of struct smb2_fs_control_info, but never assigns
> FileSystemControlFlags.  Those four bytes go to the client as they are
> found in the response buffer.
>
> The buffer is zeroed on allocation, so a standalone request leaks
> nothing.  A compound request can leak: the offset of the next response
> is advanced by the length pinned for the previous one, so a reply that
> was written into the buffer and then dropped in favour of the short
> error response of smb2_set_err_rsp() stays there, and the next reply is
> laid over it with only the header cleared.
>
> ksmbd does not implement quota tracking, so report no control flags.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Aleksandr Khromov <haa@amicon.ru>
Applied it to #ksmbd-for-next.
Thanks!
