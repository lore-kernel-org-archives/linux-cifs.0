Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA330155757
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780752899; cv=none; b=p2GMvNm/rQsuiAsAWuinEUl0j9vD+k8VWuOriVINld+wMDercMYI8XjZ0AyMqA3RlVGQGjMs8P31T2AKXPSPDo6uJX1x3kFaKKYa3Xh8ha2wC/L287ReOGJsm5RkjH2YtJaRqsuP5jXZxjy4QVOadlvJXkMpWspklqN+RC+Ohjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780752899; c=relaxed/simple;
	bh=RanSwdjWqpiJAu/gBeePBosrhl1kKf7BxUB1VLl5Fd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=neoWqBV+Kqt+GmOOATu8JoqIEXb/fVbgJgKCWKfwBfU8QW5i++zRBHuJtp6qfuI9Zq6oOpMGBDlpJyCatTn0JOMGQJnvyA6ceFaX4M1LWaOx2zclveQHS8/p4IY43y/d62bTd6bTD1Tii3XjVrl8xK5JD6D6JsleHAo99040R50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CSCtfzm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CSCtfzm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73B591F00893
	for <linux-cifs@vger.kernel.org>; Sat,  6 Jun 2026 13:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780752898;
	bh=BVDdWvV4Gli8JNHoWJrszkX/y3HmOH/iBJYsz1g3DTw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=CSCtfzm5xYRgVvKrOSv02TwdiGZwSRUn6IiDPlKvy+VV+CUsHTbE/HXfboryeuIPA
	 SRfcVDzzrWHU95GzFZ6w9ju5uoR2HzZNPoO7NKJgG1psXYYC99P65q5RLySEq+4VAJ
	 fnnB60BmGPqG9JIkJENJXSdgwr81Sj+rIeZBU2oXTGorB9GvXL8MoUEFQYD4UkaPMo
	 8+yfB575wPsGOy0STe9sjmDClC8fGBtnv+ZgYJqtV9mdaiyhD5hqbj7of1RGeYA9zb
	 GUXdCPI+rRRwhj59lPN+jLWrV29T4R+19mbfZxeLtVjWTHhNtraV6ah4OWuIlkNNDM
	 YSqVe3IgGkmyg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-befee9e5ef7so311595466b.0
        for <linux-cifs@vger.kernel.org>; Sat, 06 Jun 2026 06:34:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9aM40FBuZrgzsy5H3zukIzWbhZkAnGWgyHVesIka0CtX4q08qvw8HomedfBN442IwxBWDdyfQJXpdf@vger.kernel.org
X-Gm-Message-State: AOJu0YxW1JOnhEGf4EJE/C8VY2d49fmX8YrR54LXd8PGaaghqXPc2wrM
	hFYmIhN3Aw94XOrLu7M6NFsqmS1DeA+/JSMpgf6ii1Io7qtBVMlarhdRQcjfHf3Ke6exxvdtz+r
	do0vdwDcYEgy8AltsHn8IxjlCpNWu7dw=
X-Received: by 2002:a17:907:a710:b0:bdb:e19d:525c with SMTP id
 a640c23a62f3a-bf372741072mr421446466b.33.1780752897215; Sat, 06 Jun 2026
 06:34:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260606092601.299698-1-chenxiaosong@chenxiaosong.com> <20260606092601.299698-3-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260606092601.299698-3-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 6 Jun 2026 22:34:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd87ALe7fy-ZL9o-c1BkXMNVYDEMz7jigwgfcm9373BkEg@mail.gmail.com>
X-Gm-Features: AVVi8CeVPW7W4wD3dhUqyovgixAMsr2uG1yYXtvkKmSBF1CAcVKZlAYh3Yvjsho
Message-ID: <CAKYAXd87ALe7fy-ZL9o-c1BkXMNVYDEMz7jigwgfcm9373BkEg@mail.gmail.com>
Subject: Re: [PATCH 2/5] smb/server: get compression file attribute on open
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +void ksmbd_vfs_update_compressed_fattr(struct dentry *dentry, __le32 *fattr)
> +{
> +       int rc;
> +       struct file_kattr fa = { .flags_valid = true };
> +
> +       rc = vfs_fileattr_get(dentry, &fa);
> +       if (rc == -ENOIOCTLCMD) {
> +               *fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
> +               return;
Please remove unneeded return here.
> +       }
> +       if (rc)
> +               return;
> +
> +       if (fa.flags & FS_COMPR_FL)
> +               *fattr |= FILE_ATTRIBUTE_COMPRESSED_LE;
> +       else
> +               *fattr &= ~FILE_ATTRIBUTE_COMPRESSED_LE;
> +}
