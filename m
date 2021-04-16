Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D451AC433ED
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 15:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB2F06115B
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Apr 2021 15:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhDPPAk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Apr 2021 11:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhDPPAk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Apr 2021 11:00:40 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA738C061574
        for <linux-cifs@vger.kernel.org>; Fri, 16 Apr 2021 08:00:15 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id u20so31361027lja.13
        for <linux-cifs@vger.kernel.org>; Fri, 16 Apr 2021 08:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=fmhhMaC9jl2RVHJ7vwIkjhR4yolSMbfxl4BIXazBmMs=;
        b=sVq+G8hhuwy+5V7x/pKqBk2mqtAdKKNqXneKIcGRBjEnjBrFREmW8LvyGJZ+/LOzct
         3jKmND4KXWuk3wOfqd/UFxxfGgM/w0ifBnDlcEO4ZdbSv+oD8+fgnQewrPdepH/XJbqw
         VtEzWfjQA9WFV22iSvxrqUHOaSf57W1JN2AlJB/JYGc4uxXTG03EEgtBW71eaMZVgJxJ
         CyvlBe29W+5Y/lYHvQN/UdXzhP0+/mBUo7Tf2xYXbzNq/ZUdP1UZ9oxFRNyq5vB2/W2W
         YjRX1JC6E+LZoRTcApjZGFTf41q3XULmDPO3zlca3xrlwa8mGvZZ4EuifbQV98uUhmZN
         kLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fmhhMaC9jl2RVHJ7vwIkjhR4yolSMbfxl4BIXazBmMs=;
        b=Rbxm/1lZlemTEPwNy91IgmZ7xYkW2lwnBekLNXzqentuRWbui+lYXdQy/r9Is00/cl
         TDRb5CqDEX3J5upODsJCiDy5fuROaOiPNsgCuHWK7hdpec9HWi7lab/d1jHjwTllbLrV
         VegF0eDi70v2nJ+K1ZTELgiQLdFzP/7aAOdEKhjFyWNhLADNzkZVjj8u7ok72AXa3M3W
         +OoAYvrZTL3nBCCERML473OAlEhM8EFx7LopeFc1SDkP5TvoNhpk+e3LfOqQod/n3er6
         HOgSMeLRKnTKHNnhJAPwt9pydCV36dm4lwfAei85janzrdVEMa1YL/sVkFJk06k9P33V
         oU9g==
X-Gm-Message-State: AOAM530oYbjeTKW77TXglFE9okBmsbA8fXOkKbJQhKEdnDWKtClu9pXx
        6DWeSJQnNI932W2Z2MPp2ztwkcvrCpSyMEZAxexR2ApJkE8=
X-Google-Smtp-Source: ABdhPJywttTsCDFrkkchlwJV/NXjnbGSWPm6gdIv/V/mNZ8ehVf1tqtM/SWXhv5EUWFUoWnKC1OQhCOtriSWFKegup8=
X-Received: by 2002:a05:651c:339:: with SMTP id b25mr2883255ljp.406.1618585213847;
 Fri, 16 Apr 2021 08:00:13 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 16 Apr 2021 10:00:03 -0500
Message-ID: <CAH2r5mvsC9n-WA-ngFViKctD_H=3x5JeEcf_DP+yL9wH1YU9mA@mail.gmail.com>
Subject: testing results against current for-next
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

testing on current for-next (35 patches) looks good (other than an
intermittent problem seen occasionally in a couple multichannel tests
over the last few weeks - will be interesting if the multichannel
reconnect improvements suggested would help this)

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/577

passes all tests now that one patch,

     "cifs: improve fallocate emulation"

was temporarily removed from for-next. That patch looks like the one
that had caused the regression over the past week (use of this patch
may have uncovered a copychunk bug) - so we need to dig into why this
patch breaks various xfstests.

-- 
Thanks,

Steve
