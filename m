Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A22E1E0B86
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766977003; cv=none; b=EONEVfQchcp7OJuMtksu1VeYPijHDTXVlL5cn8Qpccfdr+97EJTaQnu1D0oQNdapMhoDJRatpNFStC3JCQVI3tboUgqpc8NeWGJYYJ7E803Bu0+x0/IRB69DT1D649EatJIlqewLSv6MpT1yJt+DC/0fuEUwU2rTkROpsro26vU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766977003; c=relaxed/simple;
	bh=bmPuW2PZhVLNjVI8QT9iRZS4o0FD8MCmaMiwvQJallI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=islRT9i9TS8OK3/UJoSMWik6RjceAIyD5kXKUMzQGgQrOoYlQDes67wVzuBGyGw+KZ1nJzigBmyGRexMRsHzu2C24i0ReV5pMo4F/7F4YhW1fWhtHPZWUhFr/F5pE0jQnoXIr82cqGAIe62aQ9Wl1zEmVLmp2btsFzL7a/0tnd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qWmXdG9h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qWmXdG9h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F05C2BC87
	for <linux-cifs@vger.kernel.org>; Mon, 29 Dec 2025 02:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766977002;
	bh=bmPuW2PZhVLNjVI8QT9iRZS4o0FD8MCmaMiwvQJallI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=qWmXdG9hXhliZPFW6kkrW0wzQ2DaJtJcabaZZLV9tyBkgTP4gifGnAQLEOgivVl0k
	 RIA97/GskruRO/AgfP7TsQg2YX1joaLvKAPVcmTXVZ3f84S4ttc2k9Gti4eZ1TbvxM
	 mQHn22u5Wk/7RLP0V4nyOSPlIUOvdsvnc9Yvhv3RZ7aATYjS/FhbfSID9Ur7M4hSt9
	 ktt5K+SXjg0JFPn28+EJU2o7/DbvsRf0AEO9CJvo4mxC1Px+aHie9kJh9vG7NFktra
	 EGJj9A8NN5NAGEay8/GPDXO6vU9Y1mY5wToWUdZnRzEyozeuv5ZVQZObczJ8xuBzk9
	 BWSKPsocAsIdg==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b734fcbf1e3so1790498466b.3
        for <linux-cifs@vger.kernel.org>; Sun, 28 Dec 2025 18:56:42 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXPc2zq8gJ/xlbVY/BCMockRalwDs7UMqVwreq+PEutWo+5+ijcGQwwROTlR16jRn8VQavTCJo1rIJE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7oCTIwV23DpIBW1BgxSfzXyv7feWXLKxYAqavu1tvxV7yIoOX
	13dilXHqROjEsSw5uPIjbXxJgNL+uVHsCQrYDURVgLWEn+zZQypyggfsieHFWQj5JSDwzbXj0HZ
	fI+r18q0tY1fWIIctuudJMuA2xwU2RyY=
X-Google-Smtp-Source: AGHT+IE7RsqAoFYIkxqvCCs7rt+4qIKckbUR/drKtB+krFMDfONd9PykwvV9NzBmKEj/c9J9HRGNm9QJyqDzpij+Z80=
X-Received: by 2002:a17:907:8686:b0:b76:8163:f1f8 with SMTP id
 a640c23a62f3a-b80371d6725mr3112706966b.53.1766977001078; Sun, 28 Dec 2025
 18:56:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251229021330.1026506-1-chenxiaosong.chenxiaosong@linux.dev> <20251229021330.1026506-3-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251229021330.1026506-3-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 29 Dec 2025 11:56:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-+ef+x5uWJ5nXY2iujxpUvBeiD7ar7Ah2dAY+cO+48Xg@mail.gmail.com>
X-Gm-Features: AQt7F2plTY7tt1N7C47HFRgclcRkX7wSICDOOd867CkCZJdSb-DCiUW2_iVVkwU
Message-ID: <CAKYAXd-+ef+x5uWJ5nXY2iujxpUvBeiD7ar7Ah2dAY+cO+48Xg@mail.gmail.com>
Subject: Re: [PATCH 2/2] smb/server: fix refcount leak in smb2_open()
To: chenxiaosong.chenxiaosong@linux.dev
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ZhangGuoDong <zhangguodong@kylinos.cn>, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 29, 2025 at 11:15=E2=80=AFAM <chenxiaosong.chenxiaosong@linux.d=
ev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> When ksmbd_vfs_getattr() fails, the reference count of ksmbd_file
> must be released.
>
> Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>  fs/smb/server/smb2pdu.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 6a966c696f7d..ed9352753d83 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -3007,8 +3007,10 @@ int smb2_open(struct ksmbd_work *work)
>                         file_info =3D FILE_OPENED;
>
>                         rc =3D ksmbd_vfs_getattr(&fp->filp->f_path, &stat=
);
> -                       if (rc)
> +                       if (rc) {
> +                               ksmbd_put_durable_fd(fp);
>                                 goto err_out2;
> +                       }
I think that It is simpler to do it like this:

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8a7c48adb87e..41626cb7d2f5 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3009,10 +3009,9 @@ int smb2_open(struct ksmbd_work *work)
                        file_info =3D FILE_OPENED;

                        rc =3D ksmbd_vfs_getattr(&fp->filp->f_path, &stat);
+                       ksmbd_put_durable_fd(fp);
                        if (rc)
                                goto err_out2;
-
-                       ksmbd_put_durable_fd(fp);
                        goto reconnected_fp;
                }
        } else if (req_op_level =3D=3D SMB2_OPLOCK_LEVEL_LEASE)

>
>                         ksmbd_put_durable_fd(fp);
>                         goto reconnected_fp;
> --
> 2.43.0
>
