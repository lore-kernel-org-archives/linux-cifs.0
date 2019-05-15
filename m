Return-Path: <SRS0=u+N2=TP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8681C04E53
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 22:26:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A128120843
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 22:26:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kASEZCAm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfEOW0c (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 May 2019 18:26:32 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39182 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfEOW0b (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 May 2019 18:26:31 -0400
Received: by mail-lj1-f195.google.com with SMTP id a10so1246705ljf.6;
        Wed, 15 May 2019 15:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BI+5XxI12X2lRwb6h4wr8dsiBHIzz/BpYGz/CVy4Mc4=;
        b=kASEZCAmJ6x7vfVCdxHXiPm2z4vZO3NkJuKAjvUA4di/S3kmxI7yJcUadArWTSGKpL
         flpaOZvsU32pP/7Oupuu67XHJecRHcSY8W+sbK1yM63am8jUQPDBuD9eUhQAUinAZkoO
         0ctD9R6ltTVnBaCyZcGERS7/qb08y+XNnSgSR9v7cAQi5VM9uAH3wQ23CkZ0vF2t8uN7
         e2AeHm7U0VtIm8kbJHlpFpq3m/yr7Zj7A/w3OoAuI8ZhqlI/AoQt9ngJ9v8JZBK5zbEH
         IP1yJo+yzcp+AqBlXM6uehBDbaaXDeWxGdYS3Gh7U/q2fNR5yHdFO0hmN0snP4NBVZjS
         KBVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BI+5XxI12X2lRwb6h4wr8dsiBHIzz/BpYGz/CVy4Mc4=;
        b=AKg3+9EhVTa+myoCRaoB3taF2DVC8EAydscC6qA6IYh8JzjUiBCIbHfEUgYKeup8L0
         LpioMgRzlKcMEBxhbPOdbRNnbDUvcIcYk6Vn7GU7SOpzc8Y685xtcZJOwoNlAz6SnSiw
         pklFThQkBLr13VCurOaI/pYCEdYWfTJKT17xsHxzJSNtEoMTpkaZpGecd+HfMW0ySQQN
         devAxSaRVU23xaSlBR/0din7+hhK7ENyBq3Xo8F6RbaZnVg45jX6FlBitUI+FuXjzjdo
         kZqdJr/9OL5ktsIi13o2CgzmhbhTuI4M8XJAJhc4cNkOnTC9JMWxLqlpH7BoY1miJfPx
         YMsg==
X-Gm-Message-State: APjAAAXhWr09sK8CXnsZ1xT3GJ9KbJicW3pAbt4h8qJ/LzLEu7+8mPRq
        fd6hY2nDCMLEplIai6UvMhCrwYdnq3TQIVbLag==
X-Google-Smtp-Source: APXvYqy4NdkTYy5zjAt5CzvxBa9Vv7mWMfLF8QYKz17MP7z6QNLaJDiFFildHcyL0EcxI/paLqlXCK7gCtFfTQHdphI=
X-Received: by 2002:a2e:994:: with SMTP id 142mr13721967ljj.192.1557959189767;
 Wed, 15 May 2019 15:26:29 -0700 (PDT)
MIME-Version: 1.0
References: <1557954545-17831-1-git-send-email-longli@linuxonhyperv.com> <1557954545-17831-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1557954545-17831-2-git-send-email-longli@linuxonhyperv.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Wed, 15 May 2019 15:26:18 -0700
Message-ID: <CAKywueSxXB3av+4qhi07u2VCMmRPxXTiFBHc4kt5gdRQZQTJXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: Allocate memory for all iovs in smb2_ioctl
To:     Long Li <longli@microsoft.com>
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

=D1=81=D1=80, 15 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 14:10, <longli@linu=
xonhyperv.com>:
>
> From: Long Li <longli@microsoft.com>
>
> An IOCTL uses up to 2 iovs. The 1st iov is the command itself, the 2nd io=
v is
> optional data for that command. The 1st iov is always allocated on the he=
ap
> but the 2nd iov may point to a variable on the stack. This will trigger a=
n
> error when passing the 2nd iov for RDMA I/O.
>
> Fix this by allocating a buffer for the 2nd iov.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smb2pdu.c | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 29f011d8d8e2..710ceb875161 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2538,11 +2538,25 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct sm=
b_rqst *rqst,
>         struct kvec *iov =3D rqst->rq_iov;
>         unsigned int total_len;
>         int rc;
> +       char *in_data_buf;
>
>         rc =3D smb2_plain_req_init(SMB2_IOCTL, tcon, (void **) &req, &tot=
al_len);
>         if (rc)
>                 return rc;
>
> +       if (indatalen) {
> +               /*
> +                * indatalen is usually small at a couple of bytes max, s=
o
> +                * just allocate through generic pool
> +                */
> +               in_data_buf =3D kmalloc(indatalen, GFP_NOFS);
> +               if (!in_data_buf) {
> +                       cifs_small_buf_release(req);
> +                       return -ENOMEM;
> +               }
> +               memcpy(in_data_buf, in_data, indatalen);
> +       }
> +
>         req->CtlCode =3D cpu_to_le32(opcode);
>         req->PersistentFileId =3D persistent_fid;
>         req->VolatileFileId =3D volatile_fid;
> @@ -2563,7 +2577,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_=
rqst *rqst,
>                        cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer=
));
>                 rqst->rq_nvec =3D 2;
>                 iov[0].iov_len =3D total_len - 1;
> -               iov[1].iov_base =3D in_data;
> +               iov[1].iov_base =3D in_data_buf;
>                 iov[1].iov_len =3D indatalen;
>         } else {
>                 rqst->rq_nvec =3D 1;
> @@ -2605,8 +2619,11 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb=
_rqst *rqst,
>  void
>  SMB2_ioctl_free(struct smb_rqst *rqst)
>  {
> -       if (rqst && rqst->rq_iov)
> +       if (rqst && rqst->rq_iov) {
>                 cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* requ=
est */
> +               if (rqst->rq_iov[1].iov_len)
> +                       kfree(rqst->rq_iov[1].iov_base);
> +       }
>  }
>
>
> --
> 2.17.1
>

Looks correct.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
