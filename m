Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793632035;
	b=sL5uyaklwpNRFfO2kHTXDH1Yjth5FqWyDMqrmeXHnxSvMFGxnK+5xczlMnlUKpBg0NSv
	 n9o9z7cN+ME3+IlkF7e2DkqiiiqqYDnaI3EHg3P71Iciazwhh2vUawYuoXsJjpPar36sa
	 1pFPhwBDcI1dLOe6lGWSFewqczUN/fXS7i14QPeQ+9uFa48garjdUxvG57obUduGVl/C8
	 wDAdjThChi8WpgLcmeDZUJ2t0uwlM+yebDGxn4/Qc7taxE6z+p7TY/FFbpRNqRCmf5fMn
	 m2vkCzVCc77HrIzQighRFd/vPX/EMVMiuSSPCrtx74CcyHMvrMt/BdBDE84lAXMb05A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793632035;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fA+/6n3xf0JnFJOXkIesJrFydGTUim2+GD5U2sr0aT0=;
	b=DNmUAcThMiMP13RZNXaYh0Smk0ekWXlM0A8Oq1rcwA6hCpzHA6XQjEQIrsNG020fyxvs
	 qSUEQm7Km9SIrdQVgqzSdKo9I24p0Gw6UtiGeorPfsNZOpzibemjVimvBMma/i/Rdn2II
	 FvDJdWwvE3jsOZWir2xhmiy5QZyUGxnsbWDMuXi7EzKcN/c5WV/bMS6V55kBUUaaAwA8S
	 bX5i/d1Jk5uMQCuZVFk1JqikXC5I0OMoQjaGFL6WJqb7ERRPDe5U9P0/5RxIH7a6k0Xx8
	 c5z6mZnVL1dnt31CAs3o1X3mF7v6ruILTK4v5m6iyhcPqhqmO77Tk7GJhX1SYS4THrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c3t44WYX;
	arc=none smtp.remote-ip=209.85.128.54
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBB16072ED8
	for <linux-cifs@vger.kernel.org>; Mon,  2 Nov 2026 15:07:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BBB16072ED8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=c3t44WYX
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a2d6cf958bso14138605e9.1
        for <linux-cifs@vger.kernel.org>; Mon, 02 Nov 2026 07:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793632032; x=1794236832; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fA+/6n3xf0JnFJOXkIesJrFydGTUim2+GD5U2sr0aT0=;
        b=c3t44WYXPWxz2a69ph0WawkN7Yd35kaElSYggNkLAtxP/H6sSI97oTIEyJ3H9BS1Lx
         IJHubOTarTIPBgOwD1/ONT7uJwum6Qf6DzeKDKJ60j8IFXfaWsqKAZvT/ICgvw5egrM9
         Qtob5bXS42rrZiG6Xn3/4X2whCdozLD3JZ/Z0wdfc/PE09ihNTh9lof9fRSQpkX24TLL
         AKNmfJdAsytACif/XdfdFgnJfG5CYqxpnrFkZhvsssOz62smaOoVTq1+6z/yO9V+FYS5
         FnGUKsXgYTTHBlbN5nIREwor2bLz1haIeJPIuqib5JRTP5Xqmw84lDdNB9RIO8BVMlnI
         2dyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793632032; x=1794236832;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fA+/6n3xf0JnFJOXkIesJrFydGTUim2+GD5U2sr0aT0=;
        b=zp/nHigZtbxxSKambLWeLgDPlCLVrEIuFIaHyouwcZPDO4BFSiOgpT8UF2vGFdno+t
         HHwfvo/WuF6GazPy8VR8p1JVotKi+DxjJ6CoiIhrp/h/ZveP70slV3hmJ3KePDqScoX6
         PGCz4BSpXiO9CTOEhgfaWhhDuQEL93MCOnJtKuih0Jq6uDU9SZDhkRmrbRiG+q1UQDB6
         R4WHVkGwjS1mnsNAeZnUXvvqsuqokGhbNW13f5V7mVPMmXll61RTqR3ngJsBbYRdB8NF
         U+J0aEZ0MohMqbafthXIibHCvIqv8BUF55VD8mo9FqmSc8Dk7Xf2LvSu8iJf6u/WTIlT
         0/PQ==
X-Forwarded-Encrypted: i=1; AKwUvBwVLo5WZb+0FbTRJ9EM5Z7BSxUCwmTYCRTHszazBxL5Qn0JH8S5iTxgu2lKsfrSJL6OZYsepA4QQxAg@vger.kernel.org
X-Gm-Message-State: AFq9FYLDtMxIoTftAVxeVBbMgfMDOxd+N6LihtkncxZf/FpgQuRywF67
	mC6T0PfF7BzkKSVm3OmGPXTGfbcZaEUnYjpoFwj02QIl8kzjCPnQJ3I/
