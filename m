Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AED93451B3
	for <linux-cifs@vger.kernel.org>; Thu, 18 Jun 2026 14:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781792279; cv=none; b=J3QrFxbMvf3/3Aed6kkkfRNe6vvfq3af2fdkM4Qh8/4kh3BypPFXzxzryw3WXe89pTGkIj6bPU2IboKOeqqptVGUptRkmPrfFqDMAbOPI30o6FKsK58yWYUi60DrsafWV9owv+cQB8bKdOzC8Iw5ll2Bn5xU75ApqIe4dE56x4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781792279; c=relaxed/simple;
	bh=dSYLD04dhwWQHbts6riy6n+AgOQ0qj3aQ7QK7t+WFwM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=d7Ppp8ESz2H4ZwC9QYFJCEzRQG5fcWZrg1t/jRsDMJNDeFcijerYSzMT6Dcc3iPQD9mSn6FOl8edXrBXoRX4l90HYaRZwJDxjUAfntrIGJ2N78xCO1zGpuePnQ4m5UyF6yzAQVn+fPZgDZtSose3zViqiUV1oQJcZEXC4VsoyKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeACALbT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeACALbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C601F000E9;
	Thu, 18 Jun 2026 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781792278;
	bh=aPVNiqo6lmo30xhbadirZceoK+0Id9BFBCpX4a01DnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LeACALbTv9oso7IakWV3c3WpXV7oP3U10ZT52jJPt5lqu/O2T9mqk4EK4uIlCMIjN
	 e2UnAFtcEOccxyLbMrG8Q5swxVh2BxJO0A1po3L9gVqF7Wo8E6Kmi7p8agHqBJsl0k
	 MlXz8kScGUrA0yots9afMED1/Xx3EYY2N8l6SG7clQXuloLbP+j7vy3aPf+nMYSL2c
	 ibY57Rhce4q0X+cbT5WOzUhrXK7x3D0MVll37Wh/yXGNxyBiV4/TYTIqM/2Z/y5Fma
	 jaPTsgEzQCUjY+WswLbF53py6hSOWvCb6asLCnYLM9WIZFfiCDLhIM2fSOiEph1k7B
	 z+9p4A7BHLACg==
From: Namjae Jeon <linkinjeon@kernel.org>
To: linux-cifs@vger.kernel.org
Cc: smfrench@gmail.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	metze@samba.org,
	atteh.mailbox@gmail.com,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 07/14] ksmbd: treat unnamed DATA stream as base file
Date: Thu, 18 Jun 2026 23:17:32 +0900
Message-Id: <20260618141739.9029-7-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260618141739.9029-1-linkinjeon@kernel.org>
References: <20260618141739.9029-1-linkinjeon@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SMB path suffix :: names the unnamed data stream of the base
file, not an alternate data stream backed by a DosStream xattr.

Canonicalize an empty stream name with an explicit  type to a NULL
stream name after parsing. This keeps the base filename produced by
strsep() and lets open continue through the normal base-file path instead
of looking for a non-existent empty stream xattr.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/misc.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/smb/server/misc.c b/fs/smb/server/misc.c
index 966004c414a8..2dd91c9e956a 100644
--- a/fs/smb/server/misc.c
+++ b/fs/smb/server/misc.c
@@ -121,7 +121,9 @@ int parse_stream_name(char *filename, char **stream_name, int *s_type)
 	char *stream_type;
 	char *s_name;
 	int rc = 0;
+	bool has_stream_type = false;
 
+	*stream_name = NULL;
 	s_name = filename;
 	filename = strsep(&s_name, ":");
 	ksmbd_debug(SMB, "filename : %s, streams : %s\n", filename, s_name);
@@ -137,14 +139,20 @@ int parse_stream_name(char *filename, char **stream_name, int *s_type)
 
 		ksmbd_debug(SMB, "stream name : %s, stream type : %s\n", s_name,
 			    stream_type);
-		if (!strncasecmp("$data", stream_type, 5))
+		if (!strncasecmp("$data", stream_type, 5)) {
 			*s_type = DATA_STREAM;
-		else if (!strncasecmp("$index_allocation", stream_type, 17))
+			has_stream_type = true;
+		} else if (!strncasecmp("$index_allocation", stream_type, 17)) {
 			*s_type = DIR_STREAM;
-		else
+			has_stream_type = true;
+		} else {
 			rc = -ENOENT;
+		}
 	}
 
+	if (has_stream_type && !s_name[0] && *s_type == DATA_STREAM)
+		goto out;
+
 	*stream_name = s_name;
 out:
 	return rc;
-- 
2.25.1

