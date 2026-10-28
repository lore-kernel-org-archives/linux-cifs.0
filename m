Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211163;
	b=HRH54hZujTZF2IWUdF4XhAfPV+tdw1L5az4VlzVYe8iKOZlGGcGuLwa46hvZM8fQ1Jof
	 7zkOYXqSzV31fJMIXneN0DYYkurhyyiSGB6NZOHCLNgcde2AVbGykpq0czonR2QsMWDvv
	 U4AhUfcw11rQTfPGSY7FENszLPbXSNRlintfunyw+JmeV/MAkWn86TzufpEuNwCN/+cqK
	 /SLsxT5D9ZXHlvHoNTrMSTDGvwE1n4adUHh9mmE1Ab9uHSNRS49Jo/2UjpmzEQltF+9qV
	 mfR8fCYqoR9nBLYExjjSeAIYfpZa7myVe1VElQGBQsUAv7ZcKjYUlGXVTIr9jGrw2pg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211163;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=SC+rlLyAXoWmtdm6xDuX7v9is1jRIFMfGWnpAh7mi7I=;
	b=htWR6KixUwMZ0ypXH7Hw/QrXjQ+D9x6gZRut4mPYPQyyyussgGQLzlPvGR61WqhXsUAe
	 gGk43SyGtmNjqq0lxIMDu207unArWSGRHz/JG6NXFVW97Q72ugh2sSyaa/U3Y6PlcnkPt
	 DplYmVg5yMTDSjfYVolWddEKcMP0WFZ2m5xVsl1ioTNnzRO14PmaIuZiSpJu0m0zoHSNa
	 A79ci/KM1qpJqHd3XC65HDWk0jh0D4bJMmXsGf0Aq9bcS0CFluFoC9Nglbx6/8qLBRAHk
	 cnxu8LXt80GfeFVUqadK2h82IeSTcubc2tStcRcxTePJ8dWKmEVVrGQylDhVvWOREFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LTqxRz3a;
	arc=none smtp.remote-ip=74.125.82.176
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE7A60A3826
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 18:12:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BFE7A60A3826
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=LTqxRz3a
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36a18fc7a38so2653349eec.1
        for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 11:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793211161; x=1793815961; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SC+rlLyAXoWmtdm6xDuX7v9is1jRIFMfGWnpAh7mi7I=;
        b=LTqxRz3atU/3Py4bE5qrCwTTL8ubQSIxirokP4Nj/IxLMIPzl9oXnN9LNdj77gFs0c
         WHGFKwAOq9wdzrDMT1rXbBD16vZYrdFgx6JMXIwYdbszQvOW8oY8JaVpklu+ncMfvJuR
         UgmwVADOP+HqaUmMXCxpqEFbKoADiJQLx1xc5p8ZYDofEqFAbQLjFnniYr/MqlPLw6gV
         Wyf6Sx/MtbfCkx/Cxp0TBvYJCqBUVQCDDSd2K0wMCaz10bGNcD9cvX4OfzNcjQCubmfh
         ugSHppyZKaDVe1VC30/FyZ7RKTd2DJeQaQlP+dDF0hFV80Dz+GbY+jupPABB/1+Ra005
         oDvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793211161; x=1793815961;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SC+rlLyAXoWmtdm6xDuX7v9is1jRIFMfGWnpAh7mi7I=;
        b=jmalHBldmxKmupHQIH1FCmsZHMgHA7UORAHLQWSHHjBv7GHVOsYcixTilkxy8L80XR
         WQeiVmLCEb8HM2BFOdsS1la5WYi4DlDl3eBKEjaTOZ73y/Vgv/fVk1zCk54Ae2WSzhs2
         fkivmdQCUlUtpZQ+UNttputEwKgLJfYwXG/2TMpU9FssbXYOn1gYQJ8G8NHzYrkpl7Ux
         8KL+Z/v3s1Ht/LDDB6NcI9Bc1gL6yyB52ahjGPTyeFQts0XVsqK4hSOEVNVLUspWZbW7
         01JBBJn20uAAyhto+b/hrM5PqWxM7Qm3LgDDIeldjjdXMwG3K9dwzyt5f/DfUWTOqczq
         iBWg==
