Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F96314B73
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 16:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776183493; cv=none; b=aTXvWYO07ZrjnBvTgU4ToXhgyI5Mo5DOs/LOkAG8tEWquRAHOVrJ9Ndd4V5m+2RQM+V8yB5pw27AcrziNSnHRp77mpNNb2eYC4h2oGi+r9OSTvmS8ggeYPVgJLHNr5z+goD3ZA6F8gEPtVUCXWkPjC0xD/R2wDvtugHUPkVrb1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776183493; c=relaxed/simple;
	bh=1cKR59a8LFv+m3+/Saa1ocskqgMkiRtSNSU9mYzf3EM=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTnYghgjwiDmiD78qiGXLc1GRJsjF7CQFMSRc1dbCEwSC/G/OeNGOH14FoQIsP02oy4s8U6kMV4348MZWF3V0BAM8SFp0SNzesCQsT9DwPHR+vR6WZfW9mmA5FqiQTKnrgfNUKaTgtah/1xBuq1o7MfF2mN2sbnpKMjoGhuskBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UB5+LK21; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UB5+LK21"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82cebbdab08so4259805b3a.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 09:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776183492; x=1776788292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K71PSMfpHRlyFWoQ4+uuYsY2JS8Ju9wHEZODt3x5U6w=;
        b=UB5+LK21KjBziOHq4y3rnEfESoUOG4Svln/EoY6DAnXM1+mf60aivuaOuWG8/dQRVZ
         sAVSse1aQ7bPK8rVLUu9t7sE0Hpbk3WlHOPwdPnWQSp7uUBTgswJk27xwueLTdqWzCtZ
         Kprzd6L+uVOFNT/Y0AH6OG7v2+tkVHjsIoNx3MwW4eH4hJdQ/mqTULt1q7i8MGo8fz/q
         9C11o5igLzFRydWuYliM5EZMD1TadureTlpDjSvMKjX5JXXcTQgbUkg8sL2BLTXhJkzw
         eYqS58skz/MPruEadaqwv7hI9AmPWkeULjvrsDVN6/MGuaZ8pgY7aO6k6aUnrwgi2r+I
         EeSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776183492; x=1776788292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=K71PSMfpHRlyFWoQ4+uuYsY2JS8Ju9wHEZODt3x5U6w=;
        b=ZR6JYD3tYFiFgtcN2YeSlzQO4I+7AjfqeDcBfI6edk5KpnUg9IsWysie9TJTmsClx1
         BL3Wc/nrkwUGo6v6S/yIxF6B+8sehDDYCo2FF2JgZ3zxRGAcVXZLU2capiu5BWyH6tuW
         65UQVlaegfMPbEfmi6SfO5RGqcsW/tY25XZgAiBemXqSW62Kln6GRepITMBbBd8raN21
         EXSGdvXCH0A+vqUgrdEmIQtMhvie3jA1+vM8YeEPwsLvD1FOQp1cN8HhFF8TBHv4iqfG
         BwqGtCDPZR6NPIo+G5Gja7BzxvgIHsa4d2ZWILlu/JKkqtACqtTI5RO3JP6w0cx8mHGb
         kpAw==
X-Gm-Message-State: AOJu0Yyyc60EbswRZ1ON/GPYhDhvdeHDhcLHGFUVx+ESW7xOHZi/O19m
	5ZR8BM18kNfpit+/8kedPz+DUwM5m1bKtUSxPvJGl/+pGemSIHGWXhJ478F/l8A6
X-Gm-Gg: AeBDieshLnOvfCr54bx+dFeQpx3mDBGqtJMJT1o+3oyYr2eT9KPBrDB7PR3LeZszLu5
	7Agrzs40rU9/VMP78Q3Dtjj5iCCInmvmE5uLz6niwma+ojEoyb69SlC/S5nk3p0ktUMXOkr4WvZ
	YPxXSJW+N4Cym7rNJKZq/ofncRzykQAk80LICnG7sIibfnLITFj+mDGkOGslfkpPtSXfNxxD7Kh
	X68H4bQyQd2A6dTcNFu9aFgnkQN+jFd98Tr/atTVwF0ibezN1C/6fPn/xdl3V4jy3uokwFAkjRh
	wGUI1YwiaKncZ9z8R06c13G2AxrHDkmwG65GjvX+RvKIpdGBE1/OKDczARIoCgEZSMTpR016QY6
	TYGYWsmw0e5WH7UAY57kE7teOfcG+XAlZtadFcxoXHz48CKvFcTdcZqg9c+w5O5TtEuQ2LS9PoF
	tbRO+6DMcwnV/y2iLVR5h4s2GvpuMjalK5HUQ8h7fe9YdNy/SNbuuVL1c32L/Spg==
