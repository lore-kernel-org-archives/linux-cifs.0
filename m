Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B702B1E2839;
	Thu, 10 Oct 2024 22:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728598934; cv=none; b=k3LLiIKwEVsGETShnnzyRAFtLgMSkPjMDka5XhyyLYaSO2Q/cPNe8uPjrYFptuw2JKgld4SHIUMxwJzu2XIvH84wtUqtsI0SsPeGujR1tzdI7HSR5vZ8t6iMZ5VB4+ebk8UURd23oYnMukUjGIHe3d/VY/VFGXcBEjg3o+Onryk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728598934; c=relaxed/simple;
	bh=4aSNyHFj2a3sv9HTlB5j0icOpCkpze2gdgEUsrKowIc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TwVrTjdzLoY/wcdZo1LJoierG8LqVMYORzcy74/HqA0nrK8m274gaySKXCUSs/z8B179z3oMix8iL9muklVWCtGe8GXldkwigj2r/4FRUX/GBQsPZov2Ty6l/mkVmFfmYI0wnC63F9v6QRuobCvoa1lOYiB1xaS/MzREMXnVp1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZILr9lCX; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZILr9lCX"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5398e4ae9efso1930655e87.1;
        Thu, 10 Oct 2024 15:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728598931; x=1729203731; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6GcS15oGBg5Qp9pUdUup2rJKA6lsBI4Jc2zF6G9+B4U=;
        b=ZILr9lCXuiExekZuOviK45xqwyR5j8p9qaDv6343kKnZVdRIkdPoMhqukhM0rvJ+RI
         qFzb4CFfRJJUKUZXQINzc5t1Yk4IIfCLxdHPnvlIJg0552i2IZXluPL6vhyX0cSYN5yk
         lOAKNc3RFTDVfato5cHOe5CSj4LGP8Ttndd5qwRleYVzBQ9xLLWA4+pTnqMVFMavFV1A
         q6DsVpbI0Z14+BSPsUiKViXYHxXbFu1x/GuyoaWPdPe488ehOTxNECLyoWme5EyeMzSW
         YX7NKL2MMz2eglY77i4kRWQ85vcrZNrpW4zlL4Dyp6Ns68zwaEBiivOEvFODyNWGGP8W
         5Ygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728598931; x=1729203731;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6GcS15oGBg5Qp9pUdUup2rJKA6lsBI4Jc2zF6G9+B4U=;
        b=AjhOIsbwsHYyCR0qV0AlfVlE4SD0eaYi+Nisd9RnxjMkbpEaDwPQsFPm44B+45BFZs
         vBwV9bP0t1uewVGZUVl7jrDBC8BXRz3V+Bi2Q6HXuCN5zr5G1jvK3omj9Kxd3xPwmbXe
         uvFNLQT/6a8j2p8bRt1B6Aop2Uusoz6hjxjvajuUch9k5+/uP1ZhS0BZX63wNrG+Wtxd
         BAQ7/wnRb2Ko+uZrLxts+58egHBj8QvCugtEiNdQ3rzsfHnbSNufDJkVSuv7osSBUYcm
         ymTdbUQQsY794/FvxIvLFKvsgq73Wbpg4dXaJQhyxWsbuG150ddDMCKJzN8r1wxcwRp8
         0YGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlILDpWxtDXTNTunNFXm/+rIljdn2QqzMRRclQAwBgdDHn9QKQGAMYObAQncpgHRBvzW27YoQ/cllh@vger.kernel.org, AJvYcCVQAzYYwoDfEVkrZ7xwqPCHe8ymbei0p2jnhbQLG+x0xvkfqhcbjyseTd8rB4d9o8asKopa7i2aZFMSaDqx@vger.kernel.org
X-Gm-Message-State: AOJu0YxnyzQSfSezVc+dsDTMUiElIcuyReYNzi2dGsQEzZo1wmgKMI6g
	D7ktrKMZfgqAjIbn2F6xF3RnSXxAxjimnjLAAn7U1emCxFcJnoZXBAkzZxVOE4gxL2Z2vqgn5EV
	SFzuHhXBwmsQrypNF3+NuZidKlh4=
X-Google-Smtp-Source: AGHT+IE4fUe3SiO9Y0v1hJGDJi7hWD4hFZrFysXnzTwZskfQTvym0jrGbAzNdGISFAQGxTv7qeDgYao8QxFqTZg2FDI=
X-Received: by 2002:a05:6512:2345:b0:52d:b226:9428 with SMTP id
 2adb3069b0e04-539da3b6d1dmr183343e87.6.1728598930663; Thu, 10 Oct 2024
 15:22:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006100046.30772-1-pali@kernel.org> <20241006100046.30772-2-pali@kernel.org>
 <CAH2r5muLa_0L5LL4ipQkzEHOUdtYtJVAD29AAjQOaun9dWmK0g@mail.gmail.com>
 <20241007183650.aw3skuztljpgk2bs@pali> <CAH2r5mttO-aDq94QrLQm10xJRGLg=PULqX9fcfoykAweVVO+uQ@mail.gmail.com>
In-Reply-To: <CAH2r5mttO-aDq94QrLQm10xJRGLg=PULqX9fcfoykAweVVO+uQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 10 Oct 2024 17:21:59 -0500
Message-ID: <CAH2r5mvV7WzB62hWt4K6oF_xyrQH1EF75zc0JdfjsjFEV4SQKQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] cifs: Add mount option -o reparse=native
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2024 at 5:17=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
>
>
> On Mon, Oct 7, 2024 at 1:36=E2=80=AFPM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>>
>> Currently choosing how new symlinks are created is quite complicated.
>>
>> Without these patch series, by default new symlinks are created via
>> native reparse points, even when reparse=3Dnfs or reparse=3Dwsl is
>> specified. There is no possibility to create a NFS-style or WSL-style
>> symlink yet, and this patch series address this missing functionality.
>> When option -o sfu is specified then all new symlinks are created in
>> SFU-style, independently of -o reparse option. And when -o mfsymlinks is
>> specified then all new symlinks are created in mf style, independently
>> of -o reparse and -o sfu options.
>>
>> This patch series does not change -o sfu and -o mfsymlinks overrides, it
>> just changes the way how -o reparse is handled.
>>

I lean toward something similar, and more intuitive - do not have
"reparse=3D" control symlink creation - but instead use another mount
parm (e.g. "symlink=3D") for that.  It would be rarely used - only if
you don't want the default (windows default format too) for server
symlinks or "mfsymlinks" (for client only symlinks):

1) "symlink=3D" if specified can be set to one of five formats (with the
default being the windows format)
  a) "mfsymlinks" (Mac style which is safer for many use cases since
they are "client only" symlinks which the server will never use)
     Setting "symlink=3Dmfsymlinks" will have the same effect as just
specifying "mfsymlinks" so won't break anything
  b) "default" (or "windows") which uses the default symlink format
when trying to create a new symlink
  c) "nfs"
  d) "wsl"
  e) "sfu"
2) "reparse=3D" will still control how special files are created (char,
block, fifo, socket) and can be set to:
   a) "nfs" (default)
   b) or "wsl"
   c) If "sfu" set on mount will cause special files to be created
with "sfu" format instead of using reparse points to create
3) reading reparse points will always be supported (unless you want to
add a new parameter "reparse=3Dnone" to treat all reparse points as
empty directories)
4) reading special files via the old "sfu" will only be supported if
you mount with "sfu"




--=20
Thanks,

Steve
