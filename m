Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196261B2EFB;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735684630; cv=none; b=OUJ2BEpnbEz2cO4e2kJtw6R4czZxFLZudpUNRVmJRUWRJm3+vsQWgII59JgYUYX/nzBqtYdWZzoEnAcdNb1omGY1s9q/LPoe6DflG0VVTtCYcSzlzC7tD6icjPTePHHPbuNer68gV06uUWM+4RlpgQ3KtQw2Q3cxFoH4JGw1aKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735684630; c=relaxed/simple;
	bh=6GSndX9vgk1Jj7hX2LSrDyaH6Z1T2mZF8OG3lq2E9Yo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nW+19J1A/cCLOFCh2gOobRKQd+gdjE3dvEIzizo/czZKnPyYUazP5gvORMn/V5cqNORYnhfS8SKaTzTWi4+Q/bu7c4Tmw8nZhxDj0kIslHrKYkIx6RNeMNbLlEad8RZZ5qLPwG31+rUG6o8lXkbOAYDQFGUY7aKVPYY8459XlVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2/cBQpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2/cBQpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDEFC4CED6;
	Tue, 31 Dec 2024 22:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735684629;
	bh=6GSndX9vgk1Jj7hX2LSrDyaH6Z1T2mZF8OG3lq2E9Yo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2/cBQplPCrFqdBs0EfzoJG6/668qmnaEAwXcB9bRNo1hqv6aPp4aMlwUzGFhJX6/
	 EsZX01WBSYz11BQSodzhAifOGWlcbtKpVRzL7yLeex4alTck+m1EveWVnv9Bk6O15K
	 iEqasx5NUFeVdG+1qDagHSwu1jzO5VWs3WYBNoVtVvW3ONH8hWS10Fdcebyp3SxJyi
	 ewcbR80WU5uE0VVBMwp7jfwAkWH3Pqtfd1aPpr5gif51Z1FA4F7NvDlMgvEpipY6CV
	 5ayHUwnfo2DuyL0JDw4Xe60BcpDPdyd744IlW7aoX5gaL0sUqwQdRDfYV1nUjo5No+
	 kqniKm0hDKs0Q==
Received: by pali.im (Postfix)
	id 601A6983; Tue, 31 Dec 2024 23:37:00 +0100 (CET)
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To: Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/12] cifs: Fix calling CIFSFindFirst() for root path without msearch
Date: Tue, 31 Dec 2024 23:36:32 +0100
Message-Id: <20241231223642.15722-2-pali@kernel.org>
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

To query root path (without msearch wildcard) it is needed to
send pattern "\" instead of "" (empty string).

This allows to use CIFSFindFirst() to query information about root path.

Signed-off-by: Pali Rohár <pali@kernel.org>
---
 fs/smb/client/cifssmb.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 604e204e3f57..7c42a0651138 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -4108,6 +4108,12 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			pSMB->FileName[name_len] = 0;
 			pSMB->FileName[name_len+1] = 0;
 			name_len += 2;
+		} else if (!searchName[0]) {
+			pSMB->FileName[0] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[1] = 0;
+			pSMB->FileName[2] = 0;
+			pSMB->FileName[3] = 0;
+			name_len = 4;
 		}
 	} else {
 		name_len = copy_path_name(pSMB->FileName, searchName);
@@ -4119,6 +4125,10 @@ CIFSFindFirst(const unsigned int xid, struct cifs_tcon *tcon,
 			pSMB->FileName[name_len] = '*';
 			pSMB->FileName[name_len+1] = 0;
 			name_len += 2;
+		} else if (!searchName[0]) {
+			pSMB->FileName[0] = CIFS_DIR_SEP(cifs_sb);
+			pSMB->FileName[1] = 0;
+			name_len = 2;
 		}
 	}
 
-- 
2.20.1

