Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794405207;
	b=laOzUKT/aH+UP3hH8Tya2KrMwNHkOEPpWm4W+/Kcacwunv3RvRgNCCGibiwXEMhZDvdF
	 zPAukg8H4tdtQcc9JHW2nTGLzEPYONxWfBTAokxSP1G4b/c8v3eHXXU7cQ3LsbFUWycpy
	 uhd/IwnE9G71JuN19gxWewXWX2BflAydy0aYJAQMipBoGOoisLzU1YYoUACn8TIO154bL
	 kgFNkpi/Hfn+BfCAHc3YspIr3WrdFXXPwQqJKLfTdqEEHio3TSks11CotqIUL4UpMkGkK
	 FvBunCru/JToPK2wunr30kv8UwJ5Iz6ip4E9n8Tx9yd8mE4yYAErb/WNL8lH3TmwqKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794405207;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=GoH5SdsCOu/+HV6dTnYj6Ma2/O5gdpaUNzhXeMTOHXY=;
	b=spIn3vwq/WVWUQEDlgeyVHMEW7eg0QPzFnBBjX7irFQugqfzNjklP29kyA7feiIcnO8M
	 zSSHVWME1sV39ADtorBIjgItlAwSyZnGKdUXhJzwMKYJj8Knup8izEAKytuV0t98/40zp
	 P1epBkqx1lp2x/JiM1PrEKTaYGYG411gj9fN+QlcELkPAQ8o0LbTV7GrDg/qz3kKyImHJ
	 vFXDR6pc+d/eSA7I2J3jFHEXyB3Sqi1NCDX7VyrEX5y48I9B206Gq/Wd+F+HufQBCRWOP
	 /fHn+L/nTLzt+LGwU20x/sWf3qE3AIFP2DD730cOC5DFDENuY9ercOfeis4n8X1PEgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Em1tAyZO;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FDC606A324;
	Wed, 11 Nov 2026 13:53:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91FDC606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=Em1tAyZO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GoH5SdsCOu/+HV6dTnYj6Ma2/O5gdpaUNzhXeMTOHXY=; b=Em1tAyZOOaAD+ekIT3aLhafrtF
	qoIPYv/rWg8RDZpR2U4GyiuWFcZIPq8m0p+VfhJ5I4YY8sNTCzm9fVCwpv57t1Y2twDgjKaPm6F6D
	x0mjCxdnwD7dgNrvYBN1C6BgzrCjcewlZ0yCUZMSP8IloZ0KZ6KVQ8RRp67Uzdd8UUGXQvuXJ0X1Z
	7K11CJJxtLPulBneeCy+2GO8qiGt3R0kGEiDzO0SZnQ3fY3wQS1UoHLLHYp6AW4Vn+pG/QMXUi8cA
	OuPxuCe21bp49NdMv31MndUZTW8QGqIzdZEzmVyEpfHXVsUYgTSewzCZBaNN9PmzQcHEwNeTaLHcl
	ynfs44CQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xR8lP-00000001SwM-1D7v;
	Wed, 11 Nov 2026 10:53:24 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] smb: client: retry a hard link open without a lease
Date: Wed, 11 Nov 2026 10:53:23 -0300
Message-ID: <20261111135324.4028153-1-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Opening a hard link of a file that currently holds a lease fails with
EINVAL over SMB3.  The client caches lease keys per inode, but the server
ties a lease to the file name it was granted under, so reusing the inode's
lease key to open a different name of the same inode is rejected with
STATUS_INVALID_PARAMETER (MS-SMB2 3.3.5.9.11).

Resend the open without a lease when it is rejected that way, as
smb2_rename_path() already does.  Fold it into the same retry loop as the
FILE_READ_ATTRIBUTES fallback so either can follow the other in whichever
order the server rejects them.  Reacting to the server response covers
every case - including a name kept open by an active handle - without
racing a handle opened concurrently.

Reported-by: Giuseppe Piscitelli <ooonea@gmail.com>
Closes: https://lore.kernel.org/r/CACmoRBbDZR3eyEM65j73sWMS7A=T89z1QAvCP=+u0WGzZhwW6g@mail.gmail.com
Fixes: 262b73ef442e ("smb3 client: fix open hardlink on deferred close file error")
Cc: stable@vger.kernel.org
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
---
 fs/smb/client/smb2file.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 764cfd894ad0..4369621393a0 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -201,18 +201,27 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 	}
 	smb2_oplock = SMB2_OPLOCK_LEVEL_BATCH;
 
-	rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
-		       &err_buftype);
-	if (rc == -EACCES && retry_without_read_attributes &&
-	    !oparms->pending) {
+	for (;;) {
+		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL,
+			       &err_iov, &err_buftype);
+		if (oparms->pending)
+			break;
+		if (rc == -EACCES && retry_without_read_attributes) {
+			retry_without_read_attributes = false;
+			oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
+		} else if (rc == -EINVAL &&
+			   smb2_oplock != SMB2_OPLOCK_LEVEL_NONE) {
+			cifs_dbg(FYI, "%s: invalid lease key, resending request without lease\n",
+				 __func__);
+			smb2_oplock = SMB2_OPLOCK_LEVEL_NONE;
+		} else {
+			break;
+		}
 		free_rsp_buf(err_buftype, err_iov.iov_base);
 		memset(&err_iov, 0, sizeof(err_iov));
 		err_buftype = CIFS_NO_BUFFER;
-		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
 		oparms->reconnect = reconnect;
 		oparms->replay = false;
-		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, data, NULL, &err_iov,
-			       &err_buftype);
 	}
 	if (rc && data) {
 		struct smb2_hdr *hdr = err_iov.iov_base;
-- 
2.56.0

