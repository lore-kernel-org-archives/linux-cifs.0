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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD21C4361B
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 22:32:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03DEE23603
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Dec 2020 22:32:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730176AbgLPWcB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Dec 2020 17:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727821AbgLPWcB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Dec 2020 17:32:01 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E949C061794
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 14:31:21 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id a9so52436434lfh.2
        for <linux-cifs@vger.kernel.org>; Wed, 16 Dec 2020 14:31:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=X0oV0c+DEna77MaYqksnL658KMZn2DgHu/VOTFs8Mxg=;
        b=jYzK3dQmuxWbXu2HzzkpuB/kqTnBwya1j8TOug9vRgfRj7l2EcJhXnNzr1bJ58f+Gr
         JInACoMJE4J1qliXKM2PaYPc5SdUFEjDezR8ZdZCsrTo9w8hlReopzmkAx5jFTDMLu4A
         bX7xp+nW9OQ16SQhEtcXNj3aKAFP8OZmlSw5CozZFpvTD27WFZu+6d+6PMlIPO9cYFkh
         SgNcEwM00HVWt1gwDmVQxfDKXg8Vw7jBPsSNxL2KrJ0f497hFaxcoMb3naeDPNrX819Q
         S5kGOFec0Kzv/liyAEOOpH7LfKkkfaaUEo9g2BajozQhg2EeCLjKlmKYxJ4otoAhr/wM
         1TxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=X0oV0c+DEna77MaYqksnL658KMZn2DgHu/VOTFs8Mxg=;
        b=KhIdFtSy9zC88WKhXCzj/H6Rox/Kd5OG3j9N8jAf1tuecAgjwzoWZ6An8LDTMg6TZw
         RGcluRgCG5BzRomBRsGQRls0NR8gVY/ja+M6P/II2kw1BfitavxEPLAxFKKSYSOxClgN
         S3jlJdKqNPNE3xjZoIQ6YQbo8VNH2xEqcr5DdeYkRPy23Z+c95R+oJC7H6svufnAjWBg
         ggX6ytn/m9GHnikmwZS+As4cRQBEUVZ7aYZCNTw9jgDa8LZviFN6JmkF1jEIKzSNDpLm
         E2+OJqwNuSBcO7jPfifDgL+3GspFum7cOUNCI0951zxvY7jmocVDhM9K1lhMsHz9S1fF
         Ek9Q==
X-Gm-Message-State: AOAM530V/r/xi7m8O/M6vgMI2VkO1/NILUbatwxAhsmhwokFMaeI0c+S
        qnjKFHcEp3LtNWXgtzFeAQLn+UFeZZLZaMNCcsZGTJIKftEGzw==
X-Google-Smtp-Source: ABdhPJwkNGphJQzKn9eC3zhB9fvXc/hqdRH3QH5SEK46e8271B0jDWVf0Ds7ao1b8F0bXoH/3kmepHxNhLR9jrMdj3Q=
X-Received: by 2002:a2e:88c8:: with SMTP id a8mr15082131ljk.148.1608157879165;
 Wed, 16 Dec 2020 14:31:19 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Dec 2020 16:31:07 -0600
Message-ID: <CAH2r5mt6Mx+bv9V1YWg0JFJRSYSA+S0j0bi1cueachy1AEH0SA@mail.gmail.com>
Subject: [CIFS][PATCH] handle "guest" mount parameter
To:     CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

With the new mount API it can not handle empty strings for
mount parms ("guest" is mapped in userspace mount helper to
"user=") so we have to special case it as we do for the
password mount parm.

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/fs_context.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 29b99e68ec80..24b7f8d0a51a 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -733,6 +733,9 @@ static int smb3_fs_context_parse_param(struct
fs_context *fc,
  if (!strcmp("pass", param->key) || !strcmp("password", param->key)) {
  skip_parsing = true;
  opt = Opt_pass;
+ } else if (!strcmp("user", param->key) || !strcmp("username", param->key)) {
+ skip_parsing = true;
+ opt = Opt_user;
  }
  }

@@ -1250,6 +1253,7 @@ static int smb3_fs_context_parse_param(struct
fs_context *fc,
  ctx->rdma = true;
  break;
  }
+ /* case Opt_ignore: - is ignored as expected ... */

  return 0;


-- 
Thanks,

Steve
