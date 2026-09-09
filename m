Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196CD36F428
	for <linux-cifs@vger.kernel.org>; Wed,  9 Sep 2026 17:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788974089; cv=none; b=OL2xewQfXbSZKl1YQ/++sxxuJbkHS2O5t5MnACNPIPipc8vjwfgMgPgFqhx4HnYbvGHqyEE3lpHMz5+KHjRFzsD7aqNrzeeQM1OnvS25F/WHbzmnlye6dSTiVsoH8/8CpijaNyuU3V75LDAxdVQsuZHiBgAqVxogCx86bPxZ7lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788974089; c=relaxed/simple;
	bh=AhG9uZP5Vc+oU60yw43Lea20JRbSBt/2ZAdLmmE7+58=;
	h=From:In-Reply-To:References:Cc:Subject:MIME-Version:Content-Type:
	 Date:Message-ID; b=q/NRBC8EqNaSJpZYm4N2l1tD1J+ue5vOZKNU3ATJBK4CCK+qPju2GqQmuZU9uXSG0IwXbZmuS9tLsxngEUmrhqdvwzYZjVbet5pZaaIzJcn9rf9sx2aDMXh/Apc25wv3kTjFlqFvCybiTYLOIOu3VRvJ2yS/0aujpzp1kz0yktg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QpdlO80i; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QpdlO80i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788974087;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wrrcFv43Y6IitaL5MyShgfkwkQfgO8qX9JD4vZRKPPY=;
	b=QpdlO80iwcGu17T3vqDOW+LBvHKrVz1Wf8RiTDAGpq+XUMvoZ5my3S1D79di0jRJnYadci
	J+WXGZqtu5ymDq6Iul6H66rwdQdyqPkO+QCLmBeQgmHDpT2+Yuju3m/j7eKmQS6rzXXi2b
	zZf22cuij4G1Do6tEmRC9KX4T9zRXN0=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-642-v8CazuleNgmALlpzy5bkZw-1; Wed,
 09 Sep 2026 13:14:40 -0400
X-MC-Unique: v8CazuleNgmALlpzy5bkZw-1
X-Mimecast-MFC-AGG-ID: v8CazuleNgmALlpzy5bkZw_1788974077
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 94F59195605F;
	Wed,  9 Sep 2026 17:14:37 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.158])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5422F1955F19;
	Wed,  9 Sep 2026 17:14:35 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1729858.1788973986@warthog.procyon.org.uk>
References: <1729858.1788973986@warthog.procyon.org.uk> <afd68097-b2b2-47e5-889b-fb077e7a9247@redhat.com> <a385053c-1c4a-4060-a3bb-befa007ddb33@redhat.com> <1714046.1788952509@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, sorenson@redhat.com,
    Paulo Alcantara <pc@manguebit.org>, Jeff Layton <jlayton@kernel.org>,
    linux-fsdevel@vger.kernel.org, netfs@lists.linux.dev,
    CIFS <linux-cifs@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: netfs_read_gaps(): aliased sink folio makes the read destination unreadable, SIGBUS on cifs with signing
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1729916.1788974073.1@warthog.procyon.org.uk>
Date: Wed, 09 Sep 2026 18:14:33 +0100
Message-ID: <1729917.1788974073@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

David Howells <dhowells@redhat.com> wrote:

> +			folio_unlock(bvec_folio(&bvec[sink_from]));

Meh.  Nevermind.  There are two of them.

David

