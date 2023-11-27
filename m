Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lZkv2mYG"
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB0A12F
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:54:51 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-50ba78c7ee2so2464894e87.3
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701060890; x=1701665690; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B+9kHM0FXbgL9+c1g/cZgX3FPGiw2hYvMeickf4DJx0=;
        b=lZkv2mYGvhxCQcDfqFvO78qQRZ52Ra3ON3Vzf7MzVx6AfLwEMsFl62w4y63m06QuQw
         kJdMCtQM20ZSZF8jLiOLnhw0U8P0sIOxZ0eNHkVtcJxqO2z6JOLchpMtBm3pxaUwcjoi
         0vUvFQrNZI7cNrPZwKcBGbVtfuazX5Xg5Ih3hw+enPmo6WS8kWk3qHHG9NjtQZsiQdOu
         6g8z7bEmVWTrSrF8B/2znxFs7wE6BWroarOSlivn9XlXmMl/BqiqTbv7nSkeHeHQ6iw2
         pa3ArzwsFBxGS1CEzRk5BBTIZppC1iOpQI84v4Ar4tfbg4y1yNY6ehzjRRKLD3bFQ3oe
         Ox7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701060890; x=1701665690;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B+9kHM0FXbgL9+c1g/cZgX3FPGiw2hYvMeickf4DJx0=;
        b=VsbGcWq13J5nz6OSNqDfScbKJLyRG+L+EZS8OTKpr30g0Jw/wGYhIAxg6smJ6ZNoXw
         NZaOANFVExaVBCPDb3Q+9abBjbH1+oUvVq2IyhxkSQLRI8h3A6oQL2gEgB+UU9WTr7vu
         tMA2fcM2foLY8UmzlV81WmzZto5iCBmhVBJjjdpprRRI4C4eibtc9pOtmhr/HUAbtGwj
         K6rGg3Rb7baLX0LH9TGpjAflZd47rov55hiV/c5MyuZauwfWiTIKDjX9ocFfwOPF55yx
         PBrd8DtSkx/RsoKMd0YspR3r+MHEiRUg/YwdbmZO06XJCWcVMl7CJZIOqTCBxw5IWX7i
         MkYg==
X-Gm-Message-State: AOJu0YwYLCEBtNKQSC8GKhD9mDDJqG8EWqfgOAGuAJylHywLD/uFAfEh
	/HfoN5x3lSnt/Wf5LmJ5ATR0pfDaXcwsQ7X+p8Hp6b1QHOU=
X-Google-Smtp-Source: AGHT+IHyyxeEQ1oO7btGmY+8HZQ7jx/awok0yl4CzWjsJV244PQilDINIm0fMsjCLp0bUuPBeLimmSaLqs50NKvTWcA=
X-Received: by 2002:a05:6512:4007:b0:503:95b:db0a with SMTP id
 br7-20020a056512400700b00503095bdb0amr4832217lfb.12.1701060889482; Sun, 26
 Nov 2023 20:54:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
In-Reply-To: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 26 Nov 2023 22:54:38 -0600
Message-ID: <CAH2r5mujUZgEiHJZgo-6Z6Xe3xykWMqUoTvQ8_ev__5-5RmO3w@mail.gmail.com>
Subject: Re: [PATCH 1/4] smb: client: Delete unused value
To: Pierre Mariani <pierre.mariani@gmail.com>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

on this one - I lean toward leaving it in (although technically
unused) since may reduce future errors by being clear that this is not
an error case and may be a bit clearer to read to some.  No strong
opinion though on this.

On Sun, Nov 26, 2023 at 10:52=E2=80=AFPM Pierre Mariani
<pierre.mariani@gmail.com> wrote:
>
> rc does not need to be set to any value in this location as it gets set t=
o other
> values is all subsequent logical branches before being used.
> Fixes Coverity 1562035 Unused value.
>
> Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
> ---
>  fs/smb/client/connect.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index f896f60c924b..449d56802692 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -1770,7 +1770,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>                         tcp_ses, (struct sockaddr *)&ctx->dstaddr);
>                 if (tcp_ses->smbd_conn) {
>                         cifs_dbg(VFS, "RDMA transport established\n");
> -                       rc =3D 0;
>                         goto smbd_connected;
>                 } else {
>                         rc =3D -ENOENT;
> --
> 2.39.2
>


--=20
Thanks,

Steve
