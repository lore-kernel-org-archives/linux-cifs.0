Return-Path: <SRS0=BDHi=EC=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF7E3C6379F
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Oct 2020 00:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E9CF21D41
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Oct 2020 00:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603758869;
	bh=fbOKK3oj6RLCzwslWtdXpYtuvTduGUnB3rdCifdbUIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tzGpLRCGW0ITtIdnCunynA1cR32OiF3e8WABxbK8JYGZ9FHSE6U7eTrpqZumVnaeU
	 SFse3YtJpxZ+9tVwSlBl+BOBwkQE/4sdvWBoIDG5HFC559MwrHrvMeFDs4J+P2y9vI
	 IdwRyGg9AeKuGyAyrdQX3Xbw0lk4YIjeV+qbz6Kc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443535AbgJ0AbK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Oct 2020 20:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409504AbgJZXvn (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A1B320882;
        Mon, 26 Oct 2020 23:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756302;
        bh=fbOKK3oj6RLCzwslWtdXpYtuvTduGUnB3rdCifdbUIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2DlNiugeajzi+LFJxkw7am2Znyh5RNsM9wtavd2H1acACBoYU9L/HUjJLfDN04fD
         fQIbOcvhZCT7KsG4zeqsLUSL2Ji5X+qJgFnhWxnFNaDHlXHKuxX5/doK/r4j1sNgL4
         bw4fBdPtAvzKdKflkBvE8Zc3GhfnmX2kU+f0Zh9M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 5.9 128/147] cifs: handle -EINTR in cifs_setattr
Date:   Mon, 26 Oct 2020 19:48:46 -0400
Message-Id: <20201026234905.1022767-128-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Ronnie Sahlberg <lsahlber@redhat.com>

[ Upstream commit c6cc4c5a72505a0ecefc9b413f16bec512f38078 ]

RHBZ: 1848178

Some calls that set attributes, like utimensat(), are not supposed to return
-EINTR and thus do not have handlers for this in glibc which causes us
to leak -EINTR to the applications which are also unprepared to handle it.

For example tar will break if utimensat() return -EINTR and abort unpacking
the archive. Other applications may break too.

To handle this we add checks, and retry, for -EINTR in cifs_setattr()

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/inode.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 1f75b25e559a7..daec31be85718 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2883,13 +2883,18 @@ cifs_setattr(struct dentry *direntry, struct iattr *attrs)
 {
 	struct cifs_sb_info *cifs_sb = CIFS_SB(direntry->d_sb);
 	struct cifs_tcon *pTcon = cifs_sb_master_tcon(cifs_sb);
+	int rc, retries = 0;
 
-	if (pTcon->unix_ext)
-		return cifs_setattr_unix(direntry, attrs);
-
-	return cifs_setattr_nounix(direntry, attrs);
+	do {
+		if (pTcon->unix_ext)
+			rc = cifs_setattr_unix(direntry, attrs);
+		else
+			rc = cifs_setattr_nounix(direntry, attrs);
+		retries++;
+	} while (is_retryable_error(rc) && retries < 2);
 
 	/* BB: add cifs_setattr_legacy for really old servers */
+	return rc;
 }
 
 #if 0
-- 
2.25.1

