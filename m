Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3853016E7;
	Mon, 16 Feb 2026 10:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771239252; cv=none; b=sh/LA4piUVBlXnxkPPYqu3DfM3/4Ky81tFlBqOOu+JlzMIk3YC4aF4X4TYpX3nh720i+yhJbwUCtUs/o0Dw8P0PmOplmEzmCZyVu0oCiZFq6xlmzAe9r1oU04/W/ObSprlwXRMppGMGiu4BrgCRuZBY511NPILpNxFK8MJ4Pdfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771239252; c=relaxed/simple;
	bh=JinFGjUhP2hYlg1Y8SzOMvzzfAH+mN4ghm5Gl7xBmww=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IrOSGBqCDVBiOOqqddfK4WQCtKLks2bIVRW1SpM4TdqVcSDRwd/L+9zQq5Rj0trEhxXo5CygKewQgT/UsZMRdxHwkd2I8vcBQxTB/V75Q92cFHCwNrmALafZeI+dJm5dsVU5ycBNTeobwuhkte71xlF194b7icsQ8fat2foYa00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OePkduDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OePkduDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EEEC116C6;
	Mon, 16 Feb 2026 10:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771239251;
	bh=JinFGjUhP2hYlg1Y8SzOMvzzfAH+mN4ghm5Gl7xBmww=;
	h=From:To:Cc:Subject:Date:From;
	b=OePkduDFQFDtIpZ4Pf6Khh6KEihh/TNakhWb5GDiBY/wW+V4of63Q8GbkqOIeTmTE
	 aDJTQMt/PvA/x+sXylDWR0z1iwcMotOnnTV8RygOpypIqCMWaZic71Jwr4NcBukgbF
	 rZCb8bnMOMACFXFxpSK8Swtt22IeF507r8A7wPhtqCid6R/UojaFSALCsLfDcPenZN
	 UkAPpSn5pp46igW7X3gxTqNcK699biC/hVzGZn+hL9EYWrj7X36wTF4/Y/ir/0YeCZ
	 DjtWjwEjPL4jj2BCSObqxPVWYgLImIsgudlBB987M4qMM0oCmeNO+EisnygVR3ZvMN
	 Abt8RsfM0Vmpg==
From: Arnd Bergmann <arnd@kernel.org>
To: Steve French <sfrench@samba.org>,
	Stefan Metzmacher <metze@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: smbdirect: select CONFIG_SG_POOL
Date: Mon, 16 Feb 2026 11:54:00 +0100
Message-Id: <20260216105404.2381695-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

The smbdirect code now uses the scatter/gather pool interface. This
causes a build failure when the interface is disabled:

In file included from fs/smb/client/../common/smbdirect/smbdirect_all_c_files.c:21,
                 from fs/smb/client/smbdirect.c:176:
fs/smb/client/../common/smbdirect/smbdirect_rw.c: In function 'smbdirect_connection_rw_io_free':
fs/smb/client/../common/smbdirect/smbdirect_rw.c:76:9: error: implicit declaration of function 'sg_free_table_chained' [-Wimplicit-function-declaration]
   76 |         sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
      |         ^~~~~~~~~~~~~~~~~~~~~

The other users of this interface all 'select SG_POOL', so so the same
here.

Fixes: 5ab0987c492e ("smb: smbdirect: introduce smbdirect_rw.c with server rw code")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/smb/client/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/Kconfig b/fs/smb/client/Kconfig
index 17bd368574e9..725422b45ef4 100644
--- a/fs/smb/client/Kconfig
+++ b/fs/smb/client/Kconfig
@@ -182,6 +182,7 @@ if CIFS
 config CIFS_SMB_DIRECT
 	bool "SMB Direct support"
 	depends on CIFS=m && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=y && INFINIBAND=y && INFINIBAND_ADDR_TRANS=y
+	select SG_POOL
 	help
 	  Enables SMB Direct support for SMB 3.0, 3.02 and 3.1.1.
 	  SMB Direct allows transferring SMB packets over RDMA. If unsure,
-- 
2.39.5

