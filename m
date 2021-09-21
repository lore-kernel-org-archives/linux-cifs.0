Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3436C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 02:22:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99E6F61183
	for <linux-cifs@archiver.kernel.org>; Tue, 21 Sep 2021 02:22:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348665AbhIUCYJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Sep 2021 22:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238437AbhIUB50 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Sep 2021 21:57:26 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929B3C093956;
        Mon, 20 Sep 2021 17:43:59 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id g41so42115206lfv.1;
        Mon, 20 Sep 2021 17:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=dKYtMG1M7HT7q8h/2F2W9SKuIVgYAAKbgp4qkM0hkq8=;
        b=bpVZYC3jvvyKyxCGVOURxtfkbBNd1Q5QdGWEZFATxHGnONqI/7rxQ492kNtWTiMLGm
         4kcgJP/qfk8/uVFHkmgbllg9HvjDz1Ox7ASENylzxkkcQEoN0Qk+zI+LwlbSBwF3hDQj
         C4+hhT/07PYc+3QJLRxwk/zfIQfWyIaefo/tNzeVklbi4e9kZml2xt/t/d32hwCiUN4V
         Qfd2HjQ349r2KAFNgNnfPSWCfgDDqqq94Ddir3dMi2KhJsz7c7HAwBwhEIRKiP0zEBiE
         Qmey/j30dowsuHwEzJcH8RNgaSYshSuwUWAsK6UZWDRr63Xek3NbMCYJLJ6uGpsClZnY
         gWCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=dKYtMG1M7HT7q8h/2F2W9SKuIVgYAAKbgp4qkM0hkq8=;
        b=JphknETf2XWD2bIQh5tiArvG5xXqExi5X8PN89GiBnEfic8eZhSOxFQ+/7V/5OHq9f
         XNy8BEh05OtPqQUW3uXmjLjeLSjMXCjDRR/8YG/IiRRt4GbbtyjDQbblqQRjsltYoVoZ
         p5WdZZlBoa90qXEsvVaUDdcPuWWyZgQ7PhAgTtTJMLZlM0rUPowcBc+nz3rEO1peOZ9n
         ZfogWE3WsLFfgcdt9xsD6VyfcG8nouPwgMawzCH5bWhpYN2tEu8FTU3ElEzlIqDEbrvf
         natjjwon69gbEO50UHzFHnjDdFgyHzi14zOXLc6HbKPiI1VElNbU8zlDnFgJmRIdd10o
         8IYw==
X-Gm-Message-State: AOAM532AhwNzsUhBOyIDAqrVJF5h6bqUT2K/aKThC3aQVZJ69L/FXqMR
        4DIe1egXbF5n9vouDYxX+8gozMZOekQ1EYqDWqz7zNs9nm0=
X-Google-Smtp-Source: ABdhPJxIY6Gxm+3A/h0adUEfIuN1Ju17FUjuYJ7zGcd/ou62yn4ZIlJYGNCmDktB+PXDpjEKakgH/GxhqZ2wU3DxyCg=
X-Received: by 2002:a05:6512:3d93:: with SMTP id k19mr21982026lfv.545.1632185036666;
 Mon, 20 Sep 2021 17:43:56 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 20 Sep 2021 19:43:45 -0500
Message-ID: <CAH2r5mv84yZk=FEmSZwNRNXncPs22Fgf6zKLBozgWXbMSJkGMA@mail.gmail.com>
Subject: [PATCH][ksmbd] log that module is experimental at load time
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

    While we are working through detailed security reviews
    of ksmbd server code we should remind users that it is an
    experimental module by adding a warning when the module
    loads.  Currently the module shows as experimental
    in Kconfig and is disabled by default, but we don't want
    to confuse users.

    Although ksmbd passes a wide variety of the
    important functional tests (since initial focus had
    been largely on functional testing such as smbtorture,
    xfstests etc.), and ksmbd has added key security
    features (e.g. GCM256 encryption, Kerberos support),
    there are ongoing detailed reviews of the code base
    for path processing and network buffer decoding, and
    this patch reminds users that the module should be
    considered "experimental."

    Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
    Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index e6a9f6aa47eb..2a2b2135bfde 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -584,6 +584,9 @@ static int __init ksmbd_server_init(void)
        ret = ksmbd_workqueue_init();
        if (ret)
                goto err_crypto_destroy;
+
+       pr_warn_once("The ksmbd server is experimental, use at your
own risk.\n");
+
        return 0;

 err_crypto_destroy:

-- 
Thanks,

Steve
