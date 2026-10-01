Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C504BD0EF
	for <linux-cifs@vger.kernel.org>; Thu,  1 Oct 2026 22:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790894305; cv=none; b=oqu3cLKwR2eAL/r0liA6cehtrw6eW+8QALkJLSMQDn90L1BW5X2KcgEYiCV/6YDjPj3Kt0u+eIdAp44KkhYPn8/tsQcBba6VgE15gI7xyqw2xI1NtnNHOWRrsecdSmJtM8HOTyiYd7HXjFESohrqjjWE/Io4RmE9qkQVbeG8gc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790894305; c=relaxed/simple;
	bh=BmDo2NgwTobNw/QxfV/PXlm5U6X+tyxROqDF/lu1Jqc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=NFxDFLy/PkYJkRxy6AX+7uRMEPG4CmICYhqTVBv4cnTZxbWdgORr4jCpMWcDS9KblnHUoEFAB5qyG7ZdJivg+fppsbxX2YOKXZa3k/3zpo0Av/XQ7acJ5QJvDwHn6eshIlD/7a90lqRSsUUXaAV+MIQgklcab2F0MxYffJ3l6es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SVEl+BCm; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=YtYfzpse; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SVEl+BCm";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="YtYfzpse"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790894302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WAQkY/3Hdz9pmH44JOpK4eYwhd5PHEHXQKuWf1a9nS4=;
	b=SVEl+BCmuCHZpmDqMQcbzVswuODc4hAPKAiJbq2XKMyR8RMvyAh3bQQNhvWMILcF3e3Ijt
	2ttyPbPdPhahcjieEi6vabNOT04ljaAbWbzI/A2X733cJp/mN7O70RDyfXz51+27VBCkPL
	mGiul2LFWMBTrZLzgHjxfJ3a+26HLp0=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-2eRS70K6O9yeDPU-n-SFJw-1; Thu, 01 Oct 2026 18:38:21 -0400
X-MC-Unique: 2eRS70K6O9yeDPU-n-SFJw-1
X-Mimecast-MFC-AGG-ID: 2eRS70K6O9yeDPU-n-SFJw_1790894301
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-53397338004so12585361cf.2
        for <linux-cifs@vger.kernel.org>; Thu, 01 Oct 2026 15:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1790894301; x=1791499101; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=WAQkY/3Hdz9pmH44JOpK4eYwhd5PHEHXQKuWf1a9nS4=;
        b=YtYfzpsefa89EfV2TwUMJ+AFG8JZWNUQd2RvXXXIwv1iZuccPv7mrmY9xVt6lfslNV
         MD4i8W+yT+h3d+WU87c7anhGQmXSAliGrnpqpKWyIJe67GAnAkV+1JKn07iBW24+Xr5F
         n+ec5G6HjUXQcXS/Ka9x5XYryCXzp/EmDxe8y6HWOyqP+O+ULJn1MlkCdocDxNXNDBA8
         WU/m6SH4FouiQ5kgh+kUBG4vKP+k5XI7RBSIk4ZVy8k7ga1o7eeOXoxsJvMtmJX3wG4w
         Q0KKZqKYiCgFwPQpEACZ0p69hAJmfef1KV9769C4dbsi+df2biadKy7TdmJdpy37oyTH
         H6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790894301; x=1791499101;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WAQkY/3Hdz9pmH44JOpK4eYwhd5PHEHXQKuWf1a9nS4=;
        b=cXhoiDJOQQUC2v/0hQYBGiQ1zmYRPf/Xgcar/QvSbE/lUP0PgGnAidifJXhFormZ3F
         JR/doQIuprb+4JHBVRoxteoqo+ap4TLe4p5xwhe6G1dypvC6YpAB0QBuWiXf1oD0xBdt
         V4hDhiNRTattf7vkv3cSmpCoPCznVKd/LVrMrMnS8sCTP3BukOg7AtPWbZDQ8ON5kxVt
         mZmfYL7cByk0QCOqxmLu9fCbmSE9+NE6hSLstHlX1WcamYBGraoB9lZvMMCehRMFGdw5
         U57nUGnXWrEDHz0Hld58UwDd0I+GQbytQe6336MbB+NzMaxKCvcQcl43nFBy9u6JqLKP
         pHCg==
