Received: from mail-gw02.astralinux.ru (mail-gw02.astralinux.ru [195.16.41.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66C326159F;
	Tue, 25 Feb 2025 09:42:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.16.41.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740476536; cv=none; b=XRgkx3goNHTKzB58hI/eacy5L8kI8yytxW9dt0ELJ0gH0sFDZqSEEs/vBr+URYr9hZn4fIAeI6qzonAlLdzL5fhiA2ytHdUpzS0xIs25Jwwr09B9FWNXqkQamYCRxEbiYuSeO/XMByKHl8Ucj2fxQHGtfhM7SPYwCH19ZoF4VmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740476536; c=relaxed/simple;
	bh=eks3Lc85HLhbzd/HK40pZLMZF+S04fiYW8t+tU+g1cU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=myoXAJgZACH0uLHfNrorBUln2fm2dvOaAjTyCFnhCj4b7tquLwz75E3bHi+GhiJBiT4d4cPyQcYiHIJ5OBE4WqK8vxu+BHgwI5EGX703IcMKlSz8vQpMrk3kGB7dAchh5dOlH+sxyXEGCiwuNIb0NJyerLafJckCW/mP3Ow7hkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=195.16.41.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from gca-msk-a-srv-ksmg02.astralinux.ru (localhost [127.0.0.1])
	by mail-gw02.astralinux.ru (Postfix) with ESMTP id 030021F4D2;
	Tue, 25 Feb 2025 12:34:44 +0300 (MSK)
Received: from new-mail.astralinux.ru (gca-yc-ruca-srv-mail03.astralinux.ru [10.177.185.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw02.astralinux.ru (Postfix) with ESMTPS;
	Tue, 25 Feb 2025 12:34:42 +0300 (MSK)
Received: from localhost.localdomain (unknown [10.177.20.114])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4Z2C9s0QtQz1h0NN;
	Tue, 25 Feb 2025 12:34:40 +0300 (MSK)
From: Anastasia Belova <abelova@astralinux.ru>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Anastasia Belova <abelova@astralinux.ru>,
	Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	lvc-patches@linuxtesting.org
Subject: [PATCH 5.10/5.15 0/2] smb: client: fix UAF in async decryption
Date: Tue, 25 Feb 2025 12:34:22 +0300
Message-ID: <20250225093428.611253-1-abelova@astralinux.ru>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: abelova@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 51 0.3.51 68896fb0083a027476849bf400a331a2d5d94398, {Tracking_from_domain_doesnt_match_to}, astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 191262 [Feb 25 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2025/02/25 08:32:00 #27449984
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1

Commit b0abcd65ec54 ("smb: client: fix UAF in async decryption")
fixes CVE-2024-50047 but brings NULL-pointer dereferebce. So
commit 4bdec0d1f658 ("smb: client: fix NULL ptr deref in crypto_aead_setkey()")
should be backported too.
