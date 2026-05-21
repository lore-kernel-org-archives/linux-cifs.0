Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5152E311C27
	for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 14:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372419; cv=none; b=RTn4owk74v4Lh7r8zQLId+udEoCUPsAey6yMhe/nIz07cNW7ZRrHrZJBtt3nH8i560nfCGNkoLeUG2Oxkd4pIMp4vgZ+HhVhJ/3U4qpLYMXynOSkP+10ek4oK56nGvAQNbWsx2Rkvg8rCg758z+XgFlZHU5TaoVXP8Y+nH8T7X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372419; c=relaxed/simple;
	bh=MF3jr+TWwaU4aFfScYUQqUoq7VamaH9MJ97TeazV8yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=th2gVWcVjstACnndftbrvM+P2feFUJszZKEmDv9m5T1AyqPsEh/mYsKwk+MqUBS9GUUU4PdEHgqchDuX01wR8k8K9qzyfJP6QVAqkSQRgOAKbNUNc1RYV7Wz/j7EtEnBvUbwDlCAgNyabEiznnR7I5VZmc4TJspuC7LdzA9mMMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dX6511lY; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dX6511lY"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-82f8b60e485so2590282b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 21 May 2026 07:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779372418; x=1779977218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oo+sNkiQm6M5U0eLy+pOSJt6ZqbnkZ2OxN5h3YWrjCA=;
        b=dX6511lYOlAhkT980GQrvHfw/99Xzu/jYXbtsFEDuv1m6hvUjiECnJKI+o+yBFKCQ6
         dzeY/zguhIuBv57urFSYX5ffTbOLXYr/fiq7asamI3QZI6dZkNW2Z68gqwKejLXJk3bT
         L9+an8yfnodGcJLShAHGMfcAPUOghTRfFNfH1uLBmyCEctcPmVymuG9UIh062NpjQvFo
         svwztDD8UUd9X1DnEwLHUZUMJ86tr/SgxSfLnVNBEdnSdsKvJpbDmpKqv2DHjXRvs8Yt
         fKFuEdcRDcL0HNaoqMZS4JcYpDOPxo+ZKar8jfkXSYdXCoCyQmagYINJhTu2Amxs6wNG
         4KWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779372418; x=1779977218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oo+sNkiQm6M5U0eLy+pOSJt6ZqbnkZ2OxN5h3YWrjCA=;
        b=QlZagmn2XNh+4HZWrSOh1KQb44kPP6217wP96asyx0T3b+y0IiRDQMCrWDOHPhcCLZ
         Wzk+9eSISU4NY9sGqhVCg3zrY8d7CrOaAc8n6trAlrwVu+zNEngqZK0absPxAEWceONc
         Pfk1BNp/3I0gXZvvcFtVuL+IOK9g2cAyMBhGSFDsORAjRKylCGDYgOPKiM8jBLK01i5A
         ELtK0IMSiuXdg4jGBzUkD2oKXH//uOo0+IjDEbOI3AQV6OiXgkl2QFUtM4HzbcPYRQqt
         zg8safoUf/Kq6vEPbtA8oe1yqXgXtRl1gs0n+eqYiVg2l2ZM5eG1tX7dcUOYcOqHjD7u
         9GXA==
X-Gm-Message-State: AOJu0YyS6KvLoOrsEcyWI9iPfB7AEdOD34n8CQFmUcAU2NRxy1YQ8Hj1
	G3QVQUzxwZLZnLD2YVI5W+a9tBTBV2WsydmntRypTa7acurYhAe+tpoR
X-Gm-Gg: Acq92OFDYlyQO6dV8jq1lm6oNjAc+Swdqz+3qtNQOYkW9UNBwGxQcOM2da+fvObyPdn
	Ds6PeupFyCoVAzGTZVdwvZQj8qqjutsfhyQRSUo/l7Rhl+tsy8FFmPIJ3/NiFGc3qKknrRZmEAJ
	hfP5bIqWUsPQHM2XBI1JA2ooj28jZR6D6NFjpnhCiJME29TBpqdK1wC6HPpddOC+rlT0/hxEBTy
	PLjKFj4B7YBLeGwItPQgrci1b0hGtMi3J5AJX18ilMFuFwm4nCnH+URy41T/3sZlAvc/x+qWMtA
	4qDE5Bk23Vhf5tqw8c6HFUY89MNEbw9yMeQ2qvvCkrorDRcaHY0Mu4cU5FFs4UcnCA9i/VGt5HY
	cZrjnNCs7DpGHYKFAzTfa1h4e2HF5qEaA/K76wsMPkpz2JJ9+ZhAfPCwamqODWi9/xDJRBfzFHW
	AeUiL3sWovFkiQVW9phtjMDaAxAsCqNywN/EyRCQJCYIyQQ2PMJtAWET54zNeTBG2p/kUrXr/9v
	5ku5S/pZJgtrAeXV2K7dlw=
X-Received: by 2002:a05:6a00:908c:b0:829:8a84:b9fc with SMTP id d2e1a72fcca58-8414ac6afb5mr3761635b3a.8.1779372417733;
        Thu, 21 May 2026 07:06:57 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841549c46c9sm1719329b3a.10.2026.05.21.07.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 07:06:57 -0700 (PDT)
From: rajasimandalos@gmail.com
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Rajasi Mandal <rajasimandal@microsoft.com>
Subject: [PATCH v3 8/9] smb: client: block cache=ro and cache=singleclient on remount
Date: Thu, 21 May 2026 14:06:43 +0000
Message-ID: <60af8bbbdb78caa38a46df07300d34e16112f396.1779372325.git.rajasimandal@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779371115.git.rajasimandal@microsoft.com>
References: <cover.1779371115.git.rajasimandal@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

cache=ro and cache=singleclient are mount-time environment declarations
where the admin promises that the share is read-only or exclusively
accessed.  The client bypasses server-based coherency (oplocks/leases)
and caches aggressively based on this promise.

These modes were intentionally excluded from smb3_update_mnt_flags()
when it was introduced in commit 2d39f50c2b15 ("cifs: move update of
flags into a separate function") — only cache=strict, cache=none and
cache=loose were made reconfigurable.  However, remount currently
silently accepts cache=ro and cache=singleclient without actually
applying them, which is confusing.

Add explicit checks in smb3_verify_reconfigure_ctx() to reject
attempts to change these options during remount with a clear error
message.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 7164dda715ca..0ef8ccd53882 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1207,6 +1207,15 @@ static int smb3_verify_reconfigure_ctx(struct fs_context *fc,
 		cifs_errorf(fc, "can not change rdma during remount\n");
 		return -EINVAL;
 	}
+	/* init default: cache_ro = false, cache_rw = false (i.e. cache=strict) */
+	if (new_ctx->cache_ro != old_ctx->cache_ro) {
+		cifs_errorf(fc, "can not change cache=ro during remount\n");
+		return -EINVAL;
+	}
+	if (new_ctx->cache_rw != old_ctx->cache_rw) {
+		cifs_errorf(fc, "can not change cache=singleclient during remount\n");
+		return -EINVAL;
+	}
 
 	return 0;
 }
-- 
2.43.0

