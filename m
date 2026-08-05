Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E0647253B
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 13:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785936774; cv=none; b=bfawwHzoqlRT7H8fYwU3mzAK66yIkmUSpWRo/KotslZXIhxkg7pNuQrBecBQLFAYVCxRhdgecm41u1t/QjUoammajhZ+TD9ZgebIJUVUtdRDw/qrSil+tzi3MY0j/DJx1zQL3LZe+apnjc0qq1g5ZIng+I2/uO9ZpRE61xcg6gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785936774; c=relaxed/simple;
	bh=Y10kD92uCEgz3+CeFDavIb8vClhjskL0axyoxgw1fco=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p9ZuNO3ibCA4MSw+qdrupBmOPgFec9jQv57u0rDXai55j5OtnTNdt49TiVufVYIE5SHESkkUee3DYFnifjYa2TCqJ5yhauXD0zGEValkJVACrly0vIgl3HMRT7voobpe4t0AiiDLvclorvAJmY7gFxSFk5+OPc7l/VxC1xLzCgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=E+qCN1kg; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="E+qCN1kg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785936767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MFWlHBQdFkx0V1GufiY9tEO9IiyeKTxwfZBN6yPQ9Kk=;
	b=E+qCN1kgis8OE8YThd/eOiKoqF4x77BHmBAOYl9MHY9j3JdjC39ulTOm0twGv5iaGNhwsm
	CZAGz/lDO//FSw1kBbuuabUCUK5HKte6YdBZy5+wCk1XA/DMJ+Lx1BnB3kp2D7pU7qfB1B
	IQZUscRGaqqaWPKWE7iW8b7n9mhtqol94R3cbVmS6fg5zvHNunVF+rijjNmayoUmiMroF3
	UHNpHwj+2OvScwnv47ZoBMJ5gJzv0LKlWY9hZeg399xA8+p/Ff73Lrg8khP74P8Nme+kir
	t50uUVCtxy/apprQwHNYYNgY6eXg0mh2dZ7y+vBxfojTGi8Q1naFQyYJqN5V2Q==
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
To: smfrench@gmail.com,
	linkinjeon@kernel.org,
	pc@manguebit.org,
	tom@talpey.com,
	senozhatsky@chromium.org,
	slow@samba.org,
	metze@samba.org
Cc: linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org,
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: [RFC PATCH samba] smbd: deny rename if the destination has non-POSIX opens
Date: Wed,  5 Aug 2026 13:31:45 +0000
Message-ID: <20260805133145.312198-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

Check the destination share mode entries with
has_other_nonposix_opens() before replacing it, and return
NT_STATUS_ACCESS_DENIED if a non-POSIX open exists.

Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 source3/smbd/smb2_reply.c | 48 +++++++++------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

diff --git a/source3/smbd/smb2_reply.c b/source3/smbd/smb2_reply.c
index 6bdc02c2374..c3da096205e 100644
--- a/source3/smbd/smb2_reply.c
+++ b/source3/smbd/smb2_reply.c
@@ -1312,31 +1312,6 @@ static void notify_rename(struct connection_struct *conn,
 	TALLOC_FREE(parent_dir_dst);
 }
 
-struct rename_check_open_state {
-	struct files_struct *dst_fsp;
-	struct file_id fileid;
-};
-
-static struct files_struct *rename_check_open_fn(struct files_struct *fsp,
-						 void *private_data)
-{
-	struct rename_check_open_state *state = private_data;
-
-	if (fsp == state->dst_fsp) {
-		return NULL;
-	}
-
-	if (!fsp->fsp_flags.is_fsa) {
-		return NULL;
-	}
-
-	if (!file_id_equal(&fsp->file_id, &state->fileid)) {
-		return NULL;
-	}
-
-	return fsp;
-}
-
 /****************************************************************************
  Rename an open file - given an fsp.
 ****************************************************************************/
@@ -1483,11 +1458,9 @@ NTSTATUS rename_internals_fsp(connection_struct *conn,
 	}
 
 	if (VALID_STAT(smb_fname_dst->st)) {
-
-		struct rename_check_open_state check_state = {
-			.dst_fsp = smb_fname_dst->fsp,
-		};
-		struct files_struct *found_open = NULL;
+		struct file_id fileid;
+		struct share_mode_lock *dst_lck = NULL;
+		bool has_other_open = false;
 
 		if (!replace_if_exists) {
 			DBG_NOTICE("dest exists doing rename "
@@ -1498,13 +1471,14 @@ NTSTATUS rename_internals_fsp(connection_struct *conn,
 			goto out;
 		}
 
-		check_state.fileid = vfs_file_id_from_sbuf(conn,
-							   &smb_fname_dst->st);
-
-		found_open = files_forall(conn->sconn,
-					  rename_check_open_fn,
-					  &check_state);
-		if (found_open != NULL) {
+		fileid = vfs_file_id_from_sbuf(conn, &smb_fname_dst->st);
+		dst_lck = fetch_share_mode_unlocked(ctx, fileid);
+		if (dst_lck != NULL) {
+			has_other_open = has_other_nonposix_opens(
+				dst_lck, smb_fname_dst->fsp);
+			TALLOC_FREE(dst_lck);
+		}
+		if (has_other_open) {
 			DBG_NOTICE("Target file open\n");
 			status = NT_STATUS_ACCESS_DENIED;
 			goto out;
-- 
2.54.0

