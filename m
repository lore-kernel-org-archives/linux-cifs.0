Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEC44071DB
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780753618; cv=none; b=A3gft/G+ZX65yte/XLnJgb1ZHWKj4cF2NDHDL1p9aD0STNCN4Lutb3LN5ZpUWMZh6+7lFEbAV5b4NPUUtnBMpcD0z/ycsA/ILBai0HTPkS/Zt/o1FESB7DSoaz5gV0tU4M0HoygXE5bJEf+tJIkgZNVJJXOwY3y3la3JQIAYRHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780753618; c=relaxed/simple;
	bh=mVurO743uweD6+cKGdZlhmeFCUbX2/3u3OQfhWTUTPs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aILVUVRzk1zYSyfhl2DtNsGl8z9zCRl9uj/8a6XSOdrmtbrK7718hPwMdt/uXILFHwh4WdWOl3zMf7POZ1owoveKayGFAyLhylnWeqNsnefI/wcT9Ssh7KMr3VOZxo5cZJBxzgQ5O7dy5JSxYlPMgiAPdxdBz1RQN87FqzLUJn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MpbbGWgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MpbbGWgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2A71F00898
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780753617;
	bh=/MvjYBonQRwJip8atH44BB1w4ude4uS5Q77SAF0fkMQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MpbbGWgBW3ySv6HImt+Z+e2SLdZqjqpTMm6qRTRtGemxhTlfBU75pRFmwbkdioVM8
	 kVz9khfTAzBdK4I6SZLXHnUh+UPFqrlPI9sDRI2W1rK72uc//BdqMZkXbCqT3dR7Ov
	 fJz33hQrk8ozpzX1Gft4KKqypoXzhu2f/G75HtxEEzn0PNeyzbiAoqj1VhVlYRbz7D
	 kvaARfUonQkt31hhFW4Xngd0g+hNZeYJu5GRdBKrz8YOc1Y5XV53AMfW5m3abvs+Q9
	 al41Pj59QcV3g3PvzlilV2U4fDgvgebUAMO4VnyRolDu3806bRXt34lSaGBIZZ2naW
	 gnG0vQzZSKJwQ==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-bec43ee8ff0so401883766b.1
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 06:46:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8nCowUb0VMdbsuBgaNxrWXMP6URHqdPSwM9E45wRZ9WPQt6GoREjS9IEPnI95662YQ2x0IgvuDoFfW@vger.kernel.org
X-Gm-Message-State: AOJu0YyKouUv2rPfrbmhonaPLnbos1wxExpvCR2uh39n0cACf394lNp3
	AyqsGQB8+qa89oP3PJmwmZow9PliJHUNQgayeFgK5eY+I2QpmAXdS9dzP8h+W+UueUl/jfnpNIS
	Xt/ucdf57BKexuCjqvcowUJEg9YoZG7A=
X-Received: by 2002:a17:907:c389:b0:bd5:7c2:7617 with SMTP id
 a640c23a62f3a-bf3a97fbd38mr361582266b.24.1780753615497; Sat, 06 Jun 2026
 06:46:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com> <20260606092601.299698-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260606092601.299698-2-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 6 Jun 2026 22:46:42 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
X-Gm-Features: AVVi8CeVOO--FQpbtlMFVxKcAWK-OX8h5S8o3jKkBc0R4rViNBro5Ga74ypEpdw
Message-ID: <CAKYAXd-inU4rYZ=P0SmLUwDdL-x=QtJuBPdSg2DRKZMF-KuLDg@mail.gmail.com>
Subject: Re: [PATCH 1/5] smb: move compression definitions into common/fscc.h
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

Hi ChenXiaoSong,
>
> -/* compression state flags */
> -#define COMPRESSION_FORMAT_NONE                0x0000
> -#define COMPRESSION_FORMAT_DEFAULT     0x0001
Where is COMPRESSION_FORMAT_DEFAULT defined in the specifications? I
looked through MS-FSCC but couldn't find it...
> -#define COMPRESSION_FORMAT_LZNT1       0x0002
