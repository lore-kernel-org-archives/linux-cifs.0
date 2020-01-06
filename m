Return-Path: <SRS0=+dfI=23=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E25C33C8C
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jan 2020 16:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04DAA208C4
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jan 2020 16:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ay2ypHHQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbgAFQb0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:31:26 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44867 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgAFQb0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 Jan 2020 11:31:26 -0500
Received: by mail-qk1-f194.google.com with SMTP id w127so39909774qkb.11
        for <linux-cifs@vger.kernel.org>; Mon, 06 Jan 2020 08:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xkfa5x78Jkq1S3G19eOeCV4/s74GQk+h4IclOxcbIXw=;
        b=Ay2ypHHQCw5OM45qxOgJt4lQBnqdj2k4btZswWT7oJkOSSulzoK7KJDwKQiWuyophL
         xGYUinRF1efow7+jRrTjycJQIWNFaiovjSTNyNvhQ7u3fhcKn1J3urU1q/GOSUNNfQmY
         8YZwiCjIMYMAnVYBB0tc6LJA12o2PfEjseCXVkuZsYd24n1vdL+t90eCZqHtjJb2/rZk
         UdP/InagQnVch1wCjOWLZMNq2W/2HgV2bf9n4/YcUmT6cqaZeUT3dGIA/TZVLNt2BZ3g
         gvLyQRoAO2tXH0nAwWYQyA7XhdhijMvUfmoLB60qEUliEYU2ah2cQiuhC7j7hZVMk9Wa
         aubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xkfa5x78Jkq1S3G19eOeCV4/s74GQk+h4IclOxcbIXw=;
        b=NK4PM/7syGDGpBun5Yqc1+rD+fJ5AqLKR7eQ1qU5eO85bznxMElWDBB8/bRYQdnlKN
         lajWHLSmXQNsuKm30iZJU30JFeelr8QoxvAPOvrA+2lYI5v+0JLPoMCIqY2O43DHnZ4/
         L8/ZZKr9wwPyLX+5BN6eoToxIsHhP8prk6D2Ia/GA+thEcpSnPud+Z+gVj6MRxB/+PVf
         vu95Gaq9swFPNIYJchkpZIE7FwfHc1WlRpajn5QQb2ut93SdIm3+7Fx0AfFLfaXjAivN
         aKoEu8n3kYRmFrlWin7V0wGVfEJEmg43ssKsHAIucCcimpIud+yC0fnNqtb+0Jwgn5wz
         Blbg==
X-Gm-Message-State: APjAAAWjuzHLDYXHIxa4DWwQDG1FAcf4qrKzNCfh9t/hj/SmOuTLKmOb
        jkq5ThDRX2af/hXuSo1YBp2LXymH
X-Google-Smtp-Source: APXvYqxyjU7/0WmK5gKPcdj3oGnynT7bQ/pOta7Sh03zE8dx8WgpBxz6mZLSd9T7J5vGpwhyzyp1HA==
X-Received: by 2002:a05:620a:10a7:: with SMTP id h7mr82139014qkk.423.1578328285349;
        Mon, 06 Jan 2020 08:31:25 -0800 (PST)
Received: from ip-172-31-1-121.ec2.internal (ec2-3-231-202-5.compute-1.amazonaws.com. [3.231.202.5])
        by smtp.gmail.com with ESMTPSA id f26sm23434195qtv.77.2020.01.06.08.31.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Jan 2020 08:31:25 -0800 (PST)
From:   Boris Protopopov <boris.v.protopopov@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org, samba-technical@lists.samba.org,
        sblbir@amazon.com, boris.v.protopopov@gmail.com
Subject: [PATCH 1/2] Convert owner and group SID offsets to LE format
Date:   Mon,  6 Jan 2020 16:31:18 +0000
Message-Id: <20200106163119.9083-1-boris.v.protopopov@gmail.com>
X-Mailer: git-send-email 2.24.1.485.gad05a3d8e5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Convert owner and group SID offsets to LE format
when writing to ntsd

Signed-off-by: Boris Protopopov <boris.v.protopopov@gmail.com>
---
 setcifsacl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/setcifsacl.c b/setcifsacl.c
index f3d0189..9a301e2 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -114,12 +114,14 @@ copy_sec_desc(const struct cifs_ntsd *pntsd, struct cifs_ntsd *pnntsd,
 	if (dacloffset <= osidsoffset) {
 		/* owners placed at end of ACL */
 		nowner_sid_ptr = (struct cifs_sid *)((char *)pnntsd + dacloffset + size);
-		pnntsd->osidoffset = dacloffset + size;
+		osidsoffset = dacloffset + size;
+		pnntsd->osidoffset = htole32(osidsoffset);
 		size = copy_cifs_sid(nowner_sid_ptr, owner_sid_ptr);
 		bufsize += size;
 		/* put group SID after owner SID */
 		ngroup_sid_ptr = (struct cifs_sid *)((char *)nowner_sid_ptr + size);
-		pnntsd->gsidoffset = pnntsd->osidoffset + size;
+		gsidsoffset = osidsoffset + size;
+		pnntsd->gsidoffset = htole32(gsidsoffset);
 	} else {
 		/*
 		 * Most servers put the owner information at the beginning,
-- 
2.14.5

