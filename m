Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793611538;
	b=aft1hQBWWdP+jKlQ+B9Re6D/DsBDnLPA1+5pxK5FaKgFxixXp/cyRZWMj9hjlbaHcvFj
	 jayrT0/Lx8vPB9PqEeJJTZik00PqdxwzwmEt/jgaGjAks+KI1snBsysecXEiVHYZAqI8Y
	 lKWD7J5ZKdvja05ts1D0X4kf+ng+XlAWZKogS6RkC/hh9xeZYS46dIawR9Jg5AI6bCueO
	 w5kJfRnlrBIBtYv5pYB7g88xyB055dCaTGGkje2KvueJwazP/J48m2P8d/Jq2BaKfz2vM
	 7O/3b4Yot2iFS/9ue6DtKdnzLZja393+DgPcOHPWFQcZliW7y3Sf0Gqjs1ZmUgnoa5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793611538;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=LNx9hSZ9We7ZO5wkYLxI8aesL/8TIpZpdBJMnBpdWFc=;
	b=WBkuXqAaVNjoNHhMaAXinJtwJodCK+cbaf0AtmCy1G4R1h/CjFHA9FhkOJBSR1s8eyD7
	 NO1i0rPzgRGd63RvRBwNtdq30awsy12wSwFeMeS6fDtlXDxIWo8fjKaqzbddyE8j4HxDn
	 pP91EU/np3qTLunrVr/eT+qXPiElWMXCBQJ8xmdIaYtFcHPW76P/3hCrXVuTQdOGjddHE
	 HFOlowCEIrAQSa0rBpwW9OFr97OoUXbYGvQWZB0DTPPQb2aR9AvfMkKnrU7xhy6nDfSCP
	 PjGZgd5XrAuSenwRPNaxDogpissG+q5EUSB4hDjGCVSdSBgnQh4hBdUjRCbXiaLVZeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zaw+wRPV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25218606A324
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 09:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zaw+wRPV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2ED41F01806
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 09:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793611537;
	bh=LNx9hSZ9We7ZO5wkYLxI8aesL/8TIpZpdBJMnBpdWFc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Zaw+wRPVkCfPy0LP7ToojmYV1uvZ7wz5OITq7kyiu1Em1JIxJSEJfl8dQaRzd1TcZ
	 7AMTyoCgjsgeZNmqGbyu7S+mCrG6zavdEF8aTcehRAoT8v6geTMfxVmeQIsmfJ9MYo
	 Z583rAmA+JUtI/CW+3TcQgUbycp+AOuIs1cjeLb1SIa0+l8w/da20FjRAOX457+IcX
	 ibjWUlHAB+UbGauwXUuYlrr9vklJUcgoVS/+KUBUHB0bj96YNWAQ+eEa52/OPj/iP4
	 NVnrkgYqICtBjS/LiGwosCSz8qMjydieutKOJ4uaNS32LQeF/guuyCpA9AtDjJ/qrL
	 1bU9ACI9JZphw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso452141766b.3
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 01:25:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBxhqSLrNgaXgj7cFbwCqi8IW7q5jvMnuCZLedDDzQ6LO8u1W1eSF0ciRzvDWHG6qJr/fO+oaaNfMsAA@vger.kernel.org
X-Gm-Message-State: AFq9FYJ2VfT79EU9qqw2QpUiWPvR211bSEhR1KqYUWI76t8x5mCrOtAY
	vJyTZuNZmQtLjGka4gPP8NcZcxm/AxGnVUlPjkJluCOrnm5MeBGn2FLnQdaFM2eap+MjJ7lSXAc
	yqAfEIVGIeEfWXuUUFsfuzdg7yvblg7s=
X-Received: by 2002:a17:907:6d29:b0:c40:3a99:3f96 with SMTP id
 a640c23a62f3a-c4ca7a16292mr723014166b.10.1793611536413; Mon, 02 Nov 2026
 01:25:36 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102061537.830714-1-icb@fastmail.org> <20261102061537.830714-2-icb@fastmail.org>
In-Reply-To: <20261102061537.830714-2-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 2 Nov 2026 18:25:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-f=SdVTA39eE94=+fNubJWeRXTs2ZzS+6-FsCeaZt9Ng@mail.gmail.com>
X-Gm-Features: AclHuK-hyRelR43z4vxIAD3_xqk-kPEqP5Abiqe2SZ0RUAsb6GnyPJCZfWkYyxc
Message-ID: <CAKYAXd-f=SdVTA39eE94=+fNubJWeRXTs2ZzS+6-FsCeaZt9Ng@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: let the owner read and change the DACL when no
 ACE names it
To: Ian Bridges <icb@fastmail.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Aamir Ahmed <elb12345@hotmail.co.uk>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 3:16=E2=80=AFPM Ian Bridges <icb@fastmail.org> wrote=
:
>
> smb_check_perm_dacl() refuses the owner when neither its DACL lookup nor
> the POSIX ACL fallback matches. The owner then cannot read or replace
> the DACL over SMB. MS-DTYP 2.5.3.2 grants the owner READ_CONTROL and
> WRITE_DAC unless an OWNER RIGHTS ACE applies.
>
> An empty DACL allows the owner's explicit requests for these rights but
> refuses MAXIMUM_ALLOWED. smb2_open() uses that check for the maximal
> access reply (MS-SMB2 3.3.5.9.5), so even a READ_CONTROL open fails when
> it asks for that reply.
>
> Grant the owner's implicit rights on both paths, for explicit requests
> and MAXIMUM_ALLOWED, unless an OWNER RIGHTS ACE applies.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ian Bridges <icb@fastmail.org>
Applied it to #ksmbd-for-next.
Thanks!
