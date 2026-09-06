Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A99B3C2795;
	Sun,  6 Sep 2026 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788721689; cv=none; b=n3Z2pvYNuR7gP+JtM9a4hNZ1c1DaIbBy5f0WxNYaOwons+THK+OLVnrZ8jaaypQlaazCZdivlr4kKtMjMuoY62hJbCe/5NjgWzgHzwoev8t4U4RW8lBAoHmvnF4NpVyLAKZW4VOg7MIrAX5vCEr2pHzMdPLlAVxWy9bXM+GN/zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788721689; c=relaxed/simple;
	bh=8p/pvuBdz8hLcfPkBFrT0AXtzEC5AWMym8QstiVyErI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYe3Xo3RNwEJcajGN2bSJtmUEXkWCgGFUu6LInX3zzpw+jeYUQ6yUfFN7DgzmJXVN7oeci4oXt+iFL6RaKLefew8EDMExnPA8DtJ9K1WKSfnoWe3AgUYTjAdsrGUuKzZ+QC168wAdj0SapMGa+u/CVwFmjLGAsquA8U04BNJG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=e96bLIhi; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="e96bLIhi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=3WH7nRAfbHRujv4ox4AtnWJDSBFjBJDaLxf0Vfyw5NE=; b=e96bLIhiH6me8lirxf/wyoTTgM
	koKmHTSzj8XTF+Od2m7FiYeO5hH/CtCtr2KZ6W3kbXLe/Kbqa08zWyF4r9hk2chKXizaWS3J8P6rr
	ZEN/qeRq3qSvdeRuffWfN6OpRazCUwAFqq+oaNk+9AQHGkzWNgnp2zihO9K2rEK/Uz+LM6RfBUmDG
	FTOklLp1bsGsYLcldBJAHeatfMhV0yk6l1Aa5kudG2mdBX2vb1HBD9OIxCF5ocg94qyJr0W5bPfot
	vblFaPNcPjjM36Bf8DzHAMgSdbBIy9IXzpGUgFGxU+QaL91ConPNS3emDsFG9PirSHvV4v6c+A25Q
	1QN/J42Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3IDl-00000000o6T-2mZz;
	Sun, 06 Sep 2026 16:08:05 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 6/7] smb: client: fix file type corruption in posix_reparse_to_fattr()
Date: Sun,  6 Sep 2026 16:08:02 -0300
Message-ID: <20260906190803.667489-6-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906190803.667489-1-pc@manguebit.org>
References: <20260906190803.667489-1-pc@manguebit.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setting the file type in cf_mode without clearing the existing S_IFMT
bits first is wrong as it corrupts the file type when cf_mode already
has type bits set (e.g. S_IFREG | S_IFCHR == S_IFLNK).

Use a local ftype variable to collect the new file type and apply it
after validation succeeds, clearing S_IFMT and setting the new type in
a single assignment.  This avoids stripping cf_mode on malformed
reparse points where the function returns false early.

Closes: https://sashiko.dev/#/patchset/20260906172005.627163-1-pc%40manguebit.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 9edc379bd686..b44dbeca2419 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1226,6 +1226,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_open_info_data *data)
 {
 	struct reparse_nfs_data_buffer *buf = (struct reparse_nfs_data_buffer *)data->reparse.buf;
+	umode_t ftype;
 
 	if (buf == NULL)
 		return true;
@@ -1241,7 +1242,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFCHR;
+		ftype = S_IFCHR;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_BLK:
@@ -1249,22 +1250,23 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFBLK;
+		ftype = S_IFBLK;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_FIFO:
-		fattr->cf_mode |= S_IFIFO;
+		ftype = S_IFIFO;
 		break;
 	case NFS_SPECFILE_SOCK:
-		fattr->cf_mode |= S_IFSOCK;
+		ftype = S_IFSOCK;
 		break;
 	case NFS_SPECFILE_LNK:
-		fattr->cf_mode |= S_IFLNK;
+		ftype = S_IFLNK;
 		break;
 	default:
 		WARN_ON_ONCE(1);
 		return false;
 	}
+	fattr->cf_mode = (fattr->cf_mode & ~S_IFMT) | ftype;
 	return true;
 }
 
-- 
2.55.0

