Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32001274FC1
	for <linux-cifs@vger.kernel.org>; Sat, 27 Dec 2025 11:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766836778; cv=none; b=H3QpQpTbmXeESBexR88YmosY3aY+A9VPoooYz0gefQedEKLgSU4DqPwFWobaI5sPKCyPm8dEzPgYIrNzROeh7VHJv7g3noC3sN8ETKhvt4p6J+XCfQjnurk08wigjhFfRftSK1h+80UxXC9HIPnow38o0u6AwLkT4bs6ztH8KWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766836778; c=relaxed/simple;
	bh=d2ORrd1zlQhRifGrwDOlty7W7d0tMpqqQlCcfyPTzy8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=q/ZljzcRaMVro7a9offhJmrrhUnK5UA0L/NdolUEZm+wW/utNgb9T5Wf/POKDW4cNVZN8UkwZ3PYA4aU7zfG0EuWxdSiBaIv1gPukCAeezqZt+1uLfBstR0hZdkT673Y8uTGismVb+wB9gWDJV3uSs8tKSNXOybzwjJMnyxV8ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oai070to; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oai070to"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766836775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Un9EUYagtsO5rlKBmFDC1khGX58UB2ReLflz5boA/7o=;
	b=Oai070tokJV5r+X+djeBAcNHU0dvubeOKMH1ImVk+RdLfgG9yK4/xnycIRZjzsGbVGqS+1
	a20JGcMI6OoVvelwCSxJL152TYfjmWhuU1A0RCPE7+u72dO/aTcyX5SGNir/7dM6iiOG8k
	L1EHQDLhnUeeOZJZaEhwyj4Gaq8eNus=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-137-w_O-fM-SN1648r07olUzOQ-1; Sat,
 27 Dec 2025 06:59:30 -0500
X-MC-Unique: w_O-fM-SN1648r07olUzOQ-1
X-Mimecast-MFC-AGG-ID: w_O-fM-SN1648r07olUzOQ_1766836769
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5519A19560B2;
	Sat, 27 Dec 2025 11:59:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 102CC180045B;
	Sat, 27 Dec 2025 11:59:24 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <d84af000-7d6e-4104-82ce-de9d08e46f92@linux.dev>
References: <d84af000-7d6e-4104-82ce-de9d08e46f92@linux.dev> <f0740fbf-1142-42f8-b56f-937fa915a4bb@linux.dev> <20251225021035.656639-5-chenxiaosong.chenxiaosong@linux.dev> <20251225021035.656639-1-chenxiaosong.chenxiaosong@linux.dev> <1236711.1766750798@warthog.procyon.org.uk> <e64b6e2d-6ad8-43b0-bca3-fbeae76f6306@linux.dev> <1264023.1766825812@warthog.procyon.org.uk>
To: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Namjae Jeon <linkinjeon@kernel.org>, pc@manguebit.org,
    ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
    bharathsm@microsoft.com, senozhatsky@chromium.org,
    linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
Subject: Re: [PATCH v6 4/5] smb/client: use bsearch() to find target in smb2_error_map_table
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1266569.1766836763.1@warthog.procyon.org.uk>
Date: Sat, 27 Dec 2025 11:59:23 +0000
Message-ID: <1266570.1766836763@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev> wrote:

> > __le32 key = (unsigned long)_key;
> > Ummm....  u32 key?  I'm pretty certain it's sorted in cpu-endian order.
> 
> Should we update the `gen_smb2_mapping` script to sort the table in
> little-endian order?

I wouldn't.  We really should convert to cpu-endian when we pull the value out
of the protocol struct.  switch() works better if we do that.

David

