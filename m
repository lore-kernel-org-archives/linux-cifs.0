Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A08A4964F
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 00:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555570; cv=none; b=C8GLn+rtC+CzvlTTf/7xKgCZFAnzGmtk/VwRIUfvKgXvAMAN6gghNQf5zhsQlGMLYuBjrjoPvgJO9P5e+mbRfav1qedHRrI49uGDQIrVo501wLSQA0l+QrGwVuCJTECklV3ml0409wpbCtCCtui77Padvlz0zetDCKi88xtT6RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555570; c=relaxed/simple;
	bh=Ao/e8cXDYdVLUKHqv/GqVaage3EikfUpPTJNmWVOsCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQ8po/J5zmh1IVl/kI33CyW5Y/wQ9x6/fcULLKL9SW1hMsCUp52dDJcW66OKnVMX67aKot1wooDdSyLjEWBHFo3fs+akmndnb2+DYR3wCGtnHhTrlwTOgbW9NT4D9GHWFHTCj6VZPVr6eS86iRcNEcG3DD/+t5UYrREurLJ3Gwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WwX0KwOz; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WwX0KwOz"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-493ae59eca6so6933765e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2026 17:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783555567; x=1784160367; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MmqgJ0T+t1s7gFHiAY7ua2HSRiNgzEyh3x62fvKAtjA=;
        b=WwX0KwOz58wjHkstwCYmiIiI7feRxQnb8zOpSsayKXr5H48zkUdJCm8gaSABbiXVwK
         ILTFSaLusaQ2aZoALLFnYdcEWU/EESorExbJnDDWSt+xlFy4SrVOEYXyfZdhamTqx6LN
         PnKv+KSlqIMJ5Ahwv9qA30o29jxAUfn/4BAMryh4Qcgnz1pWRQvTLcqizDxWdZVieZbh
         24F6gENOhLtefz6v5KpYH81axGNIGABdIgdjVlQCT6RGetqSJOXiWHgkqOmZX/u9Rh5+
         Uprg3RrN7Q44x7avJqDwVmp7Q2/TKoh9e7PU/IOkekjcSACnSxQLihNvk0clnwTWZYJZ
         aIMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555567; x=1784160367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MmqgJ0T+t1s7gFHiAY7ua2HSRiNgzEyh3x62fvKAtjA=;
        b=V4e6W70YMXiO5o2Rf4lxzlz0DgXj3xMuKb6Nspe78o1hTfPQjVO3q0J+WpX/PTems5
         AK7n61GzTRdELhvMnfOwqKpDbu3jt1Ar92PZbH4ijJn8LPCxm3Xstyt2Kh3Ep6cPXh9H
         669rnn+wu1Lm9YvXkXQ753cqnOSJONbyw8MLXxMTIRDWqKRZ2GM4rl2gKGeUJ4aiM4kS
         IlGkqzKNTHG4RkcS8Cakc/YnD6gqJE9LhrJQPO6DS97SewwTxKzWRJI02+zhNX2ufCJW
         boTJKdXZwubjtD2LHyBGLYOBpF5dKSYUNLG55mb4SqO/GWvJak9s/5o/rmZoWPGQ1vGB
         xq+g==
X-Forwarded-Encrypted: i=1; AHgh+RqkG6ojDuLe7dQudScwmAFoXx+SumQpJrICjUWBmTWyxlEjJjV2K7wmvVOa6Tcjb71NLOjM6iWejkTh@vger.kernel.org
X-Gm-Message-State: AOJu0YyjOs3GTtx4/6tysMlggwgS2dmkwvY02UyRuOEWljj4mdn3GT7T
	nG8fHbAfnvIG6xp4WM2aNCJyn8Hji8zMFS6K4Dtujj2z4jpqzsatNliL
