Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792641211;
	b=0XrHDmt3ssdOeycypJeYJM8GaTnV63zFxEM5u1Ba5XHQxzuNt1Y4iGNAaDAfXuo8zBC7
	 4UbgRFm6w8lXoK9mf3qBiaUhZJ/09J2NxDF/ApJi/NrdF/qwgB3/zB535+bapJiaACGvH
	 o8ERyzXzByErn1qeY/xajdARMVCRrEx+IuRgK7NwAmknob1uUGUq1Mb3E0X2OR8DI9pvo
	 r+7kfwuX5bR2YwdFnOajk2hHuKfF54yc/T2SyNxL8FnHksBrd30nL7gDBhllEt+2XYiE3
	 /cm6zSn4vZ3Oo4mrBvDSaN9mAtGio00Sl/H1HfjKRYUDtzRqoEwT+XL0SlmqKjsdyrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792641211;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=PFcEYtHPDZ2pIPyW3D/zakCIslo6EG3bD7BCUgb7zS0=;
	b=X+cMzWPeffziGrQ8Tk4REf4sgcVowdNr/hbTkj/Yjg/weCFf7PkTsrmxDndAyLrzohQ4
	 Vla84rgJvUzUMTKq6cumcSeYPRgPC7x+VmIzOHoj2ecZ2NriFtmzZes/WJevmnH9EWeSI
	 YjrdTTnjSUumgiFR2AuE9K04xJPg8Ax8I0EUsYRrZ2wKZci+/NC7GSkZpEyLm5LdMcw49
	 PX9levwmRxNqO/AiTAb+n+NChuHnK4DAjOE5pjqWTEg3Fmnj3ZE0QkFsxjp9XZlh9Jx8W
	 mRqYrwik3zS0zMmikGXqN+PQuvoy+tdhqlFs0zxHai3mnVrMBwF+lIwyvvb21Fw6yTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FMqL+8ZH;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FE8606A319
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 03:53:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7FE8606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FMqL+8ZH
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso12336955e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 20:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792641209; x=1793246009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=PFcEYtHPDZ2pIPyW3D/zakCIslo6EG3bD7BCUgb7zS0=;
        b=FMqL+8ZH9ONMWspAF8nRpPBJqk5QDZtF5QeuMWh+aapUCPJ7jomchmxdjUxPjq8mOK
         PbqpzMd/W0i4Zvw5bsbToURV3dwH6Nnpj+7e/a+9VF2iYsIC31hSlsZTVnPduJ1ifdbZ
         hp5JIeDyf9+4t5+IbMxumxb5jBppGp4ZWY1ASie0brS8yUK+BS1N2116VPnVarnfLAyK
         rrkKzfrFVQPOAKj6PUaooI81hO59sisaoHFG14VuOrgtvTBbtKkPkcXuKKhnjXwOzevv
         nPnt5dGNrljKoIkJL/GSfw2RnEh7D6hszsxcXWC+FUxYAbGmIKIcPNeD4TRPk0MALfsw
         Jzjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792641209; x=1793246009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PFcEYtHPDZ2pIPyW3D/zakCIslo6EG3bD7BCUgb7zS0=;
        b=qLukL4ZE5lTOvpnWT5suzIhAtjSNSN0EN9TY1t2DEC2/rgzHRcTw7pvlFkiO2ghn3t
         4ZvECqfRlWI8M3DqqnB4gt51xEnU/fSyAeBiplVO1hvJ9/UhNO/lPCQ7PUEOIXkmMxpE
         bz0x3jESgsWxe5g5yQnZguFpJmSjMjQgDHsg+mdMEUqSP5fa9DGU6c6lvEXhSyavZHwm
         /aXFSM9DhKxCXhmcctyOS7LIJGm3Ufd4fB1KdZPa7QJV1AQswzwODp8aCrnrSCrL770A
         DVwoWD6nrGhYx47zIxwLp+A3WtcpE+7V/LyAwpXu1gFF6t9zkUMlcsYEzBs5WMelHcnR
         FAVA==
