Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.231.138
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793113490;
	b=MncTFv8JHf3in8EznyJf0rngLWYBbowksQBVKzmBEkWiQS8K6k9BOPQJhA2PbpYhyWYg
	 43pi8oDvcwQQn1N3STYCKXVjwsDW7HjgIqKPsE9C1Hl3Tj58aoiTxwTec8vkDiAo0N2ck
	 82nUIdVUxwqLDfOJ/TnJyjrkcyO87ARQKksvIZHykB8MNwlHISUy39d4dIPCvY6A2TYru
	 COD1tf+TXF8oVI5YFToyCq02z7CctOLnje8i2Cs2fD4Zrovc3fx2RbFcpqBS7UobJtDxw
	 Yys4l/CyDIYrvra/cploPMf8v+EScsvkAA+BosSoVVQofbW7MssSmBFzvO/zLqs/0bQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793113490;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=idHmBdkYB+pGsb4ciFoRZd8OmfSYmN5C47UdDtDs8Ag=;
	b=0WFLKQ1G9sZzMT8/Vhjdv6KxgnD58YNoksznEkRzzAk2PYjR362wHrzsICrr4mLw0E0w
	 cSJK0JoYafx/rLfXwy+Fcj9LQwDdr11mCSIr0UoMXLcXvAQhFRdUTV1tqSaH56utb24i3
	 pLkDVfvKCx1ec5FwNw9jzMMJ+arXGXgRSqMxR/vw+UTpOcd4AKXVekIhMnqwj0B9AX5ND
	 URc8NaXmUk64iS6hR8Fn3wjcuWTni7fnNRAdv68fyivuXbWF2ZpWcn61DRCQYGVvmRTG1
	 d/hMHDJp0rXmGYwlWGc1jvaGdi6PlxxzhV66ECB/sD8O887JyMwbGEOlD0zdzyFuM1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wPJeWiS1;
	arc=none smtp.remote-ip=74.125.231.138
Received: from mail-oo2-f10.google.com (mail-oo2-f10.google.com [74.125.231.138])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D284E606A324
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 15:04:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D284E606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wPJeWiS1
Received: by mail-oo2-f10.google.com with SMTP id 006d021491bc7-6dd3bb640bcso5318eaf.0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 08:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793113489; x=1793718289; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=idHmBdkYB+pGsb4ciFoRZd8OmfSYmN5C47UdDtDs8Ag=;
        b=wPJeWiS1MqHh+MC1Qy4nsxftqxqYus959w86RlVdZQnsO5f5oh1Py4MCQS/18WhtEd
         0MyW9N/02eePu25tCo/xRE/CKd78CcLihtAzPuMGwG5GTLd2t5bpA3h11IW/lPy3mIok
         AqBcOAXdYKTnTQkFd6jmRfHcFBFnAYfyz1gl6d0E7WYXm5n/xunyXalOQ6FYQS98UWnO
         aT0ZHLIpjdUJyZiH1YGBU6YQqFiS+j1LkfpeG9eec/AXG4PX0J0CTwIFJOdgCHcRozvm
         eoHb0vjgdD4ez2rpVTE4jYD1L0OJhJeHM8XY5ixHC5hFR/zlYMlD8GO7fImsjk/R69ez
         bONA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793113489; x=1793718289;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=idHmBdkYB+pGsb4ciFoRZd8OmfSYmN5C47UdDtDs8Ag=;
        b=oOtTdLBH2pbUdBKo4EZisoYsl44AwvPAizXYUop9ENFSlxkJRY1bZBcxB8rwpeA8y+
         fM+krOtvfKdhdB05DU9U2umhnFZiVVkfLBeaHZM7K6mQ12bgtL0iqsKSGq1pNbs8jH1V
         0WfvngGSP0BzMjJuzUgLHVvUyb+r/yvYkgN56yyVu7GoRwi9EX7xPKm/Eq+IupslRWtK
         adg36NHaz+enxicUdwbGgOkhbAqzAjsXRANoLWrlUOdGn+xoQzjT+GqOKdcV7ttCLAHp
         mSbX2oLMpJZpQx0nnKA1eANlktS2qqlIFkSukM6fij3sqZGYWDIg6hQVxJBj7w/DH+Ew
         Mlcw==
