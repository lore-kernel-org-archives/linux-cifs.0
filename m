Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E62D27B340;
	Mon, 23 Mar 2026 16:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282281; cv=none; b=cQ4PgzmfCx0xXaGmZ81KlF8CftWvLmbwwTGQRY3v3IR5kqRTxl/tAr0mQo7iVBW8ChMsgrocGcI0uc0yKCPTOMBTH6OYXn+tEbQH5CaiomPf4dM7fVJVIpPCq+ufRawIYvHLtja+Dz8oKiAMP0YbX0dZKV2Juiw1g0mDKDXPJhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282281; c=relaxed/simple;
	bh=NhCf3Uq2XdDay+pOToS++ou2A9QG8o5zcR0KSKSSrjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+abXdHjmwN6I/17xQEoWqeyfPUzGs3p0ml5WF183P1GH3xC/S7myh4bS/AP61yF0N+SMgNP6Dkfvp39KPAiCuXooQf9U5ECsmvw56+UaZ9buvdNUg0cm1NOZYkBVjW3EmaI/Jj5xHAeqy91csvJegiyvjRP0/h2yIej9i/Cd/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY5yg7y9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY5yg7y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B33C4CEF7;
	Mon, 23 Mar 2026 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282280;
	bh=NhCf3Uq2XdDay+pOToS++ou2A9QG8o5zcR0KSKSSrjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mY5yg7y9pzGCz+sS9uKg7m/HJrRcQvUlWtppe2/REywR9k18dbg042aMqZw9wn/Hd
	 JCxaUsbDwcoJ9JZ7DRylZNu/3kdocUDkulKxrdPLUv2Hm9GO9I6yWZY2AgGQvQsk5v
	 1y8cb5ShyFHhtMr9by6LjpqZ3CSmSzLj3YJXPdZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoli Feng <xifeng@redhat.com>,
	Enzo Matsumiya <ematsumiya@suse.de>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 091/481] smb: client: fix broken multichannel with krb5+signing
Date: Mon, 23 Mar 2026 14:41:13 +0100
Message-ID: <20260323134527.496502676@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 fs/smb/client/smb2pdu.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -1484,19 +1484,17 @@ SMB2_auth_kerberos(struct SMB2_sess_data
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


