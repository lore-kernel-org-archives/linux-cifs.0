Received: from out-185.mta1.migadu.com (out-185.mta1.migadu.com [95.215.58.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF82367B65
	for <linux-cifs@vger.kernel.org>; Thu,  6 Aug 2026 00:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785977223; cv=none; b=rd2NBkrvjuUAoVek4nZ+zXATJA0LnUPl49e2ifubVvb+GTDplZJ3UaARdXF+rYedGUitw4wsCXA/nW1/1CIZLbMdenqIHrI6LPQaSYUhiVZeiqIyZk42BXd9iNAGLZCzrXragTf2ZWJ8HGvuwhUAYwcU3spQXeGtvTFt7Dbstdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785977223; c=relaxed/simple;
	bh=e0TIsR/wnj7uHKNuLZkeTxWYkHtcegBtz5Gwwa0AUQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LWQE5I5Ny7zy++OT0DhKnaYaNSplFqp/2CLp+sIx0iWnafKdRvEqO49auwtn6bvphLb+c5F231qxrKMR9wrnfe4jQdeNmbdW1x29H6xYxfp/gBThf5td8a+PXBD8pQ3nIFL48SfU68VOsI3dbPDD3A/6Xs6JCTulyvwNKaIiBdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=Dv5+e2cq; arc=none smtp.client-ip=95.215.58.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="Dv5+e2cq"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1785977217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KflPyz73AKn5AV7jq0tEqiYipV2WwRZAzqFMBL4SJkE=;
	b=Dv5+e2cqv4yZ7nL3QeqvUrn+x/pmdqorHbNUsXsRIRPbDiEPMs4QF4U4lom9T+O81do6Je
	MaxYf8uCgY5hGMoCZe5BQMSNukK6Ek2ffLt/dxVKBs3q29sB+8u5MOaFefWpuHe1u+WmIl
	/6PTzQfFoc73/aAXsMWlxJND2oGnj5uRjNswx+QcfkaA7+x6wtWnAaoiw4aoWajnWp2dLN
	HNDXRWMZl8O5OtjujeKpqY2xqPYaYndwShJKsW4EBU7QC8asMDbIHyGuFmenSGfP/IDKrn
	VxcDae3UsONl9CxO6xTMf7mg0p5Azc+igNC2Q0gFOMHeRuEGi1cBSx+ZsQ3y0w==
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
Subject: [PATCH samba 1/1] smbd: remove redundant rename destination open check
Date: Thu,  6 Aug 2026 00:46:01 +0000
Message-ID: <20260806004601.314121-2-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260806004601.314121-1-chenxiaosong@chenxiaosong.com>
References: <20260806004601.314121-1-chenxiaosong@chenxiaosong.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: ChenXiaoSong <chenxiaosong@kylinos.cn>

It already checks the destination in smbd_smb2_setinfo_rename_dst_check()
or smbd_smb2_setinfo_rename_dst_delay_done().

Link[1]: https://lore.kernel.org/linux-cifs/0f6a5c9c-2c65-480e-aa44-facdf11fecc0@samba.org/
Link[2]: https://lore.kernel.org/linux-cifs/a6a6913b-7a85-48a8-ba65-13fae188c33b@samba.org/
Suggested-by: Ralph Boehme <slow@samba.org>
Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
---
 source3/smbd/smb2_reply.c | 43 ---------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/source3/smbd/smb2_reply.c b/source3/smbd/smb2_reply.c
index 6bdc02c2374..5209c0046de 100644
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
@@ -1483,12 +1458,6 @@ NTSTATUS rename_internals_fsp(connection_struct *conn,
 	}
 
 	if (VALID_STAT(smb_fname_dst->st)) {
-
-		struct rename_check_open_state check_state = {
-			.dst_fsp = smb_fname_dst->fsp,
-		};
-		struct files_struct *found_open = NULL;
-
 		if (!replace_if_exists) {
 			DBG_NOTICE("dest exists doing rename "
 				   "%s -> %s\n",
@@ -1497,18 +1466,6 @@ NTSTATUS rename_internals_fsp(connection_struct *conn,
 			status = NT_STATUS_OBJECT_NAME_COLLISION;
 			goto out;
 		}
-
-		check_state.fileid = vfs_file_id_from_sbuf(conn,
-							   &smb_fname_dst->st);
-
-		found_open = files_forall(conn->sconn,
-					  rename_check_open_fn,
-					  &check_state);
-		if (found_open != NULL) {
-			DBG_NOTICE("Target file open\n");
-			status = NT_STATUS_ACCESS_DENIED;
-			goto out;
-		}
 	}
 
 	status = can_rename(conn, fsp, attrs);
-- 
2.54.0

