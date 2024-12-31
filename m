Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DE81B4254;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=IzU2L7/N1CbO0UN5EY66MoKCTMv1j0XnXRiQ5nyoVTjoGdsU+C9GTX956ea1uX0q5gs0PBlkNDWXYMqYsyzHuRHPslB10XvAz7qWGyqUWZzMfzVI2Z9h3m+Yx3RLAmSH7IYAun8+W/3nhek29FOyCpEngAMOS+U3NqLxz8yJy40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=Izf59NF6S5+Ds6OjDjX0Gn5vu0iX6iBS0DYB3Ez1QhA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=II6xxh15R3onfQ/wRYtPHpYf7G1kkhBxdi1CeqEO8xeI4DblRaEYNq7DEAIwBS4jS6Xs+3ZdxprRJWHhOi9o+eHRzkglYYF2LaJMuu6/JzOIEj/TJR88uiRrHHMlMIx2mBHizOx0V15n0GSovfUs2mPWZc44SEeYN4WOghFW5cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZQJfG1c6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZQJfG1c6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D89C4CED2;
	Tue, 31 Dec 2024 22:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684630;
	bh=Izf59NF6S5+Ds6OjDjX0Gn5vu0iX6iBS0DYB3Ez1QhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQJfG1c6/Jw0ryuZ4GTzdWbDmGZt+kHUAr5wx1wUa1INPKf/Riy8Ox3V5NuOdRJLH
	 1vL0RLhzW6bF7/lrS9dB1dzUua02azsJcxN8AlsGhAyigSURQzMK4bJubULijJG4IR
	 R9zD1ggQ8zqffnjtiPN0GkscluPJ0QvAKxsmEkFKAs60zEXcCA5yf7oSXiyDRz/ux9
	 OprCCxhm5yiJNzjFpbWUpmpjh+L64TRsqTKgCMNoiMTTIYUZeAM7t1xHQ/zNbznRhH
	 xKJV8EVYK6Wrvu1yJ7EYID6eit4Eq33K0uSsxcnHXmLil+reZl8KJlRvM+4WtAmYB1
	 K/WwT2Z/lxi4g==
Received: by pali.im (Postfix)
	id EDA52EEC; Tue, 31 Dec 2024 23:37:00 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] cifs: Improve SMB1 stat() to work also for paths in DELETE_PENDING state
Date: Tue, 31 Dec 2024 23:36:37 +0100
Message-Id: <20241231223642.15722-7-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241231223642.15722-1-pali@kernel.org>
References: <20241231223642.15722-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Windows NT SMB server may return -EBUSY (STATUS_DELETE_PENDING) from
CIFSSMBQPathInfo() function for files which are in DELETE_PENDING state.
When this happens, it is still possible to use CIFSFindFirst() fallback.
So allow to use CIFSFindFirst() fallback also for -EBUSY error.

This change fixed stat() to work also against Windows Server 2022 for files
in DELETE_PENDING state.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index b0813106df16..a7a846260736 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -578,7 +578,7 @@ static int cifs_query_path_info(const unsigned int xid,
 	 * so they cannot be used for querying paths with wildcard characters.
 	 * Therefore for such paths returns -ENOENT as they cannot exist.
 	 */
-	if ((rc == -EOPNOTSUPP || rc == -EINVAL) &&
+	if ((rc == -EOPNOTSUPP || rc == -EINVAL || rc == -EBUSY) &&
 	    !(tcon->ses->capabilities & CAP_UNICODE) &&
 	    strpbrk(full_path, "*?\"><"))
 		rc = -ENOENT;
@@ -587,7 +587,7 @@ static int cifs_query_path_info(const unsigned int xid,
 	 * Then fallback to CIFSFindFirst() which works also with non-NT servers
 	 * but does not does not provide NumberOfLinks.
 	 */
-	if (rc == -EOPNOTSUPP || rc == -EINVAL) {
+	if (rc == -EOPNOTSUPP || rc == -EINVAL || rc == -EBUSY) {
 		search_info.info_level = SMB_FIND_FILE_FULL_DIRECTORY_INFO;
 		rc = CIFSFindFirst(xid, tcon, full_path, cifs_sb, NULL,
 				   CIFS_SEARCH_CLOSE_ALWAYS | CIFS_SEARCH_CLOSE_AT_END,
-- 
2.20.1

