Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F08F155C8A
	for <linux-cifs@vger.kernel.org>; Tue, 19 Nov 2024 06:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731996532; cv=none; b=cXb0wSj5U+Cxym4ofRpQFC7XXWiY2GSlVVw3SufdwswtX2ljMbTWZIK0k82TIXaBPpCdLSIhj3CVf2eEY1qLrOrMXpa+jJzAoWCVdwueRq9Pig8HFbx74zlE4UZu7f96OWw8VUklHTHVY5D3IfBj0jrww2UwlGM9hZxMunN/j8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731996532; c=relaxed/simple;
	bh=Qy7Row9Q1xQwndfUeqkhrcHJb4CRdOrQbU+L8XpGWbE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lSRspql9YvFoKX6AjK7PR6VKpRa+NvRbal78bckmXtsDlOyo4cAx66Uo/7rH4tH7fEleunbaCePivovFJ3ipeUVvMcWxspme9JTqj95CM0UEsyCGSy7Lv1f1vBohs5kzAlrhTokjOdvNUonL/Ca7wVGaCNLLVqnHcABk2WtCTL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rsk1FkkX; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rsk1FkkX"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7eab7622b61so372357a12.1
        for <linux-cifs@vger.kernel.org>; Mon, 18 Nov 2024 22:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731996530; x=1732601330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=opQIo/UDex7F0GgDQYPwbV3A+5hkpDYxUE4ItcEBt0Y=;
        b=Rsk1FkkXsosNlJoxxLlv43ReaU3VWnRYdT1CdRdDAOfW5jNVD6iQqfOTBqA4CJb73p
         psyW8dDfCjlHnFe4trmAG/Q8TReAZrWAJ92kEVFJosZuQAe39vqvHqtFfIdOKsQOULkb
         vqFy6QVYuBGd5vBo1VNO2SdrT4tz2TSXhnpBf7oK7MoMY4xkFmziT/mYhkaPZXVLLSIS
         faDmVhfoqnh7F4o6D8hfyOVHNJ8BUPUG90xgEa/5pomqtoEG2Fhg3dnu57ZUF4grNz5S
         fWn/shv3VWrG1mAw+JxXmN/gydWxq8xEjE8Sd5BdsTjj5YF3tkvTeijYte6r6XZKhvEW
         9O2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731996530; x=1732601330;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=opQIo/UDex7F0GgDQYPwbV3A+5hkpDYxUE4ItcEBt0Y=;
        b=aMQ8TwXLR5uembBGi2mFdygZWNIw/sBbcZ591OMOeCPm6kNJaX0xYoPntkQ095CliE
         1kbVfU13EQeWb+YDRVnLPLsdJduNpxUP4wl1KWnHwaiM9ByW+0AEVuc56WT/1Cy8u2CW
         CoXMj2Q7krcYJnyrThMcnKyZ4ADZ/O4b0mUkK23h6pe4o/oRtO6YP1jWSp8202g0GRa5
         v7z8FV9S0ZJEuf87fQD7SD0oexTwh/m5DSJoLWB4RHkS53gcFpl4PlMDH1faCHW8z8kR
         jNiDSctzOxCJWCQlX6TCzaIoYotw5AjsQ1mRfazXFVtsJ4pcSxE6J3BvuLlcXzZ573iZ
         bRIw==
X-Forwarded-Encrypted: i=1; AJvYcCUrlKmIJHR0S6CWXQTa+WwJZfb5TLFwIUJ6QEwq3d95POSVee87ViNo7U1KsQOw6YxJUtjcFw9ml2FB@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ8+pgmlYa9R8VRCiimdkscmoZbMB3fy0KKSv/smtHR4NYdUMx
	eRbjW5T1F1IvFoax3w9EnUey7sojod/PbsZ12K7cnOrWpmXreWB/MSTqlA==
X-Google-Smtp-Source: AGHT+IEfHUiQI6usz/n2/+Yp+y7Gui1hJeLSyHkhjbwnnVv98/4OVzbKmF/xkVUnp2Le0R3ar2Hwcg==
X-Received: by 2002:a05:6a20:3d8d:b0:1db:ef91:2e51 with SMTP id adf61e73a8af0-1dc90baa5a4mr24016748637.28.1731996529867;
        Mon, 18 Nov 2024 22:08:49 -0800 (PST)
Received: from localhost ([74.225.236.108])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724771bfdfdsm7526723b3a.129.2024.11.18.22.08.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 22:08:49 -0800 (PST)
From: budhirajaritviksmb@gmail.com
To: pc@manguebit.com,
	dhowells@redhat.com,
	jlayton@kernel.org,
	smfrench@gmail.com,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	nspmangalore@gmail.com,
	bharathsm.hsk@gmail.com,
	lsahlber@redhat.com
Cc: Ritvik Budhiraja <rbudhiraja@microsoft.com>
Subject: [PATCH] CIFS.upcall to accomodate new namespace mount opt
Date: Tue, 19 Nov 2024 06:07:58 +0000
Message-ID: <20241119060758.273090-1-budhirajaritviksmb@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ritvik Budhiraja <rbudhiraja@microsoft.com>

NOTE: This patch is dependent on one of the previously sent patches:
[PATCH] CIFS: New mount option for cifs.upcall namespace resolution
which introduces a new mount option called upcall_target, to
customise the upcall behaviour.
 
