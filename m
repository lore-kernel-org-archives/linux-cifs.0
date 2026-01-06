Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA911FECCD
	for <linux-cifs@vger.kernel.org>; Tue,  6 Jan 2026 09:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767692072; cv=none; b=N1e1FOfRXwMKjHTWawTiaHH+XYb+wSGjS4cbDJzZ3bXP8dmMmTf5g9EsDDFDSvW5wJGCoFbAehBX8/OgQdEOGQ2H1ZNs492uO8ujD6uk8q+yGutIQzhFdBEh9kOp24TvvM7UbP9teGynj3/wFXVOLc3HxkzaD2NnSTcVhazY/H8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767692072; c=relaxed/simple;
	bh=LbHOKemj3x3i/RRfgL4O8FQ7JtEapB4R9zBWaNJlTbY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=E5pk054RhraCI0JQHMig2ZpGmB2oRaIdeGc1HbXEfzjkz7v785rOE9XYKCK2RvHwS8kpYNwp2XKoZwqZUnfWHEzXDky0YMbMstYMdOAPuFEAPd2S+7WHUdyxpm9bBfQhCs7tjsJL46qNFxqWiLKZzJ/T5Y19Rp7VkYHV6kuN0B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bdk5Fzi3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bdk5Fzi3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767692070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LbHOKemj3x3i/RRfgL4O8FQ7JtEapB4R9zBWaNJlTbY=;
	b=bdk5Fzi3SUtc1tLFV5HXih7leAsZfbs0aMi+YyagkTa8iGHMjfmM7eWcb4toaC8UF9JQ0F
	GaE6Gukt/TESSOR0P8zYg2OeNcMFlUENYErYafmOo7IDDLyiu+VlQntNDMGCygutAqCAwq
	6TCssHdatl03+q54FfXr8dQ2MvKG03o=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-672-o63ftV2OOyOfAzfHD-L16Q-1; Tue,
 06 Jan 2026 04:34:26 -0500
X-MC-Unique: o63ftV2OOyOfAzfHD-L16Q-1
X-Mimecast-MFC-AGG-ID: o63ftV2OOyOfAzfHD-L16Q_1767692065
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D6B0A1956080;
	Tue,  6 Jan 2026 09:34:24 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A4FD519560A7;
	Tue,  6 Jan 2026 09:34:21 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
References: <20260106071507.1420900-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v8 0/5] smb: improve search speed of SMB2 maperror
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1837635.1767692060.1@warthog.procyon.org.uk>
Date: Tue, 06 Jan 2026 09:34:20 +0000
Message-ID: <1837636.1767692060@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Reviewed-by: David Howells <dhowells@redhat.com>

