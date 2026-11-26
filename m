Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705721;
	b=c9mxIt8j7T/KoLDwbgN/4ivAiTfXnsxCa5BrR0jIBeUXKdsqvDfcyTAjkK0MVY1L2c5e
	 Y5ZHruiDu3jg8PTeF+vl+fPFGA/f7ZdSQ2F1rH+eBr+/JLnp2TlJpkl62BziV5HbtH6cz
	 pkMdU8V8K6hhk+Tdtkdiahpnz6ATwVJZlIauu4Ti5keNPuF17Fwr/7qmI3GJV835hn7bk
	 0XAb4UX8RRbKMFK3tMX84M75+fV94o9E4Tip5nIMId8ovdIpF/f82dFnGPeqePVfLQA8F
	 obdR44C+V4D/oUs3K6necYwT8PBA+XkGT9nMLeF8dC/I2QvpDbIzMX79B/gdIMRXC8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705721;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=baX0uOuAFizNTsTDSKWrZnJ1i/LidaT/qdEz9s6Znmg=;
	b=0RoA54UovgAdUgBy8owFciBjsBo6nn+O3eloLEWeA9X8YIdpnFZBJMpikOwFo+FeUX4g
	 Uahqwd2WVIVLKEo7Ytozk3Sr5Xcc4THQK2dY1fJjYf/jzL4uRDXDYu7SyUm+XRzF+rATQ
	 9//7XHKI+DhWHmAkyokAnn2LA/8zo9gh2fys1dd+2gjBZSrJZyv7QvmKBl/8q2C+9YyOx
	 RsjniQOzHQ2A7lHj8Dus8s1UHJp6U676pTt88iY1Vsc6IbFSBIpNU9GCN3ZFNJur1EwSj
	 2NO+Zi8/AVUfFHIxhxz0tpYolhq9O+Jzul841Gpewlu1G8BgD80j/JOl303xz0ctL/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=rootsys.at;
	spf=pass smtp.mailfrom=rootsys.at;
	dkim=pass header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b="i/M9s7P8";
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A97606A31C
	for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 15:08:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 99A97606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=rootsys.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rootsys.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rootsys.at header.i=@rootsys.at header.a=rsa-sha256 header.s=google header.b=i/M9s7P8
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so76136815e9.0
        for <linux-cifs@vger.kernel.org>; Thu, 26 Nov 2026 07:08:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rootsys.at; s=google; t=1795705719; x=1796310519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=baX0uOuAFizNTsTDSKWrZnJ1i/LidaT/qdEz9s6Znmg=;
        b=i/M9s7P8Dw3oCoeDyGFVI7/DtTCauUAG3VVmhaOf6epXgb12Q1N+SGeYjiZWOhI3tr
         hRGamnObdIJXXDZUbvP5bi/5HcjzK29wf9G+jeHZdb2Yd3BCKDWOhWPekdtz4U1a004q
         7Ph7caNFq02+fR2jsAtc6Qw2ldpkyDCetylrrUHvH/cEJGgY7/028YtTCQCu2R9pbKPC
         JZmQKPgFldNhifsBZyIJ3/RgzDbQRxmS3l88SuKb2+Fxf5TJsBXhO6ZPF4kljTzw1nJb
         FDOIiz6BLF8oxTZoXYBBk9GWveex1aFjwLsjrsKvwXr6e8WcR3fS7DHEbAwlDc4iiOC7
         y84w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795705719; x=1796310519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=baX0uOuAFizNTsTDSKWrZnJ1i/LidaT/qdEz9s6Znmg=;
        b=hxc4MPjIh+6o6rqR+gdNX+ZrNH/oONG/iD2Bbh9k0VeubwQhRJwpTQG8wdHXx1X2nZ
         m60GPJiac+LBYEPz9tOdVV2i26YKStmJgRBnRrMipCAU0pDtGh1eMJnPG8ION3N/OXsF
         VEg3lIf08QhjxzCiT9h6kd+dNS83Q1QaGz+BSQ02V4InqN/lGr+sx7jsnm0f4ahRcUk/
         n1KRzqd2RYewabzZa0ludnc4v0k3Hzoq1ggqqmhOHLCCLfDj9WH+BVhwscTMVfx2CPMt
         ymYzMuXk2boYiSxWIB9ZRZ4O0FX8Tppeuh/LKcs2JjrnGv6Fp9p4waVgAK8RtupWrp1R
         08nw==
