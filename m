Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0D5396D2C;
	Tue,  7 Jul 2026 09:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415047; cv=none; b=JAzcl+qalhiEbNOu3MxLX3hsLbeY90VhQBgdSn6zeK92L/C6Auda74cjUnCbnzW+nNTRWlCW5lPaagLS7sQMqlE5DkMbobLp0tItpfmWKJDQwf84uhQo68pSqBinEibSABmaHjXBLoljTuxutLHnqMaBJrFshJACuhFdZA/DhI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415047; c=relaxed/simple;
	bh=gqr6P8wwAWVcRdX7g3vWHuctkMA6BJdfW11xrylprX8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=hKB0cida0pStNgNbu+hB/J3/+H92L4PrPg35ju28hoLsQKtIq/RT0GBI64bP1gac2QalSSN9Rcw00e+lmclRLGefItrSARyYHktGvuLjVmnsjqXdFd99aSVROz95XnooEMho4CLC10rZg9mHpKAju3TiM1tMwHFYzq4BKqPHJis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WSYOE9yj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSYOE9yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5E61F000E9;
	Tue,  7 Jul 2026 09:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783415045;
	bh=7Ss8IJ7OFBgFwjahPIdzSJ2SPPJpfVxtSmp5m4LUF14=;
	h=From:To:Cc:Subject:Date;
	b=WSYOE9yjsJrELIqj9nGuLeaP+6bePHhULQnLMtVrlCgTwqR/02snUqReW1S9dtOZo
	 Rwy9PpOoTssPdGnINOTiNpTQRh8BCuWFXrLxjOmJ8/s/+rAtPRbVVsQYWN/sUfGwDj
	 WdtrNh2TYt9/BntN2gYJ2hOf/AqekuIKiuqw94J4TEWhlK53d+0YpcFxgoUffQ4Vcc
	 vBqPyXAAnqzWRlJoUe7EOrK4PhNKGPMb/oq8NN9I70mYFafwgtGEryCPu4p33jUIMr
	 n7FLg5ibYukDgfiXq4A2qegFN9QC84i6qs7SePW/550MKQoVd9nIinJto/29oPJbOo
	 uhbN38cpAsbrQ==
Received: by pali.im (Postfix)
	id 66B7171B; Tue,  7 Jul 2026 11:04:03 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Fix support for creating SFU fifo
Date: Tue,  7 Jul 2026 11:03:56 +0200
Message-Id: <20260707090356.26163-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SFU fifos are natively supported (created and recognized) at least by:
- Microsoft POSIX subsystem
- OpenNT/Interix subsystem
- Microsoft SFU (Windows Services for UNIX)
- Microsoft SUA (Subsystem for UNIX-based Applications)
- Windows NFS server (up to the Windows Server 2008 R2)

Windows NFS server since Windows Server 2012 uses new reparse point format
for storing new fifos, but still can recognize this old format (also in the
latest Windows Server 2022 version).

SFU-style fifo is empty regular file which has system attribute set.

These SFU-style fifos are already recognized by Linux SMB client.

But Linux SMB client is currently creating new SFU fifos in different
format which is not compatible with all those SFU-style consumers. Fix this
by creating new fifos in correct SFU format which would be recognized by
all those applications and also by existing Linux SMB clients.

This change affects only creating new fifos when mount option -o sfu is used.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2ops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index e59fda1b2230..1261b928edee 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -5293,10 +5293,8 @@ int __cifs_sfu_make_node(unsigned int xid, struct inode *inode,
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

