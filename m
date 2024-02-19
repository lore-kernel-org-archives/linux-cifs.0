Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DB73C49D
	for <linux-cifs@vger.kernel.org>; Mon, 19 Feb 2024 16:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708359141; cv=none; b=msr/6HKHAK4+SaaiK2fVomuH+Cl1xN47ABwS8MPVaEOkcXOitWgMMxCfwXhGXH1lz/nLlITZoa9BmGtOU7nZAu50fBOlhnJ/w3CBsi+nfXr1mywIdPtHJQQd+9E+0lGRztqi91dMvziR4CaMBerl6R3wSP7ToN5jVou285KcJ4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708359141; c=relaxed/simple;
	bh=6KnJ0wJsYP4PPL5k3hrJckmE7GZOMlUN8YoSAyFXLQA=;
	h=From:In-Reply-To:References:Cc:Subject:MIME-Version:Content-Type:
	 Date:Message-ID; b=aqomzwLeVzk5Xvq1YWV4wWUWsU5lotV42z8xndqLOBBO/eDS347szmMOvSDyqBabOLZ6B5J3V7f+PA6tQig2ZPmxWRl+cwe5xnaPwXmAmWtDfJ4DW4JW9H9JTv6Hc9nvIyY97TkeAOgsjCeuaXbr/pVDZ9308H1hHRyQyTMkAug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NdT5/bhc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NdT5/bhc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708359139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6KnJ0wJsYP4PPL5k3hrJckmE7GZOMlUN8YoSAyFXLQA=;
	b=NdT5/bhc/0drUNf7JsJa8frtAU92LhYIGY8Uv9Fp6eGV3XDi6MXMn8Lma1h4CQI9AMip9/
	vWT266L6h00jPYuKFsxFFlx9EAItJ3k/ar0/TGyQoueVi9uGbmaJE4CHv0k2kHtPqYCZj9
	gwHkh7xorBZCFcX7dNBrPlfX6bgunAI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-396-dv6PHkUGNxe-PkviZ87TXQ-1; Mon, 19 Feb 2024 11:12:17 -0500
X-MC-Unique: dv6PHkUGNxe-PkviZ87TXQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B6AB2185A781;
	Mon, 19 Feb 2024 16:12:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 01DEB492BC6;
	Mon, 19 Feb 2024 16:12:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <187507.1708357334@warthog.procyon.org.uk>
References: <187507.1708357334@warthog.procyon.org.uk> <187136.1708356611@warthog.procyon.org.uk> <CAH2r5mu0Dw7jVHFaz4cYCNjWj9RFa76pRTyQOEenDACHDgNfyg@mail.gmail.com> <20240205225726.3104808-1-dhowells@redhat.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    Jeff Layton <jlayton@kernel.org>,
    Matthew Wilcox <willy@infradead.org>,
    Paulo Alcantara <pc@manguebit.com>,
    Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
    Christian Brauner <christian@brauner.io>, netfs@lists.linux.dev,
    linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
    linux-mm@kvack.org, netdev@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 00/12] netfs, cifs: Delegate high-level I/O to netfslib
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <229264.1708359134.1@warthog.procyon.org.uk>
Date: Mon, 19 Feb 2024 16:12:14 +0000
Message-ID: <229265.1708359134@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

David Howells <dhowells@redhat.com> wrote:

> so the reversion is probably unnecessary.

Removing the iov_iter_revert() fixes the problem.

David

