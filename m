Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063613009F6
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jul 2026 08:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894397; cv=none; b=NuXXBG3Phk+xiw8Wk9zyqPD4MCI9S1C846UTZVhxyYmvKDZ/fAl4I2Ls1TzNTI4MnDcPosRBKImjOak19IzOaBJrYtjVkIN44rkeLsZXvONsCXVfa1f040cZ5/Croz0TeggQ4XGgRZR4zn5eQhNEtBJNDTcUEVm7p0nbZ2w4QKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894397; c=relaxed/simple;
	bh=wFwCvQbpYg1oq9xOfFfa0O9bxUHSIeHUXfkYJEhGshA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPKmPX8Rl7WJ7D2vj0q1AvgjDJlvaqwVlUw0s6gtNoo2sQRBosq2u6iV6DH1uTMSVKuR0VvNfl7SrOVlxa7Us6ek70Pq7d/9KRNodSDaYnQPiSY8io7atGvxsXI6n7KAf0HXhR/LxPnusgKCHJB81V5ZYvRbAsbDMXWhwrgd74A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=GNZiKwh5; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="GNZiKwh5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1782894393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2ih6Zw/QRYSoxquXlML+dt/r/wfObwgdEWNHfKHh+SA=;
	b=GNZiKwh5W6kzn4ocMneAMKHLxZ28PeXm4WoSb3YZXY8GojNtH+mpK/iXL89bof584mHt1W
	fiNZRmrbbAUlQnTmXOGsV/D2FQP0GMYpPlf85PbKzDBaubfHo6nbJO30wHuLrJPl0grbTS
	cTaOXX1CcLA7p629PC/lav44u4FD+KVIwVOLcJV3e6nyAjE3aVoJZQ9Jj8gHe7b8+ZSVYl
	///vteJQjvgvhXFnScsolbDBuOvyKsMzcyi8TXOfD/F31+v+9g7BoGmd7Izr8uCkDMLFhv
	yFghSN9WIpSO014EXxgOwHYsYg1mG2dYxcj8BwBiuE/uQsbQ7IaxJqK2fNRLow==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH 9/9] smb/client: make SMB2 change notify interruptible
Date: Wed,  1 Jul 2026 08:25:07 +0000
Message-ID: <20260701082507.786487-10-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
References: <20260701082507.786487-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

SMB2 change notify can block indefinitely while waiting for directory
changes. Mark the request as interruptible so userspace can stop the wait
with a normal signal.

The interrupted wait now uses the SMB2 cancel callback added earlier in
the series to notify the server about the abandoned request.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index d058584b8f05..56caf8cbdb0b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4127,6 +4127,7 @@ SMB2_change_notify(const unsigned int xid, struct cifs_tcon *tcon,
 
 	if (smb3_encryption_required(tcon))
 		flags |= CIFS_TRANSFORM_REQ;
+	flags |= CIFS_INTERRUPTIBLE_WAIT;
 
 	memset(&rqst, 0, sizeof(struct smb_rqst));
 	memset(&iov, 0, sizeof(iov));
-- 
2.54.0

