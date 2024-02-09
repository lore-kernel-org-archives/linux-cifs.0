Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098691DA59
	for <linux-cifs@vger.kernel.org>; Fri,  9 Feb 2024 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707477952; cv=none; b=pA8h96JNoD3TFGUQ3jOZIJDHTAvwSYBEXXmfsw77dfbWfqVTO6+sdd2TooRdNjBZ5RLPXgLgFyC189ms0raqr2d9jDsR0K5UNCB/6z7cD9noaWyfxMdU+7xxauEaca0YMsEqFXHtWyUjkH55hdoo0O8ATKQKkjf0TY9EL5LHppU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707477952; c=relaxed/simple;
	bh=9Omkb+oOj9WJ18saxHwLtaGig+6CYJtNe1yIWUmHTyY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nt8nGcfEz/5TXwlcUUw3YRe6BIyyU5YjyGdvvSXkoW3NCJSoM3kaT91jJVLcYId0Qj2Zcmllv8/F2NzFbxIpaeEW43NNFaRTVw9EglOD+YYmuAosKVxsPZXKT4yZriQnMuOHlZsBRzVUaf+4sUnYeP2wrFb3Au4wgajkFa6gWBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvE4lT2Z; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvE4lT2Z"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-297108e7001so63639a91.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Feb 2024 03:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707477950; x=1708082750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=iJd4AAWYF75b9SiKACTuV0V3YSxTJjJF7p+Bj5h9EAY=;
        b=jvE4lT2Z4XSjhKHuA6W8JTBuA/7/Q2qNwtLi2v/hB6jHIH0qOovvjdcuGEAm7fKh6U
         1qHcS9VjJ85UI+nmdY9K+XPlYuAGlclH98RKXuzH3D4smkrHy9Afl6IwM0Le07AsGECa
         j3hfsEx3ah45w/4TRO94wXqR9cAqoCfmS5YAUvF/X+NDm5mfk05ufb9M9rOWnWc2ZKLY
         Ildy9PJsboSvK3raOd60sbrSNh+gVOtWpKhQLe2xee8u1RrV1C8Iqh7ldkZGujNz/wZr
         er4DTUeMPtm/o0IKhZZI+oE77i+xvdk2WKwRZPMmHrSBtHgatsbizse5oi7uoNdIIjLU
         3xUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707477950; x=1708082750;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iJd4AAWYF75b9SiKACTuV0V3YSxTJjJF7p+Bj5h9EAY=;
        b=iNomFqy2cnsz3CvknnPyA79wZQieG3cblefJDJ/obgtfond5iQkKFP9EeW9PGVVszc
         41NA2Xvyzuo1aLsXvsiYvjt0xW2kgJ3F/LMDGr5MMombpB7tKm7vCdQfzxzpI9cEdqWf
         TMrYMtTWGBuDp1wvBI3xjI+do3Oq/sgdOeD3/HT4fARvXBOLu78jVHOBjj3Qnkl6Hu49
         8KQBslw4mT6guGR5nvoK4GqZOjy7fnDhlpYR38aMGF9s40kOuR7kJH6Q5pJUAn7yyjhw
         6k1afs86zIbEDo1U2vNIa/JldKyvb9JCZyqmxCwloa2xi5CP3d+whjYHLPWkcQTmxBee
         UvCA==
X-Gm-Message-State: AOJu0YypUYlmebSY6NnZebk31X/dACkGqU4SwqrzYg8Y5i8kHUY6jWJU
	P4Ng221WDeVwFp1qWbUQTbPRGcOfZbp7l0L9rwCU5vzBOWoYBZW93wpqrm27JAY=
X-Google-Smtp-Source: AGHT+IGitSE6xIlMmrxZwyR5t4eZcpUdZvRclbueqOFhlXO1WTcHzeFKyuJ7ZjygHnpQk35vKvXvDQ==
X-Received: by 2002:a17:90a:4a05:b0:295:ff5a:5e4d with SMTP id e5-20020a17090a4a0500b00295ff5a5e4dmr1112887pjh.20.1707477949613;
        Fri, 09 Feb 2024 03:25:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWgIhAt/xyp77W6+GOvcxYQAcYu5YsvM6PRNp5DkBK/OOO+Sliqci6cDn3IPZiJnJFS/xJKBu7y7Ta3OjHadMFhK5KNDqRj5nxxOZEE38IlWar55BD0R9bZ202CCFOcLt5wmglP5lqvEA/ji931zg/zOKJJtFZEh0dYkkldrQ==
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id mm14-20020a1709030a0e00b001d70ad0fe79sm1303983plb.291.2024.02.09.03.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Feb 2024 03:25:49 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	tom@talpey.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH] cifs: update the same create_guid on replay
Date: Fri,  9 Feb 2024 11:25:42 +0000
Message-Id: <20240209112542.55690-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

