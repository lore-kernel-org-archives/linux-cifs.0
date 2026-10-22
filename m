Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792641204;
	b=UFVEYIdqkQs8PlsUkTo/vqno/GGnU61uf/IPYubzyVmMOa3ZsC+NeNfvfoNBW5YZsutr
	 NHJMIND9oYwuI37MbHtF5+6DdA/S6vR2wLzTOG84pAWBmErZe2qsDgBw2I+4ISugaQLAj
	 va6vxDF6p+yxeLxeBjPRGUusojVJa5vD4CJY/owM7ASyx2QcwKUbau+ZSAMTU0nykclm0
	 O42WldlcSI7tNOrO0bc/vzRdlyb4IOl3GLEkv+sJVeEBSMs9eNvY4DzD/ZZwV9M/S+Glc
	 TmcYYcZboP7xwbrP26tGic2hrTlefkrz5kfIiYpcipQ6v6HwqN9DCdHvwlYF0ZaF/QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792641204;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=YTwXX/e+2q2uxgf0ajbM0Q4u9v6L0C35gNVhAj4Ee6k=;
	b=NdyrVZv9beLrtaG/l61jwsUcSFyeILKPCvngG09aNXTSXKwrnfgP7gHA2poUklKeTF/I
	 O6A/M67TZhI8fwSgBrkdS1Q7VrUEbX9Sr5s1+ltZS1ECEk6jqzZkc5XRYEYN0G2ofplD5
	 4Dr4aLj2udqtmgdi30BhnUA6OoRjirSDptTpITPQ0myN4QGBS0zP7VRj2+ApuBt8fSdYn
	 2DWsnfsqRHPyKiikAMIFqU1i4bGN/pEYtG7xEkD76FnU34jlCOGhQqraPLHD0i7pcgebq
	 Le/EbiohWRgCBXbIwd+/mYmg3ZtcwPuG6qwLxSxgjhR2Nj1d11lwXdYV3vg607OqhkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kvW1+URm;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B68E606A31A
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 03:53:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B68E606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=kvW1+URm
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a20a37703bso194545e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 20:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792641203; x=1793246003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YTwXX/e+2q2uxgf0ajbM0Q4u9v6L0C35gNVhAj4Ee6k=;
        b=kvW1+URmU0ECHNTcv+pAMwpCdKdf1Ev/KIEfNw0Svw7ZNxJkwaQttbnsNLEF8cufJE
         7uOv2ivfFhtzOxA4dncYRkG0mF8zw23nUyVhYh5QzZZwoa13L6X5o/LMdnjjmYyyELRD
         RxwzrtF3BEWvUMjCeDyicRIj1d0ITNxhC1qWwqWLJsUbfZiAJfc/o0shHWZY7P3hPk61
         G+4xid8lr/mX/rPe/8re6vBh6FdFz74g1n6wQMubjBswqnChcWqc6TC67Ne89ezpmmea
         wYD71w8CoIRhTIOX3W0sAihcRhQ3gW1pS6j/JAO+rNAgNRqYJsRLP8CQE45fazRb/QmO
         RotA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641203; x=1793246003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YTwXX/e+2q2uxgf0ajbM0Q4u9v6L0C35gNVhAj4Ee6k=;
        b=fbrjvC93JfT+CwDHRsTAerj9BdjQpZ3NkEafYS/C2e/cwfag16jWX7cco/X4TT0EA+
         w8JFjH5xJ76o0E7JxDdtedXR37f2/EPfbBiZv6Ag8hlrhQoNxLjVTkbsEH7bF4xi7Jwm
         Elvj0lq5fJ8aAm2OUuSVbOJXLI9M++wVUCq1jxreXs/JxcrK93GVQmCABHmsM4rk+ne/
         YYC383UFPlEkMsh8PJY9ixEv4tb9x/UYmwJX7IxBXPNPfVz5EzqFYCr4wpnAejMuvZRL
         SGFRpD9HMXy4KPg4IHW7jqDebDlF1JN+4Y6MckUa6chmfbxn8A5DkN3KB+pFF3RZjpMg
         /Gyg==
X-Gm-Message-State: AFq9FYLsDre6uTL/i2QpTzZ8ppkM9sqGDjio9HvaifYON+WGypfCOX2y
	KbJAS8XJDYwaQvWCwTaIjgIQvTNCtFwpAkG2J04cticMLje5lGrKjhKB0vg8lw==
