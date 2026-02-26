Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85DB843CEC4
	for <linux-cifs@vger.kernel.org>; Thu, 26 Feb 2026 21:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772141405; cv=none; b=CmfjNm2CNbHzkQGZf+VfecFlo46XAny7gM5GxayPqfy5FyQr/dGtrcnHaXmRKohva4l01BaZmnkki7nmjbbPBPvYe4fkrqVdBbGZfvvUJfcPLAW6IuiFRUnbgQf4lbhdwG+iRjuQw4wgeG2SglsDUlNmcd2laUM0E9hExweeSLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772141405; c=relaxed/simple;
	bh=QRhkc2uP4bcM/LsatLWRGGTQ+sviFI9ge5Ts/pHpRGM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hBzorpz578b4Gj2JFsWFK/4y9TmeEITR6BBO1yTQLPaRG9+b5gS01Mn8gEcN1SbBkVu5c9iDHXQWa5RloJC9z6LwGInAcFQr3FNzN/nw7pdTkqH8mLhS4GVLB/b1owoYnB6+JUe894+rdbc7Fx7QeHd3fpWAVSTfBQzWMqACBqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=H32EvuyO; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="H32EvuyO"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772141401;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yA2lI/2C+h5S4XfL+NjFfiE7eFsCkQ61mJturdSOo3k=;
	b=H32EvuyOIig0mkZAMRT3EofA/29NLMI5sHQlNC52zBlbXZo5Pz28I7dXIjDSZ/5WTsy/ND
	kLTGwfaZFF/HfdargXr72QhTTlkTEoo74nsv3ozxYbsT/HwiRGQ2j2vACd8itOOxrzjhJv
	Jl/kMGoPxlPB4Uf0jhVn+ZPs2ZEGm3w=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Jeff Layton <jlayton@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	stable@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: Don't log plaintext credentials in cifs_set_cifscreds
Date: Thu, 26 Feb 2026 22:28:45 +0100
Message-ID: <20260226212845.784172-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When debug logging is enabled, cifs_set_cifscreds() logs the key
payload and exposes the plaintext username and password. Remove the
debug log to avoid exposing credentials.

Fixes: 8a8798a5ff90 ("cifs: fetch credentials out of keyring for non-krb5 auth multiuser mounts")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/smb/client/connect.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 33dfe116ca52..038f87062419 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2236,7 +2236,6 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx, struct cifs_ses *ses)
 	/* find first : in payload */
 	payload = upayload->data;
 	delim = strnchr(payload, upayload->datalen, ':');
-	cifs_dbg(FYI, "payload=%s\n", payload);
 	if (!delim) {
 		cifs_dbg(FYI, "Unable to find ':' in payload (datalen=%d)\n",
 			 upayload->datalen);
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

