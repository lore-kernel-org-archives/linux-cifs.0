Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A02B11FF1C8;
	Wed, 12 Feb 2025 07:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739345709; cv=none; b=t5JO5hceY21ILLYk0vZcQzHRrdgK95sktXHLTpdPV5f2i06th5wL0nJHYwo8R4StNlzFDJENePKohdzj4hW+XjlrJo/vJpemHBSsy8gwLsOsX0z4KdhBPPgCxtOQyKCgmd7faIDYiT29dX6aBvVxuzJVP0Wt9FqHrj6sHCYF3JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739345709; c=relaxed/simple;
	bh=vzAYFgD6NsPtoPoanmFtwkOgtB83JG3kaQy+7FvwREk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tdr35Z+SyIsdK32/cdKuWiyPxPu95wa5qdFReXu20964fS2lUZ+oi2V9W+WRzLSueMyrExD/U+EpliOH80aK6aGIz9I06Pu+sSbaHI3VCoeHf94Jo+BNjjtNuUktrsNR4b1LMqZhUGehz8o1UlhWnKAaGwbN5oxbs2sucnDk9ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RCYqwWQ8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RCYqwWQ8"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fbf77b2b64so871132a91.2;
        Tue, 11 Feb 2025 23:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739345706; x=1739950506; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=55MQT8EffuBkX0+zq144/b95PKg1mZ4gkJfdfqwu5qA=;
        b=RCYqwWQ8GMzu3k1ptD9mPxmvHgqBj5AmWoMcVBEEFuj1MzM/CQcqVcIVJ1Svgjfqgj
         oDc5N4I6vQYdFbqamLDsji0AZWn6saVL4PfQx1GLIu6NOeGrDuYu5sIMvn1v6EuEASFI
         Nqe7m6nWoFyMxgRg1RXD8kHNMByWX8wu8WGTInGttdOP7FRhaDUSwYEeYd6MlF8nL09w
         gA97LDHSfT+YdD6Po6pfemJGj/tD7WO8GzYfgWs3rXXufAGkCumqbwgtSmNyURNwQoTz
         G6vaL2E81VGMHRQfSHA1rKMHTdGgdSiQlQ0B/4FElquYSqPXJTwpKQr49r6Hr/5v+NlS
         y5+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739345706; x=1739950506;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55MQT8EffuBkX0+zq144/b95PKg1mZ4gkJfdfqwu5qA=;
        b=VW/5sNCGf/DU+xfvalVUK5TDeBzDbsOIm+RIFEH4VZqdwzBTiOrdzcgp7TgVTEe+ME
         tq3USM8Ga8Z5lPIuotv+3DwfDbquid/THPKK1AYr7ymysBljkuinakXThGavUv7z/13i
         FVh8Pj33s9RIH6QvybRj/w9Gm8801a11bEye3QUJhDxw/BhRIT3SxC3W/HG+2kpxePgz
         rN4ZDtLOylm348sYr+9LXYx7VmWpFcZO6jeaXCxS3VqzGOi52m1a1s56Ds9H0F6bha0u
         faBVNy54b6srD/rccPfJt9VwB+OfIgOCAu56NsX4741L+DkXdzq+2SqEi1V4oeLocb8K
         DX6g==
X-Forwarded-Encrypted: i=1; AJvYcCV4yhgHrqIZhGau35IVAsnpVTat2ffwu19d/BNnN6lZXRywgBqQ6IW5uTtmfs59lZZZk01187c=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMT49NdA5FGLvR2DNPIzRj0svrkQe6CyxNRfguEIzXlsBwfXA9
	77N+GJUdvAbRHW5FsTbt/iJXiPdDKrRAv321NH1yDvCf1hJOzT4DUe/prXeI
X-Gm-Gg: ASbGncvWGrCI6yqG21zzbTFDRMkdcqR+k1BzBjqF/QBmeeZp/pcSxQPJCxmiMTG00PR
	SUXlt/NNSflHuM6Akf8g3vXZROXbrm0uNEzMQAnPoNF2NM4XcoBoh3OdeD2naJkuNb0tVfzR54/
	Bzy3FZHqGoZhTlc11qhIWk9lw524J2BMDZAvCTXAsHq9lwDehXaBofCRdWJcKefeg87wdJh2f42
	Ygb6nmGNEocZb0UaX5W6TjsvN7UMNwddl+dIvUPC93+YQXrSFDfDX/bpYhdE/TN/Iyh/VHsoDAf
	iWWsCkw0sx1dqBtUCcyn/prj4y55IjwWXdV0DM/ruVlXvt49ZSetZg==
X-Google-Smtp-Source: AGHT+IFKh3ZqNVRzGTbQ7qYPkmNpUAXO/KlxJwa21Zg54QcVSt7HzrYyauglTnv0Np9RgQtl5B/qfg==
X-Received: by 2002:a17:90a:fc4c:b0:2ee:48bf:7dc9 with SMTP id 98e67ed59e1d1-2fbf5c1bfc6mr3596216a91.15.1739345706358;
        Tue, 11 Feb 2025 23:35:06 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2fbf989bdcfsm789978a91.3.2025.02.11.23.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 23:35:05 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	stable@vger.kernel.org
Subject: [PATCH 2/2] cifs: deal with the channel loading lag while picking channels
Date: Wed, 12 Feb 2025 07:33:43 +0000
Message-ID: <20250212073440.12538-1-sprasad@microsoft.com>
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
index 0dc80959ce48..e2fbf8b18eb2 100644
--- a/fs/smb/client/transport.c
+++ b/fs/smb/client/transport.c
@@ -1015,14 +1015,16 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
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
 
@@ -1039,17 +1041,15 @@ struct TCP_Server_Info *cifs_pick_channel(struct cifs_ses *ses)
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

