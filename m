Return-Path: <SRS0=SjeK=VW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B540BC76190
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 04:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A3F52190F
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Jul 2019 04:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0DJIeB+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390238AbfGYEtk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Jul 2019 00:49:40 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42619 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390204AbfGYEtj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Jul 2019 00:49:39 -0400
Received: by mail-pg1-f196.google.com with SMTP id t132so22335759pgb.9
        for <linux-cifs@vger.kernel.org>; Wed, 24 Jul 2019 21:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=//+z3x/eqpwOoFdJwYQGA5fYKQHQ8UziR4hGSJfeAsk=;
        b=F0DJIeB+pZ36AiWlOZKd2AY+y4HphlroeRh2xr/s2OVLwQErBrBUbS9jrqdta6Ke+B
         sljXvNII5kvAAySswxBC8bkaaTkJvFCT4N6goEVslAqzwqDnc3WuTNi8zyV0o/wUWdpr
         7MxY+mhZeT21fWDOX5AyzaY+6GRmG2bpx0z8u8JmpKDazNzwWae63BR92Y/WUbe939dy
         5DJtYEjGJirxpfsrYUzOiKf3HMsKMZmdmmqRfes3Q4YtZdhxoiwLkhVGEL1ODN+En6N2
         fBXSR7nn5eldiPrHn7gA2HD8tQuyMa91LV/Kqy+i0H4/Zm379h/n6qri+7kKwfgCv8yB
         8wyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=//+z3x/eqpwOoFdJwYQGA5fYKQHQ8UziR4hGSJfeAsk=;
        b=DZyDtAZWmwyxDMBvN6+RoZKa5fzkivJ3bx+9rcXEhYthDJnz6+ImxJ7hn+Sb06O0Z4
         uOr3wW1t34NUMYEX2Rc/A8BI+JpORbqzMErmcZ7XPl/u3K4vrUI2ditVHT20zJ45F9O/
         hEKIvKw3l/g8+fp2uqbk3z+6s4kQyniakg90elcTOCpJxC0J/auCquq43Vozur6OZqEt
         xz6liESEdEW9dwRxASzbjlVVIs/MmUwwP4FN9QPBPvOyXJxMB4vJFGH93+2sO2S377yQ
         jKKRD6TfNt0TBtNDu1e+JqgrNd6Qy0Z0oUrpBg7P5hyjTCZQbZwtBcuzqOVg+K91KEZT
         +Szw==
X-Gm-Message-State: APjAAAUDPiknRtk7Wy/EM6279RP5Tm634GcOyGmcx3gmvACr9X1eN3IO
        LUojbAWYfxw67XV0Nqa66RP+JSmdSzzruDTpkiw=
X-Google-Smtp-Source: APXvYqw6HEiRfT2luQ7ewzXojyf7Rt3uH+z+EOR6yh3AoBQX65auW1zS/u1r1e2v++bmCgD0biXzyqaCXuxn8FDxID0=
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr92253537pjb.30.1564030178766;
 Wed, 24 Jul 2019 21:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190725030843.9412-1-lsahlber@redhat.com>
In-Reply-To: <20190725030843.9412-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 24 Jul 2019 23:49:27 -0500
Message-ID: <CAH2r5mu2wMjbDGFOBSWTzqbnTaAe9dM2ys20QaXuZ1maVygcqw@mail.gmail.com>
Subject: Re: [PATCH] cifs: add passthrough for smb2 setinfo
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more testing

On Wed, Jul 24, 2019 at 10:09 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Add support to send smb2 set-info commands from userspace.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifs_ioctl.h |  1 +
>  fs/cifs/smb2ops.c    | 29 +++++++++++++++++++++++++----
>  2 files changed, 26 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> index 086ddc5108af..6c3bd07868d7 100644
> --- a/fs/cifs/cifs_ioctl.h
> +++ b/fs/cifs/cifs_ioctl.h
> @@ -46,6 +46,7 @@ struct smb_snapshot_array {
>  /* query_info flags */
>  #define PASSTHRU_QUERY_INFO    0x00000000
>  #define PASSTHRU_FSCTL         0x00000001
> +#define PASSTHRU_SET_INFO      0x00000002
>  struct smb_query_info {
>         __u32   info_type;
>         __u32   file_info_class;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 592aa11aaf57..fc464dc20b30 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1369,7 +1369,10 @@ smb2_ioctl_query_info(const unsigned int xid,
>         struct cifs_fid fid;
>         struct kvec qi_iov[1];
>         struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
> +       struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
>         struct kvec close_iov[1];
> +       unsigned int size[2];
> +       void *data[2];
>
>         memset(rqst, 0, sizeof(rqst));
>         resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
> @@ -1404,7 +1407,6 @@ smb2_ioctl_query_info(const unsigned int xid,
>
>         memset(&oparms, 0, sizeof(oparms));
>         oparms.tcon = tcon;
> -       oparms.desired_access = FILE_READ_ATTRIBUTES | READ_CONTROL;
>         oparms.disposition = FILE_OPEN;
>         if (is_dir)
>                 oparms.create_options = CREATE_NOT_FILE;
> @@ -1413,9 +1415,6 @@ smb2_ioctl_query_info(const unsigned int xid,
>         oparms.fid = &fid;
>         oparms.reconnect = false;
>
> -       /*
> -        * FSCTL codes encode the special access they need in the fsctl code.
> -        */
>         if (qi.flags & PASSTHRU_FSCTL) {
>                 switch (qi.info_type & FSCTL_DEVICE_ACCESS_MASK) {
>                 case FSCTL_DEVICE_ACCESS_FILE_READ_WRITE_ACCESS:
> @@ -1431,6 +1430,10 @@ smb2_ioctl_query_info(const unsigned int xid,
>                         oparms.desired_access = GENERIC_WRITE;
>                         break;
>                 }
> +       } else if (qi.flags & PASSTHRU_SET_INFO) {
> +               oparms.desired_access = GENERIC_WRITE;
> +       } else {
> +               oparms.desired_access = FILE_READ_ATTRIBUTES | READ_CONTROL;
>         }
>
>         rc = SMB2_open_init(tcon, &rqst[0], &oplock, &oparms, path);
> @@ -1454,6 +1457,24 @@ smb2_ioctl_query_info(const unsigned int xid,
>                                              qi.output_buffer_length,
>                                              CIFSMaxBufSize);
>                 }
> +       } else if (qi.flags == PASSTHRU_SET_INFO) {
> +               /* Can eventually relax perm check since server enforces too */
> +               if (!capable(CAP_SYS_ADMIN))
> +                       rc = -EPERM;
> +               else  {
> +                       memset(&si_iov, 0, sizeof(si_iov));
> +                       rqst[1].rq_iov = si_iov;
> +                       rqst[1].rq_nvec = 1;
> +
> +                       size[0] = 8;
> +                       data[0] = buffer;
> +
> +                       rc = SMB2_set_info_init(tcon, &rqst[1],
> +                                       COMPOUND_FID, COMPOUND_FID,
> +                                       current->tgid,
> +                                       FILE_END_OF_FILE_INFORMATION,
> +                                       SMB2_O_INFO_FILE, 0, data, size);
> +               }
>         } else if (qi.flags == PASSTHRU_QUERY_INFO) {
>                 memset(&qi_iov, 0, sizeof(qi_iov));
>                 rqst[1].rq_iov = qi_iov;
> --
> 2.13.6
>


-- 
Thanks,

Steve
