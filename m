Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1509613C3CD
	for <linux-cifs@vger.kernel.org>; Sun,  9 Nov 2025 01:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762651971; cv=none; b=rkqkQMuHRqJQPLzIHRmRtauB0qW3g2nqfzZdiylJGodp7EeXU4tDhdZvPVQQU6XBRUAY5sXrcocK/b9LyS9EPm4CAmBaXncL1KhDN/UZTp99bgs4mO+O3XD/2L0Mm/J3uR7UOXoGvOOycj7HVrd1dLLh7MD2q1God4aBDa4tlHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762651971; c=relaxed/simple;
	bh=JLDqV8ezX7r/6cFHYwMMco/iyixfBO8kA6xRqCIgak0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XCG+II62tNLjy7tcKRJyCphlwKJ/QQt0iEyGGm61w0DoH3LJvo89NAeSTTrG0rvdjCyYK889mL72m2XaLjoPTQXSk0OxMcGth6YYZ9/oPpHriZ7GFSugKoWvIfgI+/b+A+JZ85bmU7Tidm5MblFxQT2za4s+MyboKvMSdFsJdO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tseue9iF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tseue9iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F26C116D0
	for <linux-cifs@vger.kernel.org>; Sun,  9 Nov 2025 01:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762651970;
	bh=JLDqV8ezX7r/6cFHYwMMco/iyixfBO8kA6xRqCIgak0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Tseue9iF/XsTqddA/n2eiYdGOL9xB5VwvXusYMlOOCeD9l9GjP4zzS8/BPalTFG0e
	 BAg7zKhf5g5qK7V+bgY8DqfZsJNKsfk8pYmtfGUZszQJFzOMpAkNH8VmC4m6k+W0mg
	 hhk94oI3NK6bVMyY+oZFMjucSWZzFlmrDS1genhoaMG2ApWDqR4gk0V9SMB3ed5QuS
	 BYwttlBm7DPZ0f6UhKJ4ecNFwyMOZBK0pHFZm2CbpucecMOMq4jVfW3JllLUSGReOU
	 LH//cABc57A0GkSNuy98bgT16Uq9a7cu9CCAuDIQk6Omf3PSd8kYUdbzTR6qBIkbtn
	 /ZhtFoU22JTqg==
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-640f0f82da9so3845034a12.1
        for <linux-cifs@vger.kernel.org>; Sat, 08 Nov 2025 17:32:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWrJd/DrUAH8yVW4ikGsW2tG1EfgV4hvzOCDD5qdTFIF7sMS8RQWnhKrV/22pb+1ARWRw/nX8nRuw3L@vger.kernel.org
X-Gm-Message-State: AOJu0YzAwprzBzfWqHREZtp2ZujI/T1S1Rmf/Q5mt+Db96jzBx5ezrQb
	SKvHFXoOSuVdO/KXp18WhnVdv9lgjNPmpfcHxucGzdCLVBGnZCPlQ5iFhuoSRphqh2iGTgd8TNd
	ZzC5J11c2oN2xjohdWpF04WqSDO+zoEY=
X-Google-Smtp-Source: AGHT+IFwE0YurAS9EBuOH/BTK/I2Z5iOVtiNvSMR5NXl4i1e/jRjGd1XBWjtYC10l/5GnGiHdMouahIIkUWnSFvo2LU=
X-Received: by 2002:a17:907:7246:b0:b72:5e29:5084 with SMTP id
 a640c23a62f3a-b72e02729dfmr390481166b.4.1762651969360; Sat, 08 Nov 2025
 17:32:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKYAXd-R8NGDzQ-GTM67QbCxwJTCMGNhxKBo1a0sm0XBDqftLw@mail.gmail.com>
 <20251108155712.384021-1-pioooooooooip@gmail.com>
In-Reply-To: <20251108155712.384021-1-pioooooooooip@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 9 Nov 2025 10:32:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-SSBbW+FhC7mHYEh1JLFRVNyNOLiogbj=Nt1eszxf2vw@mail.gmail.com>
X-Gm-Features: AWmQ_bnHIIwGraT7R8ro6xvCocGSJ1L8DonF5ZezAsU__d-y2HYgoO6DXOrC-NQ
Message-ID: <CAKYAXd-SSBbW+FhC7mHYEh1JLFRVNyNOLiogbj=Nt1eszxf2vw@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: vfs: skip lock-range check on equal size to
 avoid size==0 underflow
To: Qianchang Zhao <pioooooooooip@gmail.com>
Cc: Steve French <smfrench@gmail.com>, gregkh@linuxfoundation.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, security@kernel.org, 
	Zhitong Liu <liuzhitong1993@gmail.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 12:57=E2=80=AFAM Qianchang Zhao <pioooooooooip@gmail=
.com> wrote:
>
> When size equals the current i_size (including 0), the code used to call
> check_lock_range(filp, i_size, size - 1, WRITE), which computes `size - 1=
`
> and can underflow for size=3D=3D0. Skip the equal case.
>
> Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
> Reported-by: Zhitong Liu <liuzhitong1993@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
Applied it to #ksmbd-for-next-next.
Thanks!
