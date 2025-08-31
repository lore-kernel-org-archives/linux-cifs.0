Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31BCD26CE10;
	Sun, 31 Aug 2025 12:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756643799; cv=none; b=qNPs2h73ica405aMSgnnv0lnoxUG4rqPYI+duep5Z4/I0fCTFhDtOnhQrKITrBHxrDSco/IQG9EbEyDzX6FKq0dPS5NZH8vpXhsfKmDW2if9RZ/hwpQIfliQxKl+/60R7z6EO8HKCrFj6YuRHPoFL4Lm506JWnVQ8iZOmjxGf24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756643799; c=relaxed/simple;
	bh=YrTaPphT5xReaVE8kxQXjKTYVGCfayvzY3KlTdv2IHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MqB/RBSlgZI+2wNe+jnYaSUo8dMxx+QDxl+zStnOLQk8OnIzAuxhnCCjeUZh/WWTZxSdhcMfQdrnB1PE7Xl8Y8gD4ZwNY8h1cRQ+HTjzPkLllha+V0KipIK/uf3enDmgO6uy4+x6/B5veV+FkrJVnlb/9XJDLbQmypTy3uPJQ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p6x9YeaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p6x9YeaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5FE9C4CEF5;
	Sun, 31 Aug 2025 12:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756643799;
	bh=YrTaPphT5xReaVE8kxQXjKTYVGCfayvzY3KlTdv2IHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p6x9YeaW/zV80Ir81y5JZ1Ky2z8zgJyRNR1fV990lpQ2820WC8kzFKyioneXoeEo7
	 R+2w5bqLvKih3rPPiNhqSPk2LeKeIxlWrw2x/g3x8j9ETv/thUgDiMPGrWibNpT3ni
	 Lmy+W8tCpbaEcH9aYCbCW+1djxGFKZ+QDClVqDrvYlJcytcyv7OdFCayOHT4yIsKfP
	 vvcaMwxeoLdTq0Av63ccDZthE549jYBFafo/1rs0ZAZ112MAM6SMAh/te7xjCi9PaN
	 QqMQqBNdO2hNR/VirnLwTEv7rqmn6j7jAiCap7E/15KyG8hl67VgS+Fkx1YsmJeTmi
	 P+znM+o8YIfvA==
Received: by pali.im (Postfix)
	id D6523D58; Sun, 31 Aug 2025 14:36:34 +0200 (CEST)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>,
	ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 21/35] cifs: Propagate error code from CIFSSMBSetFileInfo() to cifs_rename_pending_delete()
Date: Sun, 31 Aug 2025 14:35:48 +0200
Message-Id: <20250831123602.14037-22-pali@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250831123602.14037-1-pali@kernel.org>
References: <20250831123602.14037-1-pali@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Function CIFSSMBSetFileInfo() setting the file to the delete pending state,
the core part of the cifs_rename_pending_delete() functionality.

So do not mask error code from CIFSSMBSetFileInfo() function and properly
propagate it to the caller of cifs_rename_pending_delete().

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/inode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
index 63ab233517f2..b0526787138d 100644
--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -1822,10 +1822,8 @@ cifs_rename_pending_delete(const char *full_path, struct dentry *dentry,
 		 */
 		if (rc == -ENOENT)
 			rc = 0;
-		else if (rc != 0) {
-			rc = -EBUSY;
+		else if (rc != 0)
 			goto undo_rename;
-		}
 		set_bit(CIFS_INO_DELETE_PENDING, &cifsInode->flags);
 	}
 
-- 
2.20.1

