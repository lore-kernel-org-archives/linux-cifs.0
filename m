Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CFB1A76D5
	for <linux-cifs@vger.kernel.org>; Thu, 19 Dec 2024 18:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734631223; cv=none; b=NEFFKmlvKJMLlN9dIPOK+nDGAme0uQt9hAOp6J1AhWoTs2AnfDwP+HuHhK0WuPwIoLMdPn3x1a+sfiAq1eGp4yfFfhiH1qfRxG9Pencup5tkxu+V8qPXzdDS4jBv0fOeYz8kd5WUg6mB/wN3EAbbsk0WUUTqux3Si7vv5aWzfqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734631223; c=relaxed/simple;
	bh=rbQa8Mze+5MENXGfW5CI6I5AO4HIqA72Srs5TVI3pv0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pu7AJDB7rKF8zOeKk6y3/qUhVtUqRyGeOcx61csqd3PHuEDtP/Mk8IrYiw3OroBw/q98z9hJvHzKH0I0uB6SGFMkiMUALFqT/DS5zBXhLu7QVo57WtwJgQ4aEUg6p6gAvL24lGxGBChVnNgrL+dbVO2NlTVy21p68LMvbyNg74Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DP3trsUG; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DP3trsUG"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-21675fd60feso12868735ad.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Dec 2024 10:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734631220; x=1735236020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OYEnbng14Mvnn4vxsBylCr8HsKPPgoJTl0I9pX9025E=;
        b=DP3trsUG+NJZ7jTKuDuohy5JbrGkFGhEr+pPaVrngcrLo8eiKb6Nr4zuL2O+TEjHTA
         hEyJEk/oX72+OJhonzo5L2Qc7Msaz6zIE/shTC9iDowtrRqZ28FbLSpsABYX7VhXPUQX
         Ncy3X8beM5TTrkR7JTnUAavXhg+scc8salKHH0Q8XFMTG8a9Mm5ySye5M8QXLlf+dyLz
         eEHYmmHO8o8XCQPn7LbY1kGpvR6oWyHnXyuDYyBukRH+/SHhmgFmzvrbJ9XKkJbLu+ig
         arlox+wPFDsVmV6LqHgz18NSkOOLX5DIyAX9qi+vCy5HKelsK1s1yDBVnaJBd9Y4ypHE
         0Jzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734631220; x=1735236020;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OYEnbng14Mvnn4vxsBylCr8HsKPPgoJTl0I9pX9025E=;
        b=I8r9xF+cpmQ7Xbi2zxehLuNITRievVU44GAacODHpkoOqyOCJpBJ7llswds4Rod2Gv
         svFZEZGhvvGR1KTRrQu3LYGscmUr0fLV7y5t5pksY5H2q7l0NN6QZHW8Pa2tQA1+HFQ6
         CHW0p9/rKzxh3LttzWP1fF8RMIWwif5ORTPlwfYEDAl+IpTZQ2aEAVSBzhXeLAFnasV4
         Aul/6lcv2ehG2B3pKzKNDPUYJfyvwDI7vmiHai8SxrL9s3hoVzKey7HpiCGvI9sYo+G8
         AsWk7F2TqvYt06bEdrvCK6x5SHWJAbLWiyNs5GsdogOhJfsFV3MwTk4ZbvCAa0J0IdVi
         9lFA==
X-Gm-Message-State: AOJu0Yy3La+oY7r3gqkiimW6ZpVFWMlJS+xm7ayh8kiI9EZ9+jbrgalZ
	E3/T5QIUr7o6SdQk9L88opBYPj2YiVatw4lkFevQm7lu4Zi4BYLHdga2Vw==
X-Gm-Gg: ASbGncsm5vafgYRTNPztbcL8uti3YsFWkZTT1hU+/WEvaSNoD3+G5tNy6wrIcSc6ZX8
	zshAYU1loI69pW4XP2m2lWElkQBAYE8gRZn1sRHMGPhQUlLg3RDVneVF/KAVGdKH9RNTfJBx4pq
	wPHHb/y+XbDZbgX/Ta4Eaun7Ve9/fx91zip/utTRZdPLUiaVKTooBJXqA6HqZ2M7ZBPB8uuaN3k
	of167PzEE7O4aMOGkXIgKO/woJFhEOyaIgrdnqH1c9cQbmZYXr1D5Xsmrk0A3x3PkOuabwsNJVV
	IxxJ25Mg
X-Google-Smtp-Source: AGHT+IF/achmFZamRFtRwUu5QhsOnoXaOThsDT2gmpw6Axm1j0IvBR1p17Z4fXZnv9Oc/GjGp2/eug==
X-Received: by 2002:a17:90b:544e:b0:2ee:7415:4768 with SMTP id 98e67ed59e1d1-2f4520f2fe3mr431402a91.17.1734631220135;
        Thu, 19 Dec 2024 10:00:20 -0800 (PST)
Received: from bharathsm-Virtual-Machine.. ([131.107.160.189])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2f2db9939b5sm4260034a91.1.2024.12.19.10.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 10:00:19 -0800 (PST)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	dhowells@redhat.com,
	sfrench@samba.org,
	sprasad@microsoft.com,
	pc@manguebit.com
Cc: Bharath SM <bharathsm@microsoft.com>
Subject: [PATCH] smb: fix bytes written value in /proc/fs/cifs/Stats
Date: Thu, 19 Dec 2024 23:28:50 +0530
Message-ID: <20241219175850.34836-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With recent netfs apis changes, the bytes written
value was not getting updated in /proc/fs/cifs/Stats.
Fix this by updating tcon->bytes in write operations.

Fixes: 3ee1a1fc3981 ("cifs: Cut over to using netfslib")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c945b94318f8..959359301250 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4840,6 +4840,8 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		if (written > wdata->subreq.len)
 			written &= 0xFFFF;
 
+		cifs_stats_bytes_written(tcon, written);
+
 		if (written < wdata->subreq.len)
 			wdata->result = -ENOSPC;
 		else
@@ -5156,6 +5158,7 @@ SMB2_write(const unsigned int xid, struct cifs_io_parms *io_parms,
 		cifs_dbg(VFS, "Send error in write = %d\n", rc);
 	} else {
 		*nbytes = le32_to_cpu(rsp->DataLength);
+		cifs_stats_bytes_written(io_parms->tcon, *nbytes);
 		trace_smb3_write_done(0, 0, xid,
 				      req->PersistentFileId,
 				      io_parms->tcon->tid,
-- 
2.43.0

