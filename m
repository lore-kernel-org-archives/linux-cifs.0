Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB5E1C7012
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769695795; cv=none; b=GD17YSb0WG7hXj3dItRJh4Dc5QiBLokq6ukRlnT2x7IKgciziQTe5yUVAMoCjSfuvl1XYC1dVjGJlDmKJQb936IDbAPpvxnTUEqByCcOaSMvTZYXOQ1HJ5Q4ma4AXAatN7TRWtGL/wDh1L1voPSP0UX+5kcaAQnMp/AVoWvDgEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769695795; c=relaxed/simple;
	bh=yMul5kaba3qRooq0Iu4QbzAKXEziMxV+yffZVFaGMvQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=ZvsYa9Gdkt3A2nURL4Wk1Oqj0qpj24XKscttSqfbb8JV5vOUVrNcmuZpMdLO6fq9dn5iY0rFBmnuD4v3SVMP6rh7BmqrXWejFOBZwswZOQaNJ9GZbgHlatlVmvF7iqXpeiYDzZ24XXzPxS1bftHPhuQeomje246hTBVVyjd7DFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L0YWheld; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L0YWheld"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769695792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PjQoq3s7k6bvVyVR7wGbjP5CyAZzQd/JWNa2IBot6I4=;
	b=L0YWheldI2ZD1JNYyQIrH3GsLY01sSB8n4vFAWpP7/SPOfr27xUbHx/rBM6JoDrma9+FcF
	HKZmy9hgSAyET7RRXiMDOS5hmpXYvvq0MpsNsnbGTXJ+wAq0Xe+yJOZOLmXJvV+XOJE9U0
	lW0Qb3+FdCgkNIVB58Bmgv8QkNdHtBs=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-139-NSQEKvAUPCyR31Ka8wZWAQ-1; Thu,
 29 Jan 2026 09:09:51 -0500
X-MC-Unique: NSQEKvAUPCyR31Ka8wZWAQ-1
X-Mimecast-MFC-AGG-ID: NSQEKvAUPCyR31Ka8wZWAQ_1769695790
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CA5F195609D
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:50 +0000 (UTC)
Received: from plambri-thinkpadp16vgen1.rmtgb.csb (unknown [10.44.33.159])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B2822180086E
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 14:09:49 +0000 (UTC)
From: Pierguido Lambri <plambri@redhat.com>
To: Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Subject: [PATCH v2 1/3] cifs.upcall: add option to enable debug logs
Date: Thu, 29 Jan 2026 14:08:46 +0000
Message-ID: <20260129140948.621754-1-plambri@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

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
 cifs.upcall.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 69e27a3..9c2843d 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -1356,7 +1356,7 @@ lowercase_string(char *c)
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
+	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-d] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
 }
 
 static const struct option long_options[] = {
@@ -1379,6 +1379,7 @@ int main(const int argc, char *const argv[])
 	size_t datalen;
 	long rc = 1;
 	int c;
+	int mask;
 	bool try_dns = false, legacy_uid = false , env_probe = true;
 	char *buf;
 	char hostbuf[NI_MAXHOST], *host;
@@ -1395,12 +1396,19 @@ int main(const int argc, char *const argv[])
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

