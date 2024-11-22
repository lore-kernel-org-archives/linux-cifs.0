Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A8B17B428
	for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 20:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732308031; cv=none; b=u1Bu3+ajntVP7MaXAgzvyFSbdcSOILFtTgWdX/AvfEtmftm5+2hXPt2KhITNl9nUu+sVprYa2Dm+PV4lfTXYwUhgGKeDwEp/qIjDhrI9zVJ9YbR1sJXGSNxjCZf6d3aOBEDG28KSIHMKeLcrc8Ix8DfBy98yuVVzOY1ur/f/r2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732308031; c=relaxed/simple;
	bh=/ezPXWpWVrulaooLZhCDml/9r9QLWHg93WkEDVEJgkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IPZ1kjgDfj9Vx/L3hwO8w2+rA/wk23vYZSMHBVhc1yOXrlMjrl5OC5qIhOF44HX5+2KdFczvR1frRIdM+xt1NqtssP+ejVaL+8YZZN3auWwS6rTyhoBYRObmi+si1vM+R8cu0yc5QlOcGuvg65J/paFjXPR+J0KH4C3BGhWZ9SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=XVm0VmXI; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="XVm0VmXI"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-382325b0508so1684236f8f.3
        for <linux-cifs@vger.kernel.org>; Fri, 22 Nov 2024 12:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732308028; x=1732912828; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V2vnbMl/BWCcUYVePyPyKrpM5ozYiHydygp4Ra23Nvs=;
        b=XVm0VmXIbRWJrZ5plKF66Ps+x0jA1PIINg+tFX7awyVvNlrvM/JoVLP2de63Bc9395
         j0nk8hHsnRTZj3NWp4xHzNlGaMBr85KYKcDoGJFEL4Jiyc72jP2l5yITyqhhYBpKyOwZ
         X/2ERQc5IE+eU9LQN++vbIXfRIQDNjICHkudhNZy7skGgbSsKUrXcT5U+2fAmAiA2KI/
         GDNHeOU+T2VBnnVWqOOmy5lja8bgnecAfDxmmJqcMts07iWmNKXLABgHji2Df58bwz0O
         yU2TyicETikj2i8CD62uYnkqhTfs7uJQzUmwQzGjdQpPi6QwWv3rnQcvXjXCrYnprCxR
         YzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732308028; x=1732912828;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V2vnbMl/BWCcUYVePyPyKrpM5ozYiHydygp4Ra23Nvs=;
        b=Ryg2JFL4S8txCJbO6N+oNjL9Tw4ZrOniyf8AItOhGEZq1XTFaf6K0JGaJQi0AlqDuw
         i3RNibrqLzOLLuvnqD4lED29T5gX0xex0WIWR9rzrUzuqGeCSGP7ZGYuMbow9NN046CN
         ZylPOT4TriJhiUCxfFHSPlI/SzsGQ+yBzQilaZD+athwwQ7Bh+P0yiS1KvBuIUzab2WK
         7O/4G4UaLWiCHDdqsH7h9NPUd4gAomQBDqN/3AV8Kb1aNmTXJzbTQ/bB+eXufBhKSfql
         o4GS/ydTYwhlUZ6p5EuBdv4aK6dUrH4Vi5sL41EIYvm7tHZ6OFOQisY2XCeqOVMx1nrT
         U9ZA==
X-Forwarded-Encrypted: i=1; AJvYcCX2jc8INExFpdubl+8A7qpnKrSgpXa9Ahlhuxma9GwG94ht2yW130DzIIGVVNoLE1J9S/lvaTi3v61E@vger.kernel.org
X-Gm-Message-State: AOJu0YwV3e9S/JbtvTKZrsreQ7KPL1qkgupP4rbPS/VzUFDJAZ8g97lt
	2OF/ddA+ebyuSH0SX+Fk0at5LIQKCY/M4Oysu8w6R8A3zuP6E8ymEzULBLtW1kw=
X-Gm-Gg: ASbGncuOIMSVcq/zkHTFGM68faZ0/BtNjNjyJ6PiZ6pyBfrDhA1Z8rYXfDnSJ7qufM2
	28GLuDZDlT1eD6eH3zKVpll1f7OizUDJBq+Bxd2BkKAXQvDQNYLI0p+EiE+BVqCXjZdBCwC3KP8
	8UDULIPiE1nYsFjKCyXUxD362JtWICt97K6p4uzF8N5flY0kDhtx4yZvskgQ6+BOT/+Zu1n/EcP
	SXPx8WPeKnvXXi3/AmysEFZNJoYi0T0w3+nKfYqufIAblFjx7KytpN4arlmbWfxrUY7cw==
X-Google-Smtp-Source: AGHT+IGbGKhmXaj3W2bbHVCDovJ1ZZnY37b6q4Hug2hEj11SGKrb28nU+aSiB0Q6hKdZKg1fkUTAFw==
X-Received: by 2002:a05:6000:2d0b:b0:382:4126:f182 with SMTP id ffacd0b85a97d-38260b6d7e9mr2882350f8f.25.1732308027984;
        Fri, 22 Nov 2024 12:40:27 -0800 (PST)
Received: from localhost.localdomain ([2800:810:5e9:f3c:e019:b39:5a90:cfe])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724de57a3d1sm2053423b3a.194.2024.11.22.12.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 12:40:27 -0800 (PST)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: ematsumiya@suse.de,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	linux-cifs@vger.kernel.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH 2/2] smb: client: remove unnecessary NULL check in open_cached_dir_by_dentry()
Date: Fri, 22 Nov 2024 17:39:01 -0300
Message-ID: <20241122203901.283703-2-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20241122203901.283703-1-henrique.carvalho@suse.com>
References: <20241122203901.283703-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function open_cached_dir_by_dentry() is only called by
cifs_dentry_needs_reval(), and it always passes dentry->d_parent as the
argument to dentry.

Since dentry->d_parent cannot be NULL, the check for dentry == NULL
is unnecessary and can be removed.

Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index d8b1cf1043c35..9ac503dee0793 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -400,7 +400,7 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tcon,
 
 	spin_lock(&cfids->cfid_list_lock);
 	list_for_each_entry(cfid, &cfids->entries, entry) {
-		if (dentry && cfid->dentry == dentry) {
+		if (cfid->dentry == dentry) {
 			cifs_dbg(FYI, "found a cached file handle by dentry\n");
 			kref_get(&cfid->refcount);
 			*ret_cfid = cfid;
-- 
2.46.0

