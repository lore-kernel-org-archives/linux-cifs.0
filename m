Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E156AC7618B
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 11:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjCQLQA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 07:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQLPz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 07:15:55 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C294DBD0
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 04:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=AaQ2ehI8xzojdsdE7qs7SRgxVJu6qK7rBlsn99MWtAE=; b=DYUM9HlSQ4p1Xdew48KMh7C7I9
        PCYtDuh21MWXSyXAiWddJpZBeX7OvpMHg6TD4KH/wHZZ2CY06ch8M3iNcGqQZQaB7pFYC3vpgObeR
        y8RsKEFT26SmXlj/h8jtJvrj0fwj0E4dJMHtxbv7SRnQCOXh1b167xm3vLoWZgtx/WVU7ZXCsv4ku
        nd8c4Q1OqUr8iC87ifhxDWPK0pTIDyi8r9VlkuIG4tTlcl05BKSJUfCWjIbp6QZrzmZ5oUi4Buw5j
        3BISiRehvAlIjhIeuhzfvkvZKwkcI3rND307xFkUzI93LyBx5j/DHCHUQd2YQVI4GGKi0mLjYqnLG
        LA2yi6nHnMpD+CXzjJwK+qKBaS7FqTkC2NVUov3z5FuG3NjEvSQSMbV9zpH8d6RQMi6tVa0llqRbp
        3anjXfiBv29sQOwklxcDYMsMhCxY3ev7V/bRFeK09Lnw7Hgu3YUjelg7nclFVIn84X/q5qwoVpPyr
        UXmxx/pGHgx/hx1adgGKiaGU;
Received: from [2a01:4f8:252:410e::177:224] (port=37520 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pd83o-003p4x-Fn; Fri, 17 Mar 2023 11:15:48 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH 5/7] cifs: Avoid a cast in add_durable_v2_context()
Date:   Fri, 17 Mar 2023 11:15:26 +0000
Message-Id: <ba67f406d3ef0e125995902e7de5a59a70e5a193.1679051552.git.vl@samba.org>
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
 fs/cifs/smb2pdu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 91fc0ad3e1b4..6d4a14efa79f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2241,10 +2241,10 @@ create_reconnect_durable_v2_buf(struct cifs_fid *fid)
 }
 
 static int
-add_durable_v2_context(struct kvec *iov, unsigned int *num_iovec,
+add_durable_v2_context(struct smb2_create_req *req,
+		       struct kvec *iov, unsigned int *num_iovec,
 		    struct cifs_open_parms *oparms)
 {
-	struct smb2_create_req *req = iov[0].iov_base;
 	unsigned int num = *num_iovec;
 
 	iov[num].iov_base = create_durable_v2_buf(oparms);
@@ -2296,7 +2296,8 @@ add_durable_context(struct smb2_create_req *req,
 			return add_durable_reconnect_v2_context(iov, num_iovec,
 								oparms);
 		else
-			return add_durable_v2_context(iov, num_iovec, oparms);
+			return add_durable_v2_context(req, iov, num_iovec,
+						      oparms);
 	}
 
 	if (oparms->reconnect) {
-- 
2.30.2

