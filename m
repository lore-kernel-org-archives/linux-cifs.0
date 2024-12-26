Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EC6146A9B
	for <linux-cifs@vger.kernel.org>; Thu, 26 Dec 2024 20:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.178.240
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735245754; cv=none; b=k3yEflWLAJl+yR2c3ZtYt07sxsoRCSWDVE9TsTUubdn/eoVyoq5STCvzTYUW52xOv8qmXSbx6+nvWAOBHiCMrn+OGBeLg3Kj4sxQVCOXPdERy09LkEuMzYMLBCRAPa6/FlHmBh4F/URah5YKh6jgCBOszUQhJU8XG8ctSQccwIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735245754; c=relaxed/simple;
	bh=eZqooCE1zD5+W1OZHimrfQYq7I92V6fuVzDkfp7gl6c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FByFncKUVNfKn9IXYB18FMxqHBcI6koS4CD7kSOlpM8/Bubcyd+2MeZjEElbHm6oL9X14gXUF/Di9vwP2Lb7R1olnjKU0AaWY+Id1dlrnuK3OxjeB7wQbVDOdNIKvwwNZA3xF70TinpAJ31445WhmYJ9pXWDRpMcZa0E0jAIMm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=i3emYDLK; arc=none smtp.client-ip=217.70.178.240
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="i3emYDLK"
Received: from relay5-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::225])
	by mslow1.mail.gandi.net (Postfix) with ESMTP id 1C7D4C14B3
	for <linux-cifs@vger.kernel.org>; Thu, 26 Dec 2024 20:42:24 +0000 (UTC)
Received: by mail.gandi.net (Postfix) with ESMTPA id 77BDD1C0002;
	Thu, 26 Dec 2024 20:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1735245735;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=EWLJjfEAU+XMVWY66MgWQ7fGj7YOtorKqEG4w4DhGXc=;
	b=i3emYDLK6Pej/Ch/OT1sYmNanxzOrgLUc+IW09utIJQqEVv1MMu0pZH0QEorXrhp0CXp62
	8HDdNYDuCbuaKbjVGbdLHm5/ynf0AP78mF/rfllj6F3Oc3goUsTVeg/RFp6fl9+JGHhz6e
	LmZCPhPuaZFfD9UnMLSejTF+Z+EtuoAnIShpTzSMjWa00ux5awUoZkj62obl4dtBhDL0YO
	bmkagkcVARkxoMRrLNo0o2QtMzxFHG3IR8QlzQDG48tLKeaJrrGpNtquF3KlTezyEDYZvT
	Xb2G++2LbE2Nriy4GTTyc86DQCrYj3XdYgdN30vJhaiNLCl1moCk6lW3VedOAQ==
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To: Pavel Shilovsky <pshilovsky@samba.org>
Cc: linux-cifs@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH cifs-utils] configure.ac: libtalloc is now mandatory
Date: Thu, 26 Dec 2024 21:42:12 +0100
Message-ID: <20241226204212.2311264-1-thomas.petazzoni@bootlin.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: thomas.petazzoni@bootlin.com

Since commit c6bf4d9a59809fbb0c22ef9eb167c099ab8089fb ("Implement
CLDAP Ping to find the closest site"), libtalloc is mandatory to
cifs-utils. This needs to be reflected in the configure.ac script to
get a failure at configure time and not build time.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
---
 configure.ac | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/configure.ac b/configure.ac
index b84c41f..b74358d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -133,6 +133,10 @@ AC_CHECK_HEADERS([arpa/inet.h ctype.h fcntl.h inttypes.h limits.h mntent.h netdb
 AC_CHECK_HEADERS([sys/fsuid.h])
 AC_CHECK_FUNC(setfsuid, , [AC_MSG_ERROR([System does not support setfsuid()])])
 
+# libtalloc
+AC_CHECK_HEADERS([talloc.h], ,[AC_MSG_ERROR([talloc.h not found, consider installing libtalloc-devel.])])
+AC_CHECK_LIB(talloc, talloc_init, ,[AC_MSG_ERROR([talloc.h not found, consider installing libtalloc-devel.])])
+
 # FIXME: add test(s) to autodisable these flags when compiler/linker don't support it
 if test $enable_pie != "no"; then
 	PIE_CFLAGS="-fpie -pie"
@@ -177,16 +181,6 @@ if test $enable_cifsupcall != "no"; then
 			[Whether the krb5_keyblock struct has a keyvalue property])
 	fi
 fi
-if test $enable_cifsupcall != "no"; then
-	AC_CHECK_HEADERS([talloc.h], , [
-				if test "$enable_cifsupcall" = "yes"; then
-					AC_MSG_ERROR([talloc.h not found, consider installing libtalloc-devel.])
-				else
-					AC_MSG_WARN([talloc.h not found, consider installing libtalloc-devel. Disabling cifs.upcall.])
-					enable_cifsupcall="no"
-				fi
-			])
-fi
 if test $enable_cifsupcall != "no" -o $enable_cifsidmap != "no"; then
 	AC_CHECK_HEADERS([keyutils.h], , [
 				if test "$enable_cifsupcall" = "yes"; then
-- 
2.47.0

