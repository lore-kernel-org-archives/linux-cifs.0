Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DF21DDC07;
	Mon, 31 Mar 2025 22:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743461348; cv=none; b=E8bKWIC488hSjMyG7b9MuLXfi2r+B7A2DfQ5F+wOiBCxpMeV1c2SxSwVblt5mGD+kUGpA0Di93OrdMiSlebCTye2+m5DQ9brFrzx4GI6/Nxt5jaWxgaNW52aJQ7Lm6saBHv4E4cwDsplhlIvb+oXZhjGZ+C+pMJtGLikB+s8QpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743461348; c=relaxed/simple;
	bh=PMfyaOxPIRpbvuO5JZ+FFYKtJN4/8ZgmSMc+NhwKDjA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sgkJ+qiYarlCKFivjDMnfFJjN8hw/XxKweLFTqov+RYyzrt/7BQrNqWYXP6KjdgdQs1XY2Rl9vEp3GRkJH9ItK9TcGAZrPZ1QjH/skHPKTpfA43b6YGXb7pAwBw19phV77CSV7L8oghdCG42rRlFzARnBwV+IHob6o3HNIlo0S4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YHkAT59j; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHkAT59j"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-30bd21f887aso35087371fa.1;
        Mon, 31 Mar 2025 15:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743461344; x=1744066144; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJncbmJLl+VK6TEg0oGQymF+gbbxt9mxEVuNURYUInk=;
        b=YHkAT59jlu9PvDjDE2Qu/egJsgfW4YX9sq3odps5aGc3MMSqlOZHFZ3q34QR0FivZr
         M3R1i/1yFPkFPx3B2HRBUqOLlXMfilzomGlyzc3vX54gQ/LlCAkH36lVYQnFvAOLawfQ
         xm74gBFzg7cjS42+HJo5pgKL+dOo01idYWvGqvoW98ROctW1giwh26TqH4GL/n0VHuif
         U5AlkISpa0hqqVoM9MDh2KkqzdSXi1bmzeTJPigKDGkbDZ/IpvGbAfPoRcBW9YCHw2VF
         vRKFrSrlayIHPfb6uWHNfmObMpkbyNKo35Y7W/0vPVhzBeQ342SF474E7kxuY2hsK1+y
         110w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743461344; x=1744066144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJncbmJLl+VK6TEg0oGQymF+gbbxt9mxEVuNURYUInk=;
        b=OjRIErlhUVWwqlybQ0yoP1y1qZ0aORQACNCQHZCoLVZXu1BZumMXV6MIBtFfIHMmjk
         Rb/W7AZhee8Mg/lJCwig9cH93tf6KeliBCSQDhGxk/45nvxfcbyUKixfhJfmpC7y7p52
         QmqfpE71iQxFzglOirjHv5ZGF7mo/p7NQXGRN3GizUw6V37Q7LSoR6pLPrOct43741YR
         +dyectQ8xma9YpIqlmyOuloS5hfuJrSFOYVwDcZqMorzz9IDghd9EMsyB7cs3GU5BOXN
         61edI9q4QGTlwEmauKyG+4O8WEXOcEk7iHVlwjteO3XC8UB282PQxrrK08LMXdCm3C6M
         wM0w==
X-Forwarded-Encrypted: i=1; AJvYcCUm2T/qa2T5fBK/DRd1dwZU4ZssMBFgqphFOCMiIxQhjfsKb9LXm075jydca5n+9ePLNrGbeTMufTS5+p/S@vger.kernel.org, AJvYcCXJjAnDvzkktnjICxyprpGNVxGvmJkm7PeF3MDC0JlmZNut7YQDh2FdgvMeM5HmcFA9bZWlwX/Cc46C@vger.kernel.org
X-Gm-Message-State: AOJu0YxXnZvXerlLFMi8TUfanB8mV0gNzSdK5oWz9b9Px9B93EjLxhuj
	L+CP/KJdiSWLLkiSIymO6LyQHMB3rIhykQBt1C2VCYlFn83W2OV9UP98VGbAKq2MKk99yTzmZjo
	kBnAwxq7fgqzJzFovcJbAGsxnpno=
X-Gm-Gg: ASbGncuKB/dFhgQchPt7AV7Fbx5J79R4DiZnemSq+XWWjfRQJaTla5y3n+bkQlQwY9O
	qCJ7X9f17k6s3VYv5BjSztc9MWimNCIzvqYvRf46BGfeYDLLF0BTyJ5TMnei3esZOabl3bapW6b
	fHzA+Gds3BVjpkH9VP2VdGTMEMoUoOrwOVHPoi5JzRTAvJ5u2xvcvyKmmp8Q==
X-Google-Smtp-Source: AGHT+IFo6fCjpdqA4vfxsp3o/NnEBqFJy1/SxPTHysERpTkduj0rc0zuI6zgJHSdYETc8tbGvR6edlfPCXOcFfjeamM=
X-Received: by 2002:a2e:ad90:0:b0:30c:467f:cda2 with SMTP id
 38308e7fff4ca-30de0248a84mr39845021fa.10.1743461343946; Mon, 31 Mar 2025
 15:49:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250331082251.123381-1-r.smirnov@omp.ru>
In-Reply-To: <20250331082251.123381-1-r.smirnov@omp.ru>
From: Steve French <smfrench@gmail.com>
Date: Mon, 31 Mar 2025 17:48:52 -0500
X-Gm-Features: AQ5f1JrmN4-FDQbhNyJ2tAAA5NJkv_0KAU_KrvRkEUwYudcVKQIfG4o7iA0f3-s
Message-ID: <CAH2r5mtkVvPyT0qvZbNwwKSmsXtryStiE6bGGn_mK=E3V_waEw@mail.gmail.com>
Subject: Re: [PATCH 0/2] cifs: fix integer overflow in match_server()
To: Roman Smirnov <r.smirnov@omp.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Sachin Prabhu <sprabhu@redhat.com>, Shirish Pargaonkar <shirishpargaonkar@gmail.com>, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Merged into cifs-2.6.git for-next

On Mon, Mar 31, 2025 at 3:23=E2=80=AFAM Roman Smirnov <r.smirnov@omp.ru> wr=
ote:
>
> If a large number is written to echo_interval during mount,
> an integer overflow may occur in match_server():
>
> smb3_fs_context_parse_param()
>
> cifs_smb3_do_mount()
>   sget()
>     cifs_match_super()
>       match_server()
>
> Found by Linux Verification Center (linuxtesting.org) with Svace.
>
> Roman Smirnov (2):
>   cifs: fix integer overflow in match_server()
>   cifs: remove unreachable code in cifs_get_tcp_session()
>
>  fs/smb/client/connect.c    | 6 +-----
>  fs/smb/client/fs_context.c | 5 +++++
>  2 files changed, 6 insertions(+), 5 deletions(-)
>
> --
> 2.34.1
>
>


--=20
Thanks,

Steve
