Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3C63C661D
	for <linux-cifs@vger.kernel.org>; Thu,  7 May 2026 13:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778161508; cv=none; b=LY7tjDXs4BRpdtdQWZTKEhDlV5omWJsPZL31v88i6gr4p7ZMjWdLx+zdVrk2udHpGsMHgELwMfmDHFyO7aYzwOyxTHDG+3shr7wglbuTMUkgeSukWmFfAh7is0tAfmvcx0TSBwdHoPWEDHzVkHpzPa+RfWWiS5IkTWYBTDLvMUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778161508; c=relaxed/simple;
	bh=VG+41lZ448btaNUOynmCdnEZq9o8tA/uUr4F8PoMhNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qjY8TDLxizaQMxaupZqwGpmGBgZzDVp+GYVijeZK+kKmpH5bBPRmaOuyzfwtQVPYsSGAAKNnI/ubiuGQ5g1u8r1Bp92jsR5FU/5dbyYlz5C5idoZhvLBsbeTtS04c9aF1E22OMHA9i9+qZFty1QHAzV7oms/pOlnNIFzqSrgaec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TD5itKVA; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TD5itKVA"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-36627a0ea23so186956a91.0
        for <linux-cifs@vger.kernel.org>; Thu, 07 May 2026 06:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778161506; x=1778766306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4wxpdgZR3F+6gO9A+ACWETsBld7N7ULc+/S9pmw4rc=;
        b=TD5itKVArHc6uogtTmKhoeM6135KaoO4mO//KoZuU1XAD4dyDUahC20S2YFzPtur60
         VV4a8y3+c7DpY71SrHaewjnMMJOWAHkHV5cKa6BJGid3DP8PAiXbQTFDmFVkMgKguQCT
         oBQRdVvaETFwf74f7Y8pvjaHdX4twEj+7vn+lJl3fSWl4bA1aGSKJi7fGvtIpPOKgX61
         LHQR9H38Wf9SUuKcdCA2SA3YX8SNxKmCqXJUQojJUz9pLVRj8N7+k6UNKibmP2fosuTm
         w1+JriqM+IboPLShUjIFNGzKFpquZx+pIPSw0helo6+ZEVrwx7+dlYrP9FO7bGyZYmZk
         ngxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778161506; x=1778766306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N4wxpdgZR3F+6gO9A+ACWETsBld7N7ULc+/S9pmw4rc=;
        b=E+vnPoYGYDXPsRQj3DMVP2Bx+QN4IAHEzkwvAhOh3XXSMDx6ASqUN6WqpK3tSysu3x
         StP6klc4WIj13iXgVKAWpZClO+eOZQqGDpVjarALehYk6MHTRsa+lFh4VeVNH5/W7nXL
         Uujy9HSAbh8qgbhqlZXXabEKgDhcQHVTDTDnHPimzDhwWGKgaHgMHwz3BTat09Q/jMJM
         d1Sjzxo02xjROqs3YJosgnMfwfgqLZtvzVxe+QAC6SXpQj9Zds3i02o8YQBbT/vQGtvv
         7a5tj2SblUZLYsZeNQ8+9hPzIZVUOkFChsHHqoxcEmy5hPOLHFTexG+6FJd0iEmEz4Cs
         2Oqw==
X-Gm-Message-State: AOJu0YyRQfcuwfFMcKD4T/hHx1O6V1isD6qjgPsyAPiO+ZJ5W46JeZxN
	OJyHKjhJwdUt5/Q2hQ3dAGYQqvZkihIMv64Aqx9S3ZHILACrFU1GLmhn6l256w==
