Return-Path: <SRS0=QbqR=WC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2554C433FF
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 02:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A42E920B1F
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Aug 2019 02:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731259AbfHFCga (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Aug 2019 22:36:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57222 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729334AbfHFCga (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 5 Aug 2019 22:36:30 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 76C3C323F3DAD912D613;
        Tue,  6 Aug 2019 10:36:28 +0800 (CST)
Received: from [127.0.0.1] (10.184.225.177) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Tue, 6 Aug 2019
 10:36:19 +0800
To:     <linux-cifs@vger.kernel.org>,
        =?UTF-8?Q?Aur=c3=a9lien_Aptel?= <aaptel@suse.com>,
        <liujiawen10@huawei.com>, Steve French <smfrench@gmail.com>,
        <pshilov@microsoft.com>, <lsahlber@redhat.com>,
        <kdsouza@redhat.com>, <ab@samba.org>, <palcantara@suse.de>
CC:     <dujin1@huawei.com>, Mingfangsen <mingfangsen@huawei.com>,
        zhangsaisai <zhangsaisai@huawei.com>
From:   Zhiqiang Liu <liuzhiqiang26@huawei.com>
Subject: [PATCH cifs-utils v2] mount.cifs.c: fix memory leaks in main func
Message-ID: <0f780b18-0b1c-e2ff-31b1-1d697becd142@huawei.com>
Date:   Tue, 6 Aug 2019 10:35:29 +0800
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
Reviewed-by: Aur¨¦lien Aptel <aaptel@suse.com>
---
v1->v2:
- free orgoptions in main func as suggested by Aur¨¦lien Aptel
- free mountpoint in acquire_mountpoint func as suggested by Aur¨¦lien Aptel

 mount.cifs.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index ae7a899..656d353 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1891,7 +1891,10 @@ restore_privs:
 		uid_t __attribute__((unused)) uignore = setfsuid(oldfsuid);
 		gid_t __attribute__((unused)) gignore = setfsgid(oldfsgid);
 	}
-
+	
+	if (rc) {
+		free(*mountpointp);
+	}
 	return rc;
 }

@@ -1994,8 +1997,10 @@ int main(int argc, char **argv)

 	/* chdir into mountpoint as soon as possible */
 	rc = acquire_mountpoint(&mountpoint);
-	if (rc)
+	if (rc) {
+		free(orgoptions);
 		return rc;
+	}

 	/*
 	 * mount.cifs does privilege separation. Most of the code to handle
@@ -2014,6 +2019,8 @@ int main(int argc, char **argv)
 		/* child */
 		rc = assemble_mountinfo(parsed_info, thisprogram, mountpoint,
 					orig_dev, orgoptions);
+		free(orgoptions);
+		free(mountpoint);
 		return rc;
 	} else {
 		/* parent */
@@ -2149,5 +2156,6 @@ mount_exit:
 	}
 	free(options);
 	free(orgoptions);
+	free(mountpoint);
 	return rc;
 }
-- 
2.7.4