X-Gm-Message-State: AFuF++mqTpzaXqB8rc2/W39FdnC9hPDrsefLJGsbanUFzkwL77fNu7pO
	jCiVFmlrNe3iRPPFDv9RINgTGFVKtxoLcA0QB+H1k12335uAY/CVmPwvrTK/yeXVLmeg3I2Lk6Z
	eqyBxNCUP6KDvWg3DtfPLJln5o/yTFYpTG7I2D3mYGSbDdA0jqSJPh1lkW3FEZx08DdEGj2G50h
	nJvMTFJUnUNNiyopxH/A2zlWvmXDPdhEvgYP7VJ78ziFVe11g=
X-Gm-Gg: AYBFou2qpmrMpdMbPAn0V27Ppnr5+8h2QSaATp658/FllQhA/eJqrNI7t4FoN94MSQH
	8vqIFe8jJJvY9ly2v4/iGCubPtXYOuyvhTQwOe4XSXF9hQju+JlM+LSY1o0NTBIeHBlYhXoQpH5
	vnvH3T88CNB5dHrTwzsvJC64GMYbVXgYL0PrbFoKfXYFXoYEs2vfXagYUxG5KoeDZ7b0eVnJu6h
	K32AKA94MxHSyPhZcyP5+aidZ58giCEGni4u87Qdvt9GoC/aL5Xk9qykl6xQrgGtton8AdZsSpt
	+/1gPjmqCLiD9qWL4eGFk+ZWbB5JUlJlwdQTK6wqxVugu4zvcktcBk3GEPslcvmpuKYE/2p9Dlp
	7jDkoMZLW76r1KuZobLneFXFWe/5krmBaIsQw6gascOtWWGxY0BjoLJAcrAY7cJo/zw==
X-Received: by 2002:a05:622a:488d:b0:533:929b:624e with SMTP id d75a77b69052e-533d96a6b22mr11650421cf.59.1790894300666;
        Thu, 01 Oct 2026 15:38:20 -0700 (PDT)
X-Received: by 2002:a05:622a:488d:b0:533:929b:624e with SMTP id d75a77b69052e-533d96a6b22mr11649961cf.59.1790894300099;
        Thu, 01 Oct 2026 15:38:20 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53398a5c46csm9665251cf.10.2026.10.01.15.38.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 15:38:19 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org
Subject: [RFC PATCH] smb: client: fix data races in STATS2 per-command timing fields
Date: Thu,  1 Oct 2026 17:38:14 -0500
Message-ID: <20261001223817.2542012-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KCSAN reports concurrent read/write races on server->time_per_cmd[],
server->slowest_cmd[], and server->fastest_cmd[] inside __release_mid().

These debug counters are updated by every thread completing an smb2
request without holding any lock, which can lead to inaccurate
accumulated totals and min/max values.

Reduce the data races by protecting the statistics updates:
 - Convert time_per_cmd[] to atomic64_t and use atomic64_add().
 - Use try_cmpxchg_relaxed() retry loops to safely update
   slowest_cmd[] and fastest_cmd[]
 - Use WRITE_ONCE() for the initial assignment on first completion,
   accepting the narrow race which might overwrite the very first
   statistic.

Update cifs_stats_proc_show() and cifs_stats_proc_write() to use the
corresponding atomic and READ_ONCE/WRITE_ONCE accessors.

Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
Hi all,

I'm sending this as an RFC because I'd like guidance on the preferred
approach for fixing these STATS2 data races.

This patch fixes the races by using atomic64_t and cmpxchg loops for
higher accuracy of the timing statistics, with a slight overhead
due to the use of another atomic in a hot path.

Obviously, locking is out of the question here, so the alternatives
I see are:

1. accept this patch to prioritize accuracy; the other two counter
   fields in STATS2 are already atomic, so this makes the third
   counter match.  And the try_cmpxchg_relaxed loops for
   slowest_cmd and fastest_cmd should be exercised infrequently, so
   overhead should be minimal.

2. change nothing about the logic, but wrap the existing bare
   assignments in WRITE_ONCE()/READ_ONCE() and accept that
   concurrent updates will sometimes silently clobber each
   other.

Let me know which approach fits best, and I'll submit a formal
v1.

 fs/smb/client/cifs_debug.c | 12 ++++++------
 fs/smb/client/cifsglob.h   |  2 +-
 fs/smb/client/transport.c  | 24 +++++++++++++++++-------
 3 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/smb/client/cifs_debug.c b/fs/smb/client/cifs_debug.c
