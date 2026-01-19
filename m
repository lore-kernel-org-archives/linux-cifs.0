Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3743126FD97
	for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 20:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768854649; cv=pass; b=eE9FtRrqbgm0qMALvsF3pj9XNzqRl+kpgJjpnD84x5XcgbvdjREuEYyr5sLmUvfXeXSQ2r/sd4A1EdyoH99qnTQiwAbXdIAAUsWelSFpMeoNxEuBqXCQ00agpzq6fot3Fm0JnOjjFbsRrnJB4Y5A0BIcANEyJvD8qTx+sHg9e9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768854649; c=relaxed/simple;
	bh=lTXq/K01kBNT1D8jxUcG65wa7DJ0s8gSci13bXaOW2s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=deiKDZOk8FazMTBVqmRqd65Wi1l278DX0gVXjEDIlFXKrrJBRsnc/a4pVebaNyCFTcPaOhcOXhVKIU96kv2ozh3KRNUJJE8wKL47NvEWCH82vQb8qn3NoDwsaSO9/J+bkUJmKEoB1Z9BgXgWlocFq5C2qSXbbzdYcZU9oJXKgDQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DffmkoP/; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DffmkoP/"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5029901389dso29630641cf.2
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 12:30:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768854647; cv=none;
        d=google.com; s=arc-20240605;
        b=afqfUEHAX+VQrR5W4JNf2hwW7Sc5fFCAwBi3qiuLFw6v7UMlSgcPHHfPTZtmBUe/02
         fKYqtzfaqp4jBF6Zr2gu/5N/dEO3ho5FOxahQnLw2EDCV4Xq49yBBvOC5YKQsDbrGzTr
         hBi6aNEHHRfWbo302WNrZbB42X/5SOzdY5OAzSK8fI6thG4QNfqb5+gz1tAQ/Urg+g+r
         ePLDenPvpan8sybYqcTh05ZgeldxND40zO5e6fY6Yd+L6zFsfqPBfFFkHxln7EAz/1LR
         4ml2mWVkH/lgFk9R7YytuFCOQkfw6MhE/3okbSMeus8PckV4iliBhDBdrLVDfvJ4XAN/
         ioJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jop3jeIDSiLso+KJagNCEQNrzj3qWlQzAYQCYBp3+vY=;
        fh=SiZGJhGcjAPvEu+mDCy4aDjpHtiXI2ezpiPVsaZ1AWU=;
        b=ccqBz5tY+wHLL1xb7i9bp8hs+9IcDI6AZr4OtSpRtTbC8iSDlyO0tPKEuKZ4akARxl
         6XilzTh2STDXAXfwBO7+vL0+zdsXwnJy7tZe2lAYgY0+m9wktcaVPV3FKzK1jI9t3tbw
         tqljbzBh8tR6XqtsKcxNqZ9NvY+IcJD832/uMTeAPJSKlTWsg7mfVSQoIIONykSmZNqp
         bsia7B4p5nZmfvIYBwBl4bBCIMoudv5QEVSzznEYDju/r4eBGuwnX2bePcPHWGDhiStN
         k2No1Gz2tVu9ZAGa4vxHKgUNKRstKkG0VIJn4nu317Ng35WOfG+FDfqwn4t8M2IoE26p
         olww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768854647; x=1769459447; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jop3jeIDSiLso+KJagNCEQNrzj3qWlQzAYQCYBp3+vY=;
        b=DffmkoP/+jb96qVPI8qMCc5h7HkKnuiYY5Ruz+xe6YD4w3LwidrAOUmJMkNjQ3o+Aa
         7pVLbm9kufJTpSZ0BdeRmlNJE+YrLiWP/n46tVg5bbwoyAG62spRzxRYa+iZOFS5rsm4
         A092AEQBiPPmlvkaAPp+alDI1mkYQhrENLNsy8MDot3oCZh4/lxculif52x17IADD0Ih
         2ILVWFpIYX+pucrWC1LTUZg2eqUGHN8rIydzvLbD/ltxW81aBeZ0oip2QzkthtIHEOSh
         uqk2o4sAHqTarDFhWUgwilmz5dJ1yZSt3j3BKc/n1C8Z/105kIbppj/0n/oTI0IFxyEt
         4zgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768854647; x=1769459447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jop3jeIDSiLso+KJagNCEQNrzj3qWlQzAYQCYBp3+vY=;
        b=KgG2wYVCqcre3H9jLtm9hOBqx3ZRiEooyNAsI9VGGTgs0lel3yDRXzh/Edh3sYb+Y6
         Rl5AxWG/4n2mg2wZpAAp5PzbEuHejNiZmPmgUE6O8flV5eEtsbCiHjECNJ2fqcIS85hB
         9KCB1Q2pTzj3R8yLPfunwWQN58AIkyf28ogGiXCUvJlM+CqvO37EjziRuJEQv1OVet1d
         3tP+vsrh8NVM6etyMP0m5GDK8JE8hNQP6I5ps4DEQpGeA0PSE8qFzV8gLnmHOSOD3qAy
         y4X14RBtKc9CquuccBVBAfUBfqOb/8auWP5tLgOI0Km5h7Ej8SyEq3M1npBhVLU6G6a4
         +8Aw==
