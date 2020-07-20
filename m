Return-Path: <SRS0=CLpK=A7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37CE7C433E3
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Jul 2020 00:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13ADE2177B
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Jul 2020 00:13:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fa6BM93D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgGTANY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 19 Jul 2020 20:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbgGTANX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 19 Jul 2020 20:13:23 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C93FC0619D2;
        Sun, 19 Jul 2020 17:13:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=lu1fmLS9P2smCCuZldAHD8/i9SFslEh6s3uUkcgyaTU=; b=fa6BM93DTZr3J0lM0xhqz8cVh8
        s+SNOUzuoVpcRK9xAw0CCnLo6HNkgLTa+XPtGSPue0+ElyEL0cMjcXjgnw4EIcM4bT63dXNzrOCfC
        o2pfu2jBSeSV/ptZo/Z/bw6ebdwZQpqsYa4/VbxfiPrM7DsLE4tZdDBvfqAGt19K8CzaK7Sz4s0XB
        jezKMeE6RNEDoMDauZfngcWX9cIMcEFFyTBvPb23+dAhI9sf7QQzRZtbXVFCBU/VACnNtM5s1696y
        HOJSOKxM1S/UptVrk30R47ERnKswBqFFE6sHmxIgfEKcNXs8ySO8lD+oDcNKoXCo/+OprS+LYBuB2
        fr/QKJPw==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jxJQm-0003wk-Lm; Mon, 20 Jul 2020 00:13:21 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [PATCH] cifs: delete duplicated words in header files
Date:   Sun, 19 Jul 2020 17:13:16 -0700
Message-Id: <20200720001316.22854-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Drop repeated words in multiple comments.
(be, use, the, See)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
---
 fs/cifs/cifsacl.h  |    4 ++--
 fs/cifs/cifsglob.h |    2 +-
 fs/cifs/smb2pdu.h  |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20200717.orig/fs/cifs/cifsacl.h
+++ linux-next-20200717/fs/cifs/cifsacl.h
@@ -132,7 +132,7 @@ struct cifs_ace {
 /*
  * The current SMB3 form of security descriptor is similar to what was used for
  * cifs (see above) but some fields are split, and fields in the struct below
- * matches names of fields to the the spec, MS-DTYP (see sections 2.4.5 and
+ * matches names of fields to the spec, MS-DTYP (see sections 2.4.5 and
  * 2.4.6). Note that "CamelCase" fields are used in this struct in order to
  * match the MS-DTYP and MS-SMB2 specs which define the wire format.
  */
@@ -178,7 +178,7 @@ struct smb3_acl {
 
 /*
  * Used to store the special 'NFS SIDs' used to persist the POSIX uid and gid
- * See See http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
+ * See http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
  */
 struct owner_sid {
 	u8 Revision;
--- linux-next-20200717.orig/fs/cifs/cifsglob.h
+++ linux-next-20200717/fs/cifs/cifsglob.h
@@ -1466,7 +1466,7 @@ struct cifsInodeInfo {
 	struct list_head llist;	/* locks helb by this inode */
 	/*
 	 * NOTE: Some code paths call down_read(lock_sem) twice, so
-	 * we must always use use cifs_down_write() instead of down_write()
+	 * we must always use cifs_down_write() instead of down_write()
 	 * for this semaphore to avoid deadlocks.
 	 */
 	struct rw_semaphore lock_sem;	/* protect the fields above */
--- linux-next-20200717.orig/fs/cifs/smb2pdu.h
+++ linux-next-20200717/fs/cifs/smb2pdu.h
@@ -31,7 +31,7 @@
  * Note that, due to trying to use names similar to the protocol specifications,
  * there are many mixed case field names in the structures below.  Although
  * this does not match typical Linux kernel style, it is necessary to be
- * be able to match against the protocol specfication.
+ * able to match against the protocol specfication.
  *
  * SMB2 commands
  * Some commands have minimal (wct=0,bcc=0), or uninteresting, responses
