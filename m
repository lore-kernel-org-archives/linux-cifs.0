Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44446ADD;
	Mon,  2 Jun 2025 17:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748884145; cv=none; b=her7Fk4V3AVyMfakt6HNWiDMT9mzCAC+lrBcl6K6MXHg68taXBHKyTJOZvaYQZKvHACcNDUpXCiNVbshepJlgcLg2MuR4bnaSptOJBlR8i8P3oBBwBelXx3d2DZn98vT41mrcl5EMCG7lDZLoCAhTehJM5M28MAIQiVHn3uVAwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748884145; c=relaxed/simple;
	bh=hjkBk3HMiGwwCbb/hmIBEOedCZP4RWeS84JP3EYNaJU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Q8kTN1WskxjTeAhAIenW+dB7ea17q3hnTXU5A1yCflP+EqLXJhzrXWeVkEoWWNfkHcuW1ddzFF4LK829W9hDkS0HuQwAhLUPoMdwROz3TG40lc9sdaORmuP3xD23hBDDdOIPDzxWXm+UIh1p/XeCZ1nqbWLX1uhuS2fdf+jEDD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JI84mQjR; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JI84mQjR"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2351ffb669cso36376215ad.2;
        Mon, 02 Jun 2025 10:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748884143; x=1749488943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gkYA4rHxMq/jjiQgQozusK4XdfpLMf/SmvgSi3FtQ3o=;
        b=JI84mQjRAfycAJtZMFZQknkTmgHiFgLCHR7ouENidC0CsKhTm/xVWcnHpmUKahuR64
         a4C6GVTIrlsGsmNkK2g/4JtJ7IT/V+7csBtDTLUo0x47ZzZZGVuRLmX9/5kFE8adsj+q
         nTUwYHgyXTehJzTi8DMePCcGz1XexOVBd0yjHGQEHbxdAbZE8gpwV8PticSS3NTSpVW5
         AdKvDk9Ou8qxKIf9ucaVfBOqNElc+/lI+i7fiaUjl18SB6Q4qJojKYTNPEAC0HPwovRx
         gOEvD/HN8Z6GDilnn3qC/JEnP9Ylse2JFIIHVt25imtJqf56HbxHCHm7Q+HiPrkv61xY
         EF8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748884143; x=1749488943;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gkYA4rHxMq/jjiQgQozusK4XdfpLMf/SmvgSi3FtQ3o=;
        b=iv3FfR7kkqshO7hs3oJgzXXMFBk5wLZtSwiHHlEMCZl9F/7mWVsKdMZkVKbev3yno2
         sYU6Sa7yJN4BGjwXxEBtNBRaihj5W2PQwhjCVKvxXLI4D1vm2Icm/II4tpv8kQ/Lw0nd
         TYVZm0GYLG6kTu4ygnUU/KZR7N0hVCvBQATb9NviUpLb0tc5FJWhrUQYkGy/4IpoZKXg
         wyRDf8sRuwM7r+QlO8C31CimGDwFvYeGijKGOWwjhn3JGqAB5m2E7vgTwhTaPkCXb0PC
         ROPYGwryuJUCv/zJkaSsMVJqBg2qSdHedLMRkJHf5cJ+rMPvvbF4NINNCRPTiaJ/olW1
         nQzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUImNx+QRf3s8oPssbFxEjkAZtxIAgj0bDLeNFdy4ZDQgoC9qHGzZ7duRX+8HL1yeUGnjas1RQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwP2oHZ6EwY6Xr0vMUavNDu0VJKbxw5Ybhty07Y7vf804gC9FFj
	CNtJHO6b4liCoJkWrtcTHG4C5huCqmZBwgMAqWDR957z32jvO0qzOOMa7HTGyg==
