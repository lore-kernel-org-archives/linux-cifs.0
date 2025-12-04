Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9921036C5A2
	for <linux-cifs@vger.kernel.org>; Thu,  4 Dec 2025 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764871595; cv=none; b=GgeDm4gsK0YMIthlKsEbm4lT42O2RHtYo/aedIIPlrw9D3t7dYMIlZ7sC+KfMoaDD5Wf/VPK58XDdEfqAJjSQ11+1VVx19UtyoabzHmAznoG3tlURnPoJWk5B5FbN3LI0zlKWHbo4tg02QN9PpY9Ot2bfkQeg/gUcXkI2sGu3YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764871595; c=relaxed/simple;
	bh=xqvzQ2x5DYDGOHIFPsmK/RCVTnEOdk8ea+8nq55xgjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnH8OhDCaIG/iHtXL6I65z9hJk/jlcD1+ushiopLwAMSJvoF5jB/prI333IlVOq2phfKZDn3iovsvMJBS9MPRMtTxRpgkBG0dF50EdplG5mOTa4laCuQybtFbcK1xFk7NhpSve+sejMsNuzZ6XX/lP5tsSTvQPY75jaLp+VPzjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=B7472bbB; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="B7472bbB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=uECrD5oxA154R1fanGj6CDqqDGvu0PmN7uCO1zSKF9s=; b=B7472bbBKikys+HjotAhHuqMCO
	ueGCzIkD7jURRfB+M40B2CUTziIZkUhEjMaT843+WhpSFWJcGuHZMH0D25rX/T1tIhvB1YaRnh2a5
	XaCSxxcnLHq3TAlxHfX0j/QejLXxM19415wa6LEetuv8+dz8XelieFCZ0f9KTUe4vQl/7DtVsCJtw
	nqzMc6pz4EWYSWeX6PcDSGImh77hxld0+QICrYnvfuTkAgAfIQY50BESnNMyznQepNbm+gpVKk5n/
	KkHn5Rlgw8+6J2uFYAqeTQH2C1+MlJ7IP3x0kCUnKnkweYCnc3SAOPTZ+eWd9Ef640ekuvzk7Hruu
	ydeI4qyg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vRDik-00000000Dfl-18y4;
	Thu, 04 Dec 2025 15:06:26 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: "Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Pierguido Lambri <plambri@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 2/3] smb: client: improve error message when creating SMB session
Date: Thu,  4 Dec 2025 15:06:24 -0300
Message-ID: <20251204180626.244415-2-pc@manguebit.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251204180626.244415-1-pc@manguebit.org>
References: <20251204180626.244415-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When failing to create a new SMB session with 'sec=krb5' for example,
the following error message isn't very useful

	CIFS: VFS: \\srv Send error in SessSetup = -126

Improve it by printing the following instead on dmesg

	CIFS: VFS: \\srv failed to create a new SMB session with Kerberos: -126

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Pierguido Lambri <plambri@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/connect.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 3838dd14d4da..bc28e21340e7 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -4238,8 +4238,10 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	struct sockaddr_in6 *addr6 = (struct sockaddr_in6 *)&pserver->dstaddr;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&pserver->dstaddr;
 	bool is_binding = false;
+	bool new_ses;
 
 	spin_lock(&ses->ses_lock);
+	new_ses = ses->ses_status == SES_NEW;
 	cifs_dbg(FYI, "%s: channel connect bitmap: 0x%lx\n",
 		 __func__, ses->chans_need_reconnect);
 
@@ -4325,7 +4327,10 @@ cifs_setup_session(const unsigned int xid, struct cifs_ses *ses,
 	}
 
 	if (rc) {
-		cifs_server_dbg(VFS, "Send error in SessSetup = %d\n", rc);
+		if (new_ses) {
+			cifs_server_dbg(VFS, "failed to create a new SMB session with %s: %d\n",
+					get_security_type_str(ses->sectype), rc);
+		}
 		spin_lock(&ses->ses_lock);
 		if (ses->ses_status == SES_IN_SETUP)
 			ses->ses_status = SES_NEED_RECON;
-- 
2.52.0