Building upon the above patch, the following patch adds functionality
to handle upcall_target as a mount option in cifs.upcall. It can have 2 values -
mount, app. 
Having this new mount option allows the mount command to specify where the
upcall should happen: 'mount' for resolving the upcall to the host
namespace, and 'app' for resolving the upcall to the ns of the calling
thread. This will enable both the scenarios where the Kerberos credentials
can be found on the application namespace or the host namespace to which
just the mount operation is "delegated".
This aids use cases like Kubernetes where the mount
happens on behalf of the application in another container altogether.

Signed-off-by: Ritvik Budhiraja <rbudhiraja@microsoft.com>
---
 cifs.upcall.c | 55 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 47 insertions(+), 8 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index ff6f2bd..a790aca 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -954,6 +954,13 @@ struct decoded_args {
 #define MAX_USERNAME_SIZE 256
 	char username[MAX_USERNAME_SIZE + 1];
 
+#define MAX_UPCALL_STRING_LEN 6 /* "mount\0" */
+	enum upcall_target_enum {
+		UPTARGET_UNSPECIFIED, /* not specified, defaults to app */
+		UPTARGET_MOUNT, /* upcall to the mount namespace */
+		UPTARGET_APP, /* upcall to the application namespace which did the mount */
+	} upcall_target;
+
 	uid_t uid;
 	uid_t creduid;
 	pid_t pid;
@@ -970,6 +977,7 @@ struct decoded_args {
 #define DKD_HAVE_PID		0x20
 #define DKD_HAVE_CREDUID	0x40
 #define DKD_HAVE_USERNAME	0x80
+#define DKD_HAVE_UPCALL_TARGET	0x100
 #define DKD_MUSTHAVE_SET (DKD_HAVE_HOSTNAME|DKD_HAVE_VERSION|DKD_HAVE_SEC)
 	int have;
 };
@@ -980,6 +988,7 @@ __decode_key_description(const char *desc, struct decoded_args *arg)
 	size_t len;
 	char *pos;
 	const char *tkn = desc;
+	arg->upcall_target = UPTARGET_UNSPECIFIED;
 
 	do {
 		pos = index(tkn, ';');
@@ -1078,6 +1087,31 @@ __decode_key_description(const char *desc, struct decoded_args *arg)
 			}
 			arg->have |= DKD_HAVE_VERSION;
 			syslog(LOG_DEBUG, "ver=%d", arg->ver);
+		} else if (strncmp(tkn, "upcall_target=", 14) == 0) {
+			if (pos == NULL)
+				len = strlen(tkn);
+			else
+				len = pos - tkn;
+
+			len -= 14;
+			if (len > MAX_UPCALL_STRING_LEN) {
+				syslog(LOG_ERR, "upcall_target= value too long for buffer");
+				return 1;
+			}
+			if (strncmp(tkn + 14, "mount", 5) == 0) {
+				arg->upcall_target = UPTARGET_MOUNT;
+				syslog(LOG_DEBUG, "upcall_target=mount");
+			} else if (strncmp(tkn + 14, "app", 3) == 0) {
+				arg->upcall_target = UPTARGET_APP;
+				syslog(LOG_DEBUG, "upcall_target=app");
+			} else {
+				// Should never happen
+				syslog(LOG_ERR, "Invalid upcall_target value: %s, defaulting to app",
+				       tkn + 14);
+				arg->upcall_target = UPTARGET_APP;
+				syslog(LOG_DEBUG, "upcall_target=app");
+			}
+			arg->have |= DKD_HAVE_UPCALL_TARGET;
 		}
 		if (pos == NULL)
 			break;
@@ -1441,15 +1475,20 @@ int main(const int argc, char *const argv[])
 	 * acceptably in containers, because we'll be looking at the correct
 	 * filesystem and have the correct network configuration.
 	 */
-	rc = switch_to_process_ns(arg->pid);
-	if (rc == -1) {
-		syslog(LOG_ERR, "unable to switch to process namespace: %s", strerror(errno));
-		rc = 1;
-		goto out;
+	if (arg->upcall_target == UPTARGET_APP || arg->upcall_target == UPTARGET_UNSPECIFIED) {
+		syslog(LOG_INFO, "upcall_target=app, switching namespaces to application thread");
+		rc = switch_to_process_ns(arg->pid);
+		if (rc == -1) {
+			syslog(LOG_ERR, "unable to switch to process namespace: %s", strerror(errno));
+			rc = 1;
+			goto out;
+		}
+		if (trim_capabilities(env_probe))
+			goto out;
+	} else {
+		syslog(LOG_INFO, "upcall_target=mount, not switching namespaces to application thread");
 	}
 
-	if (trim_capabilities(env_probe))
-		goto out;
 
 	/*
 	 * The kernel doesn't pass down the gid, so we resort here to scraping
@@ -1496,7 +1535,7 @@ int main(const int argc, char *const argv[])
 	 * look at the environ file.
 	 */
 	env_cachename =
-		get_cachename_from_process_env(env_probe ? arg->pid : 0);
+		get_cachename_from_process_env((env_probe && (arg->upcall_target == UPTARGET_APP)) ? arg->pid : 0);
 
 	rc = setuid(uid);
 	if (rc == -1) {
-- 
2.43.0

