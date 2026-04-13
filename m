Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCEB53AC0DC
	for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 09:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776070804; cv=none; b=if4cIgg+Xle0q7mUHITCVxJdth0b6CXq9+3n/wjlp/mBp10IgqyK0aqk2jAUV5/3ePLHGF51AgQf9q7QxOr6xa3bLVSGNuEhQttuVTQGzNZN3affsc4EQRuC1+X/bkcKOv6osRVCI6QmlbUDokCMsvdnU9jX83PTj+aVjSP4rD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776070804; c=relaxed/simple;
	bh=4mzML9+7ImtcwlYZY6CyYI203HbmZJ7jqaHEyl+MrIQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=A8j/qEevjqPTTMs6av3ag3GIaErJFGplKDXhAEXSxXFFZY2ocMcfvUA32kkz0iaxVhqVuFYRVDHyaOl9KTmcbU5G5OTOKvGasxSLeynDhvDJPkfoOhx+9FKV3s1TE//ZyWc5p4vi8tFy39CDtpav/zumkEc+2aGFJ/gh1n9EEhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZIdAzjIr; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZIdAzjIr"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b2494440f3so13843645ad.2
        for <linux-cifs@vger.kernel.org>; Mon, 13 Apr 2026 02:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776070802; x=1776675602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4QuZI8wnRGhW1JqAONcbEsHyBYLDeETAby1pSr6OKFM=;
        b=ZIdAzjIro00fIoiRfaJkkHZ59ftU128ap+lDAJQMgMLLpDIH0cFqae0DGj33ij7727
         KpiexLxpE+9SbKl0RXtlsYulrwIbihZKg7+Wx07mR/RvjsQzJVhEPNZuah87UWDoV/uj
         zyYFBonQm6z9KiKq5AZUDhSIsx6mdfBy1MI125ITDpwyC/gd5Sr56ebAtoC2PDiYtx14
         wKbON6WrNNUxQkjVnl3dV4sh5YxSoePH7vnchl5atg3MKngHg08DDlGey/aNHTovCOio
         rcB39td3ALHNzg6gBvjdXTGI1OenfYQ8lnJ4oBq8X62Y17LmV8N4DRDlUYkD5ASec08F
         Bjdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776070802; x=1776675602;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4QuZI8wnRGhW1JqAONcbEsHyBYLDeETAby1pSr6OKFM=;
        b=Yqo74p/wSlsqT0wzylVWjY1tKzvLGqmTk8aId3A1NOwS1UYaeqtu05DKiZNc0UguPB
         bHwYO0HMcqXdLeS3PEyzYVeJnYEZBGFWdEg/3VlFIeZTkFjfRDeaVB2/L/s5S+TKubOf
         uu4Q2BI9dG8cWacbCifthujWqU+TGFBTnVcqZMT1botoChefsu4pXcRLBcEq4cqr+kg3
         GJFNQdgRrCNq0SxFaxlS07U9VXZ8pRWcDt4PfUrtnb6moOhoOk9f/n1vE0FhHMbjrdO5
         4hsFU9yFMIXGT9d2K2tieOsjqlyMV1LWyjPpfIozzGSb32DrnvInLxBI5rdT5GxlccRp
         CjxA==
X-Gm-Message-State: AOJu0YxIDczuc7q7P8qq3qRu1hBJ1OaF/zRuODflWAOOMQGxwLwPqZV0
	uYqSEghxgrG4rinEHw2vUBf7eFeLa5zS69g/qEp8Ad8Zj6XEvhUJ1+nKkxdZFg==
X-Gm-Gg: AeBDies8r8VjmJZaGclZWsXq4TJp2BlA4WlrnrjiHZ0aZn8FNm0vHQm6KEkqt1HiZCG
	03Th3y64MN6atm1Yq2S+n8AvyYaTzL1mME/DCytRrbLsPTkDgOmo78El0Mn27/NE3UfQQy4PYSI
	ezxh3F3+o5eu78EA5SgodBBWWc1kxMr82athqI2712X9e6K6/P/xDvg3D0qWiUnHoGxvRbGXXlN
	RuXaSAIZzVJd7s0oYReBJCvWmezj96fgtY6JDqtwrMrqxrbh/NEv6MJphhXZDzNk9hLTFxsGaZe
	iKxP2CxC01VbUOJ7p71FKx8l3YtICquRGDQhrUm4x08olPgvExU0mx7z5D8iyCIWAzSX6XGp8ue
	hxzRqCgk10oP8yhYIhqlHWgFHZ1oSvhT3hjwxiddtAvdHFEh5XP0w7kESXc2GUO3UkxJWQvlh8p
	sPAly48Q58iOj0dLcuyRRjDKhGT5AD4+lLuB5IG8b251Ou46XS8ienS/1TZIj9GZpT
X-Received: by 2002:a17:903:1c1:b0:2b2:42da:25cc with SMTP id d9443c01a7336-2b2d5938b87mr123612545ad.1.1776070802050;
        Mon, 13 Apr 2026 02:00:02 -0700 (PDT)
Received: from gmail.com (69-172-89-235.static.imsbiz.com. [69.172.89.235])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4ddb742sm111717455ad.27.2026.04.13.02.00.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Apr 2026 02:00:01 -0700 (PDT)
From: Dudu Lu <phx0fer@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: sfrench@samba.org,
	Dudu Lu <phx0fer@gmail.com>
Subject: [PATCH] smb: client: Fix integer underflow in receive_encrypted_read()
Date: Mon, 13 Apr 2026 16:59:57 +0800
Message-Id: <20260413085957.77355-1-phx0fer@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In receive_encrypted_read(), the length of data to read from the socket
is computed as:

  len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
        server->vals->read_rsp_size;

OriginalMessageSize comes from the server's transform header and is
untrusted. If a malicious server sends a value smaller than
read_rsp_size (sizeof(struct smb2_read_rsp), ~80 bytes), the unsigned
subtraction wraps to a very large value (~4GB). This value is then
passed to netfs_alloc_folioq_buffer() and cifs_read_iter_from_socket(),
causing either:
  - A massive allocation attempt that fails with -ENOMEM (DoS)
  - Under extreme memory pressure, potential heap corruption

The existing validation in smb3_receive_transform() only checks
that pdu_length >= orig_len + sizeof(transform_hdr), which does
not prevent orig_len from being smaller than read_rsp_size.

Fix this by adding a check that OriginalMessageSize is at least
read_rsp_size before the subtraction.

Signed-off-by: Dudu Lu <phx0fer@gmail.com>
---
 fs/smb/client/smb2ops.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 509fcea28a42..ca90f96052d4 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4943,6 +4943,14 @@ receive_encrypted_read(struct TCP_Server_Info *server, struct mid_q_entry **mid,
 		goto free_dw;
 	server->total_read += rc;
 
+	if (le32_to_cpu(tr_hdr->OriginalMessageSize) <
+	    server->vals->read_rsp_size) {
+		cifs_server_dbg(VFS, "OriginalMessageSize %u too small for read response (%u)\n",
+			le32_to_cpu(tr_hdr->OriginalMessageSize),
+			server->vals->read_rsp_size);
+		rc = -EINVAL;
+		goto free_dw;
+	}
 	len = le32_to_cpu(tr_hdr->OriginalMessageSize) -
 		server->vals->read_rsp_size;
 	dw->len = len;
-- 
2.39.3 (Apple Git-145)

