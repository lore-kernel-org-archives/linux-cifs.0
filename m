Return-Path: <SRS0=8TPy=V5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2897C32751
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 02:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDCBC20B7C
	for <linux-cifs@archiver.kernel.org>; Thu,  1 Aug 2019 02:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbfHACC6 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Jul 2019 22:02:58 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:3286 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726185AbfHACC6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 31 Jul 2019 22:02:58 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id AF281736122E02F675B2;
        Thu,  1 Aug 2019 10:02:55 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 1 Aug 2019
 10:02:43 +0800
To:     <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        <liujiawen10@huawei.com>, <smfrench@gmail.com>,
        <pshilov@microsoft.com>, <lsahlber@redhat.com>,
        <kdsouza@redhat.com>, <ab@samba.org>, <palcantara@suse.de>,
        <liujiawen10@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH cifs-utils] mount.cifs.c: fix memory leaks in main func
CC:     <dujin1@huawei.com>, Mingfangsen <mingfangsen@huawei.com>,
        zhangsaisai <zhangsaisai@huawei.com>
Message-ID: <d4bf65ab-42e1-606c-be35-a5cb3b7b77b0@huawei.com>
Date:   Thu, 1 Aug 2019 10:02:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gb18030"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.184.225.177]
X-CFilter-Loop: Reflected
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Jiawen Liu <liujiawen10@huawei.com>

In mount.cifs module, orgoptions and mountpoint in the main func
point to the memory allocated by func realpath and strndup respectively.
However, they are not freed before the main func returns so that the
memory leaks occurred.

The memory leak problem is reported by LeakSanitizer tool.
LeakSanitizer url: "https://github.com/google/sanitizers"

Here I free the pointers orgoptions and mountpoint before main
func returns.

Fixes£º7549ad5e7126 ("memory leaks: caused by func realpath and strndup")
Signed-off-by: Jiawen Liu <liujiawen10@huawei.com>
Reported-by: Jin Du <dujin1@huawei.com>
Reviewed-by: Saisai Zhang <zhangsaisai@huawei.com>
---
 mount.cifs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index ae7a899..029f01a 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1830,6 +1830,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
 	}

 assemble_exit:
+	free(orgoptions);
 	return rc;
 }

@@ -1994,8 +1995,11 @@ int main(int argc, char **argv)

 	/* chdir into mountpoint as soon as possible */
 	rc = acquire_mountpoint(&mountpoint);
-	if (rc)
+	if (rc) {
+		free(mountpoint);
+		free(orgoptions);
 		return rc;
+	}

 	/*
 	 * mount.cifs does privilege separation. Most of the code to handle
@@ -2014,6 +2018,7 @@ int main(int argc, char **argv)
 		/* child */
 		rc = assemble_mountinfo(parsed_info, thisprogram, mountpoint,
 					orig_dev, orgoptions);
+		free(mountpoint);
 		return rc;
 	} else {
 		/* parent */
@@ -2149,5 +2154,6 @@ mount_exit:
 	}
 	free(options);
 	free(orgoptions);
+	free(mountpoint);
 	return rc;
 }
-- 
2.7.4


