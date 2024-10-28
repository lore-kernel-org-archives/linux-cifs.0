Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8A71DE2DF;
	Mon, 28 Oct 2024 11:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730113466; cv=none; b=EE/9s2+UEeaV4jUt3KeK+HR6o3pMGmTptg52ZTL97uQH6VJS8RubBuij73XpzcduHGeSJt8mF+p5bBEb9zHR6LbrwHGFZOx9ILBNZD9Ov7947w7amZ4i11pNqDJgICAr0VkPVCplXVwh6/QagGgP1qHv34sIIDOVMVAT2A/p9dQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730113466; c=relaxed/simple;
	bh=+KsPW+UwOATIiva30fDwDf9YFBwdccBWJBjRe5rPAXY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hLJFUtgWc5/UIhjYujmv0XlpSq906o3xcCOnwxgxlD2a8WJTDp/SlvJkQUcMfr24Bmy4YzjDfw5njeNAQ3BISLIU3fCZZFnoVQ2W4U2LNjyp8JH/wwoygJgrd1IObNjZyUxgsd/BTDILvelOCwu9Azr9DXo82t4rGDM3Mdq7fjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r/YzKaXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r/YzKaXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B865C4CEE9;
	Mon, 28 Oct 2024 11:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730113466;
	bh=+KsPW+UwOATIiva30fDwDf9YFBwdccBWJBjRe5rPAXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/YzKaXp5ZniTTVhekTO+z9R25IY0+OBzDMQRxKeA3Ehy3ZzY31YM6ADroHlBtKVn
	 cEjWMgnWP6LUCWYyIyP60PspdRN8H9vqBs6PRiwk3Y5ef4D5BUxwOwbTzYiH5s7ZQ2
	 YZzsk0PjmuIEVeeHYfL0EMud5sonoBpQlPqPkFjbROdYVGN5SuGX+rMwBKm++k9ygB
	 l3eIE2Ncn9QOkPyiHX7XUyfqXg9gIZYyHv6hk2op6IoD3kCCIGLTuWMOs8Uvvl+lom
	 sb1QYRp4UknwZ9kapk7EabQglfdIKOve6EJnIhVDZWaC0afJ78XzNYMvbSYtOpANYu
	 PjNeeHOXtv2kA==
Received: by pali.im (Postfix)
	id B9FC4C7B; Mon, 28 Oct 2024 12:04:18 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] cifs: Fix parsing reparse point with native symlink in SMB1 non-UNICODE session
Date: Mon, 28 Oct 2024 12:03:39 +0100
Message-Id: <20241028110340.29911-5-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241028110340.29911-1-pali@kernel.org>
References: <20241028110340.29911-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SMB1 NT_TRANSACT_IOCTL/FSCTL_GET_REPARSE_POINT even in non-UNICODE mode
returns reparse buffer in UNICODE/UTF-16 format.

This is because FSCTL_GET_REPARSE_POINT is NT-based IOCTL which does not
distinguish between 8-bit non-UNICODE and 16-bit UNICODE modes and its path
buffers are always encoded in UTF-16.

This change fixes reading of native symlinks in SMB1 when UNICODE session
is not active.

Fixes: ed3e0a149b58 ("smb: client: implement ->query_reparse_point() for SMB1")
Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index b0fb4a5c586d..f552951cfc04 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -1000,12 +1000,11 @@ static int cifs_parse_reparse_point(struct cifs_sb_info *cifs_sb,
 {
 	struct reparse_data_buffer *buf;
 	TRANSACT_IOCTL_RSP *io = rsp_iov->iov_base;
-	bool unicode = !!(io->hdr.Flags2 & SMBFLG2_UNICODE);
 	u32 plen = le16_to_cpu(io->ByteCount);
 
 	buf = (struct reparse_data_buffer *)((__u8 *)&io->hdr.Protocol +
 					     le32_to_cpu(io->DataOffset));
-	return parse_reparse_point(buf, plen, cifs_sb, full_path, unicode, data);
+	return parse_reparse_point(buf, plen, cifs_sb, full_path, true, data);
 }
 
 static bool
-- 
2.20.1

