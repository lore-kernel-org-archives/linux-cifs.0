Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B247C05027
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Feb 2023 23:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBIXsQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Feb 2023 18:48:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjBIXsQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Feb 2023 18:48:16 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E263803C
        for <linux-cifs@vger.kernel.org>; Thu,  9 Feb 2023 15:48:14 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id br9so5638950lfb.4
        for <linux-cifs@vger.kernel.org>; Thu, 09 Feb 2023 15:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=iK+fy5OrQ8oSN04ZMh8oXW6YQ5N6Js4T4HPGX2BFQ4s=;
        b=EAX2VTINZGKufLCVwnfy2C++gErlo586skDfnAahXOmgzQm0qL+YcsiK3t3klTpbGj
         3XA32qbBjzZaIN/Vv45n1ceZKZPX1rR0lNjcyR7Nwhu1onbkOLXWGPKZBa1FNjwIu9SJ
         DPdrlIYLDM03kdnmsMATi6jmKq8daok7na1zxguofIYOKsyQsbxomvbUZFWqzfHg2aZq
         6aevlbh2CkWcJ7cm86O/gR1IawMN4MdCOGWOKdiwdTVf8T27LdTd1MGbl1TE+UM0JdFH
         1sy+qtl9UBA7Na9u2J7cOF4IapXZ7TxP39Jig0Cd6C9HL9Ir9t5XIXyRwt8rcuLGgpZM
         1Khg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iK+fy5OrQ8oSN04ZMh8oXW6YQ5N6Js4T4HPGX2BFQ4s=;
        b=ecxtQ8MGuxFnKeKSZsjL856Af5YAuuVRyMYdOtnQFQEYPZfYr76facz3fEi42hJmdt
         1w8SjWVoVC5cFQt1lzLavsYfk2irfUsRHB9hTCRENL1U3lwvJrB67QCE+CR6kE/8VL9o
         Q1FBw9LS4ukwWmj9ScoPuDIXF4iTK3N0azRytfiPwiKLSPK6kAYpf/uXitwf91h2mZr0
         pCDXzc20xgLPi0xbATuLElrrniaO+y1qkUEnlHFPCnzyBJT6Bu9D/wC6rUHpDfWrwSvN
         PgaE9UbVAhmuX5w1aaCshEULqq5oBI8ewxkVldcvWjracJNKN58d6DjCCIR5msC/9Jnc
         QK3A==
X-Gm-Message-State: AO0yUKUUH56h6JMVLcPOLTowIFpactwlCzrz9J5YB8KbZ12C+Ze03Map
        rKGsMK4rTP7bwS5Eo20DNGGDfKsLpMJxb9qxe78=
X-Google-Smtp-Source: AK7set/jFtKWGLaaAHpzbCi0Fl23Y7lKKYyJvxmf4M1p1jwuikY03hmlWB+Keq0MKEpKX8Dku7iOvpiFPi5RWXwl42Q=
X-Received: by 2002:ac2:4a66:0:b0:4db:dd7:dee2 with SMTP id
 q6-20020ac24a66000000b004db0dd7dee2mr1755927lfp.16.1675986492915; Thu, 09 Feb
 2023 15:48:12 -0800 (PST)
MIME-Version: 1.0
References: <20230208094104.10766-1-linkinjeon@kernel.org>
In-Reply-To: <20230208094104.10766-1-linkinjeon@kernel.org>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 9 Feb 2023 17:48:01 -0600
Message-ID: <CAH2r5muCPMELUij-9RLcBqsYqbkcnOYi=F-JN8Oc3c3azUW0uw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: do not allow the actual frame length to be
 smaller than the rfc10024 length
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

typically rounding up to 8 byte boundary would be logical to allow

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
