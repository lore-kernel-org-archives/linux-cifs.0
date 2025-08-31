Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB132609D0;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643796; cv=none; b=sO3u6CtGl6prgQHWvQeEBwfEb7i/wHvLYYzl7aCY4ZTU7ZNUagmVmnqtA7QLRE5f31wqfzMqs0+0ukvGBun4i3IN0SFOmeMwSOJflz6FPTqNvGn5KGBg6ohqFkVBOZflaRPAm6u8tS5S9tilJPQzPfImbsJBTHrm1GqJUx0vWvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643796; c=relaxed/simple;
	bh=Az5JDJb6gm7BaaOCT/rbQWvWiCkLEb8ew0r6DIb5I1Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a35WMgdvGv8+wWP5MnugcI9Hb7O1JYrks2VSnxx7R9kuIHR31Tjs/uD5vBMXoRddi8bxOdwAqYFjcGwQXQeiVGkcdawgPi83H74df2seJXVhMrhIwtBcf9AUen1rKb8tF6om3sU9FYiKcxLUVhHWUgEtL95x2vRF5qHabPG9mvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnokS++/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnokS++/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78811C4CEED;
	Sun, 31 Aug 2025 12:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643795;
	bh=Az5JDJb6gm7BaaOCT/rbQWvWiCkLEb8ew0r6DIb5I1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NnokS++/bzuy4r6n4H5NBbR466sdbazsVmgBu3Xk5x6T9s50pl6gcMq9t9923E2Qg
	 NJBxaFcKNs7kSxrhmcEhF5qliaYug7xq4TSANTLgRQV62crGL5+zw8tBu/0OdtiSip
	 hS3f1GoJMyvJFd0suivn/5zRPNxLpD+0e3tPHL5sTC0Z5Pyc1YfnHnE+8NI8RWbXcH
	 eoQzVQbxXKL0lKr+BT2nZNkfOyxvGxNTvN0Zo6wY7qenOg/mYsY37RgwyU4kvHeEJz
	 aPj1hUJCc3HdL2IVJdbSKaF4o3rmTOdGybT+o2g4h4RoBkWdOdCsF6MnuQVIlmSJR0
	 aDPlavk39oDkw==
Received: by pali.im (Postfix)
	id 11DDB11D8; Sun, 31 Aug 2025 14:36:32 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/35] cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY
Date: Sun, 31 Aug 2025 14:35:34 +0200
Message-Id: <20250831123602.14037-8-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

STATUS_DELETE_PENDING error is returned when trying to open a file which is
in delete pending state. Linux SMB client currently translates this error
to -ENOENT. So Linux application trying to open a file which still exists
will receive -ENOENT error. This is confusing as -ENONET means that
directory entry does not exist.

File on SMB server can be in delete pending state for an indefinite long
period. Moreover it does not have to final state before the real deleting,
as any SMB client who still have opened handle to such file can revert file
from delete pending state back to normal state. And therefore client can
cancel any scheduled file removal.

So change translation of STATUS_DELETE_PENDING error to -EBUSY. -EBUSY is
used also for STATUS_SHARING_VIOLATION error which is similar case, when
opening a file was disallowed by server due to concurrent usage.

For SMB1, STATUS_DELETE_PENDING is translated to ERRDOS+ERRbadshare which
is then translated to -EBUSY. In the same way is STATUS_SHARING_VIOLATION
translated to -EBUSY.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/netmisc.c      | 2 +-
 fs/smb/client/smb2maperror.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 9ec20601cee2..4fb265525ea4 100644
--- a/fs/smb/client/netmisc.c
+++ b/fs/smb/client/netmisc.c
@@ -302,7 +302,7 @@ static const struct {
 	ERRHRD, ERRgeneral, NT_STATUS_EA_CORRUPT_ERROR}, {
 	ERRDOS, ERRlock, NT_STATUS_FILE_LOCK_CONFLICT}, {
 	ERRDOS, ERRlock, NT_STATUS_LOCK_NOT_GRANTED}, {
-	ERRDOS, ERRbadfile, NT_STATUS_DELETE_PENDING}, {
+	ERRDOS, ERRbadshare, NT_STATUS_DELETE_PENDING}, {
 	ERRDOS, ERRunsup, NT_STATUS_CTL_FILE_NOT_SUPPORTED}, {
 	ERRHRD, ERRgeneral, NT_STATUS_UNKNOWN_REVISION}, {
 	ERRHRD, ERRgeneral, NT_STATUS_REVISION_MISMATCH}, {
diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index 12c2b868789f..6d381f26c5cd 100644
--- a/fs/smb/client/smb2maperror.c
+++ b/fs/smb/client/smb2maperror.c
@@ -368,7 +368,7 @@ static const struct status_to_posix_error smb2_error_map_table[] = {
 	{STATUS_EA_CORRUPT_ERROR, -EIO, "STATUS_EA_CORRUPT_ERROR"},
 	{STATUS_FILE_LOCK_CONFLICT, -EACCES, "STATUS_FILE_LOCK_CONFLICT"},
 	{STATUS_LOCK_NOT_GRANTED, -EACCES, "STATUS_LOCK_NOT_GRANTED"},
-	{STATUS_DELETE_PENDING, -ENOENT, "STATUS_DELETE_PENDING"},
+	{STATUS_DELETE_PENDING, -EBUSY, "STATUS_DELETE_PENDING"},
 	{STATUS_CTL_FILE_NOT_SUPPORTED, -ENOSYS,
 	"STATUS_CTL_FILE_NOT_SUPPORTED"},
 	{STATUS_UNKNOWN_REVISION, -EIO, "STATUS_UNKNOWN_REVISION"},
-- 
2.20.1

