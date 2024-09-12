Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA721A3040;
	Thu, 12 Sep 2024 12:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726142761; cv=none; b=RirQ6bf/SRbtWc/ofrbfDbD9qsVIlOVo4Orxa5jjDVODAMzzzHp14aAXtE2VFO9+iLKIGeqdwoBx6daH3gQnLYQ/Rum4egy6S/9dD1++sYgTt5lQewv01ueOAHCqi1JxoaHXtq/mFtiZU84Gveqv1syq/7pDvpRf8G+aoWn9v+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726142761; c=relaxed/simple;
	bh=+uNJ9eLwhQVbYHW30+NUBpqazhheNtp4DLIS254FP3s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/a0Qmi0oK5ubmZr8AwdDwyukgt2XIDh/THMudlIgr7FNFPS6/pYLMXONzrG3UsmyuTc6TPCMm1hIL2yzt8222tk5iOY+vm/6yZd7SsfSl3HA++NgCeDVQpCwcXWtDjkVoQb5KZp49oCpho4UH2LmEmqCEJJvc9P66AcsE30ByQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZesqTLJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZesqTLJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69EFC4CECD;
	Thu, 12 Sep 2024 12:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726142761;
	bh=+uNJ9eLwhQVbYHW30+NUBpqazhheNtp4DLIS254FP3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZesqTLJ+riVA9kTs5RfICgK1X4tslpnA9nUCNYL1OP0/NhjFTsC4sjfHUPUajPQ1a
	 Eyvx9FHsQpNu2/X9+i9aNOGdbbhWfJu9NpxDOdqCoydW3tBl22pNx+igsgty0/CYgd
	 KVias7Li1zaJo6nhHpRL0TND3Xx7ObIvDY/mqtNQ94EdCgNiLU7L/mCoGUDtOryU5e
	 vd9ZiEXrmukl1QEk6XV7+xb5+NPZXFXBddNjr7j8LhIX8hKxH+AF6m8DAkcN2BR9ux
	 CyJVQ30hbDSANYd8qtZEIi+3UrmnBjMroq8TEEd2ca/CDGqLGbU3djbNY2ESy4TMqS
	 xanDPzLe499PA==
Received: by pali.im (Postfix)
	id A69F0C46; Thu, 12 Sep 2024 14:05:55 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] cifs: Recognize SFU socket type
Date: Thu, 12 Sep 2024 14:05:46 +0200
Message-Id: <20240912120548.15877-6-pali@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912120548.15877-1-pali@kernel.org>
References: <20240912120548.15877-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU since its (first) version 3.0 supports AF_LOCAL sockets and stores them
on filesytem as system file with one zero byte. Add support for detecting
this SFU socket type into cifs_sfu_type() function.

With this change cifs_sfu_type() would correctly detect all special file
types created by SFU: fifo, socket, symlink, block and char.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 70c32b40ede0..331a86074ae7 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -545,7 +545,7 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 		fattr->cf_mode |= S_IFIFO;
 		fattr->cf_dtype = DT_FIFO;
 		return 0;
-	} else if (fattr->cf_eof < 8) {
+	} else if (fattr->cf_eof > 1 && fattr->cf_eof < 8) {
 		fattr->cf_mode |= S_IFREG;
 		fattr->cf_dtype = DT_REG;
 		return -EINVAL;	 /* EOPNOTSUPP? */
@@ -655,6 +655,10 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 			fattr->cf_dtype = DT_REG;
 			rc = -EOPNOTSUPP;
 		}
+	} else if ((rc == 0) && (bytes_read == 1) && (pbuf[0] == '\0')) {
+		cifs_dbg(FYI, "Socket\n");
+		fattr->cf_mode |= S_IFSOCK;
+		fattr->cf_dtype = DT_SOCK;
 	} else {
 		fattr->cf_mode |= S_IFREG; /* then it is a file */
 		fattr->cf_dtype = DT_REG;
-- 
2.20.1

