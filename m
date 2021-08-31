Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B5DC4320A
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 23:33:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 090F160F92
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Aug 2021 23:33:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238552AbhHaXeT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 19:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240762AbhHaXeS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 19:34:18 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6EC061575
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 16:33:22 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id j4so2412356lfg.9
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 16:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=qWnM7YPAOoXvYDxBQDy2ull6nlOC2QI3Q/xmnnDOtZc=;
        b=LJzclgzuyW3STDXBcvfHrf+6ChiUotZsnk0qDNafgQv0+C2MkEVPex/uWivMGuyBan
         Xj0NNDwI1+tCyDWYUG0qdSrJrQrPsAil/vaoaT0mcxHChjtCPhIqnFCDE9MdofMcDzM/
         roN6mFvrelxM+lqy3liyOMc0zk/lK7Lfx7Xgivd3qVLglvgSYfbFYgMzgaK63wgnubvK
         +eyf1FhrbY/V7DD6edUVmT1alOHIav5hlgPxrTPTofY4svQn+BlF5fpn3vaMvLu2Qk1h
         LHcUUCMdw7KgSxksWTWe+VwnR0ItWks9T14rPxWzxu73PTYtLHwz7ywyTaIIFyL8uHZn
         l9jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=qWnM7YPAOoXvYDxBQDy2ull6nlOC2QI3Q/xmnnDOtZc=;
        b=O+1CCUtwDd7EQ47Suw6H2mRMbI3jAmVYdmd8hfpOPJbfIeyOqGLBrITFI4Y7O/qS3D
         2VpcIJ+kJzh0qTqCj0IaHgSVeYqq9nk9n1HvADMl0vWxKAsoWbFbNy/7ouX2MnnpHr6N
         5YlXWL2Py71wduBnX7ZPnSgewxOnMtVVDurgQ33hqUz5SN2oOSRW65kfMcNleH3XTlTz
         v5zfwSUpzZXKvbM4cHHqiEdo7q/wFUdhhnVstmyaKo+RU8EPtV99OeSHQnLVngB/2H1L
         SeOHwSvgkgzUM7IfZkB5fwVwbbUreJYp1HG/h5jWQ01Wc7hdgKG35pPz9KJj6R5Fh14z
         gKtg==
X-Gm-Message-State: AOAM532hqhgSrqoEwUsfBnDOVnukb6Jg3sXjD+xDXEIFCAct0WnVIKiW
        LNRYXr90/P4IzyuT3B9noyeSZsDtrMpK5P/jWiXqgVsH
X-Google-Smtp-Source: ABdhPJx6utr0CAYiwxdJBkt1aXRzbTRKP/E4E7Qb+lA6cgxtkWVHyFRhpj9C5+CvdXwWlP3RHpxzroriaIZQk/cmNak=
X-Received: by 2002:a05:6512:6cd:: with SMTP id u13mr23594605lff.184.1630452800777;
 Tue, 31 Aug 2021 16:33:20 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Aug 2021 18:33:10 -0500
Message-ID: <CAH2r5msVD=ySXysQoVvDsw+d4+2sVjybMKYSh2fBC7YDcVfp1w@mail.gmail.com>
Subject: Common headers kernel client and server
To:     CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like a good opportunity to move a few of the kernel headers used
by the kernel client (cifs.ko) and new kernel server (ksmbd.ko) into
common subdirectory ...

Some have diverged a lot, but others like "smbfsctl.h" would be fairly
easy to make common (and has value as well, as a few of the additions
made in the client version will help the server in the future and vice
versa).   In general, I lean toward having common headers for anything
defined in MS-SMB2, MS-FSCC, MS-SWN, MS-DTYP, MS-SMBD etc. and to try
to use the "official" names for fields and #defines so it is easy to
cross reference the code and the protocol documentation (even when
those field names in PDUs (protocol definitions) and infolevels etc.
use camelCase)

-- 
Thanks,

Steve
