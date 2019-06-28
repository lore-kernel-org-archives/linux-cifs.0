Return-Path: <SRS0=z2/z=U3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 721BFC5B57A
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jun 2019 16:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A7512083B
	for <linux-cifs@archiver.kernel.org>; Fri, 28 Jun 2019 16:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Os4G7GAg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfF1QZ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 28 Jun 2019 12:25:27 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:40892 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF1QZ1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 28 Jun 2019 12:25:27 -0400
Received: by mail-pg1-f172.google.com with SMTP id w10so2805183pgj.7;
        Fri, 28 Jun 2019 09:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8gelbe0rDKFW5SrnVIvFcvxuQDN13GjuwxH8iO0F4i8=;
        b=Os4G7GAgNaQ9lrS/VwRpy/HVYwIl6oNdCwOnn4sWOERKoDF6vTvvagy3U46G6Cm89l
         KfRoDBcee/Pj8J9dtVKSODer6A3i0JIuP8y9JHhF6ELtWcVqvhTT6o5uwCugL1svWQj0
         VI+dXu8CTzcaFaawl9hGjUZfEHCN6h/1RQZ1PHSg8Byu2IVwgLnYSVNsn5Y7fDfbbQ/z
         sfUXoM02268hjL9AckHPrYI5IJVOoyEgJvx4W7vOoacerEoyeD+gqDrangHmQMsNc3T9
         uMMpwqpiiy86Zo1wCT1qZZCNQEjhfR61sT4HoElXA3dIdPCAQKsQv24RFd88sGCxQhAD
         OZiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8gelbe0rDKFW5SrnVIvFcvxuQDN13GjuwxH8iO0F4i8=;
        b=m05oVXVhmDL0Nb9QZ946fZ4K7j3AuAppDncD4X4yjml7dG7E/KhIEdiGBy1yx3wFnw
         mwtHgVHwFqUdrBvDQKrxkYY5vsC2e01bLb7URukZkxueNO8mGuBw8NmNGzB1b0FCL1qh
         f4BAPtkHe+l2cB9ObKu3mmqmVas+B3Josd3N5wIZgSOJtrF6+vYZcIZT9V6mCYeHuZHk
         SWNpF2jqG8C1Rv8aIEe4yZptM06X7sfvrXdvV8EOctWBe/FJfYKMuGJQ2bVRfF1TeXsD
         9W9bOF5Wp2aJx0o+6Ndm4C1G5Mceg91kRMfCDsgSvRM9OyvJMmfvBJ92hQdh8ihzmRy7
         irSw==
X-Gm-Message-State: APjAAAUYTT05P5/cgc+GplbPDUYLC8KugVIXfGuWHI7PUPfaBzZll3ie
        849vLSVYUs63HBErnB+mtdk=
X-Google-Smtp-Source: APXvYqz8dz7b353W91b92kYWAEOwF6Yvg6V2g2WpHn/cK4+o+qzIjvd4bJsrpjJkD/nOD89LZGyVlg==
X-Received: by 2002:a63:d0:: with SMTP id 199mr10123914pga.85.1561739126719;
        Fri, 28 Jun 2019 09:25:26 -0700 (PDT)
Received: from ldmartin-desk1 (jfdmzpr04-ext.jf.intel.com. [134.134.139.73])
        by smtp.gmail.com with ESMTPSA id i14sm4491419pfk.0.2019.06.28.09.25.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 09:25:25 -0700 (PDT)
From:   Lucas De Marchi <lucas.de.marchi@gmail.com>
X-Google-Original-From: Lucas De Marchi <lucas.demarchi@gmail.com>
Date:   Fri, 28 Jun 2019 09:25:17 -0700
To:     Harald Hoyer <harald@redhat.com>
Cc:     linux-modules@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Pavel Shilovsky <pshilov@microsoft.com>,
        linux-cifs@vger.kernel.org
Subject: Re: multiple softdeps
Message-ID: <20190628162517.GA24484@ldmartin-desk1>
References: <0bfb6f60-0042-f6be-24ed-7803b6ac759c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0bfb6f60-0042-f6be-24ed-7803b6ac759c@redhat.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

+cifs, +Jean, +Pavel

