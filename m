Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B723C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 18:22:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4172561465
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 18:22:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344726AbhI2SY2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 14:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244341AbhI2SY2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 14:24:28 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125F8C06161C
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 11:22:47 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id i6-20020a1c3b06000000b0030d05169e9bso3886767wma.4
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 11:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=AbEcCXRwgD+vOF97JVisYxkNc1WaFUp+G7xAVmWlseU=;
        b=KLixKzTQAKFNY72bz+xPPlxEdEQIwIt5AF8Al32qSoJltOSgFKntALALdmA+JwyAJZ
         DGmZ+8MZZUIynAitLxdotowxp0epaDkGeH/QvDu2WSQcvrMWVqMAnnnDCfYXyztX8Q2G
         8gdt3p0Sbo7GUUMRMXgof3UWLpLFOgV/MAQNrITc9vESUrflwrNSXnj74jYYkNYPKooG
         WZyiMUPYnsrTau0WnEAvdbF2LWUX7U+xWBNzkGI58sY8dOOtsbH86mEtpHWpiKVzwz3H
         QTE+YYcTWoH/VJWzBoUuHdWvnHD9pj2+b7TS11Haju1K2mkreWtFBGTJ2cqtMoODPYWT
         zrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=AbEcCXRwgD+vOF97JVisYxkNc1WaFUp+G7xAVmWlseU=;
        b=I4UmVQD22tyDQKqb8WUY4QGyCZZMkpoWAIaTi5oelmPZEu+P89dgq7Ks7WLYDTGrF9
         AUr/bfb7N1BqQRHZpwjg/W9JDcUcXDq1V3oT25oTtU1KsdA0F3PKWotR6EgOjE9ZZ4qk
         ECqNrubgICuh8mbTK4VJ9EWZ5fyEjsHVpEKrx+sv6VvGSnzRRNHzFENWcfQakhtNI+g7
         RWYCVBAOXMFtJjIIs7fKEG6akC2/ATFq/deTZ+BtqGG6NSIHnRQTfJnI7z2IyXaN+izy
         U7BmjbsMvEW9k5AsBWJOlWJQKBqn3NiBB2xNprSHEObI3isxDblQom4v65z1epYDEFgz
         eRZg==
X-Gm-Message-State: AOAM532RNf5AJIVNif2UwW1CFoHy1Npp8Jq/Na80xpYc0wp3mjuz9VK5
        ZNtRh1KQRFGdBoZRQJfqSNYgOZME7XVAfcbNr5k=
X-Google-Smtp-Source: ABdhPJzJJ5FzspmP8Mo6UREmL3Ieg/gBn3+poAe4wroV0m1bvDY+AbnP47C4kN+pRr5mJ3g7v5DYZSVCQvfW+NHFphU=
X-Received: by 2002:a1c:98d1:: with SMTP id a200mr7120608wme.86.1632939765370;
 Wed, 29 Sep 2021 11:22:45 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 29 Sep 2021 13:22:34 -0500
Message-ID: <CAH2r5mt_cFskiqbVvMn_M44p=0L-zFdkKsJj2JNYC3QLriEAXg@mail.gmail.com>
Subject: Use less confusing branch name for populating ksmbd changes in for-next
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Can we switch from using "cifsd-for-next" branch to "ksmbd-for-next"
when pulling changes
automatically into linux-next (since the module is fs/ksmbd/ksmbd.ko
using the branch name "ksmbd-for-next" is probably less confusing to
some)

ie from:
  https://github.com/smfrench/smb3-kernel/commits/cifsd-for-next
to
 https://github.com/smfrench/smb3-kernel/commits/ksmbd-for-next

-- 
Thanks,

Steve
