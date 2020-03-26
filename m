Return-Path: <SRS0=YqT1=5L=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFFC1C43331
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Mar 2020 02:02:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7170820737
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Mar 2020 02:02:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A470PTWm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727564AbgCZCCT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 25 Mar 2020 22:02:19 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:37489 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727561AbgCZCCS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 25 Mar 2020 22:02:18 -0400
Received: by mail-io1-f67.google.com with SMTP id q9so4508262iod.4;
        Wed, 25 Mar 2020 19:02:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4xp15kfS5NUhuffpTH0eDvjkAD1zDSgezpo7dNfleWM=;
        b=A470PTWmd3GEYYQ4A9YPKgbChJGyiY4F/5V6tcTy0Ga8tbBdJSYPz/yC1fvPflKC8t
         WT1IfvFT5UA8wR63Th2NKqY/PfnKZBL2AlVbiXDux3dX32OD+3x48cmCev8maPRSMctw
         fpJ2WGSxh3ZXObrhTsnQjWHPAF7jDOWQon21L1ZpOloI/0Aw7A7OxyIAFk6q9OCaypmO
         asZ8yswb5cUYK7ryzf6JBnfJ3G3zJWWwcZnMccr2dxbWr5hbvukhmq+Jj9Usat4VM6xk
         LZyyXwmJTzoZjDhXYwz4nKOePITfEIm/WUbVlGg86nkknSWbaIs5H5iqcDmYuBmLO+F7
         UoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4xp15kfS5NUhuffpTH0eDvjkAD1zDSgezpo7dNfleWM=;
        b=pra/aJfty1EJRUqmW7F2zQSUGN4zZZjBPXk03d9/LvoQkv5AhDYoskiSlkGyucDvE0
         hNwkTmP65A/QdhbnMLwx7B5Pml2uBa7LNHxb2+KwPeYt9dLuOJnaFMG0qjYG9F07PQlN
         hU3SNcOU2ylopVuzxFD3jxx2eypv9xX/b4nUK3YHSWmZLEOmDT30SaeKFlsb4ZDs79Y7
         q5PKsH9HzyisxPtpZ+qr5v4eaAP41DlV7V2e1ianWd1I9CaTUzBp8Q+Lqwzv5/w871HV
         0hh08srYPXzL6GmDU9awMvZNyDQgartF1sI51gkLDkjr5HniLrL9G4eCPtTr5aAPvQwp
         eA9Q==
X-Gm-Message-State: ANhLgQ35tko9PXHfiWIxhRy3bi89uxKtVZyKZ+CYw0vZnD26d4lyM7Bc
        uLSY0ncxDejqUeovzaWDt/anRiStbxFM/zuVMyw=
X-Google-Smtp-Source: ADFU+vucW6te80eivq0ZUfTKnqSxSc1+eL3rS9tLJ0yst4sgacQvScGP8hbBJX3hkuA0Xv/JiphAaGlq1hTtVpSHdco=
X-Received: by 2002:a05:6638:a99:: with SMTP id 25mr5874582jas.37.1585188137103;
 Wed, 25 Mar 2020 19:02:17 -0700 (PDT)
MIME-Version: 1.0
References: <1585164614-123696-1-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1585164614-123696-1-git-send-email-longli@linuxonhyperv.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 26 Mar 2020 12:02:05 +1000
Message-ID: <CAN05THTH8-pK9uw77COWSUQ_knztT1o1Ms0b=2PPvmBJd=ovUw@mail.gmail.com>
Subject: Re: [PATCH] cifs: smbd: Calculate the correct maximum packet size for
 segmented SMBDirect send/receive
To:     Long Li <longli@microsoft.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>, longli@linuxonhyperv.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Long Li,

Mostly looks good  but the magic constant 49 I think is wrong.
49 is the structure size of the read/write request header
but for these sizes, if they are odd it just means that the header contain a
variable sized blob.
I.e. the size is 48 bytes (for the fixed part of the header) + a variable part
which in this case are the ChannelInfo blobs.

So we should probably add to smb2pdu.h a
#define MAX_SMB2_READWRITE_RESPONSE_SIZE 48
and use this in the calculations. Then we need to add the maximum size
we will use for ChannelInfo.

Maybe we should have a define also for the MAX_SMB2_CHANNEL_INFO_SIZE

regards
ronnie sahlberg