X-Forwarded-Encrypted: i=1; AL+hErHVHdCXmyS0QDtt8fQSlp3M9gl/N92vkqwPsTrhsrSxk7Xh8KQIWak40WYxYDh3FwTgKyRvu3fW1WCb@vger.kernel.org
X-Gm-Message-State: APuU4Z9krlDG8LYliGZ0cJkHJvycnrWBBtevsqw9lr9/IufoZVeO+v9G
	M3LxShny4iH3EaRB9a4PYN4AHg4CWrRCKsCMFGxgwDjN8wwX2y6SIDIn/j7n/QTIjKOi
X-Gm-Gg: AZFdTZfmaVTyoEWihBJ0fEiNpyzSfx7eVCOlH06nR0wp55L2Is/gzdD7Q5aYttvJZdB
	sCONQWB+P7p638nzAcU03/shVJWI27toFL6BArSGctWOz4r2IUzr8lBMFJYycEqR1H9h7u7aIhQ
	7ITAw+Mp7duYjc66cAwoAFwd7T7V0YiHdqIKyVitw83UKZRY9eSuLUYGWzGVwdrAHbnSaXyHNNN
	MIZG9kQR2uDRokVObelNULl7udE54q8MVZb0+IrmJUO8dHqr3G7kTPPPJ1SO4MY6fBEB4y1QFYl
	nYeCsnwDo2xemZEGnohTt5flLsSAz0kPb0BIxgwrfHvSk5r1pM/PTUKiyh6YTtz+pjuIM+gjHz1
	4NKjcocKcG7pekuKnFZBIGuEwWbc6pPD6FwnjOFCJ7QlWPSL4Kh4/MCnOA6v18dluBU6AS2MfMP
	ESkJdover4V/PUUHwUpRu6IqW4R4SGXYk7k1+QoOXtwrca9y43C+WQN044be37ko51O+fNgwjbM
	arEQr9f8CrUIbWrw60S5BzLDYFayWoFBBkpX7e0Ujlzd8rm7oRaoVbW/t4syORQQZnsj1W8uI4D
	lKEcFRFTfc0eD9bPj/TgzyY/QeFUPM+cga+bYqSkhBBuMHUjymVT4xg1s+e5ul2xaQvXd9J6Cky
	QNQFCQt2WhBHDiQ==
X-Received: by 2002:a05:600c:64c8:b0:4bb:68e5:b952 with SMTP id 5b1f17b1804b1-4bb88819be1mr405854245e9.16.1795705719116;
        Thu, 26 Nov 2026 07:08:39 -0800 (PST)
Received: from rootsys.at (clnet-p094-053.ikbnet.co.at. [83.175.94.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm599850045e9.5.2026.11.26.07.08.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 26 Nov 2026 07:08:38 -0800 (PST)
From: RootSys GmbH Research <team@rootsys.at>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Ian Bridges <icb@fastmail.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	RootSys GmbH Research <research@rootsys.at>
Subject: [PATCH v2 1/4] ksmbd: keep negotiated capabilities per connection
Date: Thu, 26 Nov 2026 16:08:33 +0100
Message-ID: <0a11d02c7eb33fb38b2a0cf3cdd44e31dd08e3ba.1795701726.git.research@rootsys.at>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1795701726.git.research@rootsys.at>
References: <20261119103805.29514-1-research@rootsys.at> <cover.1795701726.git.research@rootsys.at>
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

From: RootSys GmbH Research <research@rootsys.at>

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

In the default "smb3 encryption = auto" mode, such a later SMB 3.0
client that offered no encryption gets sess->enc set and sess->sign
cleared in SESSION_SETUP, but is not told to encrypt. With mandatory
signing, its unsigned plaintext requests then pass __process_request(),
which only checks sess->sign. That is the gap "ksmbd: require signing
on sessions that negotiated encryption" closes for clients that do
offer a cipher; here it opens for a client that never did.

Give each connection its own copy of its dialect's table and set the
capability bits there.

Found with AI-assisted code review and testing.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Cc: stable@vger.kernel.org
Tested-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: RootSys GmbH Research <research@rootsys.at>
---
 fs/smb/server/connection.h |  2 ++
 fs/smb/server/smb2ops.c    | 19 +++++++++++++++----
 2 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 891612382d0f..adddcda735c6 100644
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

