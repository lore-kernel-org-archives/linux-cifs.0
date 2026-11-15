Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794745641;
	b=XagKRSCp15tAoq0XLbQymn0I3hUGvLvH+lLmBB88xX6Hl/C3lyAer37TwrMjCrP9MaqX
	 +S4bmmq2G6DiNNHmisksZVDrDP+XbybcZK5glSngJFfN1fKxqmpW8TIkFijo53SgkU4zr
	 WrNvCTcV95zjD67TRpG4J+uUDlhwwaUI2kYqiWb6IE59Jew1pIFvlLj5SM5KzLUM/TA9D
	 hkrNaBEaYpbPo7ob4Zou/KlEXDr+bo5Y1WCLaCpemkAPI9YsoKAaqVkw99RAFTBZUUcCH
	 YhhsWxOqXLi8a3M3TwIn69ZHbJGWASSYihG5B5XEetZiDYjUts5h9C22EQq5E0crDNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794745641;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NB1w2u3xkVvO+2PGAHEd0slXbgnQ5oCjDxu5kM2qVSI=;
	b=RprD2UwIV51bUj0LnzXYnVZ34XDJvFqEOqwDxhRpo2+qIBAcpH/vrDINXBdz36VeDVtX
	 6VPq0nmpBv8vIiOSKwRcLA/gtMcQOUGkIf4TeJUhMynponBcpkveoEvhizxz4Qapyik7p
	 13EWFa7Tgga0PvN8qdoPRDZqwOKL86Nwi8tgTCR+VO48H/3j6soXGHLGLrFKpxFJ1QdqL
	 gGW5Y/jF95/FwxnwYbeKQ3r4blikoCm1s7OmRA0e0Xo+FsxBLx+sbqN2GhuyOAzBB1itv
	 Wlns3nRBTyyP6UxQucO6dRldP+v245/QE5qjGAVz7OEOoThO51Gp5mz6mUgwkucM5EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HAVPNL5f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40613606A31D
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 12:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HAVPNL5f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE6C1F000CB
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 12:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794745640;
	bh=NB1w2u3xkVvO+2PGAHEd0slXbgnQ5oCjDxu5kM2qVSI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HAVPNL5foOLNcdJ+vKehkfHmP0fyD2Wg7r9vpcM38dNhK2Dpmo07pNhjCwm3bAV+Q
	 gVd3bPx1cSZr+7rIEC5hf84cDqNy6KLMSpbNhQg7XkB39+plcKdI7pafTLVxMnA/UP
	 75aczzQht9Ra7/s/ftjt/iXRE5K7w5pwmKwVFDOpT3x6/ja6WI9Z0r7Y1zG5vVXVhE
	 i+TvPKh8Y54vGkjrt87Sxxe54UGz0En3rkM7V4U+X6zKxQA6Z25yPRmOnRoubUocW5
	 yvvDZK9IulRnfZx3xdfFdmVqbNBgT3Qr7EUQK3U7tjNx4Ibk16FOiSc4HHZiY+tKYL
	 KoymE4smzg4MA==
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-67da62357acso693325d50.0
        for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 04:27:20 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErF70WJujTD+xN4aucuTlMdQ8a1T/ybwqZsBLVW/mA+xgaSZ+LdGJXhmya/hntWiIUZydGv8f/h1FGQT@vger.kernel.org
X-Gm-Message-State: APuU4Z8D1eWfmeSZTRlxnN4EVkqa+ITG9Lexx6mBJHt8GZkwmhUq2Fqh
	O1uNJonvdUou52sNfXlRTxl3ZyXn18+Dpq5W1yrago567kLEpG+GTg0sw6wWUJy6//pUpBC0jZ/
	m5LW0kzPGOgjt+mt0AB8xdYPeBKIoWTw=
X-Received: by 2002:a05:690e:190c:b0:67d:b0df:909b with SMTP id
 956f58d0204a3-67db0df9d31mr693683d50.21.1794745640119; Sun, 15 Nov 2026
 04:27:20 -0800 (PST)
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
 <CAKYAXd_qe-dLq6o7XdJzG8orYiKRioAtfEsLjxj33Ca3=PzGjw@mail.gmail.com>
 <DMVECM7B14I1.3GF2HZB9KRUX@gmail.com> <20261115030707.2275633-1-icb@fastmail.org>
In-Reply-To: <20261115030707.2275633-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 15 Nov 2026 21:27:00 +0900
X-Gmail-Original-Message-ID: <CAKYAXd93sDtx_nzvB3B3aqgScFjMN82u9vpePTCsuPk+uEPtWA@mail.gmail.com>
X-Gm-Features: AclHuK-O0RszS51_FPFPfSFdYdy5xBvfaWWwn-CxRpe0JOJmF1xY1ntdTYz5fr4
Message-ID: <CAKYAXd93sDtx_nzvB3B3aqgScFjMN82u9vpePTCsuPk+uEPtWA@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: decode and honor DOS attribute validity flags
To: Ian Bridges <icb@fastmail.org>
Cc: koray.fra@gmail.com, senozhatsky@chromium.org, tom@talpey.com, 
	chenxiaosong@chenxiaosong.com, hyc.lee@gmail.com, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 12:07=E2=80=AFPM Ian Bridges <icb@fastmail.org> wro=
te:
>
> On Sun Nov 15, 2026 at 2:34 AM CET, koraynilay wrote:
> > Hello, so I should include the legacy handling in this same patch and
> > separate the bugfix for sparse/compression in another one?
>
> One option might be to keep it all in this patch, with a few changes
> so that it stays compatible with the xattrs older ksmbd has already
> stored.
>
> When sparse or compression updates an existing xattr, it keeps the
> creation time, but ndr_decode_dos_attr() discards the flags. The
> writer then stores the time with only XATTR_DOSINFO_ATTRIB set.
> Checking CREATE_TIME on read would hide creation times that ksmbd
> reports today.
>
> Your changes to decode the flags and keep the existing fields are
> useful. On top of those, something like this might work.
>
> - Read the stored attributes unconditionally, including a value of 0.
>   Samba also reads the attributes without checking ATTRIB.
>
> - Use a non-zero stored creation time even when CREATE_TIME is clear,
>   and fall back to the filesystem timestamp when it is 0. A comment
>   could explain that older ksmbd writers lost the flag.
>
> - When rewriting an xattr, preserve the other fields and flags, set
>   ATTRIB, and restore CREATE_TIME if the time being written is non-zero.
>
> > The problem I had found when trying this approach (I originally wanted
> > to send PATCH 1/2 to fix sparse/compression and 2/2 for the decode/read
> > fixes) is that with only the sparse/compression patch applied, ksmbd
> > clobbers the time on reading by reporting 0, since it doesn't check
> > the flags and reads the timestamp anyway.
>
> With the reader change in the same patch, a creation time of 0 would
> select the filesystem timestamp. That handles attribute-only xattrs,
> but it would not make the writer change safe to apply on its own.
>
> > Please tell me if I wasn't clear, this patch/bug is quite confusing for
> > me since it touches a few bugs and they all depend on each other.
> > (And one fix introduces another bug fixed by the next fix).
>
> Keeping the current no-xattr initialization would avoid that ordering
> problem altogether. We could fix preservation of existing xattrs here
> and consider changing newly written xattrs separately.
>
> It might also be best to leave changes to ITIME validity policy out of
> this fix. I don't think ksmbd uses the itime for anything it reports, so
> those changes would not affect this bug.
>
> Namjae, would accepting a non-zero creation time despite a missing
> flag be a reasonable compatibility rule for existing ksmbd xattrs?
Yes, that is reasonable for compatibility.
Thanks.