On Thu, Mar 26, 2020 at 5:31 AM longli--- via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> From: Long Li <longli@microsoft.com>
>
> The packet size needs to take account of SMB2 header size and possible
> encryption header size. This is only done when signing is used and it is for
> RDMA send/receive, not read/write.
>
> Also remove the dead SMBD code in smb2_negotiate_r(w)size.
>
> Signed-off-by: Long Li <longli@microsoft.com>
> ---
>  fs/cifs/smb2ops.c   | 38 ++++++++++++++++----------------------
>  fs/cifs/smbdirect.c |  3 +--
>  2 files changed, 17 insertions(+), 24 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 4c0922596467..9043d34eef43 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -332,16 +332,6 @@ smb2_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>         /* start with specified wsize, or default */
>         wsize = volume_info->wsize ? volume_info->wsize : CIFS_DEFAULT_IOSIZE;
>         wsize = min_t(unsigned int, wsize, server->max_write);
> -#ifdef CONFIG_CIFS_SMB_DIRECT
> -       if (server->rdma) {
> -               if (server->sign)
> -                       wsize = min_t(unsigned int,
> -                               wsize, server->smbd_conn->max_fragmented_send_size);
> -               else
> -                       wsize = min_t(unsigned int,
> -                               wsize, server->smbd_conn->max_readwrite_size);
> -       }
> -#endif
>         if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
>                 wsize = min_t(unsigned int, wsize, SMB2_MAX_BUFFER_SIZE);
>
> @@ -360,8 +350,15 @@ smb3_negotiate_wsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>         if (server->rdma) {
>                 if (server->sign)
> +                       /*
> +                        * Account for SMB2 data transfer packet header
> +                        * SMB2_READ/SMB2_WRITE (49) and possible encryption
> +                        * headers
> +                        */
>                         wsize = min_t(unsigned int,
> -                               wsize, server->smbd_conn->max_fragmented_send_size);
> +                               wsize,
> +                               server->smbd_conn->max_fragmented_send_size -
> +                                       49 - sizeof(struct smb2_transform_hdr));
>                 else
>                         wsize = min_t(unsigned int,
>                                 wsize, server->smbd_conn->max_readwrite_size);
> @@ -382,16 +379,6 @@ smb2_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>         /* start with specified rsize, or default */
>         rsize = volume_info->rsize ? volume_info->rsize : CIFS_DEFAULT_IOSIZE;
>         rsize = min_t(unsigned int, rsize, server->max_read);
> -#ifdef CONFIG_CIFS_SMB_DIRECT
> -       if (server->rdma) {
> -               if (server->sign)
> -                       rsize = min_t(unsigned int,
> -                               rsize, server->smbd_conn->max_fragmented_recv_size);
> -               else
> -                       rsize = min_t(unsigned int,
> -                               rsize, server->smbd_conn->max_readwrite_size);
> -       }
> -#endif
>
>         if (!(server->capabilities & SMB2_GLOBAL_CAP_LARGE_MTU))
>                 rsize = min_t(unsigned int, rsize, SMB2_MAX_BUFFER_SIZE);
> @@ -411,8 +398,15 @@ smb3_negotiate_rsize(struct cifs_tcon *tcon, struct smb_vol *volume_info)
>  #ifdef CONFIG_CIFS_SMB_DIRECT
>         if (server->rdma) {
>                 if (server->sign)
> +                       /*
> +                        * Account for SMB2 data transfer packet header
> +                        * SMB2_READ/SMB2_WRITE (49) and possible encryption
> +                        * headers
> +                        */
>                         rsize = min_t(unsigned int,
> -                               rsize, server->smbd_conn->max_fragmented_recv_size);
> +                               rsize,
> +                               server->smbd_conn->max_fragmented_recv_size -
> +                                       49 - sizeof(struct smb2_transform_hdr));
>                 else
>                         rsize = min_t(unsigned int,
>                                 rsize, server->smbd_conn->max_readwrite_size);
> diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
> index eb1e40af9f3a..0327b575ab87 100644
> --- a/fs/cifs/smbdirect.c
> +++ b/fs/cifs/smbdirect.c
> @@ -2097,8 +2097,7 @@ int smbd_send(struct TCP_Server_Info *server,
>         for (i = 0; i < num_rqst; i++)
>                 remaining_data_length += smb_rqst_len(server, &rqst_array[i]);
>
> -       if (remaining_data_length + sizeof(struct smbd_data_transfer) >
> -               info->max_fragmented_send_size) {
> +       if (remaining_data_length > info->max_fragmented_send_size) {
>                 log_write(ERR, "payload size %d > max size %d\n",
>                         remaining_data_length, info->max_fragmented_send_size);
>                 rc = -EINVAL;
> --
> 2.17.1
>
>
