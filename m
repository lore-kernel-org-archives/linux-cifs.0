Return-Path: <SRS0=Kcr7=RG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 688F2C43381
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Mar 2019 05:05:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F40620857
	for <linux-cifs@archiver.kernel.org>; Sun,  3 Mar 2019 05:05:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n3+RFMYQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbfCCFFX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Mar 2019 00:05:23 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:37321 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbfCCFFX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Mar 2019 00:05:23 -0500
Received: by mail-pf1-f174.google.com with SMTP id s22so875305pfh.4
        for <linux-cifs@vger.kernel.org>; Sat, 02 Mar 2019 21:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=U5Wrl1GlVjl/IKipVOlgGTbSeml6JYScXS6rLjmlCDg=;
        b=n3+RFMYQnvzuJoTdxjhkTWGJP0o0cqY2LfpWN0oJ/ylvgUEIHEnU+ckn5e+BpnFiRM
         v1wke0H42p9Hjkz1VnZ/IiDogvK1JIqh5CRpXYHnrqxVlH5LNzXW3fA2Oyq+kNxaeawf
         +sLFjFqPR//EZU1Y8qlXXDh7IU9yUdQrQ0My/BufMZyStZsGKHSXnvYKZDd71a7sdKzn
         QxtTL8TxU6lmUS9ZIFPipjoXzyfGRBvLE7poddd69g5ah6aMPAHhGS9xioFV/QMbrQoq
         3bQgncxEASMp/Jx6ms1B8aKILs0OOV9m2S2KCoSN3t9+fBV6jaryyXII0f/6jip5f9jd
         vjFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=U5Wrl1GlVjl/IKipVOlgGTbSeml6JYScXS6rLjmlCDg=;
        b=lI/dh8S1ucOkbxYBH7AQP5PoaSR/9v+64UqsJKWEtBKVI8h+UUQNlSbZP32yYiZ47s
         SAz3QEn0ci+rWYrgzYcwPIfLode0J7u6DVpX/5k8uBy/nEJYIWxvy/l8kmfNvFQsFP8T
         fzwyoxxC0yjJZxq/m0PoKuYY6eUSs9jnY6uee8IG37bYY58H9w0008n9FAMeWhMYEsUG
         Sk6EPllTmRHRCk5rKfsAa23dR8Hj6mR20d1ZDNv9JMt8zbXtHbTeWmcZO1CzF0nHWwaD
         SBTTCSeDvbc8LlpG1wA96vRusUoBJXy8zxQGs+pp4tgjBOi6UY00WauVPKXmtiOQgwnf
         e2vw==
X-Gm-Message-State: AHQUAuY9o+8na9+6mRPacLDo5uog/KtP6rgvT1lEB9pv/7ZfY+vEn4U7
        bnngkaRkjRuZXKxnqwViDGYLQ+wcMFVSbAw5fXSM7Fu8
X-Google-Smtp-Source: APXvYqyMIAr3myjD2t06o/xdPmNnE+OjC3WiH7gQUYkDL6l/zT6N71ftht/cjAksIPYXXr5/fM1Wr6AMazT1xpag9C0=
X-Received: by 2002:a62:ac10:: with SMTP id v16mr14251633pfe.111.1551589522433;
 Sat, 02 Mar 2019 21:05:22 -0800 (PST)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 2 Mar 2019 23:05:11 -0600
Message-ID: <CAH2r5muJYvzg7-HEa1_+Zww3QFBgiL-L6oGBDMiP4TPC5GX2BQ@mail.gmail.com>
Subject: More tests added to buildbot
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Added four xfs subtests to the cifs-testing buildbot (and 3 of these
were also missing from the Azure buildbot so added them to Azure as
well)
+        [ "generic/464", "smb3"],
+        [ "generic/469", "smb3"],
+        [ "generic/524", "smb3"],
+        [ "generic/528", "smb3samba],

Testing the three new tests for Azure in
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/4/builds/105


-- 
Thanks,

Steve
