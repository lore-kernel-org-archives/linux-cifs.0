Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759181CF2AB;
	Mon, 28 Oct 2024 10:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730110231; cv=none; b=YLZ1jwb3E0UIbOmD2yMgHF2J6QxoX5wMWaNvnyl6viQprbmPDwlUIQth4EqODSbDy8VfAIQ0Ru1gBN1NfE6r1ogy1VtqGOTP6/vPCt92LsDlRQuzHxLYP2F9v3LI408syVB479xd/7d1gp/mZIRvtCWkSxGol/4QfKfqDNa1KCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730110231; c=relaxed/simple;
	bh=D2OIUOHMjnw/6oBtePX97KgzryCvG2LA0jsLNZFqlBI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8O1GHy1fEiGkOIEdtWTw3iL21R+LMOzc2v1h9apEInQrb0i2jmSnR3gajbcV3eazp62HdEntETFQDozZic69Ih0gFdP7SLPSwy+luBr58juTtmUcsPEmNaPuMxq78rDsEX4cpZ4pIGBbv8XEnmKRSG6N53iuOQFkSGE1XFEDpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tKEaLMwE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tKEaLMwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1362C4CEC3;
	Mon, 28 Oct 2024 10:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730110231;
	bh=D2OIUOHMjnw/6oBtePX97KgzryCvG2LA0jsLNZFqlBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tKEaLMwEmFBMu7eT72xwZZj+CisxX3RLZmC37iopZhGi9/kDK68HkQIH/FIlLVpcA
	 WTfALVFTTRjWPPzTcZ6/mUiBj1nRVuzrR1i/JdRT1PUtvHEtFaUyKaIOFqwQri/Jj0
	 LdxzSIBrT+8TaG5GvV+40xYmWJS1WUmxREO2Bvb4F/MqZe1Eu/23Q//pmRsY4k2OV0
	 ptmzxTZdMMqdahPSzCm9Dn8pKpCyAOdkc8r1TbauDKuigqleQkKQJqMHvMCDHV8z4y
	 IkYScpFDUynWSyEca3tqTcVpx8paDN1eFd2tba7f1rT7b8brWZxCQFfuWawWNYpFWm
	 L/3szVw0crD4g==
Received: by pali.im (Postfix)
	id AB6DBA58; Mon, 28 Oct 2024 11:10:23 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] cifs: Recognize SFU char/block devices created by Windows NFS server on Windows Server <<2012
Date: Mon, 28 Oct 2024 11:10:07 +0100
Message-Id: <20241028101007.29306-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005145445.19850-1-pali@kernel.org>
References: <20241005145445.19850-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Windows NFS server versions on Windows Server older than 2012 release use
for storing char and block devices modified SFU format, not compatible with
the original SFU. Windows NFS server on Windows Server 2012 and new
versions use different format (reparse points), not related to SFU-style.

SFU / SUA / Interix subsystem stores the major and major numbers as pair of
64-bit integer, but Windows NFS server stores as pair of 32-bit integers.

Which makes char and block devices between Windows NFS server <<2012 and
Windows SFU/SUA/Interix subsytem incompatible.

So improve Linux SMB client.

When SFU mode is enabled (mount option -o sfu is specified) then recognize
also these kind of char and block devices and its major and minor numbers,
which are used by Windows Server versions older than 2012.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
Changes in v2:
* Rebased on top of v6.12-rc5
---
 fs/smb/client/inode.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index eff3f57235ee..b6213d595e71 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -598,6 +598,17 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 				mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
 				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
 				fattr->cf_rdev = MKDEV(mjr, mnr);
+			} else if (bytes_read == 16) {
+				/*
+				 * Windows NFS server before Windows Server 2012
+				 * stores major and minor number in SFU-modified
+				 * style, just as 32-bit numbers. Recognize it.
+				 */
+				__u32 mjr; /* major */
+				__u32 mnr; /* minor */
+				mjr = le32_to_cpu(*(__le32 *)(pbuf+8));
+				mnr = le32_to_cpu(*(__le32 *)(pbuf+12));
+				fattr->cf_rdev = MKDEV(mjr, mnr);
 			}
 		} else if (memcmp("IntxCHR\0", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "Char device\n");
@@ -610,6 +621,17 @@ cifs_sfu_type(struct cifs_fattr *fattr, const char *path,
 				mjr = le64_to_cpu(*(__le64 *)(pbuf+8));
 				mnr = le64_to_cpu(*(__le64 *)(pbuf+16));
 				fattr->cf_rdev = MKDEV(mjr, mnr);
+			} else if (bytes_read == 16) {
+				/*
+				 * Windows NFS server before Windows Server 2012
+				 * stores major and minor number in SFU-modified
+				 * style, just as 32-bit numbers. Recognize it.
+				 */
+				__u32 mjr; /* major */
+				__u32 mnr; /* minor */
+				mjr = le32_to_cpu(*(__le32 *)(pbuf+8));
+				mnr = le32_to_cpu(*(__le32 *)(pbuf+12));
+				fattr->cf_rdev = MKDEV(mjr, mnr);
 			}
 		} else if (memcmp("LnxSOCK", pbuf, 8) == 0) {
 			cifs_dbg(FYI, "Socket\n");
-- 
2.20.1

