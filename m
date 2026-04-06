Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC4412F585;
	Mon,  6 Apr 2026 13:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775483381; cv=none; b=brNjZnXoSiJPpPkpz5mQATk4R0nQ6UVI8myQ2rZwfs8DAQpowfuaduOHH/wxiqfDSEU1773n5c4uDFI2bBKRNr+03fjk0MvixGtDTjdBfPA1oddIWqZEJgauLfVW51P6/GBekpgMIgp7HfC0FvCO444xCdaOBMAvAo6JT4HHy6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775483381; c=relaxed/simple;
	bh=9BU9EIZ0xpSJhe6BLo5bEcq83MnOBqIILZ9FwVVRilI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5C6Ye1JK+N7bxSbbEI36yJm1JnWaCYvt/fFCSCDMy3K3tW44unhpQu21ueCkCavqXbUkOhrwzuzfpHCzSF53gAFZadPh0x3HTyiyk6DXX6kFcBGdr6Y6+rgMg+iJ3/RLPENlkSyhF1sj+7Min8pGY8WMi2stjj+CSNx3G4mjFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To6h9XC5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To6h9XC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03D6C4CEF7;
	Mon,  6 Apr 2026 13:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775483381;
	bh=9BU9EIZ0xpSJhe6BLo5bEcq83MnOBqIILZ9FwVVRilI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To6h9XC5zP+xWBz0FzFGxcHhdJiVt7QI1Vq9SU297CnmbumwIuUx3EZTpmP1fihB1
	 iQLu5GNl/TLRxXOf+HGpB60h3/kd/cMpbPp5R6WRDk4Gv2I1McfDfi49yfPm2SxRWF
	 Wbz/f4FCxG6xmntVxIB6Qt/qW+KmUp9Dn/tzASKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-cifs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	stable <stable@kernel.org>
Subject: [PATCH 1/2] smb: client: fix off-by-8 bounds check in check_wsl_eas()
Date: Mon,  6 Apr 2026 15:49:37 +0200
Message-ID: <2026040636-unsigned-jackal-e239@gregkh>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2026040635-banking-unsoiled-3250@gregkh>
References: <2026040635-banking-unsoiled-3250@gregkh>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1895; i=gregkh@linuxfoundation.org; h=from:subject:message-id; bh=9BU9EIZ0xpSJhe6BLo5bEcq83MnOBqIILZ9FwVVRilI=; b=owGbwMvMwCRo6H6F97bub03G02pJDJmXd37YvON0Y+CLz8fKbul+Pt/QzS5tbfrrpeC17U+3n 5Pe+GPJxY5YFgZBJgZZMUWWL9t4ju6vOKToZWh7GmYOKxPIEAYuTgGYSPcxhvklT4Lt51b5zRRO /3AqezXzJP1TBlcYFlyZd2OJ5PuqTwc9jvWucA059fXE/yUA
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp; fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Content-Transfer-Encoding: 8bit

The bounds check uses (u8 *)ea + nlen + 1 + vlen as the end of the EA
name and value, but ea_data sits at offset sizeof(struct
smb2_file_full_ea_info) = 8 from ea, not at offset 0.  The strncmp()
later reads ea->ea_data[0..nlen-1] and the value bytes follow at
ea_data[nlen+1..nlen+vlen], so the actual end is ea->ea_data + nlen + 1
+ vlen.  Isn't pointer math fun?

The earlier check (u8 *)ea > end - sizeof(*ea) only guarantees the
8-byte header is in bounds, but since the last EA is placed within 8
bytes of the end of the response, the name and value bytes are read past
the end of iov.

Fix this mess all up by using ea->ea_data as the base for the bounds
check.

An "untrusted" server can use this to leak up to 8 bytes of kernel heap
into the EA name comparison and influence which WSL xattr the data is
interpreted as.

Cc: Steve French <sfrench@samba.org>
Cc: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 364bdcff9c9d..fe1c9d776580 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -128,7 +128,7 @@ static int check_wsl_eas(struct kvec *rsp_iov)
 		nlen = ea->ea_name_length;
 		vlen = le16_to_cpu(ea->ea_value_length);
 		if (nlen != SMB2_WSL_XATTR_NAME_LEN ||
-		    (u8 *)ea + nlen + 1 + vlen > end)
+		    (u8 *)ea->ea_data + nlen + 1 + vlen > end)
 			return -EINVAL;
 
 		switch (vlen) {
-- 
2.53.0

