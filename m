Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B7D2045B5;
	Tue,  8 Jul 2025 16:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993638; cv=none; b=sPcVOizIqylRYRBWsQ/yPKoyTmziZOwF2CqSkyGkW0hOT9pcR0IrSf6bGvqatfxdjOCJ/7e1QYQTn+cpTGh2ptkvcKFzL95HFeM/DErC0/rikby9uhQlK1HT0GLvsmzDyWfYE/+MWUzKP3BYETgoasYHiGXJwopDEcA9hW1tBPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993638; c=relaxed/simple;
	bh=y/Co7S/XZG9D7uYiD1VT2P8hQh94uSAbtc6mNcbnarE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ03TLd2fxkCK4XBg07/L8vozA7Lj8ssX1FmJkHw8OKQb8O8d1ElrzsJFFkv5ERm+o8hg2Cf7Q1srrMksQpUZ9mwO8JbHiA2UngUMRqN3pFBZm2komKMwS6HWkhzUJiElSBWM9YSnCDZXK596c8av34QWWxMBE6VhYodIofCoOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGw7CMUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGw7CMUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EA2C4CEED;
	Tue,  8 Jul 2025 16:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993637;
	bh=y/Co7S/XZG9D7uYiD1VT2P8hQh94uSAbtc6mNcbnarE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGw7CMUbRdhxtArONQPfpH9Z5I0ObTFDhjd61yj7aIbIyNMa4jLSNpwLwtxcAWxYx
	 NgRf6ya6PvqVFZz995DCIZlmStRRX9R+OrHSYAggWnUxC3t6B8A/Iw0IQrJt1BgaPO
	 BNi/2KpObE4p13d5lcY4S7fWlbvbME4hVcQoKxCM=
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
Subject: [PATCH 6.15 102/178] smb: client: set missing retry flag in cifs_writev_callback()
Date: Tue,  8 Jul 2025 18:22:19 +0200
Message-ID: <20250708162239.311480572@linuxfoundation.org>
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

[ Upstream commit 74ee76bea4b445c023d04806e0bcd78a912fd30b ]

Set NETFS_SREQ_NEED_RETRY flag to tell netfslib that the subreq needs
to be retried.

Fixes: ee4cdf7ba857 ("netfs: Speed up buffered reading")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/20250701163852.2171681-9-dhowells@redhat.com
Tested-by: Steve French <sfrench@samba.org>
Cc: linux-cifs@vger.kernel.org
Cc: netfs@lists.linux.dev
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/cifssmb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
index f9ccae5de5b88..0e509a0433fb6 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1715,6 +1715,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	default:
-- 
2.39.5