X-Gm-Message-State: AFq9FYL5XhKoXllHJWnwtT3T6densY3AEK/H4viRPquHNwRt6v4oAjUS
	sexKCaUSqd7+S9pAGOlfAhQ9JGYu3CUJPQbEzbky6YfeNxFeG2aMH8ei
X-Gm-Gg: AYBFou0vZ+U3JrtG3oHHJdeibIVwhkmgkpplJ6ezWBigKpxcr5lll4Ew9thq9KnZwXy
	Ufjfvi61pktezhRFBB92PhNKZ3i4fmXmZRb8Dv2O/fnCQ+WgHBW8mYJWWO0qppUs0B7b779ENiw
	oeSeWFZgwCHHHQCXBBHbddHO5aQh79TDmLPyVFlNiZ7BJBcJ6UycqrZfTSpeQkoRrTWon3bmiAS
	Rll/3m71L6eYktNmMOagGlWqzdSZIykvqN7gBIg3RQfAdb8qYkNMsq+skMBu5aQEoWpyXMx45e3
	FJTDIZCoanN6bPlMQ3yLIVOgkGHSeO9Pz3VnXdql9hG4gunjrccm3bmo4n+66G1A+P6d3WjhnE5
	2Z/HTvV40uIDPSpRD9KUK+IKlgQq35jwwy0Aoaf0svHQZFlD3ZxGJIGSPSitHiiPYxxZdRqdzal
	Ndd/DVZ3MMW+hS/aUpTSTM/dFuUDl6XZ9PfDoGMhvE40R+pcviBxvjRNfkb2oIDqNEbKrbvcxyv
	ObGIv2hrk4N7EW+C4ZhrH7Tq61r4adV5r1dxuRiGCPHkRIU0BznQXQNPoC9guZ+QOiNtUgnLu4v
	tVIh8jLtrKplwJqztA==
X-Received: by 2002:a05:6820:1625:b0:6b4:117e:545 with SMTP id 006d021491bc7-71269638a81mr1504369eaf.13.1793113488681;
        Tue, 27 Oct 2026 08:04:48 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.180])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-71278c864b0sm2824416eaf.9.2026.10.27.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 08:04:47 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: fix UAF read of server->hostname in cifs_get_spnego_key()
Date: Tue, 27 Oct 2026 23:04:38 +0800
Message-ID: <20261027150438.943354-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
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

cifs_get_spnego_key() reads server->hostname without holding
server->srv_lock (fs/smb/client/cifs_spnego.c):

    const char *hostname = server->hostname;
    ...
    desc_len = ... + strlen(hostname) + ...
    ...
    dp += sprintf(dp, "ver=0x%x;host=%s;", ..., hostname);

while the DFS failover path frees and replaces the hostname under
srv_lock (__reconnect_target_locked(), fs/smb/client/connect.c):

    spin_lock(&server->srv_lock);
    kfree(server->hostname);
    server->hostname = hostname;
    spin_unlock(&server->srv_lock);

The read side runs on the kerberos auth path without the lock, so the
strlen() and the sprintf() can race with the free.

Take a stable copy of the hostname under srv_lock at function entry,
before any use.

This issue was discovered by Tencent CodeBuddy Security.

Fixes: 93d5cb517db3 ("cifs: Add support for failover in cifs_reconnect()")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 fs/smb/client/cifs_spnego.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/smb/client/cifs_spnego.c b/fs/smb/client/cifs_spnego.c
index 44c4072756804..488ddf6df138d 100644
--- a/fs/smb/client/cifs_spnego.c
+++ b/fs/smb/client/cifs_spnego.c
@@ -105,7 +105,15 @@ cifs_get_spnego_key(struct cifs_ses *sesInfo,
 	char *description, *dp;
 	size_t desc_len;
 	struct key *spnego_key;
-	const char *hostname = server->hostname;
+	char hostname[CIFS_NI_MAXHOST + 1];
+
+	/* hostname is replaced under srv_lock by the DFS failover path
+	 * (kfree + new assignment); take a stable copy while holding the
+	 * lock so strlen()/sprintf() below cannot race with the free.
+	 */
+	spin_lock(&server->srv_lock);
+	strscpy(hostname, server->hostname, sizeof(hostname));
+	spin_unlock(&server->srv_lock);
 
 	/* length of fields (with semicolons): ver=0xyz ip4=ipaddress
 	   host=hostname sec=mechanism uid=0xFF user=username */
-- 
2.43.7