X-Gm-Gg: AfdE7cm5zk29UDGc0aduxWyUTLOuTk4WUHo0f8VAFluSOcNaxirb8IAou5FImD7fk+Q
	xW8UQ5Fl6QndF4ktBHyay1uLcv4Yx7956ici73ATBOGDeLlY/fIQku1Ntlg17wo9qmfJKz8AFrI
	jDT6gTcV4X4Q+U7mnxK/xYPs7hx6kh7tsOhIPq5/jBLTeds5XbisLMtK4MjR29ArQ+H9ypXO/rj
	astHu6V0tSGzyivY/aHPSj+X8+XxWOnNSFWnY3PtToUIA62tEmXC5HroV7Ot7WSUeWSLuTK+a6f
	GI4FZEXQp2CCGpf3zKScg6RuweDp2UqoWmvTYNayUZ0Vd5o6/ifnFoki486MtErjJPGSiddwcpH
	Y0RO7g6nenUMj2Aqh6t4yYtIHZ1rdhuJ6CjqPI2JaQnIwoNkUyzGxnrMw58caSTGyL9IRvttCSs
	0BCh5TNb/uoQt0GNStHhVxcTwl3EOoNExRXPo=
X-Received: by 2002:a05:600c:8b17:b0:493:e6f7:ad75 with SMTP id 5b1f17b1804b1-493e6f7afb1mr41798595e9.11.1783555567327;
        Wed, 08 Jul 2026 17:06:07 -0700 (PDT)
Received: from macbook-air-de-gael.home ([2a01:e0a:821:3a80::37ba:9a3e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493eb742d0esm15843755e9.13.2026.07.08.17.06.06
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 08 Jul 2026 17:06:06 -0700 (PDT)
From: "=?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?=" <gael.blivet@gmail.com>
X-Google-Original-From: =?UTF-8?q?Ga=C3=ABl=20Blivet-Bailly?= <g.blivet@me.com>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Gael Blivet <gael.blivet@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 8/8] ksmbd: skip fallocate for SMB2_CREATE_ALLOCATION_SIZE on a stream handle
Date: Thu,  9 Jul 2026 02:01:11 +0200
Message-ID: <20260709000548.66445-9-g.blivet@me.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260709000548.66445-1-g.blivet@me.com>
References: <20260709000548.66445-1-g.blivet@me.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gael Blivet <gael.blivet@gmail.com>

smb2_open() calls vfs_fallocate(fp->filp, ...) unconditionally when a
client's CREATE request includes an AllocationSize create context.
For a stream handle, fp->filp refers to the base file's data fork
(streams are xattr-backed on the same underlying file, not separate
files), so this pre-allocates storage on the base file's actual data
instead of doing anything meaningful for the stream -- fallocate has
no applicability to an xattr-backed stream at all.

Skip the fallocate call for stream handles.

Signed-off-by: Gael Blivet <gael.blivet@gmail.com>
---
 fs/smb/server/smb2pdu.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 818353ad8..f68cecad9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4113,13 +4113,22 @@ int smb2_open(struct ksmbd_work *work)
 			ksmbd_debug(SMB,
 				    "request smb2 create allocate size : %llu\n",
 				    alloc_size);
-			smb_break_all_levII_oplock(work, fp, 1);
-			err = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
-					    alloc_size);
-			if (err < 0)
-				ksmbd_debug(SMB,
-					    "vfs_fallocate is failed : %d\n",
-					    err);
+			/*
+			 * fp->filp is the base file's data fork for a stream
+			 * handle (streams are xattr-backed on the same
+			 * underlying file) -- fallocate has no meaning for a
+			 * stream and would otherwise pre-allocate storage on
+			 * the base file's data instead.
+			 */
+			if (!ksmbd_stream_fd(fp)) {
+				smb_break_all_levII_oplock(work, fp, 1);
+				err = vfs_fallocate(fp->filp, FALLOC_FL_KEEP_SIZE, 0,
+						    alloc_size);
+				if (err < 0)
+					ksmbd_debug(SMB,
+						    "vfs_fallocate is failed : %d\n",
+						    err);
+			}
 		}
 
 		context = smb2_find_context_vals(req, SMB2_CREATE_QUERY_ON_DISK_ID, 4);
-- 
2.43.0

