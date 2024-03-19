Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C66784A51
	for <linux-cifs@vger.kernel.org>; Tue, 19 Mar 2024 16:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710864843; cv=none; b=rIl3CQs4amt0Y8ZnzCbaCAXoGTLuy3SXaXMJphhYTkt8uzhaEBbos0kPFwdsA2BJX6FYI4FdA0ZYmxYXJoTEWv9Xw0aBpZKi/ZmK6baI61ctwp9Xud9x1g5btyvI0V8bs16ndKIZfJ1iWZbolOXo37dGttEQPMPgwKW6L2SeCz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710864843; c=relaxed/simple;
	bh=xK6oFtMSPOO/+MFMrzgdRfpeW/yJYOp63dnRub6XKM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ciQ7VJdgbwgRdQx+D6ysbPnNO/XJyczAfUMUNLhWOgE0+fsA0tMODuunLMjSl5aCUVqaEXmbDOl4Kqc/xaUuHqjKkeoFvqH3wn7um1V47Rv/Kid/t3SarwA9r03kkkLvzPVpahCQOGDU7KhKl8vba50dQJ/ZIqmRyg7YiWeicJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=l+V0fC34; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="l+V0fC34"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a46aaf6081fso422997866b.2
        for <linux-cifs@vger.kernel.org>; Tue, 19 Mar 2024 09:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1710864839; x=1711469639; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qssoFyi0EHVSMQZ8tvcNSLF8ll1cyBFfjAUL3WkFTKQ=;
        b=l+V0fC34qbWms3t2kAM2Tsaco+GNRpzk32yyo0NNeSGtZuo5iLyGwkDFxfHS7jyxuT
         EjYfJjUYY/jl10/fim6+6QLQfSlCeSzFvYZY0aAjsYBNlqdd16aIRTso+2GaFAMF86Wh
         g0+a6IL6vAXBN23hxZ4lFYPLWdEr8CCHoiv+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710864839; x=1711469639;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qssoFyi0EHVSMQZ8tvcNSLF8ll1cyBFfjAUL3WkFTKQ=;
        b=Pw4RqaS9b6hnU3SKOA5t0csbZWLHsU/EP2MEtITDKBuEN6ezL3oOxsJlCqSOQz547x
         JOQQi4uTZIk2rzoQ5fbE3MUM+kYyMOD4eooPt0kEnbBFx2CrxDqbQrYxkf61jhIKXtYy
         T1cklLHEemFkEKqWHSpB94fCS4UcNMixqeGpn9lyiowa2xhhc8esAXa/1FiyRmb13wB8
         656buP7yZe53ZIKdPALGcY4SCYPAUkpm+k8wgbgLQNkPrXoHpUrE27AYT0+/jkKf0pxg
         rQcl3zQsp4UBXQpMwp9evJbnDcKqRcs/dJYJosT3cvGilqF1471YgX3s+GuJ26+Yb1jJ
         dkfQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQpUqnP053YYavVuV1wFbArQY21HLm7v/Zr1o38kqoAh6BX3F6+HehvMfzOKUnAyI1y5/ddxuZ142fcy5TvSYmjJO3+iRTWtYlOw==
X-Gm-Message-State: AOJu0Yym5JFiBdoGNKbT1lSiPrFKebWhvZLnC1aUtV1+fxBSPg55ulHJ
	tHitHkm2juQj9mJXuzBIhQusqRWcQquKo0853a1t1Y2t3QETdgoY7Eypf+1Oz/ywwURPif2pNQP
	wAcZrDO9PkmwU1KK6cl2cvL0bN5CqMTU03aWYww==
X-Google-Smtp-Source: AGHT+IG80idJ/eoHfs/tS8xY4ItmYTZEjrCulMFp8PsOW5O33PBCGW/QH9XqH6EWMgC+d4lP/zrFK1SKGKNE4vf/7pM=
X-Received: by 2002:a17:906:af07:b0:a46:47bc:580b with SMTP id
 lx7-20020a170906af0700b00a4647bc580bmr2203920ejb.56.1710864838625; Tue, 19
 Mar 2024 09:13:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1668172.1709764777@warthog.procyon.org.uk> <ZelGX3vVlGfEZm8H@casper.infradead.org>
 <1831809.1709807788@warthog.procyon.org.uk> <CAJfpegv8X0PY7PvxEF=zEwRbdZ7yZZcwB80iDO+XLverognx+g@mail.gmail.com>
 <651179.1710857687@warthog.procyon.org.uk>
In-Reply-To: <651179.1710857687@warthog.procyon.org.uk>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 Mar 2024 17:13:47 +0100
Message-ID: <CAJfpegsUYUwp2YNnCE3ZP+JtL0whgQ=3+wcsBABGXH9MjXC0zA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Replace ->launder_folio() with flush and wait
To: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, Trond Myklebust <trond.myklebust@hammerspace.com>, 
	Christoph Hellwig <hch@lst.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	netfs@lists.linux.dev, v9fs@lists.linux.dev, linux-afs@lists.infradead.org, 
	ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org, devel@lists.orangefs.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 Mar 2024 at 15:15, David Howells <dhowells@redhat.com> wrote:

> What particular usage case of invalidate_inode_pages2() are you thinking of?

FUSE_NOTIFY_INVAL_INODE will trigger invalidate_inode_pages2_range()
to clean up the cache.

The server is free to discard writes resulting from this invalidation
and delay reads in the region until the invalidation finishes.  This
would no longer work with your change, since the mapping could
silently be reinstated between the writeback and the removal from the
cache due to the page being unlocked/relocked.

I'm not saying such a filesystem actually exists, but it's a
theoretical possibility.  And maybe there are cases which I haven't
thought of.

Thanks,
Miklos
