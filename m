Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795084710;
	b=wbJYiC5y/c37T0wp6z5/q44ePLFd9AcX5UGpuV2BCwGvvCrkVy9vSzFQ7w56UKNbdxCi
	 6hrQ+9lpmr9cvGcyiWR5aD9G0LeLQC/cyJ+k2S9doztCA5IwuxypfFpk5uJkvAOfg/aAm
	 8iJX10u8BKgYQoriaHU/tioudcIoaCqozet4TptAVmStBnMgI6FKMU16sF8WOXzcDCMEk
	 ChR4QHKnHIHTi92YFa+iqR79rcCzzhKiCKZVok1CMUTPdt6SIrMKUCUrYZJ0o/nJ6j9+a
	 tl7pRdx5qSz3o52H6W29dO6S9gZDEv+AmwKgt7pByUVwVtfnh44uT1bzY1pdLXYOtmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795084710;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=41g2aFyZlZ8E3QQK9S4bIKisMsXwI8meCodqRFnJc38=;
	b=V+/61aVLnult6pxzdjaSzoPm5LU9w2bohfwBcQSiDRUrqF38TZKv8wfQtXLcbonVCUCX
	 g1p+pQ2V/pMiSUUrf+sej/G/AGblFwVaPYc3lbNbHe7zvfqHdUyyIpDbCKVNr4mX/vGMd
	 esDwTYX20jpi7L9Faq5aret1sMieBqa/i6rKmtauLynigFZpJZ4koaP5R/a5mTIDTihyM
	 s7oONLUQnBZQ8DVtszgSO75DqwNJoEEwhOMAYXgWYkQ0pLNtMlTIjFesLDn8agryjnXt0
	 kwJVTZ1CXaF3AMoTD5yj1yec6rEsHO7Rv3hBOLzCgckl/n4fDufGnheAhlK3Cag/i8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=qFsOPUJp;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C6A606A320
	for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 10:38:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9C6A606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=qFsOPUJp
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so9944605e9.1
        for <linux-cifs@vger.kernel.org>; Thu, 19 Nov 2026 02:38:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795084708; x=1795689508; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=41g2aFyZlZ8E3QQK9S4bIKisMsXwI8meCodqRFnJc38=;
        b=qFsOPUJpOchr3qUIsHDB8VWLp+dtU0Rz8RHK/PDUbRkONuYP8y1S3XGfOLoAgyw/dW
         K8gLZrWdK8fHoJH83VCOSz0UTe9ROBrhfuuut3MfyZLD0M2WdEjOJx5wzTMXJWmYSJiU
         zq5suAZCLEmD6k/fhos7MsYVvqXUmDdUnZKn2+dRpgGziJSR9eHZ8A/lOIUkk0YGR3DQ
         OtzxqXod4VYiq0VLTNyqMCpKC11d4P149zlDH9z0BNgpEGqh+TxyLt4X2YXyC+416HvD
         jwQSCZ0/+69/sl9pfqCYSYakLvju6miVzgIyJ814FBBBgVT/PttrH7A5/wPJ12VR1ld7
         LtFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795084708; x=1795689508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=41g2aFyZlZ8E3QQK9S4bIKisMsXwI8meCodqRFnJc38=;
        b=J+pKdHJvjCYoQChqFrYf4xc99CmnjJRv5RabSVwCvW19qJii1tkIPKyTB3tr3lEaCI
         I4i07HGERKc8+GAOha4OYr0M9fd778Q87LeXvH8hQfHvzMGecRj1KWiOmmLv01N3SwFS
         CZDWz68ZHHTdZSfd9/X4n6IPx2G9S6tT2KuFc5HfcQqtzJMudZB8P0S655HfjqsGI9bf
         vIt4R4d9PYvg5rYgboIKYsECTk3WbMYmzOZmiAPNzzIA9ceEsUdf8kLfdTqnLiui78gm
         HnhP4dydGcvw/C/n4G/kjq2LjAizr360mC7Nx9+hWe95+DSUMQYJfnNDo/CLVtg1G1pu
         jfYw==
X-Forwarded-Encrypted: i=1; AL+hErFCiR7m1kGi/IMqo9xrkzbH8NEoKcqxJsfU92b8N7wEtjDQAdFiIRmTrMCT+HXSMNkvmDroLx8tVTB0@vger.kernel.org
X-Gm-Message-State: APuU4Z/CnA8LSgu0wd45IUg/O17StklKPWtYy3jYjdODiruP98KB6+7h
	Sa1RJzIrhxJ3mFSUi7sOSQWDGyI0KARY3HLwe7aFlErDGjovSEUE40qT4kx2RxVmSF0W
X-Gm-Gg: AYBFou2Rzp5X/InOW4iySzi/MiTED738im42Yh9VrDigu8ueOpOKwvvvXcAUUtb5QYC
	7c44Rd2sOOJa3uSeZXKGYk8HgiXZKiyjKMzVK8QHYyv+2cDd5nb7D5B/LoMv2d+LZP7kVgp//rR
	potdybXb6AJaSEgVhbj9xLRTiUpAzmsz0JUxnIf3/UtK/w2nV72s+/erW5YIrozXOEb0677Z/BF
	IbwJf4OG+J/fQhqHm7FLqYrbayZPc5kyk4oejmO4IwjxLyCUltaURbJRDZez0dfRAKo5Bi6P/pO
	PVsEm3g1wwhWT3MaIWtq6pIr+Qys+RpOAyWaH9ibl8T5Tmz9LT1btVS4QEioQ94bY5cpCXUCMab
	w5O44ZFueT/InEhXbADr8vSSHzsn6elw21ysXo+OcyP+tKMWZFxhbu2hs5EbVV4ZWPUA1QHILKo
	3qaynCW9+agpsHyDOBw8UkmyahTKboQ+vvOyGpeEv1qJQ3oksoLEP8GYCelQfIpXy8MywB+gXSG
	7Ntz/Cf1K0Tk7qfDrwdfZXeJ25I7nW/zJtJxBoxdP/OGwiZOt0thWdU2BY6Q29BaN8Uiz+xwjJ4
	qA3/yBRw5GqsC6pgWdfuIzCMSm13qqNq2AoPS0maWUoulA3ufuiN7Es+BCOvZDgsOeAG
