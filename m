Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792523037;
	b=KnHYw8iomtsC5R19ZaVppruul61yCslfURVDn7VnAYemT4hBNkYApnp4+rHT2beqvirJ
	 DheXyeSJfjIz3qUih2A66kKA5xsMD9gtZgiWkVwMbjFHjlHQol+QlgxKc2p1PdWTkCOzh
	 /dkUUbpbAd/coH+xsuScuQ1+PGUliguUdqoL2jxI7rD+8n3gnd3ThmWyCPKlu+7v0GTjW
	 99l0xUdPnLnhSntMFV1cZl9sfy+4kap1EpKn9+ZCAszP2cuPJ/hSpWgsggWavYEcY8DIH
	 WrRlsQkZ3dwATYksU2S1cQTVXisEFTT3BekuLOGi5McOIdPLFSHKWFVkAuwPZCs4BjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792523037;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=m+YVhDETtUQWm9g1HvFHGXlxhsLtvKkYiiefCwtpS5Q=;
	b=NXW2aFTg+/htIM2A/k5Gcy7M9STsAcrqXTnRMsaO/Rl+EnGx9OwpgIU+z+scpR+Oo3cI
	 W8NWSFePB82uOKxoS5FFW/wNY81arKpqktN6qP9fnNYhB7spPbAFS/v7u2X5XVf3+xRa6
	 Eh7av0NEw2HkC5NRiLMbslbKBnXwiWWglFYUQ34yrRRbzYOld1OgjLYfcIDJY8w0qMbk6
	 d5QUHVVQwoC50JDmu7Axo3k/BH2N9YPEzb22/ajOef91Bs1wtwRUwyzAUHlGIqxcrUOEK
	 SvucUoAwxKc5Ln8SYydiO3IF6FKbix5p/ZunjCIwMJPC0Lte3gooAGSJ580z/KP/9Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Yi1QS84B;
	arc=none smtp.remote-ip=209.85.208.53
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30202606A319
	for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 19:03:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30202606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Yi1QS84B
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6aa9164072cso5012046a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 12:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792523035; x=1793127835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=m+YVhDETtUQWm9g1HvFHGXlxhsLtvKkYiiefCwtpS5Q=;
        b=Yi1QS84BGHvS8TsgRfabeYKIqe70t8cUNCXCVXCmavgsqsUzeP1VJbf7UDqxQRbvHX
         Wk+y8GqSYwdO0exxPbPb3hBvRhyAnCfeNVAoY6WIdDkjacF2+jMOsZ6O85wi2ebiagy6
         GioTRewLq6QPvGlqHl9+ygm4T/An5kAObTYsZnhek1hxs8BAcMGDMgbCHwiZmjy/RnB5
         YD5tUsMix7DS3s753iR1oqHU9WTOG64ucFZIQCdMcHen/Z2mUpf2bV1RvKjopYaP3DpJ
         5nXAcvUs+HJ1uuKHOcvrmICOwUtEkSp0V78sG7A9zdGKwYF5ZAfgwvHeah5uaX5AX2de
         t2Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792523035; x=1793127835;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m+YVhDETtUQWm9g1HvFHGXlxhsLtvKkYiiefCwtpS5Q=;
        b=lwMMrtz8r7nXCHbRVLUmOt7+uWxxvTTt79HU5bxG+3JuDwncz1JuYKok2Xnnk2lFqu
         M3Dz8TAjD/+s5L04dj4cQbpPlDUBEVaRiD6bQiek+N1sCm17ZT90/CaQGeNZBRo1bRVZ
         hEbYsykeiqlwprK2TOpa421YBAN9N2Ir7SG4CuQABCwbNg0f+TR9pJcLH9J/jXr8zAmI
         zsm2FrOVd5GpTbHvGyaq8weBfY8tpnxWdkXNd88xK1apsEpPnCJdUxQgiaIDhdsGGgpP
         wZN8tc9gWCxQa5PQgd7ZpmBcoJYNyCJIpdFlzca/wd3hxv3oFypIKkyue0sYkTnA6YoA
         98mg==
X-Forwarded-Encrypted: i=1; AKwUvBxFCG8ujAqoKRJPehqbcnUmqps4n0ApBDYP8GwQBirPu4d7yMSM1fczXHDxw6PQksNtYIFkCeVb4ZWV@vger.kernel.org
X-Gm-Message-State: AFq9FYIqB10iBcVxPxJoxdkE71ckg77jsBS9wUlaYfstWv4yEoOxsUXu
	EnMSZdYm74Cu3+Vpos7KJgLhJk+2Lg9G9MFdKLdgcvJ4Qzll0ObytZ/o
