Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9584C3E5ECA
	for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 16:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776183508; cv=none; b=RODNblSXukWEJiKWDaS/odoQDx32zTHIlFO/Tc2t5GxTxNHzMz1PsGPDUQAMdunxxBIGoJPKDabT4bbdYOOFWEpmfWrtURAG9Iufeo9Eci7W30ztmcl9aO7JbvgC0dGMEj+hKbP7eHNKibkVoJGjYycsJGGm2J73KhlcyS8Ibpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776183508; c=relaxed/simple;
	bh=nibqdMYmBb7tAORp3Xmg66Zl4jf3OkES70n3H/pw9Ko=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8OcYJsWA6I+ieXdO6ftdovCDYSmWGFRLLHCd4vcRM8jy3DiWGs5I8SoGyt35A8qxuL/M5u1nd6x3YCRsh0KLyQf5BShNNP2nhkGmQvcWfsbHTLvk0U10sFFlnT8Rrml08K0DqZAK6Q6bZCs4yiQ8L4gxDR5fBA0Xh4bTuKCRuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pRUoNADS; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pRUoNADS"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-82c70e4654eso2516498b3a.2
        for <linux-cifs@vger.kernel.org>; Tue, 14 Apr 2026 09:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776183505; x=1776788305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3FEZZFLdFMDiBVXrPIj+L0y1hVnxidBgedh/d+dmu28=;
        b=pRUoNADSLhr0/lUBTpV8LwuvffdytY0w6O7bCB/wVWOBz37l2hJZQFSf/JDOeDtVvJ
         WMEEExFTp1KkoqmmS16wDHPExDPOj/paLFQQ+f87blRpdvhWGT8Nup3Tz3cKq2B08IDm
         qnkzhQTPQPGcZ2FQlB5+q9IIkDis9l3Vz64+GvCTHYxlHES/QYfj+J6zsZU0JJhIzbiZ
         bLCn16PYZFJixXkcrhpU1lJ4aPGf9j+8vf9ppwIbY3SsiDgJdVEq3r9YiE42O9tlh1aj
         dN6kcGa62vt0nKnh+hP/UlhO8slfuZWVxB4kz0ewMT9CjkSMY5bl69fDJg1Syn2m3/E1
         d1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776183505; x=1776788305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3FEZZFLdFMDiBVXrPIj+L0y1hVnxidBgedh/d+dmu28=;
        b=UqPLI45u/HrpfCgaj3NFiBAbAFIxDmE7hFrsJ3RoNCnKGgeYz9NhNrMiA9eT/qxass
         9Epr1nSpy2syLCGvMOvwIyCjDj4N71c6mlc66JuKrzqkwydzn1WBkLn2FnEMiWb7JEOg
         g7+HhjQopB/fsigptcnyGJbthQFzdhv8/yurQHIDiolzdfQqeX+hvK2GusooO42iEwno
         YR+m61DE8AaTW3QGSK+jIn3iyc1zuUphYrxd8Hm3tqGJ3bKfLsjEsvoPBssySK3D4dM7
         KRql1LfXrWurYcbJFXfr9ny8bmspsEr7H1jryXSFFAu00wVPmvatX0b0qHIUbY+N+XY2
         Flmw==
X-Gm-Message-State: AOJu0Yx6EKP/GnTugZcVugfLgHIicN2fi2RZLJumMpPKpV6Jr/uUX2iC
	ZREwhr8XKH47HYuDq5YDpnb3JzPB7x4XWSz2+18m7QyMaFXnecnJFC+cLQLOLU5L
X-Gm-Gg: AeBDiesFXV3k8wHxNqhKxgNejfZF7zCLdIm41dM0EYJ+yW8aQLO5hZvtmPBkpc8Q1JL
	BH5++oLrArMm9wDVxMrCInK7AQ9+3HN66SoqJpGnXg3R4fsdYKQvRhagq9xEmE43zPW6uif4ol8
	loQZ8qbhAFKW2N0jbvY2k4EeiTOwbFPvON+cORRdAFkuCEL09wGZ9wms67yae/hT4NnStgtbmAZ
	BfzV8+QuS8KhHGR7NRbOsHVW/Xci4qKsiGpbnDIZEYKGiEOvJuRak13DcV7Y5mliMgATb8Kt6NL
	fa9FGJmkdHFxpiUhmfjHdNy03kTHbkCp8YKEg6YLc0TzmMorIwXvGkWiEHyvciRhdn8UCPWpN4R
	noqn96a2ri6IkfhX8BIozq+ihfxhrlNsFQ42x6F17+KX2FRCJnoUdvIOYYl/UXk8xr0ulrM/JwB
	oLEKTpBJjtmhtelYSdaixmwILcD3zPBVarRIpn3Y1aC/WO1yjDeMWbSPy4quxHeA==