File open requests made to the server contain a
CreateGuid, which is used by the server to identify
the open request. If the same request needs to be
replayed, it needs to be sent with the same CreateGuid
in the durable handle v2 context.

Without doing so, we could end up leaking handles on
the server when:
1. multichannel is used AND
2. connection goes down, but not for all channels

This is because the replayed open request would have a
new CreateGuid and the server will treat this as a new
request and open a new handle.

This change fixes this by reusing the existing create_guid
stored in the cached fid struct.

REF: MS-SMB2 4.9 Replay Create Request on an Alternate Channel

Fixes: 4f1fffa23769 ("cifs: commands that are retried should have replay flag set")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cached_dir.c |  1 +
 fs/smb/client/cifsglob.h   |  1 +
 fs/smb/client/smb2inode.c  |  1 +
 fs/smb/client/smb2ops.c    |  4 ++++
 fs/smb/client/smb2pdu.c    | 10 ++++++++--
 5 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index 1daeb5714faa..3de5047a7ff9 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -242,6 +242,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.fid = pfid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index cac10f8e17e4..efab4769de4e 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1373,6 +1373,7 @@ struct cifs_open_parms {
 	struct cifs_fid *fid;
 	umode_t mode;
 	bool reconnect:1;
+	bool replay:1; /* indicates that this open is for a replay */
 	struct kvec *ea_cctx;
 };
 
diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 63485078a6df..22bd01e7bf6e 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -203,6 +203,7 @@ static int smb2_compound_op(const unsigned int xid, struct cifs_tcon *tcon,
 	oplock = SMB2_OPLOCK_LEVEL_NONE;
 	num_rqst = 0;
 	server = cifs_pick_channel(ses);
+	oparms->replay = !!(retries);
 
 	vars = kzalloc(sizeof(*vars), GFP_ATOMIC);
 	if (vars == NULL)
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 8d674aef8dd9..c0da1935b0bd 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -1205,6 +1205,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tcon *tcon,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = &fid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
@@ -1570,6 +1571,7 @@ smb2_ioctl_query_info(const unsigned int xid,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, create_options),
 		.fid = &fid,
+		.replay = !!(retries),
 	};
 
 	if (qi.flags & PASSTHRU_FSCTL) {
@@ -2296,6 +2298,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = fid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
@@ -2682,6 +2685,7 @@ smb2_query_info_compound(const unsigned int xid, struct cifs_tcon *tcon,
 		.disposition = FILE_OPEN,
 		.create_options = cifs_create_options(cifs_sb, 0),
 		.fid = &fid,
+		.replay = !!(retries),
 	};
 
 	rc = SMB2_open_init(tcon, server,
diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 2ecc5f210329..1ce9be3a7ca7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -2406,8 +2406,13 @@ create_durable_v2_buf(struct cifs_open_parms *oparms)
 	 */
 	buf->dcontext.Timeout = cpu_to_le32(oparms->tcon->handle_timeout);
 	buf->dcontext.Flags = cpu_to_le32(SMB2_DHANDLE_FLAG_PERSISTENT);
-	generate_random_uuid(buf->dcontext.CreateGuid);
-	memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
+
+	/* for replay, we should not overwrite the existing create guid */
+	if (!oparms->replay) {
+		generate_random_uuid(buf->dcontext.CreateGuid);
+		memcpy(pfid->create_guid, buf->dcontext.CreateGuid, 16);
+	} else
+		memcpy(buf->dcontext.CreateGuid, pfid->create_guid, 16);
 
 	/* SMB2_CREATE_DURABLE_HANDLE_REQUEST is "DH2Q" */
 	buf->Name[0] = 'D';
@@ -3156,6 +3161,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	/* reinitialize for possible replay */
 	flags = 0;
 	server = cifs_pick_channel(ses);
+	oparms->replay = !!(retries);
 
 	cifs_dbg(FYI, "create/open\n");
 	if (!ses || !server)
-- 
2.34.1