X-Gm-Gg: AYBFou1lAmNvSwYvmreA+KoqMN9O5U1CUh9AEUgMQYthRZpo5tL6GmSy4WQeQl1/DU3
	r876lT+UXoryfgCWOhCYuAG08nmI8QZI0YaDxEiveXvaKQCc3xaH0HYoZ0teOPBiORVR4q5z/Z0
	+KCzSor/TWOGETfZPsT5BWn/rX7qa8ceYWAGWYdkIf56MV8Tc0OISouK1VXvjSPLJogog8CqDlv
	7qZcHItZPfEDg7LdZbNonLvwV8y6PnpdLOUlXsxBaaCJAlF5pXPm32tcdjnXkIBXIjl5WPVeqzr
	90QN+UPv85vcx1IJZrS7f+ZwC2HgLdewSWNaj1iJ6QgW8hPhw69hGS1JfKvCUGs1dlwicg9vsL+
	vrL7Zlam26t6qCW1nM65R9VVC08UR66xfTBvx4iGj4H9M8D3p+AD/eCINeeg0LqIwkyMtI2Fe6Y
	1NqtTXJLL8c+ltOIUXZlXlw2XIISob9k2HSOujJsnbPQ2F19/RDL6Jm21KcDkm1AfDLv3FA2kbW
	BLjYEDap3NbaIkGqwfIDNsrEef3AijKq0aEbiumGjnXemgTDSS8BpY+GDp3M6EoogQ/aEuvY5xk
	sM99/e+Mnt0E7Ka3ebEt/bw71s1Ip4Zkf70xY6ggG7a8
X-Received: by 2002:a05:600c:c4b8:b0:4a0:1b14:e283 with SMTP id 5b1f17b1804b1-4ac150b38dbmr245909115e9.1.1793632032302;
        Mon, 02 Nov 2026 07:07:12 -0800 (PST)
Received: from localhost.localdomain ([2800:810:84a:dc6d:d32b:1515:b2a9:c74e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81b7fe80sm395629535e9.11.2026.11.02.07.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 07:07:11 -0800 (PST)
From: =?UTF-8?q?Iv=C3=A1n=20Ezequiel=20Rodriguez?= <ivanrwcm25@gmail.com>
To: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	linux-fsdevel@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH netfs v2 2/2] netfs: add KUnit coverage for reissue prepare_write errno
Date: Mon,  2 Nov 2026 12:06:55 -0300
Message-ID: <20261102150656.207612-3-ivanrwcm25@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261102150656.207612-1-ivanrwcm25@gmail.com>
References: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
 <20261102150656.207612-1-ivanrwcm25@gmail.com>
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
 fs/netfs/Kconfig               |  9 ++++
 fs/netfs/Makefile              |  2 +
 fs/netfs/write_collect.c       |  4 ++
 fs/netfs/write_reissue_kunit.c | 80 ++++++++++++++++++++++++++++++++++
 5 files changed, 98 insertions(+)
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
index 000000000000..df3ef10f4985
--- /dev/null
+++ b/fs/netfs/write_reissue_kunit.c
@@ -0,0 +1,80 @@
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
+ *
+ * Large netfs structs go on the heap to keep the stack frame under
+ * -Wframe-larger-than on 32-bit allyesconfig.
+ */
+static void reissue_preserves_prep_error(struct kunit *test)
+{
+	struct term_capture cap = {};
+	struct netfs_io_request *wreq;
+	struct netfs_io_stream stream = {
+		.source = NETFS_UPLOAD_TO_SERVER,
+	};
+	struct netfs_io_subrequest *subreq;
+	char buf[1] = { 0 };
+	struct kvec kvec = { .iov_base = buf, .iov_len = 1 };
+	struct iov_iter source;
+
+	wreq = kunit_kzalloc(test, sizeof(*wreq), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, wreq);
+
+	subreq = kunit_kzalloc(test, sizeof(*subreq), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, subreq);
+
+	subreq->rreq = wreq;
+	subreq->len = 1;
+	subreq->error = -EIO;
+	subreq->source = NETFS_UPLOAD_TO_SERVER;
+	__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+	iov_iter_kvec(&source, ITER_SOURCE, &kvec, 1, 1);
+
+	test->priv = &cap;
+	kunit_activate_static_stub(test, netfs_write_subrequest_terminated,
+				   capture_terminated);
+
+	netfs_reissue_write(&stream, subreq, &source);
+
+	KUNIT_EXPECT_TRUE(test, cap.called);
+	KUNIT_EXPECT_EQ(test, cap.transferred_or_error, -EIO);
+	KUNIT_EXPECT_EQ(test, subreq->error, -EIO);
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

