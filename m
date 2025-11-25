Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50913332918
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 18:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764095646; cv=none; b=YHBoWxAkgAz9Kv54Gjyf5E9JQIt8P7qU07WA3uvsmTo+NOYYbq69o0cUWR4K7/mGleX+LXIPlytYt72woDMcLmdg6BqzHCennsYaj1i/aZxSkzQl/lhDGU/CKWBn9sWaaEM3hHp4PEmvDFrRHnpa/TbpGY5bONtNTmBSWHjyZD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764095646; c=relaxed/simple;
	bh=vV+TSWcCoLRLmi1SOIpW/EmBjqs95sehIEGHkLsnbO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjucK9TBdqNZEHljIJJ8+wDZ5iX5gEYxAU52ym1WAxLuzB4FEKTX+4ULOAZw48WkVcJJDk7CzkRc3udqjyS4BejQwrjNuGgYahZc/qgm9MFLwpOVhmaUnP9s91vRsumf9Xbxyq0M6zINfwdYsrqb7Aw8EmTZLcGxfexas0FXNuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=iZNDqMm7; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="iZNDqMm7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Date:Cc:To:From;
	bh=4RrLk4/r5FwWAwcAKY5N3aQMPt4sxOW3Rzkozzubnj0=; b=iZNDqMm7A03+VwOhTeW5q7xqvn
	cQ911DOCD0EwppTQjM12u1YmcA1a2b6CDAJNxW1e2BTJK2ppgOB7Pp8Nq5cFjPEYSO6UD7hEDSt0r
	APDU5lLIaEP3UpFU82ZlkTRlfwlb/HYEUcEsCcq0uPoBZavuEtxczDD0h+8TpBj4zkxIwJnktsk4x
	cBSHyRHsmGeMmk7RYGvwOW10lm7dAKmMoYn7yAp9E9t6Ab+RONlpsZXvEOI0Uks+CpHGtwjnZQDem
	Lh7/oF+iBSjQQce+TUdwQ3yaMFoRH+FJ4ImEMMzpi8BXcVwbsn6LDltWAuCdXWGAjUGlaceNpnx43
	hd9Ubs5qq0VuKmhbspEoRUtx/nAG4KGe40IT7g01nc1acQm2rCBAR2ITYuXpWoBtujuO8nr2hCw+/
	iWlnbqf3HyeCkVlY/PMgDDlhQ3ge2f6nspJ2k5LDKpTgVYU9CtsQeH6a75zetfFYdT9irA5LXKsVN
	7OTpz97nNE7M9gJyCxq5oxM1;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1vNxnk-00FgFO-35;
	Tue, 25 Nov 2025 18:30:09 +0000
From: Stefan Metzmacher <metze@samba.org>
To: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Cc: metze@samba.org,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>
Subject: [PATCH v4 144/145] smb: server: remove unused ksmbd_transport_ops.prepare()
Date: Tue, 25 Nov 2025 18:56:30 +0100
Message-ID: <aa3dc5a8bebb0aac5e97eac6192cd55636c1c701.1764091285.git.metze@samba.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764091285.git.metze@samba.org>
References: <cover.1764091285.git.metze@samba.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is no longer needed for smbdirect.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 fs/smb/server/connection.c | 4 ----
 fs/smb/server/connection.h | 1 -
 2 files changed, 5 deletions(-)

diff --git a/fs/smb/server/connection.c b/fs/smb/server/connection.c
index 66d6dab66ebe..71e2f522b05a 100644
--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -317,9 +317,6 @@ int ksmbd_conn_handler_loop(void *p)
 	mutex_init(&conn->srv_mutex);
 	__module_get(THIS_MODULE);
 
-	if (t->ops->prepare && t->ops->prepare(t))
-		goto out;
-
 	max_req = server_conf.max_inflight_req;
 	conn->last_active = jiffies;
 	set_freezable();
@@ -411,7 +408,6 @@ int ksmbd_conn_handler_loop(void *p)
 		}
 	}
 
-out:
 	ksmbd_conn_set_releasing(conn);
 	/* Wait till all reference dropped to the Server object*/
 	ksmbd_debug(CONN, "Wait for all pending requests(%d)\n", atomic_read(&conn->r_count));
diff --git a/fs/smb/server/connection.h b/fs/smb/server/connection.h
index 7f9bcd9817b5..784208d22c53 100644
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -126,7 +126,6 @@ struct ksmbd_conn_ops {
 };
 
 struct ksmbd_transport_ops {
-	int (*prepare)(struct ksmbd_transport *t);
 	void (*disconnect)(struct ksmbd_transport *t);
 	void (*shutdown)(struct ksmbd_transport *t);
 	int (*read)(struct ksmbd_transport *t, char *buf,
-- 
2.43.0

