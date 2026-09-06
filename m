Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408EB37EFF1;
	Sun,  6 Sep 2026 20:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788725122; cv=none; b=BTBVXBibH+LB8l6cS72CzVrYz8o/ERN4FNWFdxp3BGJz06scA+V0Tx3PktuqSL4Kj9nad5TwxcfMvp3ug5j6lvZ1YbflSTxtz/edFjguZDGawTn388+tWHdrqcBGZ8epAMzZX/hhz2IR3VdPoEygN6YQC5zfjtv2U/3bjQNFS10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788725122; c=relaxed/simple;
	bh=CuOfq29GHSL7J1rMSDxUvXdVhTfxsIfUgIIyHcbPabU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WA5YQP9nXeXJ4HnzTOHCWqwWwJLqm+5jnjSoQhqX9Z1vyR/wUij46wpVwP3Nr4C6cOEP3LfZOVJOF9Eho+zJkQbwWkbqViNzjyz+t4EeCE0VCrIDk3X0Z6h+BD9cI1tinpFSeDygLnfW6aP64E5wCmcPO7BCOL1C9kw1iciHxJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=1ibHsuCd; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="1ibHsuCd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=I7NZrM35UZux0818kfvOJ2WKMxMF7t8Ua1jgHeqc1jQ=; b=1ibHsuCdI9t9+svW4Dv1/u/AcP
	sZQo+FKgDV3VjbQcEfCmmvHzCJc9AgoWiLm3nrj6MHK6s2Y7BbnAIN08gaS8Kzm5i1ZiPab/yxk5k
	sod4BDv0oTcv/L8X/iLDS5oAQeI/vVzyjnA9xQ+QL8clXJJO04CBDcTELKSAGmleOA6DozBovcstA
	Oo6V3cjGyWKJTFax24BYG1CRP0zTuwsFPnoVeB918CfMhJjSzpko6PH+gbaxxayDLfKD1d77uoFf6
	h/eR2cCER29QAs6k9RV0BjEyCB5quj7w9GgNOlV8reqHqqbYm/qYGaV/BmFxLkD6CZy7ilhUbdg7z
	wIyN9WSA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3J79-00000000oEm-270F;
	Sun, 06 Sep 2026 17:05:19 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 7/7] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Sun,  6 Sep 2026 17:05:17 -0300
Message-ID: <20260906200517.725015-7-pc@manguebit.org>
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
has type bits set (e.g. S_IFREG | S_IFLNK == S_IFDIR | S_IFREG).

Clear S_IFMT before setting S_IFLNK for native and SMB1 symlinks.

Closes: https://sashiko.dev/#/patchset/20260906181540.647469-1-pc%40manguebit.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
---
 fs/smb/client/reparse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 616ca2dbfac4..b6bded042e78 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1280,6 +1280,7 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 		break;
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		break;
 	default:
-- 
2.55.0

