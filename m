Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5893C4169;
	Sun,  6 Sep 2026 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788721689; cv=none; b=cz3JHCKY5NpTYYpsFWAwjm1MrBFyJHu2zGDvU6oJyEkuZuYXvp4FYQ16vETj7nlAsqzyA346127wrfLfjkrmxcSssfwP99aMwugBPeURJz4DylGft8LhHFc8h0C1bGu2xwSRJCFpR64NwlQYG0zZVI5+XhW9TyAJB3oOlR0nA+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788721689; c=relaxed/simple;
	bh=n3c7JhvHoiNfSTX0K8RT1zsad1kYMD3Xfp2SqDT3VfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGrW7QY1q+W6LoLyV9PdPQxS37ev8gpMpIyCOpoRVXsrAkI007LcKkpB5c4xEkkXAaTTuLfDFblsegVpMOHFHv1gfjkmp/bkaKBdOqFT/L2XSg8vTB25WE7uDH2oyQlGuiXwEsSgQd2ZpmMWPTXSGu8E98XH1t5ESZd1mOR5Uxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=11Kidtwx; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="11Kidtwx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=ehgJfgvqBechyUTpyhRJyiAFboFpzv1o49gZ9yHM5aU=; b=11KidtwxrwNdBs9wAJx9DUg2af
	QuAE36B94dr9TIbS5x8XhxqhBtuFhlAmwd7VBbdT/l7tIYwNOv1SdkBxslxl82ouNq08libowhQ0B
	XWUsC5N9N8oGa1qP3Rw79eX2r0Lh0oJDPICR2LFV0ZmilLGuPhqzKf42DL3vq0jLzjniQGBmZmNs3
	Vin8QNCsL0hiaStv8OWKYSAxEl/pxqkhkWF8G9YJKrgSD57NU/iNZ6TI9pdup3t0hsnbP9znfqh7y
	91QGgpEK1qo9xMiunwGx4SNQeT77VS88qdI1svGXj4uLUK5ZuCRmNok5Dy/UulDUohvI+Hce0PMuU
	DbqQG7LA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x3IDm-00000000o6f-00Sg;
	Sun, 06 Sep 2026 16:08:06 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 7/7] smb: client: fix file type corruption in cifs_reparse_point_to_fattr()
Date: Sun,  6 Sep 2026 16:08:03 -0300
Message-ID: <20260906190803.667489-7-pc@manguebit.org>
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
index b44dbeca2419..5a5211fd639c 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -1294,6 +1294,7 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 		break;
 	case 0: /* SMB1 symlink */
 	case IO_REPARSE_TAG_SYMLINK:
+		fattr->cf_mode &= ~S_IFMT;
 		fattr->cf_mode |= S_IFLNK;
 		break;
 	default:
-- 
2.55.0

