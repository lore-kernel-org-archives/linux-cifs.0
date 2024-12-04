Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00781E25FF
	for <linux-cifs@vger.kernel.org>; Wed,  4 Dec 2024 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331162; cv=none; b=u6c1QX/jM3hpX8E+9RqWNC3u95+PcL7EE8PzMlwyxRwHes2FA3gY3Or5roZdFg8bA3MsnOldKPk16M4ENHrtpZUD/gAO8Xk+vUbw85bbRppNJogm+DuohJGK6Pl84SvqiNU56h6SXn6jKW3N9atgqb6zndV4utLxHAbC+sOoADc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331162; c=relaxed/simple;
	bh=hPVWTPTpARnbvvX9TY9iD2xsdnXuwABc3nd6ZGsbhTE=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=orcN7mWdNYLOmfBNZ6/6XPVRJbx9rLwj8WJfixppbV7q+k6hbmwMuulWX2Kz8iYnOgOyzuBZMQdhYk0LLESdJDRBt+W9o8WzWKfn9gp/+olEZsnOveijMNvXQUtUZcdqSMNp9wTL1NRzqbVvuPjdm4Wl/Xj98781NEjdj3mbY4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J1uXA9yT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J1uXA9yT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733331159;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPVWTPTpARnbvvX9TY9iD2xsdnXuwABc3nd6ZGsbhTE=;
	b=J1uXA9yTh968LjqVVybUlnPlFUCBrxH9IVLo0wJr57zz8VtTK5wJgS8fPJJk+cAiIg4IMd
	ftD96sua8117D/UMqov4mzIAYIqXtp1zQx5W4TBj3qStpKo8AH+7z/icBm5E5vbOhouyW1
	Ap48CvoNAjK2R92098IQq7vI3WYmbYE=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-Pg88thnrNO6fafnKIuDVgg-1; Wed,
 04 Dec 2024 11:52:36 -0500
X-MC-Unique: Pg88thnrNO6fafnKIuDVgg-1
X-Mimecast-MFC-AGG-ID: Pg88thnrNO6fafnKIuDVgg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 671E619560A2;
	Wed,  4 Dec 2024 16:52:35 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.48])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4CE633000197;
	Wed,  4 Dec 2024 16:52:34 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com>
References: <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com> <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com> <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com> <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk> <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com>
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
Content-ID: <1363600.1733331153.1@warthog.procyon.org.uk>
Date: Wed, 04 Dec 2024 16:52:33 +0000
Message-ID: <1363601.1733331153@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Shyam Prasad N <nspmangalore@gmail.com> wrote:

> 0010:netfs_consume_read_data.isra.0+0x2d6/0xbe0 [netfs]

Can you tell me what line that is?

David

