Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E59B715ECD7
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 17:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093411; cv=none; b=K5wRu5nCYilflKikldzMXf699g+4oKPKfi5LX0BOzuryySE8J8JTp4aepDfFIR+exvCwBwX0MJoRwqM87RX3WgO872rRLXMe7m307eSelzIhYrvK7pzSyTkiJwMaYcxv69v2bGT1kR0sv59UF0kjXQ0u13h4EuSoU/Bjm3tRa3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093411; c=relaxed/simple;
	bh=85BCkOtvGOghOcDvfgv6qLhpdhaSuW11ZArMxJvUWRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b2/8n9XVOeOcY9g9DiA+xvvxscAot+inQvQsdo1Cf+snaG7WfPOcahlSAO7t/HStjFZp/r4/d85K80ngSA6CtZepOwGptvXrrHhI4z0VCj3sj50dsvNDkeb0e0rz9thrbg3ztRjwp41rTNcrBmZHM9De+LcN+nSgQWMNGPei8ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=sTmT3nOb; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="sTmT3nOb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=iTyNId3h/Qps3V/EhOJfspZYMDnozKU0ouGiLtQMaJE=; b=sTmT3nObMV7JYBaoc2vKKv3R66
	8jci/EVGpNrkV+4TuNXwN5TdGF+ezxQNmQa7ya//7CcmFEDws0lCxwrAIZCmmvHpYd+xBqvTQfGnk
	OzXTNXJRY7UMkcKAeYQWUcguTODMSxqdHprrelkr+S37ZJ62ReR9y7yuTjLUFqhvvsIwfgw+tq2vO
	YQxrfva0eJk1+UHVNxZM3fHI0KcTSL5WGOKbiiENd9boh2vgYEq+CbBZpjXYGXKItnKFfgi8eKHSm
	pnzgMmdIn/FOsKd60f2yvXI1BB+uImjyHntI1Mlky7D6UVCQpNbKCrdgVruMoHha0Nv1MFCTB39Xz
	PZExjcyxVt2jdxxgSSiQBrM3NBwN19Nefv8eKhsjaSQfYjdeKXZxc8IMFlhwfTt694ybI1pEjNy29
	bdH/8A6LNmjN9xPy5Boml5WzGfWKOgR99NRLBZoqfaaK4WWWEqott0zuIngF5KsmOEfXF8MQCsI8R
	qX1atq+ek1NXMkS8IUkTp3eE;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxHS-00FcSo-1c;
	Tue, 25 Nov 2025 17:56:46 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH v4 001/145] smb: smbdirect: let smbdirect.h include #include <linux/types.h>
Date: Tue, 25 Nov 2025 18:54:07 +0100
Message-ID: <20c22b16817340d00cd310e2e09e1d74ba0b488d.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This will make it easier to use.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/smb/common/smbdirect/smbdirect.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
index 05cc6a9d0ccd..821a34c4cc47 100644
--- a/fs/smb/common/smbdirect/smbdirect.h
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -7,6 +7,8 @@
 #ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
 #define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
 
+#include <linux/types.h>
+
 /* SMB-DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
 struct smbdirect_buffer_descriptor_v1 {
 	__le64 offset;
-- 
2.43.0

