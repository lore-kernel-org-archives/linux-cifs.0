Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC5F36DA1D
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783615914; cv=none; b=OFeN3vOpQFKpvoBpovt7rXocSLgBdmlA1C4oEafIP9VnyFV8yB+OpWZOVJIOYVUSfXbF2N6GtPleOYDonbhK8wmfcHD5ghkJLSXCH1TMdOeH42O9hQHUjEyNLpidZ/+25uCcNwEUmJly6aEEuOEcZmJbHUDB2MN+qfkBdpf9l60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783615914; c=relaxed/simple;
	bh=mJjJxu91dIZn/b1E+TVC9clrOnb50gyliGF3y1jRbzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Md74Je8IKZG9tXHriKsMrFpd4owYs0r3VceS44HDPalZQ50Uu0eG0Kbi/SVIcg/y4OQjkMJ+EVJrPni695uis/9D7js2niIJ4u8WmQZ1Qf6BVdUgbZL8gHMZtQz7AYzXtVbajy7ixVnwBsPs0lzU0Ciuvf0KhslhnXufyQqAX8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X50+JZxh; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X50+JZxh"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-476d8e647e9so140344f8f.0
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 09:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783615911; x=1784220711; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DQmL9JznNX04zfKuZUh5EI3TvSz9hlrqP9/LwtOvQSE=;
        b=X50+JZxhwQLmg/moOQ/poQCajtlD8ZSIV6ePvtGxuYkh+HUhIsopFfRgOGOibDoAKF
         QvowNFU2Bx2OM5NmPutlXReuDAbt700tFOP6ku88/ynPyxo1ejwp82dt72Q/OwNkopRV
         5tDch34GhK07iCHR3WsfzYSvEkoNBgUuAYv0K3oH2BT1dfkQld983yzkFjXDxsiPbRpk
         bHZCN5w41N8fsQZi2guX501z31vVOqCCIOldlvvf1UAK/y+HSvsc6sL5Xiv3oCTBjXur
         Uj6Es60U91dyFojckslgda91OCqJzPk+6wGZeweDDAJdPj4SeP8A1CbWie2FkSMCaVi0
         //nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783615911; x=1784220711;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DQmL9JznNX04zfKuZUh5EI3TvSz9hlrqP9/LwtOvQSE=;
        b=a5Cq1JWNqbAYAoSULARERr5j9LFVGZqSD5cay0sCHD/mg3DaezIvM/GYV1CeKFzHSm
         +bYAZfUT68gJwRmwCBl676whkRGGFxZ6rEekMZ84AZFnM6BLL9UZ9sRFIM7tq/5u3ysP
         9JeiTWxkAVda4FZhe1gTW3doEEzaREOVYDg0zxOQAs/JZvNr722hYl/YnH2xu9WhQt9Z
         58Rb4IaOqggSrqP9C1ZCzktIRV+M6LEfiXzNQclTHvwjnvsSocTJAVmnW9xBcGGjvrfu
         UKBiYI7ZJ9tOhx+IIEKxf9l2Vazj/ZYe0be6PKASI6c7QQb+Gu3LdBmaFKyzQOefRbdm
         4ftg==
X-Forwarded-Encrypted: i=1; AHgh+Ro3tGnOGcZsmGUo92PYBqD3DAcNIi0fMMmjotEg/Vx2lJEGLyGh9SWS9TLk9I6dgETPM/LRIvmd+SgS@vger.kernel.org
X-Gm-Message-State: AOJu0YwBqg5PIoqNFUHH2ckLwO0jBXVWcZretlAB50MAq7vV/7yALD0x
	p5hVNw/JHBQ8zLEkh0TAB0rWoIm/XqpC3LJW/R28UxM57mKHABsEHZfimZIsigaS
