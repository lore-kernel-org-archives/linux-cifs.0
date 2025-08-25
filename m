Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF11DDAB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154960; cv=none; b=aKBWpORpNy9cykEC+6lx0lerxjhu1DgObgyeLWcygdt6mWlpJYm//pkEIubumIhlFrIzisn4wkVa6p6Kjq7zezUXVt8rMmGCcLaWgfcppzTsIRjd8C7AuL8xh2D6u39lkb06Mx37jN7nCO0KY0rSXCAT5Y46Ovs9vRnl+BfQocQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154960; c=relaxed/simple;
	bh=aG9/lLxJ0Yv09KpksN8YFT85mB2/s76n+n2PhnV/Esw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNNTUbPT4OQ2KzSU/YI0F3e+w2cHC6XbUs/8dbLq5EECTaMwPepp0spZdH7IgPsXdBHKd+oYpIexu8VHeck9DRAE9MqdPA72OtZUy3HrQFR5yKIkVpi8wAo1FTLzu7ImmBbhbzBsWlbh7vw8lC3+/xSEuKOdXYo8QDcidmGiO+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=wl4MWHGq; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="wl4MWHGq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=uRXglccDxx3/AZsZFE1LCTE+r12kACEO3iBf19LjDKU=; b=wl4MWHGqtwEYGILBxQJkFugJ4z
	cxbpaA/Cc7BcsbYo0vErESmdWdKPmvBaIgBSgeYkNFVfUsX9xKilZTYUtDkkre2jWZ2tiKTSzWp/j
	MT923YKaciNZuBd/dtboYGvi6D/oov87a4jkMm0a/UXql69ZAYiBOS+lI9a9HPAoA3CezWUd2wKR+
	9iDwCF4O7TBIAx6AdueBlxemiMGdkAohA/lHFZtPy06WBUpvCw1Vg9RVhsLbXMV60sxzFcLVd/9ey
	WcrMcF+S7/2dku7+OrojLXZuJRtul8+779tkfXmGzmDPSfNuhhkR2ylXYgKEjBE4CHbZqivTr1o4f
	rJAeAQMwKb6XfQI3oM8jO8afQHlI2Nb92fuWjd47XqE3D+euN4m6aiyLUCKMAW2kxk8OA40Tp87Fh
	GI+FLjHaH1+G/qBfnxg+o5ZBELtkIKdT+fDQstoW0gOhsq5Ck2WUqwyJtczibGvgrHa+O0Fy7Yyqk
	wR1cyNIlA1N+K1rY9Igf2QJQ;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe7t-000kiV-0n;
	Mon, 25 Aug 2025 20:49:14 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 045/142] smb: client: remove unused smbd_connection->protocol
Date: Mon, 25 Aug 2025 22:40:06 +0200
Message-ID: <6ee43343a299728f5328858774dcc57e09a5a045.1756139607.git.metze@samba.org>
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

There is only one protocol version for smbdirect yet and
this variable is write only.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/cifs_debug.c | 5 +++--
 fs/smb/client/smbdirect.c  | 1 -
 fs/smb/client/smbdirect.h  | 2 --
 3 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 9dadf04508ac..8f1ad9cb6208 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -24,6 +24,7 @@
 #endif
 #ifdef CONFIG_CIFS_SMB_DIRECT
 #include "smbdirect.h"
+#include "../common/smbdirect/smbdirect_pdu.h"
 #endif
 #include "cifs_swn.h"
 #include "cached_dir.h"
@@ -442,8 +443,8 @@ static int cifs_debug_data_proc_show(struct seq_file *m, void *v)
 
 		seq_printf(m, "\nSMBDirect (in hex) protocol version: %x "
 			"transport status: %x",
-			server->smbd_conn->protocol,
-			server->smbd_conn->socket.status);
+			SMBDIRECT_V1,
+			sc->status);
 		seq_printf(m, "\nConn receive_credit_max: %x "
 			"send_credit_target: %x max_send_size: %x",
 			sp->recv_credit_max,
diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 450e43f1fe39..68450489c5d1 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -454,7 +454,6 @@ static bool process_negotiation_response(
 			le16_to_cpu(packet->negotiated_version));
 		return false;
 	}
-	info->protocol = le16_to_cpu(packet->negotiated_version);
 
 	if (packet->credits_requested == 0) {
 		log_rdma_event(ERR, "error: credits_requested==0\n");
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 0197a9da294e..3963fd27d8b6 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -39,8 +39,6 @@ extern int smbd_receive_credit_max;
 struct smbd_connection {
 	struct smbdirect_socket socket;
 
-	/* dynamic connection parameters defined in [MS-SMBD] 3.1.1.1 */
-	int protocol;
 
 	/* Memory registrations */
 	/* Maximum number of pages in a single RDMA write/read on this connection */
-- 
2.43.0

