Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE1F35BDC9
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 14:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761144844; cv=none; b=W8tj9jL/irGuzIcokVM5aYDgMPW8Cgm67WrsqUGYiiBtNcPmCfWjUNQ5PXxi3cBa9mCk4AvpbytHs+waNcQWrHF0sHIDCrLTYjPnm6ZoxQc2oXsu7+UhO+V3AsoQYvk72oWDHc5e8tt9j5Br7voFYKGeTGtvRvOTySnVymcHQNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761144844; c=relaxed/simple;
	bh=bks8qIi7M2BOZI3y7iG2qNo8QYzUXZ0cz4QMvS9FeDg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DBX8fSPi/Spmlauw32ve1DYue0RkXUZvuF6gsyL8hX4CJp06RYHP03RyRtBmfAGhBIr1q6sZfcAlPUMOrPXVJPISXAb1jPlRGLoAcepwZSzkPMItjTEObVWgakQNMTncDN/GbQBt7fR4nC1heetxk8CxvlKqma6heHBb7Wi9FSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AL/8yhpO; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AL/8yhpO"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b6d364dd71cso12813066b.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 07:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761144840; x=1761749640; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bks8qIi7M2BOZI3y7iG2qNo8QYzUXZ0cz4QMvS9FeDg=;
        b=AL/8yhpOqQkpiE/+WJdMEYRlOKeqUqHddQ5y9TgWJ4mfVmJzEBxtfWI5erMBihdD2J
         XKH83fUX0x9DgFIwQ/jErQ8lKqPk/Izt8tkNpZmmKTMSqgpDCFQYDmnECOOnebnW6ZEw
         lL+0H28uPPY64BJaSpC3f7OycjeVYQ2cdbaUnJCnwy+28EXMg+Szcj3Q0LaATsekWysg
         JszZBSnJ3xWexLcrVIKDc1vQDMbmgVRqQZyi9zswePHLkRUeEkZoDPxuT1BOkrI+0vPI
         dAagkhoAf26tOkX23HDkW4jPq5TCuep+sC7zM5qWmao2+p7vzVHsgHUe8UpE2mAqn4NG
         Ddpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761144840; x=1761749640;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bks8qIi7M2BOZI3y7iG2qNo8QYzUXZ0cz4QMvS9FeDg=;
        b=PGd0hsstQVGskMeuk0pZCj4fl6UTha3Xrq0528iBXJK9rVLQLX8tYBEP8BARcQpJ/d
         iss7ixlWve6a5riDXS+pfg2M+35blP4tONP6tHoXwbDOFQQa17v1W3P50md8JwS9rdp1
         4b9W6e4+LpoZIeOQgazUrsEEtvTk2jQW1tIeiyschTr+mwx883mUbOPK7K19vcQ2u9oC
         HYmFWZ2tM+PMRx1FJCVc3uZKzDGpaz0HMvWGB0JYHJBOaGmZMoqYhm4svWKlA+dLwa7h
         P+L+hAROAebZIWZ6WKG4J6X0oAf4OGSfNaEZmqfWBhLR7YVkqO2wEfngE74nekIVlMgM
         +Vaw==
X-Forwarded-Encrypted: i=1; AJvYcCXUPNsHcbbWSHmy7t5zTtEfIISyd+y9tenZI/Tcs/cJtG59D08bhWyXxMQO6cnRFqgAf8z0PP8zVSvM@vger.kernel.org
X-Gm-Message-State: AOJu0YxBDsAADCadk1d6r9g8gaWY7BRsp+OCbhpsXqUcsvcqTmiqxr4U
	N8eVe0Jud0oK4yT3SUkjp63SwEGqYy1gIJ8/l6QIdBRpEZK7qTbQg9N81/7PRDyCG7yu5DWeX/g
	31w9eBlo5LnfT8OQRT5dAWXiCv4umO6Q=
X-Gm-Gg: ASbGncuRYowcNqjlFE7yUwOSW4Z6XBSIdZPWvPfwEOT5ulJJjRuZ4hrpU3DyJ1knpwg
	4qhDxgKtHFHMj5jbkCbz+hbqOJ4htNSn0TSBPFDoMp+QyUH1MAY78cgsDjDFmIlVfKFPza/9R5w
	1UDj/94i7o8ua5DLKt2RDmY1lZbM3TGmXGTz7/w9MnW8ixHwa95eUPDuKhLK3MrKx1RicLLvDel
	hHO328+07jrt2RM2hwMI7DmM3+mAXQ07zPPPPI0mIqFYLfIDWzOhulx3paIUw==
X-Google-Smtp-Source: AGHT+IG7h7TaFxHTuDY8AWEs3DohBAFF5ntTu6CWIe9+nZpuje6ygTxavGcJ/i05b9VtLfcssN/cg/UG6AHp/Ayc0iQ=
X-Received: by 2002:a17:907:d90:b0:b6c:55b5:27a2 with SMTP id
 a640c23a62f3a-b6c76fa331cmr460806666b.6.1761144839990; Wed, 22 Oct 2025
 07:53:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2025102125-petted-gristle-43a0@gregkh> <20251021145449.473932-1-pioooooooooip@gmail.com>
 <CAKYAXd-JFuBptqzEbgggUhaF2bEfWMRXCSK9N_spiBxvi1v0Wg@mail.gmail.com>
In-Reply-To: <CAKYAXd-JFuBptqzEbgggUhaF2bEfWMRXCSK9N_spiBxvi1v0Wg@mail.gmail.com>
From: =?UTF-8?B?44GP44GV44GC44GV?= <pioooooooooip@gmail.com>
Date: Wed, 22 Oct 2025 23:53:49 +0900
X-Gm-Features: AS18NWC4GzKd1xEuugd--eot2ZHrwZpDIUjy0AlgxBnilTm3xbX4azrPGMl_XLI
Message-ID: <CAFgAp7ixLZLXGSN6tOmtNj0f4b-z3pnMrQg4Avnb6tOvj3h3KQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: transport_ipc: validate payload size before
 reading handle
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	gregkh@linuxfoundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Namjae, Steve,

Thanks for updating the patch. I=E2=80=99ve reviewed the changes and they l=
ook
good to me.

Minor impact note: this patch prevents a 4-byte out-of-bounds read in
ksmbd's handle_response() when the declared Generic Netlink payload
size is < 4.
If a remote client can influence ksmbd.mountd to emit a truncated
payload, this could be remotely triggerable (info-leak/DoS potential).
If you consider this security-impacting, I=E2=80=99m happy to request a CVE
via the kernel.org CNA.

Thanks!!
Qianchang Zhao


On Wed, Oct 22, 2025 at 3:39=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Tue, Oct 21, 2025 at 11:55=E2=80=AFPM Qianchang Zhao <pioooooooooip@gm=
ail.com> wrote:
> >
> > handle_response() dereferences the payload as a 4-byte handle without
> > verifying that the declared payload size is at least 4 bytes. A malform=
ed
> > or truncated message from ksmbd.mountd can lead to a 4-byte read past t=
he
> > declared payload size. Validate the size before dereferencing.
> >
> > This is a minimal fix to guard the initial handle read.
> >
> > Fixes: 0626e6641f6b ("cifsd: add server handler for central processing =
and tranport layers")
> > Cc: stable@vger.kernel.org
> > Reported-by: Qianchang Zhao <pioooooooooip@gmail.com>
> > Signed-off-by: Qianchang Zhao <pioooooooooip@gmail.com>
> I have directly updated your patch. Can you check the attached patch ?
> Thanks!
