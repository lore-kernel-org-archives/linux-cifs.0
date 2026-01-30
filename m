Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFE231A56D
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769782334; cv=none; b=L0GV13M9B7ZZya8TNrVM+YwLSytdQLX9+u6mbWNT0YHSm/5wt+RU5WwgJzrQ2hmj3oYTi6/lRcILKzAvV9Vk8fIOspPtYN8AG9sLWscTG9Ky+AiBiXhzaWR/4T7ITUy16+x9bLVwUzIRcnKESafumqAekn8PGjx2DSXNGZ10msg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769782334; c=relaxed/simple;
	bh=8Lpk+eREpWdl7Tx3Nowh6lgAjuaxEon3TEWkhcKVXhc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Smlc2faVJFog+gRzJfZfNMhsokeIbrl302wWt5Qe4Afywi/Io8oMW7b+bsTlwaCkLU4s+oPjsn9aJIPRlT24eRrenO4RHfYGe7NPrInyAHSSVV429E3/CFAgxWOKf7Lx6VN19H8OuWu2ImzU/ECjtJOF6+c9MeIvRIzXBlpvH3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gf2DctLG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gf2DctLG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769782331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=e0in+KBbGqz6AXj87Nj3OUGdrgvC65eg8pZl8E7DFFE=;
	b=gf2DctLGm+eK7OmIolsl+MlYtg9pvX56pPgYD+CCaw4t4oXtNln5zC/4bKc5kFxs8D4+Rs
	ls6TZfs9BaRlIAjy27LYzKY+9gbBujwxWVLOfhxy3vw/1jNIFj/KF7kIfAtCmWlh8wGaiB
	LEbh3UbXLJyS4hYm4+bqEF+WRjfaV0Y=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-QAqd4hnWPgKk-W5ZYlpIgA-1; Fri,
 30 Jan 2026 09:12:10 -0500
X-MC-Unique: QAqd4hnWPgKk-W5ZYlpIgA-1
X-Mimecast-MFC-AGG-ID: QAqd4hnWPgKk-W5ZYlpIgA_1769782329
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 991D818005A7
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 14:12:09 +0000 (UTC)
Received: from plambri-thinkpadp16vgen1.rmtgb.csb (unknown [10.44.32.231])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D23C418004D8
	for <linux-cifs@vger.kernel.org>; Fri, 30 Jan 2026 14:12:08 +0000 (UTC)
From: Pierguido Lambri <plambri@redhat.com>
To: Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Subject: [PATCH v3 1/3] cifs.upcall: add option to enable debug logs
Date: Fri, 30 Jan 2026 14:11:26 +0000
Message-ID: <20260130141207.831439-1-plambri@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

cifs.upcall uses two levels of logs, DEBUG and ERR.
However, when using systemd, these logs will always be recorded.
When the system does a lot of upcalls, the journal could be filled
with debug logs, which may not be useful at that time.
Added then a new option '-d' to enable debug logs only when needed.
This will set a logmask up to LOG_DEBUG instead of the default
of LOG_ERR, thus reducing the amount of logs when no debug is needed.

Signed-off-by: Pierguido Lambri <plambri@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
---
 cifs.upcall.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 69e27a3..b57a48c 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1356,10 +1356,11 @@ lowercase_string(char *c)
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
+	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-d] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
 }
 
 static const struct option long_options[] = {
+	{"debug", 0, NULL, 'd'},
 	{"no-env-probe", 0, NULL, 'E'},
 	{"krb5conf", 1, NULL, 'k'},
 	{"legacy-uid", 0, NULL, 'l'},
@@ -1379,6 +1380,7 @@ int main(const int argc, char *const argv[])
 	size_t datalen;
 	long rc = 1;
 	int c;
+	int mask;
 	bool try_dns = false, legacy_uid = false , env_probe = true;
 	char *buf;
 	char hostbuf[NI_MAXHOST], *host;
@@ -1395,12 +1397,19 @@ int main(const int argc, char *const argv[])
 	hostbuf[0] = '\0';
 
 	openlog(prog, 0, LOG_DAEMON);
+	mask = LOG_UPTO(LOG_ERR);
+	setlogmask(mask);
 
-	while ((c = getopt_long(argc, argv, "cEk:K:ltve:", long_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cdEk:K:ltve:", long_options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			/* legacy option -- skip it */
 			break;
+		case 'd':
+			/* enable debug logs */
+			mask = LOG_UPTO(LOG_DEBUG);
+			setlogmask(mask);
+			break;
 		case 'E':
 			/* skip probing initiating process env */
 			env_probe = false;
-- 
2.52.0

