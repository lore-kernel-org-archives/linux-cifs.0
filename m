Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58013C74A5B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 11:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjCQLQB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjCQLPz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 07:15:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5DD5FEB
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 04:15:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=S+KORE2Zpa300f7YKiwwFzJhDSXNzdqgEmQ6HLKzXIc=; b=tIWkKwtpWE5h8e93bxec91c53c
        m15LBQzPl5dewalS2FLJia/EKljXpVKj5zRLcb33MJKKcW8zBFBWQTvSRVUkoh60qu+7aptxZlpNA
        azhWeha5QgS6HiAJminvZmVW0tJS8YCBGuAQREu+ElYRV9/+VHs9URwpGM+i3fqohEbGhVzFbaJdJ
        qQdK9NuW+cVVVKPIYltmnZ+O3jUqQ0MhHyu0x4S4h6XlFxyPjo0TGBS8OZgtP5GZAsRu7rD6DJaN5
        vUZAnD+dalZOz6W026/yiqn3svlPI0qeLdoWrIqwGLMGYKSlEvTCzx/MitvVzSrMidpxD2fQmcgMg
        w6vfZTZ2bRWV9zQWr1/zRZ0BuZyb8zzvUSPHATvBSqI698reWVPA9eHQeuRXIctSiQN4Cae9fE1mn
        RmBU0ez9ry3u5t5kN23fVNe1RtXcqXB0rHuhdCh/V+u2pMmGG5JLz3dZTQheShRZ1z4gTxMNWjNnX
        dghXoXK0XhZUgBBU7KVWn6HM;
Received: from [2a01:4f8:252:410e::177:224] (port=37520 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pd83n-003p4x-Vc; Fri, 17 Mar 2023 11:15:48 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 2/7] cifs: Avoid a cast in add_durable_context()
Date:   Fri, 17 Mar 2023 11:15:23 +0000
Message-Id: <01742c6a372345dce723d3511a41d21753b8aeee.1679051552.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1679051552.git.vl@samba.org>
References: <cover.1679051552.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We have the correctly-typed struct smb2_create_req * available in the
caller.

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 3eb745237459..cebb8d9837d2 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2285,10 +2285,10 @@ add_durable_reconnect_v2_context(struct kvec *iov, unsigned int *num_iovec,
 }
 
 static int
-add_durable_context(struct kvec *iov, unsigned int *num_iovec,
+add_durable_context(struct smb2_create_req *req,
+		    struct kvec *iov, unsigned int *num_iovec,
 		    struct cifs_open_parms *oparms, bool use_persistent)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	if (use_persistent) {
@@ -2849,7 +2849,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 				cpu_to_le32(server->vals->create_lease_size);
 		}
 
-		rc = add_durable_context(iov, &n_iov, oparms,
+		rc = add_durable_context(req, iov, &n_iov, oparms,
 					tcon->use_persistent);
 		if (rc)
 			return rc;
-- 
2.30.2

