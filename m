Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801EFC6FD1D
	for <linux-cifs@archiver.kernel.org>; Tue,  4 Apr 2023 19:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235711AbjDDTAL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 4 Apr 2023 15:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235984AbjDDTAK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 4 Apr 2023 15:00:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A641597
        for <linux-cifs@vger.kernel.org>; Tue,  4 Apr 2023 11:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680634764;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=6W0xzD/aChfysShRb/0ZKMoLOy4vn7cZgUPoeAGGEYw=;
        b=N4XY7/oVa3r7eJLBPp+PbJtgc22q7G5aOGk6jRPeu9/BQTDUKn5oGKzAEU9Zak7314bB70
        +DIQEGpF8y11MLXFDMaaFbZb0Q0EeKRSmjeFAINITtLIMZvbwbVXmJQcmryRvLzyN1Ebl8
        wKaw2cKIqMr1/3oRHQSPdLeDrjzbEys=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-498-EnDqV-tqMjCxCackCx-rbw-1; Tue, 04 Apr 2023 14:59:21 -0400
X-MC-Unique: EnDqV-tqMjCxCackCx-rbw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9DC728996E2;
        Tue,  4 Apr 2023 18:59:19 +0000 (UTC)
Received: from nyarly.com (ovpn-116-59.gru2.redhat.com [10.97.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 637791121314;
        Tue,  4 Apr 2023 18:59:15 +0000 (UTC)
From:   Thiago Becker <tbecker@redhat.com>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org
Cc:     pc@cjr.nz, lsahlber@redhat.com, sprasad@microsoft.com,
        tom@talpey.com, trbecker@gmail.com,
        samba-technical@lists.samba.org, Thiago Becker <tbecker@redhat.com>
Subject: [PATCH] cifs: sanitize paths in cifs_update_super_prepath.
Date:   Tue,  4 Apr 2023 15:59:08 -0300
Message-Id: <20230404185908.993738-1-tbecker@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

After a server reboot, clients are failing to move files with ENOENT.
This is caused by DFS referrals containing multiple separators, which
the server move call doesn't recognize.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=2182472
Fixes: a31080899d5f ("cifs: sanitize multiple delimiters in prepath")
Actually-Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Thiago Rafael Becker <tbecker@redhat.com>
---
 fs/cifs/fs_context.c | 6 +++---
 fs/cifs/misc.c       | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 6d13f8207e96a..c4d9139b89d29 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -445,7 +445,7 @@ int smb3_parse_opt(const char *options, const char *key, char **val)
  * cleaning up the original.
  */
 #define IS_DELIM(c) ((c) == '/' || (c) == '\\')
-static char *sanitize_path(char *path)
+char *sanitize_path(char *path, gfp_t gfp)
 {
 	char *cursor1 = path, *cursor2 = path;
 
@@ -469,7 +469,7 @@ static char *sanitize_path(char *path)
 		cursor2--;
 
 	*(cursor2) = '\0';
-	return kstrdup(path, GFP_KERNEL);
+	return kstrdup(path, gfp);
 }
 
 /*
@@ -531,7 +531,7 @@ smb3_parse_devname(const char *devname, struct smb3_fs_context *ctx)
 	if (!*pos)
 		return 0;
 
-	ctx->prepath = sanitize_path(pos);
+	ctx->prepath = sanitize_path(pos, GFP_KERNEL);
 	if (!ctx->prepath)
 		return -ENOMEM;
 
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b44fb51968bfb..e6f208110de83 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1190,12 +1190,14 @@ int match_target_ip(struct TCP_Server_Info *server,
 	return 0;
 }
 
+extern char *sanitize_path(char *path, gfp_t gfp);
+
 int cifs_update_super_prepath(struct cifs_sb_info *cifs_sb, char *prefix)
 {
 	kfree(cifs_sb->prepath);
 
 	if (prefix && *prefix) {
-		cifs_sb->prepath = kstrdup(prefix, GFP_ATOMIC);
+		cifs_sb->prepath = sanitize_path(prefix, GFP_ATOMIC);
 		if (!cifs_sb->prepath)
 			return -ENOMEM;
 
-- 
2.39.2

