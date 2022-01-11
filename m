Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 447AFC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 11 Jan 2022 14:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242840AbiAKOmS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 Jan 2022 09:42:18 -0500
Received: from mail.astralinux.ru ([217.74.38.119]:53334 "EHLO
        mail.astralinux.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243197AbiAKOmK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 11 Jan 2022 09:42:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 9C7E63048F2B;
        Tue, 11 Jan 2022 17:42:07 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pixUFdPU7y5W; Tue, 11 Jan 2022 17:42:06 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 937E63048F33;
        Tue, 11 Jan 2022 17:42:06 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id eKIDDi7QIoh7; Tue, 11 Jan 2022 17:42:06 +0300 (MSK)
Received: from himera.home (37-145-209-165.broadband.corbina.ru [37.145.209.165])
        by mail.astralinux.ru (Postfix) with ESMTPSA id DCE163048F0C;
        Tue, 11 Jan 2022 17:42:03 +0300 (MSK)
Date:   Tue, 11 Jan 2022 17:42:02 +0300
From:   Eugene Korenevsky <ekorenevsky@astralinux.ru>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <sfrench@samba.org>
Subject: [PATCH] cifs: fix FILE_BOTH_DIRECTORY_INFO definition
Message-ID: <Yd2XOmonTTG/vFAa@himera.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The size of FILE_BOTH_DIRECTORY_INFO.ShortName must be 24 bytes, not 12
(see MS-FSCC documentation).

Signed-off-by: Eugene Korenevsky <ekorenevsky@astralinux.ru>
---
 fs/cifs/cifspdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index d2ff438fd31f..68b9a436af4b 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -2560,7 +2560,7 @@ typedef struct {
 	__le32 EaSize; /* length of the xattrs */
 	__u8   ShortNameLength;
 	__u8   Reserved;
-	__u8   ShortName[12];
+	__u8   ShortName[24];
 	char FileName[1];
 } __attribute__((packed)) FILE_BOTH_DIRECTORY_INFO; /* level 0x104 FFrsp data */
 
-- 
2.30.2