X-Gm-Gg: AeBDievYl0dQ22ib169XWgcUTISnmUyodTo6yXWKRvw2W5kK0O4Ztz8phM/4Qu0QC8n
	5l/k/Ylypq9KvdYJDhaMkdPLNmZq585FnwsPJwliwDd2P0BVLL+rgBO67/KCp/RaBRHgeWMQNiE
	fNK5Ntjra0OrP9+jikeP72IIfRbOvlcgau4P89vc6PFQNF2Si4TFb3nSPVsNBbvaSwQiT/ezMa+
	eudYysp1SnthRN9ONdLEOJdW9SffRrosw/iiNApsVIIV6Al71o8UyQbwU8kyHnmzNII7tsFip/J
	JiT+qPgTsubSwBuUYTiZW6OstZ6j+MrPqN99WeujfE0PSVPK+SZnzCwvVyL1vdsEvJH70oVBsYB
	J75wOIf0BIyX985iWphnJVdcKcyY0mGVYMNMuWennI/Gq+E16msEAGqtbNigBs8ApEhcJlrzMrt
	OlSaz81Yiu1Ue/VT2sghIbodBINS2r63d+CNn96O1T3DtjrmlmDS5BvMlb0Qum2cHYIhxycB9sF
	5Opd7xY+r8Yz8HoExC3VVyBBENFp+/hGkznLubrvGRc
X-Received: by 2002:a17:90b:1f89:b0:35b:e5ce:73bb with SMTP id 98e67ed59e1d1-365ab9b7feamr7647323a91.1.1778161506357;
        Thu, 07 May 2026 06:45:06 -0700 (PDT)
Received: from dev-vm-rm.hzz4ddxqtfeetjrh00qlbgyytb.rx.internal.cloudapp.net ([20.197.52.255])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-365b4c8a8e7sm8316609a91.13.2026.05.07.06.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 06:45:05 -0700 (PDT)
From: rajasimandalos@gmail.com
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	pc@manguebit.org,
	sprasad@microsoft.com,
	bharathsm@microsoft.com,
	enzo@kernel.org
Subject: [PATCH v2 4/8] smb: client: sync echo_interval on remount
Date: Thu,  7 May 2026 13:44:44 +0000
Message-ID: <20260507134448.168602-5-rajasimandalos@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260507134448.168602-1-rajasimandalos@gmail.com>
References: <20260507134448.168602-1-rajasimandalos@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Rajasi Mandal <rajasimandal@microsoft.com>

echo_interval is accepted during remount parsing but
server->echo_interval is only set in cifs_get_tcp_session() at
connection setup. A remount with a new echo_interval value silently
has no effect on the echo keepalive timer.

Add echo_interval to smb3_sync_server_opts() under srv_lock so the
new interval is pushed to the live server struct. Reschedule the echo
delayed work via mod_delayed_work() so the new interval takes effect
immediately rather than after the current timer fires.

Signed-off-by: Rajasi Mandal <rajasimandal@microsoft.com>
---
 fs/smb/client/fs_context.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index de682a5d2b68..972d3969f7e7 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1298,9 +1298,9 @@ static void smb3_sync_tcon_opts(struct cifs_sb_info *cifs_sb,
 
 /*
  * Synchronize server-level options that are stored on TCP_Server_Info
- * at mount time.  These fields are consulted at runtime (retry logic)
- * so remount needs to update the live server struct in addition to
- * cifs_sb->ctx.
+ * at mount time.  These fields are consulted at runtime (echo work,
+ * retry logic) so remount needs to update the live server struct in
+ * addition to cifs_sb->ctx.
  */
 static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 {
@@ -1310,7 +1310,13 @@ static void smb3_sync_server_opts(struct cifs_sb_info *cifs_sb)
 	spin_lock(&server->srv_lock);
 	if (ctx->retrans)
 		server->retrans = ctx->retrans;
+	if (ctx->echo_interval)
+		server->echo_interval = ctx->echo_interval * HZ;
 	spin_unlock(&server->srv_lock);
+
+	if (ctx->echo_interval)
+		mod_delayed_work(cifsiod_wq, &server->echo,
+				 server->echo_interval);
 }
 
 static int smb3_reconfigure(struct fs_context *fc)
-- 
2.43.0

