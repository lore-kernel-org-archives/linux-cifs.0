Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293EF223DFB
	for <linux-cifs@vger.kernel.org>; Mon, 25 Aug 2025 20:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756154920; cv=none; b=JDxAFFpvxDWK20zNSEWBlF/ut1FwB+18DSQURVXISmGPLat+qpW+DHhj/ItjW5AciNavgNxTm2529y2/MnBYOkFyGbNvBPjRAM9FPhKIAce5kQPJn2ibtsp3z55+OpX47GuVPXOsTqF3ODXUGNK5OuRtFdoz56W2m04CGKPiMZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756154920; c=relaxed/simple;
	bh=bSdheOXYC5c6xN5PpZduLsjAp36UNnzQVdUSDdBH9R4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZIG7ZLWv1tK9yXdWrSm4TyIL0JiNXZu2WrkFpnE6K8lCkd7P+voT6FDe3XXEv5J4J4luFt8/UwRG3Gv23fYYdXTnyr2tjIrlBhjFz3FaTdCweoAgvRRr4yazZHXv4+m3O69HSmWLh/OGTjoj9amffUGKJD1vOLVQ2XWa6+y95o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=g0CWH6PY; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="g0CWH6PY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=Z5k2Kw0euVkw9CxnDvatgv5FUhJ5Qh5dxNWrPuY0hIk=; b=g0CWH6PY0nBSqhRGq/eQyNcEBT
	ONZiGI33soX0z/A+xHNkW3ddKp03RBWTDRtCzvPaz/9JIzifn7P7rUtGHwADbroZERWNIofWBipgj
	NcgnouP+DsMMQi/ODK7FKSk/bfOqlRhAKhLxTOqTOidSaWa6jrut2e50JCPzi9nswaJ0DE9HJ+eO6
	HWdgF7IFTCAR1IbX41YeELazCB7UK+RxSZaPWeHnak8l9CNAI/OFBWjwXEeQrwbuemp7p2ST6m3oX
	BBlZacdOfWYbAxRExG1K6TylUlGxJejHauhQjJ3WT7cwzVx0j3u7FDScpT6mXPZBzKtHg0+ASlthn
	PlIm3o2MdI6cT+2vKEbIJM70b0Ha6tLLKK3+mIk8tpNQ0G+X7hX0hlRezqBvJLH3HhxvAyMN9NI9Y
	u5ykISv5gEuP7PLg7saPA90F/uX2VKEge1+m6Ju2W/w9+eSr8k6EuiOcDCuRHFLuZf5F813Qb6TpN
	TPQpXJZkyVZfWCC/w0klm4w2;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uqe7H-000kaW-1k;
	Mon, 25 Aug 2025 20:48:35 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH v4 041/142] smb: client: make use of smbdirect_socket.rdma.legacy_iwarp
Date: Mon, 25 Aug 2025 22:40:02 +0200
Message-ID: <a79fe2e93bf4a4763c3c8fa55c576bd48296c1d8.1756139607.git.metze@samba.org>
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

Currently it's write only for the client, but it will likely be use
for debugging later.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 2 +-
 fs/smb/client/smbdirect.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index e6c54255192f..ab1f5050e616 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -298,7 +298,7 @@ static int smbd_conn_upcall(
 				ird32 = min_t(u32, ird32, U8_MAX);
 				ord32 = min_t(u32, ord32, U8_MAX);
 
-				info->legacy_iwarp = true;
+				sc->rdma.legacy_iwarp = true;
 				peer_initiator_depth = (u8)ird32;
 				peer_responder_resources = (u8)ord32;
 			}
diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index b973943acea3..f5f4188ad7cd 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -50,8 +50,6 @@ struct smbd_connection {
 	int protocol;
 
 	/* Memory registrations */
-	/* Maximum number of RDMA read/write outstanding on this connection */
-	bool legacy_iwarp;
 	/* Maximum number of pages in a single RDMA write/read on this connection */
 	int max_frmr_depth;
 	/*
-- 
2.43.0

