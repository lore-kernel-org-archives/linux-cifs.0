Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02CC0C433ED
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 19:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF17761154
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Apr 2021 19:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353479AbhDNTtu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Apr 2021 15:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238322AbhDNTtr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Apr 2021 15:49:47 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57470C061574
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 12:49:23 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id 12so35040624lfq.13
        for <linux-cifs@vger.kernel.org>; Wed, 14 Apr 2021 12:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/07iwVmXaO2Dy+qpIaY4DriaU6jogq8HJ2l3BLn9OOA=;
        b=p7xUF4XDJOilF/KUNLjO7Vaf2PFaw5lGEHSl5k/XVpVi89zALDHz0D+UQGQguuGheo
         FkuoG3YUWhss2m186e+hFsqgeNto3otcydprisTidD0O/lrzuNdT6PJ+s5MGjI1SV7+Y
         Lb44sX5ApkxUCcxvlD9Tw8C3oMd9pRUMN2DormqW40Crr9ZKkWP/3130kzShUrHcBB3n
         0+cRCwtijCHyaFnfv8wbGLVrG3GhORE59ODQB774ZlysMMnbLcBU+SHn/9sK0Uby/A2+
         SGfRe/QE/dAARkWiVmN1oZT3xQxLuyGEnVngWAW9VcIKJX3wjwNU9Maor0wAgFm6Frhq
         Xzsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/07iwVmXaO2Dy+qpIaY4DriaU6jogq8HJ2l3BLn9OOA=;
        b=a1w/7c65b5Yt/XwP3baKO4qqz7DJKIgvSQcn7fj60wPGWAyjUGX7Vne0DYbvE3Yvee
         8dJxfMoRmqCaS8aJpfyXJXxBk2Od3w0fcrOejkg7iwwUW/L6auGLvEpE+qFi/4ToiyZB
         0rc7HGWp2UR+tvZt8+OZTpK2utUPxQblC0zFErCsY0ubd2zPi+i8Wn681n61PQazYU8v
         g6s6rHR1eA9Gr38HxNbtYzSZr/U1t3rs67pOYUH1LLaccO50MDMUg/GGpMGd+3Cf+L9r
         7ZnHN/8kZsz4P9tlC8+h0fW+fw/oGrazpryXX/OJK6gY/xui/UORxdyjx74cjaJTZrLl
         NsUA==
X-Gm-Message-State: AOAM533zj5kD2B944EmfkZ9Q3544sYNoRu03lld2RcXMO95GBb4V4sUz
        QD4+gay9cDX4JnByYnQ4lg+cKUKSakyJySsP3p3cYiXE
X-Google-Smtp-Source: ABdhPJzUvMG5YagNoxifdBAJILMzYZKuLPvJtEq85H13lWQRiicH7D7ikR8OraNw7TzrZguEc5QBW5m55ax90qL0HdM=
X-Received: by 2002:a19:6558:: with SMTP id c24mr3943894lfj.313.1618429761815;
 Wed, 14 Apr 2021 12:49:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210413212527.473765-1-paul@darkrain42.org>
In-Reply-To: <20210413212527.473765-1-paul@darkrain42.org>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 14 Apr 2021 14:49:10 -0500
Message-ID: <CAH2r5mtg3Yw7=3E_JExhaG=x3qZLsXJvG8L+ynkwprfLrYiPLA@mail.gmail.com>
Subject: Re: [PATCH] cifs: Return correct error code from smb2_get_enc_key
To:     Paul Aurich <paul@darkrain42.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending more reviews
from Pavel etc and testing

On Wed, Apr 14, 2021 at 1:56 AM Paul Aurich <paul@darkrain42.org> wrote:
>
> Avoid a warning if the error percolates back up:
>
> [440700.376476] CIFS VFS: \\otters.example.com crypt_message: Could not get encryption key
> [440700.386947] ------------[ cut here ]------------
> [440700.386948] err = 1
> [440700.386977] WARNING: CPU: 11 PID: 2733 at /build/linux-hwe-5.4-p6lk6L/linux-hwe-5.4-5.4.0/lib/errseq.c:74 errseq_set+0x5c/0x70
> ...
> [440700.397304] CPU: 11 PID: 2733 Comm: tar Tainted: G           OE     5.4.0-70-generic #78~18.04.1-Ubuntu
> ...
> [440700.397334] Call Trace:
> [440700.397346]  __filemap_set_wb_err+0x1a/0x70
> [440700.397419]  cifs_writepages+0x9c7/0xb30 [cifs]
> [440700.397426]  do_writepages+0x4b/0xe0
> [440700.397444]  __filemap_fdatawrite_range+0xcb/0x100
> [440700.397455]  filemap_write_and_wait+0x42/0xa0
> [440700.397486]  cifs_setattr+0x68b/0xf30 [cifs]
> [440700.397493]  notify_change+0x358/0x4a0
> [440700.397500]  utimes_common+0xe9/0x1c0
> [440700.397510]  do_utimes+0xc5/0x150
> [440700.397520]  __x64_sys_utimensat+0x88/0xd0
>
> Fixes: 61cfac6f267d ("CIFS: Fix possible use after free in demultiplex thread")
> Signed-off-by: Paul Aurich <paul@darkrain42.org>
> CC: stable@vger.kernel.org
> ---
>  fs/cifs/smb2ops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 61214b23c57f..caa5432a5ed1 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -4418,7 +4418,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
>         }
>         spin_unlock(&cifs_tcp_ses_lock);
>
> -       return 1;
> +       return -ENOENT;
>  }
>  /*
>   * Encrypt or decrypt @rqst message. @rqst[0] has the following format:
> --
> 2.31.0
>


-- 
Thanks,

Steve
