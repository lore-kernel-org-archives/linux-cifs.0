Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794351265;
	b=GZ8yOvpa1eVCeTMFONkb/JKvTYagwJGVxkRwlv4jlLh0HsMyivxoT5602Kts65tFy7ZL
	 wXOXUFPMCmINfbIAOFq4nxZcKCbAU6dSbH6NXlr/lGtDcyhTZS+6v4jojKCAQQiRQnfe0
	 MPbpz3omXZpuUcDndwu/uzIeEUDXLXWOPZKz1ERpwkbV2RXco/EBbp2FaZcP2ZZ2UopSA
	 T4dUUgfjPdNjN7hDZ9zc6J754UClqnnus1iOoGj9dt3hZ097sAXtnacwDz2IfA4WxUiM5
	 DIk0UKWVdesx9R/4ZPIxHh0XbgVemmkquYoyNcj19gja22kcD4OgU7D6keOrpc3jhIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794351265;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sQkZxWGOUxijcv0V1zPF+5C5vpXZ6157ULceeBmTYNk=;
	b=2cgtXYYPABe+NPxaojC1XfsMEIZYmhcfpA4OfziNqqEmN3JFJyOtfqn/uQOHU9Q04NSA
	 PnO6yuAPtahhLFoRFmRGtmcD4jI2l2e1Jx/fCV28NTpzYkd4KaaUyXSwvkGC34sFjyLUL
	 YoR/VZ+uDGzPlgzYaeAHrnWjpkZuWsm4Gtz5g1BOpl+maFynlh1ELHYuDrw7e3Bfg3MBY
	 sSDCcjpCbaLiHOHNOspaKtwuYukfEi8Wj5R0uHr7FgriLwfMUrA3HizoHJgPIts+QI+at
	 JaqlT0FQKFHm5tISk/DL1Y9JspmZuZld0EKkLohOigWqsWiTAJQmrEycMz0byf6eXrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=6QFL8vkX;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BBA8606A31C
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 22:54:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6BBA8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=6QFL8vkX
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=sQkZxWGOUxijcv0V1zPF+5C5vpXZ6157ULceeBmTYNk=; b=6QFL8vkXYiime8ORR2uINBBA0K
	C2ew+4Tth9P4Fe+JrdgXS+MIkpE8SdOzoDZMx9tKt+UJkuTxRNceTlefreQhc2Z/qaRcPLFZxSHjt
	ycT5cfSxnpM3FVxjHDhD8towVVaDBo5OgIeMnqxi0fyYvbqGyMrQ86P/Mcox8LsdlmZ4nzmKmw2+f
	MSd/JZ3YagKG1ocOaiuGUDLInNVh7gHi1K83Fz16QPm3uzerHAh7BHuLWyMWHUKb3zRuy/hWx64HV
	/WQ3SkKcI6lpDh5ho20z3P3u6IbGcOTxa7pTKVTcpC6GgWjcv6JgHwyU6TQEu3XNTkPGEFSREOn1g
	5rNeqBog==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xQujE-00000001PHR-0Pok;
	Tue, 10 Nov 2026 19:54:13 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH 2/2] smb: client: flush deferred handles of other names before a hard link open
Date: Tue, 10 Nov 2026 19:54:12 -0300
Message-ID: <20261110225412.3937476-2-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261110225412.3937476-1-pc@manguebit.org>
References: <20261110225412.3937476-1-pc@manguebit.org>
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

cifs_open() flushes an inode's deferred closes before opening a different
name (hard link) of it, so the open can take a fresh lease rather than be
reissued without one (see "smb: client: retry a hard link open without a
lease").  cifs_get_hardlink_path() only triggered that flush when a cached
handle had the same open flags as the new open, so a differently accessed
name - written then read, say - skipped it and opened without a lease.

Match on the name instead: flush when a cached handle for another name of
the inode is open, so those opens keep lease caching too.

Signed-off-by: Paulo Alcantara <pc@manguebit.org>
---
 fs/smb/client/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 1247d73740a0..f51653cb6432 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -2737,7 +2737,7 @@ cifs_get_hardlink_path(struct cifs_tcon *tcon, struct inode *inode,
 	spin_lock(&cinode->open_file_lock);
 
 	list_for_each_entry(open_file, &cinode->openFileList, flist) {
-		if (file->f_flags == open_file->f_flags) {
+		if (open_file->dentry != file_dentry(file)) {
 			rc = -EINVAL;
 			break;
 		}
-- 
2.56.0

