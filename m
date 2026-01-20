Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A3B36C0AC
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768890131; cv=none; b=tyqkj4B8dVL77prPxVwUYtfZ2Re+ijmsE/JEKfqfSyIyQSsOI110hhGDa2ACz6HubNysYNyEqGH+oVuuOuE5/dt20Cvmge/s3gzUuQeq2LOuFzDM8RZTMSncVBbSkwiWNuwSiuYgJ4dVigor0I5AcCLEhaMnWjvbfNXe/j7qPuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768890131; c=relaxed/simple;
	bh=HXgh91TckTtaWRQtCBliw0DRm62hUVsJoLGoBTGStPA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eSVRYTGNRET/YIKNGvn+QjJ4mrtYPw1SmXQ3dTEkc2D7zaVGi6k5rV/woHA9RxEc7NinDkfsTYjxBY8xXlbHEFfW32ExwfzTeWwLr0j3k8NfcZ7pqjtRZCukYC/unozpFFbqF5h8dNlgJb17743g5AJj/cZxEPPHvOMLcE0sXIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0DdUgeX; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0DdUgeX"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a09757004cso44641555ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 19 Jan 2026 22:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768890128; x=1769494928; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6EKchlZhWxO3Iv5CDV1JWVC2GKSqiNAkqsBWADytBNE=;
        b=F0DdUgeXTNEJLv8wFfn0gZF3AfdG24tJeaqTNk380WANf9GqWzhV84Xw2KgK3okkwg
         UniAdQktgETAF0l5IT6BpDHX0u1qyEGkq4mfPC3NDO1jXbAw5Ozg3mvfomul2zc8xb+F
         ep4o5mS/o3oORwpk9lWPxCYklziEwe4kAILtTQG1+qt0UBX9gl89dz+ENhbH+wq2Fg4R
         Qv8+34/dtdlyqb+wRSK7TaJOL0nCf536R8lm8MOcw7PCa0qYmEyaEj2yocXsnPEd/152
         zevgGBZL22JU+/Bvb8LxlTALtuhvoLhIdz9TgqQ1BSqjaUCwXa+a5fWAWwcHhXNwMXA5
         RCLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768890128; x=1769494928;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6EKchlZhWxO3Iv5CDV1JWVC2GKSqiNAkqsBWADytBNE=;
        b=NegYXw/fTeG5i/Ju/yTnpl8yqjNTS2J7vMKq79n7CnfqLAT6w+pxoR/IYkdfNrsnPu
         kVXS/nA2iz9RiSpvqc2COCIylkT0bP3ESDJaJq/uIU7EqhbwgPH5uGNOUSPZ92yhHV5u
         GrZNxwwfRjR51R6snuBh5dBQ+oi6DigfB68ua2TZpln/HPtqADVCCxkafQiLfIozdVu+
         7OuA1xb6djG9kyMB93AMx/9SD+wVHUdS8/bOIs/tAa4Gpx1UedJsPLZTJE8Q8zylV6uL
         L4uPywUdJ9KII3zR5wxZ2wSM6SI/xsHlQ9EA0jKhUOE7qXUfv15l8LhCijeAo7ulQl16
         AiBg==
X-Gm-Message-State: AOJu0YyqJhYpPwT2TtMfiXfezhTd6CBCmAv4Uj/Kr6EKS+uvHWjaiw5Q
	nVfar/JxSR89SS8ggrZfy31+aahuR9FHEl0ZLUQjbkEheP1gFQYqC/Jl+/SMsA==
X-Gm-Gg: AZuq6aLxjmm0uxC3YpHWVtHkPD5Ce6E0YL2M7O7a5bE1U8s5Gc5uVarUpyA1eeQTWv0
	kHi5UswIAvYdTpQpoFJcKX/TqkpAmSED5vKfu/QaNIeUPgDcgHlLVevifYssYVX3qZ0CO8M6UXX
	9QVjZ4BbbQn7ct+Z9NjuJKFy9y7NDR83LzWJBL7XcF6c6MIhBdutxZxwE1XNlZcNMvrOyn0QKsO
	crFO5DjDAyn+xnNrXrngIIaEpvqitZq5gRnIPH8ZOot2ZA+uGoGobo/16VyDaSmhSCIqeTkLGRD
	KOEQZinN3NInCnSbMmbgTSizUJZM8Zetdk3E5QpPDhXcZTAEHKeJmQxHiRo9r1z1O/OGZTCNCH6
	mfhOtzwysQPVQQgKmLHGS67rtE6rtXRk5VnL8qB7kHFWhPw/SPWjent4VPZpKRb1yv5kdr2cJot
	LRbxTN8lzz9UXi3HT2+/OTsmPzDuf8rc/vttEay+QX
