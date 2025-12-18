Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A1736CE05
	for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766074860; cv=none; b=JuBw2WZJ+/mz8/d7APQHmLtZcktF9WMTwNdu4xfWIFu0HTy5e13AD6sPqnPev4vLOxgp7I7OdvwsvdCdcfYwkSN6W/faHPLhBBa2ODLN/lu5ZJfux9xj7nxJxfYLHTfYIDPVPGqhn/4GHrVSsWAaaoAsD2pQy2uCiLhKG3BpBFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766074860; c=relaxed/simple;
	bh=lzhzGU33uYKcCm6b+KBjodl3z3WaeVPZiGVdzRLcwnU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=D0bL56LoDDqmHHaEUVkk66mD9/SdLnI9QYANDwQso18vKoi0370cAPWYb51puFIal367qpxuUSSKf0sn+QQVkUVBwatSnlfIo1jeV6qBRHOY6rJt1VXAUBSfCQpEUNJTlMc1a5x0LJhQtcbiAxNmEw0Nk42wcQy0P5JlllWfYE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a09757004cso9482875ad.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Dec 2025 08:20:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766074856; x=1766679656;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amyqJV6tu7KGISF9s2bJn5b7pUqfE+j1xTAHlYWRpog=;
        b=VdR+Nk+KzLpeSvw73ZOFjMHuzPnFPFAWCAU61bwhkHSYtlS5u5NhRtqhmIslrAOYL1
         fJoaHWICTzRM7wvSIFawTgntZozLT7pHK8ivSY9S1Erf30T4k9nu7nSsiZLisBdPJ8Ek
         pgDtUQticmKolgXqWKgX171m6kNLPgyVb4DWwBi1TUiQimQQRnohHWH+4W1uWPQL+R1S
         7CIXG1aKk1llBDIR9TeKiiA7TZwVe/m0OH965+0MrUx76brOGfRl2vmRm+NkuDGXGQIA
         lLMIem/GZh2RqLDqG3L7dAIgeGth6FLPS3Gu9jrIBmNRGEsyAd9QAvOaOU6/5DeqO/dB
         eG8g==
X-Gm-Message-State: AOJu0YzRVJzT9FWy4s+BefgmvaH881opuqkXNhgOj1Wi9TXUMBVVbVlz
	wHnaQjnavG8qdP7khJEccTHu0cXsPFYumX7roXr8HLI6+Xq+N+wyEBZaa9bL/Q==
X-Gm-Gg: AY/fxX4pBRW4JVaWLAwblTk8f+BOGULBk1dnWdZbGvT66VGQUkxlOmoiZLaZbb2tcgE
	j7+1LRwi159SA9Jx3UkAqI1IpsdLQdDhbLHAux9Lk9X4MhDbD6GXxzqewDgDSDEAScLj0WDceY4
	hvDQnQt15oKZPpbSCGsrDEhUZS7AQ7fkrdlIBnCFYeFrj9510hyXya/WHNq7Bg+vMgQiv9IRRrB
	DGIC4JioGODrn1fcgTAnE/fOkWqdCnqAOxT/H8HcHPxvAF7FXPzBBEHl1DEkEYcenQPh0yhAS4V
	rpgMgDZu3hV+RUWRth5dyhHPGCsC6v3Lc2MUByTRa9ces4S+aSmGfUuwYa16IAPvxR+VRhN3yNE
	08z8qI+eF2zmMwpy3H/z18Onle2gVurcsImYBJBuFqkiBqD+VWiogmq5Yu1EUwR+1Cc/VDp+V3g
	mW1BAKxA4YQD8RejkVwTzdjRmh0Q==
X-Google-Smtp-Source: AGHT+IHahbFKimvqZhNFjZbnXG4Wr5aSUp5XnXpSId7Ultv++btxnOZbSz10HpRHzubbs+yzv2B4Ig==
X-Received: by 2002:a17:902:c405:b0:2a2:f0cb:df98 with SMTP id d9443c01a7336-2a2f0cbe061mr1316165ad.25.1766074856010;
        Thu, 18 Dec 2025 08:20:56 -0800 (PST)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d16122cfsm30268485ad.57.2025.12.18.08.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 08:20:55 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Subject: [PATCH v2] ksmbd: Fix to handle removal of rfc1002 header from smb_hdr
Date: Fri, 19 Dec 2025 01:20:34 +0900
Message-Id: <20251218162034.9024-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

The commit that removed the RFC1002 header from struct smb_hdr didn't also
fix the places in ksmbd that use it in order to provide graceful rejection
of SMB1 protocol requests.

