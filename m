Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DB2355F50
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 07:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772609602; cv=none; b=MmgQpv9hKjK0bFgJeRyQQxLOJntYzGZZ9d3xs82+5/XaSszNSybRWgrjKNMfbgvq9xrwKtoiJGGBFfxuUUTlnQvaMwgcbUYf/IfiOAGFSr+j+TPmKJThoQCtlO9aQo6v+Yb5KIiWhBskgP3gB+C6pUluV7gFMdGP67Ju+UwCOnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772609602; c=relaxed/simple;
	bh=JpywoMyHFkjiKZjEsn53+IkfTs0czhJllJ7JQK7wrI0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JsRGt/gMHaZHxqVPvIS5McU1FM3BE5J5HYyjTuw6BYtrDg51FbwrfoZOgD7L3dTWNzTRpwuwIAgn/KH2DgMkuY1nwzncCIC63xE7FENh8u7Z+i1OJ2il8yyktlQwRQDwImATeniEiT7H48bIpjM1mBCELtAStFyDLtQLKz+Q3iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MjR+++5o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MjR+++5o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19661C2BCB0
	for <linux-cifs@vger.kernel.org>; Wed,  4 Mar 2026 07:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772609602;
	bh=JpywoMyHFkjiKZjEsn53+IkfTs0czhJllJ7JQK7wrI0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MjR+++5oqBp0Jw9NuoAPlGBVBv2JnoFjSp5sbjsgoWtUYqstx6PtYxQMudf34LVL0
	 sIws0eJAmhd9h5rZcxei8RDDfgz7ln1vRnlMXcQPvKEhcdCV06G8f1zZpmRJgI5hBL
	 n4SUVQblLRKP3OdTPvHLtKnS96QCp0xIQNWzvW+C7ChS9DxWcr1E/gwo1XinuwXw2U
	 9C5fQQjrNqOy9/E2RVSSuinqEaazVHKsJXPxLhejFsyG5WK6MtWbQ154juji+N5vhd
	 KM8BTdx8fYDxhayxXvbWnsdDzgUXs6Z27ZZL/aXf6ciBhw/s5DmsLGkXED35kuW1by
	 xFXfDiYe+K3pw==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-660fb578f8eso313777a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 03 Mar 2026 23:33:22 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVXgS5aYMGAb+xYa+rwGls70AkqwPVOxYzHnQqksQ7L6UtEhc0bqQuKFB9paXAt6gKCw0SkAyaXdSBf@vger.kernel.org
X-Gm-Message-State: AOJu0YwVmoGLycIlHdr7HBL72TQY0AG49WkvKQid+NMnP8iNbrsnO9oR
	YI9FTK843eMeLOCzcQGsi6BiXB56aLgNmHcyl0aWhm7QAfaxRzl9SLWd80nM81AxyduNDKJEJ37
	+KXDLelFMxaZGIfR0Ro6zaMk9qfj34uI=
X-Received: by 2002:a17:907:3e9f:b0:b87:2f29:2060 with SMTP id
 a640c23a62f3a-b93f13b269amr64049766b.26.1772609600557; Tue, 03 Mar 2026
 23:33:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260303132552.65235-2-thorsten.blum@linux.dev>
In-Reply-To: <20260303132552.65235-2-thorsten.blum@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 4 Mar 2026 16:33:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8kvfDForq-UegFW+aC=y2X0riYn6bBGF2w2XTUOW=tUg@mail.gmail.com>
X-Gm-Features: AaiRm528qVX0kLxkzn3X7EpvjA0z6czgB-DbC-DVu3I91q11eIWo00QF0VGX_Tc
Message-ID: <CAKYAXd8kvfDForq-UegFW+aC=y2X0riYn6bBGF2w2XTUOW=tUg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Don't log keys in SMB3 signing and encryption key generation
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, stable@vger.kernel.org, 
	Namjae Jeon <namjae.jeon@samsung.com>, Steve French <stfrench@microsoft.com>, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 3, 2026 at 10:27=E2=80=AFPM Thorsten Blum <thorsten.blum@linux.=
dev> wrote:
>
> When KSMBD_DEBUG_AUTH logging is enabled, generate_smb3signingkey() and
> generate_smb3encryptionkey() log the session, signing, encryption, and
> decryption key bytes. Remove the logs to avoid exposing credentials.
>
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Cc: stable@vger.kernel.org
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Applied it to #ksmbd-for-next-next.
Thanks!
