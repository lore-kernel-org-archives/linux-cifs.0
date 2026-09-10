Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E7858B6A8;
	Thu, 10 Sep 2026 18:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789065712; cv=none; b=TKggy+noglKWw5NapX7rF15mwCvVZqpIJWETn1rCccmhc3c453V9fo5tTIzT2PhRv9VwpPoispNe+SyeAr1KI7rE6jggV6KQ/l3B0mVAcHeFLR64fcas9HqZxJWdTiTF2I2HVQT/y1S6f1CXOq1W6p/webOxcVHAK88XwolrV2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789065712; c=relaxed/simple;
	bh=PZdK3L16QgUBQ0xLmf1s4QdiHWJ4Vf+7u/ZFogFYMGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S0+j62B6onuJveAl7ABYUtP8Kcy/fjKWbRnabYOcQc0vyc6CBeBRRcSRtz/xTm6Sdz0DXFc3+by+2Pu6jI2TpW0A9ssa05vqXqWSNDa08MJ9/PnUzwzCHPJx8RGmtguSpPCfHmG2ygZeZE18V6Fw3518FLylodwxW2qozIOihzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=KgvnrfHY; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="KgvnrfHY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0nOuKVnTAcBRd9oosJmEm2gPVlmW/NvmFy1eYa3dlkQ=; b=KgvnrfHYEJwhAYvKhbiHdzbF33
	OarfsrFRPzlDJ0LU9q84daMHKCT3zZs8iquSnmOLtYfiSy2QrUuQslC0V5cg0mkgKLJw2Esgkvnms
	oYguj1/o7Wba/NlWvL+Kt0HJl2H8gvuvuFnIYqiCzY1nR07haTOKU/HE7tIV766FnVC/WeRHvSX2t
	orX1xICkat+Vksb11fLDdbQBMT5pcy5Kc0EpxGCy5UuN/19SMgm5QD/dpJ4VtVL82MWKDz710xB9K
	qc6h12fRZJvdArOMI7mzS+gwO54BhrEJcfNTEmXZqsqcak6+Hj3GdR88bLdH5q+54LNIH7JuOnLN4
	EYvQPfWA==;
Received: from [151.115.150.205] (port=34186 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x4jiU-0000000FTPh-0MZA;
	Thu, 10 Sep 2026 20:41:43 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] smb: client: validate absolute native symlink targets before NT fixups
Date: Thu, 10 Sep 2026 18:37:43 +0000
Message-ID: <20260910183742.4029092-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

With symlinkroot unset, an absolute target is copied without conversion
to an NT drive path. Later code still assumes an NT prefix is present
when modifying the target and calculating the print name length.

For "/ab", this causes two failures: sym[5] and path[5] are written
past their allocations, and plen -= 2 * poff subtracts an assumed
8-byte prefix from a 6-byte UTF-16 target, wrapping u16 plen to 65534.
That underflow causes another overflow: memcpy() copies 65534 bytes
into a 24-byte buffer. A user with write access to a mounted share
can trigger these bugs with default settings.

Validate the NT drive prefix, including an ASCII drive letter, before
accessing fixed offsets or subtracting the prefix length.

Fixes: 3363da82e02f ("smb: client: fix native SMB symlink traversal")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/smb/client/reparse.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 5cc5b04..acd5f51 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2024 Paulo Alcantara <pc@manguebit.com>
  */
 
+#include <linux/ctype.h>
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/slab.h>
@@ -159,15 +160,24 @@ static int create_native_symlink(const unsigned int xid, struct inode *inode,
 		convert_delimiter(sym, sep);
 
 	/*
-	 * For absolute NT symlinks it is required to pass also leading
-	 * backslash and to not mangle NT object prefix "\\??\\" and not to
-	 * mangle colon in drive letter. But cifs_convert_path_to_utf16()
-	 * removes leading backslash and replaces '?' and ':'. So temporary
-	 * mask these characters in NT object prefix by '_' and then change
-	 * them back.
+	 * Absolute NT symlinks must retain the leading backslash, "\\??\\"
+	 * prefix and drive-letter colon. cifs_convert_path_to_utf16() strips
+	 * the leading backslash and maps '?' and ':', so temporarily mask
+	 * these characters with '_' and restore them after conversion.
+	 *
+	 * When symlinkroot is unset, sym comes directly from the caller.
+	 * Validate the complete "\\??\\X:" prefix before using fixed offsets
+	 * or subtracting the NT prefix length below. Require an ASCII drive
+	 * letter so the prefix occupies six characters in UTF-16 too.
 	 */
-	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/')
+	if (!(sbflags & CIFS_MOUNT_POSIX_PATHS) && symname[0] == '/') {
+		if (!strstarts(sym, "\\??\\") || !isascii(sym[4]) ||
+		    !isalpha(sym[4]) || sym[5] != ':') {
+			rc = -EINVAL;
+			goto out;
+		}
 		sym[0] = sym[1] = sym[2] = sym[5] = '_';
+	}
 
 	/*
 	 * On a POSIX paths mount the symlink target is stored verbatim, so
-- 
2.47.3

