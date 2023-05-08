Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C8CC7EE22
	for <linux-cifs@archiver.kernel.org>; Mon,  8 May 2023 19:02:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232904AbjEHTCP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 May 2023 15:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjEHTCO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 May 2023 15:02:14 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AA230D0
        for <linux-cifs@vger.kernel.org>; Mon,  8 May 2023 12:02:13 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id 5614622812f47-39212bf4ff0so2679618b6e.1
        for <linux-cifs@vger.kernel.org>; Mon, 08 May 2023 12:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683572533; x=1686164533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eHISTIijKiO7qTvueZQ0jvWOQjuA2ouzTWltDImRA+E=;
        b=igkUam6Z6+b9N1Th60rjTxyFvC8B1XI4e0aW1oaw0J3KQTKsQ01CkLs3pfEJ9cSXLo
         GjadFr7qKhQUSK8qaxUnLe1YfVZ5fTZX/+6OtVWbfRInuK2zNPaujxeokeYBWwwJaJDb
         0ZR/1s6phNGmKQOeVZUOJs5aawqRt/IjiBAk6d+BMnxgy/vpCag/WUbVXh4y9O97844z
         jxCr7hwQYGx1Rj9R3Aam31Z5pxTDqV1WSp7mF5VNyQGp+McYxaF/6yWDb42Pc1Qf/IA2
         YvbXo6QKroIxH7qhcb4bk7YzfMxspC045+XJ7L8gWixgDvDPFDq9CuRhjFJUVJS92Zrx
         nE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683572533; x=1686164533;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eHISTIijKiO7qTvueZQ0jvWOQjuA2ouzTWltDImRA+E=;
        b=X5KxaQgWMbUr/DrYgsjGf1RZ754pwgYgXb0gpa9vdK2531TqyXlZlKuakBn9y1jzMW
         cvtZM1b761W1H4EITcUNk2ALHiyze6Z52rB+5wGbkv9BDDkIKTkRsY8kdrydWgT4rZ+j
         qan/o7+LtjlWexj5cP/UaInkMRzKU042j8gSBHTXvDg32TV1/ZYfRl1dcvaHgo2Nm7ld
         pru6DaJWKUvscKXIH45hYzun7q8B//loDOGNnyCbZPJmVHTBcUzJW1Swpn5jMJPeq3jw
         OefEjQM9ARC1O9ccgknjltzw3wBYXYc13uqCggA/X+l7HcaKi0WlQOTatUdR5uA4v6Sw
         RaNw==
X-Gm-Message-State: AC+VfDyIspOPDfpdPX1kYFjgKRwsWmwa8AUhIsK/XiWjkcU22/QkGIdP
        8zgdrdzYbXEGbt8vdHyQ6Qw=
X-Google-Smtp-Source: ACHHUZ6CroruTIoYesraItSitbvQRGtriUctI4t0kNBS3TR5ALjlWz6arMlzG95bz6xWn19Wbt4Eag==
X-Received: by 2002:a05:6808:614d:b0:392:6077:e36e with SMTP id dl13-20020a056808614d00b003926077e36emr50652oib.44.1683572532637;
        Mon, 08 May 2023 12:02:12 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id p12-20020ae9f30c000000b007576f08d3afsm1548697qkg.111.2023.05.08.12.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 12:02:12 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
To:     pc@cjr.nz, sfrench@samba.org, lsahlber@redhat.com,
        nspmangalore@gmail.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Bharath SM <bharathsm.hsk@gmail.com>,
        Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] SMB3: Close all deferred handles of inode in case of handle lease break
Date:   Mon,  8 May 2023 19:01:03 +0000
Message-Id: <20230508190103.601678-1-bharathsm.hsk@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Oplock break may occur for different file handle than the deferred handle.
Check for inode deferred closes list, if it's not empty then close all the
deferred handles of inode.

Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferred close handles for the same file.")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/cifs/file.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 791a12575109..260d5ec878e8 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -4886,8 +4886,6 @@ void cifs_oplock_break(struct work_struct *work)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
-	struct cifs_deferred_close *dclose;
-	bool is_deferred = false;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -4928,14 +4926,9 @@ void cifs_oplock_break(struct work_struct *work)
 	 * file handles but cached, then schedule deferred close immediately.
 	 * So, new open will not use cached handle.
 	 */
-	spin_lock(&CIFS_I(inode)->deferred_lock);
-	is_deferred = cifs_is_deferred_close(cfile, &dclose);
-	spin_unlock(&CIFS_I(inode)->deferred_lock);
 
-	if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
-			cfile->deferred_close_scheduled && delayed_work_pending(&cfile->deferred)) {
+	if (!CIFS_CACHE_HANDLE(cinode) && !list_empty(&cinode->deferred_closes))
 		cifs_close_deferred_file(cinode);
-	}
 
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
-- 
2.34.1

