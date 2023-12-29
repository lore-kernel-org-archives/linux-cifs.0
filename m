Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE4510A33
	for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 11:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QOYCzWKj"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-3bbc755167fso1673408b6e.0
        for <linux-cifs@vger.kernel.org>; Fri, 29 Dec 2023 03:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703848589; x=1704453389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0LV4eYf0ibBx+gg21ikm2S5xsE/JkugSj8XVbDVN5E=;
        b=QOYCzWKjGkxMtj3wxiZrv+bOj9yD0SheIhNoKFtYosd7TGhO8ZoCz3tWRfXNmjF9JS
         wX78YSTGV4PVm6mAFWTjOViHaoxCSn9GdPK5nYL3s4vmqSOCoFkGs21Xrmq4ACARxgWL
         /V+nUCXk+xBMhcU/eBl+HP1R2mbJl6OaJLJIVjT9lqoLz3uItms2iDsPa2m5r9IdNx3P
         1GEK2ZlBtio7TCo4Mc4zkOLF5jojxiqzeNg3mYr/4CFcl+gPx2jAROXpt/Iig1DRT0fZ
         +1IeVnN5QvzZYxcdRNo1cBH9aPyri1oWFDGqbOiec927lp5bDykIacM+zG2y3lIfCC6X
         GnVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703848589; x=1704453389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H0LV4eYf0ibBx+gg21ikm2S5xsE/JkugSj8XVbDVN5E=;
        b=LhQA3C2bl0XM7p96X/R7nu3VIPFSgNoqj5FAFI7C53xF++/uzmufHNS70JqQFjPaKD
         5XMelB2zJ1sIXunw3xMoG/o7GPEjYrbcj7DROA52k3rr6IyedYRmGAUoJfDUIZV8DPJF
         bms+HxvKltY53WPbmFF7Qq7Ub8s8GeolU1GKkjjFxR70PysTUcCcJsTU0jAUghVAnbaH
         V6ZnznhYzJDc26aeYvrFYOK3Lm9zeqDHR1vBFiN/IK7lze53AvROV6ye+r8RMeXyap2W
         iqRbKMo3MeMJF7c+iMyGaJs4m8/O2HuSUoxFIQMHFHkfMBwqFvONQwm6Q7tzSE9x350h
         ms+w==
X-Gm-Message-State: AOJu0YybAUlKZXL5sDwtns8UjZyz9XXbgY5Ak1Fp2S+wGBjyGygNtZv1
	jQLl9LrTDAFZ+sWaw+r/aA4=
X-Google-Smtp-Source: AGHT+IGykocyC/wrUoONbHj1/KWRWFUEY1Xs+1Cv9nMTRp6sUfS/8Qsa6T5+MPdXnTzTdwT2pSXKqQ==
X-Received: by 2002:a05:6358:e485:b0:175:17c5:e0e6 with SMTP id by5-20020a056358e48500b0017517c5e0e6mr1674062rwb.61.1703848589380;
        Fri, 29 Dec 2023 03:16:29 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id mf14-20020a17090b184e00b0028ae0184bfasm20347630pjb.49.2023.12.29.03.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Dec 2023 03:16:28 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: smfrench@gmail.com,
	linux-cifs@vger.kernel.org,
	pc@manguebit.com,
	meetakshisetiyaoss@gmail.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/4] cifs: do not depend on release_iface for maintaining iface_list
Date: Fri, 29 Dec 2023 11:16:16 +0000
Message-Id: <20231229111618.38887-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231229111618.38887-1-sprasad@microsoft.com>
References: <20231229111618.38887-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

parse_server_interfaces should be in complete charge of maintaining
the iface_list linked list. Today, iface entries are removed
from the list only when the last refcount is dropped.
i.e. in release_iface. However, this can result in undercounting
of refcount if the server stops advertising interfaces (which
Azure SMB server does).

This change puts parse_server_interfaces in full charge of
maintaining the iface_list. So if an empty list is returned
by the server, the entries in the list will immediately be
removed. This way, a following call to the same function will
not find entries in the list.

Fixes: aa45dadd34e4 ("cifs: change iface_list from array to sorted linked list")
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h |  1 -
 fs/smb/client/smb2ops.c  | 27 +++++++++++++++++----------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index ba80c854c9ca..f840756e0169 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1014,7 +1014,6 @@ release_iface(struct kref *ref)
 	struct cifs_server_iface *iface = container_of(ref,
 						       struct cifs_server_iface,
 						       refcount);
-	list_del_init(&iface->iface_head);
 	kfree(iface);
 }
 
diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 104c58df0368..b813485c0e86 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -595,16 +595,12 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	}
 
 	/*
-	 * Go through iface_list and do kref_put to remove
-	 * any unused ifaces. ifaces in use will be removed
-	 * when the last user calls a kref_put on it
+	 * Go through iface_list and mark them as inactive
 	 */
 	list_for_each_entry_safe(iface, niface, &ses->iface_list,
-				 iface_head) {
+				 iface_head)
 		iface->is_active = 0;
-		kref_put(&iface->refcount, release_iface);
-		ses->iface_count--;
-	}
+
 	spin_unlock(&ses->iface_lock);
 
 	/*
@@ -678,10 +674,7 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 					 iface_head) {
 			ret = iface_cmp(iface, &tmp_iface);
 			if (!ret) {
-				/* just get a ref so that it doesn't get picked/freed */
 				iface->is_active = 1;
-				kref_get(&iface->refcount);
-				ses->iface_count++;
 				spin_unlock(&ses->iface_lock);
 				goto next_iface;
 			} else if (ret < 0) {
@@ -748,6 +741,20 @@ parse_server_interfaces(struct network_interface_info_ioctl_rsp *buf,
 	}
 
 out:
+	/*
+	 * Go through the list again and put the inactive entries
+	 */
+	spin_lock(&ses->iface_lock);
+	list_for_each_entry_safe(iface, niface, &ses->iface_list,
+				 iface_head) {
+		if (!iface->is_active) {
+			list_del(&iface->iface_head);
+			kref_put(&iface->refcount, release_iface);
+			ses->iface_count--;
+		}
+	}
+	spin_unlock(&ses->iface_lock);
+
 	return rc;
 }
 
-- 
2.34.1

