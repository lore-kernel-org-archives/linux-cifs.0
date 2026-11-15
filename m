Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.143
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794748257;
	b=hDl5havsTIuFBQwaS85W2qmRy1ex4Jq6DQ9mSvb3vSAb88EKg1bBsPM+YD5Bm94TJLrb
	 ljzr34ZvgX8DeRIWApsG6qp9onTemWdSDhv3RwUvNOCULruV8gsZNHkp5iaFR2fMez+gc
	 tzcnuSlUqrivhnnvXoyrfg1ZZliDSIXVieqS1FIKa+v+3vrRF4GPBq2eeNF7kYjqMaRa4
	 ACPEaWadMvGc744zj/S0s/0zT62Tqlb/qQr+zDFKWOt5XfbkF13OXijRtzbEBEbLwYsfK
	 tdSC89I44VH34cxEpWGJJY1x/t3h8IOegJ2lUJ2T7r+W3HetW3m4RPMVsykXI2ZLpPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794748257;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OT4FeXl35Wtg7prNe9t4q4OanVhGByEupJ8DCWW0Zu0=;
	b=duQt9M3T+Ed6RW9YDoGbTj2AigIHwqKFAmNTmJdMLT/vaNRXdPpymMKNLk27mElarXFt
	 ZYhNzawRLtNhBflAOeozD3SNCBf7C0HZi2O3S9O+Nzj3A2/xCvH4cR3Rb1h/I5dmfAVbF
	 J3grfIAgHJ/X99VFKleEblWsw029bANSqN+ddK0ftDxJMSK7RP7apvPbkUuMHbhXtCPmE
	 FOJ82HeWQTAWOUKvAhwA9lhWHURh71WtNKz8rNUn9Bv8E0j3EU6vhGaKzgnJbYPYYDHg5
	 t70HlpytoiDg1dgTqJlI4x1Xv7cuHFTdE0hGM6tDfjJph5BUyFkWcibwFszd1oeS5kQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=VBAvAFaG;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=QpGATdJa;
	arc=none smtp.remote-ip=103.168.172.143
