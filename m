Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CE322A817
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 12:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786968948; cv=none; b=dv+887uW17ZSojIYKHx/ZhP8BwJw+tOb0kf/Btw4d4rcCG0vrEwHkUFZ9aMLy30JYjCbF0KIbRT1teaHh2rV5w9XlKTi6oOFQdw6T6QbyEBodRHIb3A1XWmjaZ76mB/O/k0MndOcYO36QrPbxp9bWM+JGHUd8/goTG4NGBB4WmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786968948; c=relaxed/simple;
	bh=Y44y+wF/fpBrg/1M0T+fkLnRW2AH9zzRS98+fWDeXos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AUfhXvp24AquZS+zS1F9XY5uGCxLabpuOUsaXkyn2qWL6w2eUsdFC29oI8cLOgR9r/ANPHM7y9tMUFEyNTBkyJah7ifyhP7PZXfxArtl+Bi7ugrYPwnR4bQ92hxYu4vCHSMGsVdy86OvoHF8l9t/0uw0uJ4I05RicwX7Tg1qVLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CDIuvUUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CDIuvUUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734401F00A3A;
	Mon, 17 Aug 2026 12:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786968947;
	bh=u1qHoaTi6O4i+/NVAx9kYuhc87BSNXppgGuXtfwsBdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDIuvUUBRSnWDEfNnzvAUdMqDz2M0YVj0VAFlTphu1294DUhCxWthNWRpWwzCIWLo
	 DaGOM9dO1BbgZ0wsA55BNRrMdWATDfK53Q6GheqziW/MUOcAa3U/Us1HfVitRyW9zh
	 4iFdhjtuUWrkLZ4ODz5tS+RCNKuY7qb2H8kYVJqplu8WWiKo1wvtgdGhaAsnEmgVo/
	 g6wnK4Rw54eTZIIl2anZFrysLGEiRZsdro6s7cQ/vJ3DWrpGtTHCw4cb2I2dmxhlPj
	 iHdooUfXVck/H5cUxT+02aU5IXvzYkEiBbCMBuQ4H7EDZyWQdUIVMlOuZkZNPqjBSZ
	 cWdNvCYiJgG7g==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: encrypt interim responses to encrypted requests
Date: Mon, 17 Aug 2026 21:15:19 +0900
Message-Id: <20260817121524.8812-7-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817121524.8812-1-linkinjeon@kernel.org>
References: <20260817121524.8812-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The normal response path applies an SMB3 transform when the request was
encrypted.  Async interim responses, completed compound prefixes and two
CHANGE_NOTIFY cleanup paths write their synthetic response work directly,
bypassing that encryption step.

A packet capture shows FE SMB2 STATUS_PENDING, CREATE and CHANGE_NOTIFY
responses following FD SMB3 requests.  The client resets the connection
immediately after receiving those plaintext responses.

Send synthetic interim work through a common helper that applies the
session encryption transform first.  A compound prefix shares the original
work's response iov, which encryption would replace in place, so flatten it
into an independently owned work before encrypting and sending it.

Fixes: 64bfa9d49026 ("smb/server: use MSG_EOR for async interim response")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 71 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 67 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 6581c79635fa..ade16532a8c1 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1124,6 +1124,66 @@ void release_async_work(struct ksmbd_work *work)
 	}
 }
 
+static int smb2_send_interim_work(struct ksmbd_work *in_work,
+				  struct ksmbd_work *work, bool eor)
+{
+	int err = 0;
+
+	in_work->encrypted = work->encrypted;
+	if (work->encrypted && work->sess && work->sess->enc &&
+	    work->conn->ops->encrypt_resp) {
+		in_work->sess = work->sess;
+		err = work->conn->ops->encrypt_resp(in_work);
+		in_work->sess = NULL;
+	}
+	if (err)
+		return err;
+
+	return eor ? ksmbd_conn_write_eor(in_work) :
+		ksmbd_conn_write(in_work);
+}
+
+static int smb2_send_interim_prefix_work(struct ksmbd_work *work)
+{
+	struct ksmbd_work *in_work;
+	unsigned int len, copied = 0;
+	char *dst;
+	int err = -ENOMEM;
+	int i;
+
+	len = get_rfc1002_len(work->iov[0].iov_base);
+	in_work = ksmbd_alloc_work_struct();
+	if (!in_work)
+		return err;
+
+	in_work->response_buf = kvzalloc(len + 4, KSMBD_DEFAULT_GFP);
+	if (!in_work->response_buf)
+		goto out;
+	in_work->response_sz = len + 4;
+	in_work->conn = work->conn;
+	dst = in_work->response_buf + 4;
+	for (i = 1; i <= work->iov_idx; i++) {
+		if (work->iov[i].iov_len > len - copied) {
+			err = -EINVAL;
+			goto out;
+		}
+		memcpy(dst + copied, work->iov[i].iov_base,
+		       work->iov[i].iov_len);
+		copied += work->iov[i].iov_len;
+	}
+	if (copied != len) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	err = ksmbd_iov_pin_rsp(in_work, dst, len);
+	if (!err)
+		err = smb2_send_interim_work(in_work, work, true);
+out:
+	ksmbd_free_work_struct(in_work);
+	return err;
+}
+
 static void smb2_send_interim_compound_prefix(struct ksmbd_work *work)
 {
 	struct smb2_hdr *req_hdr;
@@ -1152,7 +1212,7 @@ static void smb2_send_interim_compound_prefix(struct ksmbd_work *work)
 	    work->conn->ops->set_sign_rsp)
 		work->conn->ops->set_sign_rsp(work);
 
-	err = ksmbd_conn_write_eor(work);
+	err = smb2_send_interim_prefix_work(work);
 	if (err)
 		ksmbd_debug(SMB, "failed to send compound interim prefix: %d\n",
 			    err);
@@ -1193,7 +1253,8 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
 
-	ksmbd_conn_write_eor(in_work);
+	if (smb2_send_interim_work(in_work, work, true))
+		ksmbd_debug(SMB, "failed to send interim response\n");
 	ksmbd_free_work_struct(in_work);
 }
 
@@ -11310,7 +11371,8 @@ int smb2_notify(struct ksmbd_work *work)
 		in_work->async_id = work->async_id;
 		work->async_id = 0;
 		release_async_work(work);
-		ksmbd_conn_write(in_work);
+		if (smb2_send_interim_work(in_work, work, false))
+			ksmbd_debug(SMB, "failed to send notify cleanup\n");
 		ksmbd_free_work_struct(in_work);
 		work->send_no_response = 1;
 		return 0;
@@ -11415,7 +11477,8 @@ int smb2_notify(struct ksmbd_work *work)
 		in_work->cancel_fn = NULL;
 		in_work->asynchronous = false;
 		ksmbd_fd_put(work, fp);
-		ksmbd_conn_write(in_work);
+		if (smb2_send_interim_work(in_work, work, false))
+			ksmbd_debug(SMB, "failed to send notify cleanup\n");
 		ksmbd_free_work_struct(in_work);
 		work->send_no_response = 1;
 		return 0;
-- 
2.25.1

