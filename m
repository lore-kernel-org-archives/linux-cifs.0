Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC0BC433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Oct 2022 05:41:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJGFlx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Oct 2022 01:41:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJGFlw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Oct 2022 01:41:52 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35468FE761
        for <linux-cifs@vger.kernel.org>; Thu,  6 Oct 2022 22:41:52 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id t18so4007768vsr.12
        for <linux-cifs@vger.kernel.org>; Thu, 06 Oct 2022 22:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=8+p3i0IWH5Gmnhy823sWtVL1a50v/oarNJLcwqmpVb8=;
        b=DIpy6lA3XfwFqJRjxpJrtV8c7HZhzZzwoNJxQUjIRw5uzf+hfqWlqDB0augMnviMTi
         5xEInoBpblFkco54YckaqxsWD33GNuYAXfl0thtrcrMjsRSNZUcR51ilEMHgQiDgAObr
         F8CoeOw3MXMOYDHYKzzrMTdXAARxiCv+qDsgZij9gkG5gLO9s3+8l+Fn0Jg3B0tda5Bg
         0ePa9wreJgHlhmrrJjJx7Orgp8G1ZS7C8KQvC8wL6z/IRDPNSeuTOo1tj2kpZnByCyLP
         J7TT08y3rmNvXPXlKQ18YDdSdSHVXBhlv6jN/CdRkZdyL8gI7m0RZ9vB9tgVRkPSjZBV
         gP+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=8+p3i0IWH5Gmnhy823sWtVL1a50v/oarNJLcwqmpVb8=;
        b=qrKNfSyW9GWlW5QS4MFQf3jG+Ft3NF+NkzysfYmJYMTM8EEPRnN3xi5385CDC2Wr6s
         xUoq2J0I8J9K1A6i2n4RJW+ti6+3oe/rqX8eknMcIeyEDk81dt/BUzdDWPhVH0JDhEkC
         XI+s/iwnEDGRDAIemZKgtSAhHtXdVDXmSF1nur9/WDG+Jo+uylrDPAuP6a/of5iQ15e3
         m5Gmu0MLQChw8mC9zaPBgIWOmrkrDNLzGa1S5oXwcpHQQ2AZYvCM5NV6ZnN4V+YMFYpo
         vOxG7sZqme/yBaGi/DlEhGh53t0Rx7ZnMRmwHYsj80K+UDtbRHGVtID47/PspTk8U722
         9fXg==
X-Gm-Message-State: ACrzQf0kJxMCoWNp/qYfyW2RH+TybTera94ekwVyZQ6wvmEKqQJZHol/
        aihq58K2Ru+8tWgF/CytyBuZGjYylP0W5q5xqKQ=
X-Google-Smtp-Source: AMsMyM5cKp8s/9UP6THFwlPxfH29aeCokBiEBPmTkBm+9fCqs2wM/g5h+2YO/OtWptsQYHC8Wtiu79j5Etb/NK7+zo8=
X-Received: by 2002:a67:f603:0:b0:3a6:ff45:997e with SMTP id
 k3-20020a67f603000000b003a6ff45997emr1927568vso.6.1665121311179; Thu, 06 Oct
 2022 22:41:51 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 7 Oct 2022 00:41:40 -0500
Message-ID: <CAH2r5mtxz=T9ctLOqrfqJxAHyxWpCkdFUekybP3Ubc8KcukWPA@mail.gmail.com>
Subject: sign failure with for-next
To:     Enzo Matsumiya <ematsumiya@suse.de>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I saw a sign failure running xfstest generic/070 to windows with
current for-next (which includes some of Enzo's signing patches)

[21805.362128] run fstests generic/070 at 2022-10-07 00:23:09
[21838.320247] CIFS: VFS: sign fail cmd 0x8 message id 0x1965e
[21838.320252] CIFS: VFS: \\172.31.48.1\TEST SMB signature
verification returned error = -13
[21839.436768] CIFS: VFS: sign fail cmd 0x8 message id 0x19a0d
[21839.436774] CIFS: VFS: \\172.31.48.1\TEST SMB signature
verification returned error = -13


-- 
Thanks,

Steve
