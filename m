Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFB929BDA9
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 11:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766750298; cv=none; b=V2K4r8uK6cnX/iXCQA91DS65C37AmmJVeTpMVp52quguOgUI2c8IA+5YDQzoBngAQDU1dlr08gDthlY2EGHwuGzdPHrBn4ytf9qp4DN58Zmmfc8UJs500XsjdVtY6pMdfFTi6HojMKTIsszwoWV5qY3Wt49RS5SoNm6ddagLC2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766750298; c=relaxed/simple;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=PvNNqJOnnc3Woee8gjYflwy6uPzQPvJtRJegd47Gny3sERqM6vzr13CWrS2N8OcQSU6zZXsaemnUD8aiZVSFQAla8htDWviVY4byWb7tQf0k7XpRx9fKqNbehJRGSd7V3EKHT6bd+1jiG/muDmJimrpzgdmbpnMGl9iaDEH6SVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ymr3zbZP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ymr3zbZP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766750295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=Ymr3zbZPQ5iIyaYz96zHQmH8jJ+FP8GtUmyWyn95h6w3YlyAKkM8AeGqaJDvlOpaZqXrWL
	tipVTEcnhp5XaFfpx/macfBDJPQ+k37nss7gLD1Fjg0DljobEGQfOjBIR9mdQrl6u/o78q
	w9OEZwy/L7V74mVNxkg+wfwyXGZp6U0=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-9QCJiM89MVuebiUq7SJ4iQ-1; Fri,
 26 Dec 2025 06:58:11 -0500
X-MC-Unique: 9QCJiM89MVuebiUq7SJ4iQ-1
X-Mimecast-MFC-AGG-ID: 9QCJiM89MVuebiUq7SJ4iQ_1766750288
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 33F9F18009C0;
	Fri, 26 Dec 2025 11:58:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2075C18004D8;
	Fri, 26 Dec 2025 11:58:04 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev>
References: <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev>
To: chenxiaosong.chenxiaosong@linux.dev
Cc: dhowells@redhat.com, smfrench@gmail.com, linkinjeon@kernel.org,
    pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
    tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Date: Fri, 26 Dec 2025 11:58:03 +0000
Message-ID: <1236507.1766750283@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

