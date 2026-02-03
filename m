Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27F12EFD9E
	for <linux-cifs@vger.kernel.org>; Tue,  3 Feb 2026 15:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133985; cv=none; b=s6+bG8mEekQRhSmCF7tCYpUYyp2SBSAJFxnk9rcp7gbWMNbmuS0QphOXduuvH3y3TpTWQpIVm/hIUCeadQp5n+Jvd0aFtO/uHZ0Bea0QeFrWEcbSslJMTG5WuRsC/VCLFQCmH3GpoMIVNRc0xGyQxjuV0JZVPe/vrTf8m6Rvy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133985; c=relaxed/simple;
	bh=MUp/7vT+AF4hmriQSVHrTJx9y8qtdpo+kty+1xU0uxk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eRWXiBIjIMdzm3HRGXRprIQKcgeGfPHWkW7Btl2iWK+wwNjk6vQ9Y+pVFipuyI1qJgoDq+esHyGazJANeo6ST1GZ8/FdhNtPfiKhM8uFOO0OjHI8cY0hhOZLyAnCh/czPl8agrwltW0/P7V7UIzmPefSqAovKJ3MbSt9JTTiQ7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=gq9Uehfm; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="gq9Uehfm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=23soFuUb7ZEVk+va3gDlAlSDWsuLJO3hLNoB1wHn9oE=; b=gq9UehfmEVGYfbIy0FUxz85/bo
	ALaGht+RfZQzYGF80hiufVurvqbGP6yCPPZOQddjR5vz/k7AVUDpDmBKlpxxdmh7gAq5XPKJcwyE0
	9bVPirErYHGcw0lUFe1CTeBAPFHA15smp1ItlEdQBFVHPOn7NhjJcZcyVlM0tcI8HCv9pUf/zi/TZ
	pz8BpnmCMn149kGZvAErpfqAjx/hGsWU16gKCOkAfPb9KF/wL79lAL+/8XtQMcAaD9ofOYfU/37MZ
	rdhbvwsrJPsV1xwBYN6jT+xq8eO1WlecJIDxJtPoutAdV5wdLn3Fqikh0gwQGCCmU+8l9+PFGQEpp
	/gQQ5xrXZOyqIoE1IXT0AY+aRU51ZmkoMtfynDmEXYP1NLKXs4OrGXdM9JFUu36Dm4Rbd94veWxPP
	6wksHvk+tpc1i3/kO4knHX/RDZCVoLr960TlwwP8hDETm2LYsu1Y6z/vuuq6k/fCNkiK8Q8jNa7fe
	b3xS7q3sFecGHzjf3kRKtEZa;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vnICS-00000003y35-3JF0;
	Tue, 03 Feb 2026 15:20:21 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] smb: common: add header guards to fs/smb/common/smb2status.h
Date: Tue,  3 Feb 2026 16:20:12 +0100
Message-ID: <20260203152012.914137-1-metze@samba.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will allow it to be included multiple times without problems,
that's needed for the smbdirect move to common code.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smb2status.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/common/smb2status.h b/fs/smb/common/smb2status.h
index 3b86dbf8c369..b6421bc5113c 100644
--- a/fs/smb/common/smb2status.h
+++ b/fs/smb/common/smb2status.h
@@ -9,6 +9,9 @@
  *
  */
 
+#ifndef FS_SMB_COMMON_SMB2STATUS_H
+#define FS_SMB_COMMON_SMB2STATUS_H
+
 /*
  *  0 1 2 3 4 5 6 7 8 9 0 A B C D E F 0 1 2 3 4 5 6 7 8 9 A B C D E F
  *  SEV C N <-------Facility--------> <------Error Status Code------>
@@ -1782,3 +1785,5 @@ struct ntstatus {
 #define STATUS_IPSEC_CLEAR_TEXT_DROP		cpu_to_le32(0xC0360007) // -EIO
 /* See MS-SMB2 3.3.5.4 */
 #define STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP cpu_to_le32(0xC05D0000) // -EIO
+
+#endif /* FS_SMB_COMMON_SMB2STATUS_H */
-- 
2.43.0