X-Received: by 2002:a05:6a00:2ea2:b0:82a:8865:6fe6 with SMTP id d2e1a72fcca58-82f0c2a7417mr19702739b3a.28.1776183491641;
        Tue, 14 Apr 2026 09:18:11 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.110.101])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee59sm15298585b3a.1.2026.04.14.09.18.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 09:18:11 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com,
	ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	bharathsm@microsoft.com
Subject: [PATCH 2/4] smb: client: add tracepoint for local lock conflicts
Date: Tue, 14 Apr 2026 21:48:03 +0530
Message-ID: <20260414161805.233686-2-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260414161805.233686-1-bharathsm@microsoft.com>
References: <20260414161805.233686-1-bharathsm@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add smb3_lock_conflict tracepoint that fires when a byte-range
lock request conflicts with an existing cached lock. This helps
debug lock contention issues when locks are cached locally due
to oplocks/leases.

The trace includes both the requested and conflicting lock details:
- Requested: offset, length, type
- Conflicting: offset, length, type, pid (lock holder)

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c  |  3 +++
 fs/smb/client/trace.h | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index 66a678a0e89f..4662592801b0 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1631,6 +1631,9 @@ cifs_find_fid_lock_conflict(struct cifs_fid_locks *fdlocks, __u64 offset,
 			continue;
 		if (conf_lock)
 			*conf_lock = li;
+		trace_smb3_lock_conflict(cfile->fid.persistent_fid,
+					 offset, length, type,
+					 li->offset, li->length, li->type, li->pid);
 		return true;
 	}
 	return false;
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index 242c9da0283e..cb5ce1316eba 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -729,6 +729,41 @@ DEFINE_SMB3_LOCK_EVENT(lock_done);
 DEFINE_SMB3_LOCK_EVENT(lock_err);
 DEFINE_SMB3_LOCK_EVENT(lock_cached);
 
+TRACE_EVENT(smb3_lock_conflict,
+	TP_PROTO(__u64 fid,
+		__u64 req_offset,
+		__u64 req_len,
+		__u8 req_type,
+		__u64 conf_offset,
+		__u64 conf_len,
+		__u16 conf_type,
+		__u32 conf_pid),
+	TP_ARGS(fid, req_offset, req_len, req_type, conf_offset, conf_len, conf_type, conf_pid),
+	TP_STRUCT__entry(
+		__field(__u64, fid)
+		__field(__u64, req_offset)
+		__field(__u64, req_len)
+		__field(__u8, req_type)
+		__field(__u64, conf_offset)
+		__field(__u64, conf_len)
+		__field(__u16, conf_type)
+		__field(__u32, conf_pid)
+	),
+	TP_fast_assign(
+		__entry->fid = fid;
+		__entry->req_offset = req_offset;
+		__entry->req_len = req_len;
+		__entry->req_type = req_type;
+		__entry->conf_offset = conf_offset;
+		__entry->conf_len = conf_len;
+		__entry->conf_type = conf_type;
+		__entry->conf_pid = conf_pid;
+	),
+	TP_printk("fid=0x%llx req=[0x%llx:0x%llx] type=0x%x conflicts with [0x%llx:0x%llx] type=0x%x pid=%u",
+		__entry->fid, __entry->req_offset, __entry->req_len, __entry->req_type,
+		__entry->conf_offset, __entry->conf_len, __entry->conf_type, __entry->conf_pid)
+);
+
 /*
  * For handle based query/set info calls
  */
-- 
2.48.1

