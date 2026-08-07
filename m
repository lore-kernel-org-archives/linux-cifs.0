Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DEC358360
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 02:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786070540; cv=none; b=EsJVcwhe77VxR1WJLW8Yqt31Z/saHSM6hzIoTEbts7qGIWkPcFPjdWFVdvBX7lVcOtKl1m4aATBMr3FRXCryyBBU5QQ0QcuZJsLxJBl+k5D7qOVlpbppq6U0gMludrq3kGTmzNI8/1r4eXXMXTAFHKh/EZfeoMNnnSBSFfNTHuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786070540; c=relaxed/simple;
	bh=uRqs+fCNOX42TFHl6VqCCHziTcP9wg4pqWDHQ6U1648=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7+SHQiSyELvAnL1PtKGZZlzkM5byELmXHU6iRd3Nlii3yvdnhWpUq+22Ma7Kng4VGUy9uhq4fy0qjFGs7RNSXIkQsSJZkSyoXxOVrWe2pdm8diSwalvFO79ri6N5JppLOpIJyoEYsJKtJLm0Ab8+l3AY2myS1mBYs5bcZn/2F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JX1szP86; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=CX3tM9c6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JX1szP86";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="CX3tM9c6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786070538;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vwq7i/Gf17j5EKYufvi5JRhEhyqFtE6xGkW/b2fLbSc=;
	b=JX1szP867QfPrqerVKt7Ru1zYlmSvNIW4n0ZnWhnF464+jWov/oNGIiJqSfpcr1KZ29ydL
	IzJ4Vi8N9y3dV56rjw6ilubY37YM64/o4T3P60wMrBOpbogbPXlZa/FXfzqecj9FLRqKUd
	5d5m0Yoqb8ibc+lsQiZ/Drptz2pWEtw=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-594-KJao4yadM4284i9Ar5u9nw-1; Thu, 06 Aug 2026 22:42:07 -0400
X-MC-Unique: KJao4yadM4284i9Ar5u9nw-1
X-Mimecast-MFC-AGG-ID: KJao4yadM4284i9Ar5u9nw_1786070526
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7eb6a8c61deso1872432a34.3
        for <linux-cifs@vger.kernel.org>; Thu, 06 Aug 2026 19:42:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786070526; x=1786675326; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vwq7i/Gf17j5EKYufvi5JRhEhyqFtE6xGkW/b2fLbSc=;
        b=CX3tM9c6r5QYV75JdwVWVe7j7FGmd1BSe43INjXASgjZIRzcfRcPkbtcb77UVrNYoB
         VgitxKIKTSGGQNGsfNy3jIFK1eZ1SI9+N+EDAmmYt9sdcWkrfXyYroN5cPnC7W/+pAjL
         sSqAV9xI2l9DMZBhhZyyposqTBkeVjakOBgTbjotVk3BHC2jAXZHZd5eDPq89OtxjgQN
         GMiH18vufdrzIefAlY4O+fhtGsjMvu8NYdwPOa6zu1t+QKap7jbt7GYD7rkvwxrMNgnL
         GXskZt8AkXvF/Iye8wAdO6zpeoNLug/qXVmMkt0cuXNnPMx9Y3I7t3hmi4Pr3OpIRKLm
         9GYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786070526; x=1786675326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Vwq7i/Gf17j5EKYufvi5JRhEhyqFtE6xGkW/b2fLbSc=;
        b=Ix3oHDE/Kp0mXgzq5+k+N3aHScoGBQoFAxbxTEFcJIBbvO3WJCMhDImlcaY7JCi/uh
         qAfJH9GDieVgojDizua4abSx9KctDljLQN7ZF5g/woKugIZGwzzHkTG46lQ5/ezikMhb
         hIzH8XhRSk/0FJd9SqJPC8SJFbj5Xi3Jt+pfAfGhjFiwV5de4L4FHyqzRU5vF3HrAjaT
         z6UT0zcEPNFSOxCyWIqlT+MPtpDr9fLqRGa3iVH+bnfVDquh+NLxiOkupKbrUL3vZJTz
         6wfHIqngylOk/rBf6uCiQY9rn58sWWDTM172cKkf8asukSqrEAisDP9zXQFlN9C155wI
         K6ow==
