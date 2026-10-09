Received: from mail-oo2-f2.google.com (mail-oo2-f2.google.com [74.125.231.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6201D457E5D
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 08:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791532986; cv=none; b=SdVV2ENPXZc6zqUu4phALD81RBO3ZfkRrlnNyXfzIPFN3EFxuXqCNOVbDzg21d38i4ODlmdbX9N2s0rRJoc4+BE1dMUztijrwhEck4gfzposJn1QdNdIQaRoh0NVVcOk9GCDKD0sMHnn4oBW9dQQhZ0mdm7x3fKhEng9zFVNSIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791532986; c=relaxed/simple;
	bh=PNIWbf1MaE9ijfXHPhmWrJ+aqZsWffS2Dcf0qEM2kxk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=udinxK4UjMYDcvsYFUpkRCCi8HIfqtR1sbblgBJQVsqnaqDTKEdG34L6isDH74Xo6gFeGkLUu/ZCFSwEGLgUn3kFI/CQrYNilKd/QCVu+mErgZxtFqciF+Uia3Jk67eHYjc9z2NDiMIxSqwir7Uuzi+wdh9VkHnC4sTOpTnDfHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j6a09IS7; arc=none smtp.client-ip=74.125.231.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j6a09IS7"
Received: by mail-oo2-f2.google.com with SMTP id 46e09a7af769-824f3901d55so2216474a34.1
        for <linux-cifs@vger.kernel.org>; Fri, 09 Oct 2026 01:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791532983; x=1792137783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=abrjBZtqWK4ithY2rB/XsxNJwm1DdDO75e5ZEpU8VL4=;
        b=j6a09IS7hRbMC4+xv+vZkh4RTWexSe62b1qUFs/0A0aiDSlyo3BOckmG6b1rDruCN9
         2hoBArsVve4vTsWRwqxo4cgSXnbIZSUGzbYkOuLS8KUinGmIeyDyCh0nj5kE6Wrn0ePH
         6tqc7Ku6lYw32sNyd0wrlcbSo0HaUT61e3DThbvc5pV8EkDBSts9eu3ooH/D89JZIUOz
         AJmls8mcKJuSm2ge/YBvJp4kr21IU8H3zUimLKMOhQJAXRMuvBEXgH/1PtwuHKpKHFDd
         igIQeK+W+YCSY7q3k/vxYsN4mslcp00QmpYTBek9iBJxPLkyF4DEq9CospV0BXDW3+rr
         qQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791532983; x=1792137783;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=abrjBZtqWK4ithY2rB/XsxNJwm1DdDO75e5ZEpU8VL4=;
        b=r3G0l/fy0QB8JT+k6PI1gHk5vALITU+UHjdE0VzkMtWBlzE6lG2N9vZVcSOtyS9KM1
         7cWGaI/M/76jM2fgSyV22PA+SofzgvwA3W6+KBF4kJ4NHXdIg+djWgsPBwN5ZwFXHA07
         YtkUp+HJW0I+hBbofE5junpqP5s+cFUnZcvfMzmADs4USXk2obq3PP6ASUf3cM9pgVz0
         DoSrOfSnLFakNyqjhTRg50jnMqDKSrSWh25JmT5fSPSko2Q2HLKo9io/BfRMyMBdz72l
         lNaMU8fuf68PeAcA9mKBGUv0wuNpyDw3lGU7avRUfV8/h+M3sTn52ULLoSE4/R8EIRRQ
         /n9w==
X-Gm-Message-State: AFuF++nuZwrS6IPh++6vWTaxY00SJQgVuHMUcTMy2M5CubAnr5iT8GZa
	LgRmAIcGMXKuenSefW8Yfo8A470dgB/wjZNTDKehXx8Xgnjz7zqVUcbp
X-Gm-Gg: AYBFou1/mElquIr04XNh5xuxkw3N27IRbCHxZY+qN4GYyF95iA5lvzCHyW4MFUQzn+8
	A/vloIqsyUgSAMrpo8xMN+O8pFmiEAp3Ijwy/V/T9Biq2uwGR2y4L2A0c/VtEJWrXk9Jm/mMlAQ
	WD/wDMperIrqLlOB++4TroEIyuw83jPCq3yYKtnTFDlUhI91QV0xAM6OmF6GWMj2jYdMix27FKF
	YIy+2WpwZjd0zC26nw+Uu4TYj1H98Q8Od1NHAXMVPyVGW54DDeZ58IVC9xJ9FlTbtEclSxvU+g4
	8pjkEQR32y1kARR8MtfvTT1QpasGe1krUtsBDoQQpEpXwcKxlSSGMg3v+8b064nZsDlHaV5zZ4s
	hJs/CyTmdTm3crnIyXs7yGJygbfAtmy50pmbberXqQBUircZu7aEsZSDl4KKjxoqhROxksbJaOK
	/obXSeHohT55VXTNsxUcSW43SiSVKI0gv3yRIqDWT5HdCQhIEbcyn4dHRbAHB1CntUID4/psg3m
	dt61RvYurGNY/wVI0ghSjj8oPOaVjlkVXbG
X-Received: by 2002:a05:6830:449f:b0:816:a9dc:6d05 with SMTP id 46e09a7af769-83090b2e4b5mr856599a34.4.1791532983102;
        Fri, 09 Oct 2026 01:03:03 -0700 (PDT)
Received: from localhost.localdomain ([14.22.11.166])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-83039d385dcsm1199706a34.21.2026.10.09.01.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 01:03:00 -0700 (PDT)
From: Henry Martin <bsdhenrymartin@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Henry Martin <bsdhenrymartin@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] cifs: fix use-after-free of server info on cifs_ses_add_channel error
Date: Fri,  9 Oct 2026 16:02:52 +0800
Message-ID: <20261009080252.2805877-1-bsdhenrymartin@gmail.com>
X-Mailer: git-send-email 2.43.7
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
fixed sibling in commit 717e0a25036b6.

Reorder: clear the reconnect bit and drop chan_count under chan_lock
first, release the server reference last.

This vulnerability was discovered by Tencent CodeBuddy Security.

Cc: stable@vger.kernel.org
Fixes: ee1d21794e55a ("cifs: handle when server stops supporting multichannel")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
---
 fs/smb/client/sess.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index e095f41b5882..650c0f855a29 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -626,12 +626,16 @@ cifs_ses_add_channel(struct cifs_ses *ses,

 out:
 	if (rc && chan->server) {
-		cifs_put_tcp_session(chan->server, 0);
-
 		spin_lock(&ses->chan_lock);

-		/* we rely on all bits beyond chan_count to be clear */
+		/* Clear the reconnect bitmask BEFORE dropping the server
+		 * reference: cifs_ses_get_chan_index() dereferences
+		 * server->terminate, and cifs_put_tcp_session() may be the
+		 * final put that frees chan->server (use-after-free).
+		 */
 		cifs_chan_clear_need_reconnect(ses, chan->server);
+
+		/* we rely on all bits beyond chan_count to be clear */
 		ses->chan_count--;
 		/*
 		 * chan_count should never reach 0 as at least the primary
@@ -639,6 +643,8 @@ cifs_ses_add_channel(struct cifs_ses *ses,
 		 */
 		WARN_ON(ses->chan_count < 1);
 		spin_unlock(&ses->chan_lock);
+
+		cifs_put_tcp_session(chan->server, 0);
 	}

 	kfree(ctx->UNC);
--
2.43.7

