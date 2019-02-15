Return-Path: <SRS0=lRaz=QW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95158C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:22:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ED0420643
	for <linux-cifs@archiver.kernel.org>; Fri, 15 Feb 2019 02:22:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732543AbfBOCWx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Feb 2019 21:22:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726324AbfBOCWw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 14 Feb 2019 21:22:52 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCDDDC0D18AA;
        Fri, 15 Feb 2019 02:22:52 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.0.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 700D1600C7;
        Fri, 15 Feb 2019 02:22:51 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org
Cc:     piastryyy@gmail.com, smfrench@gmail.com
Subject: [PATCH v4] Update mount.cifs with vers=default mount option and SMBv3.0.2
Date:   Fri, 15 Feb 2019 07:52:48 +0530
Message-Id: <20190215022248.13277-1-kdsouza@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Fri, 15 Feb 2019 02:22:52 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add vers=3.0.2 as a valid option for SMBv3.0.2 and explain behavior
of vers=default.

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 mount.cifs.rst | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.rst b/mount.cifs.rst
index a0faf7f..2ad7f59 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -591,9 +591,13 @@ vers=arg
     different dialect (2.000) that is not supported.
   - 2.1 - The SMBv2.1 protocol that was introduced in Microsoft Windows 7 and Windows Server 2008R2.
   - 3.0 - The SMBv3.0 protocol that was introduced in Microsoft Windows 8 and Windows Server 2012.
-  - 3.02 - The SMBv3.0.2 protocol that was introduced in Microsoft Windows 8.1 and Windows Server 2012R2.
+  - 3.02 or 3.0.2 - The SMBv3.0.2 protocol that was introduced in Microsoft Windows 8.1 and Windows Server 2012R2.
   - 3.1.1 or 3.11 - The SMBv3.1.1 protocol that was introduced in Microsoft Windows Server 2016.
   - 3 - The SMBv3.0 protocol version and above.
+  - default - Tries to negotiate the highest SMB2+ version supported by both the client and server.
+
+  If no dialect is specified on mount vers=default is used.
+  To check ``Dialect`` refer to /proc/fs/cifs/DebugData
 
   Note too that while this option governs the protocol version used, not
   all features of each version are available.
-- 
2.17.2

