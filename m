Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C371D9663
	for <linux-cifs@vger.kernel.org>; Tue, 28 Jul 2026 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785281743; cv=none; b=YDIXnyUrtY/5VDR1FOn5jGzovu3ahvfSW6E3PhZOPyg8lqDrrLcl18hNVijLp33YbYXfa/QrS/ORl1nX14dpEzLaoCNEjDMjA+PLn9dBsMAjo4bIGLN+As0bMtRKRNpmCeLbZ1x1v+kEuOgoHpAGaCNfXBP7VkTGorhX2fxLNEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785281743; c=relaxed/simple;
	bh=ZLRHtF6xW8jYzSRhd6/rJ93bQVjNDDN694wbXmNjqzE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B/gblLTj2VxiFwKLG37StDsOEsgBC9azIgCoZ3rL6AZ0XWAXFz45XKcquSPv5bXZ0jZdlI5tggOLNVYbeJ8xB11wnna4NeVy3lSHy6q8fScu1EDx6ktmrHTSlVYOWWpayv4KXIp4LRCs026FBXTFu4Uix2Bc0TwCC0dtpgyDQ+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=9JWYeqA3; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="9JWYeqA3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=F/pjXSZ1nUQyxdLmrKCOLdIQdiHgbZIlQvZmUtRJld0=; b=9JWYeqA3mF6Sstkh9mfrXKMpcG
	TEETF4dN+FgIosLGctBESbfJXGX4ISVFSeHWH5sz6qv4zcXyRZ60MGD1C+0/d/K6XX2yT972a5B3c
	/A4lGJd0Md7xdCba9N44lypNCcSNf7/JW1RU9KtNGUeIbFimxx4JOB9yu2dNiJHCAttn6WymdWNOi
	g+Xmy/hmJqY2nNKLs/bAPXDXoiROWGiqA6lCnsSuXB8iNX8zxuWr3YWcj+Acsk3/dI5D+9idw3+ie
	s4uqiD/Y5ur1/I/Onc/914WCrI3FFsWyiFPnlmkA32wID/7ko7tkkaJrMhTMDli0SzxpDK2fReww+
	XA3IfZ2Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.4)
	id 1worKf-00000000CM2-0duK;
	Tue, 28 Jul 2026 20:35:33 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] mount.cifs: prevent stolen creds through SUDO_UID
Date: Tue, 28 Jul 2026 20:35:32 -0300
Message-ID: <20260728233532.3022799-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When mount.cifs is invoked with setuid, a non-root user may set
SUDO_UID to be used on the retry kerberos authentication path,
therefore allowing it to mount shares by using credential caches from
different users in the system.

Fix this by trusting the value of SUDO_UID only when mount.cifs is
being executed by sudo or root.

Fixes: 1a1507654c5f ("mount.cifs: use SUDO_UID env variable for cruid")
Reported-by: Daniel Birtwhistle <daniel.birtwhistle@gehealthcare.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org
---
 mount.cifs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mount.cifs.c b/mount.cifs.c
index b57c7d346f42..f0e9bc7beae2 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2145,7 +2145,7 @@ int main(int argc, char **argv)
 	int rc = 0;
 	int already_uppercased = 0;
 	int sloppy = 0;
-	int fallback_sudo_uid = 0;
+	int fallback_sudo_uid = geteuid() || getuid();
 	size_t options_size = MAX_OPTIONS_LEN;
 	struct parsed_mount_info *parsed_info = NULL;
 	struct parsed_mount_info *reinit_parsed_info = NULL;
-- 
2.55.0

