Received: from n169-110.mail.139.com (n169-110.mail.139.com [120.232.169.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9BEB665;
	Fri, 27 Feb 2026 03:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=120.232.169.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772162169; cv=none; b=oFEm6jxAq7mcGtRNEPmiBYcUfWJZQ/A/X62KcJF2Q8eLPzxWlLz7pmMenIsIUMrW+LRhZdL4SCazdWkKkqSeM1g/1URpwZUJ2oOBhflIeyV1wL1gVI55dEN+rtLLLMp8gLkdJw20b1kNMTveXkz9sit1EA6kguAjSFbyFu0MXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772162169; c=relaxed/simple;
	bh=PSRmzzLqVPUD9zU1BFy85CDWL9+pYdv0nott+E8XKbA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oebiksVIp2ZAlDTB3Dnm/2rYqTwWcqNpV233KQ9BLklnSBZXgZI9e3rTzF/Ne9RszCmzneLBAmPuvDylF04CV+zlXSu7h/eJN18R7bil1J7k1xsac4I5jkQ3RJbcfTM2998OfAAgqe31VzXPcPaFXpkC3zvqFztiMzUjAfeCM64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com; spf=pass smtp.mailfrom=139.com; dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b=mW4LBVCV; arc=none smtp.client-ip=120.232.169.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=139.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=139.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=139.com header.i=@139.com header.b="mW4LBVCV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=139.com; s=dkim; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=mW4LBVCVHaZsREkJFQ//iAwcYRCE57kC6LPSVXdb3XVZFOPgJH15Li/5Hcgvft7bYfw5A2QGfLp4a
	 lwkgv33DrayM/y2dkYMbGzJQA/5mAvmYkkg5BlurLrwWd+fpjFRIFUIu8mu4n4VmrBUEeqYCeSm2Nx
	 I2nqe/bNKQf+RQBU=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM:                                                                                        
X-RM-SPAM-FLAG:00000000
Received:from NTT-kernel-dev (unknown[60.247.85.88])
	by rmsmtp-lg-appmail-03-12081 (RichMail) with SMTP id 2f3169a10c708e7-008f3;
	Fri, 27 Feb 2026 11:16:02 +0800 (CST)
X-RM-TRANSID:2f3169a10c708e7-008f3
From: Li hongliang <1468888505@139.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	linkinjeon@kernel.org
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	roger.andersen@protonmail.com,
	spolu@dust.tt,
	stfrench@microsoft.com,
	senozhatsky@chromium.org,
	sfrench@samba.org,
	hyc.lee@gmail.com,
	sashal@kernel.org,
	linux-cifs@vger.kernel.org
Subject: [PATCH 5.15.y] ksmbd: Fix refcount leak when invalid session is found on session lookup
Date: Fri, 27 Feb 2026 11:16:01 +0800
Message-Id: <20260227031601.1548925-1-1468888505@139.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit cafb57f7bdd57abba87725eb4e82bbdca4959644 ]

When a session is found but its state is not SMB2_SESSION_VALID, It
indicates that no valid session was found, but it is missing to decrement
the reference count acquired by the session lookup, which results in
a reference count leak. This patch fixes the issue by explicitly calling
ksmbd_user_session_put to release the reference to the session.

Cc: stable@vger.kernel.org
Reported-by: Alexandre <roger.andersen@protonmail.com>
Reported-by: Stanislas Polu <spolu@dust.tt>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Li hongliang <1468888505@139.com>
---
 fs/ksmbd/mgmt/user_session.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/mgmt/user_session.c b/fs/ksmbd/mgmt/user_session.c
index f59714bfc819..8bd18610547d 100644
--- a/fs/ksmbd/mgmt/user_session.c
+++ b/fs/ksmbd/mgmt/user_session.c
@@ -302,8 +302,10 @@ struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 	sess = ksmbd_session_lookup(conn, id);
 	if (!sess && conn->binding)
 		sess = ksmbd_session_lookup_slowpath(id);
-	if (sess && sess->state != SMB2_SESSION_VALID)
+	if (sess && sess->state != SMB2_SESSION_VALID) {
+		ksmbd_user_session_put(sess);
 		sess = NULL;
+	}
 	return sess;
 }
 
-- 
2.34.1


