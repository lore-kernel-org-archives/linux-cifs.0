Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12C729CB2A
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 17:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754501787; cv=none; b=snN7NlcoXeOXGdZMt6ciO073vV1Zq8ZWQNzPk2mt7KFjxT/DT/QO4K/K/UANmwhrKB553C9omxR1g1rMxuof4rp2zuuf9PLeQJXNBqpsxNrm8GdDXPc8AnM55KovdkxHzAayAH3JwJZc/4obWbXvN3a5HDZHksztt39nGeUDFQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754501787; c=relaxed/simple;
	bh=PgczmnR4YadyjxOqTYtg7mDE9yPjgpQOivJ8STNu+rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejGAAutInpHRLYl/DOLAhAHqNBPgT3+sHMbym32hzs+ATut4qt0zLRSenpcljwILsOdCkgJHjgTT1i3SSqENwPK9Szi3FgLluYgyS+O0aMK0dKPMRrGxc/J4Q5G2H5H/6UHZwPJ37k+qPCLhrHyLF4+glrQekG84MB2itRnQuQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=fSy7bkl/; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fSy7bkl/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=3Xh0XxQgw+1/sCdwmmCbDEz41xc3QfXDqGMzKOA3EFU=; b=fSy7bkl/xafKM6u/cceCsiiUMU
	jBFbgerzvd4eTiMtjAbqoj9+pph/BXhr9YiPNEVAA8O6rT61SQYHB58TFs7YbN9nVfRVg4p9swDmG
	NY1sDrTtv5lp+g7CdUpBxeWVLBdzr1nk2d8emnbf+H11OF578K+9nFJpJ63rMQ2jwrzDoW58ESTQ0
	Xcmg3bLLQAfd8Ez8qlTx1b/WwDaWqxd3EsrFfXTkteAyZtCgt5YCecW27GvQSo/7cLDzMCAPUkyP6
	ahQ42kiuFbcNxfnd+mSyyj5jBtVegh2eE1gBcyZ1acOWjDwpEuMlhT0bPYaTUlK6aIOpUzY77WY57
	HGo3qEuqkoWPF39dH4YmWQAOuawh9TstSZDBMJl0q6LvJEPzHTPvWopVwtWBI8IzNGYRck1BXpM99
	WW4n4SiuBuwrUfQOV1EX0MzJzmrtf59Rz2zFN3Bk9rKoDzMYT/eC5l2/sWVIw5odZB54jS4b7I3FW
	1Rl8QqF530quMUQOAM79H97k;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1uji3r-001OWu-28;
	Wed, 06 Aug 2025 17:36:23 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>
Subject: [PATCH 01/18] smb: client: remove unused enum smbd_connection_status
Date: Wed,  6 Aug 2025 19:35:47 +0200
Message-ID: <5a513c72a3ccbb3bd493b42d1912d5288693c165.1754501401.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754501401.git.metze@samba.org>
References: <cover.1754501401.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/fs/smb/client/smbdirect.h b/fs/smb/client/smbdirect.h
index 9df434f6bb8c..0463fde1bf26 100644
--- a/fs/smb/client/smbdirect.h
+++ b/fs/smb/client/smbdirect.h
@@ -33,16 +33,6 @@ enum keep_alive_status {
 	KEEP_ALIVE_SENT,
 };
 
-enum smbd_connection_status {
-	SMBD_CREATED,
-	SMBD_CONNECTING,
-	SMBD_CONNECTED,
-	SMBD_NEGOTIATE_FAILED,
-	SMBD_DISCONNECTING,
-	SMBD_DISCONNECTED,
-	SMBD_DESTROYED
-};
-
 /*
  * The context for the SMBDirect transport
  * Everything related to the transport is here. It has several logical parts
-- 
2.43.0

