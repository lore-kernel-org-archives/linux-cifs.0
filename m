Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C959E1FB3;
	Fri, 27 Dec 2024 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735321153; cv=none; b=MyA5Kq5C39r2kuqrRBqak4owJGESpbMuIRhNlT9N2u6JZ+Uf2Etb6sQepmMz+bgZWoLU8Dx89q6gIIZ5agfQMXl0hijHPMdZ/YSsedoQnefAKlnqvxslzwu6SF6cKAOd8VXxNfBAX7Jaxh7izzbpGQMoEWrPP2RFHPFWotswXag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735321153; c=relaxed/simple;
	bh=4KVOZna8Jhv7HiSZht1rqhXUxaXIYIXVZiZliXFd4Fg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ifS4kHp/MQb9/xiqvYhQboKQzu9sTpHQT+NzOSs7gyeATutKvdWYk/9sCLDIGNOdtsBzaZv8P56dNj9Wbg64v1I96NfhZut2Fd5/Ybiy7+MnKDZJhJhlk2rllCzKOLk8+YTaCJ0EwjJi6O+/QmfaQdkIU1GCwM2RbX+b08aThdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhPmTPFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhPmTPFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCEEC4CED3;
	Fri, 27 Dec 2024 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735321153;
	bh=4KVOZna8Jhv7HiSZht1rqhXUxaXIYIXVZiZliXFd4Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhPmTPFERUCe82DZQWiHD0sFgKyBFkZ1LzvdeHmR6RGrukLpRiCUPYDTuIhFHZiDf
	 NoQoN5O3BrybXaW3QtvoJO5N6LtRWqR7NMr6j/7B8Akuo2v/aGZoaScnIcRHkqWbcK
	 maZMzntM0OU0Iqit0OThvKo2iH9d05o6a6a+wlHASEocpEl9ifZWDFM0XxrqHLNtUU
	 STxtjIeIsPXUvId35tSfrchlJcJJaxuE9E0G002CzWgoltuU6UdSALQ5EmGlUZX/QD
	 ouGejQL36eriG8/JhLHfaI6/nKdloBMCjp6SXSj7nutL+rOOaRsMNszdAsSMjjQm17
	 IdgsgU31mMI0A==
Received: by pali.im (Postfix)
	id 30705A7C; Fri, 27 Dec 2024 18:39:04 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] cifs: Simplify reparse point check in cifs_query_path_info() function
Date: Fri, 27 Dec 2024 18:38:39 +0100
Message-Id: <20241227173841.22949-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241227173841.22949-1-pali@kernel.org>
References: <20241227173841.22949-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

For checking if path is reparse point and setting data->reparse_point
member, it is enough to check if ATTR_REPARSE is present.

It is not required to call CIFS_open() without OPEN_REPARSE_POINT and
checking for -EOPNOTSUPP error code.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 26 +-------------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 73d4cc1534ff..3af3f64b0cba 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -564,32 +564,8 @@ static int cifs_query_path_info(const unsigned int xid,
 	}
 
 	if (!rc) {
-		int tmprc;
-		int oplock = 0;
-		struct cifs_fid fid;
-		struct cifs_open_parms oparms;
-
 		move_cifs_info_to_smb2(&data->fi, &fi);
-
-		if (!(le32_to_cpu(fi.Attributes) & ATTR_REPARSE))
-			return 0;
-
-		oparms = (struct cifs_open_parms) {
-			.tcon = tcon,
-			.cifs_sb = cifs_sb,
-			.desired_access = FILE_READ_ATTRIBUTES,
-			.create_options = cifs_create_options(cifs_sb, 0),
-			.disposition = FILE_OPEN,
-			.path = full_path,
-			.fid = &fid,
-		};
-
-		/* Need to check if this is a symbolic link or not */
-		tmprc = CIFS_open(xid, &oparms, &oplock, NULL);
-		if (tmprc == -EOPNOTSUPP)
-			data->reparse_point = true;
-		else if (tmprc == 0)
-			CIFSSMBClose(xid, tcon, fid.netfid);
+		data->reparse_point = le32_to_cpu(fi.Attributes) & ATTR_REPARSE;
 	}
 
 	return rc;
-- 
2.20.1

