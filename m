Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B78D7C32793
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 17:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbjARRHW (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 12:07:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbjARRHR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 12:07:17 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 144FF58290
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 09:07:03 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C87C65C179;
        Wed, 18 Jan 2023 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674061621; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=UYb1WqyNh7lPmAr1+XJFHrMG3xp/7GsiHoqidOc+NxQ=;
        b=lx9B+Qg5BWEQRu0k1XDrNYVwGjx/6/5NPkEMEFzC/2nhkKRotKU0PLUXrxzwuYhptoLx1F
        pFLvBaBIr7zzcsdHO7I/9WPuL4AE/4ew64nrsVVVaKiTvVOoiDXs+6PLpCdXL5QtVZxUeJ
        ZeTBy7zL/58upeZE8biPmjDD7drKVBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674061621;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=UYb1WqyNh7lPmAr1+XJFHrMG3xp/7GsiHoqidOc+NxQ=;
        b=SMxq/+aIK7yfDQo8L4FYP5YKR6XjkCab5/80mWmABvYN2G9ngboqPhNTvBpoJDUHb/gRVk
        tRg831oY1t0biSDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 513D3138FE;
        Wed, 18 Jan 2023 17:07:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hM43BjUnyGNDPgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 18 Jan 2023 17:07:01 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
Subject: [PATCH] cifs: do not include page data when checking signature
Date:   Wed, 18 Jan 2023 14:06:57 -0300
Message-Id: <20230118170657.17585-1-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On async reads, page data is allocated before sending.  When the
response is received but it has no data to fill (e.g.
STATUS_END_OF_FILE), __calc_signature() will still include the pages in
its computation, leading to an invalid signature check.

This patch fixes this by not setting the async read smb_rqst page data
(zeroed by default) if its got_bytes is 0.

This can be reproduced/verified with xfstests generic/465.

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 fs/cifs/smb2pdu.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4b71f4a92f76..2c9ffa921e6f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4163,12 +4163,15 @@ smb2_readv_callback(struct mid_q_entry *mid)
 				(struct smb2_hdr *)rdata->iov[0].iov_base;
 	struct cifs_credits credits = { .value = 0, .instance = 0 };
 	struct smb_rqst rqst = { .rq_iov = &rdata->iov[1],
-				 .rq_nvec = 1,
-				 .rq_pages = rdata->pages,
-				 .rq_offset = rdata->page_offset,
-				 .rq_npages = rdata->nr_pages,
-				 .rq_pagesz = rdata->pagesz,
-				 .rq_tailsz = rdata->tailsz };
+				 .rq_nvec = 1, };
+
+	if (rdata->got_bytes) {
+		rqst.rq_pages = rdata->pages;
+		rqst.rq_offset = rdata->page_offset;
+		rqst.rq_npages = rdata->nr_pages;
+		rqst.rq_pagesz = rdata->pagesz;
+		rqst.rq_tailsz = rdata->tailsz;
+	}
 
 	WARN_ONCE(rdata->server != mid->server,
 		  "rdata server %p != mid server %p",
-- 
2.35.3

