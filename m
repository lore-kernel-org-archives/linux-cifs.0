Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C93482488;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727560847; cv=none; b=obcIcLVHrS/ffgvnRbni4vAPM8iPoW+h0E5y4WulSPv+DKi6Xt+5+7ccEhC+2XeiJbIlcE6z0qQK6RTk+0ppQ8u2tv0UDptky2QV6i/TEZDVgg18N7rWJoNzeu6I+w4X0J32wKrewJ/tq2AbRD4rmrbMwX0zY9qp7hV4mYwTFPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727560847; c=relaxed/simple;
	bh=30vYceahhAZ6cpDf6/qon3ZtC2Ak+QBMUSkaa2C2LTQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RC0U4l9/j3jERoOvk94yasQqap1GN/AmQJo1ynTzB8i/OZe7eMb+CxdN3WafgOh9y8oXlhRZpZFa89S5NsqbSmDdFJezK0aRyjtKPqNJvwteHs98pXoYwsTW6Hg0zkH27h1ZaWGpKxfJzBWKNslk2DTFariXQrWJNdbznadovGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/L1YbNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/L1YbNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103CDC4CEC5;
	Sat, 28 Sep 2024 22:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727560847;
	bh=30vYceahhAZ6cpDf6/qon3ZtC2Ak+QBMUSkaa2C2LTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/L1YbNQ4eAf5eSMc2BCNwNXBHBlz8kVTzMQ5Z3h0yyUuDPiJd49dzATnPAahPPZi
	 RLz1Nk/NjcJyh2+8djh8+xRJJhwozlkEMBWGR4SuAN+H5YNzrasVDUU7TtFy4GhnoS
	 i1sryzAo9BXMzdEpeHLj+NIZkpdavlnt3tiUVyWisP5zH16rxw94Ym5LnNTL96utAQ
	 Gd1h0sdEL/1WQegu351IdPu1f6v5jlJSYzkET4yr7N5Z9s23yvptGcbD5kHxb5Mzkc
	 6QXM7mtUvGvdJdFW0zTbPPcCIXcWXw35S1S8eOqeu/2hBBSXpokU7BZ8V7VTQtdahq
	 Q6gUOWaUrVPQg==
Received: by pali.im (Postfix)
	id 5F9EF9F7; Sun, 29 Sep 2024 00:00:40 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] smb: Update comments about some reparse point tags
Date: Sat, 28 Sep 2024 23:59:41 +0200
Message-Id: <20240928215948.4494-2-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240928215948.4494-1-pali@kernel.org>
References: <20240928215948.4494-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

NFS-style reparse points are recognized only by the Windows NFS server 2012
and new. Windows 8 does not contain Windows NFS server, so these reparse
points are not used on Windows 8.

Reparse points with IO_REPARSE_TAG_AF_UNIX tag were primarily introduced for
native Win32 AF_UNIX sockets and later were re-used by also by WSL:
https://devblogs.microsoft.com/commandline/af_unix-comes-to-windows/
https://devblogs.microsoft.com/commandline/windowswsl-interop-with-af_unix/

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/common/smbfsctl.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/smb/common/smbfsctl.h b/fs/smb/common/smbfsctl.h
index a94d658b88e8..4b379e84c46b 100644
--- a/fs/smb/common/smbfsctl.h
+++ b/fs/smb/common/smbfsctl.h
@@ -140,20 +140,21 @@
 /* Used by the DFS filter See MS-DFSC */
 #define IO_REPARSE_TAG_DFSR          0x80000012
 #define IO_REPARSE_TAG_FILTER_MANAGER 0x8000000B
-/* See section MS-FSCC 2.1.2.4 */
+/* Native SMB symlinks since Windows Vista, see MS-FSCC 2.1.2.4 */
 #define IO_REPARSE_TAG_SYMLINK       0xA000000C
 #define IO_REPARSE_TAG_DEDUP         0x80000013
 #define IO_REPARSE_APPXSTREAM	     0xC0000014
-/* NFS symlinks, Win 8/SMB3 and later */
+/* NFS special files used by Windows NFS server since Windows Server 2012, see MS-FSCC 2.1.2.6 */
 #define IO_REPARSE_TAG_NFS           0x80000014
 /*
  * AzureFileSync - see
  * https://docs.microsoft.com/en-us/azure/storage/files/storage-sync-cloud-tiering
  */
 #define IO_REPARSE_TAG_AZ_FILE_SYNC  0x8000001e
+/* Native Win32 AF_UNIX sockets since Windows 10 April 2018 Update, used also by WSL */
+#define IO_REPARSE_TAG_AF_UNIX       0x80000023
 /* WSL reparse tags */
 #define IO_REPARSE_TAG_LX_SYMLINK    0xA000001D
-#define IO_REPARSE_TAG_AF_UNIX	     0x80000023
 #define IO_REPARSE_TAG_LX_FIFO	     0x80000024
 #define IO_REPARSE_TAG_LX_CHR	     0x80000025
 #define IO_REPARSE_TAG_LX_BLK	     0x80000026
-- 
2.20.1

