Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A750C636CC
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 16:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjAaQWU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Jan 2023 11:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjAaQWT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Jan 2023 11:22:19 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA6430F3
        for <linux-cifs@vger.kernel.org>; Tue, 31 Jan 2023 08:22:18 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 355B87FEB4;
        Tue, 31 Jan 2023 16:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1675182134;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=c4mZFlqvSUhLIwwyWCoc7WKkJ8wgJRNy/P34hnovpXc=;
        b=AaIV4CEMONQM2ghZEJYU15IqiPcnOYQ9s1q4qW0q1Q1WIGksK9yLyEtWrS70v2THYXfMN7
        twlzM3x6VDqB7rZ/BSIDB22oQ5BSy2lneVbZ0zgCPm6oOKVyWMRQDpDFF5YM1tiI/eV6Fg
        KHtKMWuEjAMn0jrC3/gz7ae2ePInEAibniBBzgFVnR2A5+BDaR1HvPpR7SxvmadxHdYzbD
        xvvE4ZCPHJ96RPJ3FjdVCVa/9MtSlElxauVP/JDlVxyyQVixffVh3gNgUy1IPN/6DugIL8
        V0/tzBTVyK30Jr5n+KAitmyliVdeCvSZGx1LTq/Z3Mpw4r+/Iejmdq7KfmPK2g==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: get rid of unneeded conditional in cifs_get_num_sgs()
Date:   Tue, 31 Jan 2023 13:22:07 -0300
Message-Id: <20230131162207.3511-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Just have @skip set to 0 after first iterations of the two nested
loops.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsglob.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 3da302ea9d76..1d893bea4723 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -2164,6 +2164,12 @@ static inline unsigned int cifs_get_num_sgs(const struct smb_rqst *rqst,
 	unsigned long addr;
 	int i, j;
 
+	/*
+	 * The first rqst has a transform header where the first 20 bytes are
+	 * not part of the encrypted blob.
+	 */
+	skip = 20;
+
 	/* Assumes the first rqst has a transform header as the first iov.
 	 * I.e.
 	 * rqst[0].rq_iov[0]  is transform header
@@ -2171,14 +2177,9 @@ static inline unsigned int cifs_get_num_sgs(const struct smb_rqst *rqst,
 	 * rqst[1+].rq_iov[0+] data to be encrypted/decrypted
 	 */
 	for (i = 0; i < num_rqst; i++) {
-		/*
-		 * The first rqst has a transform header where the
-		 * first 20 bytes are not part of the encrypted blob.
-		 */
 		for (j = 0; j < rqst[i].rq_nvec; j++) {
 			struct kvec *iov = &rqst[i].rq_iov[j];
 
-			skip = (i == 0) && (j == 0) ? 20 : 0;
 			addr = (unsigned long)iov->iov_base + skip;
 			if (unlikely(is_vmalloc_addr((void *)addr))) {
 				len = iov->iov_len - skip;
@@ -2187,6 +2188,7 @@ static inline unsigned int cifs_get_num_sgs(const struct smb_rqst *rqst,
 			} else {
 				nents++;
 			}
+			skip = 0;
 		}
 		nents += rqst[i].rq_npages;
 	}
-- 
2.39.1

