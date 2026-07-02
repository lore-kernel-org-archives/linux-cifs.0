Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4825F2B9BA
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 00:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951682; cv=none; b=VbBSSgQAScx1kP9QM7+tIuDHio4m1fK+47YPUzWCmTSjXbQhIGPE4ahwSzAVSIwhn+YnwIu3AEiSdt2oJe7RSuffHWvdjyNseBfoolh9nHGMgnjM+V2jpfvwuBtsAxBFBqAaleGfN25mlAlZmwkkfrfe1pEIhjiCz+g/58DR0iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951682; c=relaxed/simple;
	bh=tkZmPRDjrEj+e1CuTfJBxwJg8vtFtn0ku5s5YMmmAGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C/KiKDCoT7ix03MGM1hJKG6DCA+v5tlo4hvKWdwGsqaWbaJYgfVcH+UYa5aIIGQJHCLwGdF8xsZpTn22ZDQLEH7CRKu4f7F67WKxXcA7o6ckUUZh3BDVv7F3OErTOS/qbp7T7A9V8U0o+PaqOdZsp89igPYHTLJy5fjErzbVoHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGUzCGmT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGUzCGmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE04D1F00A3A
	for <linux-cifs@vger.kernel.org>; Thu,  2 Jul 2026 00:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782951680;
	bh=tkZmPRDjrEj+e1CuTfJBxwJg8vtFtn0ku5s5YMmmAGA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KGUzCGmTuy+UqrB0M2PmpegNCL6STR6JhP/VcPFIQbuggAodq148rAOdPn0y4Qh/f
	 hf5Pz29fBXoNbtdeW/w4SiaAImPJ/kZ5QXY1ffCyb5oP8cobal88RJbgLeR9KIl0Qv
	 BfTCrTi464pG22BWAjuLvzPGanRPUbr7Cdm79gHPRExbgPkXBAquLFfctZpIu0cd1P
	 olKBCU6IpUJZYFnZDEEjttDvw4UCoMH/n4A2vtuuv4YkBPpDIpm77mUuHe8sBNbVeX
	 FLm3xIcXiPYYwXgMuq7q+xd/ItyMlznBVkeK5TtAlnCE/dsmpvay2eaPxwWT2FJXZk
	 K1DfjCoZW6lgQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c12788a75abso241875966b.2
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jul 2026 17:21:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrAfJiadQ4qzHN+awfsBeBM6arW/6QnXP9GFjrwVmS72q/RbRIi1fm33ZNU43kQ5dpaMVuSm26AP/kh@vger.kernel.org
X-Gm-Message-State: AOJu0YzPXVb9G06ZUCMKpIRd57+m/papE0YuhZ2lsgBFsZsgDTG0aZNA
	+ezknUGzJkvoMhKf2vwbSj7JYMdBH6VtW0tRKmB+GCJKfM27PMengV58ZbWnRWGREQUoAqJWUcP
	pxCizdXssQLcrGpeBCn4G95qfZjLZQg0=
X-Received: by 2002:a17:907:e102:b0:c12:5bf7:4ac2 with SMTP id
 a640c23a62f3a-c12ae3ac3c1mr111814866b.8.1782951679501; Wed, 01 Jul 2026
 17:21:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260701152157.822207-1-huiwen.he@linux.dev> <20260701152157.822207-6-huiwen.he@linux.dev>
In-Reply-To: <20260701152157.822207-6-huiwen.he@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 2 Jul 2026 09:21:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_KXELiqFDZ=Q5jJBOWgHOzXtxZyLSxrjh_qPFMNsEJ6g@mail.gmail.com>
X-Gm-Features: AVVi8CeNWvEPkenguG_aC706iNStdOgH6Tit0ayORFszMuIiEwVfn139cvMow0o
Message-ID: <CAKYAXd_KXELiqFDZ=Q5jJBOWgHOzXtxZyLSxrjh_qPFMNsEJ6g@mail.gmail.com>
Subject: Re: [PATCH v6 5/5] smb/server: map SET_INFO ENOSPC to disk full
To: Huiwen He <huiwen.he@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 2, 2026 at 12:23=E2=80=AFAM Huiwen He <huiwen.he@linux.dev> wro=
te:
>
> From: Huiwen He <hehuiwen@kylinos.cn>
>
> FILE_ALLOCATION_INFORMATION can call vfs_fallocate(). If the allocation
> cannot be satisfied, vfs_fallocate() returns -ENOSPC.
>
> smb2_set_info() did not map -ENOSPC, so ksmbd returned a generic SMB erro=
r
> and the client reported EIO instead of ENOSPC. This makes the ENOSPC step
> in xfstests generic/213 fail.
>
> Map -ENOSPC and -EFBIG to STATUS_DISK_FULL in the SET_INFO error path.
>
> Tested with xfstests generic/213 on ksmbd.
>
> Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #ksmbd-for-next-next.
Thanks!
