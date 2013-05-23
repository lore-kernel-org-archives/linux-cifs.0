From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/19] cifs: break out lanman NEGOTIATE handling into separate function
Date: Thu, 23 May 2013 11:05:52 -0400
Message-ID: <1369321563-16893-9-git-send-email-jlayton@redhat.com>
References: <1369321563-16893-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369321563-16893-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...this also gets rid of some #ifdef ugliness too.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c | 185 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 97 insertions(+), 88 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 9b4aea8..5dd4f8a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -417,6 +417,96 @@ decode_ext_sec_blob(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr)
 	return 0;
 }
 
+#ifdef CONFIG_CIFS_WEAK_PW_HASH
+static int
+decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
+			  unsigned int secFlags)
+{
+	__s16 tmp;
+	struct lanman_neg_rsp *rsp = (struct lanman_neg_rsp *)pSMBr;
+
+	if (server->dialect != LANMAN_PROT && server->dialect != LANMAN2_PROT)
+		return -EOPNOTSUPP;
+
+	if ((secFlags & CIFSSEC_MAY_LANMAN) || (secFlags & CIFSSEC_MAY_PLNTXT))
+		server->secType = LANMAN;
+	else {
+		cifs_dbg(VFS, "mount failed weak security disabled in /proc/fs/cifs/SecurityFlags\n");
+		return -EOPNOTSUPP;
+	}
+	server->sec_mode = le16_to_cpu(rsp->SecurityMode);
+	server->maxReq = min_t(unsigned int,
+			       le16_to_cpu(rsp->MaxMpxCount),
+			       cifs_max_pending);
+	set_credits(server, server->maxReq);
+	server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
+	server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
+	/* even though we do not use raw we might as well set this
+	accurately, in case we ever find a need for it */
+	if ((le16_to_cpu(rsp->RawMode) & RAW_ENABLE) == RAW_ENABLE) {
+		server->max_rw = 0xFF00;
+		server->capabilities = CAP_MPX_MODE | CAP_RAW_MODE;
+	} else {
+		server->max_rw = 0;/* do not need to use raw anyway */
+		server->capabilities = CAP_MPX_MODE;
+	}
+	tmp = (__s16)le16_to_cpu(rsp->ServerTimeZone);
+	if (tmp == -1) {
+		/* OS/2 often does not set timezone therefore
+		 * we must use server time to calc time zone.
+		 * Could deviate slightly from the right zone.
+		 * Smallest defined timezone difference is 15 minutes
+		 * (i.e. Nepal).  Rounding up/down is done to match
+		 * this requirement.
+		 */
+		int val, seconds, remain, result;
+		struct timespec ts, utc;
+		utc = CURRENT_TIME;
+		ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
+				    rsp->SrvTime.Time, 0);
+		cifs_dbg(FYI, "SrvTime %d sec since 1970 (utc: %d) diff: %d\n",
+			 (int)ts.tv_sec, (int)utc.tv_sec,
+			 (int)(utc.tv_sec - ts.tv_sec));
+		val = (int)(utc.tv_sec - ts.tv_sec);
+		seconds = abs(val);
+		result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
+		remain = seconds % MIN_TZ_ADJ;
+		if (remain >= (MIN_TZ_ADJ / 2))
+			result += MIN_TZ_ADJ;
+		if (val < 0)
+			result = -result;
+		server->timeAdj = result;
+	} else {
+		server->timeAdj = (int)tmp;
+		server->timeAdj *= 60; /* also in seconds */
+	}
+	cifs_dbg(FYI, "server->timeAdj: %d seconds\n", server->timeAdj);
+
+
+	/* BB get server time for time conversions and add
+	code to use it and timezone since this is not UTC */
+
+	if (rsp->EncryptionKeyLength ==
+			cpu_to_le16(CIFS_CRYPTO_KEY_SIZE)) {
+		memcpy(server->cryptkey, rsp->EncryptionKey,
+			CIFS_CRYPTO_KEY_SIZE);
+	} else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
+		return -EIO; /* need cryptkey unless plain text */
+	}
+
+	cifs_dbg(FYI, "LANMAN negotiated\n");
+	return 0;
+}
+#else
+static inline int
+decode_lanman_negprot_rsp(struct TCP_Server_Info *server, NEGOTIATE_RSP *pSMBr,
+			  unsigned int secFlags)
+{
+	cifs_dbg(VFS, "mount failed, cifs module not built with CIFS_WEAK_PW_HASH support\n");
+	return -EOPNOTSUPP;
+}
+#endif
+
 int
 CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 {
@@ -485,98 +575,19 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 		could not negotiate a common dialect */
 		rc = -EOPNOTSUPP;
 		goto neg_err_exit;
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
-	} else if ((pSMBr->hdr.WordCount == 13)
-			&& ((server->dialect == LANMAN_PROT)
-				|| (server->dialect == LANMAN2_PROT))) {
-		__s16 tmp;
-		struct lanman_neg_rsp *rsp = (struct lanman_neg_rsp *)pSMBr;
-
-		if ((secFlags & CIFSSEC_MAY_LANMAN) ||
-			(secFlags & CIFSSEC_MAY_PLNTXT))
-			server->secType = LANMAN;
-		else {
-			cifs_dbg(VFS, "mount failed weak security disabled in /proc/fs/cifs/SecurityFlags\n");
-			rc = -EOPNOTSUPP;
-			goto neg_err_exit;
-		}
-		server->sec_mode = le16_to_cpu(rsp->SecurityMode);
-		server->maxReq = min_t(unsigned int,
-				       le16_to_cpu(rsp->MaxMpxCount),
-				       cifs_max_pending);
-		set_credits(server, server->maxReq);
-		server->maxBuf = le16_to_cpu(rsp->MaxBufSize);
-		server->max_vcs = le16_to_cpu(rsp->MaxNumberVcs);
-		/* even though we do not use raw we might as well set this
-		accurately, in case we ever find a need for it */
-		if ((le16_to_cpu(rsp->RawMode) & RAW_ENABLE) == RAW_ENABLE) {
-			server->max_rw = 0xFF00;
-			server->capabilities = CAP_MPX_MODE | CAP_RAW_MODE;
-		} else {
-			server->max_rw = 0;/* do not need to use raw anyway */
-			server->capabilities = CAP_MPX_MODE;
-		}
-		tmp = (__s16)le16_to_cpu(rsp->ServerTimeZone);
-		if (tmp == -1) {
-			/* OS/2 often does not set timezone therefore
-			 * we must use server time to calc time zone.
-			 * Could deviate slightly from the right zone.
-			 * Smallest defined timezone difference is 15 minutes
-			 * (i.e. Nepal).  Rounding up/down is done to match
-			 * this requirement.
-			 */
-			int val, seconds, remain, result;
-			struct timespec ts, utc;
-			utc = CURRENT_TIME;
-			ts = cnvrtDosUnixTm(rsp->SrvTime.Date,
-					    rsp->SrvTime.Time, 0);
-			cifs_dbg(FYI, "SrvTime %d sec since 1970 (utc: %d) diff: %d\n",
-				 (int)ts.tv_sec, (int)utc.tv_sec,
-				 (int)(utc.tv_sec - ts.tv_sec));
-			val = (int)(utc.tv_sec - ts.tv_sec);
-			seconds = abs(val);
-			result = (seconds / MIN_TZ_ADJ) * MIN_TZ_ADJ;
-			remain = seconds % MIN_TZ_ADJ;
-			if (remain >= (MIN_TZ_ADJ / 2))
-				result += MIN_TZ_ADJ;
-			if (val < 0)
-				result = -result;
-			server->timeAdj = result;
-		} else {
-			server->timeAdj = (int)tmp;
-			server->timeAdj *= 60; /* also in seconds */
-		}
-		cifs_dbg(FYI, "server->timeAdj: %d seconds\n", server->timeAdj);
-
-
-		/* BB get server time for time conversions and add
-		code to use it and timezone since this is not UTC */
-
-		if (rsp->EncryptionKeyLength ==
-				cpu_to_le16(CIFS_CRYPTO_KEY_SIZE)) {
-			memcpy(ses->server->cryptkey, rsp->EncryptionKey,
-				CIFS_CRYPTO_KEY_SIZE);
-		} else if (server->sec_mode & SECMODE_PW_ENCRYPT) {
-			rc = -EIO; /* need cryptkey unless plain text */
-			goto neg_err_exit;
-		}
-
-		cifs_dbg(FYI, "LANMAN negotiated\n");
-		/* we will not end up setting signing flags - as no signing
-		was in LANMAN and server did not return the flags on */
-		goto signing_check;
-#else /* weak security disabled */
 	} else if (pSMBr->hdr.WordCount == 13) {
-		cifs_dbg(VFS, "mount failed, cifs module not built with CIFS_WEAK_PW_HASH support\n");
-		rc = -EOPNOTSUPP;
-#endif /* WEAK_PW_HASH */
-		goto neg_err_exit;
+		rc = decode_lanman_negprot_rsp(server, pSMBr, secFlags);
+		if (!rc)
+			goto signing_check;
+		else
+			goto neg_err_exit;
 	} else if (pSMBr->hdr.WordCount != 17) {
 		/* unknown wct */
 		rc = -EOPNOTSUPP;
 		goto neg_err_exit;
 	}
-	/* else wct == 17 NTLM */
+	/* else wct == 17, NTLM or better */
+
 	server->sec_mode = pSMBr->SecurityMode;
 	if ((server->sec_mode & SECMODE_USER) == 0)
 		cifs_dbg(FYI, "share mode security\n");
@@ -634,9 +645,7 @@ CIFSSMBNegotiate(const unsigned int xid, struct cifs_ses *ses)
 	if (rc)
 		goto neg_err_exit;
 
-#ifdef CONFIG_CIFS_WEAK_PW_HASH
 signing_check:
-#endif
 	if ((secFlags & CIFSSEC_MAY_SIGN) == 0) {
 		/* MUST_SIGN already includes the MAY_SIGN FLAG
 		   so if this is zero it means that signing is disabled */
-- 
1.8.1.4