X-Received: by 2002:a05:6a00:6904:b0:82f:1369:7272 with SMTP id d2e1a72fcca58-82f136995f4mr11170122b3a.19.1776183504975;
        Tue, 14 Apr 2026 09:18:24 -0700 (PDT)
Received: from bharathsm-Virtual-Machine.. ([167.220.110.101])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee59sm15298585b3a.1.2026.04.14.09.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 09:18:24 -0700 (PDT)
From: Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	sprasad@microsoft.com,
	pc@manguebit.com,
	ematsumiya@suse.de,
	henrique.carvalho@suse.com,
	bharathsm@microsoft.com
Subject: [PATCH 3/4] smb: client: add oplock level to smb3_open_done tracepoint
Date: Tue, 14 Apr 2026 21:48:04 +0530
Message-ID: <20260414161805.233686-3-bharathsm@microsoft.com>
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

Add an oplock field to the smb3_open_done_class trace event to
show the granted oplock/lease level. Move the trace_smb3_open_done
call after smb2_parse_contexts() so the oplock value reflects
the parsed lease state (R/W/H flags).

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/smb2pdu.c | 10 ++++++----
 fs/smb/client/trace.h   | 16 ++++++++++------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 61bae531959a..96140f6d30b5 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -3044,7 +3044,8 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
 	}
 
 	trace_smb3_posix_mkdir_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
-				    CREATE_NOT_FILE, FILE_WRITE_ATTRIBUTES);
+				    CREATE_NOT_FILE, FILE_WRITE_ATTRIBUTES,
+				    rsp->OplockLevel);
 
 	SMB2_close(xid, tcon, rsp->PersistentFileId, rsp->VolatileFileId);
 
@@ -3321,9 +3322,6 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 		goto creat_exit;
 	} else if (rsp == NULL) /* unlikely to happen, but safer to check */
 		goto creat_exit;
-	else
-		trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
-				     oparms->create_options, oparms->desired_access);
 
 	atomic_inc(&tcon->num_remote_opens);
 	oparms->fid->persistent_fid = rsp->PersistentFileId;
@@ -3348,6 +3346,10 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	rc = smb2_parse_contexts(server, &rsp_iov, &oparms->fid->epoch,
 				 oparms->fid->lease_key, oplock, buf, posix);
+
+	trace_smb3_open_done(xid, rsp->PersistentFileId, tcon->tid, ses->Suid,
+			     oparms->create_options, oparms->desired_access,
+			     *oplock);
 creat_exit:
 	SMB2_open_free(&rqst);
 	free_rsp_buf(resp_buftype, rsp);
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index cb5ce1316eba..57abf5fca26c 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -1321,8 +1321,9 @@ DECLARE_EVENT_CLASS(smb3_open_done_class,
 		__u32	tid,
 		__u64	sesid,
 		int	create_options,
-		int	desired_access),
-	TP_ARGS(xid, fid, tid, sesid, create_options, desired_access),
+		int	desired_access,
+		__u8	oplock),
+	TP_ARGS(xid, fid, tid, sesid, create_options, desired_access, oplock),
 	TP_STRUCT__entry(
 		__field(unsigned int, xid)
 		__field(__u64, fid)
@@ -1330,6 +1331,7 @@ DECLARE_EVENT_CLASS(smb3_open_done_class,
 		__field(__u64, sesid)
 		__field(int, create_options)
 		__field(int, desired_access)
+		__field(__u8, oplock)
 	),
 	TP_fast_assign(
 		__entry->xid = xid;
@@ -1338,10 +1340,11 @@ DECLARE_EVENT_CLASS(smb3_open_done_class,
 		__entry->sesid = sesid;
 		__entry->create_options = create_options;
 		__entry->desired_access = desired_access;
+		__entry->oplock = oplock;
 	),
-	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx cr_opts=0x%x des_access=0x%x",
+	TP_printk("xid=%u sid=0x%llx tid=0x%x fid=0x%llx cr_opts=0x%x des_access=0x%x oplock=0x%x",
 		__entry->xid, __entry->sesid, __entry->tid, __entry->fid,
-		__entry->create_options, __entry->desired_access)
+		__entry->create_options, __entry->desired_access, __entry->oplock)
 )
 
 #define DEFINE_SMB3_OPEN_DONE_EVENT(name)        \
@@ -1351,8 +1354,9 @@ DEFINE_EVENT(smb3_open_done_class, smb3_##name,  \
 		__u32	tid,			\
 		__u64	sesid,			\
 		int	create_options,		\
-		int	desired_access),	\
-	TP_ARGS(xid, fid, tid, sesid, create_options, desired_access))
+		int	desired_access,		\
+		__u8	oplock),		\
+	TP_ARGS(xid, fid, tid, sesid, create_options, desired_access, oplock))
 
 DEFINE_SMB3_OPEN_DONE_EVENT(open_done);
 DEFINE_SMB3_OPEN_DONE_EVENT(posix_mkdir_done);
-- 
2.48.1

