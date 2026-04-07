Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08042DF701
	for <linux-cifs@vger.kernel.org>; Tue,  7 Apr 2026 14:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775573243; cv=none; b=dpJ9Vqyp+vLu28IcbcvwKknozHETLDwFgGUVGzkAgX2CUFXh4eYuqUt9gdcndquXqs327jxdTaOaphDUb40sqCbqjpyKu7mAGyenoy1HauDYb2dVo5TfN6hFsALqGrkGaZtNuxiC0z7nRcFRoDunT/aQY3PJkV8Mkiy1J6UCXHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775573243; c=relaxed/simple;
	bh=401OQXpYjNnWktwNdBMgREdJD0/+Gbeba6l8Xw9Z9U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rlg/pNCfkWJ295yAsctntRbkwm0DFiSCZ7+9Mfmy8zai0iQ/Xs8i5kMZ6ffpgXHhtsvHuXCm1c7+XHoIspgETxFFkrqLle1mPQ9T9DwpSFwmUDSvAkOz5XOKikdjKwSye5WXHS9Xi5ZM75ffAN4Z28ZtWc00fr6/WQWwEiI5CHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=f8vuBLeI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="f8vuBLeI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=+aLr7Jx308i7RKbvPfKZkDhfRRWRdiVJAQVB/WEBH/Y=; b=f8vuBLeIMFZJV9t0YK4w949DVB
	i5fsBRexWiTqu50pMDoIU/7I6BvfKmckdDv6D0eL2lLrqQMIRVf3h/5+UDHqAOkAY6kGa5Aws+tvo
	nbhYkViNA3KNI6r7mIx74Q6Bmj0T5kPbt2t0tDXdtEaNr6xsJF9EYMFto9HamO3GsCVpWbeTnpYWh
	GxLr/hnrQVYY+xxOQ0zzzvfoSwvF1n6S2/e9Xk9FVSvsS5NElKloH1KwaOZfg2XqZaqD2b58WrXXX
	gaeWgIbXaT36rGIUc7fOKd/TJhxeFNKKC+WK1U0T11s/85LJzrQfn8IuUWZE88hSBnwHb4p2qNbp7
	BDey3cWYdlYXsvaq8eFZO2g7LPlAlXL6vxf/emwfTsp8AOBYF6QlnNe0VbS4F1ncIx48ysYfWr/cr
	19ihPZlqPEwBX4CrtySv2KPl2yZnZUH1Bc0kjPjRYoGvyAK2K5H+AYkh/etefsoNeCSOHr2QhRnji
	Aaria67Wat1iZasbMj3WlcWA;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1wA7i0-00000007WP3-3PUm;
	Tue, 07 Apr 2026 14:47:16 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 2/8] smb: smbdirect: fix copyright header of smbdirect.h
Date: Tue,  7 Apr 2026 16:46:28 +0200
Message-ID: <6fc5a7bedca85319de2327e2631aa50ad3d5ab2f.1775571957.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1775571957.git.metze@samba.org>
References: <cover.1775571957.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Everything in smbdirect.h was taken from my out of
tree prototype.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/common/smbdirect/smbdirect.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index 8fbffe3eb845..bbab5f7f7cc9 100644
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -1,7 +1,6 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 /*
- *   Copyright (C) 2017, Microsoft Corporation.
- *   Copyright (C) 2018, LG Electronics.
+ *   Copyright (C) 2025 Stefan Metzmacher
  */
 
 #ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
-- 
2.43.0

