Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794843942;
	b=YzYjHydNVdiP1GG5R+J5D5/oYAbF8vG4tcY2+jO2+luml5kOZVhX9lSkQ5JrCSRfcriV
	 6JXeWpLwFpKrZjA3zKLlG1HGVqP1sbQ9m7uvT6Ysw4Pdls1LwJZfx90IIC1V9Lzc86sTA
	 YF14qmheHtRmPVUus/mJfO1dPeUGvFqAs62C4Sy8ZXrk/FMl+4EPk+OxoZG95FAJ4U8qs
	 +SA0lWJ1H5CwF8+vITPoN126t2XbH2gMMfSsu4kW7KtZiwyuBIKnKUyMabgoxQiZfxmpf
	 dOM9kHvL4pqutU3YbTOfVsxoXbRS4w8TUbwsK6wpnji+ctIwHjpHracBoyCLiHdROxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794843942;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=YrQg8b1HMQfdVG/FMxGjW2qYHjNymOxo+4+eTQKFo2U=;
	b=jn2lI1kAYKAcu5zuHQCrc+8BPvfJtNpBA1iOxQw+akIsaSdG0aAkh03vPdmz1D2p9slY
	 x5Wh3fRTTqNCcCKLZ3DMlgXfmR1jR6fQK7uDnJlzlkJL+3/hmRHJVDx5Tw+X09mel1rQv
	 lc6jpHs597OIeEnCOck1eK1vzMpyYFOoUN+xVf4e92pYndTDpfb4mWS8fHbzcHy68Hj3k
	 Si8Ju5LpXbroEOdrI/on+9tWuT4NUvXeVE5MRUZF1GJzCX8+dolQaMkpUT2qWDaXsRkc0
	 BX/T7sYZGsshq4RyvxSC5W/jte/+jbNTs+SfJO9nQnElW8HFO3s/fP1vqOiMzNYe9LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oi14qhen;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A07606A322
	for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 15:45:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2A07606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oi14qhen
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso13567945e9.0
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 07:45:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794843940; x=1795448740; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YrQg8b1HMQfdVG/FMxGjW2qYHjNymOxo+4+eTQKFo2U=;
        b=oi14qhenTRx25hlwwDKhZ/LWV/uSlT2RNCHeTID3Dz65o3FX3regIYGRq4ugzgS1uB
         peO8I4FuTjCyiDAE2cipjJM6tIM6etkZZLDY5ujAaGpdR6fBlx1sDLhX42U6n+SvTsDG
         DhiL9/tiMX1cTyS4BDTxZmbMgw6iQi4h5zsFoC6FsEqPgk2vb+tefD3V5q2KGmyqC7NB
         Mff6X/6u7EDkfBJo1CR/d68zN9Yp1/E74o13bpic+jGaCJrSrZT0jz5YwZZBRZ6Gd3bn
         WYWflAMGWHGL79DZX44rHvPl/CnGEb7d8BbOr45PDDSEZQIpTwp+bAIIyu8UoeTC3L1U
         AUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794843940; x=1795448740;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YrQg8b1HMQfdVG/FMxGjW2qYHjNymOxo+4+eTQKFo2U=;
        b=OWubbHfe+tWNn5A+wdnixh0dXY3B0Y7zfUKjhnzozWDtKX9ExloGlMRq0FuBrbtWkR
         BfzPeSjRuCVq4ZT9ZLM3NP7tPBDSuoGFAf3VGv1ufthh4uC+U59fHv88tF/CYdxPqHF3
         nzWanjB2J1U+6+zcxvLyPWdvFMSr6kGTeTaQRsbjvuId+a/EN3PKuZmsK7ErwOPTjwN7
         eguDysj1dW2MFCW5GJiiP7a5FH2D2V1QNEGL2/oQsAsR5PSeeG6TetBs78ykWcLH7P6L
         hvw3lzdhqeEoGZx/gmwvJ6bIycApCSUchDiBAmpO5NkB71Q5piMTsdF9R3SdKmgBXJ+T
         nIPA==
X-Forwarded-Encrypted: i=1; AL+hErGmZenXJGmNg0rp/4BOIXhTKJvntFWCboaUeBTWRc8XRKqU3bCyxGWTu6hwplIvm3FItHqY3SNT2T/2@vger.kernel.org
X-Gm-Message-State: APuU4Z9vSP9uTv0dP5Jd9HJCoK/T01oE2yJ4TuJta7uxEe2K1eIyusIB
	arEpnhqlyoZCx5X0OteKnDHBU8X5chKGBFjGbPhzEg3IeZk/qlMTNKm+
X-Gm-Gg: AYBFou3HhGEVU2HCgRdzukJlvBijIDJtkCI9MZc+OXoTxzOPNrKl+He18o/W0gQeVL2
	53JHqvjSt4PSyMhfC41cLctM4yphSSr8ayjYMx3nHhemwTKjwCXQ7MrcSnaoMzkyMrbu2TYhEbW
	zz/I/SGzskspl2LBjIgmJiWU+1dSswBbXqKc1pW+igQ0TDVS8pvFLoFZm7TCEaAKV7VHsoqTHP+
	nOCtAMiCcdZcd6RNPI4wyzldDU3/LyWOzuP/JvnmsRAVBMFb//bSzp3YjDlD+sH5En6hJC9ZZo5
	bIYGL/qjCoOmKWVHjxIeZ9S5LbwZ4ooA05IdZ4VuoAQk8dCcBH0vZd2N89ifF8wbAP6znWLlmoR
	EC+Je0xiEw6X8ZgM/vRUICOWIIlT7gf80yYRVAXt54gVkIxm9Lo5uNUVQCNqVps82vuSgZ82wA+
	IwcAC/caVHlsqycr91X57xH0rA3PuAWoMyyAz0DjKTaM/KYumV9zrPINYGn8/v6c7Hx/GsM1rCZ
	dzb6mExZ0wnXO5RwXAk3VgEwKEbfB4vClPemzHhfPRSRDiSAJi9fxea8KGKtHtlkvpeLI+d/+LR
	BtdSqCZoSxbHvDHueAlIyOCN
