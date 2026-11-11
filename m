Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794436010;
	b=LDeplPZ6xdubbk2CfnEpIyKaoz+ICxopoxZABSPZNugbO2BXA7eUY/iPuPtPBiQCGKVU
	 WVGwCb3wk8ReikVXGILB5NYgFt9Cusht4G3OvSl02q9IyLAbHO3a/ZK9BlmKlk0KIV2JL
	 UD3RLYhoG4vQs0TC7E5r0dL6OI5Gsw1uznmIbDNCRy9Z+cUBEKQBFtn6J/BtiaxMKIGC0
	 QvJSdUj/B8XKKt1+N5rNL+0OjwEqHQo+LKwEUPQXBMtTiCEnw8tKp2CMKXHkvXvZ5rmxI
	 4e6l+Dbt0YIs5+crsW+7S+vOD6UaYyI+73M41JHO/P6x02vBDdowYk5EQt/bm75OVJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794436010;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ga7jzUYmGDL77fNJVq4eVL8ok2xCIWbQIcFmq+e+3Uk=;
	b=mU0gK8mMlMaXTPeHb9ez3IUHdHlidwoA3m2Cge5wXRo5lcZ3WTX4tMwYngqZYmUVjEQT
	 0DRALuOqakr4QaooNXKnULDVIFztwnUuYJ44s0vDG9U4/no6rVb/RvwPACcBYyVO/6JcD
	 CdK38um549MEU5QMtRrdzywcLFBFANKPJANHPzxvvEhYToEFtX7aMdoN09eILwwbmvrSY
	 xQsWdcTDe/7vw8lxLFq/LS+HAry37aw6D10dV0UvDjLHtrXvnh++GUkIL8TnRLLDEYuzC
	 gyPWLiZ5sjhTNqZtDocFqFxegt6OXR1mvD4zVyI9UBwuiamZh6JTHTp9feNZhpfAWGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bywUqgPe;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB07606A324
	for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 22:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AFB07606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bywUqgPe
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a214c5c4c0so36689565e9.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Nov 2026 14:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794436008; x=1795040808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ga7jzUYmGDL77fNJVq4eVL8ok2xCIWbQIcFmq+e+3Uk=;
        b=bywUqgPejZ8cEXqsOHexBd+3E7SGspGOsYd22CFk2rtk+C/DQDZhxK3obhUp9ZXIyd
         hHYgXckMvEeSdS7s0EvVOOQObe33dIA1inOgEGP78GhpWETBG9gNmyNqXKx7kjnKHMAy
         b2Tz1/AFs90lFd0zfJ7t6Ymd4n37pJEkM26gx+irGgH8iTwNOaZPB04XgZnvW+Z6C1g7
         XQVzhdu8CgVXUMleJwAJ8YGZ3kPv2vY/i/c601BR+pw/xwIbYcQDgTcxMXPDBp40pZDr
         zNJsxTcDTBJzhrJ+BtjQrJWvN09SXwiueeVLakL4bkR6Sk3teIrwzMk7BOKUn7PcLQhu
         V08g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794436008; x=1795040808;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ga7jzUYmGDL77fNJVq4eVL8ok2xCIWbQIcFmq+e+3Uk=;
        b=z2VJprOXs15NXPLBTiDlz1ROkr0lKcFYB+mF+aFNAJU8v6LRHcAf5CSXl9dSB3Om8d
         +yqHbjt0dWvlcHBQnalrQBLS5o5o9E3KIbInUB9TsuukOTZ7LiIhxHavVAkKvbBM+HMX
         ehkifdGfm8S92U2BqIcKYkLmZLBCRiP6xghgk6Frsd+xva1LEW5JVtc7bVOyrXNwL7xF
         a8OsqO7d4m3uA2fmc16xR5dhfrcoDkuBeOLQFDajEgIqZZDuMP+O+nTSP8TRiBSYCPHs
         fnQJRBtjrIjDkGbmCN2RlqtzVFg4mgE9WI7rel9fEocBURhogWIoyiktpGE+enFxxRn3
         rbCA==
X-Forwarded-Encrypted: i=1; AL+hErEEaPdDrmTdoAszJI9o0Sn8ll1SgjZK+VHFcyvgNLakYib8xTA8+uRUwSB974TQD6OYu6Lo368Lwht4@vger.kernel.org
X-Gm-Message-State: APuU4Z8f0GwofNEZ7jpb1O6tmVlmA2GkpUH3wZgv8AdGMFeU+U4XNNyq
	Ac6IONl7d83BnFd+tjlS7QTXg5Q93yTxQPlQphOGRCllWC4J7adCQLea
X-Gm-Gg: AYBFou1amI5q2Uo8KH40AOtbgBSqheA65kdhUTCkaNPH8n7ra420xPewNkLB5w7KFHI
	Pvk0JMMnuuN4L00QSAnkAqC7QM9ooqe/byPR11fUYccQtZvOfo6sbKoz0ajNw9vjGsPAaj8qsgE
	d1m5zGVirOH6dgGaUmrE+eSDOS0GAkg+m26a8+Nnyq49SRJIvEvvOy98XamAMvySwEFI4+IV7hm
	WNzvd2oLnscWRRYIAYIeQhh7GKMfsO30rjtJqFIY1zXrKc5OXPDlSFvUQdCDS680FrLinM7L+cm
	MgaIyDfvgYn9WolWmlmY3/tYKvO5thcghldlWaYb8DDLbgLBiDIimCrRiqzq9ME+y6wpljJNz3T
	EU8PMqQbu+CnQh7TNoKhoZpT6PScawA3Wn+LVZJD57lwLLUXTacTy/JNOSlAOzzV2eGfhl0SS8z
	MoDPTs9HJM74C4LF5dQSaigU+2+DfJt0rzsIb1ca3IOIXxz7uDemTLPtIJyxyElu/mmF/rL3tFa
	lrmRl2+X39T84M9XW8p8nlNR6K5MHXSxXVWl92RHuPm74cQMJ24c/nJqnIUCTXf+gQATbHg1P+X
	Q/01yiVloHTyjG1OfECkZqTJNA==
