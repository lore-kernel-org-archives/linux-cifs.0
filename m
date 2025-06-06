Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89672288CBA;
	Fri,  6 Jun 2025 15:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224548; cv=none; b=V99jy1zTtqy6IgDGMSmS2Q5Sa/TharV1QverZYRrGAWQlqHEFvuvUzyqt1YNPaCPL2uqff9CypbdVMg40ZBOXXM25+7iddWhLxQdYpK5BJITNh0CnuiO56KVOJw+aAK8xWPYeTFtpdKrB8JMZYxO3790eSt/+7qNm0GMdcOqtj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224548; c=relaxed/simple;
	bh=2BmmHclrSLya+TtMmAzcXy+bKR62XNRPAQhscIpp5YQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=oFFfQh0rig3GF0r1eS/h5kl/QuD+1oJUh31EEmAUTQWTO77NJyVY+RN6BoWza6rXtTWDm/wziAIS8S+xQOb9Yba+A3YlXmtbeHmscmSfAPTjzB3qnQ+angiigYLiun9ZZHPLgW9UumbqZ2+pyHGk/x+EBX5s2JAiSWbh4p7awrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgOjGP9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgOjGP9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFCBC4CEEB;
	Fri,  6 Jun 2025 15:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224548;
	bh=2BmmHclrSLya+TtMmAzcXy+bKR62XNRPAQhscIpp5YQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cgOjGP9Px5jhg3kWwqqcr/p/uO3KoXg9dkk4THTryKUlY+rat936v1eJHRCBpvDh/
	 qAjFSnj4cD5iIzBKKDi9iHB4s80ppZePriXXSJ1VH+VCTw7y2j9laTsYLglKNKGcMx
	 ZdVVI3Wm7JxKf/OAd2gJXKYVkjQlqHTX8CJxVTqaREAPzXmK07c29vS8D4FP8/HyVN
	 qW7R9BO5sR2yUg0Zo8JCycr+sAa9Id/EujgcdFsiXoB9/2hIk4R1awSIr/WIiE3JVV
	 AhNDsqgqnFyYISXaQPfOipqh4zWsFGxAZiAWJ1dP4U0dQOqeO9DyILlVjeo+qYwxHc
	 U2nKzsnm5U2Ow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 01/19] cifs: Correctly set SMB1 SessionKey field in Session Setup Request
Date: Fri,  6 Jun 2025 11:42:07 -0400
Message-Id: <20250606154225.546969-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.10
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 89381c72d52094988e11d23ef24a00066a0fa458 ]

[MS-CIFS] specification in section 2.2.4.53.1 where is described
SMB_COM_SESSION_SETUP_ANDX Request, for SessionKey field says:

    The client MUST set this field to be equal to the SessionKey field in
    the SMB_COM_NEGOTIATE Response for this SMB connection.

Linux SMB client currently set this field to zero. This is working fine
against Windows NT SMB servers thanks to [MS-CIFS] product behavior <94>:

    Windows NT Server ignores the client's SessionKey.