X-Received: by 2002:a05:600c:1906:b0:4a1:c6f5:2450 with SMTP id 5b1f17b1804b1-4bb55ac2a34mr244233205e9.17.1794843940079;
        Mon, 16 Nov 2026 07:45:40 -0800 (PST)
Received: from infinity ([2001:b07:5d26:7a6a:365a:60ff:fe0d:cfc6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb4e293540sm395008555e9.8.2026.11.16.07.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 07:45:39 -0800 (PST)
From: koraynilay <koray.fra@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Tom Talpey <tom@talpey.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Aurelien Aptel <aaptel@suse.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	koraynilay <koray.fra@gmail.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH] cifs: fix times assignments in cifs_posix_to_fattr()
Date: Mon, 16 Nov 2026 16:45:26 +0100
Message-ID: <20261116154526.429315-1-koray.fra@gmail.com>
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

Currently cifs_posix_to_fattr() wrongly sets SMB's CreationTime to
fattr->cf_ctime.

Fix this by setting fattr->cf_createtime to SMB's CreationTime and
fattr->cf_ctime to SMB's ChangeTime, matching the behaviour of
__dir_info_to_fattr().

This patch also fixes a few related issues reported by sashiko on
another patch (see Sashiko Link tag).

Reproducers for these bugs, with /tmp as the local filesystem folder
exported as [test] in ksmbd.conf and /mnt as the smb folder mounted with
mount -t cifs:

  mount -t cifs //127.0.0.1/test /mnt -o username=ciao,password=c,posix

Issue 1: ctime clobbered by CreationTime during readdir

  mkdir -p /mnt/dir
  touch /mnt/dir/file
  sleep 4
  chmod 644 /mnt/dir/file
  stat -c "ctime and btime before readdir: %Z %W" /mnt/dir/file
  ls -lc /mnt/dir > /dev/null
  stat -c "ctime and btime after readdir:  %Z %W" /mnt/dir/file
  stat -c "ctime and btime on disk:        %Z %W" /tmp/dir/file

output before the fix, notice how ctime is the same as btime after the
readdir, while it's 4 seconds ahead (because of the sleep 4) before the
readdir (on disk timestamps are not touched):

  ctime and btime before readdir: 1794842068 1794842064
  ctime and btime after readdir:  1794842064 1794842064

  ctime and btime on disk:        1794842068 1794842064

output after the fix:

  ctime and btime before readdir: 1794842908 1794842904
  ctime and btime after readdir:  1794842908 1794842904

  ctime and btime on disk:        1794842908 1794842904

Issue 2: btime and ptime wiped out by readdir

[ no reproducer as it only happens after the linked patch series is
  applied, since it needs cifs_i->createtime = fattr->cf_createtime in
  cifs_fattr_to_inode() ]

Issue 3: in-memory inode aliasing (flock bypass on hardlink via readdir)

  mkdir -p /mnt/dir1 /mnt/dir2
  echo "test" > /mnt/dir1/h1
  ln /mnt/dir1/h1 /mnt/dir2/h2
  exec 3< /mnt/dir1/h1
  flock -x -n 3 # get exclusive lock
  ls /mnt/dir2 > /dev/null
  exec 4< /mnt/dir2/h2
  flock -x -n 4
  if [ $? -eq 0 ];then
  	echo "acquired: duplicate in-memory inode"
  else
  	echo "blocked: same inode"
  fi

output before the fix:

  acquired: duplicate in-memory inode

output after the fix:

  blocked: same inode

Fixes: 3d519bd1269f ("cifs: plumb smb2 POSIX dir enumeration")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20261115180343.576773-1-koray.fra%40gmail.com?part=10
Link: https://lore.kernel.org/all/20261115180343.576773-11-koray.fra@gmail.com/
Assisted-by: Gemini:3.8-flash-high antigravity-cli-1.5.7
Signed-off-by: koraynilay <koray.fra@gmail.com>
---
Thanks,
koraynilay

 fs/smb/client/readdir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
index 525f99181485..5d335f12eb24 100644
--- a/fs/smb/client/readdir.c
+++ b/fs/smb/client/readdir.c
@@ -253,9 +253,10 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct smb2_posix_info *info,
 	fattr->cf_bytes = le64_to_cpu(info->AllocationSize);
 	fattr->cf_eof = le64_to_cpu(info->EndOfFile);
 
+	fattr->cf_createtime = le64_to_cpu(info->CreationTime);
 	fattr->cf_atime = cifs_NTtimeToUnix(info->LastAccessTime);
 	fattr->cf_mtime = cifs_NTtimeToUnix(info->LastWriteTime);
-	fattr->cf_ctime = cifs_NTtimeToUnix(info->CreationTime);
+	fattr->cf_ctime = cifs_NTtimeToUnix(info->ChangeTime);
 
 	fattr->cf_nlink = le32_to_cpu(info->HardLinks);
 	fattr->cf_cifsattrs = le32_to_cpu(info->DosAttributes);

base-commit: 9928f403dfafd17dfe45678bbc6f623f72528744
prerequisite-patch-id: 049ae0eba275b5be35a238833107e0b251a55aa2
-- 
2.56.0

