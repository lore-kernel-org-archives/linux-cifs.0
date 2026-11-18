Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795004844;
	b=VcYs6cvlK/nE8KOXo4CCZgC626NDo66/D3cPTfq8Ed1hzjSQH8lT9welfCqsJUnvceSW
	 79t5CiBA/ZqYn6g73/INjjDW8N71m+St6WwFuaWEgEBIKrQZj34j0GIul62I0ZUhe7WPw
	 4Bp5RdXW4R3hMsr21NtnFSG/BEoTbYtoFDkki6K/iOCjWqWokO43sVLv0CoZkOF67QBdt
	 U8Icus3L4Q8AYOgi+D+aHwzUMB6MwwRFOXeAmaUpdLZn/ufHtRFXsZzz3NqY5ONHcpdaS
	 MENaYU9C6dUv4fhM5VejCz0WQlrc1v9vFAJLYSOwrGB24jBBBNC7PM0LhlsWutLxQwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795004844;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=xz2Bk4myv4eiO5R8ei+E2wIg7nTAaAYUNv7l92Ae3Cs=;
	b=ztIH7Eud/tr0KP3I23IUTBSrraXqQQsCYrnYmkbWfkb1ED4XpS9Wmy+2B9QRuJjFOvwW
	 0GdG/OJnkvksmYiqW4K2LVIHeDmt4lTXqYlZ3LCx1TzpRRgAssgCejXOSag2sjE725Esf
	 HhTP1yIRfwIIx3obpdSzFIILXIOxqPiA0pYYZb0pMI2TmADKqCRl/kNmRnj8nvJCMsi5O
	 5AGqZ+lzfsyAk64bdarr0V8D3Ikq69vFrTebeB0/vLu1GoiK8YhWZHdRA6gXakMHk9pFm
	 ylvK4pX3G2IBLP6yizj6Ynnboce+q1Bj9Mof0cQux9BfbLiJ/gHMfMZvTGCKhkEuaxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ywd4nucm;
	arc=none smtp.remote-ip=209.85.128.53
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E51606A31C
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 12:27:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82E51606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ywd4nucm
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso6988045e9.0
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 04:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795004843; x=1795609643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=xz2Bk4myv4eiO5R8ei+E2wIg7nTAaAYUNv7l92Ae3Cs=;
        b=Ywd4nucmEYLm0ATf0Lw1ZckaxEs0EzvRGYnkn/XOiMmiBstiWvmgQHqN64PEnM0tWX
         +TfO+Inb/WfN8XdC17/40AWe51QJW68L4/jKNnFE6XY2JI/pMpkqnPZOMCD+wYbGCRXK
         Tn8Q/Ap/GNVbC3IrqYJW3ZRrvqv7ChIn1W2VWyE5CxxRaWm+QQzXJ5GQEp+ZhN+NujWW
         8q4HwHi6LGkl9tEKMtyNIXgyUYqIF7BFkl3SLWHUbichUEgJ7RwAPaOLKPNv7zsEM/S6
         O2hn9kriQaukT7CMwu8pX12gl95KBr5bLklbZtB5DcWG3p867P91Y1DiNleztWSEfRb4
         uHmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795004843; x=1795609643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xz2Bk4myv4eiO5R8ei+E2wIg7nTAaAYUNv7l92Ae3Cs=;
        b=nVCB3q+iCmBKrj5LhcJVxiOUUiGPjGFPwz8SdUFaXlDzocCvC6qnq7KADe75i4oZLn
         UepqlyUZrMjtgqKNh7ktnhILk7qDO1WrkNDEH49kVFkdWJd3tFE6nDTlwoHUvne/fDY4
         6wM6dDgXLuhoeWytNSz3ouRvjNXo9iNOVQUeFAjNpNs4Y55W2OujgNxnoCkKYnErgljn
         coJo9WbQv+29ghXY4jELPbHzvcX9LsgyhzeTZu7bqZqL1DLBgQm8SpFqTbanRRkWddu9
         d/glFIrjgW/SiYuw+dbGIAtFMjhQN6dxHFu8Wdg5GDAYqarcY4Ic2y0rikSH8RIEpHVv
         zyUg==
X-Gm-Message-State: APuU4Z/CRI4kRNnRbhcDndEZ4zBGvdnkCs1fTvsNXwZJ2+0iq8Ot/YYN
	9yxbRK8MtwT6oVIK/5RVGh0xnq2eG49raIf/S4va96wPof0QOu1vf3W/1UOdjoaA244=
