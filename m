Return-Path: <SRS0=kJyB=TQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D115C04E84
	for <linux-cifs@archiver.kernel.org>; Thu, 16 May 2019 02:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8B3D20848
	for <linux-cifs@archiver.kernel.org>; Thu, 16 May 2019 02:58:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LaQAxqZC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbfEPC65 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 May 2019 22:58:57 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34648 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726084AbfEPC65 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 May 2019 22:58:57 -0400
Received: by mail-pg1-f196.google.com with SMTP id c13so799211pgt.1;
        Wed, 15 May 2019 19:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qVrC4Tuj5UyBfw+iLDxuy7o7a/GjCU+sQeQ56O5xCjQ=;
        b=LaQAxqZCNGuGalss7W1xQlG5JefFBkrDN10HKyh2spwpNBgqTvOPZgNCAutAgDzpeM
         +r+fmX3D+tXaLddhfWuPPtRA09IH5ammf47tHnMtSR3/V1MMiamRlU7VnG3hrIek4UTJ
         P91rkzAmcBfWR2ENrcgMu+jRl4r6jM6Jdb+RETJV0ETbowdW+CiT8OLW+DRAJFs6ELps
         sPx3nKjr8glEFVeYIldsdlF2Q/15kABE7VthyE5HA0Ba/r3JD9+2ZJaiQO6oWw2x4Li8
         EKo63JGHqnV9uzl/L6DcZ3PNbNS/qJepGawZX35aZ1bcjdIuKjrYSljZYgbnnurhTG8B
         LexA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qVrC4Tuj5UyBfw+iLDxuy7o7a/GjCU+sQeQ56O5xCjQ=;
        b=agsPvwwR3ChaxYncPwZpkpUH3H90wNLb+5oOxizF0eXzeWgtKQ3Nkt6lxCqxzGPuVJ
         +ix9zR0YDWTi9phgbmGk6bHPXWTWKKM+Sv6aucsePqlYTqjp4A33uKhy2GUFErBgpye1
         ZASsAHGGSdrGQ+hASzA9VktIAJJE9Ja30xiJo1B2YCStOTR13/jzjOsLTQfJ7YFlkRqS
         a4H9DduRbxhQUW/oeMLEzttB+qVrkEjz+mRvEJfrGDR6P0VHcBbmMtpHn4hGjuHppCqB
         ta3BXuftcKOf/JV1Twkfx3TJIYyt/1Qxfhh+MZeJp1R0Ep/kNh3Z55z0vTAMwqXi8Yvg
         Kyjw==
X-Gm-Message-State: APjAAAV4jv0NPH6opOd3O8MyiJbKMEmGvFyu0OBraM1BV85o484mptYU
        W3HCWeYx9Ip/QitP0PfEU0Vxf4B1Lm6U8cC5p5e4Gg==
X-Google-Smtp-Source: APXvYqzPP45QfONTxLmhLPzzS3LwtQ71ySL5Eq03qCl6oEFiGgB5qLoAzHBjErCqOL6EepJAuG0ngUNuM8CQI5krZO8=
X-Received: by 2002:a63:a55:: with SMTP id z21mr47828274pgk.440.1557975536152;
 Wed, 15 May 2019 19:58:56 -0700 (PDT)
MIME-Version: 1.0
References: <1557954545-17831-1-git-send-email-longli@linuxonhyperv.com> <1557954545-17831-2-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1557954545-17831-2-git-send-email-longli@linuxonhyperv.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 May 2019 21:58:44 -0500
Message-ID: <CAH2r5muSfofEKamfz2GrL3gTrwiR7Ek-gT_f1YapOzsh7Tbb+w@mail.gmail.com>
Subject: Re: [PATCH 2/2] cifs: Allocate memory for all iovs in smb2_ioctl
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Wed, May 15, 2019 at 4:10 PM <longli@linuxonhyperv.com> wrote:
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
> +       }
>  }
>
>
> --
> 2.17.1
>


-- 
Thanks,

Steve
