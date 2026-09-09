Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C55566C73
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963447; cv=none; b=RJ41L91oXsHXME1/lmq8bZC2jxf/9dUAZeR0jhAxdIJJkEIl4wnSxcvA7FBptY/2pKRK3mnvbQCnT3qDpZfAOcr4CW7ke6MnpY455dlhedvH6t+KRJPnF9wULQhfYpJIiPYDL9GXViPE28Q1YkxOWsq+lzGwwbXtClw106emqDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963447; c=relaxed/simple;
	bh=u5kOERMmnx/10mCXjRq6WEn/CHlFcIPHd1u4/UWzyPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BxBtcevNFLtn/8BOP39uU9c3vuzWCbdvi3XrO31RfNwHpOr9wOtS0BmZMS3p8Rx5iy+mVwutsl/tZd16AcW9MCQW9VpFIiIEct+oYKulsTux6huB5yUbq/qffXoMP66XIUpPNZq3bX/p37KR2KFuT+3jYaUfeWRdxQRgek+a+Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OmjSWbyg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OmjSWbyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E35F1F00ACA
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788963446;
	bh=PDKRUTHhDCmiVPJYXr0NSSjQGrcZKZMZgjZHcU7/9wA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OmjSWbyg5hh8gTeVY8Llt2joSKHySBo2vAvU2XVcF22bRRe/Sj32lOE51BuOEd8z6
	 hJUDdMkg3mq/KKRZZzRMvm9R6S5peSTwSS9snN+knzCVaK6jA16dcpKujhYB5mu53P
	 ZKpFS2QDO81Et5Umg9sLEMstLmfXtYiQx/WLBk9y9PJLvlVoQQOvJeUWlYWNnkGSfM
	 QkXXtZLvrYJxEFnpoQvwKzwEY5l+69Owtwms+q8PTo/rTzbXArBiZ0JIJjidtbZKIG
	 FkzyELtfxGso8SdS6wfOTnpNYchj4Kq78kCAqXUjIplqwHLOcLLbncXHGFLMaBHQce
	 GwLuRtd8eWI8g==
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6a173ad7cf4so9551623a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 09 Sep 2026 07:17:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxGLIQrIMYLkg7dPZ9xGvapyYIl0Lbw0WTSczZCsXkiAXzfqpEI8/fV1s50KkXo2VyiFKoEO8wxoISS@vger.kernel.org
X-Gm-Message-State: AFuF++nnp/G870SNKCRk44Kk2TW0Z0+YvIR4NwvCU/vmgoLcVzdu3JLE
	eUFOkX7Qvfh5zGUkoTaamHnuewoymrfUtppW9AfBkFUHPFXqo8WyhvjNbbn6UOZLyyq7joifzLq
	VGnvFG7o3Y9FBTQmqwq1/GsnJZ+O/GCM=
X-Received: by 2002:a05:6402:550c:b0:6a9:983b:79bd with SMTP id
 4fb4d7f45d1cf-6a9983b7f5emr1148490a12.39.1788963444829; Wed, 09 Sep 2026
 07:17:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260909033854.10107-1-15815827059@163.com>
In-Reply-To: <20260909033854.10107-1-15815827059@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 9 Sep 2026 23:17:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_rgP4tu1x=rQsTsSkTuHeUXe5UWC+KthcnXm3sff_gnQ@mail.gmail.com>
X-Gm-Features: AcwNN1XU-KiqECxxjdNcHkXs9x_V_WvzVUxFdNgjyPwV2VkOr1yRreOyzs1NwmM
Message-ID: <CAKYAXd_rgP4tu1x=rQsTsSkTuHeUXe5UWC+KthcnXm3sff_gnQ@mail.gmail.com>
Subject: Re: [PATCH v2] ksmbd: fix invalid pointer dereference when
 get_inode_acl() fails
To: huhai <15815827059@163.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org, 
	Henry Hu <huhai@kylinos.cn>, stable@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 9, 2026 at 12:39=E2=80=AFPM huhai <15815827059@163.com> wrote:
>
> From: Henry Hu <huhai@kylinos.cn>
>
> When get_inode_acl() fails, it returns an ERR_PTR(), but
> ksmbd_acls_fattr() stored that pointer in smb_fattr without
> checking for errors. Later callers then passed the error pointer
> to security descriptor helpers or posix_acl_release(), resulting
> in an invalid pointer dereference.
>
> This was reproduced on an XFS-backed share when xfs_get_acl()
> returned ERR_PTR(-ENOMEM). Querying the SMB ACL from a CIFS client
> triggered the crash:
>
>   BUG: unable to handle page fault for address: fffffffffffffff8
>   RIP: smb_acl_sec_desc_scratch_len+0x58/0x90 [ksmbd]
>   Call Trace:
>    smb2_query_info+0x40d/0x17c0 [ksmbd]
>    handle_ksmbd_work+0x1ca/0x770 [ksmbd]
>
> Fix this by checking the return values from get_inode_acl() in
> ksmbd_acls_fattr(). Treat -EOPNOTSUPP as indicating that no ACL is
> available, and propagate all other errors to the callers. Update
> smb2_open() and smb2_get_info_sec() to handle these errors.
>
> Cc: stable@vger.kernel.org
> Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
> Assisted-by: Codex:gpt-5.6-sol
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> Signed-off-by: Henry Hu <huhai@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!
