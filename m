Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46738C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Feb 2022 07:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiBLHwe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Feb 2022 02:52:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiBLHwe (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Feb 2022 02:52:34 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8826A26AF3
        for <linux-cifs@vger.kernel.org>; Fri, 11 Feb 2022 23:52:31 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id o2so20753547lfd.1
        for <linux-cifs@vger.kernel.org>; Fri, 11 Feb 2022 23:52:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EtqQUFUBmGkylS3hlVh86QkM1tVRWP5CJsgy3wbLLcE=;
        b=LBrNR/f20ZnFI28hTONN/qCwQKezgmHzzsS02ln35dnb8cB2updp6WrWPmjJskQv+D
         xQ/yCM6JFprXepEQVL37KypD9hzshH/IpFxEfRFX0cCkiu4CIXddLAmkC4R793uF3KdS
         bHWsxhMv38MNm0W83nYKHNsBfQQ8//gfSS6uKxNonan9Mn4EJw2PUF0lfVWvNryaEWk6
         nXz3Ul9+cPoL8IFgGggK2cxFyo13OOIId15uijty/vbisjVSnkJ1fxygtvECizYNzl+g
         Op6+GiRLlOuUwvF2Z7gVMsMz+52MTfFs6Jl10p76p9f2oSQ+KZXDCq0WJjRlISsRj/b9
         ZzFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EtqQUFUBmGkylS3hlVh86QkM1tVRWP5CJsgy3wbLLcE=;
        b=yuEnSI6/KNUTspwKVHXP19mGwYyt6Mf+kXqUVGrAN7aT1oU2T+OiObkYg111NnAkN/
         ol9aV4ozKpzxVaCm8IIZ0PpaZRGFNcehsFfOlZJND3394L9pPB1UsLZv8FzuBDX3YazL
         duHnlZo7w9mXtoBs3w1Ry007b7cLJs6HhnHa8P8WnIvqlJLWhkfMqG340kK/FE4qMZa/
         1XJvLRZf5qmD0O75lYQ1tBzcIiy6fNEenygzEUcvZnqIbwdh91dIUlKQl4UUpfx+18VP
         MPgZBtnTWNnJDNNeDW+0fecs8gzRu1Tv/OoiyyE8CP4eHDYzDg4WhAex8cW66/U4Qu4c
         K6EQ==
X-Gm-Message-State: AOAM5320U4ss6XQOxr4J83O99x9SFI1PgrBBdygJsIDb7qUuUeeWX3ub
        2Y1AvrOl9JPAGWxiIQybIOKdO5y8FbTopNs2M2Ac8G/e
X-Google-Smtp-Source: ABdhPJwwCeiSde/+JvwhhdO3T3k8wb+GbCKYPn4/GndtHpBXwhVaVf7CliGUVkLzFaYYbkttVOlD2358oxH5Twqocqw=
X-Received: by 2002:a05:6512:3e14:: with SMTP id i20mr3832135lfv.601.1644652349759;
 Fri, 11 Feb 2022 23:52:29 -0800 (PST)
MIME-Version: 1.0
References: <20220103145025.3867146-1-amir73il@gmail.com>
In-Reply-To: <20220103145025.3867146-1-amir73il@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 12 Feb 2022 01:52:18 -0600
Message-ID: <CAH2r5mv0igJuX43v-rCN1RVnrsTRqPtJkt5J_JEepSfdxb+wNw@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix set of group SID via NTSD xattrs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Boris Protopopov <pboris@amazon.com>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing

If you have ideas on how to add a test case for this, that would be
helpful (we have some cifs.ko specific tests we run in addition to the
usual xfstests and git filesystem regression tests).

On Mon, Jan 3, 2022 at 8:50 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> 'setcifsacl -g <SID>' silently fails to set the group SID on server.
>
> Actually, the bug existed since commit 438471b67963 ("CIFS: Add support
> for setting owner info, dos attributes, and create time"), but this fix
> will not apply cleanly to kernel versions <= v5.10.
>
> Fixes: a9352ee926eb ("SMB3: Add support for getting and setting SACLs")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Boris,
>
> I am a little confused from the comments in the code an emails.
> In this thread [1] you wrote that you tested "setting/getting the owner,
> DACL, and SACL...".
>
> Does it mean that you did not test setting group SID?
>
> It is also confusing that comments in the code says /* owner plus DACL */
> and /* owner/DACL/SACL */.
> Does it mean that setting group SID is not supposed to be supported?
> Or was this just an oversight?
>
> Anyway, with this patch, setcifsacl -g <SID> works as expected,
> at least when the server is samba.
>
> Thanks,
> Amir.
>
>
> [1] https://lore.kernel.org/linux-cifs/CAHhKpQ7PwgDysS3nUAA0ALLdMZqnzG6q6wL1tmn3aqOPwZbyyg@mail.gmail.com/
>
>  fs/cifs/xattr.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/xattr.c b/fs/cifs/xattr.c
> index 7d8b72d67c80..9d486fbbfbbd 100644
> --- a/fs/cifs/xattr.c
> +++ b/fs/cifs/xattr.c
> @@ -175,11 +175,13 @@ static int cifs_xattr_set(const struct xattr_handler *handler,
>                                 switch (handler->flags) {
>                                 case XATTR_CIFS_NTSD_FULL:
>                                         aclflags = (CIFS_ACL_OWNER |
> +                                                   CIFS_ACL_GROUP |
>                                                     CIFS_ACL_DACL |
>                                                     CIFS_ACL_SACL);
>                                         break;
>                                 case XATTR_CIFS_NTSD:
>                                         aclflags = (CIFS_ACL_OWNER |
> +                                                   CIFS_ACL_GROUP |
>                                                     CIFS_ACL_DACL);
>                                         break;
>                                 case XATTR_CIFS_ACL:
> --
> 2.25.1
>


-- 
Thanks,

Steve
