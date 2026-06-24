Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE867389E1A
	for <linux-cifs@vger.kernel.org>; Wed, 24 Jun 2026 11:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782302319; cv=none; b=M7vBEQp3T094/rTh1I0rB8eETyrWFlMQbfwys3KOWX/kUUzZ1qTLil4XhcsjPD5mIeOBRQX8a+5jciiIsy1fEyNXT6zmtbC6V4kPsc1IYYYjjZPUv3dYaOceLVVDS1/3KBRwVGlJnWiS2bqZV/vueGQH7WMXUx1M3rJkc7jyoTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782302319; c=relaxed/simple;
	bh=VUlgKQRtFcYZkgLggj06uMIrCxezEkk58BuS/5a9eCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUaxQ1x3dDChDVYD2hAZ+02d64ZgfAgMJefCMX5JuShwUaoayNBJeE13+wnc3esOmlRTJMeLfhukVgAQPs0SoInjN0k8RgWtIGkF8FQHB81bPvvfslQK6/XSqlHrAua0GUJOnyLuTij5zVcEpYFgTBCXyeWtGSI23llN2iwtaAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VaKe3zfb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VaKe3zfb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782302317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G/liEajtHx9CYrzJvqnOmvWcXVvucaBQw0Nv7dYml2Q=;
	b=VaKe3zfbujKQGY2FoejC0xouLKaOyB27mqLSv7F0oj/EvNqSADNK5U7SZtlPD3vE5wQn1C
	1CUQ/+COVSYTSChAR8QJMZe0SRNQdgx6/VKYoJvtuCiWKawGN1ZdvQIoctcdfv7DWSFYrP
	QWL/ngVd8qU+020W2WBFR8ZqT/raBqM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-66-kQpdT131NSOW6x98yut7gQ-1; Wed,
 24 Jun 2026 07:58:31 -0400
X-MC-Unique: kQpdT131NSOW6x98yut7gQ-1
X-Mimecast-MFC-AGG-ID: kQpdT131NSOW6x98yut7gQ_1782302310
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02E071805A0D;
	Wed, 24 Jun 2026 11:58:30 +0000 (UTC)
Received: from warthog.procyon.org.com (unknown [10.44.49.152])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 657CF180049F;
	Wed, 24 Jun 2026 11:58:26 +0000 (UTC)
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
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Mike Marshall <hubcap@omnibond.com>
Subject: [PATCH v2 08/14] scatterlist: Fix offset in folio calc in extract_xarray_to_sg()
Date: Wed, 24 Jun 2026 12:57:29 +0100
Message-ID: <20260624115737.2964520-9-dhowells@redhat.com>
In-Reply-To: <20260624115737.2964520-1-dhowells@redhat.com>
References: <20260624115737.2964520-1-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Fix the calculation of the offset in the folio being extracted in
extract_xarray_to_sg().

Note that in the near future, ITER_XARRAY should be removed.

Fixes: f5f82cd18732 ("Move netfs_extract_iter_to_sg() to lib/scatterlist.c")
Link: https://sashiko.dev/#/patchset/20260608145432.681865-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Paulo Alcantara <pc@manguebit.org>
cc: Matthew Wilcox <willy@infradead.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Mike Marshall <hubcap@omnibond.com>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
---
 lib/scatterlist.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b7fe91ef35b8..6ea40d2e6247 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -1366,6 +1366,7 @@ static ssize_t extract_xarray_to_sg(struct iov_iter *iter,
 		sg_max--;
 
 		maxsize -= len;
+		start += len;
 		ret += len;
 		if (maxsize <= 0 || sg_max == 0)
 			break;

