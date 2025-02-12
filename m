Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF59B209696;
	Wed, 12 Feb 2025 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739364650; cv=none; b=Ty8Z1uufzYvlo4IHzm2oB+lui/JJPcwrNNQkmb+cdl9CxWzWOOEh5ECP9h4I9kuhe4ypoi4iBjDUw2apr8VXKXUJpC20nSbnzzeU+SacV8yks4GJd2h/bsx31HZ1tJrinDcbkNqMDQwgLRtKhijnkavTv9wPGtoq6macWjhdmH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739364650; c=relaxed/simple;
	bh=OGbnmi5mWp2+GpUnWTD1ipJW7n3ugL9Fn0F56mtPkP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G9Hqm4C9fMzp/2pMDrbfwGPv2dBvtxv8YPkClDrZih5YgrjO/KERAFxfTHF2Ho+waVMkonkMeJajp4uQOBS1M7+eYNH6zNV8afyJMpkMWRFVg/gvJZx/Kq+urSSHbjbN8pro7iaWp9FN5KW6yB1OLLjYW9DZDeg5nY+lteCQTbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pUXX0YKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pUXX0YKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370E4C4CEE8;
	Wed, 12 Feb 2025 12:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739364650;
	bh=OGbnmi5mWp2+GpUnWTD1ipJW7n3ugL9Fn0F56mtPkP0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pUXX0YKbG0LegB1FuuGjbgV9hAVqqrOG64wc+YNa7dRV/Ndw2PyTSs8wR09/w3oOf
	 Tqs/VcEt+5WtEdkRXkllJVyQNK/ytHKcO1f+NBTXRm/lFRZ+HT+11VPm0paEPJAZsT
	 5f+cEcOHKr3cN4Jub+mY4Akgvh9LBGK09NaHAAis3J2XAechQKV1bLzH2JWKzdNzCZ
	 yAHtEiNH5JE4yNXaU3R3Jlj7rttBZuojIwStY12FKY0FnHeSVj2OYs7eiHw5ZoFdob
	 Ujx+37rg7BMWAyj4+EfLFbaWTDa9mYJZxdXw9lDMJikgcDn771ilXw9euRv4j6LLKi
	 yOe1aO5fEA7yw==
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5fcad5ee945so8140eaf.1;
        Wed, 12 Feb 2025 04:50:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCViFarHPEFsNTyUFvID6QA5C/4R68AI6R7ObSS/ymex8NL1JcO9zUOyLOkkeTE0tBNy2ii/2pakoYix@vger.kernel.org, AJvYcCXqcpA56HP7eI2os9NPkgQhHJ52QkQJUJVZ7y3H/sp+JWh+NFE/O04OA6Ft5IDlR3ukUBNz5K+6N+YQh8hR@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3l/r/dOhWTlf2wdIzbpugjKWy5RXbNVdnVk94tGtwzD8N1twR
	VgqpMZnKsr2ibFyIJxX/Qmuaucv/VtFNeYCwFgROWj3oalUWq9vAFi6UbHrFecalkSF5qeKGxkK
	ovKtRZoVq0QcArc6t2tKIhEopln0=
X-Google-Smtp-Source: AGHT+IGqfdYhZGWJSxwGz9x4+tnWVeX0CbN8i6XZQ7ftf/HCpeNGg9UYLk5PHscPMlnj6Oy7pb9ABCoA49E2+zz1Qq0=
X-Received: by 2002:a05:6870:c110:b0:29d:c9f6:efdc with SMTP id
 586e51a60fabf-2b8d8961cebmr1646790fac.17.1739364649467; Wed, 12 Feb 2025
 04:50:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212121515.112430-2-thorsten.blum@linux.dev>
In-Reply-To: <20250212121515.112430-2-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 12 Feb 2025 21:50:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-7pxTCOzrxgRWfGBYhUkWu=LApQQvjTcSy2w2SKEMPMg@mail.gmail.com>
X-Gm-Features: AWEUYZntKtpOGG6x0YONHde3A4-S4RxyXxTyQ4G-c-aRcmyc0vRB4XRpLKgX2rI
Message-ID: <CAKYAXd-7pxTCOzrxgRWfGBYhUkWu=LApQQvjTcSy2w2SKEMPMg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Use str_read_write() and str_true_false() helpers
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2025 at 9:16=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> Remove hard-coded strings by using the str_read_write() and
> str_true_false() helpers.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks!
