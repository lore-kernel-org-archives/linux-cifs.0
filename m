Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59FA38FA5
	for <linux-cifs@vger.kernel.org>; Mon, 19 Feb 2024 15:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708357343; cv=none; b=XmuVmo2jU3ielDcMVv/UDJ9W3FaYD/U+FBfdmlY4cU20KGJBmHEfxuPc2FuHmoWMxNqtzoBcSITV7pt3kj1p0I3BSq8+jeXxB2JGT31BI4Q/CWs90MozhzIRRqNiWPg1CDyEThX4O5Mj5lCGya3PDF4PYhJiV9ds7/NiuRTb4xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708357343; c=relaxed/simple;
	bh=NIFtUpFLsHivFguvB+ZvyrkpY/INW7ZD0v9T38aeM/k=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=jq50ojZQ/rL08sVTHWgNd9JuhvHKqMYDgbRZ5pTjkJ6+m3ExYKt0V+lSW2Iz26vddUj4+JZTrTa7JV0P9SnciIJCeLTly1wau7HjZ8qhANQ9D2SrE862o3JoxFUDS2EeZHGC1NM/1bFgmd6ghUFBmhb4QGvmIy4OW5LAHR38MrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ia/9TPfk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ia/9TPfk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708357340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gYi7OFizi+TSpI37jerYjh3Z/519CTMS/OFVVmKV/5k=;
	b=Ia/9TPfkZcbjFOM8oBqimgc4WdBzlmdS09FA7SYrdGahgbROlGy67dQE8uYmbvI1HSvYYS
	yYKBFXK2EsZNMNd1bw5EZLYYfIIiKPqCafdX12f4xD/5VUG4G1aJS0IboTtyZRUyNJ5cmG
	dZ1rqSNBGqCYiuSKCU77H2E/Yw0JBIQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-78AazjT2NnWPZegN_d8_QQ-1; Mon, 19 Feb 2024 10:42:17 -0500
X-MC-Unique: 78AazjT2NnWPZegN_d8_QQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C10E85A588;
	Mon, 19 Feb 2024 15:42:16 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id A3E7D1C060B3;
	Mon, 19 Feb 2024 15:42:14 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <187136.1708356611@warthog.procyon.org.uk>
References: <187136.1708356611@warthog.procyon.org.uk> <CAH2r5mu0Dw7jVHFaz4cYCNjWj9RFa76pRTyQOEenDACHDgNfyg@mail.gmail.com> <20240205225726.3104808-1-dhowells@redhat.com>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, Jeff Layton <jlayton@kernel.org>,
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
Content-ID: <187506.1708357334.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Feb 2024 15:42:14 +0000
Message-ID: <187507.1708357334@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

David Howells <dhowells@redhat.com> wrote:

> I don't suppose you can tell me what line smb2_readv_callback+0x50f/0x5b=
0 is?

It's almost certainly the iov_iter_revert() here:

	switch (mid->mid_state) {
	case MID_RESPONSE_RECEIVED:
		credits.value =3D le16_to_cpu(shdr->CreditRequest);
		credits.instance =3D server->reconnect_instance;
		/* result already set, check signature */
		if (server->sign && !mid->decrypted) {
			int rc;

			iov_iter_revert(&rqst.rq_iter, rdata->got_bytes);
			iov_iter_truncate(&rqst.rq_iter, rdata->got_bytes);

The reason that the:

	[  228.573737] kernel BUG at lib/iov_iter.c:582!

happens is that we're trying to wind the iterator back before its start po=
int.

Now, the iterator is reinitialised at the beginning of the function:

	if (rdata->got_bytes) {
		rqst.rq_iter	  =3D rdata->subreq.io_iter;
		rqst.rq_iter_size =3D iov_iter_count(&rdata->subreq.io_iter);
	}

so the reversion is probably unnecessary.

Note that this can only happen if we're using signed messages:

		if (server->sign && !mid->decrypted) {

as we wind back the iterator so that we can use it to feed the buffer to t=
he
hashing algorithm.

David