X-Gm-Gg: AYBFou3wmiSU6cfrZu3WM7C0O15B8z04KsTsR549hGyxR6FiFTnDpXFb1Hi2iD+tg6a
	UhevSEj0zxm9ri+KaToqs1HihEPIb/2k9eyQGGBwM5Xc0b09sB8Qt9KoMg+EvToE9l2P0xGVYPc
	+hCAR2letC1V/DD5fmzUKTgPycotJRvDtNc6En9/QLiwLJ0m3BSsJ2ArYS3jKtKZngICTNiUz3l
	Y7WQAfuAN8Nt0U910PCx4bsq+iNQVukw6RrdTFDNzxJcKMa44SZ9yDXREg2hNjbzTW9AwaieVMj
	Mc3ZxItsemQ4GYU/6f5rEcIeWaM56AqYUXhOEP9fNUgctiKsP1vlKv53jNxDNmJ3Matt8cDkS17
	KrdnPA1IzN6FWGcSYsv+9MmqTuUII0Td5A/wbvHEkJi6zJCXyDTaL2e9Ec7AVKp2G4GxihgO4u3
	CJVz9zkC1mimmf6rZK+NrgulWjMVLBlF/l5EKp50w9gr27lFfJAsC09CMVPGhf/GrkDDl3lopq7
	2t0jrJVPh3YiiHu+9jCiPRdI5PN++8ZIVmEWwmXBcJHV5N0bLwAfS3WFZ95loQ2RBCBXtaNUAj+
	rRWxN5ROlVRfVVUknv3Buf3jWAwugGE8qSJxpmvaHjlZ2718jnFCuA==
X-Received: by 2002:a05:600c:4f53:b0:4a1:ce33:1536 with SMTP id 5b1f17b1804b1-4a1fdd20d2amr83625905e9.9.1792641202626;
        Wed, 21 Oct 2026 20:53:22 -0700 (PDT)
Received: from SurHub.localdomain ([102.213.69.52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e258426f4sm9507239f8f.54.2026.10.21.20.53.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 20:53:22 -0700 (PDT)
From: Abdifatah Suruur <suruurism@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] smb: client: reject short SESSION_SETUP responses
Date: Thu, 22 Oct 2026 06:53:14 +0300
Message-ID: <20261022035314.17801-1-suruurism@gmail.com>
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

smb2_check_message() accepts frames shorter than struct smb2_pdu when
the SMB2 status is non-zero, before the minimum-PDU check added by
b4694f269e66d. A 64-byte STATUS_MORE_PROCESSING_REQUIRED SESSION_SETUP
response is therefore accepted even though it cannot contain the
SecurityBufferOffset and SecurityBufferLength fields.

The parser then reads those fields from stale bytes left in the reused
receive buffer by an earlier frame. With a long stale
SecurityBufferLength, decode_ntlmssp_challenge() copies up to about
64 KB from beyond the receive object and sends the data back to the
server in the NTLMv2 AUTHENTICATE target info.

Reject short MPR SESSION_SETUP responses before the short-error path,
and validate SecurityBufferOffset + SecurityBufferLength against the
received response length before decoding the challenge.

The ordering bypass is not new: the short-error early return predates
b4694f269e66d, and the unvalidated SecurityBufferLength read predates
the 2016 raw NTLMSSP split in 166cea4dc3a4, so all supported stable
trees are affected. Reproduced on 6.6.87.2; the path is unchanged on
mainline.

Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2misc.c | 16 ++++++++++++++++
 fs/smb/client/smb2pdu.c  |  9 +++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
index 5e5cf92d1..e107d4e79 100644
--- a/fs/smb/client/smb2misc.c
+++ b/fs/smb/client/smb2misc.c
@@ -225,6 +225,22 @@ smb2_check_message(char *buf, unsigned int pdu_len, unsigned int len,
 		return 1;
 	}
 
+	/*
+	 * A SESSION_SETUP response that asks for more processing carries a
+	 * security blob and is parsed as a normal reply. Do not let the
+	 * short-error path below accept a frame that cannot hold the fixed
+	 * response fields; the minimum-PDU check later is unreachable once
+	 * the early return has accepted the frame.
+	 */
+	if (command == SMB2_SESSION_SETUP_HE &&
+	    shdr->Status == STATUS_MORE_PROCESSING_REQUIRED &&
+	    len < smb2_min_pdu_len[command]) {
+		cifs_server_dbg(VFS,
+				"SMB2 SESSION_SETUP response too short: %u < %zu\n",
+				len, smb2_min_pdu_len[command]);
+		return 1;
+	}
+
 	if (len < pdu_size) {
 		if ((len >= hdr_size)
 		    && (shdr->Status != 0)) {
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 5d892300d..f276acf7b 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1857,14 +1857,19 @@ SMB2_sess_auth_rawntlmssp_negotiate(struct SMB2_sess_data *sess_data)
 		goto out;
 
 	u16 boff = le16_to_cpu(rsp->SecurityBufferOffset);
+	u16 blen = le16_to_cpu(rsp->SecurityBufferLength);
 
 	if (offsetof(struct smb2_sess_setup_rsp, Buffer) != boff) {
 		cifs_dbg(VFS, "Invalid security buffer offset %d\n", boff);
 		rc = smb_EIO1(smb_eio_trace_sess_buf_off, boff);
 		goto out;
 	}
-	rc = decode_ntlmssp_challenge(rsp->Buffer,
-			le16_to_cpu(rsp->SecurityBufferLength), ses);
+	if ((u32)boff + blen > sess_data->iov[0].iov_len) {
+		cifs_dbg(VFS, "Invalid security buffer length %u\n", blen);
+		rc = -EINVAL;
+		goto out;
+	}
+	rc = decode_ntlmssp_challenge(rsp->Buffer, blen, ses);
 	if (rc)
 		goto out;
 
-- 
2.53.0

