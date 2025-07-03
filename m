Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FFC1126BFF;
	Thu,  3 Jul 2025 14:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554230; cv=none; b=O7ColpR3z5NjtjS7y3oouStYjAH035GbqxXwl4vIwpeGFZSgyJkfw0TN4cTWrmaj7Vicc8CsNVsuMuJ33/ceCHbZJdOfcfT2wPURuvxmgW8fV0IkX/5rJlURt0GzCWvnjmKBw2Wf9DcxwEk3SZ9WlqWpvV1/j2RfQ7ZzmVeLAew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554230; c=relaxed/simple;
	bh=bo2Ozl750lniw1wkD05Mf3+OLwdhfu+2TglVATeQj6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzBCH87BXwa3qVdLhA+3F7Qw7033oJE5ypgFFq2AFADag3Aw7ltzHe8XEFqyMEFb/nkbjzEZ9KhRarOf9iaNy5hzLyDwDLc17T5BuKKgogLPJ/1d/0siAfLeewF+iw7FAFGk0wkZ8LfPJP0icZ2yLPn7UxDLCPr+3bbkLCov4DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dbLBtIDm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dbLBtIDm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521BFC4CEE3;
	Thu,  3 Jul 2025 14:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554229;
	bh=bo2Ozl750lniw1wkD05Mf3+OLwdhfu+2TglVATeQj6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dbLBtIDmTOVUOrhh0SnMVFEOuHD2hBEbeOE72QASziF5/uM3AjxhxOHj6Om4l5fMf
	 C40QvkkkPjfeewV+V1x8Yn9HxTH3oiQFRhr+DdWewjcGC/eEq4A1JqRqHHjGIKE01E
	 22OAooQMZBc9Bjp3Lcq19DnPKW3XHjKUii/D86to=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <smfrench@gmail.com>,
	Tom Talpey <tom@talpey.com>,
	Long Li <longli@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	Stefan Metzmacher <metze@samba.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 120/218] smb: smbdirect: add smbdirect.h with public structures
Date: Thu,  3 Jul 2025 16:41:08 +0200
Message-ID: <20250703144000.736053719@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Metzmacher <metze@samba.org>

[ Upstream commit 7e136a718633b2c54764e185f3bfccf0763fc1dd ]

Will be used in client and server in the next commits.

Cc: Steve French <smfrench@gmail.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Long Li <longli@microsoft.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
CC: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Cc: linux-cifs@vger.kernel.org
Cc: samba-technical@lists.samba.org
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 43e7e284fc77 ("cifs: Fix the smbd_response slab to allow usercopy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/common/smbdirect/smbdirect.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)
 create mode 100644 fs/smb/common/smbdirect/smbdirect.h

diff --git a/fs/smb/common/smbdirect/smbdirect.h b/fs/smb/common/smbdirect/smbdirect.h
new file mode 100644
index 0000000000000..eedbdf0d04337
--- /dev/null
+++ b/fs/smb/common/smbdirect/smbdirect.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *   Copyright (C) 2017, Microsoft Corporation.
+ *   Copyright (C) 2018, LG Electronics.
+ */
+
+#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
+#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__
+
+/* SMB-DIRECT buffer descriptor V1 structure [MS-SMBD] 2.2.3.1 */
+struct smbdirect_buffer_descriptor_v1 {
+	__le64 offset;
+	__le32 token;
+	__le32 length;
+} __packed;
+
+#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_H__ */
-- 
2.39.5



