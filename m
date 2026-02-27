Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05AACAD4B
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 06:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772172285; cv=none; b=SbsLbhi3+29nRcD9yXC/mRKBgYsyF6jjK9I1jgomb4IP2IeBjHAiiWtUFnZ7sLMICkG4Y+KjoA1orzEiUEowekgeM6NKYv1xmjFxQQhw0uLWKg8cDRMbH1pjtiEdqAGk5ePm0P94BSXEZdNVlZL3vk1b2D/L5QQTrsgtBGXS5Hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772172285; c=relaxed/simple;
	bh=FU6la1jl0qoiOnoLgrDqAdnpOqNOQ/j8PHOoSFTymYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l0exrBiZSak6cpu6VrmPy3Yb1tmJL79ZLkO2+Q/Jor16b51xmhFFdcoJQQXG7TT8zrPl60QiE+6vqWImu/panHJ93bSwmZE5Bdg/9gnG/UAsRlRpv1XEh1YNkYunrvK/UBsGczawLo+TD55gxsaapE6QftiwZ8tkd7pGUW9WdcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxqGYWPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxqGYWPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD8BC2BC87
	for <linux-cifs@vger.kernel.org>; Fri, 27 Feb 2026 06:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772172284;
	bh=FU6la1jl0qoiOnoLgrDqAdnpOqNOQ/j8PHOoSFTymYM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KxqGYWPOhirSLTcullZxrDtAQekieYauzqQMGl7gW6Y5vhXNFz0VcAn5u28dZWaVs
	 /Qe77kjg3HPUbOT+1civpiaMbrS5mJDCjeLvXlT6iBZsoe2JqMeePDx98x8kNw3mN7
	 ZQTd/kJEKbjjDZnsBZAmmS5nOcQLQUyzPl/OATD+0X5i5UaiEh8p1YceGuxU4QQ7Zv
	 ieSa7CYGOa4n0qBM0pyOEksLVyv3tavG0WZFDepgO3IVAxY3l5oqnTG8QrR/CrJoH+
	 MrPk+Jw9JV/+wJ+xkD2A1nQ5QZriCWBgctiKblNjVA7v9Jg64WXN6xc98bFvDN8sz6
	 jxvd6RscSSuBQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so267589066b.2
        for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 22:04:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW2wwS4jGT8eNpJvcZ23ZoxQDuQRyVx7Ww82rNkR7fetXsEJLzBMlpmIT713s9Z6Tj7RniGOSqcyVk0@vger.kernel.org
X-Gm-Message-State: AOJu0YyuVdQ7dG5xbqZVDQDJOmur/iWwNKCo2wFULkg/OCqo7mRmnTWS
	Xlz/Xt+FksH/EL33HBSRQ9Ba5AvqsURfm0i8A2ULRBJxF5WsH9nfGrAZCUlz7usfek/lJkV98zi
	indSrl2/AOPuKxNX1KULwxCdrN55wVF0=
X-Received: by 2002:a17:907:608c:b0:b87:368a:2bf7 with SMTP id
 a640c23a62f3a-b9376389da1mr95431166b.13.1772172283188; Thu, 26 Feb 2026
 22:04:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227055421.1777793-1-linux@roeck-us.net>
In-Reply-To: <20260227055421.1777793-1-linux@roeck-us.net>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 27 Feb 2026 15:04:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8fR-BZVpQY9qpxio25M-yRt0wYomWt7_Q8H4oKhJQ=ag@mail.gmail.com>
X-Gm-Features: AaiRm50oX3cH_0pNGE60YXF1guYQ2RJ3t92Fg5SEFwCEUO0BW_4qZ4UstbyJIbs
Message-ID: <CAKYAXd8fR-BZVpQY9qpxio25M-yRt0wYomWt7_Q8H4oKhJQ=ag@mail.gmail.com>
Subject: Re: [PATCH] smb/server: Fix another refcount leak in smb2_open()
To: Guenter Roeck <linux@roeck-us.net>
Cc: Steve French <smfrench@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 27, 2026 at 2:54=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:
>
> If ksmbd_override_fsids() fails, we jump to err_out2. At that point, fp i=
s
> NULL because it hasn't been assigned dh_info.fp yet, so ksmbd_fd_put(work=
,
> fp) will not be called. However, dh_info.fp was already inserted into the
> session file table by ksmbd_reopen_durable_fd(), so it will leak in the
> session file table until the session is closed.
>
> Move fp =3D dh_info.fp; ahead of the ksmbd_override_fsids() check to fix =
the
> problem.
>
> Found by an experimental AI code review agent at Google.
>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Fixes: c8efcc786146a ("ksmbd: add support for durable handles v1/v2")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Applied it with ChenXiaoSong's reviewed-by tag to #ksmbd-for-next-next.
Thanks!
