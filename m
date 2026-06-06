Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816662264D6
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780753867; cv=none; b=izt7FheQPuq4J6XVYZ+hvohGgs8yf3nI/q79Ha645sH+HAOHEXvnQFTcYrwiSsj2M2sphr7EgWEo0dkv7hBbsnO2wyBAD+l0gY83gg+cOqAqWHizMWQmJZpVKHoJoNTPIPjnzgLqmVGFmpbtndykZijCf9SJteM4SAgvFFxozP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780753867; c=relaxed/simple;
	bh=IUflA7fxPW8fFiSnVaHZ7eSTTQBOPWZhticTk/XZOv8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N4VHkEuYYlKBNy3U77EPDR3qyjXOOv9pZnc7N+Rk1z5iASfD7xnRjiYW8shGpmOlkr/yETEtExw2CsSJXL0h3iyJfqFSvsUngI3YlebGMjRU2evEN4mODe6uZ3mpeBUvnui5fZin6eQLl6+u8NC1pI3mrS+AlHSs8Y0OYbwO87s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=alAi7Ouc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="alAi7Ouc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 324521F00899
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780753866;
	bh=KrTC6qoiXcFrUfcaAGg3nbkCDHS9e5gMsf+u+yYIbhY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=alAi7Ouct+JwQxPPi9Yay4ZQKtScP9AcGghrQ6/haRDFZvIiY6sCqgTgW0urZB/y/
	 MhZJtHBv/eV4BBXhrWgJyMPK3tjAe35DFEbB5U8hf3iKIFeNr7eblVVT9dZR4/k/kt
	 LOOUmTZ1TmCmomRQtNSgJNbZO4js2KnedKMoewQ1KJa8771m06imZzYQNU88EdTiKL
	 7s1eAqbMMatYd1/SFtsJWXobPKkiXhsj42xQp55L744BId12FYeYtWPHzD+0q8qNpU
	 mmWo0kttETvqGLStNDFsvDe0OxAYf1A6D4zZwlEUgSvDmtUENlFH0ugI6E7L9Y3CtL
	 nTmjnDpceES6A==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-bec449d0af2so329508966b.2
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 06:51:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8sg0NyWavlw+XxRTq/ychi80oGrnnavq5lrs4ndao3qdiulqpblgM39rLBOkMeI6yxHVgbjcJM+x73@vger.kernel.org
X-Gm-Message-State: AOJu0YzirVlAnmm0lskSjAurPygmwe8suMxcK5DsqarOV6SJwsXS4s6j
	g6+UwHmXVeeXW2KRC7SBPd33s8Mtwrt3DE0HwMQSj90fWOIZGOGzzbdQiJes+yCEcVWI1tBPPGo
	gGItsn4W0n2TPNJRqRKY/Q9NjMgVY+0k=
X-Received: by 2002:a17:907:2803:b0:be8:d31d:e1e1 with SMTP id
 a640c23a62f3a-bf36fba1c38mr292940766b.3.1780753864667; Sat, 06 Jun 2026
 06:51:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com> <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260606092601.299698-4-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 6 Jun 2026 22:50:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
X-Gm-Features: AVVi8CdwXC9Jektp8EJ9wGgsjnZzB0sBEs8xN9DpLFNIdYiUkeeTD-d9Zceiqd8
Message-ID: <CAKYAXd-DeND_0vjHTrbTaWMjvMAk3dpiDFp0XJyK756C8AiJRw@mail.gmail.com>
Subject: Re: [PATCH 3/5] smb/server: implement FSCTL_GET_COMPRESSION ioctl handler
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +int ksmbd_vfs_get_compression(struct ksmbd_file *fp, u16 *fmt)
> +{
> +       struct file_kattr fa = { .flags_valid = true };
> +       int rc;
> +
> +       rc = vfs_fileattr_get(fp->filp->f_path.dentry, &fa);
> +       if (rc == -ENOIOCTLCMD) {
> +               *fmt = COMPRESSION_FORMAT_NONE;
> +               rc = 0;
> +               goto out;
> +       }
> +       if (rc)
> +               goto out;
> +
> +       if (fa.flags & FS_COMPR_FL)
> +               *fmt = COMPRESSION_FORMAT_DEFAULT;
Again.. The definition of COMPRESSION_FORMAT_DEFAULT doesn't seem to
exist in the spec. How do other smb clients behave when they receive
this response?
> +       else
> +               *fmt = COMPRESSION_FORMAT_NONE;
> +
> +out:
> +       return rc;
> +}