X-Gm-Gg: ASbGncvtsairKlyOiSfyMv9e4QEszdUTwxBnk6Uttd3mR1zrWBQZJ0Q98Nbmqb+U2F/
	lHjYYjNN9Ey4CjG5XtJD14QWQwEUJkoMtZBB3dwNpPzb49IyiVaHrLl4ta0Hk+7FVgugc4YYKN9
	RLBqlVvZzkPzBwR3vT90TRJ1dexALROKSOD9C99uCpoaHku7TIP+KGaAjlTMlcgPoxY52c2LUNs
	R+IGEBec9UVQeXUAd7v/bwoaWCtPjW57V6YVC7flG5ohHvvwJkZfdAff666GLV5iiJKCKX1mAVr
	5TuWsPy2l9O0GzKqd/Vb5NVifOTXuUuX2shF0xV14O5A2U0t4GDSCRhljQecGz5ZNsSB/G5q0z1
	6+K9QvA==
X-Google-Smtp-Source: AGHT+IFg2wRIPNTdCGh2lqiEs6hjTG8115wEG2gPgqQRQLgy3mJMsd1LcMRiPFSfpBA3JPUVg2imRQ==
X-Received: by 2002:a17:903:22c4:b0:220:d257:cdbd with SMTP id d9443c01a7336-2355f783273mr134114445ad.48.1748884142527;
        Mon, 02 Jun 2025 10:09:02 -0700 (PDT)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.136])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2355c58ecd0sm40319625ad.25.2025.06.02.10.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jun 2025 10:09:02 -0700 (PDT)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	bharathsm.hsk@gmail.com,
	meetakshisetiyaoss@gmail.com,
	pc@manguebit.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/6] cifs: deal with the channel loading lag while picking channels
Date: Mon,  2 Jun 2025 22:37:12 +0530
Message-ID: <20250602170842.809099-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

Our current approach to select a channel for sending requests is this:
1. iterate all channels to find the min and max queue depth
2. if min and max are not the same, pick the channel with min depth
3. if min and max are same, round robin, as all channels are equally loaded

The problem with this approach is that there's a lag between selecting
a channel and sending the request (that increases the queue depth on the channel).
While these numbers will eventually catch up, there could be a skew in the
channel usage, depending on the application's I/O parallelism and the server's
speed of handling requests.

With sufficient parallelism, this lag can artificially increase the queue depth,
thereby impacting the performance negatively.

This change will change the step 1 above to start the iteration from the last
selected channel. This is to reduce the skew in channel usage even in the presence
of this lag.

Fixes: ea90708d3cf3 ("cifs: use the least loaded channel for sending requests")
Cc: <stable@vger.kernel.org>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/transport.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/transport.c b/fs/smb/client/transport.c
index 266af17aa7d9..191783f553ce 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1018,14 +1018,16 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 	uint index = 0;
 	unsigned int min_in_flight = UINT_MAX, max_in_flight = 0;
 	struct TCP_Server_Info *server = NULL;
-	int i;
+	int i, start, cur;
 
 	if (!ses)
 		return NULL;
 
 	spin_lock(&ses->chan_lock);
+	start = atomic_inc_return(&ses->chan_seq);
 	for (i = 0; i < ses->chan_count; i++) {
-		server = ses->chans[i].server;
+		cur = (start + i) % ses->chan_count;
+		server = ses->chans[cur].server;
 		if (!server || server->terminate)
 			continue;
 
@@ -1042,17 +1044,15 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
 		 */
 		if (server->in_flight < min_in_flight) {
 			min_in_flight = server->in_flight;
-			index = i;
+			index = cur;
 		}
 		if (server->in_flight > max_in_flight)
 			max_in_flight = server->in_flight;
 	}
 
 	/* if all channels are equally loaded, fall back to round-robin */
-	if (min_in_flight == max_in_flight) {
-		index = (uint)atomic_inc_return(&ses->chan_seq);
-		index %= ses->chan_count;
-	}
+	if (min_in_flight == max_in_flight)
+		index = (uint)start % ses->chan_count;
 
 	server = ses->chans[index].server;
 	spin_unlock(&ses->chan_lock);
-- 
2.43.0

