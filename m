Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8C929C328;
	Mon, 14 Sep 2026 01:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789348259; cv=none; b=Bbyzca+GcGJeuPx2/4HwvsfHr5omO3U9ePcTFJUENhbgaYk9u2r60p1DL4v9lhLhkakOi9AcImGpRnYUxedBp0EstJLjxReTfN13JEZVRuTB6Sz5s9VpDcSTZmrN9gzVWfOPvVFlz/0dE+8Pf9Xf+PggDvfdb1jzbbvovVTvhzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789348259; c=relaxed/simple;
	bh=jrcwDqeKcslLy0gewRqc0EyxiRzZ5MeKWtELDoxkAPk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AcR4opwWyOYkJ/VN4pYzSSnvgvEbqSnu30cS8uzLSwCaNTTpaU+I35GIo7rXdE0x3Dk+kLb58cQW2n/e1sUHhX4740aodOl48pEq+jpZZ76VIhXKjKJ1LuucSwNK1uS2AWrbs2SKOVvVS+r2mV/HM2GwWPJQnr7VMSwzxN2BMxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=RVbJzdTv; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="RVbJzdTv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=7TMSi8bDaIuaMinTPgLFLBojsuPK3icRj6kV51egN2A=; b=RVbJzdTvLmvzsqsR4uS0lRsFRC
	nVmSaj7L4Ibl38sGTnhnFmlI+UmHHGBpRA7z9xfTUSLHfbT8hdPe1mIKT0/BpwlCx+Dtc03yQfOWI
	9twxIn9guNoOWhuOp5D6ZX6PZoSuViLxQDOLZUpfke1C8gQjemnZQnInNB+X41duls1/vjh/bSTz4
	PV0OPj8stXAJJ0D4Szo7eiXzyqiZJayDE2jlbThrZlbzFfpVUR1ZfmeA7w5UEds1XjdrdX4mWTQ+l
	EfSX2VaYlxAUS9Xa6MUGjrFkWMdNFrbTs+6DYwcrqyTXJ82U+dZ2j2n+6flCi5oGCK2obDEr38hrO
	QxcGNBpQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x5vDg-00000001M8C-3ikA;
	Sun, 13 Sep 2026 22:10:52 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Tom Talpey <tom@talpey.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] smb: client: fix unaligned access in WSL reparse point parser
Date: Sun, 13 Sep 2026 22:10:51 -0300
Message-ID: <20260914011052.809774-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When wsl_to_fattr() parses WSL extended attributes, it computes a
payload pointer from ea->ea_data + ea_name_length + 1.  Since the
smb2_file_full_ea_info struct is __packed and all WSL xattr names are
6 bytes long, the value pointer always lands at an odd byte offset,
never satisfying __le32 or __le64 alignment requirements.

The code then casts this pointer to __le32 * or __le64 * and
dereferences it directly, which may cause alignment faults on some
architectures.

Replace all such casts with get_unaligned_le32() and
get_unaligned_le64() in reparse_mkdev(), wsl_make_kuid(),
wsl_make_kgid() and wsl_to_fattr().

Closes: https://sashiko.dev/#/patchset/20260906200517.725015-1-pc%40manguebit.org
Fixes: 78e26bec4d6d ("smb: client: parse uid, gid, mode and dev from WSL reparse points")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 4 ++--
 fs/smb/client/reparse.h | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 9e31fce7e0a5..6ac69f4d391a 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1201,9 +1201,9 @@ static bool wsl_to_fattr(struct cifs_open_info_data *data,
 				fattr->cf_gid = wsl_make_kgid(cifs_sb, v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen)) {
 			/* File type in reparse point tag and in xattr mode must match. */
-			if (S_DT(fattr->cf_mode) != S_DT(le32_to_cpu(*(__le32 *)v)))
+			if (S_DT(fattr->cf_mode) != S_DT(get_unaligned_le32(v)))
 				return false;
-			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
+			fattr->cf_mode = (umode_t)get_unaligned_le32(v);
 		} else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen)) {
 			fattr->cf_rdev = reparse_mkdev(v);
 			have_xattr_dev = true;
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 49efd85b1e94..05b2cecb4495 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -9,6 +9,7 @@
 #include <linux/fs.h>
 #include <linux/stat.h>
 #include <linux/uidgid.h>
+#include <linux/unaligned.h>
 #include "fs_context.h"
 #include "cifsglob.h"
 #include "../common/smbfsctl.h"
@@ -23,7 +24,7 @@
 
 static inline dev_t reparse_mkdev(void *ptr)
 {
-	u64 v = le64_to_cpu(*(__le64 *)ptr);
+	u64 v = get_unaligned_le64(ptr);
 
 	return MKDEV(v & 0xffffffff, v >> 32);
 }
@@ -31,7 +32,7 @@ static inline dev_t reparse_mkdev(void *ptr)
 static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 uid = le32_to_cpu(*(__le32 *)ptr);
+	u32 uid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_UID)
 		return cifs_sb->ctx->linux_uid;
@@ -41,7 +42,7 @@ static inline kuid_t wsl_make_kuid(struct cifs_sb_info *cifs_sb,
 static inline kgid_t wsl_make_kgid(struct cifs_sb_info *cifs_sb,
 				   void *ptr)
 {
-	u32 gid = le32_to_cpu(*(__le32 *)ptr);
+	u32 gid = get_unaligned_le32(ptr);
 
 	if (cifs_sb_flags(cifs_sb) & CIFS_MOUNT_OVERR_GID)
 		return cifs_sb->ctx->linux_gid;
-- 
2.55.0