X-Gm-Gg: AYBFou1BLqARDFsUsqBCrLxmaUG0yZSB7+cqquUn2u0lMf3VfeHMT9QB/ugTgKWl4eK
	NaCGDRVM0KlE31/o2m3sY1KieC3ghDqPK7r1bxyosWVdBr+xT8xXGZz0i0LqlzBtRu4VG0oJ8R+
	bYsnOAztTux8dwb7Nb5L9u0/4aMOfBA/du+21TTouXdx1MKQEPFYiP4aVq6y0O8suP+EfJYJnup
	15PblEBhS//K89SewU7xneGNVcFf/lMouAlppFzd6nFBOGBPJXEWqksqSE1AFWEXaK72wUudP0u
	ehew/QT7wgUqHWbJXYqyQCW/WY/inO5eOTNOxqmoT66peuwiBaHd08lsgVsBCtbpsPxwPZ8R6Cc
	6CiRKT8yBh1naOEr95zbPT42U0LpDuc51UHum/lKcn1n9UNKgnNeitFaCkMLr7e7uD20aNpU/W0
	106AvbZlM1WT1ZIeesrDwgoLROyN/jAoEZZXtaC00n0EPPjS9yiIb4h3lrxrvsVrJRaTzOiBCVN
	cQA8qAOC14CH4wN5Nkkf/MU4f2FkabYJX1VJGXvt07JZl7AofOVIcZcWJSRgT2auWiEK2tH9/Gh
	mjNnK8uvAguzXIoKopjyxhpJq8tdxcgarpikBNsoBtmKclQOtXheNXYOw1kVqCY/kOp3e0lrPhj
	F3wRD
X-Received: by 2002:a05:600d:82c5:b0:4bb:693e:4c8e with SMTP id 5b1f17b1804b1-4bb7da270bamr55401635e9.21.1795004842666;
        Wed, 18 Nov 2026 04:27:22 -0800 (PST)
Received: from SurHub.localdomain ([196.188.113.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb78430752sm150071565e9.12.2026.11.18.04.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:27:22 -0800 (PST)
From: Abdifatah Suruur <suruurism@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	Abdifatah Suruur <suruurism@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: reject oversized SET_INFO data
Date: Wed, 18 Nov 2026 15:27:17 +0300
Message-ID: <20261118122718.17236-1-suruurism@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SMB2_set_info_init() copies the variable-length set-info data into the
SMB2 request object without checking that it fits.  The object is
CIFSMaxBufSize + MAX_SMB2_HDR_SIZE bytes and the data starts at
sizeof(struct smb2_set_info_req), leaving 16492 bytes with the default
CIFSMaxBufSize.  A malicious server can return a nearly maximum-size
security descriptor; id_mode_to_cifs_acl() retains its ACEs and adds up
to five new ones, producing a rewritten ACL around 16.8 KB.  A chmod()
or chown() on a cifsacl mount then makes the memcpy() write up to 336
bytes past the cifs_request object, and the overrun is also read back
and sent to the server.

The worst case is much larger: if the server returns a security
descriptor whose owner and group SIDs map to 15 subauths, the rewritten
ACL keeps the original ACEs and replaces both SIDs.  With 817 ACEs the
resulting SET_INFO data is 62256 bytes; KASAN reports a slab-out-of-bounds
write of 45764 bytes past the 16588-byte cifs_request object on v7.4-rc2
(where the earlier undersized-allocation issue is already fixed):

  BUG: KASAN: slab-out-of-bounds in SMB2_set_info_init+0x47c/0x6d0 [cifs]
  Write of size 62256 at addr ffff88800ee28060 by task python3/86
  The buggy address is located 96 bytes inside of
  allocated 16588-byte region

Reject data that cannot fit before the copy.  This covers SMB2_set_acl(),
SMB2_set_ea() and the other SMB2_SET_INFO callers.

The vulnerable copy predates the ACE-retention rework, but the rework
makes the overflow reachable with an ordinary chmod on a cifsacl mount.

Fixes: 35143eb5c2e3 ("CIFS: Add SMB2 support for rename operation")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

---
 fs/smb/client/smb2pdu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index f85595136ef8a..beb3abf9724dd 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5894,6 +5894,17 @@ SMB2_set_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	req->AdditionalInformation = cpu_to_le32(additional_info);
 
 	req->BufferOffset = cpu_to_le16(sizeof(struct smb2_set_info_req));
+
+	/*
+	 * The request object is CIFSMaxBufSize + MAX_SMB2_HDR_SIZE bytes
+	 * and Buffer starts at sizeof(struct smb2_set_info_req).
+	 */
+	if (*size > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE -
+		    sizeof(struct smb2_set_info_req)) {
+		cifs_buf_release(req);
+		return -EINVAL;
+	}
+
 	req->BufferLength = cpu_to_le32(*size);
 
 	memcpy(req->Buffer, *data, *size);
