Return-Path: <SRS0=LGzZ=YH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA59C4CECE
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 21:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9B61220663
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 21:43:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkNSjhP0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729889AbfJNVnZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Oct 2019 17:43:25 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:32897 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbfJNVnY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 14 Oct 2019 17:43:24 -0400
Received: by mail-lj1-f195.google.com with SMTP id a22so18098432ljd.0;
        Mon, 14 Oct 2019 14:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3qwTHsJQXtLByGWGmkMogTYtmXYBCZ8p7g4dCDAH2Hc=;
        b=GkNSjhP0eZ80orHn4cAARxiyTXcvb5pPD7FRVCWSFff5/lJaJh7m0Eym/uVAhlJAK3
         aOHaHKdueqDalt+cb9568WOvHFiduwq/KtHwrU6C7RUEO0UvH+kOatOoFvjlusem7ElO
         4+eiy/B13KWx8QhR4CT9z8n/JZzaCtNEUWW8qB6UdWJqss3SHN/4IMdo8S2dyTVnsMqF
         xwGi1bJhpw2ugWX5wToPEFZTe3kTp9fijpoJ039D1UCsXOR83LYsj6ftvPMB3vEpo9oE
         MAuZ+SddrdhSAp9zO46QStgTyDk2WaXu4jbmygCQohW7F1sk3FGynVd9IdaF/UXvAQ+l
         qplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3qwTHsJQXtLByGWGmkMogTYtmXYBCZ8p7g4dCDAH2Hc=;
        b=p/qd/PizWgxx65FLuAeC6FIELa6ulIclu/RTDT+OlvGQ76yq4D+AZ1lsMHjrrmt7U5
         HZrdBN7XJ6PaYXvfxm1ujgZuFQSCXIyWVDOlsFCQ+KsxApYP/kbIKn6aXwHnSnnV9UK6
         j6jk+l7+GN+S30k7mNQMWrfq0A5agqTl1ZTnCqrqI21S05w81dlbGmET2p+f9kRQBmLZ
         VdgNj3YOJMGQmYjP3PpWeNVHkhZqWdJvEm+KMFvmXTGOM6F9gu0+kNn/gCJGe/NJ0hx5
         RRsVWI6RE1upv4TAspSI9n1zq885YV+s2gnJmA93oCkFhrrOzfFmWMpI6z/DQS08nFRo
         FhEg==
X-Gm-Message-State: APjAAAVmJ0t+nqCjmqHqsL4bBQH4fGIM3g6IhoThYqsN9nq0SPeQkDC9
        8jiLLrjbHA2Am7fG6qx5IaWqBwlA9Q9sCYCyZc320hA=
X-Google-Smtp-Source: APXvYqz3z9deyqj84FSXsg+/2ryg7LbrmoOETqAHbU2dkepNZeuB6r+Ff9HGPQY2TdsoLFO2AyX5r0FI0UrTiwWGhNM=
X-Received: by 2002:a2e:5354:: with SMTP id t20mr20223113ljd.227.1571089402725;
 Mon, 14 Oct 2019 14:43:22 -0700 (PDT)
MIME-Version: 1.0
References: <20191014071531.12790-1-hslester96@gmail.com>
In-Reply-To: <20191014071531.12790-1-hslester96@gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 14 Oct 2019 14:43:11 -0700
Message-ID: <CAKywueQY-J3g0RBF4=opP8SbhpWh-BHoHWzNEeTruxmfacnhGw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix missed free operations
To:     Chuhong Yuan <hslester96@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 14 =D0=BE=D0=BA=D1=82. 2019 =D0=B3. =D0=B2 00:18, Chuhong Yua=
n <hslester96@gmail.com>:
>
> cifs_setattr_nounix has two paths which miss free operations
> for xid and fullpath.
> Use goto cifs_setattr_exit like other paths to fix them.
>
> Fixes: aa081859b10c ("cifs: flush before set-info if we have writeable ha=
ndles")
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  fs/cifs/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
> index 5dcc95b38310..df9377828e2f 100644
> --- a/fs/cifs/inode.c
> +++ b/fs/cifs/inode.c
> @@ -2475,9 +2475,9 @@ cifs_setattr_nounix(struct dentry *direntry, struct=
 iattr *attrs)
>                         rc =3D tcon->ses->server->ops->flush(xid, tcon, &=
wfile->fid);
>                         cifsFileInfo_put(wfile);
>                         if (rc)
> -                               return rc;
> +                               goto cifs_setattr_exit;
>                 } else if (rc !=3D -EBADF)
> -                       return rc;
> +                       goto cifs_setattr_exit;
>                 else
>                         rc =3D 0;
>         }
> --
> 2.20.1
>

Looks good, thanks.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

The original patch was tagged for stable, so, it seems that this one
should be tagged too.

--
Best regards,
Pavel Shilovsky
