Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B50D0C433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 13:58:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89D0C64EF6
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 13:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbhCSN5h (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 19 Mar 2021 09:57:37 -0400
Received: from smtp2.axis.com ([195.60.68.18]:9184 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229925AbhCSN5U (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 19 Mar 2021 09:57:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1616162240;
  x=1647698240;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/M28w1PF8lYT2vZv1ExYZlwHwTaCfjCoY/pOUH0jMv4=;
  b=HgR1Bm7uoA/hU6k7RNx28MUzJxofu5Z5aWSxG3xOotFdy27zRyYZn/Tb
   yf9OMWMnTM6vyBPfstILtKIs//v8l6Dc+jGCpFdDeiXGZjb69DMOzqgG3
   oUw7YbZGsfwusAnm2TdYaoX6VQsvs7m5XYNsffbw07a/eidp5w8xiw4LC
   X+Ze4U5Ztxtfs7fu9OiJ2gQ481qP1eRWj4Q9LY+X6XPzdCa7YQRcgKDhW
   GM5TlI6bWmm93i/9GD7AB9Tkv0rM+1pJeNd5qFfrJBx7fKDfi3AsBedZY
   BKNsm1uwFumy5vvn+b9hAbAA/4yCfp009/1j85wr7aVqehTYHOciLMmaz
   w==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Steve French <sfrench@samba.org>
CC:     <kernel@axis.com>, <tom@talpey.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] cifs: Silently ignore unknown oplock break handle
Date:   Fri, 19 Mar 2021 14:57:11 +0100
Message-ID: <20210319135711.11802-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make SMB2 not print out an error when an oplock break is received for an
unknown handle, similar to SMB1.  The debug message which is printed for
these unknown handles may also be misleading, so fix that too.

The SMB2 lease break path is not affected by this patch.

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
    v3:
    - Change debug print to Tom Talpey's suggestion
    
    v2:
    - Drop change to lease break
    - Rewrite commit message

 fs/cifs/smb2misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 60d4bd1eae2b..76cd05b8d53b 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -754,8 +754,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
 		}
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
-	cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
-	return false;
+	cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
+	return true;
 }
 
 void
-- 
2.28.0

