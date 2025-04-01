Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E61E8F54
	for <linux-cifs@vger.kernel.org>; Tue,  1 Apr 2025 16:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743526570; cv=none; b=C3hA/W6ji6JRWnNGgg+/DbcR3y8aAxaEreLWj+iTYuluZJo4f6bjrEYubVzDe6L7BO72nJ9DlZD22RVH/4o+xy1mypK8CZ39wQNS3FqrQF10+iEsqe3XCsx7k8YO9KHkKTVzoabuXL19k1syH7gejaMCZ8VMqluKJZ/8XT4q5vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743526570; c=relaxed/simple;
	bh=/ZrCM6zegnUOQOWJhAquVY6DpSCziGDB7aMoqLF68dY=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=hx7KpyOI+lR4mWYZe2F0642hkHELWyqI8lI/SPNAEI8ZD5bl+CLU69SSDE1X6Fp6Otg1yy93wQBSBGRg/63jVQ0IlwLa7enmxgE2Lab8waPpqo/SxEIqwOb2C20/96kWPPdZoTloiqlzSjent406Y26OD4JXvNP66oUfrdcf+qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gPsBVJDl; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gPsBVJDl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743526567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=gZOsDnFpA9PXjHLjxoH2UjCJQ09skMDvcf1MOSCqTvI=;
	b=gPsBVJDlcfY/+/0wna7HTucAvfZovYnHEOrFI6h15oquqhx+vAa9jA5sATK5MvYzm/x+nv
	b6kq1bZEe5io46DEMxr8OfxpSn3Ta77jlGnrRaI2M3KD7fP08pDEgmPuSOS4YzfE+uPhWn
	cZ8PXg1TFxW97UqfF72/1o2rhiAe6TE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-33-GNmTwbkqN3WXGyw-3z84aQ-1; Tue,
 01 Apr 2025 12:56:06 -0400
X-MC-Unique: GNmTwbkqN3WXGyw-3z84aQ-1
X-Mimecast-MFC-AGG-ID: GNmTwbkqN3WXGyw-3z84aQ_1743526565
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FEF21800262;
	Tue,  1 Apr 2025 16:56:04 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.40])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2C8C31801A65;
	Tue,  1 Apr 2025 16:56:00 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Tom Talpey <tom@talpey.com>
cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    Stefan Metzmacher <metze@samba.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Matthew Wilcox <willy@infradead.org>, linux-cifs@vger.kernel.org
Subject: cifs RDMA restrictions
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <563556.1743526559.1@warthog.procyon.org.uk>
Date: Tue, 01 Apr 2025 17:55:59 +0100
Message-ID: <563557.1743526559@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi Tom,

I'm looking at cleaning up the "struct page" instances in smbdirect.c as much
as possible.  Can you tell me what are the restrictions on the size of a
segment attached to an SGE?  For instance, by:

	static bool smb_set_sge(struct smb_extract_to_rdma *rdma,
				struct page *lowest_page, size_t off, size_t len)
	{
		struct ib_sge *sge = &rdma->sge[rdma->nr_sge];
		u64 addr;

		addr = ib_dma_map_page(rdma->device, lowest_page,
				       off, len, rdma->direction);
		if (ib_dma_mapping_error(rdma->device, addr))
			return false;

		sge->addr   = addr;
		sge->length = len;
		sge->lkey   = rdma->local_dma_lkey;
		rdma->nr_sge++;
		return true;
	}

Thanks,
David

