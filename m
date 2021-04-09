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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC16C433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 19:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B00F610F9
	for <linux-cifs@archiver.kernel.org>; Fri,  9 Apr 2021 19:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhDITwB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 9 Apr 2021 15:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhDITwB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 9 Apr 2021 15:52:01 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A3FC061762
        for <linux-cifs@vger.kernel.org>; Fri,  9 Apr 2021 12:51:46 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id d12so11467357lfv.11
        for <linux-cifs@vger.kernel.org>; Fri, 09 Apr 2021 12:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=g1JYMQkP+iUetgAEXoi7C25ENX+aX5fnfYabDjrNKXI=;
        b=gMAq5N1Rzjlffj0eESB0ju4G9ejSo067bxPX2ghwx5yvYmHiRld3Of/oGYxI75Hug/
         FqUFHP9rhIgfsjnsekNyY1+2J7gp1ilx2S7LToiYEYjq2KQ10mxCsY+KsI1aKEgUt+xJ
         nZ+C3Kfspvi0omAViENtbYujtLJp15h2WSKk1hiB5/ayJ/qqsQB8IkAoeRGG3Bu015Hz
         NnbtnWhspiBhCwcW+Etk4YoDbv/W1S1CVzG1+Xw8u4gpWx/efejOnHFNcSB0vC5UffiA
         65B9GBgVgfO+sw6lPDNFR7GWu4tJwJmsII+war7NptrgmbNVgn36xLzMaWl01l9nDzzo
         7EFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=g1JYMQkP+iUetgAEXoi7C25ENX+aX5fnfYabDjrNKXI=;
        b=ru2pMQLIVtYYwsT4CfnMzffC1Hrek5Q9tMyAMXMpi8nIvgZtJU29ZaBXR/MxIPi+7a
         3u4voFkxBRMTxxEhsFBNQ3b7AdsOF8laPi6kGzSK9MeMu49Owx/lyNsoJrmMvRxbpfFB
         cXCa6R4jFh5jAQ+8TeYgxx/rt/G1e9bK/z0SlUBlVVuUfkJ7774zqMEAw3acqj1T2RqQ
         ryGMkRuXZyOmkCeZJ2yBBcSV+VgWxR4qmDo/gtZIN3M+B8SZJE/lMugFY+kW0O0BSRSh
         9Gzx61NtXkNP556fhzK/ZqAWODSVUOakjIS+ZjyNr0+XKupgB3hMFXYUWL66ynTp0hm5
         4qUg==
X-Gm-Message-State: AOAM530VFKG6n6AnOPUGCa52jcWo2zpEKheoq+HDJw0zhz1XqSKzTt+C
        SUjvyFqQnNt6uA6nAJ7DdJMXLGJYF4U9/ye3WiF+G+AxvyhnmQ==
X-Google-Smtp-Source: ABdhPJx/hy/MFYEYkrE1N4gQfdFayKPtth6ESir0UeTb24iMm8Ixao6CFWihPIxA3jv0NbA7GJNBg2X0RLfaPzDpLJA=
X-Received: by 2002:a05:6512:3ca0:: with SMTP id h32mr11481952lfv.184.1617997904826;
 Fri, 09 Apr 2021 12:51:44 -0700 (PDT)
MIME-Version: 1.0
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 9 Apr 2021 14:51:34 -0500
Message-ID: <CAH2r5mvmsdai3iCwpohqUeeiW5tPSeiQgCH8DcpicWntc25rNg@mail.gmail.com>
Subject: [PATCH] cifs: correct comments explaining internal semaphore usage in
 the module
To:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

A few of the semaphores had been removed, and one additional one
needed to be noted in the comments.   (Additional updates to the
semaphore/mutex/lock descriptions in the comments in cifsglob.h
could be helpful to make sure they accurately reflect what protects
what).

Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cifsglob.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index f84a839224ae..6cc54a1d4336 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1792,9 +1792,8 @@ require use of the stronger protocol */
  *
  *  Semaphores
  *  ----------
- *  sesSem     operations on smb session
- *  tconSem    operations on tree connection
- *  fh_sem      file handle reconnection operations
+ *  cifsInodeInfo->lock_sem protects:
+ * the list of locks held by the inode
  *
  ****************************************************************************/


-- 
Thanks,

Steve
