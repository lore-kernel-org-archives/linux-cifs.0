Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C127823C3
	for <linux-cifs@vger.kernel.org>; Wed, 22 May 2024 10:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716374195; cv=none; b=SPBfAnCdFObkylynK5jUTJnQg8Ga+ClG9DS4MP+9o0+5RZfKQtWFYvP57qE40XR2/nz94ET0BEnLavAy33NkWLMp94BetU25tkCdGAyjfsxhr5V9VtM7ZDSkbyZBW0Uzq1rCTbISUE+2ZwuMTXFBsMburspDJDJW/IkYu6nUU8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716374195; c=relaxed/simple;
	bh=FzSc9A+gkHaRjZLE6uMFAxkU46htSQzioSnB310pUJ8=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=IjXgwY++0EW5J7IKJaHUAGoySqyGmlLBHmAxIJqRS+AZqLc0SLknflMEHK+qu6BHobfelzkVbIzWqfOEhcwnIo15fNh30h8nTm9Bj2ynQ43iygP2dLkzS/jkPxUg+wEe1bcBIusy9zXp5svNZnoQQ6+JxoiAr4Zjxk3myc0vo68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A5FYDTY6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A5FYDTY6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716374193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z2eswcLWLrokwlSeNmsp1rGG7SqGmuU6iodQGIpucDc=;
	b=A5FYDTY6lURa1GoSIRZmsQLMGoMbuwZmjPmTAuqjfx0J8W8L/5jnttVmpyAFNQktFsYy72
	RqOSUPw6dngxXWoYRxoJRM0J4vv2QZbdB2Q7c5UIKPoqA+rIlnyivlr+pbbk6C/HGgVebq
	qGdUk/yvR7ZuNpqRneO6iVYe7MHSWH0=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-120-6Sc82J_7MT-LaWT92udlKg-1; Wed,
 22 May 2024 06:36:28 -0400
X-MC-Unique: 6Sc82J_7MT-LaWT92udlKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A9D0380008F;
	Wed, 22 May 2024 10:36:28 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.20])
	by smtp.corp.redhat.com (Postfix) with ESMTP id ADEDD200A35C;
	Wed, 22 May 2024 10:36:26 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20240522185305.69e04dab@echidna>
References: <20240522185305.69e04dab@echidna> <349671.1716335639@warthog.procyon.org.uk>
To: David Disseldorp <ddiss@samba.org>
Cc: dhowells@redhat.com,
    David Howells via samba-technical <samba-technical@lists.samba.org>,
    Steve French <sfrench@samba.org>, Jeremy Allison <jra@samba.org>,
    linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: Bug in Samba's implementation of FSCTL_QUERY_ALLOCATED_RANGES?
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <370799.1716374185.1@warthog.procyon.org.uk>
Date: Wed, 22 May 2024 11:36:25 +0100
Message-ID: <370800.1716374185@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

David Disseldorp <ddiss@samba.org> wrote:
> ...
> I think the best way to proceed here would be to capture traffic for the
> same workload against a Windows SMB server. This could be don't by using
> your cifs.ko workload or extending test_ioctl_sparse_qar_malformed().

I don't have a windows server I can try.  Steve may be able to try that.

David

