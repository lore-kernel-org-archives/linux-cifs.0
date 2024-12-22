Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAC31925AF;
	Sun, 22 Dec 2024 16:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734885098; cv=none; b=AcW19yJK61GvKv/9RXEXLK1M/GYQ1qaPNlHWy55qOViYttCGduzoxZGIPXiekcMWUcH4/YWuFJxpBS7Niv3+OzLYvtG383tuQhyHHN1mpXbYLSHQCF84TDm79WAqteGjiRxX9WPsH5nx8i2nUXFSglln7sZYixNnGjA3PSTn74Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734885098; c=relaxed/simple;
	bh=roMvo+vaCtZhM+ffAECwM9kTdTDexaaoB04VHkeB1IU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c1XnYZYWmvU/EhDYtf/jo5UlNJsIg0mdFIgH/QtSK3gBHEoOTfQkZme10fgSOeATsYnlOmxaY3f2GAGdVkFV3oxpFBz06Etudm6esp5tFCQBlqjhBWI9Jd9JiCIcemRbwVX7i1Yu25O4FrFu+C4kItaMriUqIBj2wvJaNHjk8Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bou9qV7T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bou9qV7T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18DD2C4CEDF;
	Sun, 22 Dec 2024 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734885098;
	bh=roMvo+vaCtZhM+ffAECwM9kTdTDexaaoB04VHkeB1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bou9qV7TQncyJim9svbw5bDJcXfV9Hz/dIiV1AVFg0lVZ03jVFE9h3sKIKPfjq0P8
	 5+DbhVH4jukBG+e1U4WQJvGh2FYEJn5jgQ/DTZyRvD3bs/XHt1pciXA060sAB+UnE1
	 nm8Hdt29RGguaqEn59K8sDruan4hqI+IyY1mrkaa2zvwJ9pcrK9cvi57ZkFF/85Jx/
	 MRxgL0l6EJXjzJyeH5dT0VdrurGLIw0JNZziAfDO7xOg4kBK0+YQZCybHmTQR5jEwH
	 41k+510l3/zyJ1sQ205TcRvkyOD1dCJsc3LbbBqigUoXIaP+aNuBAhqmhZy3NFEDBG
	 SSWEqUT6MONtQ==
Received: by pali.im (Postfix)
	id EF695F3C; Sun, 22 Dec 2024 17:31:27 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] cifs: Set default Netbios RFC1001 server name to hostname in UNC
Date: Sun, 22 Dec 2024 17:30:50 +0100
Message-Id: <20241222163050.24359-7-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241222163050.24359-1-pali@kernel.org>
References: <20241222163050.24359-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Windows SMB servers (including SMB2+) which are working over RFC1001
require that Netbios server name specified in RFC1001 Session Request
packet is same as the UNC host name. Netbios server name can be already
specified manually via -o servern= option.

With this change the RFC1001 server name is set automatically by extracting
the hostname from the mount source.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/fs_context.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index 3774f02f45c9..0bda7ada4f81 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1125,6 +1125,7 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
 	int i, opt;
 	bool is_smb3 = !strcmp(fc->fs_type->name, "smb3");
 	bool skip_parsing = false;
+	char *hostname;
 
 	cifs_dbg(FYI, "CIFS: parsing cifs mount option '%s'\n", param->key);
 
@@ -1447,6 +1448,16 @@ static int smb3_fs_context_parse_param(struct fs_context *fc,
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
2.20.1

