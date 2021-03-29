Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14DAC433DB
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 22:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA80601FC
	for <linux-cifs@archiver.kernel.org>; Mon, 29 Mar 2021 22:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbhC2W2p (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 29 Mar 2021 18:28:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232531AbhC2W0L (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 29 Mar 2021 18:26:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A98619CB;
        Mon, 29 Mar 2021 22:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056640;
        bh=3tq3hnrcHXFKtFFh9/sB3X/Z016TELf87TU7B7HdbbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1nFf1mBN0zd4OMrurpCN8+rXTcXguW0nDOOyiC/djk30cI8Dau84PqvI9m/vD8lx
         zF4k6cqfrePw4QkEviFBmaqrJEv8voY5hpNuaAiZvfEXwVEOz3x0jd7YRGZ8cOzLme
         EiPPfniJcvpmvSwMF1fD0g2WYw7SNOB1BCIi0B/X8ETYVIJBtdWbdiCLh/Nli1f+02
         ZUCRHYmCZCB/gFU6lWao1pFfn2ChMDK/w3Q/AsoItdUtGDsWvDQv3y8orbseL05EdG
         C8/zH9SBAHlYjBw0DQROiXuxdizn5Qi5BWA2m5E7YR8UTeDrDcpzyXRvY7OuGNnVtZ
         NOp+1vDkXq/3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Tom Talpey <tom@talpey.com>, Paulo Alcantara <pc@cjr.nz>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 4.14 12/12] cifs: Silently ignore unknown oplock break handle
Date:   Mon, 29 Mar 2021 18:23:45 -0400
Message-Id: <20210329222345.2383777-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222345.2383777-1-sashal@kernel.org>
References: <20210329222345.2383777-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Vincent Whitchurch <vincent.whitchurch@axis.com>

[ Upstream commit 219481a8f90ec3a5eed9638fb35609e4b1aeece7 ]

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
Reviewed-by: Tom Talpey <tom@talpey.com>
Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/smb2misc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index 0c6e5450ff76..80339e318294 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -656,8 +656,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
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
2.30.1

