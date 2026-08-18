Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5355E47986B;
	Tue, 18 Aug 2026 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787062067; cv=none; b=GZOGspYqLU07+1/EHRe6En1nw83jcfJ9ryyYIiSQAKEueNXBU/ZMUJ3HSZfd6vQD/IYoXlICxgerfJaE3tTyPrm609AQT/iSCoGCXwxPCdi+bU3f7lRKdCCSdwSc3qyYV53FGZcYmrnIiLGrDNiryDDx3sVQsQ/OYYGTcsAPRac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787062067; c=relaxed/simple;
	bh=czuF+83ib+PA336GsMreYXGG0yJw47o24W5EUaH+qRE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c+TDnLYoOQRcuEOjHkh7rwP9lloovz3dbWeTmqOoh/XGnh24crWkvqZlgFqWvPZrMnwU1o2+0dLfnFlDcLJVG7KUFiQIsEYXh8OzM+5IJh/nMXQXudt6lxMd7vfGiavIsgr15jZyjYLMDvDFeF8ZTrmCkXz3oPHhN46ywHdSY4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=hYgBbKre; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="hYgBbKre"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=gxD/8AUz9s+QVRvJE3y342XiKtkXK9hCFV95Oe1Hbb8=; b=hYgBbKreWU+9hbiVQxnQMRDJD0
	ECDNNszjlU1cdcI+IyGnJ3oMaCiIrE1aD+CbLrnj/U79Dxgxx97eD1orjtJXIQi1AjYnGcPpzm5fl
	pCLFB0oKNg9tu3fqOoNhLlSapcl3qWGwjqrWoAdoyO0LFQnz7Sw7xzeMmkc2RJiXT/V87UeJFhJQx
	7qq6jqyiUbF9AxsKZu1EMPII5D2QE4lq1mrN936SIdCECeYxAgBirwfhTgU3/2gT7e8G83g1smfwh
	rYYc7AyW955+1ZCqYGEoIsrobfrlGh3B9wZRGfyrisn5Nb702VDuR0R+Th4E+k05/CCy9aBqVSnUZ
	4kP8QscQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wwKTa-00000000DXH-3YaQ;
	Tue, 18 Aug 2026 11:07:38 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Steve French <smfrench@gmail.com>,
	Steve French <sfrench@samba.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: Replace Steve French as CIFS maintainer
Date: Tue, 18 Aug 2026 11:07:38 -0300
Message-ID: <20260818140738.314254-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Unfortunately, due to health reasons, Steve French can no longer
continue as CIFS maintainer; therefore, I am taking over the role with
Namjae Jeon as secondary maintainer.

Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Steve French <sfrench@samba.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: samba-technical@lists.samba.org
Cc: linux-cifs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
---
 CREDITS     | 5 +++++
 MAINTAINERS | 7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/CREDITS b/CREDITS
index 91c51c14e993..d3f60da01dad 100644
--- a/CREDITS
+++ b/CREDITS
@@ -1320,6 +1320,11 @@ D: Initial GPL'd Frame Relay driver
 D: Dynamic PPP devices
 D: Sundry modularizations (PPP, IPX, ...) and fixes
 
+N: Steve French
+E: sfrench@samba.org
+E: smfrench@gmail.com
+D: Author and maintainer of the cifs filesystem for many years.
+
 N: Bob Frey
 E: bobf@advansys.com
 D: AdvanSys SCSI driver
diff --git a/MAINTAINERS b/MAINTAINERS
index 8014b9f8253e..55f27757dde5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6458,9 +6458,8 @@ F:	rust/kernel/clk.rs
 X:	drivers/clk/clkdev.c
 
 COMMON INTERNET FILE SYSTEM CLIENT (CIFS and SMB3)
-M:	Steve French <sfrench@samba.org>
-M:	Steve French <smfrench@gmail.com>
-R:	Paulo Alcantara <pc@manguebit.org> (DFS, global name space)
+M:	Paulo Alcantara <pc@manguebit.org>
+M:	Namjae Jeon <linkinjeon@kernel.org>
 R:	Ronnie Sahlberg <ronniesahlberg@gmail.com> (directory leases, sparse files)
 R:	Shyam Prasad N <sprasad@microsoft.com> (multichannel)
 R:	Tom Talpey <tom@talpey.com> (RDMA, smbdirect)
@@ -6469,7 +6468,7 @@ L:	linux-cifs@vger.kernel.org
 L:	samba-technical@lists.samba.org (moderated for non-subscribers)
 S:	Supported
 W:	https://wiki.samba.org/index.php/LinuxCIFS
-T:	git https://git.samba.org/sfrench/cifs-2.6.git for-next
+T:	git https://git.manguebit.org/linux.git cifs-next
 F:	Documentation/admin-guide/cifs/
 F:	fs/smb/client/
 F:	fs/smb/common/
-- 
2.55.0

