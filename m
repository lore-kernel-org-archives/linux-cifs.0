Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DCB2045B5;
	Tue,  8 Jul 2025 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993519; cv=none; b=fWEZX5KvXWaj9zCAWycZuYu6bl/3oQntpaLCDIizIKJva9sEESojy4umEnzBxJzPcw3mvkYhMhflRNgzuLP+qqfy2LPxHTFEMp1YWgmHglXu7zVSuAUklUxiSKUItl81ELvhCCyXpIjQh3LFqXCPmNgb4T4gbd6al9jrYPZ69vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993519; c=relaxed/simple;
	bh=ObhDK+T/yB1fnH0TV0t5DME3vgPybpTw3Kwu5rWKmG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4N2b5BVzhPVul+MhdOwn3ykJGw6DY5tSTxXnoTffgzQshqkv7sEuv8HMBbTlrh69+AkzfWc64TBlcf1gu4ArOYjrdfBwynBeMOTz0HzSaa24hqJsfT1IqHIUtqq0FsSThMFGOXep1Qfu5OLZprx5mLK3cn9qcSl+3RsVn97zAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U3MjcyYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U3MjcyYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72630C4CEED;
	Tue,  8 Jul 2025 16:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993518;
	bh=ObhDK+T/yB1fnH0TV0t5DME3vgPybpTw3Kwu5rWKmG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U3MjcyYRLUrUCEFOQW/cy56iictqx975Ugw2MU6LsNrOq6FLd/lpymgOpCBEVGAQN
	 6ivlxfUtMGw9K2YJb7MxqEF8LaortfitfLZErNr47S3z6t07aqh9y2omWrwAtS7zQW
	 1S1Qfwuld91ZCK6YyL+rF4LPHIcD7meTYk/UmXsE=
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
Subject: [PATCH 6.15 100/178] smb: client: set missing retry flag in smb2_writev_callback()
Date: Tue,  8 Jul 2025 18:22:17 +0200
Message-ID: <20250708162239.262018008@linuxfoundation.org>
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

[ Upstream commit e67e75edeb88022c04f8e0a173e1ff6dc688f155 ]

Set NETFS_SREQ_NEED_RETRY flag to tell netfslib that the subreq needs
to be retried.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/20250701163852.2171681-7-dhowells@redhat.com
Tested-by: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: netfs@lists.linux.dev
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index c3b212175b2bf..2c0cc544dfb31 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4852,6 +4852,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
-- 
2.39.5



