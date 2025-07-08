Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FFF23A98D;
	Tue,  8 Jul 2025 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992790; cv=none; b=ps32ZkvlD/O3noxj080uw9zkGHiXfMdv1qvYuY+Afiiz8unVDdmYrQMGGHRu89flJJMLMVUXUb1piXnBmBSMrHs8QoPMG0YRSj+tIFHKeaJZnJDaRV+tCOoWmsvo7DyVUD043U79gvcA+WAVR3OjS6vDFm2Nv2YhtX07dHaMWpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992790; c=relaxed/simple;
	bh=IPjXgwwtXWqDDcqeM5/IC82ujLHA2GH5tSH9k2e+Ffk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgVYp/KsEZ8nNLmdutq4IoZPK5HRhSLKWBnzuiZrDt0YO1SHfukhe0L/ELWR7B1Eml3996NRmSDAMDfNrwBL7xtUKeAuVfjM/ROpVs8KPTbvq58pI3mpIP5qqk+pCS2ELjIx4sTaMUVbsHxDXcOsQ5pA1tgj0T/kvkK5q5XbGqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fMFPnirC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fMFPnirC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F584C4CEF0;
	Tue,  8 Jul 2025 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992790;
	bh=IPjXgwwtXWqDDcqeM5/IC82ujLHA2GH5tSH9k2e+Ffk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fMFPnirCNe9fg5Km2Eik2KxXkBSf6QlfAz2660KEhK323BUnIKdAh48uj8U95X0Gu
	 2PcrSFfKmubyUG6EMOywOAkVGXMfT1PruWxarnBKODRoCTdfFyal1MZS0p6yRqtYU+
	 CA0zwpm/jptgtOotAXUOACORVpGuJglqCd/nkj5s=
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
Subject: [PATCH 6.12 082/232] smb: client: set missing retry flag in cifs_readv_callback()
Date: Tue,  8 Jul 2025 18:21:18 +0200
Message-ID: <20250708162243.595940301@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d6ba55d4720d2..449ac718a8beb 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1310,6 +1310,7 @@ cifs_readv_callback(struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
+		__set_bit(NETFS_SREQ_NEED_RETRY, &rdata->subreq.flags);
 		rdata->result = -EAGAIN;
 		if (server->sign && rdata->got_bytes)
 			/* reset bytes number since we can not check a sign */
-- 
2.39.5



