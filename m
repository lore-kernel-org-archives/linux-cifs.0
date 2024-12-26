Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B85145FE0
	for <linux-cifs@vger.kernel.org>; Thu, 26 Dec 2024 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.183.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735245767; cv=none; b=QYI4qiNRWFc6kN+/LzYUeg2h3iQwYOABk08IWnAPlHMGKRikH/MN58Qur/99BVMcXi/lUCm73HIvm+8fugLjA8TVE7RKh2dPOh41vDfGka+ES1Nsdp8yoE+1fywQbC1YYOmO1AvldsGtqsgZnu7y21qKf9aaXrnjjnA02iONA/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735245767; c=relaxed/simple;
	bh=2ywTf+7B3zo6m1vEm5tlbtVRshDftlibWkys8v8+CQI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=aa50A3NRLJpzybxoXjTV3Ht9OdYG8GyQa776An/U14Tn4Bxxinb7xs65nl73+LdKUHY5GGv8/e/J0kbWcvrXkK6cROKI64qjJz/mtM+CBDU0aeRkxgBkJeZiqKz/9soPHpkIHbvvzol2oS8zASlBERgWOlpYyNzWIYkAYdVyhaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=nQU2ES6K; arc=none smtp.client-ip=217.70.183.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="nQU2ES6K"
Received: by mail.gandi.net (Postfix) with ESMTPA id D2894E0002;
	Thu, 26 Dec 2024 20:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1735245757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3os7uJsNz/GhyiWeD7uIGzFpGqocbU7va6tGT9khDPw=;
	b=nQU2ES6KvaLJ1OFjncpqJX5KVqcEwv/oyvawPZ69z+fNGZSF08ylNu0HuNdSv0tpOo8zd1
	sRBsr0V+6PeXlmpF+rOCx0PlfrvnG+9OOMgAlMIW/WqqZHjHORm23QDHDBygrcVWsEKEqC
	0ARvIedgfa5uUVCc63GvfJMboYFNnzZjkLjn3aDDfLKUXk/EyJ/NaAwLb5KoVNIBhwN9Wx
	NYKPU8k+HiPwivMkb+KP7ViwVrKPfVDlhlEns0+4ew5wuDvWQnswBSD/QEMwzOlTDaIkNW
	DzvPF9M/p8epibzkpUy6jzFAwIDhPZJcRF75A6jVrGNi1X+nUAocCcLwL/JZhQ==
From: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
To: Pavel Shilovsky <pshilovsky@samba.org>
Cc: linux-cifs@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: [PATCH cifs-utils] cldap_ping.c: add missing <sys/types.h> include
Date: Thu, 26 Dec 2024 21:42:35 +0100
Message-ID: <20241226204235.2311371-1-thomas.petazzoni@bootlin.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-GND-Sasl: thomas.petazzoni@bootlin.com

Fixes:

cldap_ping.c: In function ‘read_dns_string’:
cldap_ping.c:72:37: error: ‘u_char’ undeclared (first use in this function)

when building with the musl C library, but even with glibc u_char is
defined in <sys/types.h>, it happens to work with glibc <sys/types.h>
gets included by another header.

Signed-off-by: Thomas Petazzoni <thomas.petazzoni@bootlin.com>
---
 cldap_ping.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cldap_ping.c b/cldap_ping.c
index 9183b27..a603be3 100644
--- a/cldap_ping.c
+++ b/cldap_ping.c
@@ -20,6 +20,7 @@
 #include <talloc.h>
 #include <string.h>
 #include <sys/socket.h>
+#include <sys/types.h>
 #include <arpa/inet.h>
 #include <unistd.h>
 #include <resolv.h>
-- 
2.47.0

