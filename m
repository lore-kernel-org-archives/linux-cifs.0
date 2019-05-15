Return-Path: <SRS0=u+N2=TP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A782C04E53
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 23:11:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 586372084E
	for <linux-cifs@archiver.kernel.org>; Wed, 15 May 2019 23:11:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WygKCYcn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbfEOXLo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 May 2019 19:11:44 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:51916 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfEOXLo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 May 2019 19:11:44 -0400
Received: by mail-it1-f193.google.com with SMTP id s3so3038397itk.1;
        Wed, 15 May 2019 16:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cN3+Ygjn4FIdAipa5bUqsDEqVVhDGW46hPCnToLIxo4=;
        b=WygKCYcnp10z8Ruf7KIWgzGuHed1D/DN7EURO6AsVIXU5Gi5ulDpcHEf5dneDB0szJ
         XQLyWhxBOaoOVQMY1CuvkH5pUV1kL64SZguQ9b9f8KR9d1feJIPm/3hwgutvH4ArY1nD
         biBIJCE+DRRQ1V4H7DN931zb56/DU+MCDYGhy8iXQ9sgPFdlFgb4us9e1hSspr58dyN7
         Nf6FAxEIOEiawAK32P8OMVdgPnQ4OhevuQ/ZO+UzYSzvAmiUhBf1Eh69QpOMcTt1CZcU
         cwQ4Iyy9kh6Zwf+KaWhpgYFa7KsLfzhdv5UNmmuG0mBATqy6+lGf/ESHygMbZ959tvpb
         v5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cN3+Ygjn4FIdAipa5bUqsDEqVVhDGW46hPCnToLIxo4=;
        b=I1V2yrCrALjSszoMG4+v/7VdS1Psf6LszAVuUIP0EFU+OCKN7ZrUECBdjnLfHTWMcy
         Gva6HhR6MbEPcv9f59hzYPEWkzSOnns6ZNWzGB94itwVKoADgljoeytcH9PQ9w6NVc/b
         ug2NtNYMerDVnAmmnT+PhBQNqdgg2uUwcGlU6u/eIpAFniRKYtmCb14P+o4scSQu3h9W
         mzbxbGoaZairKyg5dNhEn8CNMC/2J8mkIaxRqNyVTNnNvnkPOoiFVGdM6Bh3+iq2BsbK
         2a7WfmBXyc7tdUJkuBN+jKVsvfo1lJ+x7ink65jx2OFRnkLDjyBPjkmbLAanZIKyvPVP
         U3Bw==
X-Gm-Message-State: APjAAAXT527z1PCfcQwWDbHqwMq+Oeg1olF8Bd5na+POD0PRuvCZiBKs
        GNwcfeI/TtsRoG7giC7xBWVFxIOsktul8Yz0fjo=
X-Google-Smtp-Source: APXvYqycWgySzDHc20+yTvOMmVS6nuQ8hTsHDl682JxKLCfUYs7sznmDxHdhjWmszO0bPpBoXvKmc/qT/9UpNPtG5GE=
X-Received: by 2002:a05:660c:8c6:: with SMTP id g6mr4171191itl.17.1557961903672;
 Wed, 15 May 2019 16:11:43 -0700 (PDT)
MIME-Version: 1.0
References: <1557954545-17831-1-git-send-email-longli@linuxonhyperv.com> <1557954545-17831-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1557954545-17831-2-git-send-email-longli@linuxonhyperv.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 16 May 2019 09:11:32 +1000
Message-ID: <CAN05THR1VL6W2YJSeNdOsWpM1r7PhMESyzJYSgjZD7=bSFvY+Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: Allocate memory for all iovs in smb2_ioctl
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 16, 2019 at 7:10 AM <longli@linuxonhyperv.com> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> An IOCTL uses up to 2 iovs. The 1st iov is the command itself, the 2nd iov is
> optional data for that command. The 1st iov is always allocated on the heap
> but the 2nd iov may point to a variable on the stack. This will trigger an
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
> @@ -2538,11 +2538,25 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
>         struct kvec *iov = rqst->rq_iov;
>         unsigned int total_len;
>         int rc;
> +       char *in_data_buf;
>
>         rc = smb2_plain_req_init(SMB2_IOCTL, tcon, (void **) &req, &total_len);
>         if (rc)
>                 return rc;
>
> +       if (indatalen) {
> +               /*
> +                * indatalen is usually small at a couple of bytes max, so
> +                * just allocate through generic pool
> +                */
> +               in_data_buf = kmalloc(indatalen, GFP_NOFS);
> +               if (!in_data_buf) {
> +                       cifs_small_buf_release(req);
> +                       return -ENOMEM;
> +               }
> +               memcpy(in_data_buf, in_data, indatalen);
> +       }
> +
>         req->CtlCode = cpu_to_le32(opcode);
>         req->PersistentFileId = persistent_fid;
>         req->VolatileFileId = volatile_fid;
> @@ -2563,7 +2577,7 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
>                        cpu_to_le32(offsetof(struct smb2_ioctl_req, Buffer));
>                 rqst->rq_nvec = 2;
>                 iov[0].iov_len = total_len - 1;
> -               iov[1].iov_base = in_data;
> +               iov[1].iov_base = in_data_buf;
>                 iov[1].iov_len = indatalen;
>         } else {
>                 rqst->rq_nvec = 1;
> @@ -2605,8 +2619,11 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
>  void
>  SMB2_ioctl_free(struct smb_rqst *rqst)
>  {
> -       if (rqst && rqst->rq_iov)
> +       if (rqst && rqst->rq_iov) {
>                 cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
> +               if (rqst->rq_iov[1].iov_len)
> +                       kfree(rqst->rq_iov[1].iov_base);

You don't need the conditional. kfree(NULL) is safe,.

> +       }
>  }
>
>
> --
> 2.17.1
>

Reviewed-by: Ronnie sahlberg <lsahlber@redhat.com>