X-Received: by 2002:a05:600c:4e94:b0:4a1:d766:758 with SMTP id 5b1f17b1804b1-4bb86161de1mr16832315e9.16.1795084708260;
        Thu, 19 Nov 2026 02:38:28 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a655f9f4a7sm10030927f8f.34.2026.11.19.02.38.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 19 Nov 2026 02:38:28 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
X-Google-Original-From: RootSys GmbH Research <research@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	mike.michalo@gmail.com,
	linux-cifs@vger.kernel.org
Subject: [PATCH 4/4] ksmbd: keep negotiated capabilities per connection
Date: Thu, 19 Nov 2026 11:38:05 +0100
Message-ID: <20261119103805.29514-5-research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119103805.29514-1-research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at>
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

init_smb2_1_server(), init_smb3_0_server(), init_smb3_02_server() and
init_smb3_11_server() point conn->vals at the static
smb21/smb30/smb302/smb311_server_values tables and then OR capability
bits into conn->vals->req_capabilities. Those bits therefore land in
the table shared by every connection of that dialect and are never
cleared, not even by restarting the server or changing its
configuration; later NEGOTIATE responses advertise them.

For SMB 3.0 and 3.0.2 this changes security decisions:
smb3_encryption_negotiated() tests req_capabilities, so once a single
client has offered SMB2_GLOBAL_CAP_ENCRYPTION, every later session of
that dialect is treated as having negotiated encryption, including
sessions of clients that never offered it. An attacker can trigger this
with one NEGOTIATE.

Give each connection its own copy of its dialect's table and set the
capability bits there.

Found with AI-assisted code review and testing.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Signed-off-by: RootSys GmbH Research <research@rootsys.at>
---
 fs/smb/server/connection.h |  2 ++
 fs/smb/server/smb2ops.c    | 19 +++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 6855c1ab691e..127b5c2d0d9e 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -55,6 +55,8 @@ struct ksmbd_transport;
 
 struct ksmbd_conn {
 	struct smb_version_values	*vals;
+	/* this connection's copy of its dialect's values, see smb2ops.c */
+	struct smb_version_values	vals_copy;
 	struct smb_version_ops		*ops;
 	struct smb_version_cmds		*cmds;
 	unsigned int			max_cmds;
diff --git a/fs/smb/server/smb2ops.c b/fs/smb/server/smb2ops.c
index c5b3cf34494e..4a69c8832820 100644
--- a/fs/smb/server/smb2ops.c
+++ b/fs/smb/server/smb2ops.c
@@ -231,6 +231,17 @@ static struct smb_version_cmds smb2_0_server_cmds[NUMBER_OF_SMB2_COMMANDS] = {
 	[SMB2_CHANGE_NOTIFY_HE]	=	{ .proc = smb2_notify},
 };
 
+/*
+ * The capability bits depend on the client and the configuration, so set
+ * them on a copy owned by the connection instead of on the shared table.
+ */
+static void ksmbd_conn_init_vals(struct ksmbd_conn *conn,
+				 const struct smb_version_values *vals)
+{
+	conn->vals_copy = *vals;
+	conn->vals = &conn->vals_copy;
+}
+
 /**
  * init_smb2_1_server() - initialize a smb server connection with smb2.1
  *			command dispatcher
@@ -238,7 +249,7 @@ static struct smb_version_cmds smb2_0_server_cmds[NUMBER_OF_SMB2_COMMANDS] = {
  */
 void init_smb2_1_server(struct ksmbd_conn *conn)
 {
-	conn->vals = &smb21_server_values;
+	ksmbd_conn_init_vals(conn, &smb21_server_values);
 	conn->ops = &smb2_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
@@ -255,7 +266,7 @@ void init_smb2_1_server(struct ksmbd_conn *conn)
  */
 void init_smb3_0_server(struct ksmbd_conn *conn)
 {
-	conn->vals = &smb30_server_values;
+	ksmbd_conn_init_vals(conn, &smb30_server_values);
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
@@ -285,7 +296,7 @@ void init_smb3_0_server(struct ksmbd_conn *conn)
  */
 void init_smb3_02_server(struct ksmbd_conn *conn)
 {
-	conn->vals = &smb302_server_values;
+	ksmbd_conn_init_vals(conn, &smb302_server_values);
 	conn->ops = &smb3_0_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
@@ -316,7 +327,7 @@ void init_smb3_02_server(struct ksmbd_conn *conn)
  */
 int init_smb3_11_server(struct ksmbd_conn *conn)
 {
-	conn->vals = &smb311_server_values;
+	ksmbd_conn_init_vals(conn, &smb311_server_values);
 	conn->ops = &smb3_11_server_ops;
 	conn->cmds = smb2_0_server_cmds;
 	conn->max_cmds = ARRAY_SIZE(smb2_0_server_cmds);
-- 
2.43.0

