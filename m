Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D719A4266A0;
	Wed, 12 Aug 2026 10:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786531206; cv=none; b=ixoyd7BN3I0bYNQLiXDhrdPqMCNpQh7fJKfvevl41p+VhsdaRhSClMxvaoFN3xHq7Ak6NmhQFlKv4Ogd5CtSEEQbk0KPkv+IqtRnzk3+AqKDiBPjw5yUOFyCgi03C0eOlOA9oozqftnQigFgYNtVNITVrO5H5m9NvAtc18we2dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786531206; c=relaxed/simple;
	bh=8fT5Koh5mkdo/+u/cFNXk0hZJdGQOCnPGgb5Rfw/01g=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=kl2AhYFKuaioDFherenoAVfZZU0QzAzq17i4Yt8SmWpHyhMZMn5XvvsSswQ00QE3BIRftAgIyx5Q+OsyuuNTc22m/DGZ5CJfngnZmN0WEj4g8ZYJzFT0c+yLA3WY97kwQZrb0AajaLdSbq3IKqJr6F+WH6osanv1nKBnew18YCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=lFUvaQ6D; arc=none smtp.client-ip=162.62.57.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="lFUvaQ6D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786531190; bh=lTg9+P6mjJUBXUmHHXu7LnNy/Y0iaMAx8wDJU7evqPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFUvaQ6DxrIjbNnHOh4XL1+rtccQDtTh7gbGGAX9T0Wm/pIaqJyKzSS0SJ+0qznmN
	 t8EVUAfGzhIdP7/Dylyajp7AGpea8WX8oeTtHOxEw8xQ6TL7D9TIOOUMxK2hZrdImY
	 uND8okMt4uHNMbbV30Z7H/JZhW6hSg9SPwbcYWYE=
Received: from localhost.localdomain ([240e:452:ddba:7caa:44f2:d3f7:942:3f36])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id 9EE2B0DB; Wed, 12 Aug 2026 18:39:46 +0800
X-QQ-mid: xmsmtpt1786531187tdsp7eawz
Message-ID: <tencent_4A67129F3CE9202D7F81A4FF94115D64DB0A@qq.com>
X-QQ-XMAILINFO: MZtEYADUG4Agu3XXTv78TL2dhhA68BDyApj/8AL0iLamk8YIl/Zz7zkC3ONxTn
	 X3IBlWCaBB2/33WZbsXVI3FUGNVbyR8ripWvcyCKuAMWdpXDWNRABXbky6vHM/5Cffte/wNWfUmR
	 MP98MYGSNadQQ8esHwszozrvamqVfrEkXtqqtWt1jCcgnSf4QtU0Le4qhSODQShSIy0e4V4GCcji
	 NHwGuAUmCKGhAZwFSrMfL0Lshxy/YAFCBnkwykma7LaCdAzFQh9K9B0rrEFHKkQY7BthSYCpfCeP
	 19YKGFwjer5S6hOaAeMWoY67rMCKf0fKsZjg6BxgCz6aJaReqJmuAXjrlYaH1phjYzwfOPJx/imZ
	 Wm0AulHk0CUIiDxQvBhtBi5nGruvkuQlNxhb3+fSfQHX3SVminHcWHiXWQlnEuTIkxd+476xYuVk
	 MuaK5UFrh0mo3J4FV6vamHA90puqwA7Xdl5YVcQN9mBYIE+r48BYTvr3yHwSSfURAPd5EfR0zrRf
	 wuld6G0TOAufrBVPiyJUSPI309d0aLiHuxZwo1FO74tyqKBO3eWSMQlH0OfM2yx9D88xSCkliiql
	 1vmEMU8kd2EF9x4MxOBXc63fXC6kEq/oBtWmTVLGGaEGxr7wcQCA0ogfTmnK1JwWDMY9aQDmHmB7
	 FhkB3UJgP9crWf4TWm/NBPbeij5jpyD+QeRYnd0Qo99ov6UV/w63aEM+2FDHVy2guIjSfScgdva8
	 NpXBlxoGoKgTDFD+uqysBH8p/pW5IQYMrOFlz4uOrarT5M5whLhqbmmF0zqyyGkdy/xzXZ0OS5M+
	 938cycCQRnxoi4oEq2CbbW82/HahIFyvIUR0ha6fmFtnlKwL0lFsMJMsePe2YMIQru7IEyxF+tZ5
	 a0gMOnD9K81pMg0H/68pI/9wOluceXfbGT35D/a9kyahqYpHvARxzki1eMYlI/42ez33HHMDUmkr
	 otUNS83zoq/bwiiUXAIDUfHSmfwc6hhfeHFY/8okjnl1W9xTaZWnq3hHDINSh7l1Q5/pEg33ml3o
	 qZCPMWx72+Uq3OSV6TiN/XEjXbIm/citGW8qrJxV4XCVFwj+xNPEh4u/mECG4=
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
From: Hang Nan <2122295973@qq.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	Hang Nan <2122295973@qq.com>
Subject: [PATCH v2 1/2] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Wed, 12 Aug 2026 18:39:45 +0800
X-OQ-MSGID: <20260812103945.82495-2-2122295973@qq.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260812103945.82495-1-2122295973@qq.com>
References: <8970140c-1de1-4989-b32c-ea485be00b79@chenxiaosong.com>
 <20260812103945.82495-1-2122295973@qq.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb_check_perm_dacl() validates that the DACL fits inside the NT
security descriptor, but then bounds its two ACE walks by the
remaining NTSD length (acl_size) rather than the DACL's declared
size (pdacl_size).

When pdacl->size is smaller than the trailing NTSD buffer, bytes
after the declared DACL boundary - still inside the stored security
descriptor - are parsed as ACEs during access checks.  A crafted
DACL can place an access-granting ACE beyond pdacl->size, and the
current code accepts it during SMB2_CREATE access validation, while
parse_dacl() and smb_inherit_dacl() stop at pdacl_size.

Bound both ACE walks by pdacl_size to match the DACL boundary
semantics used elsewhere in the server.

Validation (KUnit, UML, x86_64, KASAN; first KUnit tests for
fs/smb/server, see follow-up patch):
- ksmbd_dacl_walk_must_stop_at_declared_size (semantic harness):
  with the current code the ACE placed after pdacl->size is
  selected and access is granted; with the fix the same sample
  is denied (EACCES).
- ksmbd_smb_check_perm_dacl_boundary (drives the real function):
  passes with the fix; fails with the fix reverted (rc == 0).
- ksmbd-for-next-next (rebased, base e9d76059ff03), x86_64

Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()")
Signed-off-by: Hang Nan <2122295973@qq.com>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index b5db6dcfbaa4..8ad2e5a5cca8 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1494,7 +1494,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 
 	if (*pdaccess & FILE_MAXIMAL_ACCESS_LE) {
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = acl_size - sizeof(struct smb_acl);
+		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 			if (aces_size < offsetof(struct smb_ace, sid) +
 			    CIFS_SID_BASE_SIZE)
@@ -1551,7 +1551,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, const struct path *path,
 	}
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = acl_size - sizeof(struct smb_acl);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 		if (aces_size < offsetof(struct smb_ace, sid) +
 		    CIFS_SID_BASE_SIZE)
-- 
2.47.3

