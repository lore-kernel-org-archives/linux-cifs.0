Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A00382373
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 23:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776815646; cv=none; b=kebw4gZvj0pDEPZiohnqnBvl4h/t2Y5dViGFtiugPdgINc1pfhdIvclAD2tpJff+i0HlomLxcY2L8m2uJAzjInkDm4EnVVKUU63G6mbZzwHDG/itTC7RGDfl3poMK2Q72f1uCVXAnvv923Op7zEZgoOfNfgFD7PaEFetW/h7vLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776815646; c=relaxed/simple;
	bh=1uoghLxmSn2t4MyPC7kZQRwuBzCyMTv08I6LlbPM1Nw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c7TUMJVenhWHEb75z8W+k0b4SNPrIeUp4gvQefT6Twm9eJiB+ucuv5KI4srTJOXAchDRaHi0bbTqqGCdspohOtowiZQTSmE1uI2RvHBgWK3TxP4U71PPZsMF91S3BoNdLzeH2gEFNdCksOHV59wIOJRK5knB5VKdymsVPjs1jw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eS+1nMmF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eS+1nMmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E691C2BCB6
	for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 23:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776815645;
	bh=1uoghLxmSn2t4MyPC7kZQRwuBzCyMTv08I6LlbPM1Nw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eS+1nMmF2hK57nPiXwnyWkVpvbNSgB0L1hZ167bcL0nlXWN6fFrPOBOeFmz5CIrwf
	 ZkxlMBFb5T4w3HSB6nwUF/+wi5litSTX0FWpHVsCLe4a2SbVZd/9xPcP6JexAQlUqr
	 PZeHBSFFK6z7I24RGSeQVF9Yj4fMph83Mve64kRvnRPb6WKa4GLvd4K/BZN5H/BmoT
	 sSZHhYIOG8+ufbQRl58zhJBxgFeSP2wtdGupxPMUq14N3a1KHTTHFibw39SCPMcsey
	 fUBG0VaQTyAZ0avNHStN8EEeBHJT4YGX1OupbeOQsdhWn2RwtoLOL3kMnwd/uR/O/M
	 V8szRebM/Ji4w==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6729c6f0ca7so5740924a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 21 Apr 2026 16:54:05 -0700 (PDT)
X-Gm-Message-State: AOJu0YxkIPxmpXhq261hgBsBllng20tUfyqb9U+VpGOPv/cUvFsNOc4C
	x8ElWftOvVmFSyXF6hHr6cVqXFtxZiYJzzs5zJoeuM4FHz6dzUUtVLZv5T7bFumK35X6ve1ls89
	+BcmoFqAd6sZCPC7PnPc6gEJpsSj8icw=
X-Received: by 2002:a05:6402:1ec9:b0:676:9c6b:6ee5 with SMTP id
 4fb4d7f45d1cf-6769c6b721dmr2625846a12.7.1776815644177; Tue, 21 Apr 2026
 16:54:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260421190619.1396589-1-mmakassikis@freebox.fr>
In-Reply-To: <20260421190619.1396589-1-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 22 Apr 2026 08:53:52 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_BD2xzMWSTWJfWECAteng6GTDtYL3V8sfTv0C5Fsyyxw@mail.gmail.com>
X-Gm-Features: AQROBzDsy45B5aHTxyEs1SBNDuYWey31yAWfAGtm8UX601FbD-IjZ_uufJkJ-Jg
Message-ID: <CAKYAXd_BD2xzMWSTWJfWECAteng6GTDtYL3V8sfTv0C5Fsyyxw@mail.gmail.com>
Subject: Re: [PATCH] fs: smb: server: stop sending fake security descriptors
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 4:06=E2=80=AFAM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> in smb2_get_info_sec, a dummy security descriptor (SD) is returned if
> the requested information is not supported.
>
> the code is currently wrong, as DACL_PROTECTED is set in the type field,
> but there is no DACL is present.
>
> instead of faking a security, report a STATUS_NOT_SUPPORTED error.
>
> this seems to fix a "Error 0x80090006: Invalid Signature" on file
> transfers with Windows 11 clients (25H2, build 26200.8246).
>
> capturing traffic shows that the client is sending a GET_INFO/SEC_INFO
> request, with the additional_info field set to 0x20
> (ATTRIBUTE_SECURITY_INFORMATION). Returning an empty SD
> (with only SELF_RELATIVE set) does not fix the error.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
Applied it to #ksmbd-for-next-next.
Thanks!
