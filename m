Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C450209671
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 20:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736886919; cv=none; b=cx3TUO1zCAjXUDPukQL64wlOSyyE8CVjIZY9qfUPWxX4rq5a9vM/6NFg1buad06np0BuOpUhgoJ6soes8tUmYhzxoWIATMtRqPofxSa6Wq9lbrXngcTGOy0nptwU679MjpB1I09ttt1NbhehbmkN2S50JVw4yitM4RgdgZV31/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736886919; c=relaxed/simple;
	bh=wROWfO9oh23/I9jEdO2G9BzHmRLhLlA8ViAZj0NT4bU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UdBLHOTOUCyTG3A1XfbBgzSU7hvp5yy1TFo2HQdSquxGRXcIk1HXN6lnKUU8UI9UycIjoNvoeHKH9UuTxNXMN1bIoPAiB1GPcIsbXoR2jOyBPYVAulGiVK7CA9rgayy4A3jNyo0fO8YEilbijHP+KsjGe29e6JesofUHvUpsHZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=So1Jiiao; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="So1Jiiao"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736886916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F70QoP72JsPwe4GpISM0tcBcDrr26ozERdR7Zp0T5Ok=;
	b=So1Jiiao8KhO6BZA+dgEI8mgU/Pbt8cixpdvxh05NNZ8gNz5qPvMkVlrNb1BsDMG6dJGaP
	FUNZ9CaJU0oswBfhnMq6S+fY8ipIo9ZYf87akaNJKllP5qwiwXsg/UDcDirwOA/LxE1Xzf
	3Mn5cbo8SdJyOkF1vgV4Q1CgPjtXgno=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-N_xddMqePWyqoXl1tt_D-w-1; Tue,
 14 Jan 2025 15:35:14 -0500
X-MC-Unique: N_xddMqePWyqoXl1tt_D-w-1
X-Mimecast-MFC-AGG-ID: N_xddMqePWyqoXl1tt_D-w
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE4C219560B8
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jan 2025 20:35:13 +0000 (UTC)
Received: from tbecker-thinkpadp16vgen1.rmtbr.csb (unknown [10.96.134.107])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D4D6195608E;
	Tue, 14 Jan 2025 20:35:12 +0000 (UTC)
From: tbecker@redhat.com
To: linux-cifs@vger.kernel.org
Cc: Thiago Becker <tbecker@redhat.com>
Subject: [PATCH 2/2] cifscreds: allow user to set the key's timeout
Date: Tue, 14 Jan 2025 17:35:09 -0300
Message-ID: <20250114203509.172766-1-tbecker@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

From: Thiago Becker <tbecker@redhat.com>

Allow the user to set the key's timeout when adding a new credential.