X-Gm-Gg: AYBFou2SBUkw3JnZgB/GcamY/gJKFcaxXAgaiLxYDWP8/FKR1FbPfcGnLIyyZb7/GFs
	tfZYAzO2si4ZXGzZqVXjHtExsDrCFoT86srCL+AeP/c880fbIJURJOLZV7c/bXk/KaA7OZmpE1S
	ALkmQJdD8YU6a/NaDBaOtzcwFMIGFkz54cV7oVNfmo5t2/xFKNruCxIkUoSO9G6nF7r27NwXEU/
	MmPAs5y5MhPKkMnmkNyUKhjnNowUbblyoFXEZV7NFZ2snPb9x4aWmpbdmGxENlKyqGPY0WuDNBH
	dnCKLFfy43mOM6Q7vAs2SY2NMh2MgYo51gAQYEU4Ul6xRftQ2DBMsvEO3ceF4uO6P3HQAUP/KFw
	bwuYF/7yvnBos3BQyYPkoq7AfDVnvOJEe6Bow7AO9J5lBrKS1RONcK+5zg+XUDUlH2C82fqf/jG
	rblyCp60VOkGvdKDurVZuBS5BVrFTDZdmI/CQW6blCUBADlHo3lPVTd9Q/72B8yvjeV/wqHZ6Fg
	7u2HoxC1LExurAHqsxYsXa2/s/AT66dMLGZ8XwrXmXQ7QU4qppp0KjTqmI4AnxHQWWqXxW3M2/l
	A7SfT+tgdA==
X-Received: by 2002:a05:6402:c287:b0:6b1:bbff:6ce1 with SMTP id 4fb4d7f45d1cf-6b3a81c7156mr5153026a12.45.1792523035337;
        Tue, 20 Oct 2026 12:03:55 -0700 (PDT)
Received: from wlan-199066.nbw.tue.nl (wlan-199066.nbw.tue.nl. [131.155.199.66])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b403110a23sm24516a12.17.2026.10.20.12.03.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Oct 2026 12:03:54 -0700 (PDT)
From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Subject: [PATCH] ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
Date: Tue, 20 Oct 2026 21:03:51 +0200
Message-ID: <20261020190351.9445-1-mike.michalo@gmail.com>
X-Mailer: git-send-email 2.56.0
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

Setting FILE_ATTRIBUTE_TEMPORARY on a directory with SMB2 SET_INFO
(FileBasicInformation) succeeds: ksmbd keeps the attribute and, with
"store dos attributes" enabled, also writes it to the DOS attribute
xattr.

MS-FSA (FileBasicInformation) says the request must fail with
STATUS_INVALID_PARAMETER when FILE_ATTRIBUTE_TEMPORARY is set on a
directory, and Samba rejects it too. smbtorture's
smb2.create.dosattr_tmp_dir checks this and fails against ksmbd.

Return -EINVAL, which is sent as STATUS_INVALID_PARAMETER, when a
directory is asked to become TEMPORARY. Do the check before any
timestamp is changed, so a rejected request leaves the open file and
the inode unchanged.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
---
Tested on ksmbd-for-next 454ae8e5c306 in a QEMU x86_64 VM with
ksmbd-tools 3.5.7: smb2.create.dosattr_tmp_dir fails before and passes
after this patch. The 187 smbtorture tests run by the ksmbd CI, plus
smb2.setinfo and smb2.dosmode, give the same results with and without
it (smb2.dosmode fails both ways, for an unrelated reason).

The same failure reproduces on the Ubuntu 26.04 arm64 kernel with
ksmbd-tools 3.5.6 and smbtorture 4.23.6.

MS-FSA (Creation of a New File) also says that creating a directory
with FILE_ATTRIBUTE_TEMPORARY must fail with STATUS_INVALID_PARAMETER,
and ksmbd doesn't check that either. I left it out because I have no
test for it; I can send a follow-up if you want it.

 fs/smb/server/smb2pdu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 40af35c0aa29..1ed8e8135c58 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8695,6 +8695,11 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	inode = file_inode(filp);
 	idmap = file_mnt_idmap(filp);
 
+	/* MS-FSA FileBasicInformation: a directory can't be marked TEMPORARY */
+	if (S_ISDIR(inode->i_mode) &&
+	    (file_info->Attributes & FILE_ATTRIBUTE_TEMPORARY_LE))
+		return -EINVAL;
+
 	if (file_info->CreationTime)
 		fp->create_time = le64_to_cpu(file_info->CreationTime);
 
-- 
2.56.0

