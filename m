Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71ACA1A9FAF;
	Mon, 16 Mar 2026 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773685163; cv=none; b=qQcYgfWOTnoX3qdEovLf7Adx9e+J0U8Q7nGT/pzHueN0NfTM5az3f2QL9f589cSNn6yiwfs5dqXfjqEwucCQkrIWVYOPH5tl4qo7LytsZW2E8WC8i5Y2F+bagHdk7fFvsOBY9f9NEmGEltCygeFr/VHD4/36iPI2kKOA+ZCcrbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773685163; c=relaxed/simple;
	bh=/RKm1pe/7/30yQ7cGABfn61O9sXuFpst/XREeqi9Rsg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FBViZFAfdLNQXa1bUPZTi1bnSwTQXo5fIW43P+41IJa/DaCLgUaus2EYF/g2omIv5Z6NwY7jtQFMMPzNnrrhZUlmKjn994ozVOBdHoaAGacblEGNqsE2HtLquMAvDbZc8wFSfZhfdPhMEfL23GUukm4bd+jvAh+06V2GI6kv31E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13F5C19421;
	Mon, 16 Mar 2026 18:19:22 +0000 (UTC)
From: Joseph Salisbury <joseph.salisbury@oracle.com>
To: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: smb1: fix comment typo
Date: Mon, 16 Mar 2026 14:19:21 -0400
Message-ID: <20260316181921.151493-1-joseph.salisbury@oracle.com>
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

Fixes: 282432612aa7 ("cifs: SMB1 split: Move some SMB1 received PDU checking bits to smb1transport.c")
Cc: stable@vger.kernel.org
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

