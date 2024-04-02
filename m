Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C64A15B96C
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 19:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712086502; cv=pass; b=X8jkUl4ddd9ZXbhTXIS1E7LMiM9Y+MpeqE9VMIWN1tbyUALeE9x5NMSLf/ARIPSDqdYkUhrtXqdUeO84ekf3D/bsp1j5g6QrhqUh1pK0OyXmdwNIdSJt5Hv35we5hXs2B3O8UKCLGc8Z+r7RrQF2f6xSkW2ZTZSG6E3rhBY4HvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712086502; c=relaxed/simple;
	bh=O6hwRl2HxUsOzaPuPskzTgUrHH0WnPZ67/otaq8HOzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zy3ta+R9k1t4uhp8f/SBUkmalO4nALjDs1BouIXzwOZQr+E8F/tze1+lcQkSHeV2R2Ox6dSZArL6PPWVEcXaaF+xP05pawAHqxsL1O4xZ/Qgfvl6amXtPt/pmTq8p+HrCDuFfrneWmugPfOCsEL7WaB8cS/t+94IXwAnPqTV3cA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=EI0Y9Y2w; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="EI0Y9Y2w"
From: Paulo Alcantara <pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0jkb2dPczVqq4yLLuPFOX4lhhQL+Wtubh3CRRnni8k=;
	b=EI0Y9Y2wFyWYvMyrmREqMxWMWIC8yqkty7+60x9CaJXbXwzF+qMiovvNim0Vgplqqh6BDp
	QByyp+2ymrDkul/21GW40KKV4NpaGAJgyJm2LTVloAE4iFW+oSLXJDFMzvOxRKC+n5jvFG
	a4EAUVVdCkJAw/sw+YwhAS7hloGVSI55GZgSiA+rYIei1AuSHGgt5AsovwF3lNA3AC0XYm
	q9cLxcrM10PbwzKheFLkrS5fhCebI7Jl6IJ9oFWreo2yZrXDVM9rPjsp+uTDc8XLNKxH6z
	CJmaWNw8B8/LWpHDnA2l70gRi5IqbOxXfRRSBv5uFAWE0dD7YkJfKTAUoHtsVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1712086498; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0jkb2dPczVqq4yLLuPFOX4lhhQL+Wtubh3CRRnni8k=;
	b=QowXJXlfX9DI5D8gET7ydEG39XPbgOXeZnN8BI+i2R36QF0AUNGpLLRPH6dwKsTHHjeu0K
	wLshfSWlMxgm8xRPclLIWdCa7W8RKqXDfvJb6/MTFqsFR5UXOob3toIcbyfJQGD/b3XGAR
	pvZAh6tdbrBW1DKUodl35RLV6o+ZMaf30LV5Peq2kgJjYrG7Ca184jF6NCe+Cjuq6teuG2
	T13C7+dziMR+IQ/X8Ah/16MnQBE3cxpgA3kkcg8kTRRrbQ3Ll+PUGwHcpgqrf0BNigcNxj
	olNXUbTfXXQF1/k51Chg8s50wglueKC7Uxh1wc4oZ3zL/yYCbsWWq5rAbksz4Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1712086498; a=rsa-sha256;
	cv=none;
	b=XRF6pYmqHvOZdzTjYtH++Wpk17Pa305hWv1Fj/oaqtyhodP9OlXOdXSSIXZx9WpLVaf/PK
	u+RLkFKIPKpionUZV/NJ+dcxZ0YgHFHeZN5LtRuEuJ9bl7aWXdHY4eGKcH9v0aHZZDkmxd
	OaVodQsnO4lggg1fEJ6JeiZmd29jx/li4nV0/sDyED/dGoOFSukXbDZVZ7lv0OvLRgdDVa
	x66HYVnnb1WYYRXWCloPlz6+I3zM4C7SXOq3kVvVyPjht81VXCO/C+VjUKdG9kOhD+Jt+i
	Cr/jQi2yIw8UH26xDlUzZ2D0rQTenLMuXIydUIepy/ntGLQPx5KaVJJbPfcVDA==
To: smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 12/12] smb: client: fix potential UAF in cifs_signal_cifsd_for_reconnect()
Date: Tue,  2 Apr 2024 16:34:04 -0300
Message-ID: <20240402193404.236159-12-pc@manguebit.com>
In-Reply-To: <20240402193404.236159-1-pc@manguebit.com>
References: <20240402193404.236159-1-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Skip sessions that are being teared down (status == SES_EXITING) to
avoid UAF.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
---
 fs/smb/client/connect.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 95e4bda4fd51..85679ae106fd 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -175,6 +175,8 @@ cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
 
 	spin_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(ses, &pserver->smb_ses_list, smb_ses_list) {
+		if (cifs_ses_exiting(ses))
+			continue;
 		spin_lock(&ses->chan_lock);
 		for (i = 0; i < ses->chan_count; i++) {
 			if (!ses->chans[i].server)
-- 
2.44.0

