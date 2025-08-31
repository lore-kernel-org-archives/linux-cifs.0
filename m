Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5309826A091;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643798; cv=none; b=QhMJr+jIS5Z7sP9wBGwRR/Dik14wUgIsHqAzVM58wN+ly65UhNnmvJR2ZjLxBT6lrG+Pi2YhmCrcI1p4FSvbH940tbmA1jAW3axbHu2txL0c4LqOfIJJbfn/2eyXdPzCYo59HsTPQ7+e75D6sodXbNz1LxmXESTQyoCyqbf2Fes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643798; c=relaxed/simple;
	bh=DTHD+PYP2YbpdTJYB1bY7oWsK3TejRcfICiywAvse/Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rPZO/3XhUQSGAX3Nk+7TvejW9O2WJNSyhCXkcsGqscuTXKMVc+ng2FipXQepcw+41ut33CegRlsRJYYywzASABnNwN89HdG41rffCBpMIo+NiPk5USNVYgJxIhBdL4NQFrPVuXSIkMXTDKPL9J6ckNJzM1U88EB0ASuEVpI0B/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eqZ8sO2C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eqZ8sO2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173D7C4CEF8;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643798;
	bh=DTHD+PYP2YbpdTJYB1bY7oWsK3TejRcfICiywAvse/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqZ8sO2CLpxMSPo2ISNZtZaco5esZQ4MW2P+k7lvzzfJLs6vBOzPQUv+09IarRJVa
	 VgO2QCZ++JQDa0fb46KGR6Ub9VopMzA5BtpV8y6PBDayfUzXlrjTqgHa+01aymFYUT
	 fOPVrk5Sf1eWZByRf0iSjTllfa2BraLovGM9BTxD4OPLRxXZ32ppF346GGD/xNSF/Y
	 mRMWXC9Ute9K0ZZ6LQ6QCobtLmCKNQSVkAjhVvZDNA1ZRZ+pVfoEEOJTRnXox8J2Ji
	 CHN5vv2mjaJn4odBocokUkldzZ98mIXPjwENNjh0AjoQIcycTGk0/YdNFtJS1x7g93
	 LbZkfefgFYU1A==
Received: by pali.im (Postfix)
	id 89D07129B; Sun, 31 Aug 2025 14:36:36 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 28/35] cifs: Fix smb2_unlink() to fail on directory
Date: Sun, 31 Aug 2025 14:35:55 +0200
Message-Id: <20250831123602.14037-29-pali@kernel.org>
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

unlink() should fail on the directory with ENOTDIR error code.
Flag CREATE_NOT_DIR handles that.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c8b0e9b2438f..c69293fcf26c 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1348,7 +1348,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 
 	oparms = CIFS_OPARMS(cifs_sb, tcon, name,
 			     DELETE, FILE_OPEN,
-			     CREATE_DELETE_ON_CLOSE | OPEN_REPARSE_POINT,
+			     CREATE_DELETE_ON_CLOSE | CREATE_NOT_DIR | OPEN_REPARSE_POINT,
 			     ACL_NO_MODE);
 	int rc = smb2_compound_op(xid, tcon, cifs_sb, name, &oparms,
 				  NULL, &(int){SMB2_OP_DELETE}, 1,
-- 
2.20.1

