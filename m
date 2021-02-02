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
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED3BFC433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 19:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A468664E2C
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 19:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240168AbhBBT4y (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:56:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhBBT4Z (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 14:56:25 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40D04C061573
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 11:55:45 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id gx20so3101372pjb.1
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 11:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x87SfFiq4vbWMr2kXVdjYptjoTVAPuRJYBro/u7E9QI=;
        b=IXoY5sS7K/XgCzlMJXUbWsVqbuV0CENI780mFwkdgKmstRkRnS8PxsSw78W5V4rjLJ
         TBgGPgMrDRLStYcT4P34br468ri1XbVyGAwtuaXD08cULds6tYiUyQHZxAX4tjn7/f0C
         ZkqkILFN6Dfzv2AUhkDXEnkIVpQ+ElYqDXrhlxc8fskEks85n/fLb9sI8D2JZUt7Yc7R
         m4NEjIk+xqVJI89UNRHO/uii3ESj8F6VaUA/KfeIuKTIF3HngUepIlfYURXi94yKgIDy
         XKHS2H4cjyoooTafHydfK9z1aH/+YTOqZ34FK4QPrVE73VisZZFCLfGZ/MszusH97hdO
         SQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=x87SfFiq4vbWMr2kXVdjYptjoTVAPuRJYBro/u7E9QI=;
        b=VQzi/PMCbjBVsmKTYFGQszryjMHIhhuXWKk7zJ5BFuLaa6xfqzLRbvpLE7vgagFxe6
         TiDPxCb0zpZSRa+v0dXmMJvxPhTV3nWY5kd6nS6w2U6jPHzLesqw50rk9/nje9iO/YGM
         y7f+7UtYKJLw1sjX3miDzxPvSiaZSCn9QzKOeXYFXAaBq6l87tkp5aFnew4Hv8bTWB77
         sj6r6hRumb2lwSfOwK/zzZjxgvV4IL26qR1XkhbFzQKEsROi6pzQXjIR4ac1hMlkMrSs
         CDLK9Yp2bS6ZObLPlesmSVI0comkfuMmhbParGMfzHplN1+29sQovxq4SNk/94uIK9Lb
         brwQ==
X-Gm-Message-State: AOAM533sgC+IedoSbT9BTOYoYCwo0PJJ6hV8Oc4qUSeIKruAKaFJQ9hw
        lgXzflCwsOZS0abVJFENerv9baMImg==
X-Google-Smtp-Source: ABdhPJzmfSedQhfz9hdWFPDdo0HdCe/x5hUoW2v0iXQTt5tVeO7NGY2OGlASjDWWq1NRcO+hSjNI+g==
X-Received: by 2002:a17:90b:618:: with SMTP id gb24mr5977912pjb.146.1612295744829;
        Tue, 02 Feb 2021 11:55:44 -0800 (PST)
Received: from ubuntu-vm.mshome.net ([131.107.160.234])
        by smtp.gmail.com with ESMTPSA id q126sm22919398pfb.111.2021.02.02.11.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 11:55:43 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     Steve French <smfrench@gmail.com>,
        Shyam Prasad N <nspmangalore@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs@vger.kernel.org
Cc:     Pavel Shilovsky <piastryyy@gmail.com>
Subject: [PATCH v2] CIFS: Wait for credits if at least one request is in flight
Date:   Tue,  2 Feb 2021 11:55:38 -0800
Message-Id: <20210202195538.243256-1-pshilov@microsoft.com>
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
 fs/cifs/transport.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 4ffbf8f965814..eab7940bfebef 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -659,10 +659,22 @@ wait_for_compound_request(struct TCP_Server_Info *server, int num,
 	spin_lock(&server->req_lock);
 	if (*credits < num) {
 		/*
-		 * Return immediately if not too many requests in flight since
-		 * we will likely be stuck on waiting for credits.
+		 * If the server is tight on resources or just gives us less
+		 * credits for other reasons (e.g. requests are coming out of
+		 * order and the server delays granting more credits until it
+		 * processes a missing mid) and we exhausted most available
+		 * credits there may be situations when we try to send
+		 * a compound request but we don't have enough credits. At this
+		 * point the client needs to decide if it should wait for
+		 * additional credits or fail the request. If at least one
+		 * request is in flight there is a high probability that the
+		 * server will return enough credits to satisfy this compound
+		 * request.
+		 *
+		 * Return immediately if no requests in flight since we will be
+		 * stuck on waiting for credits.
 		 */
-		if (server->in_flight < num - *credits) {
+		if (server->in_flight == 0) {
 			spin_unlock(&server->req_lock);
 			return -ENOTSUPP;
 		}
-- 
2.25.1

