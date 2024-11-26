Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5FF1DA2E5
	for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 17:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732642092; cv=none; b=m+7NYP0l4cF5j8L4yg5gS+vSBhw4IaoXD5Sm9VpJKxZvRD3LDU/fD297G9raVQOBKEsLD5xcuH+457w1EqawVh3FXkYsEOFKR88V99wXMVhqlNGHY73m+SZWUO+2WybdIOptENOeiPrKxTTi+lHF2ETsEZKbVHBww4vJn+a8a40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732642092; c=relaxed/simple;
	bh=sVyt3v3sV4c3F6DZUhk8AdIdxA73NaMUSu0/Xdbcd9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GM4v5fw7avnChmHy0gFXSZoUaVN8RuLercFJC8gLOjF041a9jJLpexXOGcgVAslXA/Dy0kIh0I7NcdlQIVw9BqnrPxZxysIE+E3u1Gub36uE8vS5ePCnjFWOty4BjH7Ga4OAkHw7UmA4V5BbSOP+C5owqYWFnuq3Cq0KD4TYhe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i2OrGif8; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i2OrGif8"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2e9ff7a778cso5272961a91.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 09:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732642090; x=1733246890; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=GkzluFdR/XThbmvf9PPNjQ9IlLi9FaTm3zamxDNL6/k=;
        b=i2OrGif8XioSZhE9BrOUPixAC5kozYo1Onhgl98wjKH1f/x8pBwLOnj0CKaLaDMgxm
         iuR2reI2pkSrhbWQxE0hvuT9c/dFuL96wrkyOOADNl9CJQRfd7Lk5M6WlRbtHhxZepGi
         2DJ+NSy8IHIIbgIfsN2lRtbSA95t44kpiBD5YNgUI7Z+4JOpgi2CgMXF0mQQg3h/bnj6
         AzKlcpjQyRq+bVZEkK1p2JUWeh+oYEAa0S+YScqN0iX/z9jkLR5Wrt3hWSpBog+Wcdjx
         5x8T85Ct5SsgciuTvMdnlC+67Rjq80HwWCogFEZQwH48VYoo+UnuJrgBcQhpAv8+HesN
         f5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732642090; x=1733246890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GkzluFdR/XThbmvf9PPNjQ9IlLi9FaTm3zamxDNL6/k=;
        b=JROjcvjSGjn1Munpxw8YuK3hWzpI/yPe8b20G2CwP8xRI5jDcbPDEtsfGvEFC6QViO
         VfLoSG0Od54tbFZwUeZvIPJJvhVmOn4Oe3NgYq27ZjaevPVL4jtMF90DTIqUDz3y3pZt
         A+0A+eCpMA8xd+1ujfyW0e2MUqzfBwINQQUxcCdeYI4GwZiWZpMpMD72V61ZJCr40iZD
         dqkuN+F6V83tB/+QR371LdXIG9k6/sBMoKJpjFJqOKr4lZJSG+Q0SglrE/mHUe46qPi7
         pr0Re9S23XPMLOP7cQLq8wvaE6pRGpa0EA0YqHiD5pIS2G8FH+pPX/nw1GAKLSrNNAS3
         DdLw==
X-Gm-Message-State: AOJu0Yxdhnw9nvNnS1vwf0Z/oEmLARWuxjUVSYfOKRkkCmnS9ALOemlj
	N2lgpBED6XXy4lMETxJ3WSlge4JgF681OoPzE8CEBfr4igV9RYVCA5Sb9WYm
X-Gm-Gg: ASbGncu4aIS1ZAOD0GD0BpjU/ifZEwYU/+PEFCoaUNw8gOW7smtISAQ0QyRGxqlPTv2
	j7sydggTHeT8OFohUbpgpjVAmTP+IAdgN4WNgBeesQ7wSancpw9QxGn5x5obmp36Y6/pW1QCHHs
	L4Cw9kqSQRUOxzW2gqxznSXSTZoimv2ZV8DFMdVhlicu9drii90r9oqYL9pfdeaywbN7tXyEDDn
	oEuVu6XY0ggjq673C9ygzaIgI9VXYeuejFWhREmXQlNMVNe7Egyf2voQOdjXDZUiEy5nYITwSg=
X-Google-Smtp-Source: AGHT+IGI+GTMG0l96IFAHzqvKldZ30tY8sRT81Q+nt5nCKFOZi8COQU97yZbzg02ugRlExGu0V+eBA==
X-Received: by 2002:a17:90a:fb90:b0:2ea:7ba7:33b9 with SMTP id 98e67ed59e1d1-2edebf22a2dmr6493895a91.14.1732642090440;
        Tue, 26 Nov 2024 09:28:10 -0800 (PST)
