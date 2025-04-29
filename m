Received: from james.smtp.mailx.hosts.net.nz (james.smtp.mailx.hosts.net.nz [43.245.52.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A794D2D29A8
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 13:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.245.52.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745932373; cv=none; b=CyJ5DqrzZvhuYEq+wPYUZQmENeXMA751msMCcUxqmZ6d7pbFo5AHeCG/Pc3cbw6TEDktL5eqU7oOXfXTb00fITYZIXfNKpavjPFqbA2Niw9EmPubHs7eY344hkU2vWSpPyz8/v/iP+1QUrbWkMcOm6uJay5XfuPaUTe/r0N8D/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745932373; c=relaxed/simple;
	bh=mjN5Ts49/wfSqJ4SuLfkpgl1E8y6zIYay4puqhiFMF0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=H7HqnwRNDBMCZECvGo5XsedjoKYlIL5ayLoSmq2sKFQGpwS6vy6TslOlkpUlos9hRJFcNvmZoRafJqtkVUThqjFsY33nJ9qmB/mCeNaEG0Gt8izCkYp/0I99v62b15QABP9tgy+nk56dN1WxvpINrXpb0VHa7HiGWqUMP5hEDfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jro.nz; spf=pass smtp.mailfrom=jro.nz; arc=none smtp.client-ip=43.245.52.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jro.nz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jro.nz
Received: from [101.53.218.195] (helo=deetop.local.jro.nz)
	by james.smtp.mailx.hosts.net.nz with esmtpsa authed as jro.nz  (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <devel@jro.nz>)
	id 1u9kWM-00AE6B-2I;
	Wed, 30 Apr 2025 00:57:10 +1200
Date: Wed, 30 Apr 2025 00:59:15 +1200
From: Jethro Donaldson <devel@jro.nz>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org, pc@manguebit.com
Subject: [PATCH] smb: client: fix zero length for mkdir POSIX create context
Message-ID: <20250430005915.5e1f3c82@deetop.local.jro.nz>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Hosts-DKIM-Check: none

smb: client: fix zero length for mkdir POSIX create context

SMB create requests issued via smb311_posix_mkdir() have an incorrect
length of zero bytes for the POSIX create context data. A ksmbd server
rejects such requests and logs "cli req too short" causing mkdir to fail
with "invalid argument" on the client side.

Inspection of packets sent by cifs.ko using wireshark show valid data for
the SMB2_POSIX_CREATE_CONTEXT is appended with the correct offset, but
with an incorrect length of zero bytes. Fails with ksmbd+cifs.ko only as
Windows server/client does not use POSIX extensions.

Fix smb311_posix_mkdir() to set req->CreateContextsLength as part of
appending the POSIX creation context to the request.

Signed-off-by: Jethro Donaldson <devel@jro.nz>
---

Tested as far as mkdir now works as expected.

Patch is against stable tree at v6.14.4 tag (first patch - unsure if I've
correctly done the base-commit thing, sorry).

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 163b8fea47e8..e7118501fdcc 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2920,6 +2920,7 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 		req->CreateContextsOffset = cpu_to_le32(
 			sizeof(struct smb2_create_req) +
 			iov[1].iov_len);
+		le32_add_cpu(&req->CreateContextsLength, iov[n_iov-1].iov_len);
 		pc_buf = iov[n_iov-1].iov_base;
 	}


base-commit: ea061bad207e1ba693b5488ba64c663f7ca03f50
--
2.49.0
