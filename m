Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C97835AC23;
	Tue, 10 Mar 2026 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141157; cv=none; b=rZsAin//GW+5mMaARa5xryOrd4Q1Xyhm2Nzn+k5RlQqujJwRfiEff+rxS0EtOJbo21Y/8tvWhZDqiDFg2vtzG2ewuo77JlUuqpozYOmSy5kO1qosirEWs1unmP5CZGhSNkHziHqdLPOCVtCPGwMHKo3I6W7Pct2rPfNNl43kfes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141157; c=relaxed/simple;
	bh=LfJCWiUqfNZdYBdczrwmDuJRVR/cQbefE4NdKbJGua4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tNSPfE+KRreG6VYp+9XqcilZImwSpP1mtQbqnTWMqVstJ6K3wo3ocle/3rkL7Hpvl8lK0ebrS6N51KJ8MhX0C9p8eRn4b8Sh8rH9huB8271cGgylRTRn/kQK7orkXT8OD8ubzttwp9gbdkkhsVcrDEjCWOMJrcfP9A0f2+9EZQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FQAguBuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FQAguBuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641C6C2BC9E;
	Tue, 10 Mar 2026 11:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141157;
	bh=LfJCWiUqfNZdYBdczrwmDuJRVR/cQbefE4NdKbJGua4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQAguBuhCx5gs94R9OBucbQEtLJjJfmsVNk9fgPm9LNPNdNttfYugq3J6+z6Qgs8y
	 E1+WD3xSBYyIJOBPtydrzbsW5GSKNhPmCyot8ctXGp9SXDIHeZcLw16jjmK92beo+d
	 KOzXlsKOK5sFI9K48MpVoE5Vwwiv4OsntmsE7BSt+/QiTWxqZdyn2w0rb4321mHpo2
	 94qWhYE8iLp79laJS1ykqbqiGckKkp03lbXnZNo0Br9LIMpr1Q6kAYbY9RyRva3O+9
	 FQ4O7JoPaLukLn+V8Dl2VxCEojKhOo9JHmy6+fSizE0H0addcFLsvuSaExWXit9/UP
	 fVQCyq1dHGiZA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Thiago Becker <tbecker@redhat.com>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 159/311] smb: client: fix oops due to uninitialised var in smb2_unlink()
Date: Tue, 10 Mar 2026 07:03:26 -0400
Message-ID: <c8b0ad0cccd39352072f483ee6136fa74b299a4d.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paulo Alcantara <pc@manguebit.org>

commit 048efe129a297256d3c2088cf8d79515ff5ec864 upstream.

If SMB2_open_init() or SMB2_close_init() fails (e.g. reconnect), the
iovs set @rqst will be left uninitialised, hence calling
SMB2_open_free(), SMB2_close_free() or smb2_set_related() on them will
oops.

Fix this by initialising @close_iov and @open_iov before setting them
in @rqst.

Reported-by: Thiago Becker <tbecker@redhat.com>
Fixes: 1cf9f2a6a544 ("smb: client: handle unlink(2) of files open by different clients")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 2ded3246600c0..6b0420a5b52a7 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -1208,6 +1208,7 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	memset(resp_buftype, 0, sizeof(resp_buftype));
 	memset(rsp_iov, 0, sizeof(rsp_iov));
 
+	memset(open_iov, 0, sizeof(open_iov));
 	rqst[0].rq_iov = open_iov;
 	rqst[0].rq_nvec = ARRAY_SIZE(open_iov);
 
@@ -1232,14 +1233,15 @@ smb2_unlink(const unsigned int xid, struct cifs_tcon *tcon, const char *name,
 	creq = rqst[0].rq_iov[0].iov_base;
 	creq->ShareAccess = FILE_SHARE_DELETE_LE;
 
+	memset(&close_iov, 0, sizeof(close_iov));
 	rqst[1].rq_iov = &close_iov;
 	rqst[1].rq_nvec = 1;
 
 	rc = SMB2_close_init(tcon, server, &rqst[1],
 			     COMPOUND_FID, COMPOUND_FID, false);
-	smb2_set_related(&rqst[1]);
 	if (rc)
 		goto err_free;
+	smb2_set_related(&rqst[1]);
 
 	if (retries) {
 		for (int i = 0; i < ARRAY_SIZE(rqst);  i++)
-- 
2.51.0

