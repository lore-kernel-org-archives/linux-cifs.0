Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792552500;
	b=JmO8XGIc4ckLoIACmqWkhiuPTQUIVxUUoTH4vy/GsDwceg6hPdgcDRtNzoA2ZfYY0oe8
	 Mw0pOcKfb7VLKm+RQYJg/k9+Lwz/StDU6QX7g8nuKGOw7wUXD3Z+479Fr+zzDN6zaY/rr
	 h+OE7b/sZuxaGVpgzuVinXNeRiSCBtu0muO1yymlD2m2FtOxtSlW9rodvqzQ0WsTZLf/d
	 /8rJP1ekDw3ipvnuPDTygBnk195DY3qVrD05zCm+gEkS4x/Vy2W/CTqupM5OCmTOUJbfP
	 sRUkD5EFQNUFxHIfrNOhqfiTGEK5fpkpRQ5jU+7k07xOb8lmfuY2Io7moh9AStCrq1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792552500;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/bSH53ZPdeNmRLC3k3UiHTNJS9LnNbRPqJimLIl6vZU=;
	b=bzH12O24gMAyyWtDqCz6OlJlUnJUP5CCxCi1T5x/jHumk0TLA7U4Hn+hmw/1B3nKQ+AQ
	 hDDDcJuBVBey7P3ugNisC50dCjVl124VXjediGke6bQBBJmkqKvgokPP4Qk83clbSQCQ9
	 CHU/KEPh7upKX5kO/nfdNHvSsRH0N5ksS0aDVgwgGWkj33m4XbMHmw56GxBfKw4cMmVj6
	 tpYUNuzd3NyGeLfSwWRD+5GiDH3t9IW7534QKsioA5N3Vg41xuaA7uAYu+vUj3wJRrI6v
	 LSFmaAI8ARqaZxR4bN4fC1ATp/iaAPUMXO0dDIv9KkNLb+CrD5GqOwlsy1LyUL5jW9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=flXwLEcC;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=DNvirZpN;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199EA606A319
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 03:14:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 199EA606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=flXwLEcC;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=DNvirZpN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792552499;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/bSH53ZPdeNmRLC3k3UiHTNJS9LnNbRPqJimLIl6vZU=;
	b=flXwLEcCni/Jg5FBOCi/6mTMja1pVUPBsim0+effQv1R2foBnwEriG0PwM+pUcQr1R/1W6
	84/+A9QlCk49m/RRPfZAfvqgWWcwr1OarkuFfHfRdRIN0ucmmFGdC3e7Qlwx3iCKz+Y6sW
	7XEbk5c2cNX6kIwhqR8BUZOLPwMgK80=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-QsFl3if1MoiUKuH3wyFr7g-1; Wed, 21 Oct 2026 03:14:57 +0000
X-MC-Unique: QsFl3if1MoiUKuH3wyFr7g-1
X-Mimecast-MFC-AGG-ID: QsFl3if1MoiUKuH3wyFr7g_1792552497
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-91c046843f1so10876826d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 20:14:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792552497; x=1793157297; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/bSH53ZPdeNmRLC3k3UiHTNJS9LnNbRPqJimLIl6vZU=;
        b=DNvirZpNDxhdTioRqRlp+D02uoJoK5Y4QPo7Cy/dQHagMyTP3rNH6kTWrTrcvl5wmm
         VAElEUr+MNjT5VyYq+0tAu8VFOOJT2ADEPuoMzF2V+HxdxPvQHCKrYENl26ukTp0yN6S
         42BWZOYbkf/ZP5S5fkc/KfYa6ISM24feFKOIfl+1D5TCThWoAbpx2BjpRKjL+6W/UHGT
         fooa/9BZNo9wK/aMHoObLL08cBbLrfVVjvnFjKdhcCjmpHsXXwr0chb7lLlrwIy7/t/Q
         ybO8+v+5MPJL4samiCj7rrwHoDNcip4phluNDRpnPMg6gdGUUw2I0tYjL4SnYCgjke+F
         HIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792552497; x=1793157297;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/bSH53ZPdeNmRLC3k3UiHTNJS9LnNbRPqJimLIl6vZU=;
        b=iqcrEI4R4CYB7gzstQ2fNap/A6nrxFIgNyPVadyNslhTxPhrnm0xcONSryLYj8nSJ+
         2p+iHyp+Z4IreVkXDeWrKnFFiugkiXM5YhUFi+6cNNXI4iU2PViPewLBryDE82af2OeQ
         8Pvh3pNIdrxxzpEYxUCwxJtX3GuvwqS8DqgvS5huWljPP2Zj93/A4pbsPTDFUQpK34of
         IN2qM4zT0J6GX7+HKl1lKeo/Q2pwOV7tFmMDYMx5Z+zjshH3wcFIJmRrzu0dMCN6P/cZ
         n/jUJ26niois23yj6Svuet05MuTzNaUpG57FElaWpAsPsgZbXH8ZmTtqOlipj1LWFGEb
         miwA==