X-Forwarded-Encrypted: i=1; AKwUvBwJl3piAXMm/7jOHCUtiA9Ni8iGF1e7wgZBc6yqBNvSiHiwkTP/WtAiJ56ZO7BcJJ9BGpoP4i+bPlXX@vger.kernel.org
X-Gm-Message-State: AFq9FYLqY+3bS8m9oQivYzE/AhX8c5CItv5yTcssIYgkOxdAcO7RK8zP
	UVSrk6RZJChsYk19Dd3Wg2OdOrqbh1nNsCtsqBsRez3m5Islbkocn5zB
X-Gm-Gg: AYBFou3C8L9f5tbfqdW6UFV545ZOB2YaL6ElaMZOf0q47Yk3Mmcnr1pJIzGsYkz9Dnv
	FqrvX2RjLIQFTMnrmeJlsQySwN1bCu6rUtQ5n5g9dMmZozgSSfYmOd8U2d3C+UzAkUCNdmX5r36
	/nfklWmnhrY/xbjHfj/Krc9JvAV3Faa7TEAqifVlL09NyRBBEFRdt7MdTHg2EHnwKGjjKPdTzOg
	r+ZRl3tsX5KIAYL98p3glRzz4FthU7ZXElBj9pxnm4Ve/CzD9vN+21LJZWW1YBVAZFZkPyR6Sfq
	IJs/p4uDPMtRzW9VhUnLTGYVwIKLthM4IAhpssPaebP10dshdeuZ920YhpNSw8ytEg1JZNS7LcR
	YC2TxzWCbTz4t3MTBv7NlapCPjHLEz2W/8Ln+bOacO704Q+WRz3vHFmFELs5f9dYVGAhSeioxPs
	lpH7FBGOCgPO/H1d2uXYNVHV7UzFi7LVcG67uazJdOgWoV0qlhAByZNTf7jKbmUEMi45z5siNI+
	USDsPPjL8+wo3Yvrzs7zBKfk/NM4PIYB1BRtwXnR4p7xD1Vz32NPpTVqhMSpNiep3tkUu1NCbB4
	n5PLl86eB2d7KMYi5lTc/zI=
X-Received: by 2002:a05:7300:cb0b:b0:351:4866:255c with SMTP id 5a478bee46e88-36a204a1735mr5413054eec.32.1793211160870;
        Wed, 28 Oct 2026 11:12:40 -0700 (PDT)
