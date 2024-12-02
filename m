Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DD919995B
	for <linux-cifs@vger.kernel.org>; Mon,  2 Dec 2024 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733159450; cv=none; b=g4thl1eD5TZM5esc9OQifnIR8+gw2Ehjn8+PPaMHwsWXI3ffdTDoyU6ks/geiPgF6+ruKRFZw1TguNIomY79NNHYWIilUUHqzxCGBZAhxseTuQh+ahHw+trqgzywOps7Pnvfj9wwtEtJy0PLT808qeTd3/TXcWjQ6srSS2jl2CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733159450; c=relaxed/simple;
	bh=rK7MvjgRxAxxvcNbaYncXzvccQzwjzOEQMzXgPVsDHY=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=LEfqziq59utKy7qHWj09bTOrLqTH7KDxa2qi8h3qNqbLBK5ul0Ky4+i9Kth9ZL9kvLyEx3kLLOjJWE8WvxQKI9KeKMb/oJ5J+cRPINCua4mNva0qSfr07Ti//XCiP4r3AZNk/lmrPjJLvjYX3ePVOx6/RFkGlwbiM1qtzlkR890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P2vtabbi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P2vtabbi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733159447;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rK7MvjgRxAxxvcNbaYncXzvccQzwjzOEQMzXgPVsDHY=;
	b=P2vtabbi6fsnE4MmUAEx7X7/CZg1yHAij5HDGMElNG2EZksPCID3cha5m+qeeaob4OGuTA
	vixMcHJepGWOVzGUUf1Kr6tQsOBkAaN5oSDf2sxcaEPHBBT9S7qH8ZuBpxloEK1kWgQ756
	SVkGHMBXRrMNM5ubNTPN8SjuoDaQGzY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-654-SaUjqQDaN067diSOv_FKrw-1; Mon,
 02 Dec 2024 12:10:46 -0500
X-MC-Unique: SaUjqQDaN067diSOv_FKrw-1
X-Mimecast-MFC-AGG-ID: SaUjqQDaN067diSOv_FKrw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1922F1955D4B;
	Mon,  2 Dec 2024 17:10:42 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.48])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 03E8419560A3;
	Mon,  2 Dec 2024 17:10:40 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com>
References: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com> <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: dhowells@redhat.com, Steve French <smfrench@gmail.com>,
    CIFS <linux-cifs@vger.kernel.org>
Subject: Re: null-ptr deref found in netfs code
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <492741.1733159439.1@warthog.procyon.org.uk>
Date: Mon, 02 Dec 2024 17:10:39 +0000
Message-ID: <492742.1733159439@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> This issue is consistently reproducible for me from at least 6.12.
> It shows up when several reads are in flight in parallel.

Doing what to what sort of server?

David

