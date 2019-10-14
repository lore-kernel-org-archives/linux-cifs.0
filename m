Return-Path: <SRS0=LGzZ=YH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDFAC4CECE
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 17:06:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCE3421835
	for <linux-cifs@archiver.kernel.org>; Mon, 14 Oct 2019 17:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388148AbfJNRGb (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 14 Oct 2019 13:06:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:32980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729900AbfJNRGb (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 14 Oct 2019 13:06:31 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4E301B6EC;
        Mon, 14 Oct 2019 17:06:30 +0000 (UTC)
From:   Aurelien Aptel <aaptel@suse.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH 1/2] smbinfo.rst: document new `keys` command
Date:   Mon, 14 Oct 2019 19:06:25 +0200
Message-Id: <20191014170625.21643-1-aaptel@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 smbinfo.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/smbinfo.rst b/smbinfo.rst
index c8f76e6..7413849 100644
--- a/smbinfo.rst
+++ b/smbinfo.rst
@@ -90,6 +90,10 @@ COMMAND
 - File types
 - File flags
 
+`keys`: Dump session id, encryption keys and decryption keys so that
+the SMB3 traffic of this mount can be decryped e.g. via wireshark
+(requires root).
+
 *****
 NOTES
 *****
-- 
2.16.4

