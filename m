Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CE8C4321E
	for <linux-cifs@archiver.kernel.org>; Mon,  5 Dec 2022 09:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbiLEJEu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 5 Dec 2022 04:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232458AbiLEJDw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 5 Dec 2022 04:03:52 -0500
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD61563F6;
        Mon,  5 Dec 2022 01:03:42 -0800 (PST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NQczK32j9z4y0vR;
        Mon,  5 Dec 2022 17:03:41 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2B593NeI097414;
        Mon, 5 Dec 2022 17:03:23 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp01[null])
        by mapi (Zmail) with MAPI id mid31;
        Mon, 5 Dec 2022 17:03:25 +0800 (CST)
Date:   Mon, 5 Dec 2022 17:03:25 +0800 (CST)
X-Zmail-TransId: 2af9638db3dd44b00eaa
X-Mailer: Zmail v1.0
Message-ID: <202212051703254109015@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <linkinjeon@kernel.org>
Cc:     <sfrench@samba.org>, <senozhatsky@chromium.org>, <tom@talpey.com>,
        <linux-cifs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIGtzbWJkOiB1c2Ugc3lzZnNfZW1pdCgpIHRvIGluc3RlYWQgb2Ygc2NucHJpbnRmKCk=?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2B593NeI097414
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.251.13.novalocal with ID 638DB3ED.001 by FangMail milter!
X-FangMail-Envelope: 1670231021/4NQczK32j9z4y0vR/638DB3ED.001/10.5.228.133/[10.5.228.133]/mse-fl2.zte.com.cn/<ye.xingchen@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 638DB3ED.001/4NQczK32j9z4y0vR
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: ye xingchen <ye.xingchen@zte.com.cn>

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
---
 fs/ksmbd/server.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/server.c b/fs/ksmbd/server.c
index a0d635304754..b0da15377709 100644
--- a/fs/ksmbd/server.c
+++ b/fs/ksmbd/server.c
@@ -433,7 +433,7 @@ static ssize_t stats_show(struct class *class, struct class_attribute *attr,
 		"shutdown"
 	};

-	ssize_t sz = scnprintf(buf, PAGE_SIZE, "%d %s %d %lu\n", stats_version,
+	ssize_t sz = sysfs_emit(buf, "%d %s %d %lu\n", stats_version,
 			       state[server_conf.state], server_conf.tcp_port,
 			       server_conf.ipc_last_active / HZ);
 	return sz;
-- 
2.25.1
