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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A916C433ED
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Apr 2021 15:24:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D9426115C
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Apr 2021 15:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233769AbhDOPYm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Apr 2021 11:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbhDOPYk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 15 Apr 2021 11:24:40 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F84EC061574;
        Thu, 15 Apr 2021 08:24:16 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id g9so7685069wrx.0;
        Thu, 15 Apr 2021 08:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=voeJtF0iw8AB6pNUld2TDfbtXFa8dqqEzyxFckRdXOI=;
        b=amC4xfPIXhPVxoPeNRRvDvgG212ZOtwtCi2v9kHS1fsEz3e8nTF+7dIHJgx9fVIj5p
         TCq28oputVumoxVS5SVLX9NQQN8hhOToOvI0BeWjIZafK+dPPW47J5g2F8AW1zuvIB2x
         i4ITVVeh7xecIrzYsGzJbwo/gyAC0zsfkEEkn7x7gp0zvxEE+36BdSvdCE+k7zcYJvHe
         CBFez1m5qhooAn+jGrjr6gGoYbEyhMX4xHq25ud1tYvNNDDqkc7kFKeC3HiOxMdW5Kwa
         pkAjt8glG3JEseBGIJwXrLqtEzoPvZcoz/KaFyRvJFqCuMGa9gVVcYmZ++/fXYvyf47G
         JLoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=voeJtF0iw8AB6pNUld2TDfbtXFa8dqqEzyxFckRdXOI=;
        b=U+HJGV4fjmLa91W6Wme04ALhLlZ8Jpt1E40zQA4frrwmCz4FOvrLYq4hBQty47jHjr
         iur2ImY9oDCZFQt1AHyR3S1EgHhE3umJECZ+5MQXhw3vMIcVHPhw/uwLlSUch1u2TwyQ
         KXvLtyAYziAcIhx1WAA/oOZiLci/+iIyhpg5niLoYLIP10JZIrC/kIPwSmaV1ZcfY6W1
         +ThB3+hOe8w+56eOA8xDPTDrxYRFE56fGqMLeoEoTTQpvs6AQEwq+4+P5AkocxBeeEhi
         OcyggucL0iSUbr+52YtstaeAvAxLW8jM5gKJHMgXwnLkTh6vHQ9RL9gMMKBuka3t+QKl
         aydg==
X-Gm-Message-State: AOAM532l6ovQ6Et2AdnU8FfZjFU6TWNhgZrEZMNAsro3HYSLXQNNEj+m
        4ciEGWgYgeXZPUS+/MJfT6I=
X-Google-Smtp-Source: ABdhPJyeevuUpEi01PNTMCOO6gu8n0VGBAdrqzla0ocnKObhmU+PM35BoMw/AgkZWdFvn2/7M10BYw==
X-Received: by 2002:adf:cf09:: with SMTP id o9mr4195683wrj.366.1618500255010;
        Thu, 15 Apr 2021 08:24:15 -0700 (PDT)
Received: from LEGION ([39.46.65.172])
        by smtp.gmail.com with ESMTPSA id c16sm4577954wrs.81.2021.04.15.08.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 08:24:14 -0700 (PDT)
Date:   Thu, 15 Apr 2021 20:24:09 +0500
From:   Muhammad Usama Anjum <musamaanjum@gmail.com>
To:     aaptel@suse.com, Steve French <sfrench@samba.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        "open list:COMMON INTERNET FILE SYSTEM CLIENT (CIFS)" 
        <linux-cifs@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     musamaanjum@gmail.com, kernel-janitors@vger.kernel.org,
        dan.carpenter@oracle.com, colin.king@canonical.com
Subject: [PATCH v2] cifs: remove unnecessary copies of tcon->crfid.fid
Message-ID: <20210415152409.GA2286719@LEGION>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

pfid is being set to tcon->crfid.fid and they are copied in each other
multiple times. Remove the memcopy between same pointers - memory
locations.

Addresses-Coverity: ("Overlapped copy")
Fixes: 9e81e8ff74b9 ("cifs: return cached_fid from open_shroot")
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
---
Changes in V2:
	refcount increment is necessary. Don't remove it.
	Add and improve comments.

fs/cifs/smb2ops.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index caa5432a5ed1..797a20714ca1 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -848,11 +848,9 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		};
 
 		/*
-		 * caller expects this func to set pfid to a valid
-		 * cached root, so we copy the existing one and get a
-		 * reference.
+		 * caller expects this func to set the fid in crfid to valid
+		 * cached root, so increment the refcount.
 		 */
-		memcpy(pfid, tcon->crfid.fid, sizeof(*pfid));
 		kref_get(&tcon->crfid.refcount);
 
 		mutex_unlock(&tcon->crfid.fid_mutex);
@@ -885,7 +883,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->mid = le64_to_cpu(o_rsp->sync_hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	memcpy(tcon->crfid.fid, pfid, sizeof(struct cifs_fid));
 	tcon->crfid.tcon = tcon;
 	tcon->crfid.is_valid = true;
 	tcon->crfid.dentry = dentry;
@@ -894,6 +891,10 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 
 	/* BB TBD check to see if oplock level check can be removed below */
 	if (o_rsp->OplockLevel == SMB2_OPLOCK_LEVEL_LEASE) {
+		/*
+		 * caller expects this func to set the fid in crfid to valid
+		 * cached root, so increment the refcount.
+		 */
 		kref_get(&tcon->crfid.refcount);
 		tcon->crfid.has_lease = true;
 		smb2_parse_contexts(server, o_rsp,
-- 
2.25.1