X-Gm-Message-State: AFq9FYI3RMAbRsXVp7YEL3aVBUa1KT8NwOLIT31UPywUkJh9ajIBn5Ql
	N5gTK0b1parWv/8lum96Wy0wW9oWa4z8px+IHME8/RZsPdBYda7KXRvDNLV3t337
X-Gm-Gg: AYBFou2UdsUMaUMInmdKcEWCco+9EXpFPZzdyBkF/8MH0LqMuqm1uYt4Phf6aHHsLFE
	uPFNpEGPfLmHP9qRgMarsNGhcasUNnXhND7qeZ5ZGLo+GE1bwEb2sOvxICv44qna1pzaJiiTxGK
	4whJWO5HwJ6ZyRa6GD9shOX8Nty0RXRzkPBq7F1RUf11j4NrTZfID1maFb3PR9I5U3FJyvS220B
	hfH5RvOItRUgT84YJ2/7ZGkSBdx8lMAcxu47IpGGxozjXxJKjG0LYGRY10RiRvicDgvyEq0x4uu
	PK7fwGkgzRCQ4VnPsvV3jL8Bkw6s/E006CG/7OVSjSDVebl/b4OmvHGOrJyKz+QnuU1PJGenCEd
	lLiICKcpZ3fXOkjpE6dnkAnKLszZ3LdvEGdWBCcDNmAcOdc/XcmDnw2lU+k0fOmRXZmgtkCLWxM
	iBBHN+wZsRIGWgHQyAcfm9ul9YDVepa79OVLoCIeneNcfHRfTFGj+IcgyBklmPp6kVRFU9lh5OW
	EibFO1SxFPxpF/DWbZFIPw8gHOJNabIVSBQ91WbvDOAcJicGEcEUyM2ZFKudyCw15Zk9ifea5fK
	pszWszmESVamdT1+Oaedgudk/DIapbGw
X-Received: by 2002:a05:600c:6309:b0:4a0:1f90:594b with SMTP id 5b1f17b1804b1-4a1fdd293d6mr68900625e9.22.1792641209082;
        Wed, 21 Oct 2026 20:53:29 -0700 (PDT)
Received: from SurHub.localdomain ([102.218.51.146])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a203b42befsm35838025e9.8.2026.10.21.20.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 20:53:28 -0700 (PDT)
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
Subject: [PATCH] smb: client: fix fiemap wild read on empty truncated response
Date: Thu, 22 Oct 2026 06:53:23 +0300
Message-ID: <20261022035323.17832-1-suruurism@gmail.com>
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

smb3_fiemap() treats -E2BIG from SMB2_ioctl() as a truncated range blob
and loops for the next chunk. If the server reports
STATUS_BUFFER_OVERFLOW with OutputCount == 0, SMB2_ioctl() returns
-E2BIG with out_data == NULL and out_data_len == 0, and the existing
length checks accept the empty result. The loop then evaluates

	next = out_data[num - 1].file_offset + ...

with num == 0, reading 16 bytes before NULL.

Reject a truncated range blob that contains no range, so the resume
offset is never computed from an empty response.

Reproduced on 6.6.87.2 with a malicious SMB2 server that answers
FSCTL_QUERY_ALLOCATED_RANGES with STATUS_BUFFER_OVERFLOW and
OutputCount == 0; an FS_IOC_FIEMAP ioctl on the mount oopses in
cifs_fiemap() with CR2 = fffffffffffffff8. The code path is unchanged
on mainline.

Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/client/smb2ops.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 20624f5df..7eeb33640 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4360,6 +4360,15 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 		goto out;
 	}
 
+	/*
+	 * A truncated range blob must contain at least one range, otherwise
+	 * there is no offset to resume from and out_data is NULL.
+	 */
+	if (!last_blob && out_data_len == 0) {
+		rc = -EINVAL;
+		goto out;
+	}
+
 	num = out_data_len / sizeof(struct file_allocated_range_buffer);
 	for (i = 0; i < num; i++) {
 		flags = 0;
-- 
2.53.0

