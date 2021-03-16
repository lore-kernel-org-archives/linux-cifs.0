Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBBB7C433DB
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Mar 2021 12:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE84065036
	for <linux-cifs@archiver.kernel.org>; Tue, 16 Mar 2021 12:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhCPMsq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 16 Mar 2021 08:48:46 -0400
Received: from smtp2.axis.com ([195.60.68.18]:65351 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232940AbhCPMsV (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 16 Mar 2021 08:48:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1615898901;
  x=1647434901;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=R/qrhf2BvEAQYNmpXyzvq1FG5e/yZfN8pk3ldKPlorY=;
  b=TueIOpS1ceRB+JTuZ38cjx/ZFdJA8/7OfutGamEm8SZo44B0LfFS3vwy
   /2lJd249MqRj19rNRdt1MStzaZ5dym4fKjjSqg/G0A99n25KZrjXDHSFg
   UxeN4J1BPUY5jayiRCErbOnazWespC+DSBh7xDKPu3LvT9xv3Sh7hvVO/
   gcz+2jB8v+4Hhate0dOGj71bYhzM2skjPWI+JKwAuzqNADLR7u+kGzt6v
   ByvuTsWRzHOTJr1u6CoYZEXSHb+aeKH5RBfVLh1yDwBfEpDzO9t9rYpN9
   SCRKjcph6TkQ5I1X4S2hLQytGe7TRUyKBsFdFd10+iww6ZXifPwoRcCw1
   g==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Steve French <sfrench@samba.org>
CC:     <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] cifs: Silently ignore unknown oplock break handle
Date:   Tue, 16 Mar 2021 13:48:07 +0100
Message-ID: <20210316124808.11984-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make SMB2 not print out an error when an oplock break is received for an
unknown handle, similar to SMB1.  The SMB2 lease break path is not
affected by this patch.

Without this, a program which writes to a file from one thread, and
opens, reads, and writes the same file from another thread triggers the
below errors several times a minute when run against a Samba server
configured with "smb2 leases = no".

 CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
 00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
 00000010: 00000001 00000000 ffffffff ffffffff  ................
 00000020: 00000000 00000000 00000000 00000000  ................
 00000030: 00000000 00000000 00000000 00000000  ................

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---

Notes:
    v2:
    - Drop change to lease break
    - Rewrite commit message

 fs/cifs/smb2misc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 60d4bd1eae2b..4d8576e202e3 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -755,7 +755,7 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
-	return false;
+	return true;
 }
 
 void
-- 
2.28.0

