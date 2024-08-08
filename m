Received: from mail.nfschina.com (unknown [42.101.60.195])
	by smtp.subspace.kernel.org (Postfix) with SMTP id 9D8A9156220;
	Thu,  8 Aug 2024 12:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=42.101.60.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723119859; cv=none; b=Ssl2k7tBD6/Ot4tJlIvBcEb3yxrOhanCY/X/MORSyCI0j3wNhbADUIXP9z2udlax6pddw8USIBuFxUiR1OrLVgeb9QAl/VVmr63JsmAKGB/g8B8FeurUEDQEWwA1F0A7LDQ4xcTW1ixd9PkuQysY3p9/FRy/gkYZmBLMzyc4hv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723119859; c=relaxed/simple;
	bh=SXys11+xLoBsHco0MZl/A5tIPMtTS+9EsXL6IR3Hvxk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=rieHxcu8WFJ5cQD5DSkuLIe7dwPqlcYeDF+jFDSzLiSITxqu/5bKh3Dk/mFMEbPmBwpZFKUHik+gY7mywcbONNf3t0FO1vLkLDHndNnakSjNjJIlZCOxmAWRgWyGtdRsZhL9P4+viNqHnUO+Ph2zPGsS+ErjfMBGCcRQ3F9yOas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com; spf=pass smtp.mailfrom=nfschina.com; arc=none smtp.client-ip=42.101.60.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nfschina.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nfschina.com
Received: from localhost.localdomain (unknown [180.167.10.98])
	by mail.nfschina.com (MailData Gateway V2.8.8) with ESMTPSA id C603B60C7B26D;
	Thu,  8 Aug 2024 20:23:45 +0800 (CST)
X-MD-Sfrom: suhui@nfschina.com
X-MD-SrcIP: 180.167.10.98
From: Su Hui <suhui@nfschina.com>
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	nathan@kernel.org,
	ndesaulniers@google.com,
	morbo@google.com,
	justinstitt@google.com
Cc: Su Hui <suhui@nfschina.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] smb/client: avoid possible NULL dereference in cifs_free_subrequest()
Date: Thu,  8 Aug 2024 20:23:32 +0800
Message-Id: <20240808122331.342473-1-suhui@nfschina.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang static checker (scan-build) warning:
	cifsglob.h:line 890, column 3
	Access to field 'ops' results in a dereference of a null pointer.

Commit 519be989717c ("cifs: Add a tracepoint to track credits involved in
R/W requests") adds a check for 'rdata->server', and let clang throw this
warning about NULL dereference.

When 'rdata->credits.value != 0 && rdata->server == NULL' happens,
add_credits_and_wake_if() will call rdata->server->ops->add_credits().
This will cause NULL dereference problem. Add a check for 'rdata->server'
to avoid NULL dereference.

Signed-off-by: Su Hui <suhui@nfschina.com>
---
 fs/smb/client/file.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index b2405dd4d4d4..45459af5044d 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -315,7 +315,7 @@ static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
 #endif
 	}
 
-	if (rdata->credits.value != 0)
+	if (rdata->credits.value != 0) {
 		trace_smb3_rw_credits(rdata->rreq->debug_id,
 				      rdata->subreq.debug_index,
 				      rdata->credits.value,
@@ -323,8 +323,12 @@ static void cifs_free_subrequest(struct netfs_io_subrequest *subreq)
 				      rdata->server ? rdata->server->in_flight : 0,
 				      -rdata->credits.value,
 				      cifs_trace_rw_credits_free_subreq);
+		if (rdata->server)
+			add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
+		else
+			rdata->credits.value = 0;
+	}
 
-	add_credits_and_wake_if(rdata->server, &rdata->credits, 0);
 	if (rdata->have_xid)
 		free_xid(rdata->xid);
 }
-- 
2.30.2