X-Gm-Message-State: AFq9FYK6p/mpWlAIa/H5eT+0Ze8J66pPwBQ+8wjzAYNoShVVoGVvcEyx
	Xh6vP6HdR631eO6wQqtBLFOEJunWDX60rfAqi+pj8cj4Ddv4N5vG5cuLYpJR049Yj6Ci5lvk7uV
	YixBc2kueFTvrzZjcjsq2jJCiyGFNnIxx1MobUoNgBcruHJPL4gagyQmzB44RtIdMi8dQL6ulXF
	LwAixKHFYCKUFPdvVXwoKyt3oReMvFyK1eSUyItevdY/VHw0U=
X-Gm-Gg: AYBFou0dgdY+X6Hxw3s3ece9rS3FGS5KEDVsBEqz6KtI9/kgChDfmvBomXzS8bYshHs
	VJtMgg44kr/nefQrmImcUSB73OrKWxgZVHMXNHu+CjBZVi9TQrmYm926E85HjyyBmth2+SETHMM
	/xQX6U825WNWorzv+V42xDgk3TfCM0uynA32wdml10ea2UOfQJjtk+xy2ddWMrtO0DIt4Y1oOkh
	TxcTihZ4uEzNYx6QV9ftVXcsMpG6bitw8z/+0DVDNRpjCVrG99AzsVPlT0iSgva7OsA1TzaH2fd
	eDBRhNfE4dEH169nayyqDkNWl7fhxwY5U7/DrcnSD+rMqOSSW/ltRTVCRRCdWloRJaVKDia2fkI
	weDfo8tEPAOfq9IWCKK12U1qPyrJ8cqOPjIHFLBSvrdHBHUn0mCzvUGwaBhaYdOet
X-Received: by 2002:a05:620a:7086:b0:93e:6325:ae6d with SMTP id af79cd13be357-93f57f1cc44mr229803585a.40.1792552497061;
        Tue, 20 Oct 2026 20:14:57 -0700 (PDT)
X-Received: by 2002:a05:620a:7086:b0:93e:6325:ae6d with SMTP id af79cd13be357-93f57f1cc44mr229801485a.40.1792552496465;
        Tue, 20 Oct 2026 20:14:56 -0700 (PDT)
Received: from bearskin.echidna-sunfish.ts.net (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f56c70057sm144496485a.5.2026.10.20.20.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 20:14:56 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	pc@manguebit.org
Cc: linkinjeon@kernel.org
Subject: [PATCH] smb: client: fix data races in STATS2 per-command timing fields
Date: Tue, 20 Oct 2026 22:14:43 -0500
Message-ID: <20261021031451.3376404-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
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
Link: https://lore.kernel.org/linux-cifs/20261001223817.2542012-1-sorenson@redhat.com
---

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

