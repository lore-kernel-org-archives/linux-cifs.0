Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B48F25BF1B;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643795; cv=none; b=rQQeygHRvkjfQerUMxSU14c2PdYXzbNQNAiEQGjB9meKYM8ScxY0gMrQsAZn/kH+4h7NPCSCIx64ivX9xaQH7hv+Uv1pIecPLAPfLRPe07e+DhqH+jX4OAcJASOEpxV6H4i3fxh9yeDUw9tWCdaGM46XJXm+92duN1/rKOsSj34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643795; c=relaxed/simple;
	bh=2yaxe8JvAoaujWsh6C/ntd9QE+7VcZOUC9n6I84/Phs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8HZAeot1Mzb3721NViRPyGMVjQTUzDOo8yEMPPmPEYGcU5Wyh7IodHkrc03o1N1lxYytmu7S04+S2Cyqrdn/ijj+InR85vESQ+tLhD1Pq0VH0qeI/j3izOt0K74P0U2ctl0hFCr2OVqMCMB4R5mq9U7QD3K3cu6c/wyLjGspsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iJlIgbxW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iJlIgbxW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B29C4CEF6;
	Sun, 31 Aug 2025 12:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643795;
	bh=2yaxe8JvAoaujWsh6C/ntd9QE+7VcZOUC9n6I84/Phs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJlIgbxWuvAvhorbe5j+m5xZR80aeqoHXvlZr9qahtFtPGiqNFdnvds9m2LoMbl8H
	 AAINj0tJptOQ1ZFKD6SrnEODpYzCDze8aLKwXARKPfYG/yCSSmm3x0WsWwQsG+YbwJ
	 GoFP5ZaXl+cN/Q3PCm1orsjKTS70y+/3kY5swmp/+eF0N24BeP07aL20v7OjsD/zzZ
	 myymSa00xEg/Q80A6+moVKfQ4e1Vjz3nQPsE84YpF+CSqnvlKRTkl7ZaucIcIrjorU
	 R0ZvpmlC3LRPjkLjdUO7YmoHlXQ2EXiTkaYdHiEjwp0cm9cKyP8hF05pX1K5SfbTIt
	 YO9zQuavWjeDA==
Received: by pali.im (Postfix)
	id 1B937D70; Sun, 31 Aug 2025 14:36:31 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/35] cifs: Allow fallback code in smb_set_file_info() also for directories
Date: Sun, 31 Aug 2025 14:35:29 +0200
Message-Id: <20250831123602.14037-3-pali@kernel.org>
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

On NT systems, it is possible to do SMB open call also for directories.
Open argument CREATE_NOT_DIR disallows opening directories. So in fallback
code path in smb_set_file_info() remove CREATE_NOT_DIR restriction to allow
it also for directories.

Similar fallback is implemented also in CIFSSMBSetPathInfoFB() function and
this function already allows to call operation for directories.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 1772f30419a9..cc4feebbdd11 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -980,7 +980,7 @@ smb_set_file_info(struct inode *inode, const char *full_path,
 		.tcon = tcon,
 		.cifs_sb = cifs_sb,
 		.desired_access = SYNCHRONIZE | FILE_WRITE_ATTRIBUTES,
-		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_DIR),
+		.create_options = cifs_create_options(cifs_sb, 0),
 		.disposition = FILE_OPEN,
 		.path = full_path,
 		.fid = &fid,
-- 
2.20.1

