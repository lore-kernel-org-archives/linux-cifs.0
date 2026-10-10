Received: from mail-oo2-f2.google.com (mail-oo2-f2.google.com [74.125.231.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAD63C457A
	for <linux-cifs@vger.kernel.org>; Sat, 10 Oct 2026 03:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791602950; cv=none; b=CCjHimSUNtSWR9ZYMAIJWAG1Q2fTGRYAJ1OvYM6AJGllqrHkN4mldex6E2au9xwvk7iJ3mZ9mP7oC+sd83ixKQ4SAgea3Id0296v0GLFGmAxqKerjYhNRILrx1IcMFpI9ElLBULXxefIjwy8u/tRO3d5+rD4XqfoFFn/9sCZbtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791602950; c=relaxed/simple;
	bh=1F+ODfj/fPtcpQE0Ju7toxstfzOPE2wYAET+FlLXBeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIsXv18MlNXboh/tNopGUPiKn+oNMxa6cx8Fr5Ap5oVhfeiIkTZzfJRDr1WX+eq1vVryZkkH+DHTpj/uSmTwDGo1kDf70WYqPYqmkQ0F8IHSjlVNkMOJ68iNi1WtN1B7Le7mJm9TZT/IaBt6q5/Nf/grfji7Gie6KvqUTsqdjnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OP+iuttV; arc=none smtp.client-ip=74.125.231.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OP+iuttV"
Received: by mail-oo2-f2.google.com with SMTP id 46e09a7af769-824fdec5521so254369a34.0
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 20:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791602946; x=1792207746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5P6AqSi4Tu9XFQnnSQSZLDRVBLeY7WQtLDJjSdDz4pc=;
        b=OP+iuttVX0Gigmp9WSxbad0F4zoX49RVksufOYCmHBlT9hNQ+HO8CSZdEYQSdBBvXL
         yqTjfcfyQIfzCIqmxfATHe0cevqg2W2UHB5llZyiNn9D7ySOqTLE/FryA8j4a3ZuDlDw
         JB6bATq6p4k+qrtuMpW9jIbJRvRjDv4UqG3JYG6eXNfFicB+Hlu6ku3ItO+Un8SR3nc2
         G+JNYCSOoRqECcIItIctVhrUYGIcNEfagcZTWjcA6DynLCOyb6kfaRiW8pPxOAX3A2q+
         3AZgXP7Z1J6kODF4i1WH+JTf8zptHPqnkqq0vKCrIXmCHXb3S9lRulbGre5Mqs/+ql6D
         zfUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791602946; x=1792207746;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5P6AqSi4Tu9XFQnnSQSZLDRVBLeY7WQtLDJjSdDz4pc=;
        b=aIaXTVTgxc7sN/tJQxsx0yRKttDLIabguCD2B4AQrRk2d3ThDUzuwfrp2dM69/7VgS
         W2A4vVBjz6oRFvZZOOv+TGMhNYCaUN5AklqgQmTHzvrhCy/YH6L4li0yaawtIIwNdGG8
         99RD28tU3pGSAq4t1kKyyhqj7vaL86XyxL+qoUA16JsY7fLwbEfPF45DEGZTowaefWkg
         w+0GQUy4dWtqbDgPEeBDPpmH3br6gAEe5Gjh9MookkAdbWl3k/CQZnqbCHb1Dj7/E20L
         OlXpn2JzSVVyc2aQPtvarElpR/CG6K1bjvQwYcAk7QhBkefrrWGanmzif+S7qVHHvEJI
         uUtg==
X-Gm-Message-State: AFq9FYKpwrfHICFDyC6nDxEpgEvOJ0wkdCRDWANrMSeB/FWwGWBU2Jfc
	4Mq1sjMmj7yh0fd6lD3QVjJrvYs9K41PU6BIx5R+CWwbGW2ONvCKpLRt
X-Gm-Gg: AYBFou15DD1qsnO15gMKLXBoDF6f1UoVZLwKhf6KfSpBGYnlQ8l8FeBcsbCEXWkVrXG
	N7qzzT0eDI2ChQcqjOFVgOyKgSWGBbEAWQN+m3nlMwt3oDTH+0vgAMr9OIgE4tfxMMuUbv2s3LP
	A75B8YdZfIqFDQEro1Fhy0JeZBFUHDkcpi2Wr/9x4PMrfSqGS8b4KOvwKzbOxsCPeMYDedw4a4S
	LApKsI/iuZWnK5W+WsSMs7GbygBb1z3Xv5paI6UNrOnACs5/U2qNLqF6pugqI8nZNH/QRnR2OI3
	Xt9JG4G8j5GH70hbGLls8n7ZFaj76UXs5BYvUqOjY6RvQaASaJwhcRNQ9XRZFhmb+p6D9b0NWUH
	XFbAK6anNk3iQPG4zwqeKIxi+p776c8FvSUJ41/x8+m8OdseKqgdpuHK+z6iCZLZTFgYVqLJ0sO
	ur7AnnpgXhL/Tjut6caeXg6LLRwctw5eUQwNckeqdaCxBWGtvOyDeA5m2Y16e7Yoc0teDXaO+sg
	+j85FOnPRSOwwG6eOm5bdFBCBL6NaCaa1w5yA==
X-Received: by 2002:a05:6830:44a3:b0:821:d65d:37c1 with SMTP id 46e09a7af769-830970aa285mr2951273a34.25.1791602946374;
        Fri, 09 Oct 2026 20:29:06 -0700 (PDT)
Received: from localhost.localdomain ([117.88.121.67])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-8303494f64csm3594198a34.3.2026.10.09.20.29.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 20:29:04 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] cifs: fix use-after-free of server info on cifs_ses_add_channel error
Date: Sat, 10 Oct 2026 11:28:56 +0800
Message-ID: <20261010032856.1880706-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <CAKYAXd8MyiCVhdN_PaQ=aSEO3yYYQ-Qb-2TnC68o0_pbchM0mw@mail.gmail.com>
References: <CAKYAXd8MyiCVhdN_PaQ=aSEO3yYYQ-Qb-2TnC68o0_pbchM0mw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The error path of cifs_ses_add_channel() calls cifs_put_tcp_session()
before cifs_chan_clear_need_reconnect().  The latter reaches
cifs_ses_get_chan_index(), which dereferences server->terminate; if
the put was the final reference, TCP_Server_Info is already freed and
this is a use-after-free.  Same put-then-use pattern as the recently
fixed sibling in commit 717e0a25036b ("cifs: Fix server use-after-free
in cifs_chan_skip_or_disable()").

Move the put last, but do not read chan->server after dropping
chan_lock: chan points into ses->chans[], and once chan_count is
decremented a concurrent add_channel can reuse the slot and overwrite
the pointer, so the put would act on the new channel's server.  Cache
the pointer under chan_lock, clear the reconnect bit and decrement
chan_count while still holding the reference, and release it after
the unlock.

This issue was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: ee1d21794e55a ("cifs: handle when server stops supporting multichannel")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---

v2: Cache chan->server in a local under chan_lock and use the cached
    pointer for cifs_put_tcp_session(); the slot can be reused by a
    concurrent add once chan_count is decremented.

 fs/smb/client/sess.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index e095f41b58828..ba0b4057322c8 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -626,12 +626,19 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 
 out:
 	if (rc && chan->server) {
-		cifs_put_tcp_session(chan->server, 0);
+		struct TCP_Server_Info *pserver;
 
 		spin_lock(&ses->chan_lock);
 
+		/*
+		 * Cache the server pointer while holding chan_lock: once
+		 * chan_count is decremented below, this slot can be reused
+		 * by a concurrent add_channel and chan->server overwritten.
+		 */
+		pserver = chan->server;
+
 		/* we rely on all bits beyond chan_count to be clear */
-		cifs_chan_clear_need_reconnect(ses, chan->server);
+		cifs_chan_clear_need_reconnect(ses, pserver);
 		ses->chan_count--;
 		/*
 		 * chan_count should never reach 0 as at least the primary
@@ -639,6 +646,8 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
+
+		cifs_put_tcp_session(pserver, 0);
 	}
 
 	kfree(ctx->UNC);
-- 
2.43.7
