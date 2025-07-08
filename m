Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACCFF9E8;
	Tue,  8 Jul 2025 16:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992788; cv=none; b=TA9Vs9lvKv37Q3Fr82iTUlgp8tmnGnrTlzWC/YIO1zvS78VcUEd40cdAJKLk7iVG+bv9NOtnUbLBtuT8u0uWdDIQxLHHuAi6/wYeRRGE9Lr+i3RAVNX8cy8/EVWE90/sGmbAS/hyij9xgiltwGbN9tfEarEGzBVfg+zRkqutKNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992788; c=relaxed/simple;
	bh=mc1527awR/yCeE2gxr/wRZEOb1D2fRNoLwSaQ35//y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aBqYkrbRfwm22SQ4/pLUvivimQwPpkFH6w6NC1t6dgec4xUbjsZ8EpGI3CmY3XGcoGlmdTVoPE4FO90IbEXSqzU40n3WlrfMGNTnmlNeGMQSMlUtcPkAciQd9IuZgLRl/IZPEHzFlhV4yt79lLSpVWUOxNGYOVwt5s0X/wLYyPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDTEsd6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDTEsd6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6112FC4CEED;
	Tue,  8 Jul 2025 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992787;
	bh=mc1527awR/yCeE2gxr/wRZEOb1D2fRNoLwSaQ35//y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDTEsd6zQJQrxl3uwB2gOIU8m6wZXMqneIE7AVXVQPHbr0u7PAjiEfAvcreey4Ywp
	 +J9UEUMKIU+EW+1Bfw4zMCN+LGjNqSqkRd6U7qqszmvAcqp0Ab9j4ZXxpI7xBP/7WJ
	 SzwfIr4DGNzrtGjHU2hqUCeNyId7Ct3oGoF04eTU=
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
Subject: [PATCH 6.12 081/232] smb: client: set missing retry flag in smb2_writev_callback()
Date: Tue,  8 Jul 2025 18:21:17 +0200
Message-ID: <20250708162243.571907644@linuxfoundation.org>
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
index 3e501da62880c..d514f95deb7e7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -4869,6 +4869,7 @@ smb2_writev_callback(struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
-- 
2.39.5