X-Received: by 2002:a05:600c:4f84:b0:4a1:e92b:ae4a with SMTP id 5b1f17b1804b1-4ba093b9a3cmr64193365e9.21.1794436007944;
        Wed, 11 Nov 2026 14:26:47 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e251491sm20204945e9.2.2026.11.11.14.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 14:26:47 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix timestamp corruption on special values
Date: Wed, 11 Nov 2026 23:25:34 +0100
Message-ID: <20261111222534.839117-1-koray.fra@gmail.com>
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

When a timestamp is being sent with "-1" or "-2" as its value because it
should be ignored, as specified in MS-FSCC 2.4.7 FileBasicInformation,
ksmbd would clobber it in both the xattr and on-disk value by setting it
to -1.

simple reproducer:

echo test > file.txt
smbclient //127.0.0.1/test -U user%pass -c "put file.txt repro.txt"
smbclient //127.0.0.1/test -U user%pass -c "allinfo repro.txt"
smbclient //127.0.0.1/test -U user%pass -c "setmode repro.txt +h"
stat repro.txt # the actual file on disk behind smb
smbclient //127.0.0.1/test -U user%pass -c "allinfo repro.txt"

which would show, respectively:

altname: REPRO~MQ.TXT
create_time:    Wed Nov 11 21:23:16 2026 UTC
access_time:    Wed Nov 11 21:23:16 2026 UTC
write_time:     Wed Nov 11 21:23:16 2026 UTC
change_time:    Wed Nov 11 21:23:16 2026 UTC
attributes: A (20)

  File: /tmp/repro.txt
[...]
Access: 1601-01-01 00:00:00.000000000 +0000
Modify: 2026-11-11 21:58:10.145349236 +0000
Change: 2026-11-11 21:58:10.206350216 +0000
 Birth: 2026-11-11 21:58:10.144349220 +0000

altname: REPRO~MQ.TXT
create_time:    Wed Dec 31 23:59:59 1969 UTC
access_time:    Mon Jan  1 00:00:04 1601 UTC
write_time:     Wed Nov 11 21:23:16 2026 UTC
change_time:    Wed Nov 11 21:23:16 2026 UTC
attributes: HA (22)

This patch also makes the smb2.timestamps.freeze-thaw test from
smbtorture pass.

Cc: stable@vger.kernel.org
Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Link: https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-fscc/16023025-8a78-492f-8b96-c873b042ac50
Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.3
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
Another small-ish fix I found while implementing ptime[1].
(And probably won't be the last one :c)

Thanks.

[1]: https://lore.kernel.org/all/20261101015551.786044-1-koray.fra@gmail.com/T/#t

 fs/smb/server/smb2pdu.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 92843d2944e4..5b046f10e2ce 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8867,6 +8867,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	const struct mnt_idmap *idmap;
 	__le32 attrs_mask = FILE_ATTRIBUTE_DIRECTORY_LE |
 		FILE_ATTRIBUTE_COMPRESSED_LE;
+	s64 crtime, time;
 	int rc = 0;
 
 	if (!(fp->daccess & FILE_WRITE_ATTRIBUTES_LE))
@@ -8882,21 +8883,25 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	    (file_info->Attributes & FILE_ATTRIBUTE_TEMPORARY_LE))
 		return -EINVAL;
 
-	if (file_info->CreationTime)
-		fp->create_time = le64_to_cpu(file_info->CreationTime);
+	crtime = (s64)le64_to_cpu(file_info->CreationTime);
+	if (crtime > 0)
+		fp->create_time = crtime;
 
-	if (file_info->LastAccessTime) {
+	time = (s64)le64_to_cpu(file_info->LastAccessTime);
+	if (time > 0) {
 		attrs.ia_atime = ksmbd_NTtimeToUnix(file_info->LastAccessTime);
 		attrs.ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
 	}
 
-	if (file_info->ChangeTime) {
-		fp->change_time = le64_to_cpu(file_info->ChangeTime);
+	time = (s64)le64_to_cpu(file_info->ChangeTime);
+	if (time > 0) {
+		fp->change_time = time;
 		inode_set_ctime_to_ts(inode,
 				ksmbd_NTtimeToUnix(file_info->ChangeTime));
 	}
 
-	if (file_info->LastWriteTime) {
+	time = (s64)le64_to_cpu(file_info->LastWriteTime);
+	if (time > 0) {
 		attrs.ia_mtime = ksmbd_NTtimeToUnix(file_info->LastWriteTime);
 		attrs.ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET | ATTR_CTIME);
 	}
@@ -8915,7 +8920,7 @@ static int set_file_basic_info(struct ksmbd_file *fp,
 	}
 
 	if (test_share_config_flag(share, KSMBD_SHARE_FLAG_STORE_DOS_ATTRS) &&
-	    (file_info->CreationTime || file_info->Attributes)) {
+	    (crtime > 0 || file_info->Attributes)) {
 		struct xattr_dos_attrib da = {0};
 
 		da.version = 4;

base-commit: ffde0bdfc69a0f01a081d9c1a213e63d5719e625
-- 
2.56.0

