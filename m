Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F85AC433EF
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 12:07:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F0C7610D2
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Oct 2021 12:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231180AbhJNMJz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Oct 2021 08:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhJNMJy (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Oct 2021 08:09:54 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3B8C061570
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 05:07:50 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w14so23235310edv.11
        for <linux-cifs@vger.kernel.org>; Thu, 14 Oct 2021 05:07:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=27CRBCnT4N82zZ/m3JrkRYFdSRUhcD3VPc9Gu2TEuZ0=;
        b=Hrkh+Gx/CXI2lLXqOPd6VovMz1pqPdtQJHyuHxqBulrzAlvPOom536uCCaurWzKSsg
         bvIpcde1QdqNa+D2n0dsOtEjPma6Mc5K51+KnviVWfVZrD+JOjfn143rtDb4qMGIYIr/
         VzJOX3Op5u4mvcibFCN8fkxuxIaxEn1dHr7ZeiB6DhnGC3bqzIZ4gKZ5KOnIt5hOizXV
         leZZOSGhzp5yHybST+/sp/ASwpEC0U4+0MrK2e6e3UlKfteBImc4ZVBfLny1IQU43yGR
         7waLR2ONGM+t4h388FP5HG6ixoSK43skPiJ7vnINqWsb+8+KNl1uLIcdw8HlLvRE1qsR
         6DEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=27CRBCnT4N82zZ/m3JrkRYFdSRUhcD3VPc9Gu2TEuZ0=;
        b=Zw1cU7nwnpV9GkWvy/iZZZx0ExnhfrTRRF714WYXDdkgi9A4+LWaaZ2xxe2TXE7zvh
         Tdt8anB5EY2kGoHVLGz14+MmCj7qW/rSx7QaRwPb19PDu4SAx/MS0cKXlqHv4rubBACl
         l7z15555Pdq2xbv0vyKw/g+Dt73bSyHnMQT7V7PJoxh54dGLpUFF1QFZp5VZgArYbbil
         GPcC6QtO9zQQmzSOZNA23Qh0Kr/4+hLanrbd1t8tJMKM1GZDybYm0bzKoGhWbpGwfYQ7
         owxLrCegUh1K+pgsWb+PzWzvRNeHO5kmrRmjLEYdtbBJZbnM1j11h3BNCGhBtVxGqwo4
         R1Rg==
X-Gm-Message-State: AOAM532wJJOzjYG5opqaIkmc2BsAa5FKi/zse/5ziLeaUey8H6WbCQJe
        MmuTXtJlI8c1JR5+VNpQo6OIGNAE01m3wmwnVIbjOwKzoepphP/N
X-Google-Smtp-Source: ABdhPJxHkTS+DZpsmO5is6xwr43iOUTchk6RxQsk5+hogv0HE1rxibfocUo9rXenP5TIJ+9S5lkCkn/A4NXpmto0Cwk=
X-Received: by 2002:a17:906:54c3:: with SMTP id c3mr3340134ejp.536.1634213268621;
 Thu, 14 Oct 2021 05:07:48 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Thu, 14 Oct 2021 17:37:37 +0530
Message-ID: <CANT5p=ogvdT9nH=EksBnauqdr5u3Z_u4rJRHShwqvTY3YnEGbw@mail.gmail.com>
Subject: [PATCH] cifs: To match file servers, make sure the server hostname matches
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Had submitted a patch for this earlier. But it had a bug, so had asked
you not to merge.
Submitting the new version of the patch after fixing a bug.
Please review.

https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a02fa56af1817b960ba841d00af87ef93ded1f22.patch

-- 
Regards,
Shyam
