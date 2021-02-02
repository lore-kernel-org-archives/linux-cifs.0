Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D182C4332D
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 01:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 166F164EDB
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 01:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhBBBBy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 1 Feb 2021 20:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbhBBBBx (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 1 Feb 2021 20:01:53 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6239C061573
        for <linux-cifs@vger.kernel.org>; Mon,  1 Feb 2021 17:01:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id d2so1287545pjs.4
        for <linux-cifs@vger.kernel.org>; Mon, 01 Feb 2021 17:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V0izvOuTNUtald5IcD/J2tYB96vc7/LLzt4ew9Ak4hQ=;
        b=txx7Qe/qTRpke0lYFwUZS6C7YZpw2G7fR38IoagAjJiRj/o7lF1A6ycyF2jXkZzoPm
         Y1Aoei1PdEUi5NRhF5nniOThtudjCR8HVLf0Q3MuqPJrXJxbuEpfM1J+4wmCVC2Q8rh1
         5OlGaOc/pvB5xghRiBVLAG/aVwY7y+IovjwxIfuIJovYUWIxfuqP8jYHixdtQRX94pzc
         ZO0h85YaYamHbwETuXEty3EmoC6+llBfxQjxxhm5+GtYCOeiKjFtagwP5r3ukKZOyx6J
         PdIovFIhHXHpN8f9p+i9IQBEaN0XDqRpBu6xN9tH0hqIOfPiSpvkRfibRkNxg7TpsDE7
         95TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V0izvOuTNUtald5IcD/J2tYB96vc7/LLzt4ew9Ak4hQ=;
        b=Kgxz/0YhOFAfxc3Ujsjbk77nBiKtDoh0iBiBGnPRLkTIln+8OZKXCevo4KhYFJDLcR
         lLs/3zlE+zohgB54CCRo0h/TR9d2/dtGg3i8GPVNFSHvyy3ia4Wepxsb0PVx4KNOwVeC
         fTl5re0JIdwxfNJOM8WYY9i9qUjbJVpqnQoEHdH5mFwSuxFCsbsYYSoP2LwJKJy20e4/
         aRt8ryW5PEY1BiZ743uyId/wYk7rj9RyVxz6hmSqzVU6ypTsgzs9E0FjmgxysqRVS77n
         JKB+Qey++JBkEOz5wFXtPJGU03bdY1/Ed2Z+4GyTm+APgQH+JuWfy9mXefz2LO75OFCX
         1YeQ==
X-Gm-Message-State: AOAM533STPjPzeb0fVu2fmNy4r92mV0dC4ECYldnZjcfjOD6AdXkeZYc
        Dz6c9LK0vDVt7vVfYg7ZJw==
X-Google-Smtp-Source: ABdhPJxPbMeTUZDblpkYuqp7LWBoK0Yl5RuxnFiUCv7rTtQy2AK/M0ldXS5BLfPxLUYR04Q1jtWyqw==
X-Received: by 2002:a17:902:12c:b029:e1:aac:e6f4 with SMTP id 41-20020a170902012cb02900e10aace6f4mr20163008plb.26.1612227671632;
        Mon, 01 Feb 2021 17:01:11 -0800 (PST)
Received: from ubuntu-vm.mshome.net ([131.107.159.234])
        by smtp.gmail.com with ESMTPSA id h190sm19730080pfe.158.2021.02.01.17.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 17:01:10 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Subject: [PATCH] CIFS: Wait for credits if at least one request is in flight
Date:   Mon,  1 Feb 2021 17:01:05 -0800
Message-Id: <20210202010105.236700-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently we try to guess if a compound request is going to succeed
waiting for credits or not based on the number of requests in flight.
This approach doesn't work correctly all the time because there may
be only one request in flight which is going to bring multiple credits
satisfying the compound request.

Change the behavior to fail a request only if there are no requests
in flight at all and proceed waiting for credits otherwise.

Cc: <stable@vger.kernel.org> # 5.1+
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/transport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 4ffbf8f965814..84f33fdd1f4e0 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -659,10 +659,10 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
 	spin_lock(&server->req_lock);
 	if (*credits < num) {
 		/*
-		 * Return immediately if not too many requests in flight since
-		 * we will likely be stuck on waiting for credits.
+		 * Return immediately if no requests in flight since
+		 * we will be stuck on waiting for credits.
 		 */
-		if (server->in_flight < num - *credits) {
+		if (server->in_flight == 0) {
 			spin_unlock(&server->req_lock);
 			return -ENOTSUPP;
 		}
-- 
2.25.1

