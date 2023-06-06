Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3CF7C77B73
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Jun 2023 15:35:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjFFPf3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Jun 2023 11:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232228AbjFFPf2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Jun 2023 11:35:28 -0400
Received: from m12.mail.163.com (m12.mail.163.com [220.181.12.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F8801BD;
        Tue,  6 Jun 2023 08:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version:
        Content-Type; bh=wSH7uzSKtpphX9UKHyr9xsRWMbdqP//1iixA0OAWzVY=;
        b=ZMj8R9D7IcW14UTQgSz4uAd6PLera55NzwXWiYAExQHyssv8Z+4uFmtyY7+N5d
        zk2CygpCIb1+UjBabdqz2rIPG8/u3w5ek1W7JAI6NHC29byKZHg20JhhYCGd9F24
        PizkOzzSfofU8OG1Rq6l4MYhd4zFuT5d4jaSXsHA9w9BA=
Received: from home.. (unknown [112.10.202.132])
        by zwqz-smtp-mta-g5-2 (Coremail) with SMTP id _____wCnG_gjUn9k_bKuBg--.33498S2;
        Tue, 06 Jun 2023 23:34:59 +0800 (CST)
From:   "jixianghua@xfusion.com" <jxh218@163.com>
To:     linux-cifs@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, sfrench@samba.org,
        jixianghua@xfusion.com, jxh218@163.com
Subject: [PATCH] smb: remove obsolete comment
Date:   Tue,  6 Jun 2023 23:34:56 +0800
Message-Id: <20230606153456.14454-1-jxh218@163.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: _____wCnG_gjUn9k_bKuBg--.33498S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr45trykWFy8uF4fZF45Awb_yoWDJrb_CF
        95ur4xX345Xay7KF1jkwnFvr1DZwnYvr1FkF4Sqa45uw4UXrsxA34vga1xXF1kC3Z8ur1r
        WwnrKrZavF4fujkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRXTm3JUUUUU==
X-Originating-IP: [112.10.202.132]
X-CM-SenderInfo: xm0kjiqy6rljoofrz/xtbB0wSGNVXlzblWKAAAse
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: 鑫华 <jixianghua@xfusion.com>

Because do_gettimeofday has been removed and replaced by ktime_get_real_ts64,
So just remove the comment as it's not needed now.

Signed-off-by: 鑫华 <jixianghua@xfusion.com>
---
 fs/smb/client/transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 24bdd5f4d3bc..0474d0bba0a2 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -55,7 +55,7 @@ alloc_mid(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
 	temp->pid = current->pid;
 	temp->command = cpu_to_le16(smb_buffer->Command);
 	cifs_dbg(FYI, "For smb_command %d\n", smb_buffer->Command);
-	/*	do_gettimeofday(&temp->when_sent);*/ /* easier to use jiffies */
+	/* easier to use jiffies */
 	/* when mid allocated can be before when sent */
 	temp->when_alloc = jiffies;
 	temp->server = server;
-- 
2.34.1

