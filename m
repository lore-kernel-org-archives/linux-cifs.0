Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0053321CA0D
	for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 17:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769708275; cv=none; b=A1+1nQyNqB3+qnnedsieAbJe7J3QeW4+04+OrTDqk3qrhiOhA60nMAFjShy6THeHq647JijHHKaBdXp3n2A29aqlFAyHn6achEDM5Rix/vc3Sz/RAMHhBcs9blp3yW45AmvjhDWJgKuTaWjpWI7pZPtQChVnAzYFzt+9F93+Do0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769708275; c=relaxed/simple;
	bh=gGboFYBJHGwbQ6CmsqonPgIpA+0UuN62xAZ9Z1ScB3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlQrJYNhCLAoZYgCHMpimalhotUJwEO0sRmTcM1cyAoqCSgAUFtyJ0CiZxN8s7IrlgyYIGPIU01mFfOMzRSswpqnTBVrIlC+MkVMS9kl9eSXl10TYkN1ZOHD4xs0u+WK47U1ohFNLj3JMO2luKBhzsZ76GVUHBGzgp4Kr700qtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=biJEbX8C; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="biJEbX8C"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-81e93c5961cso1037271b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 29 Jan 2026 09:37:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769708273; x=1770313073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XlNMowHZilVKV7zVKlSzSEcRiQso4KCzR8rbSekgQMU=;
        b=biJEbX8CTUvIoszUtz1/t+rAbVRbJCgRPhcWMk9gaI8q6iy3sRbnISaVbCmWV80r9e
         IseANUTkQrwduAOCMKxGPBJwSo4/XmK84cfjY0ZAeHql2FuN7dFOgFn65wZfQgfRdqol
         uhcHbbNKMY51rZ060JQAGETJl9qBYEGkh0qJun0+tqWEhszfxCSprwWZpJLJv8vkyj55
         KL1/CdE4+Amk0c/WAHo268pjrMPeG8lh1LGQ2nY6S6q5yTA+TJtQghwvqjaSV+XWHaSt
         g5tMYPqUS02FZhoRpKB3arZKLHUvBdk0U5LMhACcXXbUvLZS21P5Zb/bUngfqhyny3Sz
         w7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769708273; x=1770313073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XlNMowHZilVKV7zVKlSzSEcRiQso4KCzR8rbSekgQMU=;
        b=RO66KRjmr74fgw+CYK3D2elFOIS87yMq89k3mAd8uQWtGelN7KmAj0C+AQhbcjpvJs
         W9zB5jJcmf22TwJXutPbflTVhcRHTtfD3SX4OMje/sbQ7ex6CvgNVIOyrx3nKJN4Q+4E
         /3atoO4l0U19VdKPNWDMZD+BwAQEqKZoWaF6THpDHJ4zNk9Nnu+G7QGqNjsYTIB3Yyyj
         K8JSFK9xXGUAATcV/QO0xavf2ljdBniVu1cdKnmZ8NjubqX2Gq3uyInKTQUH2n54P0CV
         mZ+m8X8n4+upWGcE2CK7IfGEmuhNfnAz4DESBUOumGE9cNT1yNJ5iDpy0Qqkf2tZtfhF
         d7FA==
X-Gm-Message-State: AOJu0YxRBN72i/bwuyhzdKH/WtmcmlEZJUn3nJfBIcxGSZiWDvCasFo7
	J1KgVhXE8O5avUBWxCctwJTrxGuUb4hu1YJLUcbBPtXKvO0foKPXfOkcpkAcCA==
X-Gm-Gg: AZuq6aJfhlcsdhjhzQ7Q9N5yx7Ggu6TOp4iXAOv6wtgAFV2LxtiAxyApPpfvhyTdi+C
	IzXji6dy6MGKTS57RQMiUoxXL6GEUJZB8fIet1768LE9j8KDiUgh/In8LD0vpY91nb3D+XxmISS
	bIOGdPbn9ONzC/o8yzcdQO1E4CjFYHMwf5kfYZxMoXDtevSW4bXi13qCcpcMLtE0UKfTt/lIvUg
	agppN+sz1QEZVE4xGPjs1iKorFIaMwDTLM5bgn8AvPElgYwSSynmJTFyAI+h0QaOUfBtRL1wEB/
	2smV3Z+z1Skrz07FE5LBZdwjIqwpGSCU39OsjxSdmUkMRPhNXp+1TtX1OmU9Maffc6ReuDVRD0Q
	HpEJ51eXgIaPLFbLJ9ablQq3VPrRy6vNLRJQ/51xrG9yJ1Q+uIHd/cqkpo5Sy6/Tt9KlZu3xmNF
	/W4U90qDLfxksEWedmvCdIP/iOzF89BWCbi9dK7l2MkeKniV7lxvo=
X-Received: by 2002:a05:6a00:1893:b0:81f:b1d4:b486 with SMTP id d2e1a72fcca58-8236917312amr8964915b3a.8.1769708272749;
        Thu, 29 Jan 2026 09:37:52 -0800 (PST)
Received: from sprasad-dev1.corp.microsoft.com ([167.220.110.200])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379b6a5desm5512659b3a.28.2026.01.29.09.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 09:37:52 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: linux-cifs@vger.kernel.org,
	smfrench@gmail.com,
	pc@manguebit.org,
	bharathsm@microsoft.com,
	dhowells@redhat.com,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH v3 2/4] netfs: when subreq is marked for retry, do not check if it faced an error
Date: Thu, 29 Jan 2026 23:07:09 +0530
Message-ID: <20260129173725.887651-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260129173725.887651-1-sprasad@microsoft.com>
References: <20260129173725.887651-1-sprasad@microsoft.com>
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
 fs/netfs/read_collect.c  | 10 +++++++++-
 fs/netfs/read_retry.c    |  4 ++--
 fs/netfs/write_collect.c |  8 ++++----
 fs/netfs/write_issue.c   |  1 +
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index a95e7aadafd07..7ac11125ca028 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -546,19 +546,27 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 		}
 	}
 
+	/* if need retry is set, error should not matter. pause the rreq */
+	if (test_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags)) {
+		trace_netfs_rreq(rreq, netfs_rreq_trace_set_pause);
+		set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
+		goto skip_error_checks;
+	}
+
 	if (unlikely(subreq->error < 0)) {
-		trace_netfs_failure(rreq, subreq, subreq->error, netfs_fail_read);
 		if (subreq->source == NETFS_READ_FROM_CACHE) {
 			netfs_stat(&netfs_n_rh_read_failed);
 			__set_bit(NETFS_SREQ_NEED_RETRY, &subreq->flags);
 		} else {
 			netfs_stat(&netfs_n_rh_download_failed);
 			__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+			trace_netfs_failure(rreq, subreq, subreq->error, netfs_fail_read);
 		}
 		trace_netfs_rreq(rreq, netfs_rreq_trace_set_pause);
 		set_bit(NETFS_RREQ_PAUSE, &rreq->flags);
 	}
 
+skip_error_checks:
 	trace_netfs_sreq(subreq, netfs_sreq_trace_terminated);
 	netfs_subreq_clear_in_progress(subreq);
 	netfs_put_subrequest(subreq, netfs_sreq_trace_put_terminated);
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

