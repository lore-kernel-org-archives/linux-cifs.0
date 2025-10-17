Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4B73570CF
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760709750; cv=none; b=XjkLsUE2CuQPdcgmC944AZLGtVTVKJVRulRokKZhRQOCdj6SdMZeWCTCggK33EAaXjYuUQOmjEvvINo33uR81n+9uejR9rfwQTDqjzuCTjk3c0p6/oCjwKc3BoFszlOFdxsGYvdFOfuymvCty9gDilljvpRdjw9lPsmiESTrnYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760709750; c=relaxed/simple;
	bh=+WQAFIcQftgcbnsP8qi8SFo4a7cNZWtR2z0Dmdr0S4A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LMr8xfA0TgeAYJqrja2Z+N3nii8EibArV2WBf4SSLGr22ahVclHzx/Ph/n7HUe1U0kLPQz2wvh3c+fdJHdxu7sB7l+F/3Dx/e5E3pcdLn4JP48nxeMeGrkqmlEe4nawg7U3HLhiWT9Mlzt5jMzR3+EU77Lbes4fwr3L0lIrOafk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iWtMd/vy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iWtMd/vy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2895BC19422
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 14:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760709750;
	bh=+WQAFIcQftgcbnsP8qi8SFo4a7cNZWtR2z0Dmdr0S4A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iWtMd/vywIicw2TcnszpbMTAtGntaOQtLznMJO0M7wv9XlSAw0jxY+qs/fvGQeWvk
	 LoRkdVKavZTAITzQ2i03jj2i9KhqsWdT+YZ3cT3A52NC8dsQSkhSNoj+pfZuaJhG1f
	 Ovs/nDAJODNh3WPLP3uQk9Ld2G0mLirIycoyRcPfAdKfTfGj52ZtHCkzQuwX8U3r58
	 XUWnHwWrin+DrLXLFD0jzZdIYzI5jGxFKV/9+fcDIYFOC5IcHpeBV9Ks4UAo/bsAk8
	 1zu/u2IoGf8yzfwMcJN3bpsPBhvvaqMY+zvjTaOdDPCz83bdzvZ3VzfE7fFhBHnOp9
	 d0r9QEWcbhJsQ==
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-63c1006fdcfso3642827a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 07:02:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUKFLpOGym6EtAvfapi5GlfeCTBx+di4T7Zd9Lbkaz6SY1rYE1xcRi2e0NPxqUZKdfR5IpD7Tnr1dhL@vger.kernel.org
X-Gm-Message-State: AOJu0YzB9pUQtyyk9VlvXPPKwDvyB2UBzASHAELjjPsY0hhC3I22VHAo
	dFPqX7MrqMe+c1qvZA6VTTVCF/8gHmXqeetxNzQBIzRlKl3cexF/OSYNb6mkc0S4pc7bYxXsq85
	0LKxvU85YDOewH7DP8UT0b41Q6UmHSFo=
X-Google-Smtp-Source: AGHT+IHe7NdYJIpHp7uroetWArpCT2XwWBQTS8GIvDQwvcJlfeOcTPupp6wqRk9GMQmcjX/CWDNvquIyALIS2M9cW2I=
X-Received: by 2002:a17:907:25cc:b0:b40:c49b:710 with SMTP id
 a640c23a62f3a-b6475129316mr404050766b.47.1760709748584; Fri, 17 Oct 2025
 07:02:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251017084610.3085644-1-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 17 Oct 2025 23:02:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_kq9T0bgUeX-dMD-OEu48tMDm5s+gRPPADkfOL+GH7vg@mail.gmail.com>
X-Gm-Features: AS18NWDycZdJv9kAgv6lnVSHwzSiS8Xjzx0ehbFh0cukXvBd5SPGcB6YNHrRMrE
Message-ID: <CAKYAXd_kq9T0bgUeX-dMD-OEu48tMDm5s+gRPPADkfOL+GH7vg@mail.gmail.com>
Subject: Re: [PATCH 0/6] smb/server: fix return values of smb2_0_server_cmds proc
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 5:47=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> These functions should return error code when an error occurs,
> then __process_request() will print the error messages.
>
> ChenXiaoSong (6):
>   smb/server: fix return value of smb2_read()
>   smb/server: fix return value of smb2_notify()
>   smb/server: fix return value of smb2_query_dir()
>   smb/server: fix return value of smb2_ioctl()
>   smb/server: fix return value of smb2_oplock_break()
>   smb/server: update some misguided comment of smb2_0_server_cmds proc
Applied them to #ksmbd-for-next-next.
Thanks!
>
>  fs/smb/server/smb2pdu.c | 30 +++++++++++++++++-------------
>  1 file changed, 17 insertions(+), 13 deletions(-)
>
> --
> 2.43.0
>
