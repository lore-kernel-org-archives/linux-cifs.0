Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91F02EAB6D
	for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 12:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758802901; cv=none; b=K3ToUHI4eG228HzpRpzEqgMZunvQ2huUYGheCdhYw6jDr2zfgflPbFegp2i9V1hLqGbGhJ7safVCDSyUbeefxaSPYdA8gYUM/rHt8lRX/y5Gmwog5gjfFVVOAia3IhPr4ezVeAEXds6A9Oc2ePwx1loJYF7j0TP4jNE19GOQLBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758802901; c=relaxed/simple;
	bh=unZFRIOdJNgq7eCn+km2owu6h4KRROIdYovuydH911s=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZkA2K15zCiqvrixCGDltAPZ6zI5/0TS4GCk9fwymIaGXf+Ja3uGui62cCQidOkc8MhnaUGOIapUKQcErPQOUhGOxppRfFgvxusIP9ynqiCSe3+4+J9TPYO0hJplx6iCqGTlW0m0l9yenuUPLR0ghN8sABpWhUP1agh4rvyZ11BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-77dedf198d4so1220310b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 25 Sep 2025 05:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758802898; x=1759407698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XYP5Qcy3zkdHIJOISaUV+Ptv4fvXYb+sTJNRBTfftGk=;
        b=LZ4WB1lIRgGsgLf7/1Q11MypT9d35+XvuWl5Z72RwaRgA2zFO+ezCulxgij93Md1ph
         /3ZAInEhuJU5X1KfdwbxNNVuz1UOaWPUze5VmYT6xEDw1k9gqouS91wVwtzXXYY08qUJ
         /XUuU0W3bijW4VLHpxJnwo7TxNSJUeYk/4DC8dx49/IQu/QS89ULzVd7smuVBqI8L0Bm
         I19eOItP1nReBHmOBzijqGZGc78c9FsA0uuFunrkGvRaUnFrl+t0t6Me7zmP+iEw+9vr
         QU8+rMMEpnR3FQSklveF3ol3tMrtWtfz8Zsqqcuk41QqKvdU8CRgPoENQvEVT4Q6D85U
         WdRw==
X-Gm-Message-State: AOJu0YwDJoiRaCpJDg3W47KbD8LQC9KIWbPvfC0Dm79MMMrhgHg/BeIr
	jz7XzBkj3A+hNy6sX61UNBHfF8haiUnNWzKUEtM2ZE3e+ej4DdJ1F2hTKtsnIQ==
X-Gm-Gg: ASbGncuiIK/vNv7RiNnK/ko4eAky/2sNW9hpfesjNEOuujEVVDnpL585X1YCXqdzDu5
	+ufb3sV1w4xnvG5J3G+kPvaykLLk21GE2d4V9rQRFci5j/E99lAoBTPgY7GT9siMo/pNJwV5INF
	i+/NDv5DB7/oN28xA4zSKjM8wuuRrnwXwtMkMQ3rRPorsKVov0s3nROCA6ykoWWX9YriByMYPpu
	SZM+6fUHw9lStQXKPvmMnNoN7SELwbWIPnqi5nNbw8PeZF+NliYSNNupYB++pzmModcQkt3enKD
	bSoaNohk9VR0tm2BvebysM3sOPKQ3EmxIx359YCxlDTDODrUWslS6cWit7Y/ZnEfl3NrSDIE1gl
	wAtNeNXaFG12us0jAkC0Pyj0V64gFYqTES2JqPBwbLYCdK2Nn
X-Google-Smtp-Source: AGHT+IE6ULa7X7LgQBGwqoRa5uqwrCN27qTG71CifDF5vL9KYxkJSHt7HaTVm2y9Q90wKHZ+F9FCCQ==
X-Received: by 2002:a05:6a00:4c90:b0:781:661:14d0 with SMTP id d2e1a72fcca58-7810661190emr1732491b3a.9.1758802898219;
        Thu, 25 Sep 2025 05:21:38 -0700 (PDT)
Received: from localhost.localdomain ([1.227.206.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7810238d309sm1843628b3a.7.2025.09.25.05.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 05:21:37 -0700 (PDT)
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/3] ksmbd: make ksmbd thread names distinct by client IP
Date: Thu, 25 Sep 2025 21:21:16 +0900
Message-Id: <20250925122118.11082-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch makes ksmbd thread names distinct by client IP address.

100943 ?        S      0:00 [ksmbd:::ffff:10.177.110.57]
 or
101752 ?        S      0:00 [ksmbd:10.177.110.57]

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/transport_tcp.c | 32 ++++++++------------------------
 1 file changed, 8 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/transport_tcp.c b/fs/smb/server/transport_tcp.c
index 4dc0da3c091c..d5db1c5eb2dd 100644
--- a/fs/smb/server/transport_tcp.c
+++ b/fs/smb/server/transport_tcp.c
@@ -177,17 +177,6 @@ static struct kvec *get_conn_iovec(struct tcp_transport *t, unsigned int nr_segs
 	return new_iov;
 }
 
-static unsigned short ksmbd_tcp_get_port(const struct sockaddr *sa)
-{
-	switch (sa->sa_family) {
-	case AF_INET:
-		return ntohs(((struct sockaddr_in *)sa)->sin_port);
-	case AF_INET6:
-		return ntohs(((struct sockaddr_in6 *)sa)->sin6_port);
-	}
-	return 0;
-}
-
 /**
  * ksmbd_tcp_new_connection() - create a new tcp session on mount
  * @client_sk:	socket associated with new connection
@@ -199,7 +188,6 @@ static unsigned short ksmbd_tcp_get_port(const struct sockaddr *sa)
  */
 static int ksmbd_tcp_new_connection(struct socket *client_sk)
 {
-	struct sockaddr *csin;
 	int rc = 0;
 	struct tcp_transport *t;
 	struct task_struct *handler;
@@ -210,17 +198,14 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 		return -ENOMEM;
 	}
 
-	csin = KSMBD_TCP_PEER_SOCKADDR(KSMBD_TRANS(t)->conn);
-	if (kernel_getpeername(client_sk, csin) < 0) {
-		pr_err("client ip resolution failed\n");
-		rc = -EINVAL;
-		goto out_error;
-	}
-
-	handler = kthread_run(ksmbd_conn_handler_loop,
-			      KSMBD_TRANS(t)->conn,
-			      "ksmbd:%u",
-			      ksmbd_tcp_get_port(csin));
+	if (client_sk->sk->sk_family == AF_INET6)
+		handler = kthread_run(ksmbd_conn_handler_loop,
+				KSMBD_TRANS(t)->conn, "ksmbd:%pI6c",
+				&KSMBD_TRANS(t)->conn->inet6_addr);
+	else
+		handler = kthread_run(ksmbd_conn_handler_loop,
+				KSMBD_TRANS(t)->conn, "ksmbd:%pI4",
+				&KSMBD_TRANS(t)->conn->inet_addr);
 	if (IS_ERR(handler)) {
 		pr_err("cannot start conn thread\n");
 		rc = PTR_ERR(handler);
@@ -228,7 +213,6 @@ static int ksmbd_tcp_new_connection(struct socket *client_sk)
 	}
 	return rc;
 
-out_error:
 	free_transport(t);
 	return rc;
 }
-- 
2.25.1