Received: from flow-a8-smtp.messagingengine.com (flow-a8-smtp.messagingengine.com [103.168.172.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4104606A31F
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 13:10:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4104606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=VBAvAFaG;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=QpGATdJa
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailflow.phl.internal (Postfix) with ESMTP id D7AEE13819D1
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 08:10:55 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-07.internal (MEProxy); Sun, 15 Nov 2026 08:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794748255; x=1794755455; bh=OT4FeXl35Wtg7prNe9t4q
	4OanVhGByEupJ8DCWW0Zu0=; b=VBAvAFaG2NxOtSxitihLNpDtxRhSTqGiPm+2b
	OyGb8uz4h3kyw9gtRbxTpt7enq4s7JyIAVXVgMFsWHYYho9+1VRd2dP3ol9jGw8X
	TnVyTrRcOioznZxlEOQP/Wk48+xKYwJEONcIRB/MZtQNy7ucOo0lNt2Uw1GkZrYK
	NGT1+meNKtioVCfvb2N3vfzBeneZQs4EnMe1JwVV6Jg36qkoGSVNqnSwhwv7IXas
	xarfuNQIPvMSv36pCW97GqglN1k/MCF2pT+wS0AVwNCVqpjt3stvM/E9PxOETLT8
	fplEjdM6BFj9f4//adA6bLgFbJvOAqOixgBoRxbDUmpV7xpvQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794748255; x=1794755455; bh=OT4FeXl35Wtg7prNe9t4q4OanVhGByEupJ8
	DCWW0Zu0=; b=QpGATdJasvCIxdd7OqsE+1+ojDS2Yc0J2czZBP0eebTsmUqa2Sr
	oN90V7c+hYKNDSbDjMBOYONuOU3gqC1Cair05CFkKIzCV198tWcgdcFeuXZjc2OW
	vwq127miOTCWIjiGur/bKR2IVv37lC4B44+M7JT3nkX0HHko8C1a9Y9n2abpeCiu
	vPsPs26kGyh/DbxV0Ccc1VCIiLM//zhW2c7ThoFgIkvdPD4eCCmyRy1yyYrAHGcT
	ZCpmC4v36oQksOlaJjKtRPqKpufOsm98AgHe2KzuzgAug1nvq7gWLP514q2uni0o
	vQx+cJRdpeNzGL9Rh+A0D7ODjhy5OxDLWWA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794748255; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:CJebEVOFc0K6D+M2N2NH6zjmS8L78vL0AoToIE+k5qqwpZS
	pwbXoxQftVRmXo2Hw0Oc/n2gsK2actTCcdZiOeCNLVnWWSPuKXb4NXHFcIaHrZ5A
	aipORnmVpg3XqyAOEUZQ8XqMQSP4k5lIuGz3uPiYdxNDqTO3nsY8UU6SGg10Oqs5
	K/rTCN8rxEfPHWawx/ti/ycCPsCgY2lNosaO6vWMS2cT5KCGgz3yp9fEwYVtYbhx
	KKvTFAhajU/wKPt2JeUqSc5sDKpyh65edue7gwVvJRyEJK5cHI1WV+VdG9QNsMlR
	Ax4+mnkpV3/K0JFXSt9v7dl6sRahPEi7i7uiPSg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:O8NH1FAPmoca8ODKi9/z5j8obHXtjHqqOLT4jqdvk7g=:kc8jFrtHGOCCuXz0LhqwqZVS1P4n1jlyVi1qGpltCp0=;
X-ME-Sender: <xms:X6_5aifvhwe3M2YueZ3YErh4mneyU5oLa1gzXgNioVLQtXf4_uOtHQ>
    <xme:X6_5aoPbaYAg9lhcOm676mWvhIrfVOCcjrFYevwQ2yYnEgvrWJeuN72dHImlOleyZ
    2l5d6I8SJ_DN6CNR3Il5qUKUo0rTkDG4QnydNmcdstCPzzm3ZPszy8>
X-ME-Received: <xmr:X6_5alt50UF5teFP36MV0tlJQXfW9o4JKvN4gXXnoVBVja0kebOhPQqVPPXhLJK3>
X-ME-Proxy-Cause: dmFkZTGPkveAdfc5w2ZRKxtHShmO68327dXLVpOEFJzba+fXOBZCJ9NDlEESf6ERyUzj3x
    kprTj0F1LHjUz47eZg6J6ex0YNYInfQozJZBKdXWoMKMBOpVl+raMJDhDKd0AwuDLlIeuo
    xdRWeI31Kg3v08ndDS0g6FIppPlY+MnPKljgamQdHFgveNvkROi8NS7pawEH5tIztHBzic
    sivyUg+63B5x9f3VatMOCtaT76oyxVDYejPyNmtPlUA34Xff8Devw64Nbcjv+Ed+bPAWiV
    qfR7zbL9Yk4Vi+PIS2Y3IAKCEjErGIpO7L4PEbzGvvf1VDonOj192IfsVE29cyqO4djECO
    oOp5kut41//YxJalsKAQWQc7sR4CDQPT8ASGchY5GLsAwxln0Uxwbf8ZHAAHzu7FaGM51N
    nTEdc8dSO1ugrYx4NT/V98E813ytn2XCVneEeVmA0F38N0dyx3pPrcriUpvYc4LFwMJMLZ
    miQAGDDpKrXCXKCcV8ADv6k4I6s0q2Sm+VLdOBCPojuQBNerboDS5SnpN7dSQ2rCNx7JgU
    HBYv9v804kvlSeJ2xPeIq2UjjCUdKauxFgxTwapTI0hoxtUB7H/p237ed80frRzfQvLadi
    AAmOrGElWwV1iGZ9bDqgVz7nFbjKxoypZ0qak3EGYJezBTJZ1ZrRiHAugpkg
X-ME-Proxy: <xmx:X6_5ahBO0DV_VGDTfrwu1vJ2L0Jz3nc0tDEtqfN2yU_tZIZwnpvIBA>
    <xmx:X6_5asZxsW2yWe3fqZrmvMwloJd9q2m-Kqkb1Gt1svkmui-eEboJ5w>
    <xmx:X6_5asUK2sRY7RGlNf6VDmdN-Z2PRVVcz2dSu6A7drx-OuPYZjybpA>
    <xmx:X6_5arPDn_vKCAXxWOUfsUwkDdcjJaKcoLpRIymJr0mLlzNLTJUdvQ>
    <xmx:X6_5aiAi9pNtLPSQ1sy5reKSDLIQSZJAxh5ZlqnrYa74DCJZG8OmBLgN>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 15 Nov 2026 08:10:54 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix smb2_cancel() use-after-free during request decompression
Date: Sun, 15 Nov 2026 07:10:47 -0600
Message-ID: <20261115131047.2338285-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_cancel() finds the request to cancel by reading the SMB2 header in
the request_buf of each queued struct ksmbd_work. A queued request may
still be in preprocessing. smb3_decrypt_req() decrypts it in place, and
ksmbd_decompress_work_request() frees request_buf and replaces it with
the decompressed buffer. Neither runs under conn->request_lock. A
concurrent CANCEL can therefore compare a transform header as if it were
an SMB2 header, or read freed memory.

  BUG: KASAN: slab-use-after-free in smb2_cancel+0x73b/0x840 [ksmbd]
  Call Trace:
   smb2_cancel+0x73b/0x840 [ksmbd]
   handle_ksmbd_work+0xa90/0x2110 [ksmbd]
  Freed by task 53136:
   ksmbd_decompress_work_request+0x10d/0x180 [ksmbd]

Record the MessageId and Command of each request in its struct
ksmbd_work, under conn->request_lock. A plain SMB2 request gets them
when it is queued, because its request_buf does not change. An encrypted
request gets them once it is decrypted and decompressed. smb2_cancel()
matches on these fields and skips a request that does not have them yet.
It no longer reads the request_buf of another request.

Fixes: 6639b6928ba2 ("ksmbd: handle encrypted compressed requests")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    The bug needs an authenticated client on an SMB 3.1.1 connection with
    encryption and compression negotiated. The client sends an encrypted,
    compressed request. An SMB2_CANCEL on the same connection is then
    processed while that request is being decompressed.
    
    A reproducer is available on request.
    
    Tested on ksmbd-for-next dc6eabb1bd40 under KASAN. The race window was
    widened with a temporary msleep() in ksmbd_decompress_work_request(),
    not part of this patch. A CANCEL sent during decompression no longer
    triggers the report. A sync CANCEL still finds an in-flight request by
    its MessageId, and an async CANCEL of a pending blocking lock still
    returns STATUS_CANCELLED. smbtorture results are unchanged.
    
    This fix was developed with LLM assistance.

 fs/smb/server/connection.c | 27 +++++++++++++++++++++++++++
 fs/smb/server/connection.h |  1 +
 fs/smb/server/ksmbd_work.h |  7 +++++++
 fs/smb/server/server.c     |  2 ++
 fs/smb/server/smb2pdu.c    | 18 +++++++++---------
 5 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 0fcf90b877ae..01e5cc13a12a 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -352,6 +352,32 @@ bool ksmbd_conn_lookup_dialect(struct ksmbd_conn *c)
 	return ret;
 }
 
+/* Caller holds conn->request_lock */
+static void __ksmbd_conn_set_request_id(struct ksmbd_work *work)
+{
+	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
+
+	if (hdr->ProtocolId != SMB2_PROTO_NUMBER)
+		return;
+
+	work->req_mid = hdr->MessageId;
+	work->req_cmd = hdr->Command;
+	work->req_id_valid = true;
+}
+
+/*
+ * Record the MessageId and Command of a request whose request_buf now holds
+ * a plain SMB2 header, after decryption and decompression replaced it
+ */
+void ksmbd_conn_set_request_id(struct ksmbd_work *work)
+{
+	struct ksmbd_conn *conn = work->conn;
+
+	spin_lock(&conn->request_lock);
+	__ksmbd_conn_set_request_id(work);
+	spin_unlock(&conn->request_lock);
+}
+
 void ksmbd_conn_enqueue_request(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
@@ -363,6 +389,7 @@ void ksmbd_conn_enqueue_request(struct ksmbd_work *work)
 	atomic_inc(&conn->req_running);
 	if (requests_queue) {
 		spin_lock(&conn->request_lock);
+		__ksmbd_conn_set_request_id(work);
 		list_add_tail(&work->request_entry, requests_queue);
 		spin_unlock(&conn->request_lock);
 	}
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index e202bf7f3b98..6855c1ab691e 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -242,6 +242,7 @@ int ksmbd_conn_rdma_write(struct ksmbd_conn *conn,
 			  void *buf, unsigned int buflen,
 			  struct smbdirect_buffer_descriptor_v1 *desc,
 			  unsigned int desc_len);
+void ksmbd_conn_set_request_id(struct ksmbd_work *work);
 void ksmbd_conn_enqueue_request(struct ksmbd_work *work);
 void ksmbd_conn_try_dequeue_request(struct ksmbd_work *work);
 void ksmbd_conn_init_server_callbacks(struct ksmbd_conn_ops *ops);
diff --git a/fs/smb/server/ksmbd_work.h b/fs/smb/server/ksmbd_work.h
index 1ab9ddd20506..27c8705910fe 100644
--- a/fs/smb/server/ksmbd_work.h
+++ b/fs/smb/server/ksmbd_work.h
@@ -36,6 +36,13 @@ struct ksmbd_work {
 
 	/* Pointer to received SMB header */
 	void                            *request_buf;
+	/*
+	 * MessageId and Command of the request, set under conn->request_lock
+	 * once request_buf holds a plain SMB2 header, for smb2_cancel()
+	 */
+	__le64                          req_mid;
+	__le16                          req_cmd;
+	bool                            req_id_valid;
 	/* Response buffer */
 	void                            *response_buf;
 
diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index e91e3a1459e5..962f12e969ba 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -295,6 +295,8 @@ static void __handle_ksmbd_work(struct ksmbd_work *work,
 			ksmbd_conn_abort(conn);
 			return;
 		}
+
+		ksmbd_conn_set_request_id(work);
 	}
 
 	if (conn->ops->allocate_rsp_buf(work))
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d8da0b259cfd..dda5f4ddbb43 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -10698,7 +10698,6 @@ int smb2_cancel(struct ksmbd_work *work)
 {
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
-	struct smb2_hdr *chdr;
 	struct ksmbd_work *iter;
 	struct list_head *command_list;
 
@@ -10715,8 +10714,6 @@ int smb2_cancel(struct ksmbd_work *work)
 		spin_lock(&conn->request_lock);
 		list_for_each_entry(iter, command_list,
 				    async_request_entry) {
-			chdr = smb_get_msg(iter->request_buf);
-
 			if (iter->async_id !=
 			    le64_to_cpu(hdr->Id.AsyncId))
 				continue;
@@ -10736,7 +10733,7 @@ int smb2_cancel(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "smb2 with AsyncId %llu cancelled command = 0x%x\n",
 				    le64_to_cpu(hdr->Id.AsyncId),
-				    le16_to_cpu(chdr->Command));
+				    le16_to_cpu(iter->req_cmd));
 			if (iter->cancel_fn)
 				iter->cancel_fn(iter->cancel_argv);
 			break;
@@ -10747,10 +10744,13 @@ int smb2_cancel(struct ksmbd_work *work)
 
 		spin_lock(&conn->request_lock);
 		list_for_each_entry(iter, command_list, request_entry) {
-			chdr = smb_get_msg(iter->request_buf);
-
-			if (chdr->MessageId != hdr->MessageId ||
-			    iter == work)
+			/*
+			 * request_buf of another work may be replaced while
+			 * it is decrypted or decompressed, so match on the
+			 * MessageId recorded under request_lock instead.
+			 */
+			if (iter == work || !iter->req_id_valid ||
+			    iter->req_mid != hdr->MessageId)
 				continue;
 
 			if (cmpxchg(&iter->state, KSMBD_WORK_ACTIVE,
@@ -10760,7 +10760,7 @@ int smb2_cancel(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "smb2 with mid %llu cancelled command = 0x%x\n",
 				    le64_to_cpu(hdr->MessageId),
-				    le16_to_cpu(chdr->Command));
+				    le16_to_cpu(iter->req_cmd));
 			if (iter->cancel_fn)
 				iter->cancel_fn(iter->cancel_argv);
 			break;

base-commit: dc6eabb1bd40c0655837844c58432ae9095f6979
-- 
2.47.3

