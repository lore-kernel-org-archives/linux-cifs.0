Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E981CB33F;
	Sun, 15 Sep 2024 19:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726429557; cv=none; b=ZLld/FBNZ1dRa7khDpL7T8nAT7UkxVyCRRUVRus5LkVqlp+gk4ZvzFgUB0qyL85Zj6GiOGgHXOaaWeV2v9lIW5NkCvxAVXkaZePwQ+Znib69um+mXY5eIBwLVvvKUdFZXGpi3AqfuyIhuIF2TN9YmLuXmlU4GKWb7GT0N0ZTKTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726429557; c=relaxed/simple;
	bh=vp0tJ6174kqd3NVUVhvDpzmPnqU1dZ9ivhzYz0EgvRg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J0z19SG6VgTZM4X2s+Qxt7MvQqWi0VcZl+pAYN0dmFTYCtsVk8fwA2KLg8nRBeXdGqgXoz+Coxtw0vvYOacQPqawzW9Poqv3tWvUqyUK/H+aKG7WCo2NEvqVfk4fUDgCOH88j63Gaz0cp8wSM7NyJJQ49ZHFkqP8WNCS7yWyEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NncchzfX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NncchzfX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48262C4CED5;
	Sun, 15 Sep 2024 19:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726429557;
	bh=vp0tJ6174kqd3NVUVhvDpzmPnqU1dZ9ivhzYz0EgvRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NncchzfXBhzIL1H6QsMnTVqt20Tf+Mvl2i/x8S+kZrP4igs/uZkRxEJAlAwOSJ7UF
	 jn26aUwkdkJ32boLMFLIUIiXm56cgsxHumfCHQH12bmUvGH1i6vE9oHzlAVHItCsi4
	 bHWZdAdvW37GvGhBdixW7CK8uMzXu3YuOSkuW+MdizPzBqSbXz+pb9ExZXz6Fj4Mvm
	 bHn7XmLaVDEFmmujM1U3GDf74CLOeqP2j4wwde34ZBOJBhf/tlz6PXuWSwf/GNmtnQ
	 NDndFTmHVBtp7mS9fy8pWmpUit85sAlnslfAEDu9CDqbeuIFGVw+mIE27KQ8GpGzvF
	 xmsv3jGC/7i7g==
Received: by pali.im (Postfix)
	id A470CCB5; Sun, 15 Sep 2024 21:45:50 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] cifs: Fix creating of SFU fifo special files
Date: Sun, 15 Sep 2024 21:45:44 +0200
Message-Id: <20240915194545.14779-4-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240915194545.14779-1-pali@kernel.org>
References: <20240912120548.15877-7-pali@kernel.org>
 <20240915194545.14779-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU-style fifo is empty file with system attribute set. This format is used
by old Microsoft POSIX subsystem and later also by OpenNT/Interix subsystem
(which replaced Microsoft POSIX subsystem and is part of Microsoft SFU).

This format of SFU-style fifos is recognized also by Windows NFS server
included in the latest version on Windows Server 2022.

Currently when sfu mount option is specified then CIFS creates new fifo
files with content LnxFIFO. This was introduced in commit 72bc63f5e23a
("smb3: fix creating FIFOs when mounting with "sfu" mount option").

It is important to note that LnxFIFO is not SFU-compatible and neither
Interix, SFU, SUA or Windows NFS server recognize file with content of
LnxFIFO as special fifo file.

So when sfu mount option is specified, fix this problem and create all fifo
special files compatible with SFU format, as it is expected by sfu mount
option. This allows interoperability with other SFU implementations and
also with Windows NFS server.

Fixes: 72bc63f5e23a ("smb3: fix creating FIFOs when mounting with "sfu" mount option")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2ops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index dc56f7ba1a06..406f2399f0c5 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5115,10 +5115,8 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
 		type[0] = '\0';
 		break;
 	case S_IFIFO:
-		type_len = 8;
-		strscpy(type, "LnxFIFO");
-		data = (u8 *)&pdev;
-		data_len = sizeof(pdev);
+		/* SFU fifo is system file which is empty */
+		type_len = 0;
 		break;
 	default:
 		rc = -EPERM;
-- 
2.20.1

