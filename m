Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80921C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Dec 2022 13:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbiLTN3h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Dec 2022 08:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiLTN3K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Dec 2022 08:29:10 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBC65F49
        for <linux-cifs@vger.kernel.org>; Tue, 20 Dec 2022 05:29:03 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id cf42so18622312lfb.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Dec 2022 05:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vkbmibj0XyZVNbXBLgK40kCsbrvHQKP9ZFmih0ERXKQ=;
        b=f2E3v/wqiy3z8imZkUFaJKBprnHDMiANpsv3j93rFfxXoSs4rn/wYj4p7++vNnYxm/
         lprz6ziVtv6StG/MgDAkv4LewLfYf2GBVhuz4wFG42EdufZD3T8cGGRs7gL9fmeseCbc
         FTXvtI+8O1eMq5p+xKAtJMutzzTI335TZENMtt5Kn8G9yYAboyEPNno1myZZdsHr+eNv
         B6IEVL3uAVlSMS47cuCjwMKXEMCXBA80D5OYPiawcrQgij/E0mYS6I3YecPYFa2Iwc2I
         sDTJwl3u5dS/ITjcEW3rsGvSg/JhhLGCKlN7K3qHp3vyD1kwG4ZIIc8DpeX5g2KDGl6e
         U0wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vkbmibj0XyZVNbXBLgK40kCsbrvHQKP9ZFmih0ERXKQ=;
        b=4X9x6eifjwbDqHox0hFNm0MPCivzEHapvNEE6Pp9wh8k9ZrkMluE+78KLAnKcYmjg9
         8/7CHZDV833hmXPFK+WPE7kcoRpRzL8Zs1Znsjo7CHlLHvLh6x/MWAhWL5tzlivkhqjE
         8OiR7t3NZlgklvpQsYA/fMDy/IvVjPt1BB0DWCVD3Z2Ep6Cd+8cYWKah0mcBlJTavCEh
         YLlGBxh805sUpR8cjmp5DjUSseSc+aqdybInujAADeXr3O/UQR//QTVqKFIPxTr4vZ6r
         PIZ0Jqm4EuvFRSrzGL/xGdoqpaWk1JvZ4A6PyRIO47xsKbKB5DqzUga5r/lUJlIjFQDM
         6QjQ==
X-Gm-Message-State: ANoB5plVh1/omEEiApC2Yb1wo4BlxXOmsXqfXzQE7kuh1t8e6DLJiNvp
        zsSSUmhesnmzA5lHhQCr2SSOo3k6UOstQkPqD4QC4uPWa0czXg==
X-Google-Smtp-Source: AA0mqf4nWwXm8oeXAU2mdFbbKqSqKKwV+eiXm6NNvfFKxjcWIELv6DPjY7yznMUqQHSUVVimIbedZiuZEWjBUXDFz7s=
X-Received: by 2002:a05:6512:3c87:b0:4b5:a12f:4172 with SMTP id
 h7-20020a0565123c8700b004b5a12f4172mr4145525lfv.112.1671542941928; Tue, 20
 Dec 2022 05:29:01 -0800 (PST)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 20 Dec 2022 18:58:50 +0530
Message-ID: <CANT5p=oKQEB6HnopL=jAd0pxd-+OukcfrVgc76X-suShqUiA9w@mail.gmail.com>
Subject: [PATCH] cifs: use the least loaded channel for sending requests
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Below is a patch for a new channel allocation strategy that we've been
discussing for some time now. It uses the least loaded channel to send
requests as compared to the simple round robin. This will help
especially in cases where the server is not consuming requests at the
same rate across the channels.

I've put the changes behind a config option that has a default value of true.
This way, we have an option to switch to the current default of round
robin when needed.

Please review.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/28b96fd89f7d746fc2b6c68682527214a55463f9.patch

-- 
Regards,
Shyam
