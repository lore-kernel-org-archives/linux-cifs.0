Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=173.212.254.19
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793168409;
	b=cl9tKCo4mGfi4/uDa77D+dFOyAha4yNM76rmHTkplv2Wh7keRepsde5kVs6myQ/1NXsy
	 dqNDFD9RDTLrW20sq/BTuMneVpqwB6CXI2W0TxQct0KJLeV2XlGqWMhfsYWVopG9VB644
	 JpvGD/u7bBQigHg8DaHZ+0gRxPwWSPp+zLsqJCXIbuobLChVjmVrJl6Qp9HtoEJqho4qo
	 3bsNnscH1YQJp7tutzWjOryNAw1gEQkf7IZtApwuwb6LMSTutuRGJk1DRKwWeiRc4TvO1
	 DVsZ3bZaxiVPAoBzoFnhsat6Suc9z+iwNBh/Vt0NxywRYR/f4+AH6QS++B2r+jvOE7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793168409;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:In-Reply-To:
	 References:From:Subject:To:Cc:Date;
	bh=X1KfdMZcAgnCUD23j/0cYj+kYJCpxMw2VuBfm46fahY=;
	b=VncGRRnKD+sWdw7N2arf0Chnu02ORheZA8tvBAiY3cDG2yPgtSs+pGTJj4jY+SujdsDs
	 0c+YhB9GKlpi8okZlDw5O8xhWIsggQiaSKKsuB2b8g8P1gWU3ZCVq+iw6aUdlzswC7Kwo
	 prbNQRb+1ro3OyJD2WpG8AkafyyiJvX2X4K0c2EaFHD//tKIHiMR6JRQc2RRrxADJElXZ
	 BG5IEXjEyNeD4kXL/nCAmCENw1gnxmxRfbfVaJ33qAaPoaYpfWvPHbu0FBMXq4df2hs5O
	 g/nMjAiw18xotUGyKicPcT96WRXxP82sYr+0VLSblMnLiA2cdMpOtAXAA5iQ8jS/a9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=tuxist.de;
	spf=fail smtp.mailfrom=tuxist.de;
	dkim=pass header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=SsY9pSii;
	arc=none smtp.remote-ip=173.212.254.19
Received: from groupware.tuxist.de (groupware.tuxist.de [173.212.254.19])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A71C606A325;
	Wed, 28 Oct 2026 06:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A71C606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=tuxist.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=tuxist.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=tuxist.de header.i=@tuxist.de header.a=rsa-sha256 header.s=201705 header.b=SsY9pSii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tuxist.de; s=201705;
	t=1793168406; bh=WkR0tts4YKtMS6lQOPzU+Mt5nFvgoUbdvH+VD+1rGq0=;
	h=In-Reply-To:References:From:Subject:To:Cc:Date:From;
	b=SsY9pSiiI4Gq4haJxM3uuAPVGVef5zlKZllCx1loYxvw0sx7O2Z7W9OTTtDysb32d
	 x3f8l6SE4X87sssmxKM6OZEKz3Z5fEGcQ2eKMuFi+Rq/euVN+tO/nphnBz2ekJGXJh
	 tY/aYcj+JLCPkbHEGX6DkfWL78VEbcpIDD5fMAVgsPfA8p0lzkeLofdmK7FH7L0OuO
	 mCec6tQ0UxSiSVj9JdndNzjVl1dXpTyNMUQhnzYcCctXjusDagbb25+Eg/9piFliQd
	 FlCSVS8OB92lY+p7uDkUez/I9zoKq4HwzxGlSkyCZqJAXKYVN9BP+MF24+MlaBZNz7
	 bOFRIpiUj1/ZQ==
