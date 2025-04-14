Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7ABA2BCF49;
	Mon, 14 Apr 2025 13:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744637386; cv=none; b=rXmnEfLkQ6FaIHIn8byfW+7DM8ZnQqQtGmOmgq0jUKXheS4wzIHd03OoL46lyDIoiL0i7EBTaayN10HyN2wNSCgMO++k4Nm7HsMHKuaUuq0lW9wLQ+ZGdDChEdVKw0mLPIkUuq46+OsrqqngGY4VDx9Zqfr1yMmJsLDrGItPvFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744637386; c=relaxed/simple;
	bh=fpJRf9CZe3T5C9C8/QyTP6/QH8MxITneSs68umnEErU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTot8bL16xV9YyybAGYWvwOTvqdgVqNh25oWl6mMNyNCTewunhpZghjPZPkR0AL6vg1aVgMEKD/VdWB/kBXePjfCxAF5GCzGz4IzaUUcMHF/ItQO2LoJ9nPG2RPUvA6fxOtAP4HM9G/9IBxXSxIbvTqd6MpzNra8Oe4bAmXrm2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SD0pt11P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SD0pt11P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6328CC4CEEC;
	Mon, 14 Apr 2025 13:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744637386;
	bh=fpJRf9CZe3T5C9C8/QyTP6/QH8MxITneSs68umnEErU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SD0pt11P+LNACgWtgyL8apNeE16icaB9wFrIjOxl5c6dP1zLIVyBc8Zx/N/WdGbkW
	 cFk7+8vYYak4pnN+4Tw+5faGa+5F8BOw4PtKtTtMxJ548oFSQhoXmqAJANSmBhxtsX
	 vfAMBMkxfO4TYuEsFaOODJdOWbMrKqmQ/WoOZrM70VbWRh5rpk6tbqhIJm/7zqLX6g
	 pSudXrxN3zcnw+KeiS9tWq+IBIlHIW62eXlmYyyEHGSM7faVDEimB3orQa4ImdiR9U
	 slwF/Hhkw5AJKbyOoY16vcPXVgExWaxEp/Ggnw4VR7pofRVQvs1i2KKh1zW6odcMDt
	 Q3wCK0oRTsWgQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 25/30] cifs: Fix encoding of SMB1 Session Setup Kerberos Request in non-UNICODE mode
Date: Mon, 14 Apr 2025 09:28:42 -0400
Message-Id: <20250414132848.679855-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250414132848.679855-1-sashal@kernel.org>
References: <20250414132848.679855-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.23
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 16cb6b0509b65ac89187e9402e0b7a9ddf1765ef ]

Like in UNICODE mode, SMB1 Session Setup Kerberos Request contains oslm and
domain strings.

Extract common code into ascii_oslm_strings() and ascii_domain_string()
functions (similar to unicode variants) and use these functions in
non-UNICODE code path in sess_auth_kerberos().

Decision if non-UNICODE or UNICODE mode is used is based on the
SMBFLG2_UNICODE flag in Flags2 packed field, and not based on the
capabilities of server. Fix this check too.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/sess.c | 60 +++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 95e14977baeab..0a8fdbbfc081d 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -700,6 +700,22 @@ unicode_oslm_strings(char **pbcc_area, const struct nls_table *nls_cp)
 	*pbcc_area = bcc_ptr;
 }
 
+static void
+ascii_oslm_strings(char **pbcc_area, const struct nls_table *nls_cp)
+{
+	char *bcc_ptr = *pbcc_area;
+
+	strcpy(bcc_ptr, "Linux version ");
+	bcc_ptr += strlen("Linux version ");
+	strcpy(bcc_ptr, init_utsname()->release);
+	bcc_ptr += strlen(init_utsname()->release) + 1;
+
+	strcpy(bcc_ptr, CIFS_NETWORK_OPSYS);
+	bcc_ptr += strlen(CIFS_NETWORK_OPSYS) + 1;
+
+	*pbcc_area = bcc_ptr;
+}
+
 static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 				   const struct nls_table *nls_cp)
 {
@@ -724,6 +740,25 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
 	*pbcc_area = bcc_ptr;
 }
 
+static void ascii_domain_string(char **pbcc_area, struct cifs_ses *ses,
+				const struct nls_table *nls_cp)
+{
+	char *bcc_ptr = *pbcc_area;
+	int len;
+
+	/* copy domain */
+	if (ses->domainName != NULL) {
+		len = strscpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
+		if (WARN_ON_ONCE(len < 0))
+			len = CIFS_MAX_DOMAINNAME_LEN - 1;
+		bcc_ptr += len;
+	} /* else we send a null domain name so server will default to its own domain */
+	*bcc_ptr = 0;
+	bcc_ptr++;
+
+	*pbcc_area = bcc_ptr;
+}
+
 static void unicode_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 				   const struct nls_table *nls_cp)
 {
@@ -769,25 +804,10 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
 	*bcc_ptr = 0;
 	bcc_ptr++; /* account for null termination */
 
-	/* copy domain */
-	if (ses->domainName != NULL) {
-		len = strscpy(bcc_ptr, ses->domainName, CIFS_MAX_DOMAINNAME_LEN);
-		if (WARN_ON_ONCE(len < 0))
-			len = CIFS_MAX_DOMAINNAME_LEN - 1;
-		bcc_ptr += len;
-	} /* else we send a null domain name so server will default to its own domain */
-	*bcc_ptr = 0;
-	bcc_ptr++;
-
 	/* BB check for overflow here */
 
-	strcpy(bcc_ptr, "Linux version ");
-	bcc_ptr += strlen("Linux version ");
-	strcpy(bcc_ptr, init_utsname()->release);
-	bcc_ptr += strlen(init_utsname()->release) + 1;
-
-	strcpy(bcc_ptr, CIFS_NETWORK_OPSYS);
-	bcc_ptr += strlen(CIFS_NETWORK_OPSYS) + 1;
+	ascii_domain_string(&bcc_ptr, ses, nls_cp);
+	ascii_oslm_strings(&bcc_ptr, nls_cp);
 
 	*pbcc_area = bcc_ptr;
 }
@@ -1590,7 +1610,7 @@ sess_auth_kerberos(struct sess_data *sess_data)
 	sess_data->iov[1].iov_len = msg->secblob_len;
 	pSMB->req.SecurityBlobLength = cpu_to_le16(sess_data->iov[1].iov_len);
 
-	if (ses->capabilities & CAP_UNICODE) {
+	if (pSMB->req.hdr.Flags2 & SMBFLG2_UNICODE) {
 		/* unicode strings must be word aligned */
 		if (!IS_ALIGNED(sess_data->iov[0].iov_len + sess_data->iov[1].iov_len, 2)) {
 			*bcc_ptr = 0;
@@ -1599,8 +1619,8 @@ sess_auth_kerberos(struct sess_data *sess_data)
 		unicode_oslm_strings(&bcc_ptr, sess_data->nls_cp);
 		unicode_domain_string(&bcc_ptr, ses, sess_data->nls_cp);
 	} else {
-		/* BB: is this right? */
-		ascii_ssetup_strings(&bcc_ptr, ses, sess_data->nls_cp);
+		ascii_oslm_strings(&bcc_ptr, sess_data->nls_cp);
+		ascii_domain_string(&bcc_ptr, ses, sess_data->nls_cp);
 	}
 
 	sess_data->iov[2].iov_len = (long) bcc_ptr -
-- 
2.39.5

