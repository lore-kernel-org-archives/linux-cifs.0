Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55449C07E96
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 05:37:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D23A611CB
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Jul 2021 05:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhGMFki (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Jul 2021 01:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbhGMFkh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Jul 2021 01:40:37 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B7BC0613DD
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jul 2021 22:37:48 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id v189so24420544ybg.3
        for <linux-cifs@vger.kernel.org>; Mon, 12 Jul 2021 22:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=d/9VyZgK7BuLnNR6aZx6i8ToIMWk1nsD1zSAlx71eME=;
        b=AGVNIploEHUgC9W4h3SWae3DBJs0E2g4hTqSZs/Lh3++TqqX35mNBbEbNDDbsteh9j
         5cbIqJELBo2AAnhIg3XD2Air4qBkzme/4k0cgo+RaTKPrllItGZzrpPlDU/feeRS7zqw
         ZhPS/siQxfmRJuYR5Tx1lMf0E1/zOtrKwGiSVRC8F129Li8fYSIEFPnxqgs50RxX723W
         3Ny1AaeE63Dil8HK8hx9Wm82dOLLGQH2Q+oXsj3ICb3Vc5Yt/RFCFiat/dXJi0lRzirp
         U8hlYkA+l3ikfgJZPqc1CNPNYBC9/h5QtEM11J9NGflJdMUuJHqLHmgNa0IEF0zhuwpH
         ehqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=d/9VyZgK7BuLnNR6aZx6i8ToIMWk1nsD1zSAlx71eME=;
        b=ZmwPLsucn8mFi78SRdiaAIrDfgx47SRzVZePvL5vBOosbmM6sT6t6NSg7uFRwtCD9h
         9eHPrKiueCjdlqhsmJoanEcKbt9pyJ3h8VbFzxADqSyaG/a6UBJ17XQ8qSADp49Jrm95
         RgjudtgiuvVe0O+v6b/PxGpBvxmPfjQSRdSBoXGvH93ApN+Uw/6SXDfp+0AxMm5oFDKD
         f2mFmKxRyzC65W6JnoAO8Kh5+OaS32AE7STbs+tl/C25SHW8esTF8jPj6QUZjvQfp9mD
         cGpBQS5l4XUYarCrVcrnmOcCUlO5JmEbCTD8k6AP95IN5n0Z4Utbtoc9c3Vj0TGs5G3F
         dsjg==
X-Gm-Message-State: AOAM530hg+cbqkUmP3ZLd4iyshV4CMn0g/cMxYsVkiPoCSeqXFHSmO4B
        pDdvg+xqhB7BgOuPni1RUbbTl/pa++94Tn30zAxPa/bllwj0NQ==
X-Google-Smtp-Source: ABdhPJz8UXXAKEBWXMEz1rNS93/PU9CwnkEqux6KwnuZUC8PlFQZLj/sYcLdkc4rgMM4gdheC2NL1hJJoyDdN6263To=
X-Received: by 2002:a25:ba87:: with SMTP id s7mr3327852ybg.97.1626154667569;
 Mon, 12 Jul 2021 22:37:47 -0700 (PDT)
MIME-Version: 1.0
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 13 Jul 2021 11:07:36 +0530
Message-ID: <CANT5p=pDrNBRQSHAarXzxTRNF9Lo=-q-hsnbBTHJZue=ggGzXw@mail.gmail.com>
Subject: cifs.ko page management during reads
To:     Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi all,

I'm trying to understand our read path (big picture is to integrate
the new netfs helpers into cifs.ko), and I wanted to get some
understanding about why things are the way they are. @Pavel Shilovsky
I'm guessing that you've worked on most of this code, so hoping that
you'll be able to answer some of these:

1. for cases where both encryption and signing are disabled, it looks
like we read from the socket page-by-page directly into pages and map
those to the inode address space

2. for cases where encryption is enabled, we read the encrypted data
into a set of pages first, then call crypto APIs, which decrypt the
data in-place to the same pages. We then copy out the decrypted data
from these pages into the pages in the address space that are already
mapped.

3. similarly for the signing case, we read the data into a set of
pages first, then verify signature, then copy the pages to the mapped
pages in the inode address space.

for case 1, can't we read from the socket directly into the mapped
pages? for case 2 and 3, instead of allocating temporary pages to read
into, can't we read directly into the pages of the inode address
space? the only risk I see is that if decryption or sign verification
fails, it would overwrite the data that is already present in the page
cache. but I see that as acceptable, because we're reading from the
server, since the data we have in the cache is stale anyways.

Seeking opinions from experts who've worked on this codepath before.
Please correct me if I'm wrong with any of these.

-- 
Regards,
Shyam
