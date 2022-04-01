Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44677C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  1 Apr 2022 16:20:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344981AbiDAQW0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Apr 2022 12:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349138AbiDAQV0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Apr 2022 12:21:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607822A963B
        for <linux-cifs@vger.kernel.org>; Fri,  1 Apr 2022 08:51:57 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id dr20so6700836ejc.6
        for <linux-cifs@vger.kernel.org>; Fri, 01 Apr 2022 08:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ApiYTV01EtwjEYDvNft9+n8UHw77cSnJK0Zq7hPa1bE=;
        b=aIE6+DcezqVLksnEHfv6w0n8uJE3SZ5yWS72ERH/7h77/zEQAasyDlFT5+gX2fs6Pe
         /sTcVW8dZRm4oPPUZK86smvuwRMswOCmO+v8TFZODqrZv/QtBhgbjE5ax/CX2U/oo8DZ
         CXhpc/SgpOGY3jEN7N7shpILlP95rsQyRt8Qa0yOKInVyHw/1GinyiE63p4jvybnPaUJ
         gnuUAbvyl4zdmcm+ka8x+NQtGpuw9dSqKcqj8meuxSmhXNHTc9T5vEkfLd/dzDtXQtGx
         vhQ55g8fq0QA3x6J+XFmUAIveoK4e/RAPGDDFjgurW55Rpqz1R/48hPtB39CqPTEYoJv
         nTCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ApiYTV01EtwjEYDvNft9+n8UHw77cSnJK0Zq7hPa1bE=;
        b=eZRM52UGtd1Wds9T79QNYFam2sczUlaKUydPunzYutIeahbk+O5QLjqitRiM6Vk8R4
         XH+QpNSywMjH/96qHX2Gqzu8+alay+/7ZVGt4CNQEDHrL1zWiq77LB6bKzZSE97OcPH5
         bFSbQQhMsTlAE2u5evgfCMEml6TrXUGkkrZ5gaeJhL43YI7oaVsGVfncNexyvtu9jb5z
         XgvndDJvBTWrQu1U9Qnw56qKAXLX3gPdFhH+YLjiV/hSweIHW5ILA7xHl9/iRybqA2XK
         OvXfCwV5i0Y76riG+t7JjkegxRovIFGj3/Yi66Hz8ChMknnLgmNieiUeywWIOP8+yDEY
         wIKw==
X-Gm-Message-State: AOAM5335nKPBdYohn7xuQzEiOdLMef3cTaij9xdYTU1hb+Ybcw20Af4s
        rfFvREVR9aYKn0uX0Cmacus5yjQOzKSX5M+Jf38=
X-Google-Smtp-Source: ABdhPJx7U3pOl7VD3N/7C3DEbjSrVPHOKoM3h/BZ/4FrMhJsxzo4kA76R6PUarQfzMvETy9/RuEt9E3khnuGWSiVTM8=
X-Received: by 2002:a17:907:7f18:b0:6e4:c15e:772d with SMTP id
 qf24-20020a1709077f1800b006e4c15e772dmr350104ejc.511.1648828315599; Fri, 01
 Apr 2022 08:51:55 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Fri, 1 Apr 2022 21:21:43 +0530
Message-ID: <CANT5p=pY-GM7aCO1csQJek_oD=g5rwN0UJ1cKpSLEQUB=X4hiA@mail.gmail.com>
Subject: [PATCH] cifs: disable dns caching in kernel keyring
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Please review this change to disable kernel keyring caching for dns lookups.

We've seen a couple of bugs in DNS resolver that causes very hard to
mitigate issues due to kernel caching. I think it'll be good to
completely disable it for now.

Only downside is that there could be too many upcalls to userspace if
we're continuously doing reconnects. But I feel the right answer to
that is to avoid too frequent reconnects altogether. Perhaps implement
exponential back off for reconnect? Thoughts?

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/2bc32301b950e64e49b511e7803668f9e012b567.patch

-- 
Regards,
Shyam
