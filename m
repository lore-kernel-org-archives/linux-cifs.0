Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F99826B2CE;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=lc6yui3MF8wXwRNZfjeFcVHIRNIPLXja0U7flIBnVLz8MMz91rYMN3jqEulHtJnO+1pb9Fs84O/e9s0oRU+OIPSRcaEG2e5UaWIDYM+4Lhp9OQC8iXD2uK/XTEybPfph+isNyKXkNcvYCV+MElTykptgVhZwLn4SCyLzgSBw3BY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=hOE+inZuHZaLIQCHjscJllPWfxWi/52CVw/HvGIY4Ek=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B36PpX05E9LWehGUcI43IgZfoiWFmaz21qcsO3meKcBkE5fdbQHd+DVm9xLMtKphLSAdP7zc2pr3RNiwhR4CyM5eCfASQetSE+QqbZEWxIqunEh+fKws/dfEcQjZwXU45Y78vfRh0oCxMDcmBlXL2XH3RqIb1rI/bczB6ZzTwQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YOKqoz04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YOKqoz04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E78C4CEFC;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=hOE+inZuHZaLIQCHjscJllPWfxWi/52CVw/HvGIY4Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOKqoz041/IhI6ZjPYvY3Fx8W7DB/sCLuLhBamA5ihjZ+K/NPkE4bsrf9J7sAE61b
	 /CkDxMmEJqCzgRnqCfomIVxN4kxXOyiVjAR7645vJpZ5y/gWYgVprVGs8+rh3FzA91
	 Sz8yYtlyLKgDUM6LNrZmTUsnRqKJDGgtsCgPC5TszvtUAHAYg1BrY01vrT1LOsYMRO
	 xWeamE4+Fx6LIsudGnTj/4nOeDgYls1NFQvLkSwXUT/npm++p+OhuI82/YRFk5m2qa
	 FM8x/3ar4sTW90xOHC3IyNZIEkX+LSf1nMnYlisv8GlfdwMzALnNUUMEdZ0gFku4oy
	 quci1DWzdBIaw==
Received: by pali.im (Postfix)
	id 7984013DE; Sun, 31 Aug 2025 14:36:37 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 33/35] cifs: Add a new open flag CREATE_OPTION_EXCLUSIVE to open with deny all shared reservation
Date: Sun, 31 Aug 2025 14:36:00 +0200
Message-Id: <20250831123602.14037-34-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is just an internal flag for cifs.ko code, not exported to userspace.
It allows cifs.ko code to take an exclusive open with deny all shared
reservation. It is going to be used by the upcoming fixes for the unlink()
and rmdir() silly rename support.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifspdu.h |  1 +
 fs/smb/client/cifssmb.c | 12 ++++++++++--
 fs/smb/client/smb2pdu.c |  6 +++++-
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
index cb1f99d22dd7..90b0b82e23b1 100644
--- a/fs/smb/client/cifspdu.h
+++ b/fs/smb/client/cifspdu.h
@@ -395,6 +395,7 @@
 #define CREATE_OPTIONS_MASK     0x007FFFFF
 #define CREATE_OPTION_READONLY	0x10000000
 #define CREATE_OPTION_SPECIAL   0x20000000   /* system. NB not sent over wire */
+#define CREATE_OPTION_EXCLUSIVE 0x40000000   /* exclusive open, NB not set over wire */
 
 /* ImpersonationLevel flags */
 #define SECURITY_ANONYMOUS      0
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 3a0452479a69..37bc0541bc21 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1125,7 +1125,11 @@ SMBLegacyOpen(const unsigned int xid, struct cifs_tcon *tcon,
 		pSMB->OpenFlags |= cpu_to_le16(REQ_MORE_INFO);
 
 	pSMB->Mode = cpu_to_le16(access_flags_to_smbopen_mode(access_flags));
-	pSMB->Mode |= cpu_to_le16(SMBOPEN_DENY_NONE);
+
+	if (create_options & CREATE_OPTION_EXCLUSIVE)
+		pSMB->Mode |= cpu_to_le16(SMBOPEN_DENY_ALL);
+	else
+		pSMB->Mode |= cpu_to_le16(SMBOPEN_DENY_NONE);
 
 	if (create_options & CREATE_WRITE_THROUGH)
 		pSMB->Mode |= cpu_to_le16(SMBOPEN_WRITE_THROUGH);
@@ -1281,7 +1285,11 @@ CIFS_open(const unsigned int xid, struct cifs_open_parms *oparms, int *oplock,
 	if (create_options & CREATE_OPTION_READONLY)
 		req->FileAttributes |= cpu_to_le32(ATTR_READONLY);
 
-	req->ShareAccess = cpu_to_le32(FILE_SHARE_ALL);
+	if (create_options & CREATE_OPTION_EXCLUSIVE)
+		req->ShareAccess = cpu_to_le32(FILE_NO_SHARE);
+	else
+		req->ShareAccess = cpu_to_le32(FILE_SHARE_ALL);
+
 	req->CreateDisposition = cpu_to_le32(disposition);
 	req->CreateOptions = cpu_to_le32(create_options & CREATE_OPTIONS_MASK);
 
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index a6c69b01ec6b..8315213d699e 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3034,7 +3034,11 @@ SMB2_open_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	req->DesiredAccess = cpu_to_le32(oparms->desired_access);
 	/* File attributes ignored on open (used in create though) */
 	req->FileAttributes = cpu_to_le32(file_attributes);
-	req->ShareAccess = FILE_SHARE_ALL_LE;
+
+	if (oparms->create_options & CREATE_OPTION_EXCLUSIVE)
+		req->ShareAccess = cpu_to_le32(FILE_NO_SHARE);
+	else
+		req->ShareAccess = cpu_to_le32(FILE_SHARE_ALL);
 
 	req->CreateDisposition = cpu_to_le32(oparms->disposition);
 	req->CreateOptions = cpu_to_le32(oparms->create_options & CREATE_OPTIONS_MASK);
-- 
2.20.1

