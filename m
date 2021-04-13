Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FD6C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Apr 2021 23:26:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3680160C3D
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Apr 2021 23:26:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243606AbhDMX01 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Apr 2021 19:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbhDMX01 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Apr 2021 19:26:27 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76850C061574;
        Tue, 13 Apr 2021 16:26:06 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id p6so11321204wrn.9;
        Tue, 13 Apr 2021 16:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Bem/p08va+1GAFuU0LTGSjQYRLOf3cmGSRP+mg48WO0=;
        b=gAqek3+Yxs0T57tuh7TxH8pYNNFco4ooq3u47xzORW4+3k4dxKScnRb94m07lXJCtO
         6vFgbKDUAWkL89ldu90rjm/qlqvsLT9aWhEsUOHfmXov+derlxr6OD/wSU6XClgxUwva
         PP/EvYvowS8l1ypyIXJGs0Lb+VonygfGkLobJnS+1tMfAm88B1h8Bmq6gFDW9HGOM6wp
         kjeQO9YH67vIxh/c1lKVQKqEDSY94PEE+kJ4xNPV9c2M8u0QtLcjDjHS3hiXrgSdCYUA
         4W0WdSCxX6qdlMMhVQW7rX+QILvwn4qtFBGRbRZQg3Mzcg8ITYVTZ0w1xPGLnlcX1uUd
         OpKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Bem/p08va+1GAFuU0LTGSjQYRLOf3cmGSRP+mg48WO0=;
        b=cghuq1j2VeGcGhWfLFVMeW2JaQ6rNGH1OULgoIdO8M5bKYH0pgiVQHD0M8RkGxaZmg
         9MI3Su2n87CfCR9mYnQHP3TOBcG7AvMUPMBunwTsPyXm+OJZda+6HpC6ByTyCFYEOI4a
         opIBxUvXXj1ZXLIQSauEc5j5OrhRkMvreZq74y5WxwY2E+Ycdn8f7xqrlirEj+nSD+7m
         kkUJPdgzRJnkT50a0+sxK9VJFhDPZ6potafd/rXq/Wzy/LmVkKi3HudDKoIbnMGjqUxB
         NWwsCD8je/KFq420t2Jhf9NnFQdheyQWak4hiTxlcr1sfw2Pg9yCg3QNgnAIBz/orsYf
         aKpA==
X-Gm-Message-State: AOAM531G2IAWVksLHutDVdwHQY9Xkdg29nz+P9Pg4mXuT9mXn4yaAijb
        42bpbf3sv8bWy9uuTohtnkg=
X-Google-Smtp-Source: ABdhPJxpNylQxNyIvvIYwWjESkNUS14wxwP2YXsCfk6lD56i2MYhY+u38RHgySVHjDRdkUek/6oOgQ==
X-Received: by 2002:adf:f250:: with SMTP id b16mr10066858wrp.347.1618356364056;
        Tue, 13 Apr 2021 16:26:04 -0700 (PDT)
Received: from LEGION ([39.46.65.172])
        by smtp.gmail.com with ESMTPSA id i12sm1504831wmd.3.2021.04.13.16.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 16:26:03 -0700 (PDT)
Date:   Wed, 14 Apr 2021 04:25:58 +0500
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <linux-cifs@vger.kernel.org>,
        "moderated list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <samba-technical@lists.samba.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     musamaanjum@gmail.com, kernel-janitors@vger.kernel.org,
        dan.carpenter@oracle.com, colin.king@canonical.com
Subject: [PATCH] cifs: remove unnecessary copies of tcon->crfid.fid
Message-ID: <20210413232558.GA1136036@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

pfid is being set to tcon->crfid.fid and they are copied in each other
multiple times. Remove the memcopy between same pointers.

Addresses-Coverity: ("Overlapped copy")
Fixes: 9e81e8ff74b9 ("cifs: return cached_fid from open_shroot")
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
---
I'm not sure why refcount was being incremented here. This file has been
evoloved so much. Any ideas?

fs/cifs/smb2ops.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 61214b23c57f..6fa35003dcfe 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -847,14 +847,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 			.volatile_fid = pfid->volatile_fid,
 		};
 
-		/*
-		 * caller expects this func to set pfid to a valid
-		 * cached root, so we copy the existing one and get a
-		 * reference.
-		 */
-		memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
-		kref_get(&tcon->crfid.refcount);
-
 		mutex_unlock(&tcon->crfid.fid_mutex);
 
 		if (rc == 0) {
@@ -885,7 +877,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
 	tcon->crfid.tcon = tcon;
 	tcon->crfid.is_valid = true;
 	tcon->crfid.dentry = dentry;
-- 
2.25.1

