Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DD5156F39;
	Sat,  5 Oct 2024 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728144582; cv=none; b=fPkNQC4iR3wijlV/rthLLP1YLYcnj7Dd+9U8VTH3E5R5biJ5R4EbgxzsR6L5Lo3SWaAqF1s4+XCOlEtHKxnbsW23QgKdrOD8Z64Wneh4aSxcxAA/moD6e/s6S9VR4ml8z7wZUnBtVMafveP7woZrFC7HVpbGIBGfeDlFMd78bFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728144582; c=relaxed/simple;
	bh=NRQbjrs02yuBo6LF0N1x9j2WMN8jkY4nPTEoyqfzyrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AfHWnYvt05LCD0OYbEx9wdXKNcdnSyjoXr1E/khHxGY2PGfYrIxdlkxZmevgv8OZqwIzMZ4UNHpIn2r8iHFPisCUl3knxc14hU0uTj37XBqc7ycKxv8fLr7nJJPPIWNYSKh9selkJwIHkL4k8NtkctXNwMNUZV/BVYi3okEZf9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dPKJEguj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dPKJEguj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA174C4CEC2;
	Sat,  5 Oct 2024 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728144582;
	bh=NRQbjrs02yuBo6LF0N1x9j2WMN8jkY4nPTEoyqfzyrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dPKJEgujTaw/EdFkdgqtdXAccI0ep8oo1KY3lnhQ91LGr7XlJDHRWomPfiwghCwOr
	 mcifnZUtwj27Deixm/cUPeVs+nAFEx3Bo9bWRQ0MD3K2LNShcWeQL5bfJyMXlbHNME
	 cm6ytMvMu2vHtg644BcniVJsdyZgkScqdG+XJ4SYj1sCw4I/cCIWiRqMZW/oFjKTwl
	 A2rtXn8WF7G1jMZZTqNKCbQIJV2kF5h6WyZib6d04es8rhHM3CqgkuUlEip+7bYqcu
	 inb56zM+d7vfBrOOIeijBwFyDfdhA27+RhOntliUwRl7Ii+QxWmtYUru0duusuVXBe
	 KcPcvoP9PxUTQ==
Received: by pali.im (Postfix)
	id 1D86E9DA; Sat,  5 Oct 2024 18:09:36 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cifs: Do not issue SMB2 CREATE always with FILE_READ_ATTRIBUTES
Date: Sat,  5 Oct 2024 18:08:25 +0200
Message-Id: <20241005160826.20825-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005160826.20825-1-pali@kernel.org>
References: <20241005160826.20825-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Not all SMB2 operations require FILE_READ_ATTRIBUTES access and therefore
do not automatically request for FILE_READ_ATTRIBUTES access in every one
SMB2 CREATE command.

This change allows to complete WRITE operation to a file when it does not
grant FILE_READ_ATTRIBUTES permission and its parent directory does not
grant READ_DATA permission (parent directory READ_DATA is implicit grant of
child FILE_READ_ATTRIBUTES permission).

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2file.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 149449d9c1c0..faa634ce4d54 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -162,7 +162,6 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms, __u32
 	if (smb2_path == NULL)
 		return -ENOMEM;
 
-	oparms->desired_access |= FILE_READ_ATTRIBUTES;
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
 	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
-- 
2.20.1

