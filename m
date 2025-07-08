Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EB621C190;
	Tue,  8 Jul 2025 16:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993521; cv=none; b=NDTPux7AdDXQojQQZQBWCNQPDe/j9YsQH6nt9O3Qud7DRqcQCAjdhmYqt6wGFg62CvSb/fXc0Qm+/eTXcL+CZfmHvzdk3KD1Gmq+atfdFsP67/LuTc2Tw42hWrwbhWkATCIdF/JOpJm8QZlcFJ6TNap/QKKZtaC1P7eYtRs4oXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993521; c=relaxed/simple;
	bh=FEgjMhaEwM3sWKyCXp63yzvZj7n5Z6otil2ujghYUAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbDEPqrvygj9r/gb5gjGHrQ7l0959Pd7tYGBL7/fSYRC8Rv5ujyzwm9nokgHO64thIV/KPOiy6U9DaNXTlxQibnMDUaCTHyDv2l6ie+DFZrWuhlZ1eJq6mvXEq4N+bqgL31YTd9kOjuFSpziX0sFMCZ45AUOIEYk1NdTSdKqi9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ii/MD5CA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ii/MD5CA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B0FFC4CEED;
	Tue,  8 Jul 2025 16:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993521;
	bh=FEgjMhaEwM3sWKyCXp63yzvZj7n5Z6otil2ujghYUAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ii/MD5CAapWKd1cXHcJPVVm+UqnzxSodeVyxXeHazWV9YX8ncvAEG2WsOb0z9ZyHc
	 WqjN/o9VvZoUnuWTO+mO1P7d19tm7B1AnU65F6KjDODTXaBHVbmZcryr+D+pPWvjyd
	 2aAhwj4rUc6oPSqeNZeyqlrmNR2bhbGnmXD4YJsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 101/178] smb: client: set missing retry flag in cifs_readv_callback()
Date: Tue,  8 Jul 2025 18:22:18 +0200
Message-ID: <20250708162239.286276606@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit 0e60bae24ad28ab06a485698077d3c626f1e54ab ]

Set NETFS_SREQ_NEED_RETRY flag to tell netfslib that the subreq needs
to be retried.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/20250701163852.2171681-8-dhowells@redhat.com
Tested-by: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: netfs@lists.linux.dev
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index 7216fcec79e8b..f9ccae5de5b88 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1335,6 +1335,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
+		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 		rdata->result = -EAGAIN;
 		if (server->sign && rdata->got_bytes)
 			/* reset bytes number since we can not check a sign */
-- 
2.39.5



