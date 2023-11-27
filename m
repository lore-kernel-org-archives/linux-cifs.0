Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L2DpjAf1"
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002EA11B
	for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:23 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ce3084c2d1so30583855ad.3
        for <linux-cifs@vger.kernel.org>; Sun, 26 Nov 2023 20:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701060743; x=1701665543; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NocJAL7bmIl27EF1+A+zU1qQfSSMxXoshK+2TFsCp7c=;
        b=L2DpjAf1gzSwPjk85Gj30UVv/d+EMflsBqnGnylPefBQzqUNbNZVM6hDqn20CDQaYd
         iPPjdx0uGPUm2VwTBVmGjS46FABqa1vh9BktpLqe3kWkIfRufblZMsNRVYoBobz5+Se4
         SJZ+uTrEJjht48hRCroHCymtjfyy8+Z1m/QxsNvBIYy9kXfiSQbk4pcqx/XZ2bp47Twv
         LrfL/8k3tCH8mIYZ2bHiWCdNpO1AESLnPzjzRUfWlFTXPMxwNekTOAm7KvIUeqkENdvn
         sAKDoBuc3r+V22QxddQZOzQLqaJN3o+dDkaw6VmcXg2kScQFs0Y8Gvxk52tA8h0K3tDl
         2XFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701060743; x=1701665543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NocJAL7bmIl27EF1+A+zU1qQfSSMxXoshK+2TFsCp7c=;
        b=eKtiAV9YXWf4tYdTT4oGepnHUz3IOVDErQj354pF2RRZMrqhXL7F6EO0sWkofsjFGJ
         4iFrhmSgBSmhpRpQSt/rZLsL6SHSk9G1k1FqzWRe+mFGni4wNrudXW+gT7WS6/OzSpEx
         RvNJPXKWIyquWoBxO3HaMMGpMO5zsakC4cF7ZFctAWPyC2QjjhpVzxWdshRTnItXLnZU
         HyrCGLaofaMEr3Y2NJOiim8yiih8EeyJXTMjWUofta6O2bXmV+BlXByhFBKXaQhScCFd
         9bdLQFiHhIob3K1N1SXdCl+FkyMSLTwpsk/AsHaQBB2gMs+YlbDR2q+vo9xKTGL0FFIH
         yEbw==
X-Gm-Message-State: AOJu0YydjWtBj6IbL3gnaqR3dVUnnjU1jwPLzBKxCnBQdrgPzZ5E2Ui9
	GQqiL+ipp98oTRFt8IOdxvA8V8vtIrk=
X-Google-Smtp-Source: AGHT+IH9bDZ6m6cyZgED8BiulGW8GR3Wf3MQbptXoQICRCKr4fzd+gGlUhIxTd/TjOtv5vDElMLj+w==
X-Received: by 2002:a17:903:32c8:b0:1cc:3544:ea41 with SMTP id i8-20020a17090332c800b001cc3544ea41mr14200595plr.46.1701060743303;
        Sun, 26 Nov 2023 20:52:23 -0800 (PST)
Received: from debian (c-73-109-30-110.hsd1.wa.comcast.net. [73.109.30.110])
        by smtp.gmail.com with ESMTPSA id i1-20020a170902c28100b001c739768214sm7294306pld.92.2023.11.26.20.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Nov 2023 20:52:23 -0800 (PST)
Date: Sun, 26 Nov 2023 20:52:21 -0800
From: Pierre Mariani <pierre.mariani@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com, pierre.mariani@gmail.com
Subject: [PATCH 2/4] smb: client: Protect ses->chans update with chan_lock
 spin lock
Message-ID: <234ee19f9706fa55af3bae3e339e39c42d5b0b0a.1701060106.git.pierre.mariani@gmail.com>
References: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9f9f617abc69d0a7ddb3109bc257073c8b165de.1701060106.git.pierre.mariani@gmail.com>

Protect the update of ses->chans with chan_lock spin lock as per documentation
from cifsglob.h.
Fixes Coverity 1561738.

Signed-off-by: Pierre Mariani <pierre.mariani@gmail.com>
---
 fs/smb/client/connect.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 449d56802692..0512835f399c 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2055,6 +2055,7 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* close any extra channels */
+	spin_lock(&ses->chan_lock);
 	for (i = 1; i < ses->chan_count; i++) {
 		if (ses->chans[i].iface) {
 			kref_put(&ses->chans[i].iface->refcount, release_iface);
@@ -2063,11 +2064,14 @@ void __cifs_put_smb_ses(struct cifs_ses *ses)
 		cifs_put_tcp_session(ses->chans[i].server, 0);
 		ses->chans[i].server = NULL;
 	}
+	spin_unlock(&ses->chan_lock);
 
 	/* we now account for primary channel in iface->refcount */
 	if (ses->chans[0].iface) {
 		kref_put(&ses->chans[0].iface->refcount, release_iface);
+		spin_lock(&ses->chan_lock);
 		ses->chans[0].server = NULL;
+		spin_unlock(&ses->chan_lock);
 	}
 
 	sesInfoFree(ses);
-- 
2.39.2

