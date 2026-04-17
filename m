Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E97331A44
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776409638; cv=none; b=PWwNrbSIcTudIAL4UL0j+cPYUiKLWddhd06wb3TE6LcP5cFCokPoGIFqQVobOqMk/PSCqUGUDYgRm4dsvzUIzENc6In5oEw+j0sLpMLRaT2iOxlI3NovYD9d4GkVfvWYQIorNVqjEa19SAfvINwUI+JGiNR2n1wDywTq5GUtYaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776409638; c=relaxed/simple;
	bh=HNQGHKio5lq8vfbKq9z43CZLNu4SHOMy5KYmqu/oPYU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qY2KSUzzqGZrpQF0WhraXxbFE/i7Ld14PjZ6vZjbdUDGdKeaIjpcmZIQE8yp0pXUCmSKVI+tyn2aEFdugrtjIBmlUBDjsVa8D1goV8AxS1IQgVFUU5WRiaNhqWEmLl1/ewI6LIwkoI7jKd6uK6+HxZvn8/chyd3cHFLXcKufs8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxsAES9c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxsAES9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D631C2BCB8
	for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776409638;
	bh=HNQGHKio5lq8vfbKq9z43CZLNu4SHOMy5KYmqu/oPYU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DxsAES9clQ4Ds5GrOS7NUS6/8jD286vZARDrLzQCKpb+xt62V3CmVt24Y5OUimikg
	 XCdXHo59kHJ0tDvE1fzx3M3Y66bZ8kiS1XJghYfGi7L88NwB4zbjFhsKvj6JnfKVK6
	 8n4TH6A/bLNvjpo2DHnvzGFINEC1FcgCApTvkCwxJBXKIfgEPzolPy+WW/20x2mAop
	 jjIAQVKvfzSRMxlXhBRLYSYAtBZy4CBkYZ6ap4/84pBHBhPvsPsOdH2T0+48LeEZkV
	 a7UuJmMsC8Xyk4AL7RnprTlzARN0FXYb3KSxhRvofb8VuHL/vezEzV6J3lFRRMmjBP
	 nR0vNOmutmiPQ==
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-672645dbfeaso329314a12.0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Apr 2026 00:07:18 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ85mpfQ889JmSZYJ4DPpYfP4i3thUPEf+R1Dnyr1XwZvEyHqFC0G4DjNXOxLbN9GSuKTCku+g9yj1Kt@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7Z527yFa1y49PuR4hDFl5aLnrdKhsPo/TSi2ecg3Yn8PGDZhm
	6pNfXrdloDLaSGzeqOpprVI1gaagPV1u4XQPl1sfFIImS9SEnQ8bRc13UjxFXTT4kIjn1vkZk46
	9wHe+Cw593G/Y+FCWJu8Tm0B8noXiWdY=
X-Received: by 2002:a05:6402:1598:b0:671:4f9c:f664 with SMTP id
 4fb4d7f45d1cf-672bfde1bd4mr684806a12.27.1776409636596; Fri, 17 Apr 2026
 00:07:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416200439.2987930-1-michael.bommarito@gmail.com>
In-Reply-To: <20260416200439.2987930-1-michael.bommarito@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 17 Apr 2026 16:07:04 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-qQoK_qJYOCBxm87b9XH_8dExb0N94QktMmOHDLhDG3w@mail.gmail.com>
X-Gm-Features: AQROBzAFck2vqQkBOH4pN5DOnEy_kJIlkfFReLxJ1_G8N5PEhRCsyFtUwcWsIKc
Message-ID: <CAKYAXd-qQoK_qJYOCBxm87b9XH_8dExb0N94QktMmOHDLhDG3w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
> index d5943256c071..fc4fcd48d6c9 100644
> --- a/fs/smb/server/smbacl.c
> +++ b/fs/smb/server/smbacl.c
> @@ -1105,8 +1105,25 @@ int smb_inherit_dacl(struct ksmbd_conn *conn,
>                 goto free_parent_pntsd;
>         }
>
> -       aces_base = kmalloc(sizeof(struct smb_ace) * num_aces * 2,
> -                           KSMBD_DEFAULT_GFP);
> +       aces_size = pdacl_size - sizeof(struct smb_acl);
> +
> +       /*
> +        * Validate num_aces against the DACL payload before allocating.
> +        * Each ACE must be at least as large as its fixed-size header
> +        * (up to the SID base), so num_aces cannot exceed the payload
> +        * divided by the minimum ACE size.  This mirrors the check in
> +        * parse_dacl() added by commit 1b8b67f3c5e5 ("ksmbd: fix
> +        * incorrect validation for num_aces field of smb_acl").
> +        */
Please remove the specific commit hash and patch name in the comments.
Thanks.
