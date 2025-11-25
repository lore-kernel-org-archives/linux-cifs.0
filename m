Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B5E27510E
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764094716; cv=none; b=Vx071in9rrb9ZuEIdnAIP0NjCEgI1E0YauEMpabg0i1Jd5q05WgxziqwmEXlvogjU54VczSan9ZzGUwqtVrZYszGdL24zOGtJriiPwquKBJGGtbGEB917l8o9kBdKdZ4TsIlB2FJlVnkO06V8NOBOmW0mPpLQw7sUU9SXNG2VC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764094716; c=relaxed/simple;
	bh=Gz71rZbrC9Wyaoq5OiPP094JhiMbN4Sp2DoKPPMlmaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjfP8YVmGUYdZFNW8K++41Vy2llwrAI/gETmMcNou/IpbFwK5B2GndqZEtli2BSQlYfsObpfTwQo+wZVBqa2WhezwBEmF8gfBDBtBRjaKhXiSZ/z/6kTBp2XzgawUO2GkwOxH4LRZByjbzBuIQ2xt968rRW3MtHg34HW1zeU0I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=XJ7fJsqG; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="XJ7fJsqG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=41L0fkzGjZtw7n+AyUud5AU25hqjHZxA/9myhEm3YKw=; b=XJ7fJsqG49KQdiJXKbpYSnxbS7
	06mjmqEIhfY2DhACHSAGwQBUQ9E5+XHqvhXKHr0wGTQqZf9kjcNdIR2V4gFArw37IOKps8TEelHG+
	38d+ZGZq84E5bRTCGJ6MDNFr5Znhc3ED4sy4atNQ1haKPfq4eMBUJWO/295xX2WtThqxIUpR2Bpo5
	57v1zxhwvWXWqc0/FHeZhbb9nNm7Txq/I08k7TilhL4qKzLs6HV4/BeqyrlFip1ehHjfHUr48LUj2
	x3mvX+yqz+qLIfxJVN3j+1eIA+4s/XvvAWVcZxWqHpjv2lpS9Lu15Fm2Z+YHXUtnT7LkT72jMX8uM
	xLxUEARqjcXjqLH0Ib9ylMOmlWuandQK05hDlG0PrKDTckPFaQxzdtNKuL9X/TezZiZeWv3DMaQan
	AkOBS7QOFQaGkWvQI9a8QcsX9ien0RDIAfacw8GjBTDnfeLHGzmZh/aVo+pNaUNDOOmX9GQLvCAoo
	N4laIb4Jhu0vC7ixmIVKCnwo;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxUw-00FeGH-2e;
	Tue, 25 Nov 2025 18:10:43 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 100/145] smb: server: let smb_direct_create_pools() initialize complex_work as disabled
Date: Tue, 25 Nov 2025 18:55:46 +0100
Message-ID: <1a1977dd7651c7e9e1cc31b054d74c64421a7d8a.1764091285.git.metze@samba.org>
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

smbdirect_recv_io.complex_work won't be used in server until
the end of the move to common functions, but common cleanup
code will call disable_work[_sync]() before that, so we
better initialize it now.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/transport_rdma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
index d61c95eca0ee..84da674bef85 100644
--- a/fs/smb/server/transport_rdma.c
+++ b/fs/smb/server/transport_rdma.c
@@ -2107,6 +2107,8 @@ static int smb_direct_create_pools(struct smbdirect_socket *sc)
 			goto err;
 		recvmsg->socket = sc;
 		recvmsg->sge.length = 0;
+		INIT_WORK(&recvmsg->complex_work, __smbdirect_socket_disabled_work);
+		disable_work_sync(&recvmsg->complex_work);
 		list_add(&recvmsg->list, &sc->recv_io.free.list);
 	}
 
-- 
2.43.0

