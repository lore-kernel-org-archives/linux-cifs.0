Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090E81F153C;
	Tue, 11 Feb 2025 10:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739269303; cv=none; b=ZFrlSfXVUBwZtamH80D1S/gIrdi19W64s1XeQcKSoOmEN+thG7EgpNgBJwahmu0rdIN4vdKDcprS4dZyyF4XoCIcr5yXRq0CqF3KqyX3Ri+tK5M7zOzr1idFNx2h+a9BvNZQxMFx826Yt8cT2vt+fO3mXQJGVLA+r8KcyfTllDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739269303; c=relaxed/simple;
	bh=53LQ3r8rvZEOLHkZknlLjoX+zOotefhV9iMPwrCGnAU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=mE0+KTeRisMKjMNXsnP8WoVIZrwTeomhBnZWyX68TlSfORxaZGyc008qiVHolL5t1eqizXh2du7NdEmVbJG8GXApo/7j2JST9UX8ETsRQ+FFQbe9KDc1LWKTr/2PDX7UvrMqAqRCjQsUyoopZJpxm2drkF8khTcEGDDRXjDIC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PmRWdrFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PmRWdrFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47062C4CEE6;
	Tue, 11 Feb 2025 10:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739269302;
	bh=53LQ3r8rvZEOLHkZknlLjoX+zOotefhV9iMPwrCGnAU=;
	h=Date:From:To:Cc:Subject:From;
	b=PmRWdrFb/G04JdNJquDTzvPjF/D22gtMfeI2XozIl2a5w0VR9xPryEEFxZ28rE6i+
	 aHJjfmr/XIyuPk1h2W9RF2qjMZQiXRjY9fjeaABQCuv74Ze6O9TGz0qGkMs9i+EOKc
	 8drx7a+intTxiwvIglV3lULkGe7afZMEQx6cE7rqsTF68ewrBNF0Ci1vmSuvumKeO7
	 nv5nfvPKVcgNWnCFZ8NBrd9TVPJaFC7Fwnp3+wry+Mf2eHvXoFaeksmtdM0uv4y+z2
	 B3aU5kGvlEC81deCPovynsqCVaTkakrXyN3ROC+RT9FaXArIMcBYbshTmM4gh3CsoN
	 nwj8rAAfzTUxA==
Date: Tue, 11 Feb 2025 20:51:25 +1030
From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
To: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [PATCH][next] smb: client, common: Avoid multiple
 -Wflex-array-member-not-at-end warnings
Message-ID: <Z6skpSq51yv2OhAk@kspp>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

-Wflex-array-member-not-at-end was introduced in GCC-14, and we are
getting ready to enable it, globally.

So, in order to avoid ending up with flexible-array members in the
middle of other structs, we use the `__struct_group()` helper to
separate the flexible arrays from the rest of the members in the
flexible structures. We then use the newly created tagged `struct
smb2_file_link_info_hdr` and `struct smb2_file_rename_info_hdr`
to replace the type of the objects causing trouble: `rename_info`
and `link_info` in `struct smb2_compound_vars`.

We also want to ensure that when new members need to be added to the
flexible structures, they are always included within the newly created
tagged structs. For this, we use `static_assert()`. This ensures that the
memory layout for both the flexible structure and the new tagged struct
is the same after any changes.

So, with these changes, fix 86 of the following warnings:

fs/smb/client/cifsglob.h:2335:36: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]
fs/smb/client/cifsglob.h:2334:38: warning: structure containing a flexible array member is not at the end of another structure [-Wflex-array-member-not-at-end]

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 fs/smb/client/cifsglob.h |  4 ++--
 fs/smb/common/smb2pdu.h  | 30 ++++++++++++++++++++----------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index f73c57ee5035..70e84e1e415a 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -2331,8 +2331,8 @@ struct smb2_compound_vars {
 	struct kvec io_iov[SMB2_IOCTL_IOV_SIZE];
 	struct kvec si_iov[SMB2_SET_INFO_IOV_SIZE];
 	struct kvec close_iov;
-	struct smb2_file_rename_info rename_info;
-	struct smb2_file_link_info link_info;
+	struct smb2_file_rename_info_hdr rename_info;
+	struct smb2_file_link_info_hdr link_info;
 	struct kvec ea_iov;
 };
 
diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index 3336df2ea5d4..c7a0efda4403 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1707,23 +1707,33 @@ struct smb2_file_internal_info {
 } __packed; /* level 6 Query */
 
 struct smb2_file_rename_info { /* encoding of request for level 10 */
-	__u8   ReplaceIfExists; /* 1 = replace existing target with new */
-				/* 0 = fail if target already exists */
-	__u8   Reserved[7];
-	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
-	__le32 FileNameLength;
+	/* New members MUST be added within the struct_group() macro below. */
+	__struct_group(smb2_file_rename_info_hdr, __hdr, __packed,
+		__u8   ReplaceIfExists; /* 1 = replace existing target with new */
+					/* 0 = fail if target already exists */
+		__u8   Reserved[7];
+		__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+		__le32 FileNameLength;
+	);
 	char   FileName[];     /* New name to be assigned */
 	/* padding - overall struct size must be >= 24 so filename + pad >= 6 */
 } __packed; /* level 10 Set */
+static_assert(offsetof(struct smb2_file_rename_info, FileName) == sizeof(struct smb2_file_rename_info_hdr),
+	      "struct member likely outside of __struct_group()");
 
 struct smb2_file_link_info { /* encoding of request for level 11 */
-	__u8   ReplaceIfExists; /* 1 = replace existing link with new */
-				/* 0 = fail if link already exists */
-	__u8   Reserved[7];
-	__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
-	__le32 FileNameLength;
+	/* New members MUST be added within the struct_group() macro below. */
+	__struct_group(smb2_file_link_info_hdr, __hdr, __packed,
+		__u8   ReplaceIfExists; /* 1 = replace existing link with new */
+					/* 0 = fail if link already exists */
+		__u8   Reserved[7];
+		__u64  RootDirectory;  /* MBZ for network operations (why says spec?) */
+		__le32 FileNameLength;
+	);
 	char   FileName[];     /* Name to be assigned to new link */
 } __packed; /* level 11 Set */
+static_assert(offsetof(struct smb2_file_link_info, FileName) == sizeof(struct smb2_file_link_info_hdr),
+	      "struct member likely outside of __struct_group()");
 
 /*
  * This level 18, although with struct with same name is different from cifs
-- 
2.43.0