On Fri, Jun 28, 2019 at 03:16:35PM +0200, Harald Hoyer wrote:
>Hi,
>
>could you please enlighten me about kernel module softdeps?
>
>$ modinfo cifs | grep soft
>softdep:        pre: ccm
>softdep:        pre: aead2
>softdep:        pre: sha512
>softdep:        pre: sha256
>softdep:        pre: cmac
>softdep:        pre: aes
>softdep:        pre: nls
>softdep:        pre: md5
>softdep:        pre: md4
>softdep:        pre: hmac
>softdep:        pre: ecb
>softdep:        pre: des
>softdep:        pre: arc4
>
>$ grep cifs /lib/modules/$(uname -r)/modules.softdep
>softdep cifs pre: ccm
>softdep cifs pre: aead2
>softdep cifs pre: sha512
>softdep cifs pre: sha256
>softdep cifs pre: cmac
>softdep cifs pre: aes
>softdep cifs pre: nls
>softdep cifs pre: md5
>softdep cifs pre: md4
>softdep cifs pre: hmac
>softdep cifs pre: ecb
>softdep cifs pre: des
>softdep cifs pre: arc4

this is your bug. Multiple softdeps are not additive to the previous
configuration, we never supported that. Commit b9be76d585d4 ("cifs: Add
soft dependencies") added it for the wrong reasons actually. A sotfdep
means kmod will actually load those dependencies before loading the
module (or fail to load it if those dependencies don't exist).
Besides the wrong commit message, if that is indeed what is desired, the
fix would be:

--------8<--------------
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 65d9771e49f9..4f1f744ea3cd 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1591,18 +1591,6 @@ MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
-MODULE_SOFTDEP("pre: arc4");
-MODULE_SOFTDEP("pre: des");
-MODULE_SOFTDEP("pre: ecb");
-MODULE_SOFTDEP("pre: hmac");
-MODULE_SOFTDEP("pre: md4");
-MODULE_SOFTDEP("pre: md5");
-MODULE_SOFTDEP("pre: nls");
-MODULE_SOFTDEP("pre: aes");
-MODULE_SOFTDEP("pre: cmac");
-MODULE_SOFTDEP("pre: sha256");
-MODULE_SOFTDEP("pre: sha512");
-MODULE_SOFTDEP("pre: aead2");
-MODULE_SOFTDEP("pre: ccm");
+MODULE_SOFTDEP("pre: arc4 des ecb hmac md4 md5 nls aes cmac sha256 sha512 aead2 ccm");
 module_init(init_cifs)
 module_exit(exit_cifs)
--------8<--------------

I guess we could actually implement additive deps, e.g. by using
"pre+:" or something else. But I think the right thing to do for now is
to apply something like above to cifs and propagate it to stable.

Thanks for the report.

Lucas De Marchi

>
>But, calling kmod_module_get_softdeps() on the cifs module only returns one module in the pre list ("ccm").
>
>Is my understanding about how softdeps work wrong, or is the cifs module misconfigured, or is libkmod buggy?
>Please CC me, as I am not subscribed to the mailing list.
>
>
>softdeps-test.c:
>
>#include <stdio.h>
>#include <libkmod.h>
>#include <stdlib.h>
>
>int main() {
>    int err;
>    struct kmod_ctx *ctx = NULL;
>    struct kmod_list *list = NULL;
>    struct kmod_list *modpre = NULL;
>    struct kmod_list *modpost = NULL;
>    struct kmod_list *itr, *l;
>
>    ctx = kmod_new(NULL, NULL);
>
>    err = kmod_module_new_from_lookup(ctx, "cifs", &list);
>    if (err < 0) {
>        perror("kmod_module_new_from_lookup");
>        return EXIT_FAILURE;
>    }
>
>    kmod_list_foreach(l, list) {
>        struct kmod_module *mod = NULL;
>        mod = kmod_module_get_module(l);
>
>        kmod_module_get_softdeps(mod, &modpre, &modpost);
>
>        kmod_list_foreach(itr, modpre) {
>            struct kmod_module *mod = NULL;
>            const char *path = NULL;
>            mod = kmod_module_get_module(itr);
>            path = kmod_module_get_path(mod);
>            puts(path);
>        }
>    }
>}
