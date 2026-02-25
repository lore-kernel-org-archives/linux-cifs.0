Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B641E26E6F8;
	Wed, 25 Feb 2026 01:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983569; cv=none; b=U57/MWQqJge/EyMpx3IdA8AiUc/yafEPYhOvkq0UCp88az2ABQD2HrA/Z28x79qVpFr4aLG4cxHe8y5wn/zcnAJwB+9F3r/ezDuT+aA/e8YmTe/UoJRp/LyMpyrPhyl6mgnO1QlwH+296HvHONY/FhTILl+vEghLn8A/5vOeGBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983569; c=relaxed/simple;
	bh=N5eQICA58o5uo/PDc9JZqKPovFyK/NOSHC0PCl3NGRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqnXdxw/NAMIBrAHQQN4rQllFZfDhtbAH8vkhlXWV8OcF9ZJtGCIlapVbKLEXbTpMjRa5G6mOP2UQ/fYVoGrguRDkSarGESzIojXkVKV8bRXFsJKjxvxTThNtacmbh8vQnbQJ6uFHC85T6R58dy9/1c+wr4KmZcWkIRvR2tPTfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e+P+xSXk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e+P+xSXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F492C19423;
	Wed, 25 Feb 2026 01:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983569;
	bh=N5eQICA58o5uo/PDc9JZqKPovFyK/NOSHC0PCl3NGRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+P+xSXkYngjvKrrIdz2qFiq2967TGnUFGV4oYXZucDMCv2XWUGZ2RZlnrt8k+wBK
	 h6cMpvX0PHD1yjX4hsrDmo0j8XgkDWnhJIAP4MvZT2wPkv1/q2RXRVfbhwpBsDWRrJ
	 cqWrEGP861H2K3QFbUZ/fDl1+Mgi9U1LCJUr5nsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoli Feng <xifeng@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 627/781] smb: client: fix regression with mount options parsing
Date: Tue, 24 Feb 2026 17:22:16 -0800
Message-ID: <20260225012415.191230749@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 72f4d48034864b93700d1d23fc418d90fa28d7ae ]

After commit 1ef15fbe6771 ("cifs: client: enforce consistent handling
of multichannel and max_channels"), invalid mount options started to
be ignored, allowing cifs.ko to proceed with the mount instead of
baling out.

The problem was related to smb3_handle_conflicting_options() being
called even when an invalid parameter had been parsed, overwriting the
return value of vfs_parse_fs_string() in
smb3_fs_context_parse_monolithic().

Fix this by calling smb3_handle_conflicting_options() only when a
valid mount option has been passed.

Reproducer:

$ mount.cifs //srv/share /mnt -o ${opts}
$ mount -o remount,foo,${opts} /mnt # must fail

Fixes: 1ef15fbe6771 ("cifs: client: enforce consistent handling of multichannel and max_channels")
Reported-by: Xiaoli Feng <xifeng@redhat.com>
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: David Howells <dhowells@redhat.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/fs_context.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
index d4291d3a9a485..2527d2d29f190 100644
--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -826,9 +826,7 @@ static int smb3_fs_context_parse_monolithic(struct fs_context *fc,
 		if (ret < 0)
 			break;
 	}
-	ret = smb3_handle_conflicting_options(fc);
-
-	return ret;
+	return ret ?: smb3_handle_conflicting_options(fc);
 }
 
 /*
-- 
2.51.0



