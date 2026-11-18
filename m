Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795006376;
	b=xg7ow8VHmFJfxCnGqr5stbSkcS/HNvh7fK7t56S+KAqTPS3TsO6Wz+/LcVMQ9SQj+s98
	 9eLi0s5JHwgGh1y86OByei34R/BPNY6yatuWxR0wCeQ+f97HbIk5Nz62ew4YjggzdHyss
	 9UHslkdbQM0mcLFGWoQez7Z9dKHzn3xDxn8+Lk3YL/5cvl2ifhkzTb1Bf25b5BfTeYD/L
	 bI5GugPi3MZP+VEkMJk7Cjz/qmOVY9RQljLszkcm75DWU4OVNH6ZPRw96MR6SPhQcfBFZ
	 MhJql//KULiApXUxzXob4lfopjhaulgEMpWyRcnvrB0RNrQrP7+JqO2klVljWz9rVsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795006376;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=CLZdxgBTnelpDBBhYsMIenWk14F6T4PyOHqt8YvN4Vc=;
	b=RzCbY0h9slJuJzi2iB4HFPUX/IQGpl35LjiSn74xyvtFvXxbOQASpnnT5mIxI+HO55sw
	 llJgbMXgQ4a/HbOIWDSTZfPv8mrJO+EZHulAI3UXflbki/WG9wdulsBhxv2j37mTA/Tsl
	 ijr3SfH3aBcEfRNd1U/nBa4Hm5bIbDGKwBkiW9TvLbAkTpOcUap+x/IICjd2oKsitg3AA
	 qTwPpxFuHiE/M9qKdP1yQLHnfFakq7sHZEtcGnXsTJ57Wlsn1j3yHHxMybaRbY+wngtQh
	 NlK8p1uIpNHh6hluc6sCq/S9mTpSqRpqpC5y3mEg1BRI9EvxoSiwFC3aP+utUAWKcBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="U6ww/R9e";
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0149606A320
	for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 12:52:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F0149606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U6ww/R9e
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so784384f8f.1
        for <linux-cifs@vger.kernel.org>; Wed, 18 Nov 2026 04:52:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795006374; x=1795611174; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CLZdxgBTnelpDBBhYsMIenWk14F6T4PyOHqt8YvN4Vc=;
        b=U6ww/R9e6dQQb/iD/muo1eBqrsB0GLByuVbcxMV2Y4Be7aAScvjZm2leuJudLrP6id
         52EIEtQD32nkMsYhonOtRI+GpGfbjCnNDaAOFKFej9Wt9ljDv26zX45TxdVQwZ+RRf11
         vufuB9JPuOUX5X+4DR41Arrg3LjOopLFZPqDDE+XFm4gL+9qmRASEE6NBdTc9ZLS6AOh
         bOxGdhGYzqUPL/41uYrpC9bcfJHQKctxASU1lUYSowt2xYiZGNO/egMqz0VNOAbGtS9z
         puRs+DyZwKeEhNyx10TIMALNPz4dtX2bge0Lqfxa01wI6s2xu9UuB4RtPAHt2OcBmQ3z
         5VAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795006374; x=1795611174;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CLZdxgBTnelpDBBhYsMIenWk14F6T4PyOHqt8YvN4Vc=;
        b=FfAU8ciL2urIDx9bl0jdjyTRNBHMhKWwa7PMkwbrG6SN/H/RvFmpKh/4+Qqr4qsa8I
         sdeyDIdwbvRHOadB0dvpLttJxt1zG7dik3c0gNI5hz35o9GmuD7npZ+S7v6lQsWGVNYz
         8TzAlmYhYqYYVmTRHWdRZSrPmL3Qsv5g0DVxTQeoi8fpiXYYJYEdoP2sQjvNgd5eUZ6l
         W3O/5gFDO1+K4fQ90athkRbobWELXOYRin9Wi+6sDs0nG4AxyTkpCA72/czWAYUieDmd
         Y7R40VzHCx6y57OqrETaJXZbN34i3HoXls26LzQPS/1EWpqZ5zEISIOmgUa1+KEC04LR
         sX6g==
X-Gm-Message-State: APuU4Z94vL481R43wjOXdj7p8SC8rRDSz3InIPW3aXWZEEtGht3GTlrF
	4HhFiRGWbhXDEunvqhqUJIhKXT9FDCBFS3bGn34Y6IsQd4/Qk7qjBaLJ
