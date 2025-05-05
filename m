Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0432C280320;
	Mon,  5 May 2025 22:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746483315; cv=none; b=W5Qj3R4nvFfcaM1eHg5ZwILOuE8D/yubiligydIyg4yihW6BpsWvGXv++puRDGrP2Dan2IwE2iONNE6qwP0rLOfLyNyybfO0gOZSSKhhW+g56uWT87i/V5O24ZT+qUBWYwTW6BKz2L2VoVOtzB7pgKmUnfK5PHl7F3Y+mEnhP1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746483315; c=relaxed/simple;
	bh=SMCyw3lBghrm55WqPRwfUNdcNs0jGG4njBch5xen+mc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FjpjDAj7lYQQNr35NUL0wf26laSy2CNxnwqQRIy32SOz91R9NA+0voksKhd/8WVkEMKY2olEFJmV/VfsDSRejuxCWtAyltWSPD327Qv160WmzWKOElsELZaUyfV+cYOJk4GQfec5XxDVOZQmHbEISs+MCSJGksYrhys3yikZQ5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ol6n/NhG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ol6n/NhG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2ED1C4CEEF;
	Mon,  5 May 2025 22:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746483314;
	bh=SMCyw3lBghrm55WqPRwfUNdcNs0jGG4njBch5xen+mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ol6n/NhGQtK8vh/z/vTeFKscQjcP5oahPtqM3ti5fRG7WBqoUNhFBXms7pYLzfmgd
	 gxWVCHEfbpnV9XQxKvW0SRH5iLCPK2JZ1aoYd9UooPlM53P2lzWI0tje1cd/GiiC02
	 eNSTYbSdaH2W7ydU+MojQ/HXIr56xFrHw91cPkopU5GgJrCvDaoo2Qq5tEYgJWEVOb
	 J8EGjeM1YRfBDn1F1lliIBhwOL0Q1HsgLNSeU8qdISvpL9bapr0eoL61Pt7Kpz1BM+
	 JfXJJS5ttpNOYrZwQ+b5wcZzNkvsgGi/KLLAdeocb/ef4AuQHKtDXcV35U+TCP/Xke
	 ueeZEeTryVhLw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	sfrench@samba.org,
	linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: [PATCH AUTOSEL 6.14 027/642] cifs: Set default Netbios RFC1001 server name to hostname in UNC
Date: Mon,  5 May 2025 18:04:03 -0400
Message-Id: <20250505221419.2672473-27-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250505221419.2672473-1-sashal@kernel.org>
References: <20250505221419.2672473-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.5
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
index 00af8dd5aa689..b877def5a3664 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1118,6 +1118,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	char *hostname;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -1450,6 +1451,16 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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