Received: from unix.. ([181.229.23.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da675sm8309394eec.5.2026.10.28.11.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 11:12:40 -0700 (PDT)
From: =?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH netfs v1 2/2] netfs: add KUnit coverage for reissue prepare_write errno
Date: Wed, 28 Oct 2026 15:12:29 -0300
Message-ID: <20261028181229.1408342-3-ivanrwcm25@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
References: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Stub netfs_write_subrequest_terminated() and call netfs_reissue_write()
with FAILED + -EIO.  Unpatched trees terminate with 0; patched keep -EIO.

  ./tools/testing/kunit/kunit.py run --kunitconfig=fs/netfs/.kunitconfig \
	netfs_reissue_write*

Signed-off-by: Iván Ezequiel Rodriguez <ivanrwcm25@gmail.com>
---
 fs/netfs/.kunitconfig          |  3 ++
 fs/netfs/Kconfig               |  9 +++++
 fs/netfs/Makefile              |  2 +
 fs/netfs/write_collect.c       |  4 ++
 fs/netfs/write_reissue_kunit.c | 73 ++++++++++++++++++++++++++++++++++
 5 files changed, 91 insertions(+)
 create mode 100644 fs/netfs/.kunitconfig
 create mode 100644 fs/netfs/write_reissue_kunit.c

diff --git a/fs/netfs/.kunitconfig b/fs/netfs/.kunitconfig
new file mode 100644
index 000000000000..c783d180ab8f
--- /dev/null
+++ b/fs/netfs/.kunitconfig
@@ -0,0 +1,3 @@
+CONFIG_KUNIT=y
+CONFIG_NETFS_SUPPORT=y
+CONFIG_NETFS_KUNIT_TESTS=y
diff --git a/fs/netfs/Kconfig b/fs/netfs/Kconfig
index d0e7b0971fa3..d796dbe4bd7c 100644
--- a/fs/netfs/Kconfig
+++ b/fs/netfs/Kconfig
@@ -33,6 +33,15 @@ config NETFS_DEBUG
 	  management module.  If this is set, the debugging output may be
 	  enabled by setting bits in /sys/module/netfs/parameters/debug.
 
+config NETFS_KUNIT_TESTS
+	tristate "KUnit tests for netfs" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	default KUNIT_ALL_TESTS
+	select NETFS_SUPPORT
+	help
+	  This builds netfs KUnit tests (e.g. write reissue errno).
+	  Say N unless developing netfs.
+
 config FSCACHE
 	bool "General filesystem local caching manager"
 	depends on NETFS_SUPPORT
diff --git a/fs/netfs/Makefile b/fs/netfs/Makefile
index 54834cde7e56..fa1544b9a199 100644
--- a/fs/netfs/Makefile
+++ b/fs/netfs/Makefile
@@ -33,4 +33,6 @@ netfs-$(CONFIG_FSCACHE) += fscache_proc.o
 endif
 netfs-$(CONFIG_FSCACHE_STATS) += fscache_stats.o
 
+netfs-$(CONFIG_NETFS_KUNIT_TESTS) += write_reissue_kunit.o
+
 obj-$(CONFIG_NETFS_SUPPORT) += netfs.o
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 6e8ea534230d..f3236fe494bf 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/pagemap.h>
 #include <linux/slab.h>
+#include <kunit/static_stub.h>
 #include "internal.h"
 
 /* Notes made in the collector */
@@ -529,6 +530,9 @@ void netfs_write_subrequest_terminated(void *_op, ssize_t transferred_or_error)
 	struct netfs_io_subrequest *subreq = _op;
 	struct netfs_io_request *wreq = subreq->rreq;
 
+	KUNIT_STATIC_STUB_REDIRECT(netfs_write_subrequest_terminated,
+				   _op, transferred_or_error);
+
 	_enter("%x[%x] %zd", wreq->debug_id, subreq->debug_index, transferred_or_error);
 
 	switch (subreq->source) {
diff --git a/fs/netfs/write_reissue_kunit.c b/fs/netfs/write_reissue_kunit.c
new file mode 100644
index 000000000000..fca5f7dd9265
--- /dev/null
+++ b/fs/netfs/write_reissue_kunit.c
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * netfs_reissue_write must not clear prepare_write() errno.
+ */
+#include <kunit/test.h>
+#include <kunit/static_stub.h>
+#include <linux/uio.h>
+#include "internal.h"
+
+struct term_capture {
+	ssize_t transferred_or_error;
+	bool called;
+};
+
+static void capture_terminated(void *_op, ssize_t transferred_or_error)
+{
+	struct netfs_io_subrequest *subreq = _op;
+	struct term_capture *cap = kunit_get_current_test()->priv;
+
+	cap->called = true;
+	cap->transferred_or_error = transferred_or_error;
+	/* Mirror production: leave subreq->error as prepare_write set it. */
+	(void)subreq;
+}
+
+/*
+ * prepare_write_failed() sets FAILED + errno, then write_retry still calls
+ * reissue_write().  Before the fix, reissue wiped error to 0 so terminated
+ * reported success and mapping_set_error(0) was a no-op.
+ */
+static void reissue_preserves_prep_error(struct kunit *test)
+{
+	struct term_capture cap = {};
+	struct netfs_io_request wreq = {};
+	struct netfs_io_stream stream = {
+		.source = NETFS_UPLOAD_TO_SERVER,
+	};
+	struct netfs_io_subrequest subreq = {
+		.rreq = &wreq,
+		.len = 1,
+		.transferred = 0,
+		.error = -EIO,
+		.source = NETFS_UPLOAD_TO_SERVER,
+	};
+	char buf[1] = { 0 };
+	struct kvec kvec = { .iov_base = buf, .iov_len = 1 };
+	struct iov_iter source;
+
+	__set_bit(NETFS_SREQ_FAILED, &subreq.flags);
+	iov_iter_kvec(&source, ITER_SOURCE, &kvec, 1, 1);
+
+	test->priv = &cap;
+	kunit_activate_static_stub(test, netfs_write_subrequest_terminated,
+				   capture_terminated);
+
+	netfs_reissue_write(&stream, &subreq, &source);
+
+	KUNIT_EXPECT_TRUE(test, cap.called);
+	KUNIT_EXPECT_EQ(test, cap.transferred_or_error, -EIO);
+	KUNIT_EXPECT_EQ(test, subreq.error, -EIO);
+}
+
+static struct kunit_case netfs_reissue_test_cases[] = {
+	KUNIT_CASE(reissue_preserves_prep_error),
+	{}
+};
+
+static struct kunit_suite netfs_reissue_test_suite = {
+	.name = "netfs_reissue_write",
+	.test_cases = netfs_reissue_test_cases,
+};
+
+kunit_test_suite(netfs_reissue_test_suite);
-- 
2.43.0

