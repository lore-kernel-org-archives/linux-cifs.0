Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6371C761A6
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 11:16:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCQLQC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCQLP5 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 07:15:57 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46E9F442EA
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 04:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=QiQkInIdAMivDawkI7nXi9zVQPJVBBtqwak6lqEcqDg=; b=wJxa4dS1oSBVd20LienN9OgHIY
        1Ff/ZOCNVOV7pIjRWPDxgvEGVyXy4TP4GjaJxDK2hB3DoVL++w8xzpP4nt6GxJnpwKeC9vFGfIwfk
        2LBcUM5l3nTTatUQQsci86zl80dT0sHH1RmkPfzKB9tFW9OgUfw+jcizijT6DlfRYqhTfTtLollsT
        HXnuYbjof2j6ryj+H0IDymdttKEUbQnESQEuX4uxmvuW+evzNQzwgZaaECHkDMEA1L2VHne4VSIIu
        xIQNBmZLRTbWeLordFlrIV8hWweuVWvBgNyerKfDmjNZibcWweZXtKCZKtHH++nZNn8leWU0zoC2N
        dAsrCXPVIHzrU/8SK6JxVuyTcfzACz9DOEpqL88z1JWDE5isVZxU8qg83pUQPvtzANlKGIFOeQPDu
        s909moXHYKXk/o40APvN3m1jNJDaRSv0iqsIRLDCzKQ6u3U+BOSWi+J7hMVFNQiyg4EB01IRfJubn
        954u7brgUDehJ1MyUC4iIOED;
Received: from [2a01:4f8:252:410e::177:224] (port=37520 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pd83o-003p4x-CI; Fri, 17 Mar 2023 11:15:48 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 4/7] cifs: Avoid a cast in add_sd_context()
Date:   Fri, 17 Mar 2023 11:15:25 +0000
Message-Id: <8d0f4a2c9c860a89bde3d172bd5fccbdbc26b8bb.1679051552.git.vl@samba.org>
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
 fs/cifs/smb2pdu.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6b6790d8d0ee..91fc0ad3e1b4 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2344,9 +2344,9 @@ create_twarp_buf(__u64 timewarp)
 
 /* See MS-SMB2 2.2.13.2.7 */
 static int
-add_twarp_context(struct kvec *iov, unsigned int *num_iovec, __u64 timewarp)
+add_twarp_context(struct smb2_create_req *req,
+		  struct kvec *iov, unsigned int *num_iovec, __u64 timewarp)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = create_twarp_buf(timewarp);
@@ -2478,9 +2478,10 @@ create_sd_buf(umode_t mode, bool set_owner, unsigned int *len)
 }
 
 static int
-add_sd_context(struct kvec *iov, unsigned int *num_iovec, umode_t mode, bool set_owner)
+add_sd_context(struct smb2_create_req *req,
+	       struct kvec *iov, unsigned int *num_iovec, umode_t mode,
+	       bool set_owner)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 	unsigned int len = 0;
 
@@ -2877,7 +2878,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 				cpu_to_le32(iov[n_iov-1].iov_len);
 		}
 
-		rc = add_twarp_context(iov, &n_iov, tcon->snapshot_time);
+		rc = add_twarp_context(req, iov, &n_iov, tcon->snapshot_time);
 		if (rc)
 			return rc;
 	}
@@ -2907,7 +2908,8 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 			}
 
 			cifs_dbg(FYI, "add sd with mode 0x%x\n", oparms->mode);
-			rc = add_sd_context(iov, &n_iov, oparms->mode, set_owner);
+			rc = add_sd_context(req, iov, &n_iov, oparms->mode,
+					    set_owner);
 			if (rc)
 				return rc;
 		}
-- 
2.30.2

