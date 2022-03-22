Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9622C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Mar 2022 06:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbiCVGaq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Mar 2022 02:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237043AbiCVGao (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Mar 2022 02:30:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 13DB937AB6
        for <linux-cifs@vger.kernel.org>; Mon, 21 Mar 2022 23:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647930555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vQkGQ2LG8I4aQBoQ9yzvcmigLhTR8+YMMa5oI4uvrUc=;
        b=IVb6kzDeRmepv+cXyRo8+qnbIoq6TLBoYnKAvZfLyEkTRKRillKB4sipPFzPbBfWXAeJ1z
        /r4ejl01kuX6ptPGYijM1AvKNYnjIuEclkEwqEhWJrYZ1oqTn2lsdqXNkWIs3Z0+5WJPFl
        OZcSDrXlJVEn9M0Ft6nKmEAsjXO422U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-zQxxPGKgNkS7D09_12Cd2Q-1; Tue, 22 Mar 2022 02:29:14 -0400
X-MC-Unique: zQxxPGKgNkS7D09_12Cd2Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE9943C01B87;
        Tue, 22 Mar 2022 06:29:13 +0000 (UTC)
Received: from thinkpad (vpn2-54-164.bne.redhat.com [10.64.54.164])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D6D8C2166B2D;
        Tue, 22 Mar 2022 06:29:12 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 2/2] cifs: change smb2_query_info_compound to use a cached fid, if available
Date:   Tue, 22 Mar 2022 16:29:03 +1000
Message-Id: <20220322062903.849005-2-lsahlber@redhat.com>
In-Reply-To: <20220322062903.849005-1-lsahlber@redhat.com>
References: <20220322062903.849005-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This will reduce the number of Open/Close we send on the wire and replace
a Open/GetInfo/Close compound with just a simple GetInfo request
IF we have a cached handle for the object.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/smb2ops.c | 45 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 024adb91dd57..9cce5ae1dfa2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2659,6 +2659,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	int rc;
 	__le16 *utf16_path;
+	struct cached_fid *cfid = NULL;
 
 	if (!path)
 		path = "";
@@ -2673,6 +2674,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	resp_buftype[0] = resp_buftype[1] = resp_buftype[2] = CIFS_NO_BUFFER;
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
+	rc = open_cached_dir(xid, tcon, path, cifs_sb, &cfid);
+
 	memset(&open_iov, 0, sizeof(open_iov));
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = SMB2_CREATE_IOV_SIZE;
@@ -2694,15 +2697,29 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	rqst[1].rq_iov = qi_iov;
 	rqst[1].rq_nvec = 1;
 
-	rc = SMB2_query_info_init(tcon, server,
-				  &rqst[1], COMPOUND_FID, COMPOUND_FID,
-				  class, type, 0,
-				  output_len, 0,
-				  NULL);
+	if (cfid) {
+		rc = SMB2_query_info_init(tcon, server,
+					  &rqst[1],
+					  cfid->fid->persistent_fid,
+					  cfid->fid->volatile_fid,
+					  class, type, 0,
+					  output_len, 0,
+					  NULL);
+	} else {
+		rc = SMB2_query_info_init(tcon, server,
+					  &rqst[1],
+					  COMPOUND_FID,
+					  COMPOUND_FID,
+					  class, type, 0,
+					  output_len, 0,
+					  NULL);
+	}
 	if (rc)
 		goto qic_exit;
-	smb2_set_next_command(tcon, &rqst[1]);
-	smb2_set_related(&rqst[1]);
+	if (!cfid) {
+		smb2_set_next_command(tcon, &rqst[1]);
+		smb2_set_related(&rqst[1]);
+	}
 
 	memset(&close_iov, 0, sizeof(close_iov));
 	rqst[2].rq_iov = close_iov;
@@ -2714,9 +2731,15 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		goto qic_exit;
 	smb2_set_related(&rqst[2]);
 
-	rc = compound_send_recv(xid, ses, server,
-				flags, 3, rqst,
-				resp_buftype, rsp_iov);
+	if (cfid) {
+		rc = compound_send_recv(xid, ses, server,
+					flags, 1, &rqst[1],
+					&resp_buftype[1], &rsp_iov[1]);
+	} else {
+		rc = compound_send_recv(xid, ses, server,
+					flags, 3, rqst,
+					resp_buftype, rsp_iov);
+	}
 	if (rc) {
 		free_rsp_buf(resp_buftype[1], rsp_iov[1].iov_base);
 		if (rc == -EREMCHG) {
@@ -2736,6 +2759,8 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 	SMB2_close_free(&rqst[2]);
 	free_rsp_buf(resp_buftype[0], rsp_iov[0].iov_base);
 	free_rsp_buf(resp_buftype[2], rsp_iov[2].iov_base);
+	if(cfid)
+		close_cached_dir(cfid);
 	return rc;
 }
 
-- 
2.30.2

