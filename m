Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D3E2C433EF
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 408C061B08
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Oct 2021 13:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbhJBN1P (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:27:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbhJBN1O (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 2 Oct 2021 09:27:14 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB38C0613EC
        for <linux-cifs@vger.kernel.org>; Sat,  2 Oct 2021 06:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=MWRvV/IrF2/E/YfGChZyT9gyo6eF7R7G2D3V+iQHpQk=; b=jPzM3VlWBi1Zvkwvg4ToaEHMaq
        W8idi9PGGlUkuYHQJLADHE+GX5HX/BQTrAMHzyMWuk0xfyW/I+DIs6lWOYD0oS6YGtaBy/f7L9wBf
        p/E8JNWsuCOiMrNLD77awTzvPoUiHS4DstjS83G4Ok+c3ZAalsDRXoRtlfMLASaiCznEaWcGnpnfd
        naaWVhwP95bld5pzYbjeYxFc10+9o2GRlwZbHcjwRVch0rgfUVaRIztNDo9G8f/6B4Xs1sTnFTO32
        DIEywmpwkgaaWXJxfGRL1TseR5ta58DeNwIast3MhzCdHKRcdzulOjZhkuBy1jIkUfg9yUQ9JJT2A
        kczN1rIsbZCZ2yMaPK4wNIbQLbMNO8WBuPwepZs7mbWnYhmJ7t8fqASvYqMRpcTA1zI6SysiFwTNW
        ESVTqvBp8olsFI1yo6qyiVu3BiSM858Rj7YnquFwrzKYKqbedt9EvbXIYdVP3c3RoWmgPG5jTMc/N
        Lyh1XViqtwiO6AvCSJjpF817;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1mWeoQ-001DcY-DC; Sat, 02 Oct 2021 13:12:22 +0000
From:   Ralph Boehme <slow@samba.org>
To:     linux-cifs@vger.kernel.org
Cc:     Ralph Boehme <slow@samba.org>
Subject: [PATCH v6 06/14] ksmbd: check buffer is big enough to access the ProtocolId field
Date:   Sat,  2 Oct 2021 15:12:04 +0200
Message-Id: <20211002131212.130629-7-slow@samba.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002131212.130629-1-slow@samba.org>
References: <20211002131212.130629-1-slow@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ralph Boehme <slow@samba.org>
---
 fs/ksmbd/smb2misc.c   | 25 +++++++++++++++++++++++++
 fs/ksmbd/smb2pdu.h    |  1 +
 fs/ksmbd/smb_common.c |  8 ++++++++
 3 files changed, 34 insertions(+)

diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index 9edd9c161b27..c1f0f10ca9f9 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -432,3 +432,28 @@ int smb2_negotiate_request(struct ksmbd_work *work)
 {
 	return ksmbd_smb_negotiate_common(work, SMB2_NEGOTIATE_HE);
 }
+
+/**
+ * ksmbd_smb2_cur_pdu_buflen() - Get len of current SMB2 PDU buffer
+ * This returns the lenght including any possible padding.
+ * @work: smb work containing request buffer
+ */
+unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work)
+{
+	struct smb2_hdr *hdr = ksmbd_req_buf_next(work);
+	unsigned int buf_len;
+	unsigned int pdu_len;
+
+	if (hdr->NextCommand != 0) {
+		/*
+		 * hdr->NextCommand has already been validated by
+		 * init_chained_smb2_rsp().
+		 */
+		return __le32_to_cpu(hdr->NextCommand);
+	}
+
+	buf_len = get_rfc1002_len(work->request_buf);
+	pdu_len = buf_len - work->next_smb2_rcv_hdr_off;
+	return pdu_len;
+}
+
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index a6dec5ec6a54..c5fa8256b0bb 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -1680,6 +1680,7 @@ int smb2_set_rsp_credits(struct ksmbd_work *work);
 
 /* smb2 misc functions */
 int ksmbd_smb2_check_message(struct ksmbd_work *work);
+unsigned int ksmbd_smb2_cur_pdu_buflen(struct ksmbd_work *work);
 
 /* smb2 command handlers */
 int smb2_handle_negotiate(struct ksmbd_work *work);
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index e1e5a071678e..0dc70ed2a5be 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -133,8 +133,16 @@ int ksmbd_lookup_protocol_idx(char *str)
 int ksmbd_verify_smb_message(struct ksmbd_work *work)
 {
 	struct smb2_hdr *smb2_hdr = ksmbd_req_buf_next(work);
+	unsigned int buflen = ksmbd_smb2_cur_pdu_buflen(work);
 	struct smb_hdr *hdr;
 
+	/*
+	 * ksmbd_smb2_check_message() will verify all SMB2 PDU buffer sizes,
+	 * here we just check we can access the ProtocolId field in the header.
+	 */
+	if (buflen < sizeof(smb2_hdr->ProtocolId))
+		return -EINVAL;
+
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
 		return ksmbd_smb2_check_message(work);
 
-- 
2.31.1