For compatibility with [MS-CIFS], set this SessionKey field in Session
Setup Request to value retrieved from Negotiate response.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my comprehensive analysis of both the commit message and code
changes, examining the current kernel tree context: **YES** ## Extensive
Analysis ### **Nature of the Fix** This is a **specification compliance
fix** for SMB1 protocol handling. The commit addresses a clear violation
of the MS-CIFS specification section 2.2.4.53.1, which mandates that the
SessionKey field in SMB_COM_SESSION_SETUP_ANDX Request must be set to
the value from the SMB_COM_NEGOTIATE Response. ### **Code Changes
Analysis** **1. Structural Changes (Low Risk)** - **cifsglob.h**: Adds
`__le32 session_key_id` to `TCP_Server_Info` structure - minimal ABI
impact as this is kernel-internal - **cifspdu.h**: Corrects endianness
annotations from `__u32` to `__le32` - pure annotation fix, no
behavioral change **2. Functional Changes (Contained and Safe)** -
**cifssmb.c**: Captures SessionKey from negotiate response
(`server->session_key_id = pSMBr->SessionKey`) - simple field assignment
- **sess.c**: Sets SessionKey in session setup request
(`pSMB->req.SessionKey = server->session_key_id`) - follows
specification requirement ### **Risk Assessment** **Minimal Regression
Risk:** - Changes are isolated to SMB1 legacy protocol code - Current
behavior (setting SessionKey to zero) works with Windows NT due to MS-
CIFS product behavior <94> - New behavior follows specification exactly,
improving compatibility with non-Windows SMB1 servers - No security
implications - purely a protocol compliance improvement **Code
Maturity:** - SMB1 session setup code is very mature and stable -
Limited recent changes in this area except compatibility fixes - Well-
understood code path with clear specification backing ### **Backport
Suitability Criteria Met** **1. Important Bug Fix:** ✅ Fixes protocol
specification violation that could cause compatibility issues with
strict SMB1 implementations **2. Small and Contained:** ✅ Four minimal
changes across related files, all implementing the same specification
requirement **3. Clear Side Effects:** ✅ No side effects beyond fixing
the specification compliance issue **4. No Architectural Changes:** ✅
Simple field additions and assignments, no structural changes **5. Non-
Critical Subsystem:** ✅ Legacy SMB1 protocol code, deprecated since 2017
**6. Minimal Risk:** ✅ Maintains backward compatibility while improving
forward compatibility **7. Stable Tree Rules Compliance:** ✅ Important
compatibility bugfix with minimal regression risk ### **Comparison to
Similar Commits** This commit closely matches the pattern of **Similar
Commit #3** and **Similar Commit #5** (both marked YES for backporting):
- Protocol compliance improvements - Session setup related fixes - Clear
specification backing - Minimal, contained changes - Authored by
maintainers (Steve French involvement) ### **Conclusion** This commit
represents an ideal stable backport candidate: a clear specification
compliance fix with minimal code changes, no security implications, and
improvement in interoperability. The fix ensures Linux kernel SMB client
properly follows MS-CIFS specification, which is valuable for enterprise
environments using diverse SMB1 server implementations.

 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/cifspdu.h  | 6 +++---
 fs/smb/client/cifssmb.c  | 1 +
 fs/smb/client/sess.c     | 1 +
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cddeb2adbf4af..caada3bf8b883 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -772,6 +772,7 @@ struct TCP_Server_Info {
 	char workstation_RFC1001_name[RFC1001_NAME_LEN_WITH_NULL];
 	__u32 sequence_number; /* for signing, protected by srv_mutex */
 	__u32 reconnect_instance; /* incremented on each reconnect */
+	__le32 session_key_id; /* retrieved from negotiate response and send in session setup request */
 	struct session_key session_key;
 	unsigned long lstrp; /* when we got last response from this server */
 	struct cifs_secmech secmech; /* crypto sec mech functs, descriptors */
diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index cf9ca7e49b8bc..f5afdc5325bfa 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -597,7 +597,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 SecurityBlobLength;
 		__u32 Reserved;
 		__le32 Capabilities;	/* see below */
@@ -616,7 +616,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 CaseInsensitivePasswordLength; /* ASCII password len */
 		__le16 CaseSensitivePasswordLength; /* Unicode password length*/
 		__u32 Reserved;	/* see below */
@@ -654,7 +654,7 @@ typedef union smb_com_session_setup_andx {
 		__le16 MaxBufferSize;
 		__le16 MaxMpxCount;
 		__le16 VcNumber;
-		__u32 SessionKey;
+		__le32 SessionKey;
 		__le16 PasswordLength;
 		__u32 Reserved; /* encrypt key len and offset */
 		__le16 ByteCount;
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 4059550859a9b..68722e60fdae1 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -495,6 +495,7 @@ CIFSSMBNegotiate(const unsigned int xid,
 	server->max_rw = le32_to_cpu(pSMBr->MaxRawSize);
 	cifs_dbg(NOISY, "Max buf = %d\n", ses->server->maxBuf);
 	server->capabilities = le32_to_cpu(pSMBr->Capabilities);
+	server->session_key_id = pSMBr->SessionKey;
 	server->timeAdj = (int)(__s16)le16_to_cpu(pSMBr->ServerTimeZone);
 	server->timeAdj *= 60;
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 9d6b1a4704773..6d6491e035718 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -627,6 +627,7 @@ static __u32 cifs_ssetup_hdr(struct cifs_ses *ses,
 					USHRT_MAX));
 	pSMB->req.MaxMpxCount = cpu_to_le16(server->maxReq);
 	pSMB->req.VcNumber = cpu_to_le16(1);
+	pSMB->req.SessionKey = server->session_key_id;
 
 	/* Now no need to set SMBFLG_CASELESS or obsolete CANONICAL PATH */
 
-- 
2.39.5

