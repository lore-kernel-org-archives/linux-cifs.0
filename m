Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F2A388E57
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 07:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028635; cv=none; b=skY4OIbUiMYmxI2rSAPnpkc3LeueY28MFllcDuVupnt9vtazVQUxmWq4+fliI+EMN9y/i8zRU3akiYiYgtYBr3IXZLu6w6SiqO6jxUKojI0stAlkatEFIGGXMqZR/YQ0S+UzIiMqHVfw/qS23yLXDo2TgAN0Zlqxd+gDDvINUJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028635; c=relaxed/simple;
	bh=DbGkvFwlbrgs+fz42YuEcrFRmqkD3VrsX/Nb79mX91Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+loQw/ZeMbADKPzbKhUjhyx9nNTCKvpxiVPwJ8MffHHLaO2Q+JIeM+O9N1qYS698fHTXuFcFoMYVuoucZsTQBy7LGkLSAXi1pCohrl/UxOfB6RuN7Tr7dMxyM4d9PVjTQarnbeGCntOSS2w8rnZVY805cMmvr9pBToFRcT4F9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qSflNCQp; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qSflNCQp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iUo4twWGNV6iwtSZoWncM1mTAfGi4f/KFoB3iiXSk8k=;
	b=qSflNCQpCB1Q77KKeuDss8y7fBqIPW6yxfSXGlSzwxmBQ0IX2a/ve+YA1awJs6WW9WSFg2
	h5v3W+anXEwICEv9ZjXKoD8PXywGMVBf/OI2TYBWH9AGXGxWq19lUf2BgGJFEa/imGi79D
	oKwwZDJlQAqrg20mXkoy94iHsOYlzjU=
From: huiwen.he@linux.dev
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	senozhatsky@chromium.org,
	dhowells@redhat.com,
	chenxiaosong@kylinos.cn,
	chenxiaosong@chenxiaosong.com,
	tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org,
	Huiwen He <hehuiwen@kylinos.cn>
Subject: [PATCH v2 04/12] smb/client: refactor ntstatus_to_dos() to return mapping entry
Date: Wed,  1 Apr 2026 07:29:04 +0000
Message-ID: <20260401072912.355072-5-huiwen.he@linux.dev>
In-Reply-To: <20260401072912.355072-1-huiwen.he@linux.dev>
References: <20260401072912.355072-1-huiwen.he@linux.dev>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Huiwen He <hehuiwen@kylinos.cn>

Refactor ntstatus_to_dos() to return a pointer to the mapping entry
instead of using output parameters. This allows callers to access all
fields of the entry directly.

In map_smb_to_linux_error(), integrate the printing logic directly
to avoid redundant lookups previously performed by cifs_print_status(),
which is now removed.

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 51 ++++++++++++++----------------------
 1 file changed, 19 insertions(+), 32 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index 53313b39d1de..c906f233ac64 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -116,41 +116,19 @@ static const struct ntstatus_to_dos_err ntstatus_to_dos_map[] = {
 	{0, 0, 0, NULL}
 };
 
-/*****************************************************************************
- Print an error message from the status code
- *****************************************************************************/
-static void
-cifs_print_status(__u32 status_code)
-{
-	int idx = 0;
-
-	while (ntstatus_to_dos_map[idx].nt_errstr) {
-		if (ntstatus_to_dos_map[idx].ntstatus == status_code) {
-			pr_notice("Status code returned 0x%08x %s\n",
-				  status_code, ntstatus_to_dos_map[idx].nt_errstr);
-			return;
-		}
-		idx++;
-	}
-	return;
-}
-
-
-static void
-ntstatus_to_dos(__u32 ntstatus, __u8 *eclass, __u16 *ecode)
+static const struct ntstatus_to_dos_err *
+ntstatus_to_dos(__u32 ntstatus)
 {
 	int i;
 
 	/* Check nt_errstr to allow mapping of NT_STATUS_OK (0) */
 	for (i = 0; ntstatus_to_dos_map[i].nt_errstr; i++) {
 		if (ntstatus == ntstatus_to_dos_map[i].ntstatus) {
-			*eclass = ntstatus_to_dos_map[i].dos_class;
-			*ecode = ntstatus_to_dos_map[i].dos_code;
-			return;
+			return &ntstatus_to_dos_map[i];
 		}
 	}
-	*eclass = ERRHRD;
-	*ecode = ERRgeneral;
+
+	return NULL;
 }
 
 int
@@ -172,11 +150,20 @@ map_smb_to_linux_error(char *buf, bool logErr)
 		/* translate the newer STATUS codes to old style SMB errors
 		 * and then to POSIX errors */
 		__u32 err = le32_to_cpu(smb->Status.CifsError);
-		if (logErr && (err != (NT_STATUS_MORE_PROCESSING_REQUIRED)))
-			cifs_print_status(err);
-		else if (cifsFYI & CIFS_RC)
-			cifs_print_status(err);
-		ntstatus_to_dos(err, &smberrclass, &smberrcode);
+		const struct ntstatus_to_dos_err *map = ntstatus_to_dos(err);
+
+		if (map) {
+			if ((logErr && err != NT_STATUS_MORE_PROCESSING_REQUIRED) ||
+			    (cifsFYI & CIFS_RC))
+				pr_notice("Status code returned 0x%08x %s\n",
+					  map->ntstatus, map->nt_errstr);
+
+			smberrclass = map->dos_class;
+			smberrcode = map->dos_code;
+		} else {
+			smberrclass = ERRHRD;
+			smberrcode = ERRgeneral;
+		}
 	} else {
 		smberrclass = smb->Status.DosError.ErrorClass;
 		smberrcode = le16_to_cpu(smb->Status.DosError.Error);
-- 
2.52.0