Signed-off-by: Thiago Becker <tbecker@redhat.com>
---
 cifscreds.c     | 17 +++++++++++------
 cifskey.c       | 12 ++++++++++--
 cifskey.h       |  7 ++++++-
 pam_cifscreds.c |  4 ++--
 4 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index c52f495..f552bc8 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -43,6 +43,7 @@ struct cmdarg {
 	char		*host;
 	char		*user;
 	char		keytype;
+	unsigned int	timeout;
 };
 
 struct command {
@@ -59,7 +60,7 @@ static int cifscreds_update(struct cmdarg *arg);
 static const char *thisprogram;
 
 static struct command commands[] = {
-	{ cifscreds_add,	"add",		"[-u username] [-d] <host|domain>" },
+	{ cifscreds_add,	"add",		"[-u username] [-d] <host|domain> [-t timeout]" },
 	{ cifscreds_clear,	"clear",	"[-u username] [-d] <host|domain>" },
 	{ cifscreds_clearall,	"clearall",	"" },
 	{ cifscreds_update,	"update",	"[-u username] [-d] <host|domain>" },
@@ -69,6 +70,7 @@ static struct command commands[] = {
 static struct option longopts[] = {
 	{"username", 1, NULL, 'u'},
 	{"domain", 0, NULL, 'd' },
+	{"timeout", 0, NULL, 't' },
 	{NULL, 0, NULL, 0}
 };
 
@@ -218,7 +220,7 @@ static int cifscreds_add(struct cmdarg *arg)
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_add(currentaddress, arg->user, pass, arg->keytype);
+		key_serial_t key = key_add(currentaddress, arg->user, pass, arg->keytype, arg->timeout);
 		if (key <= 0) {
 			fprintf(stderr, "error: Add credential key for %s: %s\n",
 				currentaddress, strerror(errno));
@@ -253,7 +255,7 @@ static int cifscreds_clear(struct cmdarg *arg)
 	char *currentaddress, *nextaddress;
 	int ret = 0, count = 0, errors = 0;
 
-	if (arg->host == NULL || arg->user == NULL)
+	if (arg->host == NULL || arg->user == NULL || arg->timeout)
 		return usage();
 
 	if (arg->keytype == 'd')
@@ -362,7 +364,7 @@ static int cifscreds_update(struct cmdarg *arg)
 	char *addrs[16];
 	int ret = 0, id, count = 0;
 
-	if (arg->host == NULL || arg->user == NULL)
+	if (arg->host == NULL || arg->user == NULL || arg->timeout)
 		return usage();
 
 	if (arg->keytype == 'd')
@@ -419,7 +421,7 @@ static int cifscreds_update(struct cmdarg *arg)
 	pass = getpass("Password: ");
 
 	for (id = 0; id < count; id++) {
-		key_serial_t key = key_add(addrs[id], arg->user, pass, arg->keytype);
+		key_serial_t key = key_add(addrs[id], arg->user, pass, arg->keytype, 0);
 		if (key <= 0)
 			fprintf(stderr, "error: Update credential key "
 				"for %s: %s\n", addrs[id], strerror(errno));
@@ -474,7 +476,7 @@ int main(int argc, char **argv)
 	if (argc == 1)
 		return usage();
 
-	while((n = getopt_long(argc, argv, "du:", longopts, NULL)) != -1) {
+	while((n = getopt_long(argc, argv, "dut:", longopts, NULL)) != -1) {
 		switch (n) {
 		case 'd':
 			arg.keytype = (char) n;
@@ -482,6 +484,9 @@ int main(int argc, char **argv)
 		case 'u':
 			arg.user = optarg;
 			break;
+		case 't':
+			arg.timeout = atoi(optarg);
+			break;
 		default:
 			return usage();
 		}
diff --git a/cifskey.c b/cifskey.c
index 919540f..4fef02f 100644
--- a/cifskey.c
+++ b/cifskey.c
@@ -40,11 +40,12 @@ key_search(const char *addr, char keytype)
 
 /* add or update a specific key to keyring */
 key_serial_t
-key_add(const char *addr, const char *user, const char *pass, char keytype)
+key_add(const char *addr, const char *user, const char *pass, char keytype, unsigned timeout)
 {
 	int len;
 	char desc[INET6_ADDRSTRLEN + sizeof(KEY_PREFIX) + 4];
 	char val[MOUNT_PASSWD_SIZE +  MAX_USERNAME_SIZE + 2];
+	key_serial_t key;
 
 	/* set key description */
 	if (snprintf(desc, sizeof(desc), "%s:%c:%s", KEY_PREFIX, keytype, addr) >= (int)sizeof(desc)) {
@@ -59,5 +60,12 @@ key_add(const char *addr, const char *user, const char *pass, char keytype)
 		return -1;
 	}
 
-	return add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING);
+	if ((key = add_key(CIFS_KEY_TYPE, desc, val, len + 1, DEST_KEYRING)) < 0) {
+		return -1;
+	}
+
+	if (timeout > 0)
+		keyctl_set_timeout(key, timeout);
+
+	return key;
 }
diff --git a/cifskey.h b/cifskey.h
index ed0c469..0069445 100644
--- a/cifskey.h
+++ b/cifskey.h
@@ -41,7 +41,12 @@
 #define CIFS_KEY_PERMS (KEY_POS_VIEW|KEY_POS_WRITE|KEY_POS_SEARCH| \
 			KEY_USR_VIEW|KEY_USR_WRITE|KEY_USR_SEARCH)
 
+/**
+ * Default key timeout is 24 hours
+ */
+#define DEFAULT_KEY_TIMEOUT (24 * 60 * 60)
+
 key_serial_t key_search(const char *addr, char keytype);
-key_serial_t key_add(const char *addr, const char *user, const char *pass, char keytype);
+key_serial_t key_add(const char *addr, const char *user, const char *pass, char keytype, unsigned timeout);
 
 #endif /* _CIFSKEY_H */
diff --git a/pam_cifscreds.c b/pam_cifscreds.c
index eb9851d..2b8c0b6 100644
--- a/pam_cifscreds.c
+++ b/pam_cifscreds.c
@@ -232,7 +232,7 @@ static int cifscreds_pam_add(pam_handle_t *ph, const char *user, const char *pas
 		*nextaddress++ = '\0';
 
 	while (currentaddress) {
-		key_serial_t key = key_add(currentaddress, user, password, keytype);
+		key_serial_t key = key_add(currentaddress, user, password, keytype, DEFAULT_KEY_TIMEOUT);
 		if (key <= 0) {
 			pam_syslog(ph, LOG_ERR, "error: Add credential key for %s: %s",
 				currentaddress, strerror(errno));
@@ -335,7 +335,7 @@ static int cifscreds_pam_update(pam_handle_t *ph, const char *user, const char *
 	}
 
 	for (id = 0; id < count; id++) {
-		key_serial_t key = key_add(currentaddress, user, password, keytype);
+		key_serial_t key = key_add(currentaddress, user, password, keytype, DEFAULT_KEY_TIMEOUT);
 		if (key <= 0) {
 			pam_syslog(ph, LOG_ERR, "error: Update credential key for %s: %s",
 				   (currentaddress ?: "(null)"), strerror(errno));
-- 
2.47.1

