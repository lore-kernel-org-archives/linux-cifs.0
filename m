Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B3A158845;
	Sat,  5 Oct 2024 16:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728144584; cv=none; b=W01uCVfUPOaoC0e2H0sRsmAx5CEr9A6Lf9Bii6ruECWYlhiloXOLzvWyRFB7OO6zjGWztH68qWaFXqImLP5iPUc7R4YCFTj3dkRWEruZkpEcIUdKnZVQep9PeFmQBgoIg2L9leh82TWY/hs+/99O7cpepjFXeJIfk9H8ylSHME8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728144584; c=relaxed/simple;
	bh=TDVfE4mXn/mryDEBhTmglxNTqweeeEO1OY1SU0BoSeQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=WA5yJEjnD2LVX81S62GUYxGo8afQ8vk25kfRcNwnD1HJRswURgQDHOg2HAZ3vyecnUWcpUGe4/z+FETMI9/gKD40N0aV2Zb8MAhoLLu7CVEpPLQC4QsEBWy0hIdktxlmhj4TLIJGFTPD9Paa7aogfNEyR7n0pHRG3GD507FTa9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1sPOCZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1sPOCZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAE7C4CEC2;
	Sat,  5 Oct 2024 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728144583;
	bh=TDVfE4mXn/mryDEBhTmglxNTqweeeEO1OY1SU0BoSeQ=;
	h=From:To:Cc:Subject:Date:From;
	b=B1sPOCZkFU3piAQ0LzKPplEdU+d08z0WbVKwTJtfcWaPG+PfA0eyl4BnOaMTrfata
	 RG9rHRg7208hxTR6VuEP+DMor1viv9ZkIN4LlmV6ekq3d2iYNpkTEUhnamDMDrBYZb
	 INZ/XsgxbSb0svabH+TZLmpb6Qle7pn8Oo0GtHSRMTcMLPCRR183jyykox0uDjxgvD
	 JwIKsut3fvjCHrgPg/KtCYDa3Bxt7eFAqrkXV+sp9SsrAspC3Tp1PGt6gWJ7EDWvfp
	 qgBcCX31Frwk0zFRjyYrAek56cIagyhz9kyHTuOTXd4hpb5W34k65iWIIgcHiTMwN+
	 lb0d4RHx4zxwg==
Received: by pali.im (Postfix)
	id F1B02648; Sat,  5 Oct 2024 18:09:35 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] cifs: Improve access without FILE_READ_ATTRIBUTES permission
Date: Sat,  5 Oct 2024 18:08:24 +0200
Message-Id: <20241005160826.20825-1-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Linux SMB client currently is not able to access files for which do not
have FILE_READ_ATTRIBUTES permission.

For example it is not able to write data into file on SMB server to
which has only write access (no read or read attributes access). And
applications are not able to get result of stat() syscall on such file.

Test case against Windows SMB server:

1) On SMB server prepare file with only GENERIC_WRITE access for Everyone:
   ACL:S-1-1-0:ALLOWED/0x0/0x40000000

2) On SMB server remove all access for file's parent directory

3) Mount share by Linux SMB client and try to append data to that file:
   echo test >> /mnt/share/dir/file

4) Try to call: stat /mnt/share/dir/file

Without this change the write test fails because Linux SMB client is trying
to open SMB path "\dir\file" with GENERIC_WRITE|FILE_READ_ATTRIBUTES. With
this change the test pass as Linux SMB client is not opening file with
FILE_READ_ATTRIBUTES access anymore.

Similarly without this change the stat test always fails as Linux SMB
client is trying to read attributes via SMB2_OP_QUERY_INFO. With this
change, if SMB2_OP_QUERY_INFO fails then Linux SMB client fallbacks for
reading stat attributes via OPEN with MAXIMUM_ALLOWED access (which will
pass if there is some permission) and OPEN reply will contain attributes
required for stat().

Pali Rohár (2):
  cifs: Do not issue SMB2 CREATE always with FILE_READ_ATTRIBUTES
  cifs: Improve stat() to work also without FILE_READ_ATTRIBUTES

 fs/smb/client/cifspdu.h   |  1 +
 fs/smb/client/smb2file.c  |  1 -
 fs/smb/client/smb2glob.h  |  1 +
 fs/smb/client/smb2inode.c | 71 ++++++++++++++++++++++++++++++++++++++-
 4 files changed, 72 insertions(+), 2 deletions(-)

-- 
2.20.1

