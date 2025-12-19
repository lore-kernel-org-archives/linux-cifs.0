Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E501CD2C
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 00:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766103378; cv=none; b=lCfBx6Jqc/Ry/UoEjTVJH+/RZnzB/XWSMDEb+baYY84UB111Bu7p5Ci6v12ya3MgXIwRx38M1xI4LHUtXqd1Vzen6m4INll+rik/0JWi/0j2ox1oX3JGFSrGJ35r2+VZZW57/zdHwMQKh6jmvUnFQDa8Ll5ze4Kz1mnFgwHANzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766103378; c=relaxed/simple;
	bh=5e7+3DATPX8cm/BodZEk+G3VZ3ae3lZJumGHPeFUv5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nXg5genXA2SKZ9b3UfmoAZTQzpXXzHxU2OL+DYdU+/tf8DIN/HMeEu+oHfw8zBD5aaMnpzMSIZjI7nTkq5uvW4cjCLziZi2fjvTyD+I1tpPJF1U8OunZzWOLd74Mh6K+CX8GVW1Zi4i1A63Vw2CbCSDhQud0oCa3lsbcDdBCtj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FP/h2eA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FP/h2eA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C33C19421
	for <linux-cifs@vger.kernel.org>; Fri, 19 Dec 2025 00:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766103378;
	bh=5e7+3DATPX8cm/BodZEk+G3VZ3ae3lZJumGHPeFUv5Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FP/h2eA4U9dvhnpP+UYZZXpSAu7s6rOORG6v536lzQ0m2/wyrgyxsvc3hsMSSkMq7
	 w+cl2JUv4jl8bC6R3FLOPV9HeAWh9GMINBdV+PPHzBeTkhcj4dTh08yE8NFqu2yH9Z
	 QyasApa4xrCh0zeW/pOK0otFsKygDS25meB2U1uBvOkIzNjzrfFpbo/9Gi9XeVE8d6
	 VVMnNC90Fim4m7BJlvHIJHyQgmc4h4gT/yZMQodZgqh1OISbmXe5sfbiGZiEzBSp9N
	 0aE47iitgLiFJCNc2wI5zrHeJF9d2NgHSIe9IU+NLui8qmGS7b5ZgWQeHvEK4cq/0n
	 /HDDGPY4b0nJQ==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b713c7096f9so203722066b.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 16:16:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVdqVsYo0vSIksEgUBV6QMlDgrxGlPxHrgTToj7KgUOvYY+wFtDAlDX/Uu4XFBsWuixAe8xRd6EwPL+@vger.kernel.org
X-Gm-Message-State: AOJu0YxCDQBzqgh4ETze0/MQldcvYYClCtUwpml+zOhzxyGX+Bpsd+l5
	uO7/PzmQ/2edULMGpnrhRGitifxrcc7gryisIAne5X6htV86yevpeLhKWIP76ui1dXSGBpDXYiE
	nJcHtVT2TQskx69sZQ7z+ACUixfxn9wY=
X-Google-Smtp-Source: AGHT+IFSVfll9BCYY3GaTkDukoYqqa3AguOUQx2GWzdoarYfzTtU/kd+GJuitSzFjgGWP2rQ5G+9Xt2IUVsdVv8uAjI=
X-Received: by 2002:a17:907:3fa7:b0:b2a:10a3:7113 with SMTP id
 a640c23a62f3a-b8036f637e5mr104334266b.29.1766103376639; Thu, 18 Dec 2025
 16:16:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251218171038.55266-1-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 19 Dec 2025 09:16:02 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
X-Gm-Features: AQt7F2oG_wP04t9fTS9TC4sE_2Z7MOF__z6iAqVhyQJejqu6kempvUuG79TY76I
Message-ID: <CAKYAXd-W9xN9rQ4_Y9eudV2CJ7ZObys9YLXib-=wHymH4kfExg@mail.gmail.com>
Subject: Re: [PATCH] smb/server: fix SMB2_MIN_SUPPORTED_HEADER_SIZE value
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, sfrench@samba.org, smfrench@gmail.com, 
	linkinjeon@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 19, 2025 at 2:11=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.de=
v> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> See RFC1002 4.3.1.
>
> The LENGTH field is the number of bytes following the LENGTH
> field.  In other words, LENGTH is the combined size of the
> TRAILER field(s).
>
> Link: https://lore.kernel.org/linux-cifs/e4fbcbad-459a-412c-918c-0279ec89=
0353@linux.dev/
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/server/connection.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
> index b6b4f1286b9c..da6dfd0d80c2 100644
> --- a/fs/smb/server/connection.c
> +++ b/fs/smb/server/connection.c
> @@ -296,7 +296,7 @@ bool ksmbd_conn_alive(struct ksmbd_conn *conn)
>  }
>
>  #define SMB1_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb_hdr))
> -#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr) + 4)
> +#define SMB2_MIN_SUPPORTED_HEADER_SIZE (sizeof(struct smb2_hdr))
+4 is needed to validate the ByteCount field of the smb1 request and
the StructureSize2 field of the smb2 request. Let's change the macro
name from HEADER_SIZE to PDU_SIZE and add +4 to
SMB1_MIN_SUPPORTED_PDU_SIZE.
>
>  /**
>   * ksmbd_conn_handler_loop() - session thread to listen on new smb reque=
sts
> --
> 2.43.0
>
