Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D7F21FF4D
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 02:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772159836; cv=none; b=HWgzICH5T+PiadcSh2OwaZrHJR7cbn8AfZu3LxgIFI1rT+32Dby2WR+Y4RV57VAiwp3b0TH2bu2ZwMAXTnJ7+nlAUFoS2Qt81e/lv5QGqN/SJ6cHbXYGl2nXyi8NOJirsqPf0lUhLyk7wMpMHqXxGMJum3hAfoiEOgr1epvImY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772159836; c=relaxed/simple;
	bh=kXHt003+06P5fUvManb5R2F9sUlcH+bxGwb/l/xZrCE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OoAANcxICN+HLHdt5KDAF/O0QMWS441kW7kzm/rQ4b4betX9Jef89F0lNQ6Du9zdFCxlCjeNeMcKf8UtRooIa7uLu2URg3Kjmwoo3fmqrrZqpCFhSytgQDRAD3chMontl9l6rnMeAkbZJFMYhEUf2MwOvCSzaHA/gdMvOT8kBqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=azhpNobO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="azhpNobO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12497C19423
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 02:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772159836;
	bh=kXHt003+06P5fUvManb5R2F9sUlcH+bxGwb/l/xZrCE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=azhpNobOg7CHgiusZoWH67Ds+KhJV92fnIBT01hVh9+Oyxgu+ZvJjCKX9ESoe3Yxa
	 7/H9V4MJoI65TFP9sMKzeP5KVJBK2XmPkToYqQrDe7++vGaHD2XcKtfy+CA4MqR99C
	 Ruotd/7e8E8ez/IfiPbfH7XQqL5fr5CzrcAPLLqrViaCnmZD1/8fXMUyClUrJI9FtT
	 wViqDNWiKjIINVfbVSJys6Cx+Ii0sZQknurwhTzJnlG3wfFvAvCQApoiwpdr2xURN2
	 qe1p0sxUk5CRAe0zkYGB6bDnzkmG7ntYXFZZraWxmNETDcuU11Ego6ISa+V3rxtORQ
	 yiomB8O1lciyg==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b936331787bso183881166b.3
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 18:37:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXqwBQdm7DRgARnTrnqWcv0vRuDqvRD2DchuGW9IK74svBYyZJuEmZrhPbidK75l/+3V2Ihk4yKo7o7@vger.kernel.org
X-Gm-Message-State: AOJu0YxjhT7Y0DTGlXMcP8Pa7b1UAklolmqar107V5voHZsLj5hZlccv
	33byEL7U9p4JZU7GlW/dJ7HT7BWeN5IopCQNtLF4yDjg0VSUdbDC7QXsxbRwrI68urQUBil5o97
	9HHUTaOEIluQ1AZ4RdFJ6uL3TwYWojxw=
X-Received: by 2002:a17:907:a0c:b0:b93:5564:1b69 with SMTP id
 a640c23a62f3a-b93764cdadamr68567066b.28.1772159834536; Thu, 26 Feb 2026
 18:37:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260225041100.707468-1-zhang.guodong@linux.dev> <20260225041100.707468-4-zhang.guodong@linux.dev>
In-Reply-To: <20260225041100.707468-4-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 27 Feb 2026 11:37:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9D5NEnJGTwk2_=zzCG7=+C=NyP6W+WTYkpfhPJq-Zf6Q@mail.gmail.com>
X-Gm-Features: AaiRm52V28OsJaG_GOnIly76BAPCulB-l47A6bGT9lexS-TPNynABo0hKoD9Oro
Message-ID: <CAKYAXd9D5NEnJGTwk2_=zzCG7=+C=NyP6W+WTYkpfhPJq-Zf6Q@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] smb: move filesystem_vol_info into common/fscc.h
To: zhang.guodong@linux.dev
Cc: smfrench@gmail.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 25, 2026 at 1:12=E2=80=AFPM <zhang.guodong@linux.dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> The structure definition on the server side is specified in MS-CIFS
> 2.2.8.2.3, but we should instead refer to MS-FSCC 2.5.9, just as the
> client side does.
>
> Modify the following places:
>
>   - smb3_fs_vol_info -> filesystem_vol_info
>   - SerialNumber -> VolumeSerialNumber
>   - VolumeLabelSize -> VolumeLabelLength
>   - struct smb_mnt_fs_info: __le32  vol_serial_number
>   - struct cifs_tcon: __le32  vol_serial_number
Why did you change vol_serial_number from u32 to __le32 ?
