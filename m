Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793B514A86
	for <linux-cifs@vger.kernel.org>; Sun, 21 Jan 2024 03:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705808016; cv=none; b=re6KmFhgLMnb6maN3YZUuZ2FZtRGt+q7Yo4SBzAKo4TRSz12xbA1xrKUk8UEh+ASiYarbPcQAQ2655ofG06pTXT9fXZkpSHQKcInYxRrWSqIt+07ax9EVIcfG1xxrrZt8ZjjntBRd4sC1bU5clHnhc0HwsW09LjweOzGYdPbj0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705808016; c=relaxed/simple;
	bh=4F5ClitWe47kq3A29eFByKbVBCQuDDdkDJB88zL0Cs0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ihGwLQNuRXEYU7hd9pYC56t8es8lYV2TBZnxhsIW693wsCQ8hpPFEftCQlhJbxUZGcmcsBTdgybTY7buAXidTXjCMJgEHUVhiKcr5HwEazpBpvbvlfVQ9KC7E5Fd76tK23ZLKdFILqQNKmU58ca9BBzWZdQS9VZpMwU70HHOnCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SBYRNLSz; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SBYRNLSz"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6daf694b439so1338944b3a.1
        for <linux-cifs@vger.kernel.org>; Sat, 20 Jan 2024 19:33:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705808014; x=1706412814; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZsvZ9wp7r/vrwBrSEVi+y2DE6g0VhzvM7Ta3kQvqaJk=;
        b=SBYRNLSzNrcA2RJ7viKjoJuESqd44bU5M7nM73R0b2M1aAmS0Y7G5j4DboCzND9HGb
         L4/oKljMv2deeO63FEYh0+yGDlfXIloK2SSuzagfvxBQaPiQ0m5EL7HSDUOoDneaUECy
         P9DYtYAluhltyAa3e9PMURf2kdOKEePX1TaDKwC43VrsxKseXxBugh9ADH+SwRMr2j6j
         BKfyc+oWkEpbF94ssClraw7BZ3HbRkwS6fYY//aRYlCn+vwz+bqcMKHg4rJZHCV/+GW3
         ZSfK1ByBGAAZlVSpnwCYhbLaZK9l0cSo1NT7xCH/1nByBlFRK9Wq4pXyPZP7FLZeBlVL
         LDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705808014; x=1706412814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsvZ9wp7r/vrwBrSEVi+y2DE6g0VhzvM7Ta3kQvqaJk=;
        b=LjAYLN2R7KkOkQx03h6aLZOFaNZvj9xhvLADW/gUguFwmLgllIeyhLHbh3y6jgiK4a
         YiDb4Hs0735p9mcwYBW4jGcPAxh6FtB9b2rruzRPdBAiI0mimMRKmcEeHUPco9GvqxeK
         NKp5VRkO8WZ/jvqTEumGmUsPA9OKnqhGb03xA4asv6exwM9vyqXpmrkTPdLRsX0qmKE5
         +87iN/dA/6qSQ13yODl4DGEsIgimeJ9wqGuUDLVUYqRg4hOL2fBm0qcRAf3GivcR9kVi
         OdwWZTkkzA4TwOAxsj48xPZJDxR5RQHBRkbxe1OmXluDkrBGMdFXdZ3HyuYT2fR3b6RJ
         Zr/g==
X-Gm-Message-State: AOJu0YyCEpueNtTcR6wjpTyNdjcVfOZJ5E3qTuwlr4WuWojP13Z/gzIB
	/W99H56uyeGlDgelbsygcnYhqsoVttWqt/d1C5O8wOOCfAlM0/iiu7HeivW4
X-Google-Smtp-Source: AGHT+IEvTwjJAgcDviOjlYp+eDZrNzV+o9imrBndSWbZ/+HZNJY7c21rfReppB2qalsS3ufKvQoDrQ==
X-Received: by 2002:a05:6a20:2d29:b0:19b:ffea:43f4 with SMTP id g41-20020a056a202d2900b0019bffea43f4mr570135pzl.103.1705808013794;
        Sat, 20 Jan 2024 19:33:33 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id lg14-20020a170902fb8e00b001d058ad8770sm5193166plb.306.2024.01.20.19.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jan 2024 19:33:33 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 3/7] cifs: smb2_close_getattr should also update i_size
Date: Sun, 21 Jan 2024 03:32:44 +0000
Message-Id: <20240121033248.125282-3-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240121033248.125282-1-sprasad@microsoft.com>
References: <20240121033248.125282-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

SMB2 CLOSE command with SMB2_CLOSE_FLAG_POSTQUERY_ATTRIB
flag set is already used by the code for SMB3+.
smb2_close_getattr is the function that uses this to
update the inode attributes.

However, we were skipping the EndOfFile info that's returned
by the server. There is a small chance that the file size
may have been changed in the small window between the client
sending the close request (thereby giving up lease if it had)
to the point that the server returns the response.

This change uses the field to update the inode size.
Also, it is a valid case for a zero AllocationSize to be returned
by the server for the file. We were discarding such values, thereby
resulting in stale i_blocks value. Fixed that here too.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index d9553c2556a2..e23577584ed6 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1433,9 +1433,9 @@ smb2_close_getattr(const unsigned int xid, struct cifs_tcon *tcon,
 	 * but instead 512 byte (2**9) size is required for
 	 * calculating num blocks.
 	 */
-	if (le64_to_cpu(file_inf.AllocationSize) > 4096)
-		inode->i_blocks =
-			(512 - 1 + le64_to_cpu(file_inf.AllocationSize)) >> 9;
+	inode->i_blocks = (512 - 1 + le64_to_cpu(file_inf.AllocationSize)) >> 9;
+
+	inode->i_size = le64_to_cpu(file_inf.EndOfFile);
 
 	/* End of file and Attributes should not have to be updated on close */
 	spin_unlock(&inode->i_lock);
-- 
2.34.1

