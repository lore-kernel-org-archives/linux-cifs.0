Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CE012B9B
	for <linux-cifs@vger.kernel.org>; Mon,  5 Feb 2024 09:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707125156; cv=none; b=lc2Y2yFkAa73LGqw6Yhq6YkmsV3stG5leXSraK76/ULsfE4D2IvtKhZ/T85dApxBytQIxRrt+P9UcbKO0nipWjzSH1e7/IjwdSIDpIQuKSEoQ/mGXCaX17KJ0U6DIiOKHCjBNJZiC68N6XFn5o+6fCmZGHvdoa07VMynmcGGmFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707125156; c=relaxed/simple;
	bh=RSYIxUYjbixSS3kCMiLD3BcrnKj3Xwcbw3PzO116WhU=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=Hr/JSQ81aJ2eYkE8EEgzKIkXkM5dfJ/bzrynhcG4HhXWyWx/F+1C7RLjF5qtbj05cJUEpE3VdtLCp/t8OQn0mF/cbTjqM8VhNiHHKYVy/DCyS/iud1s9/GA1y1nvqSXmbjRX282B/eNfW/zVRqEzRFfoHirJjDmWwrrjrnYhBy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QCd5Mc7M; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QCd5Mc7M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707125153;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RSYIxUYjbixSS3kCMiLD3BcrnKj3Xwcbw3PzO116WhU=;
	b=QCd5Mc7Me/u3tc3iV2XKzmh6K95rYkKa8Eww33CvomCSFPMIrLLe0P9HykGTrMG5nfqcer
	1Z9ZzmXxtND/3LkrIfHlI2tYQlO1KRE9p2Lf6sc3ZhHB83VM+d8EY/d2VtQBfzEGPhyr41
	RaUzKPy0a24fOKFwfUApc7qRxOqQOpM=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-494-dcJlkHKjOVikM0ba2XXQOQ-1; Mon,
 05 Feb 2024 04:25:50 -0500
X-MC-Unique: dcJlkHKjOVikM0ba2XXQOQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B8C741C29EA5;
	Mon,  5 Feb 2024 09:25:49 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.245])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 37C8D40C9444;
	Mon,  5 Feb 2024 09:25:49 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com>
References: <CAH2r5mtYF4MgTz8v3DGfYiDycMMaGywuyPxF9-61d4575-S0bw@mail.gmail.com> <a356847f-afa0-446a-b896-fd2b9af2e393@rd10.de>
To: Steve French <smfrench@gmail.com>
Cc: dhowells@redhat.com, "R. Diez" <rdiez-2006@rd10.de>,
    linux-cifs@vger.kernel.org
Subject: Re: SMB 1.0 broken between Kernel versions 6.2 and 6.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3003955.1707125148.1@warthog.procyon.org.uk>
Date: Mon, 05 Feb 2024 09:25:48 +0000
Message-ID: <3003956.1707125148@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Steve French <smfrench@gmail.com> wrote:

> any thoughts whether this could be related to folios/netfs changes?

Unlikely as you didn't take them for the last merge window, let alone 6.2.

Daivd

