Received: from mail-wr1-f67.google.com (mail-wr1-f67.google.com [209.85.221.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A272737E1
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 19:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758655023; cv=none; b=rX4CSDk+3AAbp0usSWw7Dj11AFDPBZk0vG3BLl0ozxYXeu98bFzAbpFtHTQaBDvLHBHdanq096QLjXf/TzmyrnrQEThRuNZC4qo/9Rn/4mXxzuM2zaimOw/WOIq/oP8ZotHmpgwZRyAFOhUctR3/cngaGO5u0k2saz4TuZVB31c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758655023; c=relaxed/simple;
	bh=99gctKDVlbFhhWEO6aJ5nfxEW0Ef1pT/tFT6zelkn1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=DOxk/e0ev9AVvBJ4o2jXEMAEHq5jqRaBWcrMAFrMQpn4sJYFtGY2y5B+5YSKJkZriNL+qvKVwTUcAboRPad8spXufQb2awQEkPZGgEZbyE5AOAWKckr8+3HVnft/J31JuyHa2IBM0Ueubpia2t8z1KtVaTj0coL0unEE7UZd5xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bn3QlRc7; arc=none smtp.client-ip=209.85.221.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bn3QlRc7"
Received: by mail-wr1-f67.google.com with SMTP id ffacd0b85a97d-3f99ac9acc4so2550678f8f.3
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 12:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1758655019; x=1759259819; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=I+W0Xl6b5sVsDJG7yqO1p9FQ/QRVrrbLHX71ZTiQZ88=;
        b=bn3QlRc7sQ3Ab2f0C1YSGo/L0u2nVZ0vszVL6gXMbJ/93xpG36Tex9O+7j7mqS1/W9
         ITk7ZATqtZLsSzj/OQAJb/++EZ+8YgqpTFs/UjiQBpQ0cRe6ZiBRvZ65nRUPB3U/wnOD
         xLgi21B+euglB0SkTNl6WVzZV9KgMyzYjAOTqSzBUlXFz3Wuph8MlQmAAzdcbtMEc7NU
         9A85lfx8EWYs9yHMqW/lZY/s7KNGOlmh0cFBaAZhjBnfELyAhbLM2sEcwBvcJE4u+rm7
         LLlqkrkhKWlptahTVCbABmGQyDg2aCymE4SWWn42gQ1KeAOXjU9C0XzlBLbNF/J4Xdnl
         XeRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758655019; x=1759259819;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I+W0Xl6b5sVsDJG7yqO1p9FQ/QRVrrbLHX71ZTiQZ88=;
        b=ZizWNzX08+BZModH07m7jejhmMtsShiWgwyP5pTvm/HCFxsLF3uXavRT4w65QgAB7/
         rzoVA0yDuVsYGXaKJJml6W7wsZLPr0Pn/gQyJVzmbeSYHKbjdWjips4NDT7oe97uVs5w
         nnZ6gxGrnh33+07hO48CeINwBq3z6kK0hkHXL/Tvkqa2coCD6eo52eLlD90xuxQPWTWr
         qv8NOkr9sETWmvxbNrYxNkzshksiqYl7CnjJjEqkRGW1asZ9bFVFyXx9M8X+bfPI8QCc
         cL8lGTLd6Zx3woGZiA2bgHt/5WbEGKAu2otcAYqCrVvGwxy3maS/QeHtugzbct7Jrawg
         Jk9g==
X-Forwarded-Encrypted: i=1; AJvYcCUVWa1L0bksMEnPMp95GdHpVn19j1cj6boiWVY/pCy0a6Yjr8IF4jGPIytl/s8e2DoEeWpnet4pBYw5@vger.kernel.org
X-Gm-Message-State: AOJu0Yzvd01Ji0PegLZ8PJ7oPkFyJw0zaqzS9SYi+KoCVvbx7zzLkmlP
	AePhgtgn9GKEzTHe4Joh8WpNPyZ9EDduJLBLFcFjn94PeDE8IW2ZS+lUYNUvq81sP3w=
X-Gm-Gg: ASbGncsahwt+29nBoHmrFZ90hMLM7XLex7Yto2Vj+NWpUQrsT8PE9Kay3LzpoBdsJ5Z
	+dZe7neZS2i0yOp2fyX0/XcI8ANZay2s0tVpjQKCjj983GDi031sux+zz1HFQmo0uuIxFlbGf2h
	2Rm4VlazgfmJ9YIaHmBr2oM6Aou1tbDyPtA3uCn3Q6RlinqR+ML6QAF1ufazGoiwDFdSlxGqu2I
	7VqXxPDM3KDO3wiZ+0FLIbNA2yv05O5MYIOOLiPfVjSCzamJdThBlsRSTMlBgITcXUiujSnzW9C
	WtVB8/UfEkXGbXVt1DPj9xiPlzcO3xtuywRKjH9MZq0Fm5JHexdJWt/VAfJ9BXbk4ZUypxBCMFp
	YX8OMCsHniaB+HJnEZ5/6UWpS8zI=
X-Google-Smtp-Source: AGHT+IFXI82A09jQWmvBkeKlFtZp8O1OHifzVz0uVhZcR/Gby7l3/xUIrdWraEAEUzL38VIjSKEisQ==
X-Received: by 2002:a05:6000:3106:b0:3ee:137a:7adc with SMTP id ffacd0b85a97d-405cb5d1eaamr3286886f8f.44.1758655018713;
        Tue, 23 Sep 2025 12:16:58 -0700 (PDT)
Received: from precision ([2804:18:100:3a9c:1980:6fc4:f65:e8d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269a75d63eesm151117015ad.100.2025.09.23.12.16.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 12:16:58 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Henrique Carvalho <henrique.carvalho@suse.com>
Subject: [PATCH] smb: client: add tcon information to smb2_reconnect() debug messages
Date: Tue, 23 Sep 2025 16:14:17 -0300
Message-ID: <20250923191417.237112-1-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_reconnect() debug messages lack tcon context, making it hard to
identify which tcon is reconnecting in multi-share environments.

Change cifs_dbg() to cifs_tcon_dbg() to include tcon information.

Closes: https://bugzilla.suse.com/show_bug.cgi?id=1234066
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c3b9d3f6210f..9e3b2cb7b5cd 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -240,8 +240,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		 */
 		if (smb2_command != SMB2_TREE_DISCONNECT) {
 			spin_unlock(&tcon->tc_lock);
-			cifs_dbg(FYI, "can not send cmd %d while umounting\n",
-				 smb2_command);
+			cifs_tcon_dbg(FYI, "can not send cmd %d while umounting\n",
+				      smb2_command);
 			return -ENODEV;
 		}
 	}
@@ -296,9 +296,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 		return 0;
 	}
 	spin_unlock(&ses->chan_lock);
-	cifs_dbg(FYI, "sess reconnect mask: 0x%lx, tcon reconnect: %d",
-		 tcon->ses->chans_need_reconnect,
-		 tcon->need_reconnect);
+	cifs_tcon_dbg(FYI, "sess reconnect mask: 0x%lx, tcon reconnect: %d\n",
+		      tcon->ses->chans_need_reconnect,
+		      tcon->need_reconnect);
 
 	mutex_lock(&ses->session_mutex);
 	/*
@@ -392,11 +392,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 
 	rc = cifs_tree_connect(0, tcon);
 
-	cifs_dbg(FYI, "reconnect tcon rc = %d\n", rc);
+	cifs_tcon_dbg(FYI, "reconnect tcon rc = %d\n", rc);
 	if (rc) {
 		/* If sess reconnected but tcon didn't, something strange ... */
 		mutex_unlock(&ses->session_mutex);
-		cifs_dbg(VFS, "reconnect tcon failed rc = %d\n", rc);
+		cifs_tcon_dbg(VFS, "reconnect tcon failed rc = %d\n", rc);
 		goto out;
 	}
 
@@ -442,8 +442,8 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 						       from_reconnect);
 			goto skip_add_channels;
 		} else if (rc)
-			cifs_dbg(FYI, "%s: failed to query server interfaces: %d\n",
-				 __func__, rc);
+			cifs_tcon_dbg(FYI, "%s: failed to query server interfaces: %d\n",
+				      __func__, rc);
 
 		if (ses->chan_max > ses->chan_count &&
 		    ses->iface_count &&
-- 
2.50.1

