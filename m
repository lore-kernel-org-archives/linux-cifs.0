Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792756386;
	b=HniCBDPPhL8Qrgju+otiA0yYyArP0IfbO2Dm7zVcV/UoeYwYaDxGwfvmQRyRz17dvRop
	 EmuNfEKxYZYOf2Ve+GRCdy+Wy3E4ahVZKG8zrd6kH39TwhifBXOiWYdgjO66hoUVhedMy
	 O/ucVur1bxHnST8tNrznnlPwH3WzyjnTUmHFei6C+Kc0W0NzGMwbKa6AEdJZZYqDG+vzd
	 +VzuOgxH8kUpurK1XPEKkhOsYFQPFwGQvkgZqFCFUw/TgUVs4FFXdQiIZzodlo645i63E
	 5Z3CEYwwQvYq7wgm8YV+fzwdP6TUp2EI3DBVEWO3aT6LZuLcctQ2LqAgfQMjoO5bXBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792756386;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=TaTsYfuLxHhBqdkMeXFHx9EDOOo9W7TtKJpx5ldOBss=;
	b=hHdiUjMeE3D8vClQqLcFOrOZoqufzjgOBrljfBa2/lbdgUTJaLlcKehl7K3VIoBxNTys
	 YBSfpXZ8rjph9mZjRq8eChztvTEqiTIp2AL10hN2iP7oTNeB8kx9k1arhW4iU53Sq14Z5
	 pE7Qz5LdNHHTGywS6lewjVOwUqcgU3pBjCPiaNZbhRCI+TtTuxVA7/+EwyBYR8+QUJJjl
	 d2+86TX/AEHR+Fgh3BBnTJNYwp+eTaFxONYMu0lT7+IsuTtYEsOW4TkWIbKytuhpO4hlS
	 tR9bosOT02fPaIbUGKtZyrxHE7Wv3Tc7gXfduF/WkhcUpNfaYt1Gjyj78M7CuQD4zkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PZ0o7VH1;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5FB606A31B
	for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 11:53:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3F5FB606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=PZ0o7VH1
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48df4f540ebso458708f8f.3
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 04:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792756384; x=1793361184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=TaTsYfuLxHhBqdkMeXFHx9EDOOo9W7TtKJpx5ldOBss=;
        b=PZ0o7VH1T2n0oaJC/6wRcOdYvYc8otyM4i2atn89dMPbvln+coSJUuk/DUQb3D6GB6
         1wCaXj0lHHVp/Tdql8++xuX7fAlREFqqTr8mmVZishta2e+qXpws34pBKfZ3dULkg2jE
         WzOk3yzgoujB9WkwSC2ilvj/aZMkQ5SU1FKzydL6wRb0SUr363HfIdT3QzkUo9jVB66a
         E0WyPefvykFOXyHXyUUW8gFOJU8wFvmLt3Gg17uPiRYPu0rAYhUDELcoZiKtovvmZTDb
         9tlGIp/ICOWIdfN46P7AsbPdGOHFTQQuhRC5Eh6mHK2CmR9k5Kv/+ZxnU3iJSOxQzPZ3
         rE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792756384; x=1793361184;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TaTsYfuLxHhBqdkMeXFHx9EDOOo9W7TtKJpx5ldOBss=;
        b=gqFV/f21rKz5DFAsCwOJMM/CKdLjgUCDcXXQhbB0lBru5Y+3PQU7wU7ZZ6EsRJBJ+4
         o4pTfxKwWFVm1h4C3Nlw0YfRPUR0hGyCKp6TfZ2Riq2bYfIE8Gzvp8+0CT5J8vxe7gNG
         LaDaVhZ41jDRSCKsKEhtGmjXo4F79R1E0nnFNmcruKjrU+ZZCt2Bq3u0WxrOHi+hwmAg
         kkIU06qBZFm8FM57sql5bAOJ0Gl1cG0YgIHTZrMkcMUd93BLjbfb4FMeWpePOa33bqmv
         GSzH8gekCo+nlmobEPPNRRIcKXR9tZKasYaZyduw9FC1naVMW/o+dUMhPjJSw/eLst5/
         lRcA==
X-Gm-Message-State: AFq9FYLHLy9tp56hCZLjlKoSKw7JhrTo0HYns/P7KdjefGA54totXU8d
	ufJUvcml6s5YLHy1oqTR2qSAkBanTs34MhsEdxHLFaNZrtwPmOG14/MwJNgFNF88GFs=
