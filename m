Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3433803CD;
	Tue, 10 Mar 2026 11:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142059; cv=none; b=P8LqQQwsMbj4lcSi7R9dQ73LNfXwQ2VyDVecY7D+SGjmLUhGsshYPw3RZNo98ZuyNvhlE9X988gLpvM25ufcHApx7bzYBkFiST7A1hIA3dyIoRIO2HfAmMTKRHHixfzBzUZlUCurP3igutqwjxDRqFSS+1EhCPfsmVFZOs6Iy9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142059; c=relaxed/simple;
	bh=Ri0+cE6oSvCKr3b5/gAtcBM/kTYoPmJmCpTKMkt4+qQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r9IoB7m0Q0GmpFehmtyS+zMhhjTp+Ada/+X8MR7MSWScsrNJix40cpUgA9BAuyQlK2dfOQAiKyqH3xru+WUDCEraR+6L8fcx4gwJJgqPCp4n5zWqFIgoz5LyKoYlmsPXHaombwJV2XqaL1XF98LYO+YMPRTO8XWnFqe3EZb0xjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R8EvHsdl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R8EvHsdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49D9C19423;
	Tue, 10 Mar 2026 11:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142059;
	bh=Ri0+cE6oSvCKr3b5/gAtcBM/kTYoPmJmCpTKMkt4+qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8EvHsdlopEzgMTF9JTvvZxg5ElzeVeNW8mVs+XiOP5tJAamY+uErBHvNpq6lQfRi
	 ffHEC+fMB2XWsbK5kCKSiHXKBuNBZGaBGkOWvPt4fOKZyE2V4LbL/sqgJDvq4s0W/b
	 2tKptv9V3jrgB+0qJ9lR///SodbbwkMVSw2LwzhCTa33SSMjTsVmE+zmN78Ll0slFt
	 elNF6mU7Ls1AgvCx6qbspQdpwDf5TKwE/uLEPVbe1u83tm+cRIwFhC56lgyz8jlpN5
	 C6JP8UDKVboPE7AlEsI9KEFAaovv09094yf/hO/guE+BFeYL006ZDw4yTiUTcTAAPp
	 X16QccONG48AA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Paulo Alcantara <pc@manguebit.org>,
	Xiaoli Feng <xifeng@redhat.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 185/314] smb: client: fix broken multichannel with krb5+signing
Date: Tue, 10 Mar 2026 07:17:24 -0400
Message-ID: <9f7fecaae0110f6d285ee00e1acdcf1c378974aa.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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

commit d9d1e319b39ea685ede59319002d567c159d23c3 upstream.

When mounting a share with 'multichannel,max_channels=n,sec=krb5i',
the client was duplicating signing key for all secondary channels,
thus making the server fail all commands sent from secondary channels
due to bad signatures.

Every channel has its own signing key, so when establishing a new
channel with krb5 auth, make sure to use the new session key as the
derived key to generate channel's signing key in SMB2_auth_kerberos().

Repro:

$ mount.cifs //srv/share /mnt -o multichannel,max_channels=4,sec=krb5i
$ sleep 5
$ umount /mnt
$ dmesg
  ...
  CIFS: VFS: sign fail cmd 0x5 message id 0x2
  CIFS: VFS: \\srv SMB signature verification returned error = -13
  CIFS: VFS: sign fail cmd 0x5 message id 0x2
  CIFS: VFS: \\srv SMB signature verification returned error = -13
  CIFS: VFS: sign fail cmd 0x4 message id 0x2
  CIFS: VFS: \\srv SMB signature verification returned error = -13

Reported-by: Xiaoli Feng <xifeng@redhat.com>
Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/smb2pdu.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index 1ef82408ecad6..58238e65c7edf 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1650,19 +1650,17 @@ SMB2_auth_kerberos(struct SMB2_sess_data *sess_data)
 	is_binding = (ses->ses_status == SES_GOOD);
 	spin_unlock(&ses->ses_lock);
 
-	/* keep session key if binding */
-	if (!is_binding) {
-		kfree_sensitive(ses->auth_key.response);
-		ses->auth_key.response = kmemdup(msg->data, msg->sesskey_len,
-						 GFP_KERNEL);
-		if (!ses->auth_key.response) {
-			cifs_dbg(VFS, "Kerberos can't allocate (%u bytes) memory\n",
-				 msg->sesskey_len);
-			rc = -ENOMEM;
-			goto out_put_spnego_key;
-		}
-		ses->auth_key.len = msg->sesskey_len;
+	kfree_sensitive(ses->auth_key.response);
+	ses->auth_key.response = kmemdup(msg->data,
+					 msg->sesskey_len,
+					 GFP_KERNEL);
+	if (!ses->auth_key.response) {
+		cifs_dbg(VFS, "%s: can't allocate (%u bytes) memory\n",
+			 __func__, msg->sesskey_len);
+		rc = -ENOMEM;
+		goto out_put_spnego_key;
 	}
+	ses->auth_key.len = msg->sesskey_len;
 
 	sess_data->iov[1].iov_base = msg->data + msg->sesskey_len;
 	sess_data->iov[1].iov_len = msg->secblob_len;
-- 
2.51.0