X-Forwarded-Encrypted: i=1; AJvYcCXIMK2nM7B5wli9UwQWkGzEPHBBiXqTICmZobB4CW6gFRugqp91pFRN06X4+dIWoMABmVtnR9PFOcdM@vger.kernel.org
X-Gm-Message-State: AOJu0YyuN8nalO+uWL1nPlvNfTw0LeqQYdTW5LSdJcezgBAK6paAbddq
	oizcItAkf1Z/jyfGyIvTK0rzJE50FlVB1ghiNSNlcLmztV8uMPybikSZ0aGAxahcLi8AOGyQVWr
	Umy+D+x7Em/TH9z7eMexBUiLlbYKJPBw=
X-Gm-Gg: AY/fxX7iuLstMjVSeI2BWoddUp69GSs4nAZoN4eEpl6X2D8QRRw8oxpON9xDRrLr9HG
	ZWv2GGQpBQD4iMxQ23z0ECL12+khDm+MOTOCqTL5bSz2yKe/F+KLzZ6yQ95QkrNNoCRC6ntQ2ao
	1WZSgvSe1592e2/34+wlaoz4SuoGRz1ZchE4xLuQ/JEA/HBaXtf13sQd+Bt2sddIZ8BMKFmgiPg
	VpzdTTqo06A1YBD7vgSiCkKkApkuWjmteYKXA2CAcPszeViGncdPYrL0Qwx/RvJYzoA5aruXdCk
	i3vvLva5K7FuHePfOw8OX5Pa9J70v9Yyc0cvjvB95Bx9RegwIEK08lhMVtQvKghV42Iq1RKhoFU
	vYmAULBynyCEI+Vl6X77UxOYp2rCSxW6HMd5qe4Z1AIaHatOz5gKgW2eBAvYll3C2Jlye7xNuFY
	0/dnNFTUHGgQ==
X-Received: by 2002:a05:622a:1108:b0:4f1:ba4d:deb1 with SMTP id
 d75a77b69052e-502a16c24ecmr202653881cf.46.1768854644114; Mon, 19 Jan 2026
 12:30:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116032204.181201-1-henrique.carvalho@suse.com>
In-Reply-To: <20260116032204.181201-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 19 Jan 2026 14:30:31 -0600
X-Gm-Features: AZwV_Qg9FBoEnyKxRo8HqE7KxURDJeI_WrE9Xju_F7qWliaoqocBbDiOqwJuAM4
Message-ID: <CAH2r5mvO5n4t63PiSWmyQrKhLCJijqWVUqWyXCUBcrx925u80Q@mail.gmail.com>
Subject: Re: [PATCH] smb: client: split cached_fid bitfields to avoid
 shared-byte RMW races
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending additional
reviews and testing

On Thu, Jan 15, 2026 at 9:22=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> is_open, has_lease and on_list are stored in the same bitfield byte in
> struct cached_fid but are updated in different code paths that may run
> concurrently. Bitfield assignments generate byte read=E2=80=93modify=E2=
=80=93write
> operations (e.g. `orb $mask, addr` on x86_64), so updating one flag can
> restore stale values of the others.
>
> A possible interleaving is:
>     CPU1: load old byte (has_lease=3D1, on_list=3D1)
>     CPU2: clear both flags (store 0)
>     CPU1: RMW store (old | IS_OPEN) -> reintroduces cleared bits
>
> To avoid this class of races, convert these flags to separate bool
> fields.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cached_dir.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.h b/fs/smb/client/cached_dir.h
> index 1e383db7c337..5091bf45345e 100644
> --- a/fs/smb/client/cached_dir.h
> +++ b/fs/smb/client/cached_dir.h
> @@ -36,10 +36,10 @@ struct cached_fid {
>         struct list_head entry;
>         struct cached_fids *cfids;
>         const char *path;
> -       bool has_lease:1;
> -       bool is_open:1;
> -       bool on_list:1;
> -       bool file_all_info_is_valid:1;
> +       bool has_lease;
> +       bool is_open;
> +       bool on_list;
> +       bool file_all_info_is_valid;
>         unsigned long time; /* jiffies of when lease was taken */
>         unsigned long last_access_time; /* jiffies of when last accessed =
*/
>         struct kref refcount;
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
