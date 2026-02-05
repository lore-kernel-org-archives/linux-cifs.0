Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B48734BA42
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 16:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770308403; cv=none; b=IQAnHUjMHejsT6jb2fXU9nPd8cutX4UwrKq93X2cTDQHgBpMghfP4S+847z/FrjNOhzKnHlU6f223QWnjuB5tDTXJJWC2hO2qDJQMwKX8cgJdzwRz0u7SM7OVcOiyD3Uj9xoEcLhzuzwk+k51BZSz2aJ8vxhn08BjJgQtxm327c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770308403; c=relaxed/simple;
	bh=KsJgsRhHzPdytIkHNFoXpJysSdA39rPEyS46AzoH/a4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gfVkyqq1LjGy4mh7XYzKgUwi7I5kmaY1vjB/hRW0d+d6XQ4o5mkvBC5QGLisL0pJ5HWMN3p5/MHIbwqCEnRPH2M8KK4D2/UNONC3j0bwnvGHAZ8IOk6VnxR5CMpwEAdfBvVsJ/j1FGUV4TDNW1A132E3RCeVYvngzJSrimLDfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=XErSpN9V; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="XErSpN9V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=2FRaqs3F+abORQ0SEpROYKzEvfetPcgCE3c9vJvEVKE=; b=XErSpN9VYz9kAV+7f0ktHnyfr8
	3qTP1prErL65JLKrbb+hcDmpUBw+3nBaj5sVHLq+KFRuK3TdWmEwMuDjSqyYzFGcQxERsMPbvOu8H
	qXNm29bqODtjs/3vFjWGYsJO9eQZGLnQH+Mn/95qBU0YAMoP4Pppn5foKuTD/+Bw4mjw8YRJGSQlu
	B88ucsNUsI4YcuwFEG/fDUPTc6wKszTxHcuy82Yf2jf9qARivkcEje6H6+3+59VtXBeP+j8tj26LB
	hCoc1MU3OEoaDAWTERfj2LJhND8Qq9daFHIiYkw8yliYo/0XbLpLR7P7LhWezPC+VgwI5A0SBDX87
	jj5fm+EQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99)
	id 1vo25A-00000001gyR-1iuY;
	Thu, 05 Feb 2026 13:19:52 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: smfrench@gmail.com
Cc: David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] smb: client: fix potential UAF and double free it smb2_open_file()
Date: Thu,  5 Feb 2026 13:19:52 -0300
Message-ID: <20260205161952.245146-1-pc@manguebit.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero out @err_iov and @err_buftype before retrying SMB2_open() to
prevent an UAF bug if @data != NULL, otherwise a double free.

Fixes: e3a43633023e ("smb/client: fix memory leak in smb2_open_file()")
Reported-by: David Howells <dhowells@redhat.com>
Closes: https://lore.kernel.org/r/2892312.1770306653@warthog.procyon.org.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: linux-cifs@vger.kernel.org
---
 fs/smb/client/smb2file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
index 2dd08388ea87..1f7f284a7844 100644
--- a/fs/smb/client/smb2file.c
+++ b/fs/smb/client/smb2file.c
@@ -179,6 +179,8 @@ int smb2_open_file(const unsigned int xid, struct cifs_open_parms *oparms,
 		       &err_buftype);
 	if (rc == -EACCES && retry_without_read_attributes) {
 		free_rsp_buf(err_buftype, err_iov.iov_base);
+		memset(&err_iov, 0, sizeof(err_iov));
+		err_buftype = CIFS_NO_BUFFER;
 		oparms->desired_access &= ~FILE_READ_ATTRIBUTES;
 		rc = SMB2_open(xid, oparms, smb2_path, &smb2_oplock, smb2_data, NULL, &err_iov,
 			       &err_buftype);
-- 
2.52.0

