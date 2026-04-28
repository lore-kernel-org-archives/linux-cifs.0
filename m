Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DBD175A86
	for <linux-cifs@vger.kernel.org>; Tue, 28 Apr 2026 02:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777344740; cv=none; b=NEHvfhJugPWZoUCdKIiRSjlpG1ZHe6dNrJAJyO5aecb6oI/wrFfaVWGlofCe5EW5lEv3/KD6RF4ItsaA2i3uFyikKdwytB44SBZ3bL5gvVgq3hE4jiYQTva30GycTXuTzaTeZ+FKJHw4KRNk4Dz6OB74Wns29vT/mutoTDPbaaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777344740; c=relaxed/simple;
	bh=TkoPdIVnEDDcQkPQIK1u6AA2DgP5kx9+S9MtA08CmZY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NFEeqgsCI1zoEYli3YenX/upoLHm8xUZHwGjbRXRrh5cxbUruGXKGDUTZrM6ZXA5AOCjIQ4Cp3Lp8GswEesHm4JpP5OKzpDZHAHJ+ac/gXreI7/UJU64Jfyd7r+vzBY2kcKuNlORp3aBMZqPgyZ3Bvfni03P26S3ptWAruv9D94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tIHGAWKO; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tIHGAWKO"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-12ddbe104ccso1090906c88.0
        for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 19:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777344738; x=1777949538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a8Nhk45wzO3zlFt88EGGS6yZ3Zatdszo/GvXIEznylg=;
        b=tIHGAWKO69bmUBlcVuZ9ibWlVt9fv12KA46fvx0WfMitONXTEBr5dK4ioRvTQwURoS
         bdwqgGD4lrT6Ct8VPgvFp8qOJd3OBVk9P51LV2iZpaufh4v5zsl5VdhAGc/pJLHEtj7J
         f1qkEwVLNtUo7+UaoZC0y5bTQp8mCRjpFkigR0JKCPBSGI2EbvRY/myGstH68oqm+Ub5
         nYD7SWv0RLpeM5kPc6Rivie8ayRSO+DDgTskQVYZRSYK0A7urXOT0UIiU9J8zfljrK91
         qDnAerWk0EckTjFRXPB0GfXLONzYL/3W2hJ0EHTu0v33meZg4rvpto1enmT6bXuTPU5Z
         6ihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777344738; x=1777949538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8Nhk45wzO3zlFt88EGGS6yZ3Zatdszo/GvXIEznylg=;
        b=UADFZX+paQINGdcq700cN/6hFXQZ04WVzvKW8KwLpGrd0jn43/5/VOrmlwjSXqDljr
         rS/jnQJepeDYgmTbvtdmUwWsD5PaWXCZ1h/4bWhzk92EoQQGFSJFqYGrc1lcJYixzRe/
         NFgEva+9paTu2fZYgBsxvKohnSD1N/XHB//HFNHmVFh8/9WnhxIEfV6FUezuskNQEuz2
         UXEgENFc4BfKfqBOuZt5g0lder+zVT+H+37AIoJGjwQAe8kZ2nSoL9WmcwBMqRm325xk
         pq7bPMQClktd0lPkKj4S4hY1R1Qq1fWBc5bqBSgrSXWk/Y7XIXc+DJMUFc3BdqsK74QL
         Rumg==
X-Gm-Message-State: AOJu0YzRwjswBdEqA0M4frKToEoTeLwXmj7Lo4zNB+YiMgYp/wIcHowM
	si30fw9doCo1rkAPHDClQvA1tiq6gqQxXlnnYHCpIixloNbRiebZ3O7p
X-Gm-Gg: AeBDies48CwFqZkg/W0oFVhrzRU+6PB+ODxhAXS8zgErNS+Tpx7oWnpwQXTXFTzSkHO
	D2q0iibAH23MBkW38lxFv0xxz7fz6CoI1dPLxbyckK+Yoyf9wL2Jp0+9t0hXo53oELthv2qc6oT
	LFlYUZjeyookqj7Fp/hqYEdb2c1N3fQZrh5ct0VatgiD7J4y53O0cQeOwoHNDCtEUxfOe/ufwik
	5UFgcz7FWZJRz+WC2/c81JLTVNWz4vuK7Me4yt9/9L8OJAAC17Uv7gYDEEzkNYchahnfXSCXIoX
	XUz14ED4xidEenIx8D42gMbRGhHUCj5XlolapwBudUTrBljiT0HIgwztvVFNdLvJI71XMZoYksC
	9JmY/wQt5MgL7aQYgooaYoWfTTPIqD8vH1mD6AedRJS5poy9864G5/RfbVBi/rATUIKMDfdPyV6
	TTpXnFsO4Z6GJLOQ3aaxohlWqm+A2tnoFNrAZxss2R+RR6m1A9/hVKKHWhrbHUqnXKez6v/4xD3
	NzF46VFjEWAR1HBw5eHzg==
X-Received: by 2002:a05:7022:eacd:b0:12c:2cf8:2f30 with SMTP id a92af1059eb24-12ddd9614a5mr665176c88.15.1777344738072;
        Mon, 27 Apr 2026 19:52:18 -0700 (PDT)
Received: from FredPC.wirelessinternet (mobile-166-176-187-202.mycingular.net. [166.176.187.202])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ddd9a63a7sm1210664c88.11.2026.04.27.19.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 19:52:17 -0700 (PDT)
From: Fredric Cover <fredric.cover.lkernel@gmail.com>
X-Google-Original-From: Fredric Cover <FredTheDude@proton.me>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fredric Cover <fredric.cover.lkernel@gmail.com>
Subject: [PATCH RFC] smb: client: fix NULL pointer dereference in smb2_compound_op
Date: Mon, 27 Apr 2026 19:51:10 -0700
Message-ID: <20260428025110.38825-1-FredTheDude@proton.me>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Fredric Cover <fredric.cover.lkernel@gmail.com>

When a valid cfile is passed to smb2_compound_op, the code uses a
goto to jump to the 'after_open' label. This bypasses the
initialization of rqst[0] by SMB2_open_init().

However, the 'finished' cleanup block unconditionally attempts to
call SMB2_open_free() on rqst[0]. If SMB2_open_init() was skipped,
rqst[0].rq_iov is NULL, leading to a NULL pointer dereference.

Check for a valid rq_iov before attempting to free the request
to prevent the crash in handle-reuse scenarios.

Signed-off-by: Fredric Cover <fredric.cover.lkernel@gmail.com>
---
I am new to writing code for the Linux kernel.
Please be patient with me and feel free to point out any
obvious mistakes I made. 
I tested this patch in a user-space skeleton clone using ASan.
I only have access to a shallow clone and cannot find the 
original commit for the 'Fixes:' line.
---
 fs/smb/client/smb2inode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index c6dd282fc..aed96eeba 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -552,7 +552,13 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 
 finished:
 	num_rqst = 0;
-	SMB2_open_free(&rqst[num_rqst++]);
+	/*
+	 * If cfile was passed, the open was skipped; check rq_iov
+	 * to ensure we don't try to dereference a NULL pointer.
+	 */
+	if (rqst[num_rqst].rq_iov)
+		SMB2_open_free(&rqst[num_rqst]);
+	num_rqst++;
 	if (rc == -EREMCHG) {
 		pr_warn_once("server share %s deleted\n", tcon->tree_name);
 		tcon->need_reconnect = true;
-- 
2.43.0

