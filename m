Return-Path: <SRS0=Y4Lp=XS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080FFC3A5A6
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 07:17:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0D7320820
	for <linux-cifs@archiver.kernel.org>; Mon, 23 Sep 2019 07:17:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZIOiXqV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729407AbfIWHR4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 23 Sep 2019 03:17:56 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:32891 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729404AbfIWHR4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 23 Sep 2019 03:17:56 -0400
Received: by mail-io1-f67.google.com with SMTP id z19so8780788ior.0
        for <linux-cifs@vger.kernel.org>; Mon, 23 Sep 2019 00:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nRCOehiJyxp5LkMehJDFdAdALW4Jsp7O0esmUHa0Xn8=;
        b=IZIOiXqVsvPXd8qVhGUHFnOsRVIG0Ui0AEgpqhw+B2wUpFnvjG5KoBsPSMqX8FXMpv
         /PJYFhcMIXqCSnxqVq76fkYXsddibQs+1UUtj+4lbpAXtcjGnxfOWE6abJE8sdi3RvIY
         LzIWp0Xdij7pRqftUtZRRDzlA2VHVD7dYIrOTReBQmc4Tft6nzDPTycHUf0pRjYS3jNE
         u1J5H4ohBZI8cquv8roIsmM8US/MxW8Kjrt4EbmR0WPfaHw1jhIZ5oEoMcXgeAY/lnXZ
         LxhaUi8ifqHfN77GUkUpN6uHltzAoglyNXN4xRarB2xhNZa3S6eSJExL/NVnAARHWHpZ
         tqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nRCOehiJyxp5LkMehJDFdAdALW4Jsp7O0esmUHa0Xn8=;
        b=WuvCqd/F7fR9kkO15QwnosCEAlB3cKyZT0fYpeTCi4u67HbzJ+Qds1FQKZkM/hmXRX
         NqLLoiJSvCtkjQY+LnXmVSw2fjjniBI8D9goqsSnyQLrsUk2JfBOHTTWNzOs5tk+zHlU
         Gs/Yr4IWCtCQ8Bmls6BLwjVw701Tf6/nJUhutg7N3N5EHSHv/ZzxHT/R8OgDUzw31Jwt
         233/W+HN1hHXFYGm7Q2ecSpv4i/NpPmI9GpLewMYyeTbblB47RmzIkcBvDEtfFfHPM/r
         ld8wuP5Dg7qsqkG4FE50xqyBTMXCbpyChYTmV0rTe0otRRHlrZF3KXx9mYgcHnsWWglT
         zgmQ==
X-Gm-Message-State: APjAAAV0WU+qm8WdX9sradO+VuTl45qMKJ/fxX/6HVRAh0BK9ALiRSGO
        ALB5+KwoI9L/b4naQ9jHWb+iJ+K6vNv3Hs+Czas=
X-Google-Smtp-Source: APXvYqzh8gughOVneGrjUq81JgHWSFg3RUDjb5IWHN6XaU1rpzDJ2J6HlnGbT4ysl3XjPJUpEY8UXVOgxvqEzv8NPqg=
X-Received: by 2002:a6b:a0d:: with SMTP id z13mr32318260ioi.5.1569223075390;
 Mon, 23 Sep 2019 00:17:55 -0700 (PDT)
MIME-Version: 1.0
References: <1569222378-22693-1-git-send-email-zhengbin13@huawei.com>
In-Reply-To: <1569222378-22693-1-git-send-email-zhengbin13@huawei.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 23 Sep 2019 02:17:44 -0500
Message-ID: <CAH2r5mvpjuALAxaxAzjqb_TU3Sm3CNuV4g3qVeWdyNK_8kJzSw@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/smb2pdu.c: Make SMB2_notify_init static
To:     zhengbin <zhengbin13@huawei.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Mon, Sep 23, 2019 at 1:59 AM zhengbin <zhengbin13@huawei.com> wrote:
>
> Fix sparse warnings:
>
> fs/cifs/smb2pdu.c:3200:1: warning: symbol 'SMB2_notify_init' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  fs/cifs/smb2pdu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 8bcb278..5e87872 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -3200,7 +3200,7 @@ SMB2_get_srv_num(const unsigned int xid, struct cifs_tcon *tcon,
>   * See MS-SMB2 2.2.35 and 2.2.36
>   */
>
> -int
> +static int
>  SMB2_notify_init(const unsigned int xid, struct smb_rqst *rqst,
>                 struct cifs_tcon *tcon, u64 persistent_fid, u64 volatile_fid,
>                 u32 completion_filter, bool watch_tree)
> --
> 2.7.4
>


-- 
Thanks,

Steve
