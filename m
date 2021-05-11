Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F9EAC433B4
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20FD261106
	for <linux-cifs@archiver.kernel.org>; Tue, 11 May 2021 16:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhEKQhj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 11 May 2021 12:37:39 -0400
Received: from mx.cjr.nz ([51.158.111.142]:34558 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230315AbhEKQhj (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 11 May 2021 12:37:39 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 9A9ED7FEDB;
        Tue, 11 May 2021 16:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1620750989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nB22L1yGCxD6nAb7tE4RDvbYXZ2IIOl2GNS7f5U0jdY=;
        b=CRFqmWbMsEidwm4ldnbcC2zL3xbJsvWzIy6a0vus5qS0GTyUlVRT7LhLTfFsM2Aw9gLx7K
        aM3X3NB3699JE6BEzsmNxbdVEON3iezO9NHrYF8imlwBJFzEv3mjT8T0Y+DQGrVWDX+kyo
        WlakdY8CRjqTKAdNv41U4A/7ihdZRjiErenPRU1Dx3ySHN+cyRBleqV9UoWd6UqngzrkaQ
        7YQEZzEjVfX4rXNP/o8ibuu9qtvgljtqdhDEdR5xLfOtuWD3sQKdTEdnlMNPa27FFZmUYg
        UHkYwJTAf9mto323pwoieNjZZDKNYMjJrIi7JuiIGLfRtpUGz6oTfJAdFl7Hyw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 1/3] cifs: introduce smb3_options_for_each() helper
Date:   Tue, 11 May 2021 13:36:07 -0300
Message-Id: <20210511163609.11019-2-pc@cjr.nz>
In-Reply-To: <20210511163609.11019-1-pc@cjr.nz>
References: <20210511163609.11019-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Introduce a new helper to walk through the mount options and avoid
duplicating it all over the cifs code.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsglob.h | 16 ++++++++++++++++
 fs/cifs/misc.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index ea90c53386b8..6c65e39f0509 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1960,4 +1960,20 @@ static inline bool is_tcon_dfs(struct cifs_tcon *tcon)
 		tcon->share_flags & (SHI1005_FLAGS_DFS | SHI1005_FLAGS_DFS_ROOT);
 }
 
+char *smb3_parse_option(char *options, char sep, char **nkey, char **nval);
+
+static inline char *smb3_parse_options_sep(char *options, char *sep, char **nkey, char **nval)
+{
+	*sep = ',';
+	if (!strncmp(options, "sep=", 4)) {
+		*sep = options[4];
+		options += 5;
+	}
+	return smb3_parse_option(options, *sep, nkey, nval);
+}
+
+#define smb3_options_for_each(opts, nopts, sep, key, val) \
+	for (nopts = (opts), nopts = smb3_parse_options_sep(nopts, &sep, &(key), &(val)); \
+	     (key); nopts = smb3_parse_option(nopts, sep, &(key), &(val)))
+
 #endif	/* _CIFS_GLOB_H */
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index cd705f8a4e31..7b3b1ea76baf 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1284,3 +1284,51 @@ int update_super_prepath(struct cifs_tcon *tcon, char *prefix)
 	cifs_put_tcon_super(sb);
 	return rc;
 }
+
+/**
+ * Parse a string that is in key[=val][,key[=val]]* form.
+ *
+ * @options: The options to parse
+ * @sep: The options separator
+ * @nkey: The next key pointer
+ * @nval: The next value pointer
+ *
+ * Returns next key-value pair to be parsed, otherwise NULL.
+ */
+char *smb3_parse_option(char *options, char sep, char **nkey, char **nval)
+{
+	char *key, *value;
+	char sepstr[2] = {sep, '\0'};
+
+	*nkey = NULL;
+	*nval = NULL;
+
+	if (!options || !options[0])
+		return NULL;
+
+	while ((key = strsep(&options, sepstr)) != NULL) {
+		size_t len;
+
+		if (*key == 0)
+			return NULL;
+
+		while (options && options[0] == sep) {
+			len = strlen(key);
+			strcpy(key + len, options);
+			options = strchr(options, sep);
+			if (options)
+				*options++ = 0;
+		}
+
+		value = strchr(key, '=');
+		if (value) {
+			if (value == key)
+				continue;
+			*value++ = 0;
+		}
+		break;
+	}
+	*nkey = key;
+	*nval = value;
+	return options;
+}
-- 
2.31.1

