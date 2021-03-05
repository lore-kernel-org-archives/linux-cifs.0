Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602CCC433E0
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 09:42:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27C3464E5F
	for <linux-cifs@archiver.kernel.org>; Fri,  5 Mar 2021 09:42:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbhCEJls (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 5 Mar 2021 04:41:48 -0500
Received: from smtp2.axis.com ([195.60.68.18]:52733 "EHLO smtp2.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229592AbhCEJlU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 5 Mar 2021 04:41:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1614937280;
  x=1646473280;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eX7eX07dPUECO9RUugQmgGxyuPcG2Ye9kthbsk8KXZc=;
  b=Zu21fam45OG21ce4yYt32ntQYHAFNPeYaIQdesTDVWn01RN6ufpoz9xt
   t6IZcBhbITH6i0L2eAL1NEfMdh1rldxssLQYy51rW+TddZHt9JCi2Gs7+
   ViBl4s62C7YQhLpS01ZDsJ/R1vV6xCzGnZWpz88p5cYpoKbX+EhhvBXYJ
   bGS86e3wBRs65xKJoA176HC+ZuS8oeifd6w6A19ngtG/z1Gmu2uUi6Foo
   UVJuvm3Iejj8rfWebpBirXg2V0uF2IdvWNlvzvtwART0Ije/YX13uuXSC
   2vDdMny59XCzC87lP12wh+xn0nRf80HiWyjqx/LipzqlUMUduU8wnXTdl
   w==;
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     <pshilov@microsoft.com>, Steve French <sfrench@samba.org>
CC:     <kernel@axis.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        <linux-cifs@vger.kernel.org>, <samba-technical@lists.samba.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] CIFS: Prevent error log on spurious oplock break
Date:   Fri, 5 Mar 2021 10:41:07 +0100
Message-ID: <20210305094107.13743-1-vincent.whitchurch@axis.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The SMB1 version of ->is_oplock_break() returns true even if the FileId
is not found, as long as the oplock break notification message structure
itself appears to be valid.  A true return value makes
cifs_demultiplex_thread() to not print an error message for such
packets.

However, the SMB2 version returns false in such cases, leading to an
error "No task to wake, unknown frame received!" followed by a hexdump
of the packet header being printed by cifs_demultiplex_thread().

Note that before commit fa9c2362497fbd64788063288d ("CIFS: Fix SMB2
oplock break processing"), SMB2 also returned true for the case where a
connection was found but the FileId was not, but it's not clear to me if
that commit really intended to change the behaviour of the error prints.

Change the behaviour of SMB2 to be the same as SMB1 and avoid the error
messages for these packets which we ignore as per the spec.

Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
---
 fs/cifs/smb2misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 60d4bd1eae2b..3ea3bda64083 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -679,7 +679,7 @@ smb2_is_valid_lease_break(char *buffer)
 	}
 	spin_unlock(&cifs_tcp_ses_lock);
 	cifs_dbg(FYI, "Can not process lease break - no lease matched\n");
-	return false;
+	return true;
 }
 
 bool
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

