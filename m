Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 763D9C6FD1D
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Mar 2023 16:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjCQQnQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Mar 2023 12:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjCQQnN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Mar 2023 12:43:13 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009128735C
        for <linux-cifs@vger.kernel.org>; Fri, 17 Mar 2023 09:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=KGdkQ2QHsXAcNFVHTJz2bvfdT+IWSrZAfEnaRhDehlI=; b=1B3LS0F/oQJzc7ztVCJkwvCKQe
        m1yj9NSO0PBw+gbLPJRYqjHXrdlsla2HIQRi8lYrILJdxkCbcaustO/Lxdv7M3mxPlvXMWRBf0oV9
        g54RunSq+9COCt/pmuqhErviivCVOOzi90a8d+D+K7Da/mWHoIHSrPB2wXjXACTmatr3OvdPpgu7X
        zz3mmmIjx/7vpkbTt1X66Er/3KMyTEHBAfN2yGFrrqjMmgfGenX9DxXK4QwPmzOWxPBa0/vbFVvAM
        I0s4qJlHsI1MHnBHBWbWY4LtpcM/RBEfMR12xfFWLRFkoWPkHz9t+8mJoyGwkfRvsfwoIrMs2DFx4
        jvk8Qgkt2uYbUp3RPwuoHIqbxrLq2pDvSpSXLJZmJ0wft53+WmCLe1EPrt9+EWa0RvWcB+0rxrFbz
        0XIO+u5rGyu/QSMGBfGrf44bCTg6wkI/l+VXg4CuRklkxQBnj4OQXibodNLmMHCk3E/cm/7IGtHaq
        plVXp/h0kykMlIKzIOgh1kz+;
Received: from [2a01:4f8:252:410e::177:224] (port=50854 helo=atb-devel-224..) 
        by hr2.samba.org with esmtp (Exim)
        id 1pdDAA-003s0d-MF; Fri, 17 Mar 2023 16:42:42 +0000
From:   Volker Lendecke <vl@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Volker Lendecke <vl@samba.org>
Subject: [PATCH] cifs: Clarify an if-condition in SMB2_open_init()
Date:   Fri, 17 Mar 2023 16:42:36 +0000
Message-Id: <19c9ea1d0b1927d9550facbc5d1b43885bb3a327.1679071266.git.vl@samba.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

(server->capabilities & SMB2_GLOBAL_CAP_LEASING) is the wrong
condition to stitch together the create contexts, what we really care
about is whether there already was a create context before the durable
one we just are about to add. This also aligns with the other cases
further down in SMB2_open_init().

Signed-off-by: Volker Lendecke <vl@samba.org>
---
 fs/cifs/smb2pdu.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 0e53265e1462..5d06ecc9341b 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2840,8 +2840,7 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	}
 
 	if (*oplock == SMB2_OPLOCK_LEVEL_BATCH) {
-		/* need to set Next field of lease context if we request it */
-		if (server->capabilities & SMB2_GLOBAL_CAP_LEASING) {
+		if (n_iov > 2) {
 			struct create_context *ccontext =
 			    (struct create_context *)iov[n_iov-1].iov_base;
 			ccontext->Next =
-- 
2.30.2

