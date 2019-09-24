Return-Path: <SRS0=4YGq=XT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76D09C432C2
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 05:01:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CBB120872
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Sep 2019 05:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408741AbfIXFBm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Sep 2019 01:01:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38700 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408653AbfIXFBm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 24 Sep 2019 01:01:42 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 69724898108;
        Tue, 24 Sep 2019 05:01:42 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.76.1.145])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF3CD5D9D5;
        Tue, 24 Sep 2019 05:01:40 +0000 (UTC)
From:   Kenneth D'souza <kdsouza@redhat.com>
To:     linux-cifs@vger.kernel.org, piastryyy@gmail.com, smfrench@gmail.com
Cc:     lsahlber@redhat.com
Subject: [PATCH] smb2quota.rst: Add man page for smb2quota.py
Date:   Tue, 24 Sep 2019 10:31:39 +0530
Message-Id: <20190924050139.22007-1-kdsouza@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.67]); Tue, 24 Sep 2019 05:01:42 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Kenneth D'souza <kdsouza@redhat.com>
---
 smb2quota.rst | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)
 create mode 100644 smb2quota.rst

diff --git a/smb2quota.rst b/smb2quota.rst
new file mode 100644
index 0000000..acb34fc
--- /dev/null
+++ b/smb2quota.rst
@@ -0,0 +1,68 @@
+============
+smb2quota
+============
+
+-----------------------------------------------------------------------------------------------------
+Userspace helper to display quota information for the Linux SMB client file system (CIFS)
+-----------------------------------------------------------------------------------------------------
+:Manual section: 1
+
+********
+SYNOPSIS
+********
+
+  smb2quota [-h] {options} {file system object}
+
+***********
+DESCRIPTION
+***********
+
+This tool is part of the cifs-utils suite.
+
+`smb2quota` is a userspace helper program for the Linux SMB
+client file system (CIFS). 
+
+This tool works by making an CIFS_QUERY_INFO IOCTL call to the Linux
+SMB client which in turn issues a SMB Query Info request and returns
+the result.
+
+*******
+OPTIONS
+*******
+`--help/-h`: Print help explaining the command line options.
+
+`-tabular/-t`: Print quota information for the volume in tabular format.
+Amount Used | Quota Limit | Warning Level | SID  
+
+`-csv/-c`: Print quota information for the volume in csv format.
+SID,Amount Used,Quota Limit,Warning Level
+
+`-list/-l`: Print quota information for the volume in raw format.
+- SID 
+- Quota Used
+- Quota Threshold
+- Quota Limit
+
+*****
+NOTES
+*****
+
+Kernel support for smb2quota requires the CIFS_QUERY_INFO
+IOCTL which was initially introduced in the 4.20 kernel and is only
+implemented for mount points using SMB2 or above (see mount.cifs(8)
+`vers` option).
+
+********
+SEE ALSO
+********
+
+smbinfo(1)
+
+******
+AUTHOR
+******
+
+Kenneth D'souza <kdsouza@redhat.com>
+
+The Linux CIFS Mailing list is the preferred place to ask questions
+regarding these programs.
-- 
2.21.0

