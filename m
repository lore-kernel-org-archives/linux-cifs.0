Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC7E39099E
	for <linux-cifs@vger.kernel.org>; Wed,  1 Apr 2026 07:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775028638; cv=none; b=Bq4PoLUcZYJN9wBNi0CgrPaM+QkkO7ezWmlbb7Kjyi7TRB3Ylr/hq1k2j3IvCgo3VYvZjW9wY/3Y+FtVVNISRUDO5R7NrzOVzAQ6JqNoQgJypX4vycZ/9EPZr5CVK2pMcOv0jrUA62MrfmmHU2mKOiG4M1yfnS2qp1ohr1tbphU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775028638; c=relaxed/simple;
	bh=fbeMsmYNZRkY2N5ieW0WirGJZxza3fgby715YAHlcfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXvtr1GUQA7TEOS/fluoTLshJwyZdrBhDlExDPf/CAR1JP4ATe24xNokkKJHatJ3wuWpzlWqLYVNylvaF3Ewv4G09SXFeGoctWZsIOQgTrpKr5mFrWVkWe9+rIsU/mgzSTKA410ceae7cVGtncV7+vc3Hm04o95XXy91IvHwhCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LWYLiXD1; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LWYLiXD1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775028635;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=du+NXkaOfLTFRYm2EuLeA6PWyngLDzRbZO9TMnfhov8=;
	b=LWYLiXD1foHPkI8y/z1g87Nc4ECFvTDXPkZUYwPu8/x9cDNfIACll7d4XyjC3ipoX78kS2
	qtTFOWCdjntR+ocGWr7lWqQSe2PxyfrNwg98uGxLxaAentFKEEPR8KjAC7DifbCWQYjGiK
	D3j7rkLKv6HBL72fGPSzBmpOAxOM9kA=
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
Subject: [PATCH v2 05/12] smb/client: use binary search for NT status to DOS mapping
Date: Wed,  1 Apr 2026 07:29:05 +0000
Message-ID: <20260401072912.355072-6-huiwen.he@linux.dev>
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

The ntstatus_to_dos_map[] table is sorted now. Replace the linear search
with binary search to improve lookup performance.

Also remove the sentinel entry as it is no longer needed with ARRAY_SIZE().

Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 fs/smb/client/smb1maperror.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/smb/client/smb1maperror.c b/fs/smb/client/smb1maperror.c
index c906f233ac64..fb985d2fc0d9 100644
--- a/fs/smb/client/smb1maperror.c
+++ b/fs/smb/client/smb1maperror.c
@@ -106,6 +106,19 @@ static const struct smb_to_posix_error mapping_table_ERRSRV[] = {
 /*****************************************************************************
  *convert a NT status code to a dos class/code
  *****************************************************************************/
+
+static __always_inline int ntstatus_to_dos_cmp(const void *_key, const void *_pivot)
+{
+	__u32 key = *(__u32 *)_key;
+	const struct ntstatus_to_dos_err *pivot = _pivot;
+
+	if (key < pivot->ntstatus)
+		return -1;
+	if (key > pivot->ntstatus)
+		return 1;
+	return 0;
+}
+
 /* NT status -> dos error map */
 static const struct ntstatus_to_dos_err ntstatus_to_dos_map[] = {
 /*
@@ -113,22 +126,15 @@ static const struct ntstatus_to_dos_err ntstatus_to_dos_map[] = {
  * sorted by NT status code (ascending).
  */
 #include "smb1_mapping_table.c"
-	{0, 0, 0, NULL}
 };
 
 static const struct ntstatus_to_dos_err *
-ntstatus_to_dos(__u32 ntstatus)
+search_ntstatus_to_dos_map(__u32 ntstatus)
 {
-	int i;
-
-	/* Check nt_errstr to allow mapping of NT_STATUS_OK (0) */
-	for (i = 0; ntstatus_to_dos_map[i].nt_errstr; i++) {
-		if (ntstatus == ntstatus_to_dos_map[i].ntstatus) {
-			return &ntstatus_to_dos_map[i];
-		}
-	}
-
-	return NULL;
+	return __inline_bsearch(&ntstatus, ntstatus_to_dos_map,
+				ARRAY_SIZE(ntstatus_to_dos_map),
+				sizeof(struct ntstatus_to_dos_err),
+				ntstatus_to_dos_cmp);
 }
 
 int
@@ -150,7 +156,7 @@ map_smb_to_linux_error(char *buf, bool logErr)
 		/* translate the newer STATUS codes to old style SMB errors
 		 * and then to POSIX errors */
 		__u32 err = le32_to_cpu(smb->Status.CifsError);
-		const struct ntstatus_to_dos_err *map = ntstatus_to_dos(err);
+		const struct ntstatus_to_dos_err *map = search_ntstatus_to_dos_map(err);
 
 		if (map) {
 			if ((logErr && err != NT_STATUS_MORE_PROCESSING_REQUIRED) ||
-- 
2.52.0

