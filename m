Received: from out-181.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEA43382F10
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 08:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.59.57.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918083; cv=none; b=RMqhfONrr7wtxbFc9SxRq/8jTIFCpkWuG5stvgoQYXvYMm+O92w2IYHSdRnVkD5cZT1NussGjwmvA7iXZ5QVkxo0h5h+vGNqixmTyvg+WOfD145A+eUGTvYlYTCDMueoKkaTcqfIi+GImZ7iKsO7PfF0dRkN+bSbV9TQ/u7ZRCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918083; c=relaxed/simple;
	bh=HvNN66jSsz0ozDedR85RvNfK5c3y+joLcpDgODfvh8A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mJEA9E4oKaaFUN/hAcIpy0UxSdQ/Ej5UIzgV2009hXPCHw/gV1GMdliJhTgh5UDMzcUlZYpD1DhswV+0PcoxgjcIIkgbNtI5ipclVsqif/3hVy7L1wVRR9lPr/otLdTrSG8R3lRDtZNzFiibAoKcQtoD5HMBQvDrin5/4W2RTWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=mIgo12XU; arc=none smtp.client-ip=37.59.57.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="mIgo12XU"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785918077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lmz9IXMWYHnxiT3H+gVFXqPvx88bAij/V2jdDPoExt4=;
	b=mIgo12XURC/rJCNTh2/cBr81hkB3R1XlIAgiEyGuOjgNVHyoURQ7o6UmRDVzWBbg2+pREj
	N7FRIsKqaWFeQx+LkLJgGngd/SGx1sOMpijM3TlthG/vDAtGmC8KAQYw4k1py9juAiLPgm
	3ik0HAlnFPV8ayGKUWKlPBd7uSTO1TrXgO/KeAR4SU9k6LWWendCvhyCTwNgSOZPHGL8wG
	8qanNt0jFsmqiSUnsY1YAzP3if+kUoIRjKIhXVeblfKgK9mhfMY7ZHtTTIZ2jF2dOQEhIB
	jtkAsCYts+kXZcfRjv4LfewILvF6DolxEGUYh0gNQUcVobXla62mHaX97KwpAA==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [PATCH smb3-posix-extensions] FSA: allow rename over files with only POSIX opens
Date: Wed,  5 Aug 2026 08:20:18 +0000
Message-ID: <20260805082018.309542-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Update FileRenameInformation processing for an existing destination.
Ignore POSIX opens when checking whether the destination is open, so the
rename can continue if all destination opens use POSIX semantics.

Keep returning STATUS_ACCESS_DENIED if the destination has one or more
non-POSIX opens.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fsa_posix_extensions.md | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/fsa_posix_extensions.md b/fsa_posix_extensions.md
index e03102d..7dbdf77 100644
--- a/fsa_posix_extensions.md
+++ b/fsa_posix_extensions.md
@@ -617,3 +617,18 @@ Open.GrantedAccess does not incluce FILE_WRITE_ATTRIBUTES and
 not AccessCheck(SecurityContext, File.SecurityDescriptor, FILE_WRITE_ATTRIBUTES):
 
 - the operation MUST be failed with STATUS_CANNOT_DELETE.
+
+##### 2.1.4.8.3 FileRenameInformation
+
+When processing the following condition from MS-FSA 2.1.5.15.12:
+
+- If there was not an oplock to be broken and
+  **TargetLink.File.OpenList** contains an **Open** with a **Stream**
+  matching the current **Stream**, the operation MUST be failed with
+  `STATUS_ACCESS_DENIED`.
+
+For this check, the object store MUST consider only matching opens for which
+**Open.IsPosix** is FALSE. If one or more such opens exist, the operation
+MUST be failed with `STATUS_ACCESS_DENIED`. If all matching opens have
+**Open.IsPosix** set to TRUE, this check MUST NOT fail the operation and
+processing MUST continue as specified in MS-FSA 2.1.5.15.12.
-- 
2.54.0

