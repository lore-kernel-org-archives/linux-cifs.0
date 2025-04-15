Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54971FDA9B
	for <linux-cifs@vger.kernel.org>; Tue, 15 Apr 2025 16:21:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744734068; cv=none; b=jUbml70LaiJ6eNYn8vUbAc+EHcDrCL480gH3oEfvtTYiPrJdiKpRyEY63hs2zfu30A2c4jyEz7/8iCJb68wrQJqLXcEnLIDuddjDUZMTkMPC95XcjgCKq18wYO7hFtF2Fl8ORFGAMD0Ih+2HDuVHikxSNdr5otcEn9MKub2r9II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744734068; c=relaxed/simple;
	bh=V7PsYyT5M97mwARaj2ZGel2Z/WbdovNo8yDcItWcTq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VkQpdryXifdL0bHuDaBSrF70WBkuMASwMtegxFI2a7kdy9nrYyACCH29FY6ehhoZTGFEVB3S1780mo5pGFJoDR8ie4E7Lu/ov67I0+JK05/vsAE6t5BkUmMNoYe2Ai46riBCLUvK+RsJKSSJIWte3nZGmKUW2QaiPXzncr2otEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=EPCYOmyu; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="EPCYOmyu"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1744734057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tTN3v33Syh5IC+ND+YRvygjIi73JhTPgMVHdkLfVPsY=;
	b=EPCYOmyucaS5zMfknz5TTrWJfwt4TbnRRi48fSXU1qJLiN88b09NuU8rTcpgBCPOB4FLBE
	SHKzAemc9EUhSs0BapOx1cXVq32HglA8wHxq15nsHdY/zzraXpl5rlUvMqFcyXPS5hwr8l
	4ICA0CnNnU52TFLH3o1rWkgqYYNPkxUmaXwvEX4caSTRhwhpZAqaKGmU9v2ZWW+0S22rAK
	r+fXeWmfeoJgsF/XDjxsA8GnjOXrymYQiTxSDDeAHR6jtYT2rz1Uin/QWuvDFkeIPMIrU4
	PSmPwN08bXcTQC0iG4oGrN06KioEvvSyKAqKEVRNQpa5Sra2k/pUZwe1JqqKEA==
To: pshilovsky@samba.org,
	smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: [PATCH] cifs.upcall: fix memory leaks in check_service_ticket_exits()
Date: Tue, 15 Apr 2025 13:20:52 -0300
Message-ID: <20250415162052.361258-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error message returned by krb5_get_error_message() must be freed
using krb5_free_error_message().

Fixes: af76bf2a11a0 ("cifs-utils: Skip TGT check if valid service ticket is already available")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 cifs.upcall.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 678b1402d2ba..97ab4ec88fbc 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -634,33 +634,39 @@ icfk_cleanup:
 #define CIFS_SERVICE_NAME "cifs"
 
 static krb5_error_code check_service_ticket_exists(krb5_ccache ccache,
-		const char *hostname) {
-
-	krb5_error_code rc;
+                                                   const char *hostname)
+{
 	krb5_creds mcreds, out_creds;
+	const char *errmsg;
+	krb5_error_code rc;
 
 	memset(&mcreds, 0, sizeof(mcreds));
 
 	rc = krb5_cc_get_principal(context, ccache, &mcreds.client);
 	if (rc) {
+		errmsg = krb5_get_error_message(context, rc);
 		syslog(LOG_DEBUG, "%s: unable to get client principal from cache: %s",
-					__func__, krb5_get_error_message(context, rc));
+		       __func__, errmsg);
+		krb5_free_error_message(context, errmsg);
 		return rc;
 	}
 
 	rc = krb5_sname_to_principal(context, hostname, CIFS_SERVICE_NAME,
 			KRB5_NT_UNKNOWN, &mcreds.server);
 	if (rc) {
+		errmsg = krb5_get_error_message(context, rc);
 		syslog(LOG_DEBUG, "%s: unable to convert service name (%s) to principal: %s",
-					__func__, hostname, krb5_get_error_message(context, rc));
+		       __func__, hostname, errmsg);
+		krb5_free_error_message(context, errmsg);
 		krb5_free_principal(context, mcreds.client);
 		return rc;
 	}
 
 	rc = krb5_timeofday(context, &mcreds.times.endtime);
 	if (rc) {
-		syslog(LOG_DEBUG, "%s: unable to get time: %s",
-			__func__, krb5_get_error_message(context, rc));
+		errmsg = krb5_get_error_message(context, rc);
+		syslog(LOG_DEBUG, "%s: unable to get time: %s", __func__, errmsg);
+		krb5_free_error_message(context, errmsg);
 		goto out_free_principal;
 	}
 
-- 
2.49.0

