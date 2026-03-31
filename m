Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30EC3370EA
	for <linux-cifs@vger.kernel.org>; Tue, 31 Mar 2026 01:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774920337; cv=none; b=WRa3YU4Axr4OporhSOaNEpt7FBJxAvV/wpBxpplnVdsa5IQPObFZGjk0U3ZurrFzToX3MeG3rCgivgLMMap828JKxfjIglpk7xPiTE+1n3Oc08sfMhoKpNmy5PqsxF5jZSPjHebPKc3HmnVu+YLy6e33owejKxSbyk1dYNtgS1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774920337; c=relaxed/simple;
	bh=xvOs+VuI8lodnsrKPZcKRQyPjhUmdZtf0Tzh/Asj+Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ6BSZDq78Z6Yp3jhheZAeth78BVdDby6aby5ZL8h7Cs+1E9XQW/8qqa9SQ547BR8Ecyi/waIWbeeSb0y9Z12LQqNd52wKqEPbRRX/oVv1+fjq3LJLCF4KkrfzRvRa9Jkf8vlYFEz/HSMrzY4DMELl0wwECe7nptNA+tk8LUeWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EB63E4D5B8;
	Tue, 31 Mar 2026 01:25:33 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 67A974A0A2;
	Tue, 31 Mar 2026 01:25:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aJ4aB4wiy2mpbgAAD6G6ig
	(envelope-from <ddiss@suse.de>); Tue, 31 Mar 2026 01:25:32 +0000
From: David Disseldorp <ddiss@suse.de>
To: linux-cifs@vger.kernel.org
Cc: Steve French <smfrench@gmail.com>,
	David Disseldorp <ddiss@suse.de>
Subject: [PATCH 1/3] build_assert: add ccan build_assert.h header
Date: Tue, 31 Mar 2026 11:37:51 +1100
Message-ID: <20260331012508.17410-2-ddiss@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260331012508.17410-1-ddiss@suse.de>
References: <20260331012508.17410-1-ddiss@suse.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	REPLY(-4.00)[]
X-Rspamd-Queue-Id: EB63E4D5B8
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 

Obtained from https://github.com/rustyrussell/ccan with HEAD
050dc66dc2de3d8b150817c6bba648f74b12cccf .
build_assert.h is licensed CC0 (Public domain).

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 build_assert.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 build_assert.h

diff --git a/build_assert.h b/build_assert.h
new file mode 100644
index 0000000..b9ecd84
--- /dev/null
+++ b/build_assert.h
@@ -0,0 +1,40 @@
+/* CC0 (Public domain) - see LICENSE file for details */
+#ifndef CCAN_BUILD_ASSERT_H
+#define CCAN_BUILD_ASSERT_H
+
+/**
+ * BUILD_ASSERT - assert a build-time dependency.
+ * @cond: the compile-time condition which must be true.
+ *
+ * Your compile will fail if the condition isn't true, or can't be evaluated
+ * by the compiler.  This can only be used within a function.
+ *
+ * Example:
+ *	#include <stddef.h>
+ *	...
+ *	static char *foo_to_char(struct foo *foo)
+ *	{
+ *		// This code needs string to be at start of foo.
+ *		BUILD_ASSERT(offsetof(struct foo, string) == 0);
+ *		return (char *)foo;
+ *	}
+ */
+#define BUILD_ASSERT(cond) \
+	do { (void) sizeof(char [1 - 2*!(cond)]); } while(0)
+
+/**
+ * BUILD_ASSERT_OR_ZERO - assert a build-time dependency, as an expression.
+ * @cond: the compile-time condition which must be true.
+ *
+ * Your compile will fail if the condition isn't true, or can't be evaluated
+ * by the compiler.  This can be used in an expression: its value is "0".
+ *
+ * Example:
+ *	#define foo_to_char(foo)					\
+ *		 ((char *)(foo)						\
+ *		  + BUILD_ASSERT_OR_ZERO(offsetof(struct foo, string) == 0))
+ */
+#define BUILD_ASSERT_OR_ZERO(cond) \
+	(sizeof(char [1 - 2*!(cond)]) - 1)
+
+#endif /* CCAN_BUILD_ASSERT_H */
-- 
2.51.0

