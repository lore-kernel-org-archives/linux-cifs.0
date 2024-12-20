Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BD7225A30;
	Fri, 20 Dec 2024 22:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734732025; cv=none; b=oL7GRuQmIOlWLn01LhikEEeKh4Le8FQ7JWn8Bj4ROPETnLvP9kM52c3v3eXp2mL4B0R7LEIzVh4rGwAt0utGeO5wWpCjfUWl0KT6oUrZy88tFxnDFWxTwq8OcZYZR1GhnH77LPA1kbHgc46WDxRu59qUjyPbn2QuJB4b+GrYYiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734732025; c=relaxed/simple;
	bh=N+HFtWfX0nosQZ66+74h5MBDUgYszOwWerV+0GmT2XA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TZ1zbCO0MbdPaKRLp5kF4r+5sAtlvKZEZKvQqbq2ZZjwoG1HVn+U9TUz2/DRYB8s15tGpbiEPVZ2ODHaMYF3pGGQS8WC9/o0y1Gf8VYm4XXSVoBhhBPRrGHOHdbScSPkG+JJIYqW3+YO6nip0y3Wu3dzYh8mr+4JpozNBSvh0ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=A76R6d9x; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="A76R6d9x"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=MIME-Version:Message-ID:Date:Subject:From:Content-Type:From
	:Subject; bh=7iUbqS7JWnZ3ax3uSOMzFtIQXtN7rO5/oWPnrE/sF50=; b=A76R6d9xE4oc0etr
	4p/N70jyFP/e4TKttJARAM9ekG3bi8GNisFGRbjB9946X6uIKjJRJcI8i2igSzTjYpsDB6RolXwNY
	c4G/N+Zd/XFTaMErN2r9wWeYzuSrpBgGe0QbZlrItklPFDDWSQQ8u0sM5vWLfpk+R9X1rtb4LcCCu
	WdiA1DLX7b2f4IYfIOK+yI9OZkoqaP1mYSnfBRUT8vAVt0J4QQO6ktbFTcuCkShZM+IekyQtv+CaO
	CJyxQNbm0OrAfRrmgTTOL9NtzgorI+VooWecepO7uqPPpdxaPYrMMRrfOJ034YqO2gnLPbvpdXHHz
	pAGz4DxXbs1UHb0oCg==;
Received: from localhost ([127.0.0.1] helo=dalek.home.treblig.org)
	by mx.treblig.org with esmtp (Exim 4.96)
	(envelope-from <linux@treblig.org>)
	id 1tOl2R-006cqt-0w;
	Fri, 20 Dec 2024 22:00:03 +0000
From: linux@treblig.org
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	"Dr. David Alan Gilbert" <linux@treblig.org>
Subject: [PATCH] cifs: Remove unused is_server_using_iface()
Date: Fri, 20 Dec 2024 21:59:37 +0000
Message-ID: <20241220215937.233721-1-linux@treblig.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Dr. David Alan Gilbert" <linux@treblig.org>

The last use of is_server_using_iface() was removed in 2022 by
commit aa45dadd34e4 ("cifs: change iface_list from array to sorted linked
list")

Remove it.

Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
---
 fs/smb/client/cifsproto.h |  2 --
 fs/smb/client/sess.c      | 25 -------------------------
 2 files changed, 27 deletions(-)

diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
index 754417cb3294..d26f9bbb5382 100644
--- a/fs/smb/client/cifsproto.h
+++ b/fs/smb/client/cifsproto.h
@@ -614,8 +614,6 @@ int cifs_alloc_hash(const char *name, struct shash_desc **sdesc);
 void cifs_free_hash(struct shash_desc **sdesc);
 
 int cifs_try_adding_channels(struct cifs_ses *ses);
-bool is_server_using_iface(struct TCP_Server_Info *server,
-			   struct cifs_server_iface *iface);
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface);
 void cifs_ses_mark_for_reconnect(struct cifs_ses *ses);
 
diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 3306fb655136..91d4d409cb1d 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -27,31 +27,6 @@ static int
 cifs_ses_add_channel(struct cifs_ses *ses,
 		     struct cifs_server_iface *iface);
 
-bool
-is_server_using_iface(struct TCP_Server_Info *server,
-		      struct cifs_server_iface *iface)
-{
-	struct sockaddr_in *i4 = (struct sockaddr_in *)&iface->sockaddr;
-	struct sockaddr_in6 *i6 = (struct sockaddr_in6 *)&iface->sockaddr;
-	struct sockaddr_in *s4 = (struct sockaddr_in *)&server->dstaddr;
-	struct sockaddr_in6 *s6 = (struct sockaddr_in6 *)&server->dstaddr;
-
-	if (server->dstaddr.ss_family != iface->sockaddr.ss_family)
-		return false;
-	if (server->dstaddr.ss_family == AF_INET) {
-		if (s4->sin_addr.s_addr != i4->sin_addr.s_addr)
-			return false;
-	} else if (server->dstaddr.ss_family == AF_INET6) {
-		if (memcmp(&s6->sin6_addr, &i6->sin6_addr,
-			   sizeof(i6->sin6_addr)) != 0)
-			return false;
-	} else {
-		/* unknown family.. */
-		return false;
-	}
-	return true;
-}
-
 bool is_ses_using_iface(struct cifs_ses *ses, struct cifs_server_iface *iface)
 {
 	int i;
-- 
2.47.1

