Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54BC1917FB;
	Tue, 17 Mar 2026 01:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773710030; cv=none; b=YvhsZ742gIZVpQeXva3br9WN41WgI2Ybk3GZ+r9E7g1WfGenrEIiy6u3kEqZF/CUAsML5SvHnRe+xslNItCxn1ZGG3FOGFZjVza9HzAK+AX5YpBYSpyp8Iuvcw2gLxc9cLETA2Oait2RSRADE0/NOYnvm3fclgJY/0RLEfyQiFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773710030; c=relaxed/simple;
	bh=sQHKSixXDvqzfVUHAmt6v/LCg7mDkiZLxGdyMGizT60=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aUO+q6FzHZbI7vkDm4PYPfIhbiuDwK8ILUrN1j6DMuXoRR+OSi+xOUWmBKFtWJd8psjshTk2MTnKDf7SQsnBEGXuwsKh7dfi7neR4+UwtLuirG+FH/dW3VIufdvOVHiSMjjra5yhQdu1sd8ssniQdo4I20ttlRB8btXEREEfHak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECDCC19421;
	Tue, 17 Mar 2026 01:13:50 +0000 (UTC)
From: Joseph Salisbury <joseph.salisbury@oracle.com>
To: Steve French <sfrench@samba.org>
Cc: smfrench@gmail.com,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] cifs: smb1: fix comment typo
Date: Mon, 16 Mar 2026 21:13:49 -0400
Message-ID: <20260317011349.15702-1-joseph.salisbury@oracle.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The file contains a spelling error in a source comment (resposne).

Typos in comments reduce readability and make text searches less reliable
for developers and maintainers.

Replace 'resposne' with 'response' in the affected comment. This is a
comment-only cleanup and does not change behavior.

[v2: Removed Fixes: and Cc: to stable tags.]

Signed-off-by: Joseph Salisbury <joseph.salisbury@oracle.com>
---
 fs/smb/client/smb1transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb1transport.c b/fs/smb/client/smb1transport.c
index 38d6d5538b96..53abb29fe71b 100644
--- a/fs/smb/client/smb1transport.c
+++ b/fs/smb/client/smb1transport.c
@@ -460,7 +460,7 @@ check_smb_hdr(struct smb_hdr *smb)
 		return 0;
 
 	/*
-	 * Windows NT server returns error resposne (e.g. STATUS_DELETE_PENDING
+	 * Windows NT server returns error response (e.g. STATUS_DELETE_PENDING
 	 * or STATUS_OBJECT_NAME_NOT_FOUND or ERRDOS/ERRbadfile or any other)
 	 * for some TRANS2 requests without the RESPONSE flag set in header.
 	 */
-- 
2.47.3

