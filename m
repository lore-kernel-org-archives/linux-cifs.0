Return-Path: <SRS0=RvcV=W7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A25C3A5AA
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 16:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC7D23400
	for <linux-cifs@archiver.kernel.org>; Wed,  4 Sep 2019 16:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567613853;
	bh=xNd4kCXq6hUuyEVyhnEMc4+6Y/+LDdNmnahKeej3FwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=E/nw21YAjKdhEnFgvfUIlOKU/B6NDpZxV9jQX4Fi21JHeMufdWcDu8V90AODvK1P0
	 AXstKda/VZiMNoRnfjWOWaGKVqULd5n8xLKywxg1w5G7RoKLkZ8Rgoh1yjZ5nEQjZi
	 doEODyKwMDPR4utYsTGZXc/o2DgSLgQcMeD5wrEA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732462AbfIDQR3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 4 Sep 2019 12:17:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731559AbfIDP7K (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 4 Sep 2019 11:59:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F7522CF5;
        Wed,  4 Sep 2019 15:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612749;
        bh=xNd4kCXq6hUuyEVyhnEMc4+6Y/+LDdNmnahKeej3FwM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SWH7/GM7O6bnnohA9vsAM1iuR7C/tuQ3KUK18UW+ZD7VDDnOBqBEh2lN6Zxh9xNRd
         HwGMIZzjkM0BWTbCnLc+k8lsIsMe+jn1jPMpHElZSn6g6NrPL9CZbb04We4Ug7actC
         AH705lXo7hSAEKXs3qZ4/H01+2qco0CI51z+hIWo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 59/94] cifs: set domainName when a domain-key is used in multiuser
Date:   Wed,  4 Sep 2019 11:57:04 -0400
Message-Id: <20190904155739.2816-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit f2aee329a68f5a907bcff11a109dfe17c0b41aeb ]

RHBZ: 1710429

When we use a domain-key to authenticate using multiuser we must also set
the domainnmame for the new volume as it will be used and passed to the server
in the NTLMSSP Domain-name.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/connect.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 18c7c6b2fe08a..2beaa14519f5d 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2961,6 +2961,7 @@ static int
 cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 {
 	int rc = 0;
+	int is_domain = 0;
 	const char *delim, *payload;
 	char *desc;
 	ssize_t len;
@@ -3008,6 +3009,7 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 			rc = PTR_ERR(key);
 			goto out_err;
 		}
+		is_domain = 1;
 	}
 
 	down_read(&key->sem);
@@ -3065,6 +3067,26 @@ cifs_set_cifscreds(struct smb_vol *vol, struct cifs_ses *ses)
 		goto out_key_put;
 	}
 
+	/*
+	 * If we have a domain key then we must set the domainName in the
+	 * for the request.
+	 */
+	if (is_domain && ses->domainName) {
+		vol->domainname = kstrndup(ses->domainName,
+					   strlen(ses->domainName),
+					   GFP_KERNEL);
+		if (!vol->domainname) {
+			cifs_dbg(FYI, "Unable to allocate %zd bytes for "
+				 "domain\n", len);
+			rc = -ENOMEM;
+			kfree(vol->username);
+			vol->username = NULL;
+			kfree(vol->password);
+			vol->password = NULL;
+			goto out_key_put;
+		}
+	}
+
 out_key_put:
 	up_read(&key->sem);
 	key_put(key);
-- 
2.20.1

