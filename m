Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4579531DD87;
	Mon, 27 Oct 2025 19:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593283; cv=none; b=OBS0oieaJVbcF5J2IxNW0fht7K7MyVVogM1Md2X2o6zsoL7ntY5qA5XJ1O1Q0g0qNpaGvpn/4RP/JR6G4jINYEEfVn2ykjfbJKOJl8YV8BYwTef6Feo53BJoOH3TRi3sExew/BqpTmTpnd6RGVKE2fnsJtZVFPIOi+XesJEdH3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593283; c=relaxed/simple;
	bh=TXuUnWlzNKxSGoX5ebTMUOkkKI7LH6gbCbbP2Kf/l+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhMIg07i9o2CwKWg5iqwtOJ4FqYqK9CXNS6GSQ9FG5X+ceQXjvYgB4MIqeGJmRWdcd0vz/1tC0BLoHzCqzN9MhoW8Leivx5GR6ezWeWv7z/EDVLa/XIBP9vfMFS/8uMa5ldxFkEoyU2BHs035yMEWyKMZh2Tdsh+b2BrY3WdRJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtE4o9+S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtE4o9+S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E46C4CEF1;
	Mon, 27 Oct 2025 19:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593282;
	bh=TXuUnWlzNKxSGoX5ebTMUOkkKI7LH6gbCbbP2Kf/l+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtE4o9+StUojxLAHMsUTfNKT7c8l4nvkXq/FYFnYaL6FqbOu6dPbDNNRK14yk6SKm
	 bj2mqNMqpj4In9JwXjs5RLXAmkN1JX/jrTQNxAbYwsqynx9R46LblHsw4FVMSOpnzw
	 izY/Br+m7WkXC8AkEA3iN3ySZyi8yW2uXKZhdrUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 084/184] smb: client: get rid of d_drop() in cifs_do_rename()
Date: Mon, 27 Oct 2025 19:36:06 +0100
Message-ID: <20251027183517.158747736@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 72ed55b4c335703c203b942972558173e1e5ddee upstream.

There is no need to force a lookup by unhashing the moved dentry after
successfully renaming the file on server.  The file metadata will be
re-fetched from server, if necessary, in the next call to
->d_revalidate() anyways.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Reviewed-by: David Howells <dhowells@redhat.com>
Cc: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/inode.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/fs/smb/client/inode.c
+++ b/fs/smb/client/inode.c
@@ -2484,11 +2484,8 @@ cifs_do_rename(const unsigned int xid, s
 	}
 #endif /* CONFIG_CIFS_ALLOW_INSECURE_LEGACY */
 do_rename_exit:
-	if (rc == 0) {
+	if (rc == 0)
 		d_move(from_dentry, to_dentry);
-		/* Force a new lookup */
-		d_drop(from_dentry);
-	}
 	cifs_put_tlink(tlink);
 	return rc;
 }


