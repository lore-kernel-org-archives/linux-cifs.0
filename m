Return-Path: <SRS0=Aodf=XZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8851BC32792
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 17:06:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5ADA62086A
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Sep 2019 17:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U0guMI7p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbfI3RG2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Sep 2019 13:06:28 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34439 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfI3RG1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Sep 2019 13:06:27 -0400
Received: by mail-pg1-f194.google.com with SMTP id y35so7748253pgl.1
        for <linux-cifs@vger.kernel.org>; Mon, 30 Sep 2019 10:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zsITAX/GM1e6QT+2ZTuTTA/5dI6OAdzQjifyp6sAV4w=;
        b=U0guMI7pJ3LZk82YSpViASo85cHxqZLHxBxADq03Yob/yYj/ceqvQSzKP9wG/Cvz5q
         f+fejX0td/SSL1J2IaOmBPu6nlOirypJedYYauUiE4O14eT3G0AntO2B3PTpNl1zU0y7
         SDfMrDqzx6xUVeK1Sbrc4ykAE8TZH+SO0LbGI9B+gMPYpZPM11NqjR4MCGN68x0Wqisq
         E3nM9WHeFG8LilQDN1qMvlUgdK9DWpCVuwwng3paGoZPl1xRQD08jSYwvMwKrWbIrpgD
         ARdRZ7xxQc31a8l64OKf3hFe1HRt23P9KiteCfJHMRIpHTf4Hi0oyvP720Ff4n2xofAa
         vx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zsITAX/GM1e6QT+2ZTuTTA/5dI6OAdzQjifyp6sAV4w=;
        b=QxE2bh0dFk6JB/ljaA7OaXHKomDe0Fhaht6s5An/yEVKx0rL0Nj8qWRRH9vqNJCvge
         W+Oz34XGNBF00gbcutN9NpcuRxso4G2W6LXimfotYqJMggoEwNohY+wAT33kd0JjcjsY
         U6cVZPBzD+nY3R0U3bBjanrtdL6/hdaBOIzvMwY9nu/K04z2CMOXGdMLHK+e1HXOuG8A
         y4Z/KbTTaGHmRC9b+AEqZZLKCXtnXzEr0Wgd2S27K5rZ+mdbT9IVnIzkSMhzT2BnukV3
         z6CMclaTb0+AGmcPcJzrqwiiUg3fqb3pdq6sELEuBIOhexwI9jep7P+Jivx94pL2Sq1P
         dagA==
X-Gm-Message-State: APjAAAVF6S0iD33XpajECPJ0+iUwWaSRRgmhxRXxieP9s15so7ukU6I2
        n/03YGIS3D7RuIBqGW+BQNgr6eA=
X-Google-Smtp-Source: APXvYqwQy1hESp/XHglQDe2pf2KXKmV98o+zXWkuMSjVGMmUqtQEnRRzVkFPQFKS73cm4088G99tFQ==
X-Received: by 2002:a63:6a81:: with SMTP id f123mr25728963pgc.348.1569863186736;
        Mon, 30 Sep 2019 10:06:26 -0700 (PDT)
Received: from ubuntu-vm.mshome.net ([131.107.147.106])
        by smtp.gmail.com with ESMTPSA id d5sm18350780pfa.180.2019.09.30.10.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 10:06:25 -0700 (PDT)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org
Cc:     Steve French <smfrench@gmail.com>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Subject: [PATCH 1/3] CIFS: Gracefully handle QueryInfo errors during open
Date:   Mon, 30 Sep 2019 10:06:18 -0700
Message-Id: <20190930170620.29979-1-pshilov@microsoft.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Currently if the client identifies problems when processing
metadata returned in CREATE response, the open handle is being
leaked. This causes multiple problems like a file missing a lease
break by that client which causes high latencies to other clients
accessing the file. Another side-effect of this is that the file
can't be deleted.

Fix this by closing the file after the client hits an error after
the file was opened and the open descriptor wasn't returned to
the user space. Also convert -ESTALE to -EOPENSTALE to allow
the VFS to revalidate a dentry and retry the open.

Cc: <stable@vger.kernel.org>
Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/file.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 97090693d182..168b76de193a 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -253,6 +253,12 @@ cifs_nt_open(char *full_path, struct inode *inode, struct cifs_sb_info *cifs_sb,
 		rc = cifs_get_inode_info(&inode, full_path, buf, inode->i_sb,
 					 xid, fid);
 
+	if (rc) {
+		server->ops->close(xid, tcon, fid);
+		if (rc == -ESTALE)
+			rc = -EOPENSTALE;
+	}
+
 out:
 	kfree(buf);
 	return rc;
-- 
2.17.1

