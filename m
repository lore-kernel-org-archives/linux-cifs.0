Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0E2192B98;
	Mon, 28 Oct 2024 10:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730112168; cv=none; b=oEHOJLrcRg9fczDnnrjngnD33bhZRt6Ve9b++IXutC0E3Ma/tTn0J5cdibbRvFx9HU0R61FoAianNPnfd9lhdqyzhZUXT1j+FU4wsPT8975NLUfYns642HUvpH1h2SHgdhkPUQvstJcAtYACHtv8L6bo8mIDr7X7bxcJubZTbmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730112168; c=relaxed/simple;
	bh=q1iqQdiv5rl8BDUsBleJchF9kk0AoKRM/RgWkxrn/Eo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjialHUb5AY2/j+rRg/wBiECNc0ajODV81Ss+PEo6ENt8AkNZ0LFB7p2XFdyjOUkS8m6aku1FhfQxcXC3NTT+wrXhqdAhRUje77Vt7JdJg6bHcENrTBXW5clReapLW9A4Q472GheNMEb+ipZ72dupRNPwFgurvCg6WRZpnpYLH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qRFCbXsy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qRFCbXsy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D732C4CEE4;
	Mon, 28 Oct 2024 10:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730112168;
	bh=q1iqQdiv5rl8BDUsBleJchF9kk0AoKRM/RgWkxrn/Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRFCbXsy3r95IoYKN+D88SwLTApJXWj6W65tIq3Q8EpX7P1+FZC6qjRsHZL4QUKZL
	 amkXySjibB/UxwEkef+SHDrl5OjFkZjjc50zfabNdH6zQk8tZw/EIISRiFi1+PN3oo
	 tZu4wcff0YvzWaSBMnYdUtG8GskVNLnDAIuOV7RYPeKMt6hkZ+gkieUQzmwcTpaVVf
	 cj56NjsPDYDoWEOBwMy+fE6CUln8ql0pDf+8CsFWdFDYY562Dpm0YludOQTVr578mu
	 8nGAa1J8P+SUNyCiZmBgottOJ8sXPpTGrFsONAQ14D4LGhp0mXTqPLOaZqluVJjyY1
	 KkjbaMWtURF+w==
Received: by pali.im (Postfix)
	id 52BACA58; Mon, 28 Oct 2024 11:42:41 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY
Date: Mon, 28 Oct 2024 11:42:29 +0100
Message-Id: <20241028104229.29736-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241005154817.20676-1-pali@kernel.org>
References: <20241005154817.20676-1-pali@kernel.org>
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
Changes in v2:
* Apply change also for SMB1 code
---
 fs/smb/client/netmisc.c      | 2 +-
 fs/smb/client/smb2maperror.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/netmisc.c b/fs/smb/client/netmisc.c
index 2a8d71221e5e..a2fb1ae14d41 100644
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
index b05313acf9b2..00c0bd79c074 100644
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

