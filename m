Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF57B38655E
	for <linux-cifs@vger.kernel.org>; Thu,  8 Oct 2026 15:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791473163; cv=none; b=oIU6mCrIQeVD/HC93hJKNghfPitUHVp+GFy4F1VCd19aijXCxY9rDZc6fZOtQmPPvzRqyTXgXCPsCCHic++ATI5sY982+LogdnngFl6MyJ0N7pVKRw3ViBlqFQW1hpELZqtrRcTl0fISwqU1Gll7gfOwdAolMxAXZKCtPJk/qUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791473163; c=relaxed/simple;
	bh=TrVcGHbj2TtSqdQJyHLxeKivTSFUEkce/cKcVLryNGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C336pVJBeK9t/K4gf3prxgEFryfHk2rWCrbMN9f0fIBpBSacGs6RXZwPAuVVRbDV4MkiUWwv5xg4+L4fP+4atyarDBn38oZtFjJnjn+N25dLhbV4i8XPmAdX/tM/JQSJKvtKGuGuG3friYfB6d5CzU6Le7hocqv4t/Z/n+IxKSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EelizpaG; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EelizpaG"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a88dfb65e7so150851a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 08 Oct 2026 08:25:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791473154; x=1792077954; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n4w9bZBZ+hZ07uC6pPSV2O57YUginTevP0JitdrcPK8=;
        b=EelizpaG98H/6ol4S6fWhXNCASN6Spw/+xv46ntz72aluG5qpEKTM8KUOCHTj6l+Yy
         Y0dEEwHjgzIXrBOmwYuM/sv5q7rjpk+vDwTnlxG6XoDZXjfJEpsHzZXVbh1THh38X+I1
         AHAlT6MSgNxEl+2mQjOhVMbVeARKaLEF/EUL7pUMA9jAbFnezzx0RHJLXvc9oJe5jgUM
         64E/EY70jsnovJ8wSauteR6BUsT4QTaWkEeHN6VrrRl3iBBAuMAy342dzRrexn6vPGnu
         kqhXfPpKPeeqWH0FmRt7QvqREGZba326f1rrjsZFukzXdWe2IN9XLvbOq9Vf1NKdxObm
         r80A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791473154; x=1792077954;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=n4w9bZBZ+hZ07uC6pPSV2O57YUginTevP0JitdrcPK8=;
        b=XjKvMVqNZI6N8fcgd7GoCBaxOIgCylcGG0UOsmoIr3GK1X8CEGdsb+9BgJR56T7zyu
         Jn0mOT4GFRwvHPj6EcmvK4ksr5DAbfVT0t4fP7pi2cJ4WGPorRc/f0A1ZUzt62cf6adX
         uI8uqOoOekO8RKqlsE+r65FH+T2f9z2k1yM7GUoy/aQHs7o/fcIPxpD8RqXTWFG0lBp4
         A3m20Ula0Tat9GwQJyntxmQyvQLFHZbc39YcUbGqwSLtKkp5C7R/42PbBaVzCrUiuaXY
         vCzUor0Us7KX+7IuRyLtNaRJaC3SSNHlagnwsD5INCiZQ8jRzweL7yRe864Sy+LkfNFp
         T32Q==
X-Forwarded-Encrypted: i=1; AKwUvBzZrqgrkUv+C1Xob+jDWertarclWrIAx0Hz0reBFx0BZ8Ka8EPBLL9T5KGUJuXxOD8K+vLww1UntMob@vger.kernel.org
X-Gm-Message-State: AFq9FYJ3bxWrXTVYotOmMFxLpoESFTozH9oyTHaGS2xMXlvhC9IDfhDt
	WAV7aSoWK3X3rpQq60fPx5VBbS6CLHS8GW/VptHCX8E0til5omIPa/dm
X-Gm-Gg: AYBFou287EFHImcCE2HrbbbQo6iNxGr3HLGz8dGRVQxWfpo3NFXqqZUIqjU+L76tMZm
	0ThndR9TmbszpNJampF/V7TVjOTlez8jB4s7H8fGwOz/Oy7dGO+3h/ZXwz5kHQEIhKGh+i0+vP1
	uYh8y90UkYjK/6W7tgFJuO6nQIlJ5BCGwb+zodD+Uha8HxtnSsW0pp1oQ5jqU5vL+1fyogA4wEo
	7hXtR4oI2lsLuU9hsIWu7VgcSStr/m3ENnolXamC6FbcLX433DE2kMj59TxqkSp1/7+xeRY2RkO
	bVwCi/+LQsxRObVIKUG4ro8EKANF2BvZ7RmshSA1FuIQIu7RNrcsKp29s0FRXS8oFtk/6qA+q0h
	sobDe1Ke6QmqMLKymys71nujxkoxEqCU/rfJ5suucIA9jyrgo+VmVy/wUVJSY0rDeYgglbxNlPS
	22nQ4vhe0s0uuGVmFk4cpo4uLfzg5xCbWabOQKelM1v9YDFntoJAAmEiyc2QBZfSeEMXA+6UUtR
	EU=
X-Received: by 2002:a17:90b:3b46:b0:3a8:9db2:a59 with SMTP id 98e67ed59e1d1-3aa7c6c21f5mr4045344a91.0.1791473153896;
        Thu, 08 Oct 2026 08:25:53 -0700 (PDT)
Received: from ser8.. ([221.156.231.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1c17b63sm5554792a91.12.2026.10.08.08.25.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 08:25:53 -0700 (PDT)
From: DaeMyung Kang <charsyam@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DaeMyung Kang <charsyam@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/3] ksmbd: return end of file for reads past a named stream's data
Date: Fri,  9 Oct 2026 00:25:35 +0900
Message-ID: <20261008152537.4147299-2-charsyam@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261008152537.4147299-1-charsyam@gmail.com>
References: <20261008152537.4147299-1-charsyam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A READ on a non-empty named stream at or beyond its end fails with
STATUS_INVALID_PARAMETER. ksmbd_vfs_stream_read() returns -EINVAL when
the offset is not below the stream length, and smb2_read() maps -EINVAL
to that status.

smb2_read() already turns a zero-byte read into STATUS_END_OF_FILE, the
status a regular file returns at its end, and an empty stream already
takes that path. Return 0 instead of -EINVAL so that non-empty streams
do the same. Clients that read a stream until end of file otherwise get
an error once they have read all of its data.

The buffered copychunk path converts a zero-byte source read to -EIO,
as it does for a regular file that shrinks during copying.

Fixes: 2ae1a6cc4302 ("cifsd: fix potential read overflow in ksmbd_vfs_stream_read()")
Cc: stable@vger.kernel.org
Signed-off-by: DaeMyung Kang <charsyam@gmail.com>
---
 fs/smb/server/vfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 74cd8007a..ae9f9a693 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -269,7 +269,7 @@ static int ksmbd_vfs_stream_read(struct ksmbd_file *fp, char *buf, loff_t *pos,
 		return (int)v_len;
 
 	if (v_len <= *pos) {
-		count = -EINVAL;
+		count = 0;
 		goto free_buf;
 	}
 
-- 
2.43.0

