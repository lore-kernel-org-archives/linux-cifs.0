Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499BDC2C9;
	Sat,  5 Oct 2024 15:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728143332; cv=none; b=dPpA5Nwy6E4QSnBnTw7DyBJqdL6GhNqb/PbrroSOLPu+vUrt9OA09Ws/+p11LjFzMDbr+F0vljydWLklP3l7vcxbEEZjSJBMv6MCXRIccCObtCE+SICyRr7wWe4NlXTUV2608c2XxMlQ8GI9W2zpy3X0uP4fSGKKIkXdXs6Kb1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728143332; c=relaxed/simple;
	bh=9xoeKcKVDweNsARiellNe0LCftKTiaLL9unlkqHRO/U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=FJtFNfXIgPxGXn/Wu1DbQVr01knDKiRqdFQBkJ8kLkjMzjlxr6I/MnJQdCAuLdobnY5QA5zxzsYwOPWRgd8v0aN8KWvvnl1Ma+aAKrxo0ljYzqPCS5t0J8uDQkZdVj8F+Pg3lNx/nC26BpF9fdvkH4vWgrinuS0YVsR6V77PFjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDoHfbj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDoHfbj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9323AC4CEC2;
	Sat,  5 Oct 2024 15:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728143331;
	bh=9xoeKcKVDweNsARiellNe0LCftKTiaLL9unlkqHRO/U=;
	h=From:To:Cc:Subject:Date:From;
	b=RDoHfbj3df4lD22szVfwft1MVcPhWylhIU69zgINno0VGXIdaXGNMK2QrwbOhqZRH
	 +Z1myn29aNl1Z+P2n/p5vmdvW9C2muDsaGtZ+CCI2hBiTthW34PnfHCObmX6mwnyeo
	 JILipIQamkAZZSzl3x5AXJ67IWI1o13H2abPAnGn++TIcag7jtZQBDwS0uBwVxu+yS
	 hCxIUcRCSV1Aw7/bfinWWhsSxlKd9+GcYpSGl5+QnyqMekWBSkdvvnsGNXo9msmp8V
	 pVoEAWU5tf1z1xNlFPOhe4ePySJ1reT1vOFjK0d31GZ0qMEMTMIz+mRUeqFvtQGJQw
	 0ULUSTWILCTpg==
Received: by pali.im (Postfix)
	id 773E2648; Sat,  5 Oct 2024 17:48:45 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] cifs: Change translation of STATUS_DELETE_PENDING to -EBUSY
Date: Sat,  5 Oct 2024 17:48:17 +0200
Message-Id: <20241005154817.20676-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
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
as any SMB client who still have opened handle to such file can return file
from delete pending state back to normal state. And therefore it can cancel
any scheduled file removal.

So change translation of STATUS_DELETE_PENDING error to -EBUSY. -EBUSY is
used also for STATUS_SHARING_VIOLATION error which is similar case, when
opening a file was disallowed by server due to concurrent usage.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb2maperror.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2maperror.c b/fs/smb/client/smb2maperror.c
index ac1895358908..fbc4ed038ff5 100644
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

