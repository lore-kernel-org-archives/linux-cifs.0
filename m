Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C1D190056;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734879572; cv=none; b=KkvmVITlT6Wc/+x7smtapio07/TRc+BA1ztJ6BYZd3DF9UWRElp1to9FOYA1dpBCG4HW68VLwCdMV1Phw2V+qtj0u6LXF5ES0F5FSsLUWsR/wzk2+mmsy68wB7tbQhOioXTyb2FaCH7bfslMTQsYXt2nIpk5paXMKS2V9aYgbBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734879572; c=relaxed/simple;
	bh=Mt3mMGOeqdUffvUI0ZUvssJNk1SNS0DX0vOeDCD/sc0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KHLoQWvB7DEniRiqfpy4NzOVOnu7hvv9YlN4a1rJPcD6TZf8qZOaBAOQPPVC7dWiT8ePFSqKN5+jcipRyOaqQioQG1oSZqVVtzPhhto1qqNEkKgHXyGvCIszrK/XACf4m7Q/tLJiMDIt7JTFpOj1u31Fs7VN4H8CaCOYWCs6r+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l30EOYrH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l30EOYrH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA1DC4CEDC;
	Sun, 22 Dec 2024 14:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734879571;
	bh=Mt3mMGOeqdUffvUI0ZUvssJNk1SNS0DX0vOeDCD/sc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l30EOYrHTH17EtOfCSZ26zt687CL4ZIZhNJllwrUKZd+XWSR4Yi6yZsRxauF6yj9o
	 pPehiXdfIIpW9wo11/NCF+8ZCSKhnLtVrkIxsHWTYXGKdHpO742b/zSMSvMfHD7e2P
	 sLruDUBbtaIWOD2fg7cXC3yCcgjEIIMDgL15OgRIwM1ChQjtPV/k/f9QN9AUWaw2Rw
	 gTq/cpKMPce9Pik+01Wvpdv5D0CHTe0pW1mqsgJrTnMz7pDtndC8nK02JwZn/o6TFS
	 9AnbtOaB54a3Lpeqn04JjnuAIogCko1t/3329c2i4YTekq77w1lKLE0aIBjgDOB+qv
	 ir0jMk93NbmlA==
Received: by pali.im (Postfix)
	id DE8B7D48; Sun, 22 Dec 2024 15:59:21 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] cifs: Remove explicit handling of IO_REPARSE_TAG_MOUNT_POINT in inode.c
Date: Sun, 22 Dec 2024 15:58:44 +0100
Message-Id: <20241222145845.23801-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222145845.23801-1-pali@kernel.org>
References: <20241222145845.23801-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

IO_REPARSE_TAG_MOUNT_POINT is just a specific case of directory Name
Surrogate reparse point. As reparse_info_to_fattr() already handles all
directory Name Surrogate reparse point (done by the previous change),
there is no need to have explicit case for IO_REPARSE_TAG_MOUNT_POINT.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index b26403e6fc2c..ed32d78971f8 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1203,10 +1203,6 @@ static int reparse_info_to_fattr(struct cifs_open_info_data *data,
 			goto out;
 		}
 		break;
-	case IO_REPARSE_TAG_MOUNT_POINT:
-		cifs_create_junction_fattr(fattr, sb);
-		rc = 0;
-		goto out;
 	default:
 		/* Check for cached reparse point data */
 		if (data->symlink_target || data->reparse.buf) {
-- 
2.20.1