X-Gm-Message-State: AOJu0YydXeNo0FO08JhUEg98o0k0JxZXHsvsdaN0x64WnYzujkHjhXbC
	apPtlBDKg4P/Zu6TphlruFk38NUBgfhWo0+2Gqweh7PVheAVOpy7zSOfwWZn4txVB9gfNltHxSN
	2FObRyecyZ6Q8CIO7MC6kcHTFLYHd0X2X4Y+QDyj6nC13nL+9YHTwpp8pH1+JdXfuTSqL8CbmWs
	3E48ixi56lecCIvkTHZzPVQyQ/q1sWqhF2OnU52467LXDPo7Y=
X-Gm-Gg: AR+sD11E6YKBCUB1TeDSlE0PZA+Qo2+qB5WNeEbhHOdlnoMIT1InzS+XdQQaDmZwli0
	qE6QwjUurCwmoYglwGV2uT15jlrsLHi7MwnQTZUvxk9ZFu2gbemLik/8mU++ZRmzQOVNWY+/0aO
	zNASx8j4W8BxYorZwnBle3qHMiYU2vNmOk5zL28B9d3Ltjvmrv+PPrL88gyW9tWKkdEuO/KtfEG
	4n+F8DAWXuzSbzNWB6Zo7iluR61VUUbrggOVUP49TCNZVU+hcO68HqXjYgAVurmw6NS9A2KUaAZ
	a5f8fiiqHebTcaPLaNE6pEKFQRbbfCvGY0tsHUXK+wYUooJpZxENCQSimwnJgzXgbE6bPSfVb/I
	FwtlonHyJwoTjxaZ2K+V4wcOdFgzCiWQMgRcAp0YRJmcmO7xLiiRX7Nz3czKO0msijw==
X-Received: by 2002:a05:6830:2aab:b0:7e6:e8cd:bb7e with SMTP id 46e09a7af769-7f1e5c9972dmr11886038a34.4.1786070526281;
        Thu, 06 Aug 2026 19:42:06 -0700 (PDT)
X-Received: by 2002:a05:6830:2aab:b0:7e6:e8cd:bb7e with SMTP id 46e09a7af769-7f1e5c9972dmr11886007a34.4.1786070525796;
        Thu, 06 Aug 2026 19:42:05 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b563887sm356182a34.3.2026.08.06.19.42.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 19:42:02 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com,
	pc@manguebit.org
Cc: stable@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH v2 2/3] cifs: don't update i_size in cifs_do_truncate() without a cached handle
Date: Thu,  6 Aug 2026 21:41:57 -0500
Message-ID: <20260807024158.3707995-3-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807024158.3707995-1-sorenson@redhat.com>
References: <20260807024158.3707995-1-sorenson@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When cifs_do_truncate() is called from cifs_open() for an O_TRUNC open
and find_writable_file() returns NULL (no cached writable handle),
cifs_file_flush() returns 0 without sending a server set_file_size
request.  The outer "if (!rc)" block then falls through unconditionally
to cifs_setsize(), setting the local inode size to 0 even though the
server has not yet been told to truncate the file.

If the subsequent network open in cifs_open() fails (e.g.
STATUS_ACCESS_DENIED from cifs_nt_open()), the caller receives an error
but the local inode remains at size 0 while the server file is still at
its original size.

When cfile is NULL, the O_TRUNC flag in the subsequent cifs_open()
request tells the server to truncate; i_size is updated from the open
response.  Move the size update inside the "if (cfile)" arm so that it
only runs when the server has been explicitly told to truncate, and call
cifs_invalidate_cache() in the no-handle case to flush stale pages
before the open is sent.

Fixes: 110fee6b9bb5 ("smb: client: fix missing timestamp updates with O_TRUNC")
Cc: stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/file.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index ac89c1ba56b1..92af1782bd73 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1012,10 +1012,19 @@ static int cifs_do_truncate(const unsigned int xid, struct dentry *dentry)
 			server = tcon->ses->server;
 			rc = server->ops->set_file_size(xid, tcon,
 							cfile, 0, false);
-		}
-		if (!rc) {
-			netfs_resize_file(&cinode->netfs, 0, true);
-			cifs_setsize(inode, 0);
+			if (!rc) {
+				netfs_resize_file(&cinode->netfs, 0, true);
+				cifs_setsize(inode, 0);
+			}
+		} else {
+			/*
+			 * No cached handle; the server truncates as part of the
+			 * O_TRUNC open request that follows.  Invalidate stale
+			 * pages now so they are not written back after the
+			 * truncation; i_size is updated from the server's open
+			 * response.
+			 */
+			cifs_invalidate_cache(inode, 0);
 		}
 	}
 	if (cfile)
-- 
2.55.0

