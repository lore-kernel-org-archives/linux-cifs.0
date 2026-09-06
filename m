Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD8535F16B;
	Sun,  6 Sep 2026 20:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788725122; cv=none; b=jq3GHnoO68QgWuS3wZqr+/MXw87H2+Zzl7PkNMrLtJwZDnIKIJIg53pIz9w9fdAnneqozf7W7gsa5O4aC9xk2Z6uSO7jsVNNazb/5IFvc1n7tYai/nduyn0dqrb1yKL23MqQ3SgOp8D45Msn74IVRY6HK3Zu0ocri3vJKKVE5ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788725122; c=relaxed/simple;
	bh=D/SO8TBOoR2z/COcsEOIxV4xPs6hjtLGuJhDoBa+AeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fb6apSdpT2uU9ZJrA/cvybjpnxDA0N7AVa6oWJlzYdU/HD4OoE+hSHoqTGDfy7+zMqKaSTCT+cSxAkTGuoc5d3K0+DlT/VmnGltXAaTpf7iILV5vTexucUaxPrFVMtkQvfYi+xjxkvIMtj2IH1tsck4VMk3u2rnThSyz4p1I/5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=2FBE26+l; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="2FBE26+l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=o2WukhDdkYtGlc48GAzq+UFpmndQUxFTNErGqoKBLMQ=; b=2FBE26+lcgWOKOXaBJLkz8f2E3
	T3DMF0nP8mfjHsXrCjTnCvp/P3bJ1rDC5QnijxyOFObUOL/SnEoinT0D2Qreni1vEh/CL1tlorMgo
	EsY7dPvEKV0qLwaJjNtfEKW9GUoLhVcaC8XIniIYYlsDgHAuZVcOaLVBMkkAPOp3Tc3zR3mSr+WJa
	n6UgAzZYfchFG1lAU5ZPOI85CMRa3jTZIRWapEukl+WSl5bUMoDEBCKcGjYyd6nFnTr7JeHeORVhZ
	I55anyf0Tk7QwEn6VupepkYViVr4vJ5x6H+7dMtPd0zyzeUBdOAmKKgGuTSTuNXvbS/ZqC7/gY/k7
	uk0dTTiw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3J79-00000000oEb-0gPT;
	Sun, 06 Sep 2026 17:05:19 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 6/7] smb: client: fix file type corruption in posix_reparse_to_fattr()
Date: Sun,  6 Sep 2026 17:05:16 -0300
Message-ID: <20260906200517.725015-6-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260906200517.725015-1-pc@manguebit.org>
References: <20260906200517.725015-1-pc@manguebit.org>
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
index 8a19dee564b8..616ca2dbfac4 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1212,6 +1212,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 				   struct cifs_open_info_data *data)
 {
 	struct reparse_nfs_data_buffer *buf = (struct reparse_nfs_data_buffer *)data->reparse.buf;
+	umode_t ftype;
 
 	if (buf == NULL)
 		return true;
@@ -1227,7 +1228,7 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
 			WARN_ON_ONCE(1);
 			return false;
 		}
-		fattr->cf_mode |= S_IFCHR;
+		ftype = S_IFCHR;
 		fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 		break;
 	case NFS_SPECFILE_BLK:
@@ -1235,22 +1236,23 @@ static bool posix_reparse_to_fattr(struct cifs_sb_info *cifs_sb,
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