index 3761d3ad6088..c354a554853a 100644
--- a/fs/smb/client/cifs_debug.c
+++ b/fs/smb/client/cifs_debug.c
@@ -752,9 +752,9 @@ static ssize_t cifs_stats_proc_write(struct file *file,
 			for (i = 0; i < NUMBER_OF_SMB2_COMMANDS; i++) {
 				atomic_set(&server->num_cmds[i], 0);
 				atomic_set(&server->smb2slowcmd[i], 0);
-				server->time_per_cmd[i] = 0;
-				server->slowest_cmd[i] = 0;
-				server->fastest_cmd[i] = 0;
+				atomic64_set(&server->time_per_cmd[i], 0);
+				WRITE_ONCE(server->slowest_cmd[i], 0);
+				WRITE_ONCE(server->fastest_cmd[i], 0);
 			}
 #endif /* CONFIG_CIFS_STATS2 */
 			list_for_each_entry(ses, &server->smb_ses_list, smb_ses_list) {
@@ -826,9 +826,9 @@ static int cifs_stats_proc_show(struct seq_file *m, void *v)
 		for (j = 0; j < NUMBER_OF_SMB2_COMMANDS; j++)
 			seq_printf(m, "  %d\t\t%d\t%llu\t\t%u\t%u\n", j,
 				atomic_read(&server->num_cmds[j]),
-				server->time_per_cmd[j],
-				server->fastest_cmd[j],
-				server->slowest_cmd[j]);
+				(unsigned long long)atomic64_read(&server->time_per_cmd[j]),
+				READ_ONCE(server->fastest_cmd[j]),
+				READ_ONCE(server->slowest_cmd[j]));
 		for (j = 0; j < NUMBER_OF_SMB2_COMMANDS; j++)
 			if (atomic_read(&server->smb2slowcmd[j])) {
 				spin_lock(&server->srv_lock);
diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 5c5b76a9e9fe..96d945627548 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -772,7 +772,7 @@ struct TCP_Server_Info {
 #ifdef CONFIG_CIFS_STATS2
 	atomic_t num_cmds[NUMBER_OF_SMB2_COMMANDS]; /* total requests by cmd */
 	atomic_t smb2slowcmd[NUMBER_OF_SMB2_COMMANDS]; /* count resps > 1 sec */
-	__u64 time_per_cmd[NUMBER_OF_SMB2_COMMANDS]; /* total time per cmd */
+	atomic64_t time_per_cmd[NUMBER_OF_SMB2_COMMANDS]; /* total time per cmd */
 	__u32 slowest_cmd[NUMBER_OF_SMB2_COMMANDS];
 	__u32 fastest_cmd[NUMBER_OF_SMB2_COMMANDS];
 #endif /* STATS2 */
diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 6e21b5f8754a..437fc08dbfb5 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -67,16 +67,26 @@ void __release_mid(struct TCP_Server_Info *server, struct mid_q_entry *midEntry)
 
 	if (smb_cmd < NUMBER_OF_SMB2_COMMANDS) {
 		if (atomic_read(&server->num_cmds[smb_cmd]) == 0) {
-			server->slowest_cmd[smb_cmd] = roundtrip_time;
-			server->fastest_cmd[smb_cmd] = roundtrip_time;
+			/* First completion for this command: initialize min/max. */
+			WRITE_ONCE(server->slowest_cmd[smb_cmd], roundtrip_time);
+			WRITE_ONCE(server->fastest_cmd[smb_cmd], roundtrip_time);
 		} else {
-			if (server->slowest_cmd[smb_cmd] < roundtrip_time)
-				server->slowest_cmd[smb_cmd] = roundtrip_time;
-			else if (server->fastest_cmd[smb_cmd] > roundtrip_time)
-				server->fastest_cmd[smb_cmd] = roundtrip_time;
+			u32 old;
+
+			old = READ_ONCE(server->slowest_cmd[smb_cmd]);
+			while (old < roundtrip_time &&
+			       !try_cmpxchg_relaxed(&server->slowest_cmd[smb_cmd],
+			       &old, roundtrip_time))
+				;
+
+			old = READ_ONCE(server->fastest_cmd[smb_cmd]);
+			while (old > roundtrip_time &&
+			       !try_cmpxchg_relaxed(&server->fastest_cmd[smb_cmd],
+			       &old, roundtrip_time))
+				;
 		}
 		cifs_stats_inc(&server->num_cmds[smb_cmd]);
-		server->time_per_cmd[smb_cmd] += roundtrip_time;
+		atomic64_add(roundtrip_time, &server->time_per_cmd[smb_cmd]);
 	}
 	/*
 	 * commands taking longer than one second (default) can be indications
-- 
2.55.0

