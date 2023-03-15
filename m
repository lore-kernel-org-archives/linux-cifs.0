Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD982C6FD1D
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Mar 2023 13:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjCONFz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Mar 2023 09:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbjCONFv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Mar 2023 09:05:51 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88736515E5
        for <linux-cifs@vger.kernel.org>; Wed, 15 Mar 2023 06:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=UlnvtVTzFExutVsAMVpB1aL+jRYagjdQDq/OUASBgP0=; b=fFWGdNCPJOc3oobed79IcDo7VA
        yQXFV8lojdkZ2I9AovKlEmXcNuoKGMF8L6yk0E9DrzBVsHGFlySXt9KCNFqbYhSNMM0dPD7JB7nyF
        xlkFyWvSKH0S6jo2ASC4LVQusp0pmLAm55WAvatLhkCApXbJO7PCoQPusPKp6xNtFUdcaCJx39ql2
        eTmRrNgWrDABJzVmnz1dUEhLeaw+e5RUAfCBjGlSEFukjjHTjfmwsHjvROPautlFFGhr6uadUckHz
        8k4TJskPfyWSClTr30BhIvZzTNcvgFcCEz7863JbpAYFAR0rCZCv2PfsgJYXBPTgxGWpFSU5gHSJ1
        5EbfwZqbHozMsJ4t2T20Qwqx65nE5PxX9cYxodI8Al+Jefpmetcn2qN8XenaIcB57dbJ63Fc4QnUj
        Itt7arcDHvl5XulqMFGA5tFTNbC0owf86y3O4HRsplvT34RXFVieNVzToo1hkldQBh8IQzzRUK5Ka
        y2L9uyobwasg6iHGOn3xIPLI;
Received: from [2a01:4f8:252:410e::177:224] (port=40716 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pcQp7-003KNd-EC; Wed, 15 Mar 2023 13:05:45 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 08/10] cifs: Avoid two "else" branches
Date:   Wed, 15 Mar 2023 13:05:29 +0000
Message-Id: <89a7deedf5ab90f9247f0a3a26ac3ed9efb2c588.1678885349.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1678885349.git.vl@samba.org>
References: <cover.1678885349.git.vl@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We goto out of the if-branches, this makes the flow easier to read

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index dede2d422c1f..14b909b2348b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2997,11 +2997,13 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 			tcon->need_reconnect = true;
 		}
 		goto creat_exit;
-	} else if (rsp == NULL) /* unlikely to happen, but safer to check */
+	}
+
+	if (rsp == NULL) /* unlikely to happen, but safer to check */
 		goto creat_exit;
-	else
-		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
-				     oparms->create_options, oparms->desired_access);
+
+	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
+			     oparms->create_options, oparms->desired_access);
 
 	atomic_inc(&tcon->num_remote_opens);
 	oparms->fid->persistent_fid = rsp->PersistentFileId;
-- 
2.30.2

