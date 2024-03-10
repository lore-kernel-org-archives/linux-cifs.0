Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C7C200D6
	for <linux-cifs@vger.kernel.org>; Sun, 10 Mar 2024 12:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710072257; cv=none; b=eHs8i3/95k11g4f7ZwvVmvTygL6Z3NjukvyUlryzZyDEkyg/LC1mGhTtxnW1b8Qrr3sDOXcHounSn8jdB8m6eLlcgiHdO6xc+qZny1vqw/76mZamoRJzRihjp+4J/4LbkS+lIKqSzppRv4Ugc5OJozre96nNpUr1oyTM5ZGXyhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710072257; c=relaxed/simple;
	bh=iPB2DvYynjKHXuJgRk87dwXcF218Dk5M7obXweLilzE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dF5GkF69lrIoOfrArYATl5PvdX5kUVzNT5+LUDKZ2AMDzmSHaRVh22gflN15ApKKDtcz3H6gLXx3BtNRBlXZwIbT8ZIpWKq4iLfTXYWVeLP3gJrYILfKerFUiEmfziA4ktcGmu61jvsG9o2/gnj8GvPrBM3FBTFTPIzAnhwBvcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5dc949f998fso3242173a12.3
        for <linux-cifs@vger.kernel.org>; Sun, 10 Mar 2024 05:04:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710072255; x=1710677055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mwLhe0zzWCR1jz5ADJVoXywNQBzD30yh+g/FHbzyq+g=;
        b=NzZvq3yXH/qUysXji/6pzi2IVA+8IauIYqMOn43ozB77tUeWzusLnaPoGH4HwiwMvj
         M7nR++2cIu+g8HWaHQYaFrRPP8yTzFuKk3dtiOe1Ii/TESVNmL3zXl8vJDpBP8bcrh+k
         l1ZFSf+7u0nIide2TFldIiLkYTytECwIQxU/w/oXLcCX4RhpzbsuoTuL11LZYgptSShK
         Qs2Qpk0ZLsNYRaf30jDg+xan6C/WSEPfmSyZGWnT+17XLshMDIrfEqA1YYRM3vkP6ZHc
         XpSzS/oiOKXbE1t1D84NdJJ4r8XiuC9A+3mkTx9nMdA+iwGHT33xWMNJplQ1SUNu87pj
         i/JA==
X-Gm-Message-State: AOJu0YzVqT+TcRKKWWyWtMbzrxWDyHRuwm+cZJLm2TBUynwrfw7RQZam
	aIIH0Dtp9pPNuSWLVMKijz6PIyRFckbivhU9a0J46a63aWoqIJ3AEHpX+c5d
X-Google-Smtp-Source: AGHT+IGSS9A3d6drYAxxHf0ZGyG+FG7YGRxNkJoV3+V03l6fdjdPIa1XyZ0cHRcggDGFab+KpHiedw==
X-Received: by 2002:a05:6a20:bc85:b0:1a1:6ee4:1690 with SMTP id fx5-20020a056a20bc8500b001a16ee41690mr1472399pzb.15.1710072254964;
        Sun, 10 Mar 2024 05:04:14 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090274ca00b001dcc8c26393sm2548445plt.225.2024.03.10.05.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Mar 2024 05:04:14 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: mark SMB2_SESSION_EXPIRED to session when destroying previous session
Date: Sun, 10 Mar 2024 21:03:35 +0900
Message-Id: <20240310120336.14876-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently ksmbd exit connection as well destroying previous session.
When testing durable handle feaure, I found that
destroy_previous_session() should destroy only session, i.e. the
connection should be still alive. This patch mark SMB2_SESSION_EXPIRED
on the previous session to be destroyed later and not used anymore.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 27 ++++++++++++++++++++++++++-
 fs/smb/server/mgmt/user_session.h |  3 +++
 fs/smb/server/smb2pdu.c           | 24 ------------------------
 3 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 15f68ee05089..83074672fe81 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -156,7 +156,7 @@ void ksmbd_session_destroy(struct ksmbd_session *sess)
 	kfree(sess);
 }
 
-static struct ksmbd_session *__session_lookup(unsigned long long id)
+struct ksmbd_session *__session_lookup(unsigned long long id)
 {
 	struct ksmbd_session *sess;
 
@@ -305,6 +305,31 @@ struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 	return sess;
 }
 
+void destroy_previous_session(struct ksmbd_conn *conn,
+			      struct ksmbd_user *user, u64 id)
+{
+	struct ksmbd_session *prev_sess;
+	struct ksmbd_user *prev_user;
+
+	down_write(&sessions_table_lock);
+	down_write(&conn->session_lock);
+	prev_sess = __session_lookup(id);
+	if (!prev_sess || prev_sess->state == SMB2_SESSION_EXPIRED)
+		goto out;
+
+	prev_user = prev_sess->user;
+	if (!prev_user ||
+	    strcmp(user->name, prev_user->name) ||
+	    user->passkey_sz != prev_user->passkey_sz ||
+	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
+		goto out;
+
+	prev_sess->state = SMB2_SESSION_EXPIRED;
+out:
+	up_write(&conn->session_lock);
+	up_write(&sessions_table_lock);
+}
+
 static bool ksmbd_preauth_session_id_match(struct preauth_session *sess,
 					   unsigned long long id)
 {
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 63cb08fffde8..dc9fded2cd43 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -88,8 +88,11 @@ struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
 int ksmbd_session_register(struct ksmbd_conn *conn,
 			   struct ksmbd_session *sess);
 void ksmbd_sessions_deregister(struct ksmbd_conn *conn);
+struct ksmbd_session *__session_lookup(unsigned long long id);
 struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 					       unsigned long long id);
+void destroy_previous_session(struct ksmbd_conn *conn,
+			      struct ksmbd_user *user, u64 id);
 struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
 						    u64 sess_id);
 struct preauth_session *ksmbd_preauth_session_lookup(struct ksmbd_conn *conn,
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 199c31c275e5..201d78310bde 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -607,30 +607,6 @@ int smb2_check_user_session(struct ksmbd_work *work)
 	return -ENOENT;
 }
 
-static void destroy_previous_session(struct ksmbd_conn *conn,
-				     struct ksmbd_user *user, u64 id)
-{
-	struct ksmbd_session *prev_sess = ksmbd_session_lookup_slowpath(id);
-	struct ksmbd_user *prev_user;
-	struct channel *chann;
-	long index;
-
-	if (!prev_sess)
-		return;
-
-	prev_user = prev_sess->user;
-
-	if (!prev_user ||
-	    strcmp(user->name, prev_user->name) ||
-	    user->passkey_sz != prev_user->passkey_sz ||
-	    memcmp(user->passkey, prev_user->passkey, user->passkey_sz))
-		return;
-
-	prev_sess->state = SMB2_SESSION_EXPIRED;
-	xa_for_each(&prev_sess->ksmbd_chann_list, index, chann)
-		ksmbd_conn_set_exiting(chann->conn);
-}
-
 /**
  * smb2_get_name() - get filename string from on the wire smb format
  * @src:	source buffer
-- 
2.25.1

