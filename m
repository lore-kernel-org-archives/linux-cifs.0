Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF55C4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Aug 2021 03:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 123A76187A
	for <linux-cifs@archiver.kernel.org>; Mon, 16 Aug 2021 03:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhHPDjM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 15 Aug 2021 23:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhHPDjM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 15 Aug 2021 23:39:12 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB79C061764
        for <linux-cifs@vger.kernel.org>; Sun, 15 Aug 2021 20:38:41 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id n7so25225223ljq.0
        for <linux-cifs@vger.kernel.org>; Sun, 15 Aug 2021 20:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sAlDGKUOkBt7kw1d48yp5dUTEoQ6mh5htJwaIx0lquk=;
        b=g7SeOWeySPpyl159k4zz7NWcPOhkSsYMx0s46AJrj+oc1u4Qf3aiEo2F8w5Wwxqbpf
         LEPxV2OHbGwwmiNvhtb9wzY4w1liq1XVXjHqdsVcquV0+FR+62+vf6g7vo4YggUzqRK0
         PuNJFCxtYdpNxBbwTKGu/DA3jPZuj8c5XU4TQb1OreyWEt+JRjdMLgzUM4VpmvBtE0rh
         KSvXtnrr3+O6C1YHGqD8xAGVcCYPdyWgW/ztXiPgMb4P/pmXhNNoKKgjWHnVXRHBCppn
         epOkkA0uXQh0OuwgH7QocMdMdsXDIIaczsCmrsckmih++T3m833KBjVHT20mHeK3NPiJ
         D66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sAlDGKUOkBt7kw1d48yp5dUTEoQ6mh5htJwaIx0lquk=;
        b=FxmsvQrgyBnyoebXR7J3iq8fDCWTxttHZLrJi0x2/hKqIv4T6//QS6COOpm0/crRl6
         RvMMC3VihfTgclIS/0IAS8MWhykkWmZhcy+yHWQF08p0eYVbjD7qvSJkJd9GC2K++w07
         M3R9IrKhR/3lIgEs0pdRWOOmey1va60XiZY6fUsrZVEPTIpJXMgl/BcgKAFPRqiRLZS6
         jGDZZXr3BvD/qjKly/xNu283gCZmovo6A7etY9M9B2OTtPCV5PVXavREHYsFrzDUWE2a
         BAxMKQUmHM2SfrzITABJXJdCrI49XBF3CXc/G0rrFhT9Hb/rjHErkxAP2SmUqG1dWeZc
         In0A==
X-Gm-Message-State: AOAM5333tR3HUtKOCsCPNymR83rWEJpmfbz8g7rMS8d6CoukYMYApn9Y
        Uvm/ZJVcrxuoXIdtQCtoXYmiGpLIFAMo4RFLKzU=
X-Google-Smtp-Source: ABdhPJzmXZUrCUoChr7QrVyT2MG+UoC7uAp25g2xkGWAld8HCfNhRlJcoyeWCKmniZwZtCXAAhwK9BzAPR3SRctpPN0=
X-Received: by 2002:a2e:4e19:: with SMTP id c25mr10622420ljb.148.1629085119778;
 Sun, 15 Aug 2021 20:38:39 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=r5tE5VkQBG62K94fATeW4uGW7Q6_KcHj+5HsiKWoAD8g@mail.gmail.com>
In-Reply-To: <CANT5p=r5tE5VkQBG62K94fATeW4uGW7Q6_KcHj+5HsiKWoAD8g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 15 Aug 2021 22:38:29 -0500
Message-ID: <CAH2r5muLbLWExEwmwT29KKQ=25kpm-qFnLLb8MqdQxRFPf79gA@mail.gmail.com>
Subject: Re: [PATCH] cifs: enable fscache usage even for files opened as rw
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     David Howells <dhowells@redhat.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thoughts about the checkpatch warnings?

$ scripts/checkpatch.pl
~/Downloads/096eaae1544b9bc2b1df48613027bd46c629d406.patch
WARNING: Avoid crashing the kernel - try using WARN_ON & recovery code
rather than BUG() or BUG_ON()
#156: FILE: fs/cifs/fscache.c:318:
+ BUG_ON(!cifsi->fscache);

WARNING: function definition argument 'struct inode *' should also
have an identifier name
#191: FILE: fs/cifs/fscache.h:58:
+extern void cifs_fscache_update_inode_cookie(struct inode *);

WARNING: function definition argument 'struct inode *' should also
have an identifier name
#196: FILE: fs/cifs/fscache.h:63:
+extern void __cifs_fscache_wait_on_page_write(struct inode *, struct page *);

WARNING: function definition argument 'struct page *' should also have
an identifier name
#196: FILE: fs/cifs/fscache.h:63:
+extern void __cifs_fscache_wait_on_page_write(struct inode *, struct page *);

On Tue, Aug 10, 2021 at 5:44 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> Hi Steve,
>
> The following patch enables fscache even for scenarios where files are
> opened in rw mode. Our current implementation only enables fscache
> when the file is opened O_RDONLY.
>
> https://github.com/sprasad-microsoft/smb3-kernel-client/pull/5
>
> Note that this patch can safely be backported. It still does not use
> netfs helper library.
> I'll be sending another patch with the netfs helper integration soon.
>
> --
> Regards,
> Shyam



-- 
Thanks,

Steve
