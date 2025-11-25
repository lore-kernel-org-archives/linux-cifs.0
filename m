Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF0E329C7A
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764093993; cv=none; b=LGeepGs23qmBLcMs6OyMTjGyJsMFLLJqbZV2gTchh1H2BYmgeCaTd0AdFc/saWNmALEpFBJ52ZgVTS0PLpJlms52kb4aNqAARtoJbaHvO109n1QoQOysBU1udPOxDKV6TofxrDJwMn4LFPBg6lZibJMGKPufWbRXmciRFEULhLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764093993; c=relaxed/simple;
	bh=j0z66400zu2cstprnISMJ8n6mMsBTiGcfIkNF1sgg9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NxFwHpzqppl9nKZKIzg1/F/kJQr+sECHpCk+kfa47C3Jo5ZbO3nHRZlw+NJs3mOLJgZGt3g9fV/tBrEjfLGgy0jJLEISquywNvlYhe8hwIevt3OU/spJ/SyrFv/nX2aJhNFIjMFBRSUkAMo0ilJgkfBEys8T6pqV6/0er53dW/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1B20a+Q0; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1B20a+Q0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=O5TZrCEzx9fXdVqdrnYPrOkY2ZAOv0dCwnMvKH5CJac=; b=1B20a+Q00hW0FyKVoJS7PBsToi
	0ZaggpSRzuAzF0Fn2XCpFhgfO7sq4OjhA6Nzd2MgfsDRzlfqtOCLphX4ChnJDWeCR7x7N/Iat/PmC
	mCGbdSf4hC+bFhs2t8o+acCKQQlfC11xoay7hsyJlgJOfO1QWbonp4WA2EL/Q7detmegAv/AupQFD
	0lSOAfBs8chrEddpXWFcnO8CZJBBlc4j+goTG08jtwy3wY4N9kpwyRnoBuq4qwzj9oe0Tj1sQCsL+
	f/e0pjWmLNCe0Oia1ShGW3mA5HGKYeKspkT0GbrRUwph6nuKltVn5YVaqZACS6QDEiiRk8Q3hMKPU
	YF5bR4JDz4WH5EVh29be2lpRJmPF5Nhgcd5oQ0NzI3ClVkvT/ULHuYXu3uEEGlVqOBG9fGldhhJZz
	RM0fq1RbSGNsTeIr3QtD+VEI89VQywsxwQjU24oeqZUuQK8tKkueoZVZCBVj6RomL0bviNlVCkXwi
	JDDgfn+FGUEHD/+r851EmA0S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxNu-00Fdbv-13;
	Tue, 25 Nov 2025 18:03:27 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v4 064/145] smb: client: let allocate_receive_buffers() initialize complex_work as disabled
Date: Tue, 25 Nov 2025 18:55:10 +0100
Message-ID: <09e1ec4a68cbfa5b6f3a6bf53cfed266cfc42576.1764091285.git.metze@samba.org>
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

smbdirect_recv_io.complex_work won't be used in client until
the end of the move to common functions, but common cleanup
code will call disable_work[_sync]() before that, so we
better initialize it now.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/client/smbdirect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/smbdirect.c b/fs/smb/client/smbdirect.c
index 4dae3d1eb93e..33f3cbc0bbd9 100644
--- a/fs/smb/client/smbdirect.c
+++ b/fs/smb/client/smbdirect.c
@@ -1543,6 +1543,8 @@ static int allocate_receive_buffers(struct smbdirect_socket *sc, int num_buf)
 
 		response->socket = sc;
 		response->sge.length = 0;
+		INIT_WORK(&response->complex_work, __smbdirect_socket_disabled_work);
+		disable_work_sync(&response->complex_work);
 		list_add_tail(&response->list, &sc->recv_io.free.list);
 	}
 
-- 
2.43.0

