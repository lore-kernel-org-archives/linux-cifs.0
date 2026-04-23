Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4E039B962
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 22:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776982955; cv=none; b=G+kP9AxhPXFcO+9z9o2NIEJXF0U77S1PeUwatpfPNLNQ9T7zaZyb0O+6MmNC19+xDLEKK19H5kx7TAzwGkVuFk/SgZTub51//IHRifXCGNQVkV2yJr7fn0uNHvvhifEUqxtvK4a0ogSlsovD9HVpGQafww1mwLDvKPeacb0vxFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776982955; c=relaxed/simple;
	bh=EQpPMiLagPYSIVsb0YWyJHfB16hbO4DByLA6fMjT7yY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYHe+d+RbgtBmEO9Ikr3sSSrDM0ceV3dmoR+34grYOXejyZiejB0fp37dHYvmCTxYrd/33JuzHPYbNbJH228dexX/5e7IeFHa9kMNS0v0qwg/EyUdcNflm5MvfptKMh8wucf4qVAmA33TSrFCIXt12a+r9VPRiMVwouG0WsMTLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gicg9zXi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gicg9zXi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776982953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=600g6oafpsmNXEPuDP1fqAUAuRGwYq58jCdzRtTHVzs=;
	b=Gicg9zXiX6hRj5Di6y/cDx459+YVJA2VWwDKeOoIffNSI/UqpEZbsDIqL47rA96GT8BKXX
	RIP2djBQwMla5JS+cGkcJ/9o1SgFlUoExasYQEfLHkvEX74WobrrD59i9Xl52s41UEJwZa
	I6GrY/+xY0dOcBEdcdhG0nlhUA3K+sE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-507-GJn_nIQFO-qJAJAnoBfq3A-1; Thu,
 23 Apr 2026 18:22:28 -0400
X-MC-Unique: GJn_nIQFO-qJAJAnoBfq3A-1
X-Mimecast-MFC-AGG-ID: GJn_nIQFO-qJAJAnoBfq3A_1776982946
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1E7D519560BB;
	Thu, 23 Apr 2026 22:22:26 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.48.17])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2CE67180047F;
	Thu, 23 Apr 2026 22:22:21 +0000 (UTC)
From: David Howells <dhowells@redhat.com>
To: Christian Brauner <christian@brauner.io>
Cc: David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mark Brown <broonie@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 1/4] netfs: Fix wrong return from netfs_read_sizes() on 32-bit SMP arches
Date: Thu, 23 Apr 2026 23:22:04 +0100
Message-ID: <20260423222209.3054909-2-dhowells@redhat.com>
In-Reply-To: <20260423222209.3054909-1-dhowells@redhat.com>
References: <20260423222209.3054909-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix netfs_read_sizes() for 32-bit SMP arches to not have a return value.

Fixes: 756f72b6d8db ("netfs: Fix potential for tearing in ->remote_i_size and ->zero_point")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/r/aeoIAXzqh0n54mxl@sirena.org.uk
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Christian Brauner <brauner@kernel.org>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 include/linux/netfs.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index d72bc2f11734..ad394c088578 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -669,7 +669,6 @@ static inline void netfs_read_sizes(const struct netfs_inode *ictx,
 		*remote_i_size = ictx->_remote_i_size;
 		*zero_point = ictx->_zero_point;
 	} while (read_seqcount_retry(&inode->i_size_seqcount, seq));
-	return zero_point;
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPTION)
 	unsigned long long zero_point;
 

