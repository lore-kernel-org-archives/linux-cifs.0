Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA49026B74A
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784987536; cv=none; b=GYN0D0wkAdNQC6fXbP2LnwqJx6yy+H1TMwTdYyn+M0nczyAT0kdKWMyC9xcAz132raeXJyPtdemQmZrNRjhjbHiG0NjoBeK5jt/ckX+Ez/unMHQn2Xd94DRqV+UuHV6NtziCyjlOiosvgevRNYE6YTJ+pbsizfucEWtk33btO1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784987536; c=relaxed/simple;
	bh=CvwAXO5OwaMCKbxYwNG0b+P291Wh6ZVmaBkflEklZGI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tXk1eqjzfSU87qdTsU4bd2jqU06ne2QCQrN+XOF2hRGSbxby5ZUeWKRKsEl0CuyFocAF2hL/wL9knFm21dF486tmW9aVD+W+zSNtUqfoGRnnivTqc1onL9VnisyknqBxMfVCgTwlMwh4uabTvUmqeuGQJ51LpfOGGqqCnCqwFL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nImsfAN0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nImsfAN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C031A1F00A3D
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784987535;
	bh=4DLw86ymzA3GSaonpfoz+DsTkbrN4BoVt2rGPUsQ704=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nImsfAN0575iTgwJhGuG/rS8cqa3FhX+kqaBjUzscazY9i7reRp7NkYFbH7slYHAE
	 XTXnmMmgAtpzaO00UlhJ7shFIhpMKkff6qyMbpC3reLIoFK5Y7vUWqO/y7DF/TYPDJ
	 /vYPyaXuchrcZPFw6Uiy2J/zGLUpY1g2xC+ZY8pfIEGMVUu1TIlx5d/Rh2Akmbr+c9
	 lfBE3yUPoZTGEFOk1L5V9f1ZTH1QaljeAsTJKOoNOEk2qw1W7pRL5aWh3zLi6wfUvI
	 VH3Dq+lD2cUCCTDabt+wK4iPLiSvM260dij0jyqLInqeRhKXrTxD6fE9Tt95+adP1A
	 A98Zs9WAaCyfg==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15b1da6b82so177406766b.1
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 06:52:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RotrpIXZlJQg4I33Q00IM+hmiqKaiZdEv060tWhgbvRNz8lOey4jQ9SY2ck3yunFZuVjan2sTr6qyih@vger.kernel.org
X-Gm-Message-State: AOJu0YwpgNZOqU5uZ9nstoZmtMw25jH7i6jNsnVEzJCKdvtEBYojj+F3
	z04r9ZXAuoCv2S75yfu+kc25d/14Bv1DBjNRbJfeinFPDaa53j+bGkN5zaiJIAytJR/JcnASX8J
	e9qkX9lRIm388Zz8fYz/r5+L1IJzZ4hs=
X-Received: by 2002:a17:907:c705:b0:c1c:4db0:8314 with SMTP id
 a640c23a62f3a-c1f1ea0a768mr90231066b.13.1784987534430; Sat, 25 Jul 2026
 06:52:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260723031644.312866-1-chenxiaosong@chenxiaosong.com> <20260723031644.312866-6-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260723031644.312866-6-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 25 Jul 2026 22:51:59 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8AO6FNFNSMopMReX5=LJB1b44N3rQ7GtCU47g9tCwVKA@mail.gmail.com>
X-Gm-Features: AUfX_myt5uCtlsQbPNWd9fCdSRWHDWjWCLQ9Hoz3ffaYJFfABv10UKwvFTY9lWI
Message-ID: <CAKYAXd8AO6FNFNSMopMReX5=LJB1b44N3rQ7GtCU47g9tCwVKA@mail.gmail.com>
Subject: Re: [RFC PATCH 05/11] smb/server: keep notify watches on file handles
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	gael.blivet@gmail.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> @@ -182,6 +182,21 @@ static int ksmbd_notify_add(struct ksmbd_file *fp, u32 mask, u32 filter,
>         struct fsnotify_mark *mark;
>         int err = 0;
>
> +       mutex_lock(&fp->notify_lock);
> +       if (fp->notify) {
> +               spin_lock(&fp->notify->lock);
> +               fp->notify->filter |= filter;
> +               fp->notify->mask |= mask;
This changes the watch semantics for later CHANGE_NOTIFY requests by
unioning their filter into the existing watch. CHANGE_NOTIFY request
is queued per open, but it must not reconfigure the underlying
directory watch.

> +               spin_unlock(&fp->notify->lock);
> +               fsnotify_modify_mark_mask(fp->notify->mark, mask, 0);
> +               ksmbd_debug(NOTIFY,
> +                           "Updated fsnotify mark, inode %llu, mask 0x%x\n",
> +                           (unsigned long long)file_inode(fp->filp)->i_ino,
> +                           fp->notify->mark->mask);
> +               *notify_out = fp->notify;
> +               goto out;
> +       }
> +