X-Received: by 2002:a17:903:384f:b0:2a0:a484:6b87 with SMTP id d9443c01a7336-2a7175be723mr148911325ad.47.1768890127776;
        Mon, 19 Jan 2026 22:22:07 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.152])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a7193dd523sm112497855ad.62.2026.01.19.22.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 22:22:07 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.com,
	bharathsm@microsoft.com,
	dhowells@redhat.com
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/4] netfs: when subreq is marked for retry, do not check if it faced an error
Date: Tue, 20 Jan 2026 11:51:34 +0530
Message-ID: <20260120062152.628822-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

The *_subreq_terminated functions today only process the NEED_RETRY
flag when the subreq was successful or failed with EAGAIN error.
However, there could be other retriable errors for network filesystems.

Avoid this by processing the NEED_RETRY irrespective of the error
code faced by the subreq. If it was specifically marked for retry,
the error code must not matter.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/netfs/read_collect.c  | 6 ++++--
 fs/netfs/read_retry.c    | 4 ++--
 fs/netfs/write_collect.c | 8 ++++----
 fs/netfs/write_issue.c   | 1 +
 4 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index a95e7aadafd07..743830a149bb6 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -547,13 +547,15 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 	}
 
 	if (unlikely(subreq->error < 0)) {
-		trace_netfs_failure(rreq, subreq, subreq->error, netfs_fail_read);
 		if (subreq->source == NETFS_READ_FROM_CACHE) {
 			netfs_stat(&netfs_n_rh_read_failed);
 			__set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 		} else {
 			netfs_stat(&netfs_n_rh_download_failed);
-			__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+			if (!test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
+				__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+				trace_netfs_failure(rreq, subreq, subreq->error, netfs_fail_read);
+			}
 		}
 		trace_netfs_rreq(rreq, netfs_rreq_trace_set_pause);
 		set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
diff --git a/fs/netfs/read_retry.c b/fs/netfs/read_retry.c
index b99e84a8170af..7793ba5e3e8fc 100644
--- a/fs/netfs/read_retry.c
+++ b/fs/netfs/read_retry.c
@@ -12,6 +12,7 @@
 static void netfs_reissue_read(struct netfs_io_request *rreq,
 			       struct netfs_io_subrequest *subreq)
 {
+	subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_rh_retry_read_subreq);
@@ -242,8 +243,7 @@ static void netfs_retry_read_subrequests(struct netfs_io_request *rreq)
 	subreq = list_next_entry(subreq, rreq_link);
 abandon:
 	list_for_each_entry_from(subreq, &stream->subrequests, rreq_link) {
-		if (!subreq->error &&
-		    !test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
+		if (!test_bit(NETFS_SREQ_FAILED, &subreq->flags) &&
 		    !test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags))
 			continue;
 		subreq->error = -ENOMEM;
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index cbf3d9194c7bf..61eab34ea67ef 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -492,11 +492,11 @@ void netfs_write_subrequest_terminated(void *_op, ssize_t transferred_or_error)
 
 	if (IS_ERR_VALUE(transferred_or_error)) {
 		subreq->error = transferred_or_error;
-		if (subreq->error == -EAGAIN)
-			set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
-		else
+		/* if need retry is set, error should not matter */
+		if (!test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
 			set_bit(NETFS_SREQ_FAILED, &subreq->flags);
-		trace_netfs_failure(wreq, subreq, transferred_or_error, netfs_fail_write);
+			trace_netfs_failure(wreq, subreq, transferred_or_error, netfs_fail_write);
+		}
 
 		switch (subreq->source) {
 		case NETFS_WRITE_TO_CACHE:
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index dd8743bc8d7fe..34894da5a23ec 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -250,6 +250,7 @@ void netfs_reissue_write(struct netfs_io_stream *stream,
 	iov_iter_truncate(&subreq->io_iter, size);
 
 	subreq->retry_count++;
+	subreq->error = 0;
 	__clear_bit(NETFS_SREQ_MADE_PROGRESS, &subreq->flags);
 	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
 	netfs_stat(&netfs_n_wh_retry_write_subreq);
-- 
2.43.0

