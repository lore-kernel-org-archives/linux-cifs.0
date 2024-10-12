Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C953145B0F;
	Sat, 12 Oct 2024 08:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728723375; cv=none; b=de+MPy0Hvm3xIqDa9ew4OYA1/a+oc6EtTrC8mEBGqHzm75VE8pqgefPELD9dYB8MZxRmWL0I2Rae21VG5p6Hw0v3egPfhxp8i4xAnkFHM0ulTGNQIzTTE8OwUQMmXFrlkZyJllbxr9HCszZUELipXuDBrnThlsFzW6gVsr9GPKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728723375; c=relaxed/simple;
	bh=4Mvi152HGg7NjVSCBeQbBdl7JzN17DrdnTby1FxDoXA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jK7p3FiL4MtmckAlH+1nx6qXuxBsrWd/jP3oSyF1GYrm9T8pJhgiTvha/xLe4J9yk2rh4QwjutcpHnpYU2yiDNzMWrPym9Jidg5FxG8thY4eQyiOXXkO+ebC/ZZynKDzP6FigZbQTqUHIU/QFax1QoZP7tamwoeZ8oDFTRnU+tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oedPwe3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oedPwe3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F18C4CEC6;
	Sat, 12 Oct 2024 08:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728723374;
	bh=4Mvi152HGg7NjVSCBeQbBdl7JzN17DrdnTby1FxDoXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oedPwe3NbnLszqO/KBqHdCveHn+FqCn3Aj8HlPuRxTiK43HgQTshHi/aA0CtnuKRB
	 XUjKfTIgzycBC1PyrsEE1HdXvL9zFS6+mGEDM96mc6G1OIBpxDrDtRV9FhVbHLzaJq
	 C0e13BfuOgzVHm4r6QfbqgcUF6slnQ7hqAjCYsuYuRiVNte3liwj1m2d5YJFz9o2wq
	 gw7CJduUcv8W/09rFBdn1R0ejBuf4/3aKbYR5zzOy3yjCDAVm8T1x/EAoihH1GGz1D
	 oKlGD986jO/o4ptOsAnwWdq1MzFAOM8wYQPlCTFX1vpePZ8tPhoO83gyDom9tMcBXa
	 PI+0HUMzmzATQ==
Received: by pali.im (Postfix)
	id 2ABD97BD; Sat, 12 Oct 2024 10:56:09 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/7] cifs: Improve guard for excluding $LXDEV xattr
Date: Sat, 12 Oct 2024 10:56:08 +0200
Message-Id: <20241012085608.712-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241012085252.560-1-pali@kernel.org>
References: <20241012085252.560-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

$LXDEV xattr is for storing block/char device's major and minor number.
Change guard which excludes storing $LXDEV xattr to explicitly filter
everything except block and char device. Current guard is opposite, which
is currently correct but is less-safe. This change is required for adding
support for creating WSL-style symlinks as symlinks also do not use
device's major and minor numbers.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/reparse.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index cd12704cae0c..50048dccc5ff 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -574,8 +574,8 @@ static int wsl_set_xattrs(struct inode *inode, umode_t _mode,
 
 	memset(iov, 0, sizeof(*iov));
 
-	/* Exclude $LXDEV xattr for sockets and fifos */
-	if (S_ISSOCK(_mode) || S_ISFIFO(_mode))
+	/* Exclude $LXDEV xattr for non-device files */
+	if (!S_ISBLK(_mode) && !S_ISCHR(_mode))
 		num_xattrs = ARRAY_SIZE(xattrs) - 1;
 	else
 		num_xattrs = ARRAY_SIZE(xattrs);
-- 
2.20.1

