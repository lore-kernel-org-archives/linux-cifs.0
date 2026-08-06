Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC7D3AA4E2;
	Thu,  6 Aug 2026 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786032329; cv=none; b=lwV+ia74JTfKwvPid9oEr4rxARQIvh37lRs3wHPJyHJYV1S4iMM2yGEIBRoJM7zVXhinoPrWyMKvY5HXA1l0QxU5awnzMxdlTfZfqcwage7xCmf+ATfAgke0ZE+FCfVglbkFlkSLvhYrgUhOErhPj1mby2/T9WvW7lZpPwKKBFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786032329; c=relaxed/simple;
	bh=+kfYdB1dtaHX3QG7YzQpFbConNWalWZE5rD4/KazqH8=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=izHQ3DZBIIMcRqObVtqeJqbMgXKdNIdNhK0nGFYu/liFcNv0RlyJVdr1FlMw7Edqfqupmlfag3mOBbQnQeI+ACj/saeB3J3r7b7rSGyC05T9a3FO3JDHlTy7y2LKuY4qWkkurh4o6dLv4gzZfEbuN/+DFphXCVNIYgS26IZmI3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Cf3pcrm3; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Cf3pcrm3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1786032321; bh=53gov+xpaZ/zOL9NrsicEq2ls8rHLo/IVUBFQKjlfGc=;
	h=From:To:Cc:Subject:Date;
	b=Cf3pcrm36EtInBijYr6Mf4KkdjT7Dz8oAv77ASkOlmiiiOCckJJEJx63ec9ar8H1/
	 S1hJ+HvsYQcaVgZe2wo4t4zV2JWaWwTh8Z+u+IKoj65cL6UmCLDYXh1kItoK1X3eno
	 RCrE0sMKO48svP2VRA24en+sUWzn2anDdjLIb/kY=
Received: from localhost.localdomain ([2001:250:3442:4074:a52d:624e:968c:130d])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 10612283; Fri, 07 Aug 2026 00:04:06 +0800
X-QQ-mid: xmsmtpt1786032246t0l10zskj
Message-ID: <tencent_1C4F8C48E45F6AE9D165CC17B3F620C40C08@qq.com>
X-QQ-XMAILINFO: MllZffuBkEb5BcCJ4LiDd7wBY06+TFnygq69SeBz+FGq5q6ARJFFexQpwsYyuO
	 JLAM/rOWrMVE+6YYKwgHb7wJpX4JRSBlCTSMaSdywuOYMeIMjs1XSAek7357yzpzBNvdEr8yjOIa
	 fFN6oDGp2GHo8hPydzFRhXRD9nATiJAIJezNKUncU+hOt98ueJj0UuqqG/C6gsBUB4lLyvfP5Jsw
	 NNJHXodkMsQVDXC3NvOLz1oqrAg/9kFy0dMlElq1qud5Md+hK01PsN/Wpa8WkmzSx4sf7me111wW
	 C5vx06wmjD5zqXSVJznWw1BlOe9fKnbcYSPAeijNOfOb3xlYc4zAxeZOEtKNDmRosloN89qdz0+p
	 zvbuGGwNGBlbgo30LJUUw42/lGDCf/WyJT0QJAMFBOUCjGwK+yN6NVJhkzTtKOHqIABq5O4D+ugy
	 jVJFvHM4zqEEAjbFGINTTzOlKqM8EHO/Btmh/Tjw205kpeZV3qCiKj8IZsO2Wh29UoPAL/ViDlz+
	 nfABB9fyS35B3O9NUw//Mi4/Mr7LbA3EMzPew6hl2ELTSIbgXUiSq8357lrckvAzX5Sx86XQ5byW
	 Y8jN8tYgzN3NOWsWYkcdutFABmEV6eqxREEaN47oUbT16OMW6dEN06PqchFUvlmYYcDsEIOz+CcG
	 rcGaBdN2A+HIMFHs1HgdrqVm/8cRbMj01ZcbygbienNKwZeRHYpJLwsiSsLindbdtlI4BvW0xv4w
	 6hkeQt/8dI4LKTlWLJztVQTVx0W3a7TMS+9wPz80z0qqsXMhk1kVX5vvhNv2pI6tHTX77H8AfYaE
	 S6A5YzeabiigDQl5o9kMABaXigo09U/SjeKFnm09d1zQoeJ8oqN/MNV32NcOmr/DttIGzLEFkdSw
	 hjR7WRz5cifv65Dem3kbD5DWCar9vkiYM2ab198CUT0nFwroQ0U25WW1fvTmJFwOETqZn69SiqFk
	 WvTDj/HvCFwAxkBZGNETtVYKtYOpucJYn8zEuYmjuDwWSetg8eCI+H1/Y6WFWaRHmtwnsUaDgpKb
	 ma9agn4agtBH9ZGOVYYZw2nXEWU8owuhIAmOOLm9XTxyyxGn+bxVZjdaShgBfMo0vWC7PpZOUnNU
	 wQSRhyo3/8yHoW9TI=
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Hang Nan <2122295973@qq.com>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size
Date: Fri,  7 Aug 2026 00:04:05 +0800
X-OQ-MSGID: <20260806160405.174650-1-2122295973@qq.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ksmbd: bound smb_check_perm_dacl() ACE walks by DACL size

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

Validation:
- semantic KUnit harness shows the post-boundary ACE is selected
  before the fix and rejected (EACCES) after it
- linux master (7.2-rc6), x86_64

Fixes: 8f0541186e9a ("ksmbd: fix heap-based overflow in set_ntacl_dacl()")
Signed-off-by: Hang Nan <2122295973@qq.com>
---
 fs/smb/server/smbacl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/smbacl.c b/fs/smb/server/smbacl.c
index c13f07a09ab8..429ded811f51 100644
--- a/fs/smb/server/smbacl.c
+++ b/fs/smb/server/smbacl.c
@@ -1484,7 +1484,7 @@
 			DELETE;
 
 		ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-		aces_size = acl_size - sizeof(struct smb_acl);
+		aces_size = pdacl_size - sizeof(struct smb_acl);
 		for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 			if (aces_size < offsetof(struct smb_ace, sid) +
 			    CIFS_SID_BASE_SIZE)
@@ -1505,7 +1505,7 @@
 	id_to_sid(uid, sid_type, &sid);
 
 	ace = (struct smb_ace *)((char *)pdacl + sizeof(struct smb_acl));
-	aces_size = acl_size - sizeof(struct smb_acl);
+	aces_size = pdacl_size - sizeof(struct smb_acl);
 	for (i = 0; i < le16_to_cpu(pdacl->num_aces); i++) {
 		if (aces_size < offsetof(struct smb_ace, sid) +
 		    CIFS_SID_BASE_SIZE)

-- 
2.47.0

