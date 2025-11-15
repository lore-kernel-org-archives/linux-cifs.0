Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068127E792
	for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 07:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763192492; cv=none; b=m5gKRCdYBNeNVMxT6qe+9oYcMhVj1hlgFYpsKgEPsm14R5gfLWg+mtfZrTExq6OEIbPiNNAhQUCGb4JhFQjV8PD1e1slNaJovna3WmztSz/y7TAKH2VkHCX8nRljV3UOfdta8oMikv3GeDnQpc5RGXQyBAqPcb+YQVWljHsdSjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763192492; c=relaxed/simple;
	bh=cuFwPhieENhiqbZnwq5W/HlR7uu27u+RAILOYnQIZaU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R3JKy6M7tQgoUmWPbSTSsPg6iaoZjkwRa0g/p3fMcL+jSc8213VS98bKxlqzuj0PH+rVSuVgjU9BEAu/5I3Kx7ayW0SscvXoyhHLObqNvItYxleubKw6nueV1qHkXEMPTgwtA3owt5EYpLmkAZipUHl0NmyIHbyvV+MgQZZOo2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3jsbcy4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3jsbcy4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB60C4CEF8
	for <linux-cifs@vger.kernel.org>; Sat, 15 Nov 2025 07:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763192491;
	bh=cuFwPhieENhiqbZnwq5W/HlR7uu27u+RAILOYnQIZaU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=m3jsbcy46T+/B0XH4rwSlPRF/Hg6+D8nPekN/3CtBhi0a1gO04fKh2hVMiRG4xhQ/
	 ujNPSZGX9E3jaZmdQfj1OPz9Y9sKfdX5IbXXhK7/c9cUlVOs3YRibKWPhBTgyz5VI4
	 fNNvc7WjiYQYnL3OWnggoPPHN9LeDgwW7nvoKSbqtMqXhNDWIHRWBJcoHOXemV/Lgq
	 Jl+x1A5q5Iy48PmMw79gWZ22VQNxRaUvKDdwNZ/TV7LDMUGukCon3vTDrL5yGdyjZZ
	 RnfDf8sRqYHXbFd3gAStSarzW8bG07wbVuvWFFtMdtxUl0tSTZp8ouzqJGJLMbspCf
	 U12/Jn/9QUy2Q==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-640860f97b5so4404746a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 14 Nov 2025 23:41:31 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXUv38C7eJrwc4/G1SdQRZzXas8kxV5YT6vH7M+i+FK8b7gmkzkaTXDufmKGkZ4c9tqnfqG6TxOoCyQ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0VdZ+mUZqPSg5+lg524j1zxgwx0JZHjVslEnhekPxuds6SoP0
	VoYlZyoYC5Yu1cpwW2ZHYAjY5TJnZaEJXr7E7ui/Y/dTrm0NPdQ7b9UMgCHiUM2ET1qxjf8ju8w
	zeJWU7RXqUqBCIPvVfpADaVlVld4i+4Y=
X-Google-Smtp-Source: AGHT+IE6zWMJH1q5WHEPGDyBaouhoAModTwuB9aSVtNifzJeou+ywk7TW1l1bvssnVQMsCaFj6lXWH2tWGwRq+0gh58=
X-Received: by 2002:a17:906:280f:b0:b73:6b24:14ba with SMTP id
 a640c23a62f3a-b736b24b5c7mr318522866b.8.1763192490257; Fri, 14 Nov 2025
 23:41:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113133252.145867-1-chenxiaosong.chenxiaosong@linux.dev> <20251113133252.145867-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251113133252.145867-3-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 15 Nov 2025 16:41:18 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-E2sSk-8Kw3uZPm-CH8KSr8h0fcCvjFm2YK3eyN1BC3g@mail.gmail.com>
X-Gm-Features: AWmQ_blhiBIIy5KtuNYOxfADin2jnRlIFE13JnaGEeWPtEbL469yH5D3DaybFOA
Message-ID: <CAKYAXd-E2sSk-8Kw3uZPm-CH8KSr8h0fcCvjFm2YK3eyN1BC3g@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, chenxiaosong@chenxiaosong.com, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 10:34=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Modify the following places:
>
>   - struct filesystem_attribute_info -> FILE_SYSTEM_ATTRIBUTE_INFO
>   - client: remove MIN_FS_ATTR_INFO_SIZE definition,
>             MIN_FS_ATTR_INFO_SIZE -> sizeof(FILE_SYSTEM_ATTRIBUTE_INFO)
>
> Then move FILE_SYSTEM_ATTRIBUTE_INFO to common header file.
>
> Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/client/cifspdu.h    | 10 ----------
>  fs/smb/client/smb2pdu.c    |  2 +-
>  fs/smb/common/fscc.h       |  8 ++++++++
>  fs/smb/server/smb2pdu.c    |  6 +++---
>  fs/smb/server/smb_common.h |  7 -------
>  5 files changed, 12 insertions(+), 21 deletions(-)
>
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index d84e10b1477f..49f35cb3cf2e 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -2068,16 +2068,6 @@ typedef struct {
>  #define FILE_PORTABLE_DEVICE                   0x00004000
>  #define FILE_DEVICE_ALLOW_APPCONTAINER_TRAVERSAL 0x00020000
>
> -/* minimum includes first three fields, and empty FS Name */
> -#define MIN_FS_ATTR_INFO_SIZE 12
> -
> -typedef struct {
> -       __le32 Attributes;
> -       __le32 MaxPathNameComponentLength;
> -       __le32 FileSystemNameLen;
> -       char FileSystemName[52]; /* do not have to save this - get subset=
? */
> -} __attribute__((packed)) FILE_SYSTEM_ATTRIBUTE_INFO;
> -
>  /***********************************************************************=
*******/
>  /* QueryFileInfo/QueryPathinfo (also for SetPath/SetFile) data buffer fo=
rmats */
>  /***********************************************************************=
*******/
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 30c391424022..4ccc8d1e130d 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -5982,7 +5982,7 @@ SMB2_QFS_attr(const unsigned int xid, struct cifs_t=
con *tcon,
>                 min_len =3D sizeof(FILE_SYSTEM_DEVICE_INFO);
>         } else if (level =3D=3D FS_ATTRIBUTE_INFORMATION) {
>                 max_len =3D sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
> -               min_len =3D MIN_FS_ATTR_INFO_SIZE;
> +               min_len =3D sizeof(FILE_SYSTEM_ATTRIBUTE_INFO);
FILE_SYSTEM_ATTRIBUTE_INFO is being used elsewhere on the smb client,
and there are cases where sizeof(FILE_SYSTEM_ATTRIBUTE_INFO) is being
used. Will there really be no problems if we change it to flex-array?