Received: from bharathsm-Virtual-Machine.. ([131.107.8.125])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2eb0cfe7ac5sm9112404a91.4.2024.11.26.09.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2024 09:28:10 -0800 (PST)
From: bharathsm.hsk@gmail.com
To: linux-cifs@vger.kernel.org,
	sfrench@samba.org,
	metze@samba.org,
	jlayton@samba.org,
	pshilovsky@samba.org,
	pc@manguebit.com,
	dhowells@redhat.com,
	sprasad@microsoft.com,
	rbudhiraja@microsoft.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] cifs-utils: Skip TGT check if valid service ticket is already available
Date: Tue, 26 Nov 2024 22:57:44 +0530
Message-ID: <20241126172744.25894-1-bharathsm.hsk@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bharath SM <bharathsm@microsoft.com>

When handling upcalls from the kernel for SMB session setup requests using
Kerberos authentication, if the credential cache already contains a valid
service ticket, it can be used directly without checking for the TGT again.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 cifs.upcall.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 58 insertions(+), 6 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index ff6f2bd..4ad0c8e 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -552,11 +552,6 @@ get_existing_cc(const char *env_cachename)
 		syslog(LOG_DEBUG, "%s: default ccache is %s\n", __func__, cachename);
 		krb5_free_string(context, cachename);
 	}
-
-	if (!get_tgt_time(cc)) {
-		krb5_cc_close(context, cc);
-		cc = NULL;
-	}
 	return cc;
 }
 
@@ -638,6 +633,49 @@ icfk_cleanup:
 
 #define CIFS_SERVICE_NAME "cifs"
 
+static krb5_error_code check_service_ticket_exists(krb5_ccache ccache,
+		const char *hostname) {
+
+	krb5_error_code rc;
+	krb5_creds mcreds, out_creds;
+
+	memset(&mcreds, 0, sizeof(mcreds));
+
+	rc = krb5_cc_get_principal(context, ccache, &mcreds.client);
+	if (rc) {
+		syslog(LOG_DEBUG, "%s: unable to get client principal from cache: %s",
+					__func__, krb5_get_error_message(context, rc));
+		return rc;
+	}
+
+	rc = krb5_sname_to_principal(context, hostname, CIFS_SERVICE_NAME,
+			KRB5_NT_UNKNOWN, &mcreds.server);
+	if (rc) {
+		syslog(LOG_DEBUG, "%s: unable to convert service name (%s) to principal: %s",
+					__func__, hostname, krb5_get_error_message(context, rc));
+		krb5_free_principal(context, mcreds.client);
+		return rc;
+	}
+
+	rc = krb5_timeofday(context, &mcreds.times.endtime);
+	if (rc) {
+		syslog(LOG_DEBUG, "%s: unable to get time: %s",
+			__func__, krb5_get_error_message(context, rc));
+		goto out_free_principal;
+	}
+
+	rc = krb5_cc_retrieve_cred(context, ccache, KRB5_TC_MATCH_TIMES, &mcreds, &out_creds);
+
+	if (!rc)
+		krb5_free_cred_contents(context, &out_creds);
+
+out_free_principal:
+	krb5_free_principal(context, mcreds.server);
+	krb5_free_principal(context, mcreds.client);
+
+	return rc;
+}
+
 static int
 cifs_krb5_get_req(const char *host, krb5_ccache ccache,
 		  DATA_BLOB * mechtoken, DATA_BLOB * sess_key)
@@ -1516,12 +1554,26 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	host = arg->hostname;
 	ccache = get_existing_cc(env_cachename);
+	if (ccache != NULL) {
+		rc = check_service_ticket_exists(ccache, host);
+		if(rc == 0) {
+			 syslog(LOG_DEBUG, "%s: valid service ticket exists in credential cache",
+					 __func__);
+		} else {
+			 if (!get_tgt_time(ccache)) {
+				syslog(LOG_DEBUG, "%s: valid TGT is not present in credential cache",
+						__func__);
+				krb5_cc_close(context, ccache);
+				ccache = NULL;
+			}
+		}
+	}
 	/* Couldn't find credcache? Try to use keytab */
 	if (ccache == NULL && arg->username[0] != '\0')
 		ccache = init_cc_from_keytab(keytab_name, arg->username);
 
-	host = arg->hostname;
 
 	// do mech specific authorization
 	switch (arg->sec) {
-- 
2.43.0

