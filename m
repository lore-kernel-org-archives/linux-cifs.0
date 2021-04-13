Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3E6C433ED
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Apr 2021 21:31:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4ED05611F0
	for <linux-cifs@archiver.kernel.org>; Tue, 13 Apr 2021 21:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhDMVbr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhDMVbq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 13 Apr 2021 17:31:46 -0400
X-Greylist: delayed 339 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 13 Apr 2021 14:31:26 PDT
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962D5C061574
        for <linux-cifs@vger.kernel.org>; Tue, 13 Apr 2021 14:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
 d=darkrain42.org; i=@darkrain42.org; q=dns/txt; s=ed25519-2020-12;
 t=1618349147; h=from : to : cc : subject : date : message-id :
 mime-version : content-transfer-encoding : from;
 bh=INSjkgplWP499f+foXGMrXcO4msoz7Ierugs0n5Wp58=;
 b=RlBS28IGRZK+TMm8UzHtB5vdD6VuoI1svhFWHN2yOdmOEdnHNA0dKMha+SSbj9l4UUIMf
 xLtJvknxExgO/9EAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org;
 i=@darkrain42.org; q=dns/txt; s=rsa-2020-12; t=1618349147; h=from : to
 : cc : subject : date : message-id : mime-version :
 content-transfer-encoding : from;
 bh=INSjkgplWP499f+foXGMrXcO4msoz7Ierugs0n5Wp58=;
 b=hn98JrSiNFHclugsyYWGlNFwhTCGkwiDv6NrCiyNk7vKKAjQ7VCpnd7zYCYeOI4M3Pd8P
 bmZqTp4fEKh/uOzc1gyEBojLKCh3h4zht/ow2uIvF+k1T0GaD+uevLNsOhkT/pXft+UOJgk
 a7MUy4qMQPRkKEidD/ymbOK0Arn2piSQwHQ46aI0B5MU0wHaeM2FegFc965GebeAUwRVR9i
 4jz0bYzpdg062ULEQJH6iOrLcusroGU/Yf8WRaswC2OnC0ISANnV/+ubanTc2A4IJrWkVwP
 pWlmvTylrbJtOjf/ZnbTkbZRndgOldREAPzT0l+KzoPGiccYKTYBEfe3BT7A==
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id CD74E80F9;
        Tue, 13 Apr 2021 14:25:46 -0700 (PDT)
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org
Subject: [PATCH] cifs: Return correct error code from smb2_get_enc_key
Date:   Tue, 13 Apr 2021 14:25:27 -0700
Message-Id: <20210413212527.473765-1-paul@darkrain42.org>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Avoid a warning if the error percolates back up:

[440700.376476] CIFS VFS: \\otters.example.com crypt_message: Could not get encryption key
[440700.386947] ------------[ cut here ]------------
[440700.386948] err = 1
[440700.386977] WARNING: CPU: 11 PID: 2733 at /build/linux-hwe-5.4-p6lk6L/linux-hwe-5.4-5.4.0/lib/errseq.c:74 errseq_set+0x5c/0x70
...
[440700.397304] CPU: 11 PID: 2733 Comm: tar Tainted: G           OE     5.4.0-70-generic #78~18.04.1-Ubuntu
...
[440700.397334] Call Trace:
[440700.397346]  __filemap_set_wb_err+0x1a/0x70
[440700.397419]  cifs_writepages+0x9c7/0xb30 [cifs]
[440700.397426]  do_writepages+0x4b/0xe0
[440700.397444]  __filemap_fdatawrite_range+0xcb/0x100
[440700.397455]  filemap_write_and_wait+0x42/0xa0
[440700.397486]  cifs_setattr+0x68b/0xf30 [cifs]
[440700.397493]  notify_change+0x358/0x4a0
[440700.397500]  utimes_common+0xe9/0x1c0
[440700.397510]  do_utimes+0xc5/0x150
[440700.397520]  __x64_sys_utimensat+0x88/0xd0

Fixes: 61cfac6f267d ("CIFS: Fix possible use after free in demultiplex thread")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: stable@vger.kernel.org
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 61214b23c57f..caa5432a5ed1 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4418,7 +4418,7 @@ smb2_get_enc_key(struct TCP_Server_Info *server, __u64 ses_id, int enc, u8 *key)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	return 1;
+	return -ENOENT;
 }
 /*
  * Encrypt or decrypt @rqst message. @rqst[0] has the following format:
-- 
2.31.0