X-Gm-Gg: AZFdTZf8c4MTyLbC79nsKhOohvQM6Gq8rVvZvCiVhBCsd0CYy7EwCgQ9CS4ZvbM1jTu
	2+bzsK1a9lY/I01ggGj6jvz5JqqTRkHD3MqXmvhKT0g7tUK6RW9SlOaR3jNGuPxkzRs2qMicSA3
	ydFHVfPJ3nI1myf2eYPSGWV4cVcFTtHW9OXl6CrO3njzdEFWFcOgGhxkLldRBM6f6vpdhWYXIsV
	+4kChxx+0u4ZRbGDGWtR91uH5MMapXut/uckgikj4B5HnJyuvXJLB7EffzC6NXLATnVBo7oPZ4r
	+djFI/YlKFMYPFl8/6J+zSQy91YvUfcSOm8Hvo5eazZsETc4JnHmDooPk3e/461XIgnzFQt6kf0
	rYddIE1ajGlKHDxudpn09P3ZrZNb/bgmm0pX7z+c5D1Upkcb6uCoHeFhsg0eMJDMQZ5uZXImj9N
	3LhxWEs0SMQeLwr+sxqcDSAZqZoaHom9/e/Bltp5beX3ug5LZJcjK0Bku3ffYnPTGSOAx57eN7/
	Oo/jg5OyjMfwrIf0sstxffHhuTT3ON2IzOJ7wk0yKiOB28+NUMYuKUKBApcNOHRoyNqDfmOOpOa
	VhzFYQq/FbbQCLuyhRiux6vnT3SJUEp4zHk2nq0E0FAMocRGbmPE/uY6NzJFDmz43U8VXKY340F
	JfqZb
X-Received: by 2002:a5d:4522:0:b0:492:7efe:3fc4 with SMTP id ffacd0b85a97d-4a6389ee17fmr3826148f8f.21.1795006374181;
        Wed, 18 Nov 2026 04:52:54 -0800 (PST)
Received: from SurHub.localdomain ([196.188.113.38])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a650d2e26csm4599043f8f.4.2026.11.18.04.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 04:52:53 -0800 (PST)
From: Abdifatah Suruur <suruurism@gmail.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	Abdifatah Suruur <suruurism@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] smb: client: reject oversized SMB1 SET_SECURITY_DESC data
Date: Wed, 18 Nov 2026 15:52:49 +0300
Message-ID: <20261118125249.25375-1-suruurism@gmail.com>
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

CIFSSMBSetCIFSACL() copies acllen bytes into the single cifs_buf_get()
request buffer at data_offset without checking that the data fits.  The
buffer is CIFSMaxBufSize + MAX_SMB2_HDR_SIZE bytes, while acllen comes
from the rewritten security descriptor produced by id_mode_to_cifs_acl().
A malicious server can return a descriptor whose rewritten ACL is larger
than the buffer, so a chmod()/chown() on a cifsacl mount over SMB1 writes
past the cifs_request object.

Reject data that cannot fit before the memcpy(), as the SMB2 path now does.

This is the legacy SMB1 counterpart of the SMB2_set_info_init() bound
check: both paths copy a rewritten security descriptor into a
cifs_buf_get() request object without a size limit.

Fixes: f5065508897a ("cifs: Retain old ACEs when converting between mode bits and ACL.")
Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>

---
diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 2936b38de98f9..a5d02ed85877f 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -3961,6 +3961,12 @@ CIFSSMBSetCIFSACL(const unsigned int xid, struct cifs_tcon *tcon, __u16 fid,
 	data_offset = param_offset + param_count;
 	byte_count = 3 /* pad */  + param_count;
 
+	/* The single request buffer must hold the ACL after data_offset. */
+	if (acllen > CIFSMaxBufSize + MAX_SMB2_HDR_SIZE - data_offset) {
+		cifs_buf_release(pSMB);
+		return -EINVAL;
+	}
+
 	pSMB->DataCount = cpu_to_le32(data_count);
 	pSMB->TotalDataCount = pSMB->DataCount;
 	pSMB->MaxParameterCount = cpu_to_le32(4);
