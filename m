Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A0E28688E
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756155236; cv=none; b=BnFvZnNF8dZKMh1ZSO2ygb3V1C9Obqd4uAk9vSy/0LRMOb810bIDnaJ9XLnDuBihO6eG6itUAGRJ/8aUPgd/5LPKTJMn+POpiv5/w4Q0QCM1OSd/NfAJS45nujJRo0qEySkX+lVvuwSgelQt3ghJN+0+eG6F4xaDJ4oMHFSQ9tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756155236; c=relaxed/simple;
	bh=N2An4xbSd9GOUj2MPb5lmUHl1xMymhwxMqz9zLATgTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cynOmOX0/yehhtKSXp7vbU33rprsWwGtErNSl5I9/APBsgpA7ilT6vtfy3AK3G7ddhFHLB8T4at6ZwFe//Bt/AAhOwbiZek7monro+2aOhGObTlQIsa0/XItCmgIiigF9DerpQDDqZB2iONnk4NztGBp/Ng8pjhPBkBPqAgs1xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=QohTBFxO; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="QohTBFxO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=nlWuKhq9gXfsfec/4CdlOEgLoUCFJj2XM3EMbBn+44w=; b=QohTBFxOKmPqyFJ/63voGDtbhI
	TldYhz09LGmv0KP108cDPuzuBBeNmOhSMsvoFV3HLf3163cmUGKXbn6m6FwJIOqvooccrnTuSWXSS
	Qfg9bdvr+3kFVXlLoB5Dplo/6UkKCMOPjuZPbs2+Mdouq9R4EyD5ffAG6SuYsecBbUagOBORlOUSz
	I7W2UmgEpMJx2nKa/J1tn8sSHLs5btLmJnw+K/Hu8XEtmzw7e3p7Ylx0A7keCu59upkZY9rNwwkCk
	CQLqvQGnYZCdTGxEG63jbOuhF5fiqwcVeVABGE9nr0AkhsfcWhWPQkjw4pEy4uLCVARf5JImDhOdB
	EQKYqSZ90NqAwRBP+C4JBwdLkYDL/bBpf+RLlMxupvpa5y+RWOuUgC8mRDNv7vno9kach3AejtpKX
	bhCPKDxYRoLPPe0yexznnddskXJiHQbnbhC/uqIuMhw2BVv8Hcje1QuS+a9k9dMteS9tIYdiqsOUr
	Lq/hLW1g++Dyfm4vAkRBpyCT;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqeCJ-000lci-2Z;
	Mon, 25 Aug 2025 20:53:48 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 072/142] smb: client: pass struct smbdirect_socket to smbd_post_send_negotiate_req()
Date: Mon, 25 Aug 2025 22:40:33 +0200
Message-ID: <80ba0e1085e96f93af1150de163598d5055c2475.1756139607.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1756139607.git.metze@samba.org>
References: <cover.1756139607.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to move function to the common code
in future.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 9fef01ed6320..e5219b9c0c8a 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -827,9 +827,8 @@ static int smbd_ia_open(
  * After negotiation, the transport is connected and ready for
  * carrying upper layer SMB payload
  */
-static int smbd_post_send_negotiate_req(struct smbd_connection *info)
+static int smbd_post_send_negotiate_req(struct smbdirect_socket *sc)
 {
-	struct smbdirect_socket *sc = &info->socket;
 	struct smbdirect_socket_parameters *sp = &sc->parameters;
 	struct ib_send_wr send_wr;
 	int rc = -ENOMEM;
@@ -1221,7 +1220,7 @@ static int smbd_negotiate(struct smbd_connection *info)
 	if (rc)
 		return rc;
 
-	rc = smbd_post_send_negotiate_req(info);
+	rc = smbd_post_send_negotiate_req(sc);
 	if (rc)
 		return rc;
 
-- 
2.43.0