X-Gm-Gg: AfdE7cm33koeqGhCKoA5oj7YSW9DCJa13o/24fU932Je+EZaOD0U4NON73CzObEOWIQ
	vINVg3YjS11rn6CEMz++1ZHXk8LxVyFk2CtFM4TsHK9/CeXASXT0jy28Y3kdCN2Le5BXh0S7S40
	3WT5MM7ex5PGrHiAsB6T0tvcPyoivCBb/asjXg1EIyp3f8ok7G1HLWt7KeALYbGRB7mSUYollyw
	rZn4iYSX07XcLUtUJFOmx7GBGD/EyIWSaM7diLlyb7tsw+kVoYCEAKMYe+plwNamFGaIUwyeT79
	pYnl1gfdVU7f+z+LouEavXUr20MCIlkaYORMA59omrYxZFmrNjdNA+73WdZFgpunAw9wj+CTdfO
	hZcly726dCYfi/fG8QjjhNEqb5rIkDUJVz0+Tsj5b04dWDbsBSYhb+J7g65cm7B157pcM4lN3XM
	dSghIwE6bsz7h9J/QClf87+dLrVRBmPpfgSOw=
X-Received: by 2002:a5d:584c:0:b0:472:ec66:274a with SMTP id ffacd0b85a97d-47df074e24amr8925333f8f.7.1783615910469;
        Thu, 09 Jul 2026 09:51:50 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9e4d8410sm53974738f8f.15.2026.07.09.09.51.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 09 Jul 2026 09:51:50 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH v2] ksmbd: report actual xattr value length in stream enumeration
Date: Thu,  9 Jul 2026 18:50:46 +0200
Message-ID: <20260709165141.2111-3-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709165141.2111-1-g.blivet@me.com>
References: <20260709165141.2111-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

get_file_stream_info() (FileStreamInformation QUERY_INFO) reported
each enumerated stream's StreamSize/StreamAllocationSize as
stream_name_len -- the byte length of the stream's *name*, not its
data. This is the same bug class already fixed for EndOfFile/
AllocationSize on an open stream handle (ksmbd_stream_eof()), just
missed at this second site: a client enumerating streams sees a size
derived from the name string length instead of the stream's actual
content length, inconsistent with what querying the same stream by
handle reports.

Compute the real value length the same way ksmbd_stream_eof() does,
via ksmbd_vfs_casexattr_len() on the already-known xattr key.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
v1 -> v2: Declare slen/ssize at the top of the function instead of a
scoped block mid-function. Also pass the xattr name length including
the null terminator to ksmbd_vfs_casexattr_len(), matching
ksmbd_stream_eof()'s call -- without it, the lookup is a prefix match
instead of an exact one.

 fs/smb/server/smb2pdu.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 69b244664..e1272d64f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -5960,6 +5960,8 @@ static int get_file_stream_info(struct ksmbd_work *work,
 	struct kstat stat;
 	const struct path *path = &fp->filp->f_path;
 	ssize_t xattr_list_len;
+	ssize_t slen;
+	loff_t ssize;
 	int nbytes = 0, streamlen, stream_name_len, next, idx = 0;
 	int buf_free_len;
 	int ret;
@@ -6021,8 +6023,20 @@ static int get_file_stream_info(struct ksmbd_work *work,
 		streamlen *= 2;
 		kfree(stream_buf);
 		file_info->StreamNameLength = cpu_to_le32(streamlen);
-		file_info->StreamSize = cpu_to_le64(stream_name_len);
-		file_info->StreamAllocationSize = cpu_to_le64(stream_name_len);
+		/*
+		 * stream_name_len is the byte length of the xattr's *name*,
+		 * not its value -- same class of bug ksmbd_stream_eof()
+		 * (smb2pdu.c) already fixes for EndOfFile/AllocationSize on
+		 * a stream handle; this enumeration path needs the same
+		 * real xattr value length, not the name length reused as a
+		 * size.
+		 */
+		slen = ksmbd_vfs_casexattr_len(file_mnt_idmap(fp->filp),
+						path->dentry, stream_name,
+						strlen(stream_name) + 1);
+		ssize = slen < 0 ? 0 : (loff_t)slen;
+		file_info->StreamSize = cpu_to_le64(ssize);
+		file_info->StreamAllocationSize = cpu_to_le64(ssize);
 
 		nbytes += next;
 		buf_free_len -= next;

base-commit: 5e6eeafe46a4a19559808c5ef36ea36ea4f2a204
-- 
2.43.0

