Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5ACA2DCC05
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 15:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764863655; cv=none; b=oLeb5CV7E1VGN1tnm/R3cXeyIbdTr70YtlHKrKQ7V5PkrcpyhTjbpT5oxuPKjmBzRyWx6jh/gjNrBm58if89Yb8sURDfyg6JUf6yNSD0RUqxtkDfkOcbMli1P9NPCRB3OFKrOt7jWcmCGO25G5J/FhLxk1DFpY4f4hTsk9cgzh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764863655; c=relaxed/simple;
	bh=Ya40AQjTfcEQKO4mu/cLJffgP6jIokmMIVNoINe7u7A=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=atwvPz/rul3MAXGO3UI32hemQFfLbWFVEQAAYDLWJEUD095hp3R9kSnheLE3Ri7XsKeQ1vZCvTRwZJDzH+pNrjfYRlID/yDMgBxxUWvU6ONKB6S0KeeQfpkhFnMCAM8TvdpKmDMMtDoltWq+KrGzzQyPPcWg2xY05OHucAt014Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=es263pxC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="es263pxC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764863652;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/PXfCAogLoX2fF4ZN7adqUSt41Dc0XRpCjxePCSDDFs=;
	b=es263pxCqgKXsBkIPBmPs1ZdAN9qNUnQn6jGU6Yp8PwGopHB4PHjhYMlJQxl0YgMtcnolX
	GhHGfCEldPzZgxlzmFvjEfPC+AGbkiLivlZwq9/hSWqfc+yAbPftOxicwSAoIBTFVrXuMo
	grFQ+wbIGydfF8bSc5/yfOhAmUbFRio=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-678-9N6aZn-yOmmSjcBGr-_UxA-1; Thu,
 04 Dec 2025 10:54:11 -0500
X-MC-Unique: 9N6aZn-yOmmSjcBGr-_UxA-1
X-Mimecast-MFC-AGG-ID: 9N6aZn-yOmmSjcBGr-_UxA_1764863650
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF8F619560B3
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 15:54:10 +0000 (UTC)
Received: from plambri-thinkpadp16vgen1.rmtgb.csb (unknown [10.45.226.41])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C4CE919560BB
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 15:54:09 +0000 (UTC)
From: Pierguido Lambri <plambri@redhat.com>
To: Linux CIFS Mailing list <linux-cifs@vger.kernel.org>
Subject: [PATCH 1/1] cifs.upcall: add option to enable debug logs
Date: Thu,  4 Dec 2025 15:54:07 +0000
Message-ID: <20251204155407.625640-1-plambri@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

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
index 69e27a3..b32fcf1 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -25,6 +25,7 @@
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 */
 
+#include <sys/syslog.h>
 #ifdef HAVE_CONFIG_H
 #include "config.h"
 #endif /* HAVE_CONFIG_H */
@@ -1356,7 +1357,7 @@ lowercase_string(char *c)
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
+	fprintf(stderr, "Usage: %s [ -K /path/to/keytab] [-k /path/to/krb5.conf] [-d] [-E] [-t] [-v] [-l] [-e nsecs] key_serial\n", prog);
 }
 
 static const struct option long_options[] = {
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

