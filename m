Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0361DA309;
	Mon, 28 Oct 2024 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730113466; cv=none; b=fX1Zy3/AOx99QiAbSnp9jmhJhKG97iXDBbL8G1xiCXWbcIZKCmZ075eex17bRap4W2fa1pB41lac4wZfME3CcyM4+FCn21n7KzRrgic5zqkXj7F+5cJA8HTRSKk1+6cRx/4Fl/SYOWlcljvK4Lc7uX5ffNJiUh2OgzfFU78s5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730113466; c=relaxed/simple;
	bh=bm+RRqbe/JhESROs99jQSB63rwUhxOeEc+sxxBHydlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iaIBWPlrxTP8Sx5c5lQkVzVCsaNfAqq8Vj8hQqpdnx7NLa4Ks/bFwdfTVit5XV7qo7vEeMdrsWX/7aC0eaZKfoi1PydXRbpkfaPZHae2iStqYM+xisUH4VKzQzRLuDGR8ITvHsRGxMQbJwOS8PovSns8v1yI0qf5LOTM0aW301I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1g8JaSc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1g8JaSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DBDC4CEE4;
	Mon, 28 Oct 2024 11:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730113465;
	bh=bm+RRqbe/JhESROs99jQSB63rwUhxOeEc+sxxBHydlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A1g8JaScxncUmzZwTQU01Kd4wydn2gIFmD+oL0YhyjU3/6Kt4nNLtfk543EKDv2zC
	 6dmIYWraE0Cn0ZjL1igACgXhZMwnxgBgNWetNdxk7JImZfnlnsjAmVGdVCoDCGjmZM
	 7vQaJca5mmX7doJZmI4dYqD9Fpr5zWOXhFNK6Ul1HMy+CXO/CBV7xpF5WgS+HQ9xmY
	 b+xe2W0jOvJ/W6dXB0R1P90gIicVXCP4447ZHu3LQFurnEbl/yAJQ1IiNuzSoFbmM7
	 8ZHcDpyPQ+pAqiLKN1ej3gKZbPRgk8F3uGWUqrx6Dui44Xx8xbnc9uqK5PWc2uGyr6
	 nraCks0nvIfuA==
Received: by pali.im (Postfix)
	id 66E51AB4; Mon, 28 Oct 2024 12:04:18 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] cifs: Fix encoding of SMB1 Session Setup Kerberos Request in non-UNICODE mode
Date: Mon, 28 Oct 2024 12:03:37 +0100
Message-Id: <20241028110340.29911-3-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241028110340.29911-1-pali@kernel.org>
References: <20241028110340.29911-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Like in UNICODE mode, SMB1 Session Setup Kerberos Request contains oslm and
domain strings.

Extract common code into ascii_oslm_strings() and ascii_domain_string()
functions (similar to unicode variants) and use these functions in
non-UNICODE code path in sess_auth_kerberos().

Decision if non-UNICODE or UNICODE mode is used is based on the
SMBFLG2_UNICODE flag in Flags2 packed field, and not based on the
capabilities of server. Fix this check too.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/sess.c | 60 +++++++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 20 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 6a92db287843..7226f2563b99 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -701,6 +701,22 @@ unicode_oslm_strings(char **pbcc_area, const struct nls_table *nls_cp)
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
@@ -725,6 +741,25 @@ static void unicode_domain_string(char **pbcc_area, struct cifs_ses *ses,
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
@@ -770,25 +805,10 @@ static void ascii_ssetup_strings(char **pbcc_area, struct cifs_ses *ses,
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
2.20.1

