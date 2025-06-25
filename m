Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D682DCBEC
	for <linux-cifs@vger.kernel.org>; Wed, 25 Jun 2025 11:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750850721; cv=none; b=UXecnUMky5k/Gu3TY44ktnoRsQQiUrKxgmaK5FQTskDmd3U5DCNdEhk1BQAVMsBrFXgBI0gz//SYk/vYqB9Webi0qyUS7RmOeOR4D6ZYLb0V/A7GbAf2V1SnLeUFvLhYwd0hhvvabRES7TubsKEi28L6KzXWif+V2lH0kpxXvnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750850721; c=relaxed/simple;
	bh=dXUhEvx83Pg8POb1rpJ/LZdYQLpuyXcBJkQ9gWCPiuQ=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=N/myWcfJxGM3XKD1GNzm/5k8HFo6NwBFbrnN063R9u+FGjFev+6JLZrzfNMbXNGnGJ0ZaD1N3wyXZ7XDOTlUUpVTuLQDEk/HSmZbjuEV9CUBwFuA2wuz48UX8UuuFAdbI8lWIPKoa6Yiob+BrDONZchMqggd8auflto9sTKU69g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DfV5+1Oh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DfV5+1Oh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750850717;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wp5PUtN+fH7UE8PuSRB/gVV8zzKZ9GRLtHGmoF/7AEQ=;
	b=DfV5+1Ohc6udeszUyR4mywcD4W/4BiZpqnjGnxJEFwL6JQLwUo1D4zmAx84Xn9f7r9T01v
	PU21MCU1ook3ANXKS84RBD6Nb8o3rYN9CV2BxAbFxVVxujz8jvtstvqfAT5np//0mwhDO5
	iiEgmHj/LB1QJdefQnOhygjmIQshw6c=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-p_XjvqhMNgWGQawUtHY7uw-1; Wed,
 25 Jun 2025 07:25:14 -0400
X-MC-Unique: p_XjvqhMNgWGQawUtHY7uw-1
X-Mimecast-MFC-AGG-ID: p_XjvqhMNgWGQawUtHY7uw_1750850713
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EF08918011FB;
	Wed, 25 Jun 2025 11:25:12 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.81])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4FD2919560A3;
	Wed, 25 Jun 2025 11:25:10 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <6b69eef7-781d-42d3-9ce0-973ff9152dd5@samba.org>
References: <6b69eef7-781d-42d3-9ce0-973ff9152dd5@samba.org> <f448a729-ca2e-40a8-be67-3334f47a3916@samba.org> <1107690.1750683895@warthog.procyon.org.uk> <1156127.1750774971@warthog.procyon.org.uk> <acb7f612-df26-4e2a-a35d-7cd040f513e1@samba.org>
To: Stefan Metzmacher <metze@samba.org>
Cc: dhowells@redhat.com,
    "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
    netfs@lists.linux.dev, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
    Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH] cifs: Collapse smbd_recv_*() into smbd_recv() and just use copy_to_iter()
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Jun 2025 12:25:09 +0100
Message-ID: <1341840.1750850709@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Stefan Metzmacher <metze@samba.org> wrote:

> > [=C2=A0 922.218230] [=C2=A0=C2=A0 T6642] kernel BUG at mm/usercopy.c:10=
2!

Ah, I don't have that config option enabled.  With it, I can reproduce that.

David

