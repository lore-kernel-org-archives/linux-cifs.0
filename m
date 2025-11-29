Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A63C23EABC
	for <linux-cifs@vger.kernel.org>; Sat, 29 Nov 2025 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764440801; cv=none; b=BygBQJGdBIKJyC/GFaOe/6BwpEVOFwZEBMmtD0oZWZp0cjaRYbrEYKpfCxbSHLnoAQji4Qslcw3oJuN/c+xLgcJEIENMmBJtsidx8RiM2EGeAnSATFDzy/C31rKK+fWP432phStqBY2tstLfYob1SXHlruE3YuBL16sy360455k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764440801; c=relaxed/simple;
	bh=FjR1mEntDRObhFwEuwXhUYzmEdGdSC5tkuVCgZxGZDw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KlUGDLcvRMrwgiENLpcUrD997y6KLwhXpSzEVRzhQNCobuhiyLceoXZPYQRTAijhLfSInOXnjmDzqvfRzTkERRk35CwJre8rl4fvngYFdTn7vt+E6lcqOnfcFpKh+OA/5QwJ7wGzLDISIwtqvqmTFeYU/SJTrz8NI7+Mk4Csj+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=neVAk/po; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="neVAk/po"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-297ea936b39so9461395ad.1
        for <linux-cifs@vger.kernel.org>; Sat, 29 Nov 2025 10:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764440799; x=1765045599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3JC72Qo3TOw1s9p+vntPcAPUKDQuPh5dqE0qtCY/uIg=;
        b=neVAk/poM+FjQYpmrmh8llX2yqbRLirruQKfNjFcXcIxwzs5at9ywBBKnxAyxcbJnT
         j1ci9fKbKlb2iCoKyLEQN8RSf1jxc4Qy48jL2Mn84yld84IZu1wwRVs0skhQnL+kwyE7
         WcpVnK7iQMMTVfS60u+0t4IlhNt9zgxTofpqAbs74v6nXVfuL6jc1tDri0QeNn5TIjiJ
         J1z3mXiUi/tsCo1yJub4wW06KUK3yow2P5ZGx0tUdOEEjh9ag7M1hS5jwoO2in2bydLJ
         mf5QeT4H44aaegfUV1ytr+P7I4eF6c2yO2nt3jV/HIDq9xo2WDz0Q3NqZoL7PHSmm0AT
         +1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764440799; x=1765045599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JC72Qo3TOw1s9p+vntPcAPUKDQuPh5dqE0qtCY/uIg=;
        b=Gz8Cgeh7JjF3O/4gUQiHrlRXVriUDs4C08SPDuLn9ZXmqhnTM9oi9UWSfiqYCjoFfE
         z6aZOGNhdqKShL+Frq1ryvkHqt75u9PW/0YmASGcC3AV2OGnP5IF+tgztq+IKaj4HLmZ
         7Uw0jjkS40j1XxEjbWt4/Xaw+tE+6c+JT4LA+xHOk6vCIpRYqKmDpIPkPcgmUADVUuOF
         ij7atBTxxK10NZvGGqcM6aRfoV8qbnk3+GlWd1OR0+Qp5ycgpeoqberwkT6qVzxl3gtV
         qjWVq8r6orL2HACdaaLv1a4qJqDliNUrcPPaGcTM2NUhNiD5vuiEll98ImWidIVM1Sqf
         e7VQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtdDLYQzilx/bWPgOJajrTTL4XEKP8lQoyUxS09aiL9FJcEyE+XaMKfWCvL8Danq9eX44J3wGoxd0x@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/M19lVni/pnswXkcQKmx+tqL+TS5Ls6oRcdJulTNNP20r5cd+
	iN6lvF7t9l6+JeI8GNLhn4V3bQZBXeBmfVs36dcP9rJZaPLDsJ1tTbg/
X-Gm-Gg: ASbGncvaRQUnD+RaiFGAqORjTfIAFzPXYuo4wBmfnDnMsrPNS8RipK01SS5A6YZ631C
	ipDdeZ77DH+IRO1/2HNbcX/CmdxK8dfuiNha207peY7WR7A2I5GPnoHgf6j6TGajLVDOXnWe/Og
	HDuefwKbAsnhg7CZxjKxCCNzMBgOdks45snqTafXo1f2GYhsrXskCWFsq17mKOmQZRDmNkRwXB7
	FbqxnPb9gwwCYqQw54vc16bvHiZcLm56ZROhsECIL8z6fEXgShWojnDKlxHD0qnhVGfTkMd09Qy
	dzjymoBxdlZFPZx4nzPY+ZM5j4be46EA6bz5blbETYfUYRyCv5GPcN/cO8nzPZJfRd4eZMEfgCY
	NSkWgiBVU47F3TW6FIgzSA4GHHQUGLBUGVQ3XsZFU5Pkwjn8ZagzsDziTq6yARoOVlkhkU1X3X5
	GZmqtgbo8OBCYg5g0=
X-Google-Smtp-Source: AGHT+IHFWCBKPxYkoDnGrX3Bcm9s9hshcjYoD0pvajZbvW2Kn2yTSUnpKDGOc1WjpWgPnlDwkvZVcQ==
X-Received: by 2002:a05:6a20:a109:b0:345:42cb:50b8 with SMTP id adf61e73a8af0-3615437dbfdmr20262810637.8.1764440799603;
        Sat, 29 Nov 2025 10:26:39 -0800 (PST)
Received: from morax ([2405:201:4039:48b0:c6f2:57d3:9f1d:7d73])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-be4fb248be1sm7796131a12.3.2025.11.29.10.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Nov 2025 10:26:39 -0800 (PST)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: sfrench@samba.org,
	pc@manguebit.org
Cc: ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bharathsm@microsoft.com,
	skhan@linuxfoundation.org,
	david.hunter.linux@gmail.com,
	Aaditya Kansal <aadityakansal390@gmail.com>
Subject: [PATCH] smb: client: Remove incorrect TODO in cifs_mkdir()
Date: Sat, 29 Nov 2025 23:56:23 +0530
Message-ID: <20251129182623.530415-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove a TODO comment which suggested skipping the call to
cifs_mkdir_qinfo() for SMB 2/3. This is incorrect because
cifs_mkdir_qinfo() contains SMB 2/3 related code.

Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
---
 fs/smb/client/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index cac355364e43..20acbe88f1c3 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2314,7 +2314,6 @@ struct dentry *cifs_mkdir(struct mnt_idmap *idmap, struct inode *inode,
 		goto mkdir_out;
 	}
 
-	/* TODO: skip this for smb2/smb3 */
 	rc = cifs_mkdir_qinfo(inode, direntry, mode, full_path, cifs_sb, tcon,
 			      xid);
 mkdir_out:
-- 
2.52.0

