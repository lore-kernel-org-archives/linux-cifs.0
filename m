Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75D9289E2C;
	Tue,  8 Jul 2025 16:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992796; cv=none; b=m9CY3YKZ7JtGsLf43XxJ/A5HBS1DasH3Q6XTIwXfCCayJZCpf4niVQ+2ICNcpwnW50XAYRQJMokPbmJV6z45q86QY9+rEvGqmiUz1r9uaiADJgm0K2Za04q+qqwIpHfInQJehZpeThdNPNNlURFlBozt4ENY/a2kbTYnYyvKmuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992796; c=relaxed/simple;
	bh=fckYxr5NdA4yFewxeLJp9viFJKPNVeob8ZeTIXCZT5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfJOzCYFgEx2+XpdMuotcZua4O8RJDrJgDSrjZYAo9XGtjdoEKfOiImfakr0z2dzC939EaFrzk0lh1Rk8hSYcb9BO+6Jq4aC7LucZJS+mGy6gbDI5Z5+t0BwK/49SefO13APbMunWTIGtG8zdV6k4AYhCBYpADKJJPsoSAQeNj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWnyYmd9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWnyYmd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5A2C4CEED;
	Tue,  8 Jul 2025 16:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992796;
	bh=fckYxr5NdA4yFewxeLJp9viFJKPNVeob8ZeTIXCZT5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yWnyYmd97IXiKta6hK494z6zdwDc91cIvF6FmyixVLKVXy+LpuUEW4jRf2iAoS06F
	 V1FfwNhIeIDsOTfDRvOwCSQtio5IsvtPVMMHstTd32TUeb5i14gJaqJoF6pG6wPrR9
	 KuryHZFZIfwNL2Ef2d0ZXahIbGcktS5CPDKAxtOc=
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
Subject: [PATCH 6.12 083/232] smb: client: set missing retry flag in cifs_writev_callback()
Date: Tue,  8 Jul 2025 18:21:19 +0200
Message-ID: <20250708162243.621147875@linuxfoundation.org>
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
index 449ac718a8beb..e3d9367eaec37 100644
--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1682,6 +1682,7 @@ cifs_writev_callback(struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 	case MID_RETRY_NEEDED:
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	default:
-- 
2.39.5



