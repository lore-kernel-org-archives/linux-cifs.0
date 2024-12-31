Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D117F1BD9F9;
	Tue, 31 Dec 2024 22:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684632; cv=none; b=iVYioVyOThBxg+7h6E8UjefZFpj7HcekLTRlXbjsYTwNa52Td8qY15GgodadvMDlYMX4imUEaKoOYGNrFr+L+HFeJ/8u25tN/RcQg+Bg2vtSZQDUtnAzio6wvoq4LrAYWPcXAff1Qrwdy043vMgFJXmU0ECjk8vcTTQwZ0SBWhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684632; c=relaxed/simple;
	bh=XJQVj3tQtb2bvc7E0/stCGdfIySzLwcBcImilldPk3A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cVWMRZQDC/GHSu9mhe9/88mgtQ1gLkJ+HmDHXxJaGADvaQFhtOk8eYDy+Oav5GmHGYkKyAqWTJ7JjNfJP5SbAIGvf/s99nIM5lxnei3Fn8XlVJ1aEZJjAHcHN4JlGJudVvo5vFtIU/TaOMxyFMItgK5Sg0Pn7cLIwa2ORQVYBpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uTmmHLam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uTmmHLam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFB2C4CEE2;
	Tue, 31 Dec 2024 22:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684632;
	bh=XJQVj3tQtb2bvc7E0/stCGdfIySzLwcBcImilldPk3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTmmHLamXsGipO1yZK9nlid0LP0K5hX9QZcfvgO4RJEHOxA9fVNbY7kaLW6G/SAxI
	 bCVakM1E6tYqDIU7ZFicfXVmQ8LoZgq+tzNs+77Daszr/DUAD1Z70gIe/LVnELvBo+
	 OtAHkofbyRgdznkoOMIVkiHDGb2AJ3x/6vtiXg4IBiUJlJdAyIf4xvRofESVZrBy2Y
	 U1/Jm+e2lGvPToDzPS2h337UTLWDRrq9B1G45sbxLS6a2PMpFsdjl5d9H0tA2LkLQr
	 Tgjh1sXx4/dHBooetsfx8Rr4dt2hCD8cD9lMQjIiBnPsvZLWodmH/a+26ewyaEw4pe
	 U5mwjY/6gKNaw==
Received: by pali.im (Postfix)
	id 7EFCEFE7; Tue, 31 Dec 2024 23:37:01 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 11/12] cifs: Add fallback code path for cifs_mkdir_setinfo()
Date: Tue, 31 Dec 2024 23:36:41 +0100
Message-Id: <20241231223642.15722-11-pali@kernel.org>
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

Use SMBSetInformation() as a fallback function (when CIFSSMBSetPathInfo()
fails) which can set attribudes on the directory, including changing
read-only attribute.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/smb1ops.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/smb/client/smb1ops.c b/fs/smb/client/smb1ops.c
index 33af1a6ab348..1697c1fc13b0 100644
--- a/fs/smb/client/smb1ops.c
+++ b/fs/smb/client/smb1ops.c
@@ -800,6 +800,11 @@ cifs_mkdir_setinfo(struct inode *inode, const char *full_path,
 	info.Attributes = cpu_to_le32(dosattrs);
 	rc = CIFSSMBSetPathInfo(xid, tcon, full_path, &info, cifs_sb->local_nls,
 				cifs_sb);
+	if (rc == -EOPNOTSUPP || rc == -EINVAL)
+		rc = SMBSetInformation(xid, tcon, full_path,
+				       info.Attributes,
+				       0 /* do not change write time */,
+				       cifs_sb->local_nls, cifs_sb);
 	if (rc == 0)
 		cifsInode->cifsAttrs = dosattrs;
 }
-- 
2.20.1