Received: from [10.1.1.106] (unknown [10.1.2.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by groupware.tuxist.de (Postfix) with ESMTPSA id 932A88A096E;
	Wed, 28 Oct 2026 07:20:06 +0100 (CET)
Message-ID: <b170f21edb72c12d46cfa86cc210d6ac2614f5e7.1793168155.git.jan.koester@tuxist.de>
In-Reply-To: <cover.1793168155.git.jan.koester@tuxist.de>
References: <cover.1793168155.git.jan.koester@tuxist.de>
From: Jan Koester <jan.koester@tuxist.de>
Subject: [RFC PATCH 3/6] ksmbd: pass the domain of an NTLM login to user space
To: Namjae Jeon <linkinjeon@kernel.org>,
    Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
    Tom Talpey <tom@talpey.com>,
    ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
    Christian Brauner <brauner@kernel.org>,
    linux-cifs@vger.kernel.org,
    linux-fsdevel@vger.kernel.org,
    samba-technical@lists.samba.org,
    linux-kernel@vger.kernel.org
Date: Wed, 28 Oct 2026 07:20:00 +0100
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list

The login request carries only the user name, though NTLMSSP's
AUTHENTICATE message names the domain too. A user space serving several
domains (or local accounts next to a domain's) can't tell DOMAIN\user
apart from OTHER\user, picks the first account of that name, and a
session that the domain controller then authenticates as one domain's
user runs with another account's ids.

Put the domain into the formerly reserved room of struct
ksmbd_login_request, flagged with KSMBD_LOGIN_REQ_DOMAIN, so the
structure keeps its size and older user space keeps working. Ask for
the login response extension by the account name user space answered
with: that one is unambiguous, the client's may not be.

Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Jan Koester <jan.koester@tuxist.de>
---
 fs/smb/server/ksmbd_netlink.h    | 12 +++++++++++-
 fs/smb/server/mgmt/user_config.c | 16 ++++++++++++----
 fs/smb/server/mgmt/user_config.h |  2 +-
 fs/smb/server/smb2pdu.c          | 20 ++++++++++++++++----
 fs/smb/server/transport_ipc.c    | 12 +++++++++++-
 fs/smb/server/transport_ipc.h    |  2 +-
 6 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/smb/server/ksmbd_netlink.h b/fs/smb/server/ksmbd_netlink.h
index 3fa1c7f801..3df5264ad7 100644
--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
@@ -66,6 +66,7 @@
 #define KSMBD_GENL_VERSION		0x01
 
 #define KSMBD_REQ_MAX_ACCOUNT_NAME_SZ	48
+#define KSMBD_REQ_MAX_DOMAIN_NAME_SZ	48
 #define KSMBD_REQ_MAX_HASH_SZ		18
 #define KSMBD_REQ_MAX_SHARE_NAME	64
 
@@ -140,9 +141,18 @@ struct ksmbd_shutdown_request {
 struct ksmbd_login_request {
 	__u32	handle;
 	__s8	account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ]; /* user account name */
-	__u32	reserved[16];				/* Reserved room */
+	__u32	flags;				/* KSMBD_LOGIN_REQ_* */
+	__s8	domain[KSMBD_REQ_MAX_DOMAIN_NAME_SZ];	/* with _DOMAIN */
+	__u32	reserved[3];			/* Reserved room */
 };
 
+/*
+ * The domain the client named with the account (NTLMSSP DomainName): user
+ * space serving several domains can tell their accounts of the same name
+ * apart. Formerly reserved, so zero from older ksmbd.
+ */
+#define KSMBD_LOGIN_REQ_DOMAIN		BIT(0)
+
 /*
  * IPC user login response.
  */
diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_config.c
index cb175a4c78..a25eb0647c 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -9,21 +9,29 @@
 #include "user_config.h"
 #include "../transport_ipc.h"
 
-struct ksmbd_user *ksmbd_login_user(const char *account)
+struct ksmbd_user *ksmbd_login_user(const char *account, const char *domain)
 {
 	struct ksmbd_login_response *resp;
 	struct ksmbd_login_response_ext *resp_ext = NULL;
 	struct ksmbd_user *user = NULL;
 
-	resp = ksmbd_ipc_login_request(account);
+	resp = ksmbd_ipc_login_request(account, domain);
 	if (!resp)
 		return NULL;
 
 	if (!(resp->status & KSMBD_USER_FLAG_OK))
 		goto out;
 
-	if (resp->status & KSMBD_USER_FLAG_EXTENSION)
-		resp_ext = ksmbd_ipc_login_request_ext(account);
+	/*
+	 * The extension of the account user space found: the name it
+	 * answered with is unambiguous, the one the client gave may not be.
+	 */
+	if (resp->status & KSMBD_USER_FLAG_EXTENSION) {
+		resp->account[KSMBD_REQ_MAX_ACCOUNT_NAME_SZ - 1] = '\0';
+		resp_ext = ksmbd_ipc_login_request_ext(resp->account[0] ?
+						       (const char *)resp->account :
+						       account);
+	}
 
 	user = ksmbd_alloc_user(resp, resp_ext);
 	kvfree(resp_ext);
diff --git a/fs/smb/server/mgmt/user_config.h b/fs/smb/server/mgmt/user_config.h
index e55470e008..0035675e03 100644
--- a/fs/smb/server/mgmt/user_config.h
+++ b/fs/smb/server/mgmt/user_config.h
@@ -63,7 +63,7 @@ static inline unsigned int user_gid(struct ksmbd_user *user)
 	return user->gid;
 }
 
-struct ksmbd_user *ksmbd_login_user(const char *account);
+struct ksmbd_user *ksmbd_login_user(const char *account, const char *domain);
 struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_login_response *resp,
 		struct ksmbd_login_response_ext *resp_ext);
 void ksmbd_free_user(struct ksmbd_user *user);
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 8e47d725c1..db7f677b07 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2169,8 +2169,8 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 {
 	struct authenticate_message *authblob;
 	struct ksmbd_user *user;
-	char *name;
-	unsigned int name_off, name_len, secbuf_len;
+	char *name, *domain = NULL;
+	unsigned int name_off, name_len, dom_off, dom_len, secbuf_len;
 
 	if (conn->use_spnego && conn->mechToken)
 		secbuf_len = conn->mechTokenLen;
@@ -2196,8 +2196,20 @@ static struct ksmbd_user *session_user(struct ksmbd_conn *conn,
 		return NULL;
 	}
 
-	ksmbd_debug(SMB, "session setup request for user %s\n", name);
-	user = ksmbd_login_user(name);
+	/* DOMAIN\user: which of several domains' user of that name */
+	dom_off = le32_to_cpu(authblob->DomainName.BufferOffset);
+	dom_len = le16_to_cpu(authblob->DomainName.Length);
+	if (dom_len && secbuf_len >= (u64)dom_off + dom_len) {
+		domain = smb_strndup_from_utf16((const char *)authblob + dom_off,
+						dom_len, true, conn->local_nls);
+		if (IS_ERR(domain))
+			domain = NULL;
+	}
+
+	ksmbd_debug(SMB, "session setup request for user %s domain %s\n",
+		    name, domain ? domain : "");
+	user = ksmbd_login_user(name, domain);
+	kfree(domain);
 	kfree(name);
 	return user;
 }
diff --git a/fs/smb/server/transport_ipc.c b/fs/smb/server/transport_ipc.c
index 7bbe1b3607..4d2f16b96e 100644
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -648,7 +648,12 @@ static int ksmbd_ipc_heartbeat_request(void)
 	return ret;
 }
 
-struct ksmbd_login_response *ksmbd_ipc_login_request(const char *account)
+/*
+ * @domain: the domain the client named (NULL or "": none); one too long to
+ * pass is left out, user space then decides by the account alone
+ */
+struct ksmbd_login_response *ksmbd_ipc_login_request(const char *account,
+						     const char *domain)
 {
 	struct ksmbd_ipc_msg *msg;
 	struct ksmbd_login_request *req;
@@ -665,6 +670,11 @@ struct ksmbd_login_response *ksmbd_ipc_login_request(const char *account)
 	req = (struct ksmbd_login_request *)msg->payload;
 	req->handle = ksmbd_acquire_id(&ipc_ida);
 	strscpy(req->account, account, KSMBD_REQ_MAX_ACCOUNT_NAME_SZ);
+	if (domain && domain[0] &&
+	    strlen(domain) < KSMBD_REQ_MAX_DOMAIN_NAME_SZ) {
+		req->flags |= KSMBD_LOGIN_REQ_DOMAIN;
+		strscpy(req->domain, domain, KSMBD_REQ_MAX_DOMAIN_NAME_SZ);
+	}
 
 	resp = ipc_msg_send_request(msg, req->handle);
 	ipc_msg_handle_free(req->handle);
diff --git a/fs/smb/server/transport_ipc.h b/fs/smb/server/transport_ipc.h
index f957a33ae3..1aefa23264 100644
--- a/fs/smb/server/transport_ipc.h
+++ b/fs/smb/server/transport_ipc.h
@@ -11,7 +11,7 @@
 #define KSMBD_IPC_MAX_PAYLOAD	4096
 
 struct ksmbd_login_response *
-ksmbd_ipc_login_request(const char *account);
+ksmbd_ipc_login_request(const char *account, const char *domain);
 struct ksmbd_login_response_ext *
 ksmbd_ipc_login_request_ext(const char *account);
 
-- 
2.56.0