X-Gm-Gg: AYBFou3uuHEqGwYrSBk4VMZYX+zPBpwKlt9dSthggvXc/i0BvNbxTWKO7EEvAoKPZCV
	mOtcTRLy5OLrC2WTg80BNjj5zg3XBAMnC2XH9xdw8F1n+tx08Z37I0ZOIM8QAUdk9xPQSJfRcx2
	DnoO6IB5lPpZtWU3pmVyzaDUG31Z/7BMNepJq+8DKvsh+9Yx8Y4Klm9zN6zkBUlifneuGQUOLNJ
	QxP42V6Qaf6n3rRdiyvXIrFNFRREfy8BTyWXBQqPDCiu8hg92VrUObLuPC2BHr57xt18h7xHS/J
	6u4kArsQfDJ4nAE9rM5539bAwmo4tCV4nmf0895gCqJITa2beD4L9Lv1BID4SZDQUXaLAUoVzpw
	94KL097lqOKe9isw5N0oJkYVte7vFAJCreeKUcAter7HlZMhMNhf1mCQvcdRNi1tRylgRTPciPh
	rEvPk23XIE0HQqyCHLHftLdw1SWkuqg5pvvjP77GbWhIlOsD2f0KGB+Wi4izDcOdTXCfePF9vRq
	R85NGBiImhE2NI6DVlAHKqtU8P5MJbPSffDq0JBFqKts0SpUPc1G+iK1dC8XMyU2SpU7PygGORJ
	2qZKfPDWmZ5QBoyjK0h9+zt0MxPxwyg=
X-Received: by 2002:a05:6000:2b12:b0:488:8931:b1b2 with SMTP id ffacd0b85a97d-48e385962ffmr2119753f8f.28.1792756383503;
        Fri, 23 Oct 2026 04:53:03 -0700 (PDT)
Received: from SurHub.localdomain ([102.208.97.12])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e38048ad9sm4787574f8f.35.2026.10.23.04.53.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 04:53:02 -0700 (PDT)
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
Subject: [PATCH v2] smb: client: fix fiemap wild read on empty truncated response
Date: Fri, 23 Oct 2026 14:52:46 +0300
Message-ID: <20261023115246.23030-1-suruurism@gmail.com>
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
offset is never computed from an empty response. Also require the last
range in a truncated blob to advance the resume offset without
overflowing, and to stay within the requested range; a malicious or
broken server could otherwise make no progress or underflow len and loop
forever. Free the previous response buffer before retrying.

Reproduced on 6.6.87.2 with a malicious SMB2 server that answers
FSCTL_QUERY_ALLOCATED_RANGES with STATUS_BUFFER_OVERFLOW and
OutputCount == 0; an FS_IOC_FIEMAP ioctl on the mount oopses in
cifs_fiemap() with CR2 = fffffffffffffff8. The code path is unchanged
on mainline.

Cc: stable@vger.kernel.org
Signed-off-by: Abdifatah Suruur <suruurism@gmail.com>
---
v2:
- Validate the resume offset in a truncated range blob (overflow, forward
  progress and remaining length) and free the previous response buffer
  before retrying, addressing the sashiko review of v1.

 fs/smb/client/smb2ops.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 20624f5dff9b..56b3b183db4b 100644
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
@@ -4380,10 +4389,31 @@ static int smb3_fiemap(struct cifs_tcon *tcon,
 	}
 
 	if (!last_blob) {
-		next = le64_to_cpu(out_data[num - 1].file_offset) +
-		  le64_to_cpu(out_data[num - 1].length);
-		len = len - (next - start);
+		u64 last_start, last_len;
+
+		last_start = le64_to_cpu(out_data[num - 1].file_offset);
+		last_len = le64_to_cpu(out_data[num - 1].length);
+
+		/*
+		 * A truncated range blob must advance the resume offset and
+		 * stay within the requested range.  A malicious or broken
+		 * server could otherwise overflow the offset, make no
+		 * progress, or underflow len and keep us looping forever.
+		 */
+		if (check_add_overflow(last_start, last_len, &next) ||
+		    next <= start) {
+			rc = -EINVAL;
+			goto out;
+		}
+		if (next - start >= len) {
+			rc = 0;
+			goto out;
+		}
+
+		len -= next - start;
 		start = next;
+		kfree(out_data);
+		out_data = NULL;
 		goto again;
 	}
 
-- 
2.53.0