Fixes: 83bfbd0bb902 ("cifs: Remove the RFC1002 header from smb_hdr")
Reported-by: Namjae Jeon <linkinjeon@kernel.org>
Link: https://lore.kernel.org/r/CAKYAXd9Ju4MFkkH5Jxfi1mO0AWEr=R35M3vQ_Xa7Yw34JoNZ0A@mail.gmail.com/
Cc: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/server.c     |  2 +-
 fs/smb/server/smb_common.c | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/smb/server/server.c b/fs/smb/server/server.c
index 3cea16050e4f..bedc8390b6db 100644
--- a/fs/smb/server/server.c
+++ b/fs/smb/server/server.c
@@ -95,7 +95,7 @@ static inline int check_conn_state(struct ksmbd_work *work)
 
 	if (ksmbd_conn_exiting(work->conn) ||
 	    ksmbd_conn_need_reconnect(work->conn)) {
-		rsp_hdr = work->response_buf;
+		rsp_hdr = smb2_get_msg(work->response_buf);
 		rsp_hdr->Status.CifsError = STATUS_CONNECTION_DISCONNECTED;
 		return 1;
 	}
diff --git a/fs/smb/server/smb_common.c b/fs/smb/server/smb_common.c
index b23203a1c286..6d7b4449276b 100644
--- a/fs/smb/server/smb_common.c
+++ b/fs/smb/server/smb_common.c
@@ -140,7 +140,7 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
 	if (smb2_hdr->ProtocolId == SMB2_PROTO_NUMBER)
 		return ksmbd_smb2_check_message(work);
 
-	hdr = work->request_buf;
+	hdr = smb2_get_msg(work->request_buf);
 	if (*(__le32 *)hdr->Protocol == SMB1_PROTO_NUMBER &&
 	    hdr->Command == SMB_COM_NEGOTIATE) {
 		work->conn->outstanding_credits++;
@@ -278,15 +278,14 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 						  req->DialectCount);
 	}
 
-	proto = *(__le32 *)((struct smb_hdr *)buf)->Protocol;
 	if (proto == SMB1_PROTO_NUMBER) {
 		struct smb_negotiate_req *req;
 
-		req = (struct smb_negotiate_req *)buf;
+		req = (struct smb_negotiate_req *)smb2_get_msg(buf);
 		if (le16_to_cpu(req->ByteCount) < 2)
 			goto err_out;
 
-		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
+		if (offsetof(struct smb_negotiate_req, DialectsArray) +
 			le16_to_cpu(req->ByteCount) > smb_buf_length) {
 			goto err_out;
 		}
@@ -320,8 +319,8 @@ static u16 get_smb1_cmd_val(struct ksmbd_work *work)
  */
 static int init_smb1_rsp_hdr(struct ksmbd_work *work)
 {
-	struct smb_hdr *rsp_hdr = (struct smb_hdr *)work->response_buf;
-	struct smb_hdr *rcv_hdr = (struct smb_hdr *)work->request_buf;
+	struct smb_hdr *rsp_hdr = (struct smb_hdr *)smb2_get_msg(work->response_buf);
+	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb2_get_msg(work->request_buf);
 
 	rsp_hdr->Command = SMB_COM_NEGOTIATE;
 	*(__le32 *)rsp_hdr->Protocol = SMB1_PROTO_NUMBER;
@@ -412,9 +411,10 @@ static int init_smb1_server(struct ksmbd_conn *conn)
 
 int ksmbd_init_smb_server(struct ksmbd_conn *conn)
 {
+	struct smb_hdr *rcv_hdr = (struct smb_hdr *)smb2_get_msg(conn->request_buf);
 	__le32 proto;
 
-	proto = *(__le32 *)((struct smb_hdr *)conn->request_buf)->Protocol;
+	proto = *(__le32 *)rcv_hdr->Protocol;
 	if (conn->need_neg == false) {
 		if (proto == SMB1_PROTO_NUMBER)
 			return -EINVAL;
@@ -572,12 +572,12 @@ static int __smb2_negotiate(struct ksmbd_conn *conn)
 
 static int smb_handle_negotiate(struct ksmbd_work *work)
 {
-	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
+	struct smb_negotiate_rsp *neg_rsp = smb2_get_msg(work->response_buf);
 
 	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
 
-	if (ksmbd_iov_pin_rsp(work, (void *)neg_rsp + 4,
-			      sizeof(struct smb_negotiate_rsp) - 4))
+	if (ksmbd_iov_pin_rsp(work, (void *)neg_rsp,
+			      sizeof(struct smb_negotiate_rsp)))
 		return -ENOMEM;
 
 	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
-- 
2.25.1

