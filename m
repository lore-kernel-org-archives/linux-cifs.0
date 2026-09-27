Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37A537E5E1
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 22:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790549028; cv=none; b=lTZFWbFY0xwViN10WQh96BJ5mUP9GMTfV0LXXaQdBTatLH2wj3U2/APgeelmNoflBu/PZ24lSIAU+CmXdoo2fNhqaY6BVfT+Uciy6nWIv1fF6sR9kpM/wHlKLXc7cOKni5wBGDjYKKtlDDjlz0q8QxWFi9CC2kI47azzymYTC90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790549028; c=relaxed/simple;
	bh=SZ41bFou93ZWtyfSeOGia3NG8wwxMtHJcDTJVtsjmk0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OMZpdyzfBnQhsDHR77tSe22TDK9HXlKWWT3sr/Tb0/xoRqbj08U1yLBgmyifvMUPzDpH1wV1hpOWnm0ufMWtOhaQ22VGUSrVCkidIr9Ch4pxSunsdeZZjueJBQW1RzDnQ+9iaw0wiTpJYTYuZZmIJuJZM9D5qtteYLKyrllOW5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NikH4m14; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NikH4m14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F691F00893
	for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 22:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790549027;
	bh=SZ41bFou93ZWtyfSeOGia3NG8wwxMtHJcDTJVtsjmk0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NikH4m14m8dDps3K1v5szkR7t7pCkaiPypfZ8qwJqzAfyT7TuxqUwv+R4h94gGf4n
	 lhm3zXFdih7HKyorR74UN+QTXmt5fNEnEL0fnAzCyn+YgjIvaJmrFodYInV/13rfCz
	 O6Db55Pnf9UHvZpkNO8Cx+Z5yr41rOsLVJgRA88+/BFNcVfFqbo0BuT/F5o9gVyW7e
	 92ZhS+XJF1xc2HCKhUZcZJtISyAIc8Y0L32xBsRtiDIsSHRpnDZCNtARdGy/9Nop5J
	 RSgiVaUGZN75mfhuekswiVyiztuXGWbxilTQaqXw69GoW2Nh+jbzhkyaGCgkn27LVP
	 hn6a+E26TvxgQ==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2940ef15c1so308902066b.1
        for <linux-cifs@vger.kernel.org>; Sun, 27 Sep 2026 15:43:47 -0700 (PDT)
X-Gm-Message-State: AFq9FYLeJE6qfN75x/U0/E+VjkQeBDQ2nQDu7rISiBWbwj9GWapbNvjL
	76JZ8m/DocNlW35dIKcg7WY95KRmOjqsb067zYpkIt9hXzU3a0+y0SFOLgJ6n7thAdb9usl62rf
	BDY6NBJoJ0aq98ht1Y0414yzI0tfXhO8=
X-Received: by 2002:a17:907:3f8f:b0:c29:45ad:7afa with SMTP id
 a640c23a62f3a-c2ac20ffb1amr1009804166b.0.1790549025901; Sun, 27 Sep 2026
 15:43:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260927061639.1722520-1-zhangdairui@gmail.com>
In-Reply-To: <20260927061639.1722520-1-zhangdairui@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 28 Sep 2026 07:43:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9AJBY3GzRq7S3c7wENDf574YVFRjYsPnMjY-0O6WRr6Q@mail.gmail.com>
X-Gm-Features: AclHuK80XptZNxXYWAc9MP0v453jlUhqtJhB01uJyt8qkplw6diP6bhwz4K4MP8
Message-ID: <CAKYAXd9AJBY3GzRq7S3c7wENDf574YVFRjYsPnMjY-0O6WRr6Q@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: verify transform SessionId matches the decrypted header
To: Dairui Zhang <zhangdairui@gmail.com>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Paulo Alcantara <pc@manguebit.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 27, 2026 at 3:16=E2=80=AFPM Dairui Zhang <zhangdairui@gmail.com=
> wrote:
>
> The decryption key for an encrypted request is selected by the
> SessionId in the encryption transform header, but the request is
> then authorized under the session named in the decrypted inner SMB2
> header. Nothing compares the two, so on a connection carrying more
> than one session a client can have a request decrypted with one
> session's key and executed under another session's identity. Since
> encrypted requests are also exempt from the signing requirement, the
> AEAD tag is the only proof of session identity, and it is checked
> against the wrong session.
>
> Per MS-SMB2 the server must verify that the SessionId in the
> transform header matches the one in the decrypted SMB2 header and
> treat a mismatch as a protocol error. Compare them after decryption
> and drop the connection on mismatch. When the encrypted payload is a
> compression transform, the transform SessionId is saved and verified
> against the decompressed SMB2 header instead, since a compression
> transform header carries no SessionId.

Could you extend this patch to validate the decrypted SMB2 message
against the requirements below before dispatching any command? The
current implementation checks the SessionId only in the first SMB2
header. It does not validate subsequent operations in the compound
chain.

For a singleton request and the first operation of a compounded request,
=EF=82=A7 The size of the decrypted message is less than the size of the SM=
B2 Header
=EF=82=A7 SMB2_FLAGS_RELATED_OPERATIONS is set in the Flags field of the SM=
B2 header of
the request
=EF=82=A7 The SessionId field in the SMB2 header of the request is not equa=
l to
Request.TransformSessionId.
=EF=82=A7 In a compounded request, for each operation in the compounded cha=
in
except the first
one, SMB2_FLAGS_RELATED_OPERATIONS is not set in the Flags field of the SMB=
2
header of the operation and SessionId in the SMB2 header of the
operation is not equal
to Request.TransformSessionId.
=EF=82=A7 In a compounded request, each response in a compounded chain, exc=
ept
the first one,
does not start at an 8-byte aligned boundary.

Thanks!
