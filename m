Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0317A3D8101
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 07:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780991757; cv=none; b=MZH7xvWy/R7ZeaO8ubocikce5n2BDovwCFwACXg+eQZQTmYFAL/cXgRc1m2X9+pj25Rel1P4wfSgTHU76oYtKsYGSvTUPuDILg784iD8heIEVs3WzuIRTfN6m6DkeDxp6G6h/RkjCqlfIHzC+20Q3FKK1iSVeWS6owtUuyZZNEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780991757; c=relaxed/simple;
	bh=mBeomtlXe+T9vcG4h4RGBUHm9A773sMwUUo5E8y1sZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DysAp4LwaSjjRagp5PXsdCIkC/Kk/o2B21h1Dcgbp6831MPuyJCsTZJzrQMlTOgwXeNuS3bAt8cd2b4wa/rJSVTHhP9u4psAcrJwUuf2+1a0P/YaOkiaMQkbGNZ59UxwNFP8q/JQhC55Rv4u2Il6l5z3ZD8cG1FPk2H4Xqmd/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikPG7Uf3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikPG7Uf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9130B1F0089A
	for <linux-cifs@vger.kernel.org>; Tue,  9 Jun 2026 07:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780991756;
	bh=nTGwU5uoYIqdeefcnRcaL1roy2nO5SYoCw+F0hLZiHc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ikPG7Uf3VnakUK0cA3Hs4/x58VaU6Zfuw/GJ4vJnKylcAmWr9lbFR9CE55q6USpxx
	 jdSo5uqEkWohnGi10bWpp7acx7pQ3KPJ2E8fWNPFK8zxOm4m/sMvqEg+SsC9FcfKHz
	 jx3JdccpjuIWl3116c/uXTqBrFG5GIwmpf88Np/+vjabEFQ7dUrQk9PEPsTKuMlQlJ
	 96XCf3B+aK5NQCEe2W99XF+nOVhfvp80Kv2lYC0v8QIfBOiUFAuVIlD5W2kQg1vmal
	 fEzx1bkV95r7XsXtIbuyT2SYDfPOeD17DOnw/bX+XRYcioxgtuxC5tb+S8dB2hcSUP
	 V/W9+Fl4FiRUQ==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bebb72b845aso792332266b.3
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jun 2026 00:55:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9BEwu04qFE40xVQWd2rR7/LykcgHgMvHoKyFIHzobVF3eK3SAlf2fJknG41DKSSZhKHl4xrmo3aIQ4@vger.kernel.org
X-Gm-Message-State: AOJu0YweA4E8Lmyoibmc6em45zUsTrAD8p9ewMwlJPzkUkCq8U3xkwZo
	eoB/yBMwysKkiJTfxJhVBPIongr3yEB+o3ORZWvwSzcp1iHyMcj1OYz1GC7ecBtLFoVjbu1L8ol
	BkLJdfmsM0LltmR7sYCLTizl015bmtPQ=
X-Received: by 2002:a17:907:a2c7:b0:bf0:3fd1:5dd8 with SMTP id
 a640c23a62f3a-bf37320cbddmr912178766b.43.1780991755033; Tue, 09 Jun 2026
 00:55:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260609061028.402886-1-chenxiaosong@chenxiaosong.com> <20260609061028.402886-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260609061028.402886-2-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 9 Jun 2026 16:55:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-FkCnekRNRCbMyqWN7_6=mKtcDrrp89yZ_M-HHDc=7Dw@mail.gmail.com>
X-Gm-Features: AVVi8Ce4j-GwlxOd3lxOZwWcdReIRdMRaDBh44zNwXz17TW2sMiujYZow-Mxbag
Message-ID: <CAKYAXd-FkCnekRNRCbMyqWN7_6=mKtcDrrp89yZ_M-HHDc=7Dw@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] smb/server: fix incorrect file size in get_file_compression_info()
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 9, 2026 at 3:11=E2=80=AFPM <chenxiaosong@chenxiaosong.com> wrot=
e:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Before this patch, we got the wrong file size:
>
>   - client: touch /mnt/file
>   - client: smbinfo setcompression default /mnt/file
>   - client: dd if=3D/dev/zero of=3D/mnt/file bs=3D1 count=3D1000
>   - client: smbinfo filecompressioninfo /mnt/file
>             Compressed File Size: 4096
>             Compression Format: 2 (LZNT1)
>
> After this patch, we get the correct file size:
>
>   - client: smbinfo filecompressioninfo /mnt/file
>             Compressed File Size: 1000
>             Compression Format: 2 (LZNT1)
>
> Note that the actual compressed file size must be got by other methods.
> For Btrfs, use the following command to get actual compressed file size:
>
>   - server: compsize /export/file
>             Processed 1 file, 0 regular extents (0 refs), 1 inline.
>             Type       Perc     Disk Usage   Uncompressed Referenced
>             TOTAL        4%       47B        1000B        1000B
>             zlib         4%       47B        1000B        1000B
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
