Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBBB8205E37;
	Fri, 10 Jan 2025 12:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736511080; cv=none; b=nPafR9zWYYl/DjXRLs4YniJPdK9dBbQHZ9vgzfJpAl+IZUZtLpiNTbh+iiJvwv6quyF3M+BuWCNYvLb2BW0TI9UrBaFTTfKLO0NW5uS5LSh8mTqxPBsDCNB1qtuTVYZdxE2BFUHUTP7+j+ssOUWMQ+VeUFkq9wtHPrlpHt46S+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736511080; c=relaxed/simple;
	bh=bdkFK7F9vkXyxoi7bImEUp2h5JYce4617itxk+T2X1M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o5GGZHYfoc9GU1F8pXINHFBX4OvVKvSNzYe2lApLD1EfH6BKKkmqePpi/D94wKcYLxsdGj1DBJ3r4tmZdugcNepsKzRbwD3d5Q78iiaKROcfeffGZA9QrRF/GAo08Y4C4/SYvmia5zUNARZEUF6PZIZxAxDZ+AM0blO9Jc7Tl9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fSXdy2xl; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fSXdy2xl"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-218c8aca5f1so40218515ad.0;
        Fri, 10 Jan 2025 04:11:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736511078; x=1737115878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=x6Cbipn8EQ4wClu/FjXpBhsb9hZaB/Wr+Nmh8y5vefE=;
        b=fSXdy2xl7aUTzEzZVa4Ng5IWOFQt5tWsPAYImmQwlJYoOx7Bkhac30QtD1XCr/NP2y
         0p4ROUE9G8plj/G6Ni9Smbf8U4FPt/cTOXaunkTcvqwlbzi07KIlBFFep5pba26APdPR
         ftrO3Z8MOHCt8fGO+F8F4Ld/YVKN9tDZfKMgK4fLhoZDPNgYyS9FEnNWnp8LO732U66h
         OOoWicvRm4lMZAVNNVLudl8DdHqvy/0SUjAqcCw18wvYtW0obeNKrnBuQMFTT6M/+oj1
         LeHUCo1p48HAs8759YVVghQVruJrbHR5xxJu5VUYLCFzGZX6n++rhlV3BR1zgVr5YgtS
         HPnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736511078; x=1737115878;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x6Cbipn8EQ4wClu/FjXpBhsb9hZaB/Wr+Nmh8y5vefE=;
        b=O+FgzohvASD1sfDpEUU2AK6Y8ac7Y0DEW/8TOK17IA+9fVqcLQgVsBBfsEwq/2roR+
         wwNZ0tosGtrntAbsXBkEJ1fghwwMjoG+Y58qzUGO7Kmy++o1QAbdtu45kK3Oq1AxbyV8
         cqnHeOMk7IsWcSvlCQ4a8i4UJtmvtXwI8yg1ribrDE6ElxwRmHBrdB4U6WZXYGcHZCqe
         BmPASxHc7VHWzcBi7+y9SNZ8dPY4mwA/9KCR52gBkre7fVVp6+7sfNy5jf2SRSlw8UYn
         QB387+MicFpaZ/SknJh9CshyoUTjCbI6V8ZDg/i+67mU5e5hhkOxW470UpDaMBiFc+Tr
         nLDw==
X-Forwarded-Encrypted: i=1; AJvYcCVkJIzdLoKUFZk9usn2if58kBpDf7hOikSWROvToxh1H0p58j189vPCs4hX6IOg8gJ49m6bBqrPQCpLy7u8@vger.kernel.org, AJvYcCX7nfI0DHrA9HQ7xfQXeDE7U791oCMS33V/SyrGLW418Hbq1odmsjQ0SA3LevvF/1uqnRiL29Ng+LlC@vger.kernel.org
X-Gm-Message-State: AOJu0YxFENfEfsZHbbuiAomvAGlaoseYzu21QbVwt3y/DkUahO1wWouV
	NMAkwt/sb7bNiNgxHrKuJ+2xa+tCg0CgV9BS+gCK81JD3aphQwJp
X-Gm-Gg: ASbGnctkFPl7iXVwhF9r3Ad448anAdPoVk2JBj+o9Hurd1qj4/1MOugg42hZ2ZOsoIK
	sMuqQU1lVYpxYYioG2WqYyfoe0c5cdm44dtGqtKJgOyb6Y5/9kzazH71TXE0n1au514KFlFEpCp
	5nVC041zprgpEzl+HaZpenxla1GiBERYxIlIE0QBn2Vso9SNwxRZdvD5Hi2vEVIEldOlQ0k1WSE
	EeIG/FgmuFTs029/OOLGbfmayHRo/CKDxH2JppsAkZt8JM2mHJ2qPw4P+ZJrIjJOX3851RcEQMm
	fctyur4=
X-Google-Smtp-Source: AGHT+IGKbfyH17hZhjjkfuNLyXs/zyS4m1Jo1dS6wkWcGXybx9akScm0aPdVmTDsBNHHEdWCSAUHjQ==
X-Received: by 2002:a17:903:41cb:b0:215:6e01:ad07 with SMTP id d9443c01a7336-21a83f48e7bmr132748835ad.6.1736511078199;
        Fri, 10 Jan 2025 04:11:18 -0800 (PST)
Received: from met-Virtual-Machine.. ([131.107.160.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21a9f25390csm12706165ad.223.2025.01.10.04.11.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2025 04:11:17 -0800 (PST)
From: meetakshisetiyaoss@gmail.com
To: sfrench@samba.org,
	pc@manguebit.com,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	nspmangalore@gmail.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org,
	bharathsm.hsk@gmail.com,
	bharathsm@microsoft.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: [PATCH] cifs: support reconnect with alternate password for SMB1
Date: Fri, 10 Jan 2025 07:10:27 -0500
Message-ID: <20250110121113.60210-1-meetakshisetiyaoss@gmail.com>
X-Mailer: git-send-email 2.46.0.46.g406f326d27
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Meetakshi Setiya <msetiya@microsoft.com>

SMB1 shares the mount and remount code paths with SMB2/3 and already
supports password rotation in some scenarios. This patch extends the
password rotation support to SMB1 reconnects as well.

Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
---
 fs/smb/client/cifssmb.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index bd42a419458e..efdb7bf9bb57 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -152,8 +152,17 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_unlock(&ses->ses_lock);
 
 	rc = cifs_negotiate_protocol(0, ses, server);
-	if (!rc)
+	if (!rc) {
 		rc = cifs_setup_session(0, ses, server, ses->local_nls);
+		if ((rc == -EACCES) || (rc == -EHOSTDOWN) || (rc == -EKEYREVOKED)) {
+			/*
+			 * Try alternate password for next reconnect if an alternate
+			 * password is available.
+			 */
+			if (ses->password2)
+				swap(ses->password2, ses->password);
+		}
+	}
 
 	/* do we need to reconnect tcon? */
 	if (rc || !tcon->need_reconnect) {
-- 
2.46.0.46.g406f326d27

