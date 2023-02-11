Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53C0CC636CC
	for <linux-cifs@archiver.kernel.org>; Sat, 11 Feb 2023 20:53:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjBKUxe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 11 Feb 2023 15:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbjBKUxd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 11 Feb 2023 15:53:33 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608BA126F4
        for <linux-cifs@vger.kernel.org>; Sat, 11 Feb 2023 12:53:32 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id b16so10385877ljr.11
        for <linux-cifs@vger.kernel.org>; Sat, 11 Feb 2023 12:53:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RhNedfXoa7TMpHqr1ftYMA5XbCW5iKtdmWatW7OPCOU=;
        b=QW/2g+b5GngXx4HWt12DgP2ND0Ql1t1zd0HdDMd5uF4HUEGXcFMHyLHXFZSPUv2gvt
         KMLYPi4zs6Y5XnhCo4WwznsoB/FBSosAw4IvFcZrJcCuutiLxr2sZs0sLVKeMIO02rjs
         VGS7P3o1wD7ssuFSeMbxaeInL8DJ/F3DePC0lBcWSC+R1FVINhJYcqB1maylzKEyHEq9
         TM4ktfs+h6pumo734bznBatwSiwAqM8v+7yub4tPFUmu1VctSggr3QA/f9/Oj4EsPp1B
         Tn3Z13tA/UHBI2CmHOWRd+wimmonRFTL/cAC2mzV1EwwAI4r2RoiCgyOsTSuy0LGufMJ
         3aXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RhNedfXoa7TMpHqr1ftYMA5XbCW5iKtdmWatW7OPCOU=;
        b=QQOf7mJJsyomgT/rfEMgU/O23gh+41IpiVs/wgbTLLPA1CQf5jVy7NJq7lvMEviwGG
         mn/AIA0ezYPQ6Tna6L59qhLekJ1SUcvLw5x9VILJm+ZvU807Ws/zLHU5mGh4ml4z8I+/
         uMC3oVOkgouVBJONTwX6sjX2I3o9y+3MmI8enhl4iclI0VtdYjMNTq5PITtTwsrVCwQa
         HBkmXNZXXXiwMkct2FHv7pmkhAVBpxhedo+ky6fVpQaB5GR/sIBeInICpYoPfpPOAUka
         s2/73uvSOBHB5jemlGxNhBZfbIuw8ZFYJ5ZwRnEVem6dXrAk8egLtZ13veISDKYwDqJb
         uCNg==
X-Gm-Message-State: AO0yUKUR2aurDoMQIq8px28fIscpHJXIATnr1HYxOVCfHMJXxG+UtGGa
        NnDZ/SRTS6IGOVm+tIwIMm8h7u57Nm7Vc+Nrf7S3O84w
X-Google-Smtp-Source: AK7set/DQKYpD9Zm4z23TG3S6fPCG62h1pjuFvk3LkF8dIIOnKrB5SUk7aO4+Bc87XZr/j+Sn/tMGjn0LO/5LGs1B74=
X-Received: by 2002:a2e:9d50:0:b0:290:5102:a7f8 with SMTP id
 y16-20020a2e9d50000000b002905102a7f8mr3021780ljj.63.1676148810437; Sat, 11
 Feb 2023 12:53:30 -0800 (PST)
MIME-Version: 1.0
References: <20230208094104.10766-1-linkinjeon@kernel.org>
In-Reply-To: <20230208094104.10766-1-linkinjeon@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 11 Feb 2023 14:53:18 -0600
Message-ID: <CAH2r5mvGspRdByLkuC79oHfNkirKj2hEFSODDHKvXtQkV9KdEQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: do not allow the actual frame length to be
 smaller than the rfc10024 length
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Did you see any examples other than (SMB3) tree connect where the
Linux client padded a request beyond end of SMB/SMB3 frame?

On Wed, Feb 8, 2023 at 3:41 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> ksmbd allowed the actual frame length to be smaller than the rfc1002
> length. If allowed, it is possible to allocates a large amount of memory
> that can be limited by credit management and can eventually cause memory
> exhaustion problem. This patch do not allow it except SMB2 Negotiate
> request which will be validated when message handling proceeds.
> Also, cifs client pad smb2 tree connect to 2bytes.
>
> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ksmbd/smb2misc.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> index a717aa9b4af8..fc44f08b5939 100644
> --- a/fs/ksmbd/smb2misc.c
> +++ b/fs/ksmbd/smb2misc.c
> @@ -408,20 +408,19 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
>                         goto validate_credit;
>
>                 /*
> -                * windows client also pad up to 8 bytes when compounding.
> -                * If pad is longer than eight bytes, log the server behavior
> -                * (once), since may indicate a problem but allow it and
> -                * continue since the frame is parseable.
> +                * SMB2 NEGOTIATE request will be validated when message
> +                * handling proceeds.
>                  */
> -               if (clc_len < len) {
> -                       ksmbd_debug(SMB,
> -                                   "cli req padded more than expected. Length %d not %d for cmd:%d mid:%llu\n",
> -                                   len, clc_len, command,
> -                                   le64_to_cpu(hdr->MessageId));
> -                       goto validate_credit;
> -               }
> +               if (command == SMB2_NEGOTIATE_HE)
> +                       goto validate_credit;
> +
> +               /*
> +                * cifs client pads smb2 tree connect to 2 bytes.
> +                */
> +               if (clc_len + 2 == len)
> +                       goto validate_credit;
>
> -               ksmbd_debug(SMB,
> +               pr_err_ratelimited(
>                             "cli req too short, len %d not %d. cmd:%d mid:%llu\n",
>                             len, clc_len, command,
>                             le64_to_cpu(hdr->MessageId));
> --
> 2.25.1
>


-- 
Thanks,

Steve
