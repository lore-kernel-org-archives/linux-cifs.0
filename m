Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD41296FBE;
	Mon,  5 May 2025 22:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746484814; cv=none; b=pNl+mFHgldR7Jt3xA9+Pho8Kdt0Ts3v84IVwyYz+xQ6kr9JXz7V98Z4bX4yk0pg0YJ90zobzQrgWro2SKRG7SsgkIIccRnyWEOPn9ugDhnp01nGLZpLVWP3OTp76NxRrh/LdZGBkZ8U42rPQ2prIR36OG+Kqhkd55zUL6nYMFW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746484814; c=relaxed/simple;
	bh=a/g9tbQUy99bGFVa/jbFGQ7/OzXkiGl+liVmBwJvrF0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YhHDx6d/pS1Cew4f6/8Ossj33TTXuQmQBBEej6GheAtxkXJaruNmgl0H+o3IPDpaj1MZkv/f/+O80fav476iRWm/72Cz8KKjA1txUaexQTPF5Iig82icQrGFGZBcDwWctiBC6O1I9iEV6dPwm+jQa8jbTpAwM2qE88NgCu4DhhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RSbXjCOG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RSbXjCOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C888C4CEEE;
	Mon,  5 May 2025 22:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746484813;
	bh=a/g9tbQUy99bGFVa/jbFGQ7/OzXkiGl+liVmBwJvrF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RSbXjCOGmMQoq3GFkfeKVh4H37gOIGWzpN8bCN13IEkJdaenbcPoK6Qu/ooDrawDc
	 CXNyNY5TrFhXVsr97ZpGZbS46PEpMVBO77bAmdDuhqACJv8ZrQW+VSmeyajoAk2LS+
	 zSYWAzxsCKCbJamPr+Jga1jm+7YJ1Cc/mqJTGovXSRYwo3RI/pp8D2uuDbp1IVBjUx
	 vBGK6+6NDxTj3M+NhxUFqLfePpXT/ekH8Ty+7LRmQ+6Mh4Bnh1mL+jjCr3HqQbAAHf
	 jt2YKZjf7dgcqFLKJZlwoVPtaITZ2BAO8xJNoV5GBeyF3w0xw7hA+J5Oh+5nulhc51
	 +Yboq6YoJK2Mw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.12 025/486] cifs: Set default Netbios RFC1001 server name to hostname in UNC
Date: Mon,  5 May 2025 18:31:41 -0400
Message-Id: <20250505223922.2682012-25-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505223922.2682012-1-sashal@kernel.org>
References: <20250505223922.2682012-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.26
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit be786e509c1af9b2dcf25c3d601f05c8c251f482 ]

Windows SMB servers (including SMB2+) which are working over RFC1001
require that Netbios server name specified in RFC1001 Session Request
packet is same as the UNC host name. Netbios server name can be already
specified manually via -o servern= option.

With this change the RFC1001 server name is set automatically by extracting
the hostname from the mount source.

Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 66d872d63f839..d6685679f84da 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1028,6 +1028,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	char *hostname;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -1360,6 +1361,16 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 			cifs_errorf(fc, "OOM when copying UNC string\n");
 			goto cifs_parse_mount_err;
 		}
+		hostname = extract_hostname(ctx->UNC);
+		if (IS_ERR(hostname)) {
+			cifs_errorf(fc, "Cannot extract hostname from UNC string\n");
+			goto cifs_parse_mount_err;
+		}
+		/* last byte, type, is 0x20 for servr type */
+		memset(ctx->target_rfc1001_name, 0x20, RFC1001_NAME_LEN_WITH_NULL);
+		for (i = 0; i < RFC1001_NAME_LEN && hostname[i] != 0; i++)
+			ctx->target_rfc1001_name[i] = toupper(hostname[i]);
+		kfree(hostname);
 		break;
 	case Opt_user:
 		kfree(ctx->username);
-- 
2.39.5

