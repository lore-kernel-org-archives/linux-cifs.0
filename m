Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792560652;
	b=gFgeZZ0fbK0wimGM3dES++a9iDx8MUjZdjCpfSgqXZvNKSp0Elm7JrJi9YCXvWk7U9fg
	 iA72Z9JECLGqE+oBt7voYya6s9agX1QGpU/mFYHhtBelOJBPsjCrGT1JeIKMBvxJ6uaR2
	 7zz2q8Rc7mlpirgwLmoBp6xgIm45yLwIK8Wr16YQz/aj7mgAAxynWtiy3U1zvsz77449s
	 TI6K/Lc/ph79nDTp9PpUhe+IMDAHTVLXqwq1eyVmoY/t14rF3qX41VIpJpaEUAy1Tre5d
	 ystn0OzUCaAPGu7WCc2XSL6dtONhLN4iF4EDnNMWzhgaM0Irtcm3cmWcKpzn9KymeyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792560652;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Message-ID:In-Reply-To:References:Date:
	 MIME-Version:Content-Type;
	bh=wOxW4z1BbQYP9uEvGV85h66bQb0xJWZvNtv4eVINyQQ=;
	b=R7OLKdP/bkXPX7MCD+yAhgIYcaMIaGBU+3EP5TiPHYHRXA5zJEw+UgK2/5phBwhVk5BA
	 beSmBzaHrwZfqZnNl7HWoYkqyrugOUjdWs1rlNJLFLieky9y1Yf7Cdj4IUitnqoP2MGCJ
	 dLlyFdDDK/sDTtnsm1YxU9BnY9whXA5Hc26yTZcFBsD2EAUG5W2dj7TqbAvFNbMi1X3Xu
	 xv7U+iXSVculHJuc45tVV4j/HST9WdGEhWoBdv9HHQutd3mMIpd/kNbOsIFX9C80C9J1e
	 zKVrAlNaaU4S7cJE3p8InDqM0ZHkhicKfau0jTs8AH2lX08wS0gg9u/KwWKrrOcOUNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=innovatrics.com;
	spf=pass smtp.mailfrom=innovatrics.com;
	dkim=pass header.d=innovatrics.com header.i=@innovatrics.com header.a=rsa-sha256 header.s=google header.b=dZG9+Qrb;
	arc=none smtp.remote-ip=209.85.128.46
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8D0606A322
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 05:30:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD8D0606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=innovatrics.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=innovatrics.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=innovatrics.com header.i=@innovatrics.com header.a=rsa-sha256 header.s=google header.b=dZG9+Qrb
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4a16aaf2067so3148165e9.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 22:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=innovatrics.com; s=google; t=1792560650; x=1793165450; darn=vger.kernel.org;
        h=content-type:mime-version:date:references:in-reply-to:message-id
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wOxW4z1BbQYP9uEvGV85h66bQb0xJWZvNtv4eVINyQQ=;
        b=dZG9+Qrbq6r8virMQzN/ZnScSqFL9UpktW2+0+n3rDobwVeYO2vFRf/TLLKIVXBmhF
         Gy8RLB4EpeJSlAY8DjkXHht8NBPQbM5e5fFurkIdO9DfEYRLT1UnIUiVHv5USugAATTU
         SMpXa/vr/CV4YYNC5DI0uYI78q0K+X5Fj4Q/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792560650; x=1793165450;
        h=content-type:mime-version:date:references:in-reply-to:message-id
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wOxW4z1BbQYP9uEvGV85h66bQb0xJWZvNtv4eVINyQQ=;
        b=chvWGpuXDUbv45Fnyrf45/ZUzmw4Dbk7PDzlshwoHTm/rlPLw7QHTCncTRQqZbpC30
         I+0Kr7sSkZ67A77+Fh6ja9lek0ozFNfB9Zx/aiKTkP3bnuXqGX3cEKejDTZtg6Sk7jxx
         JApTkURo0Ifn1v1AVHGlkQVdRYLl5Wm5UHLdyuK0YBTL/1W1KzK+Jp1WCW2D+W3c2pue
         jP1XPkNiSkR8A5wbzfvRI73bzgmuo/rsVr20agXI3Lvijr5tywR2/To8c84jN2qpMgq/
         KusdL+Rhzw5IgJwpq6wydahYMeVITgAQaoqMk8rrM8d0W7KJKtjxijO6vLmOicmp8WsJ
         U1rQ==
X-Forwarded-Encrypted: i=1; AKwUvBySZ2FGk9oME84UpG5IJXc+hJwXtj9uMiWTSpzrfhJjhGBeePn0mVBbOf/TJvauImgQ35y+R9Yg3UjW@vger.kernel.org
X-Gm-Message-State: AFq9FYLLlK9ufNUPw3vfugz2z16rtHWRq8Rt5lDxEcFSksXV8cMGWp2l
	CDewu+5dor/0CezCR9vbJ+ScLEhEuQ7S5ODTSoR/hN7B6DocdLrcgNdkz0v5Mc6Ktg==
X-Gm-Gg: AYBFou0UUNF9Uy2DnooNSef6abj4KLrwJb+m3a0aAG08W089a9Q4n0bL/maL1GtbY8U
	bGsnUopDKFdxTT11qfKeGPLZvsRMQJSp1NDvVp1znmeHLl50K/YN5L496BVx11xeOUGDeqPgkim
	hGPOshshZ/BNRoh80J4cVfrviIVE42zfhqPFj+RZLMRzzCcUgMzhBBZ4g2Y+PqSexRy0wvUPJYb
	6aI9vQyk4DBwTWZpT/jlmQiarYtdh3SYGgzmQ9n/eWYmZbIVKwafE/7d0R2FaqD9mJgtl8nX+yK
	tNGpvZ99aTK+bK8t2TuoHxD9VL4QlFkBCS4mheYNuL0lobQkFwaeeViFPqRONyZ5jqQ8JRdkweb
	hczCo53Nw+f3deKiq3glbtPr/xtbAnl6kl54qJ+j7DlXF1hCUxhERtR7G0hW0CAXw1O5yyrCvlS
	ZwgAxto0fOkuPXyz4jjSj7044SDShDGZyvWD2veBWsz1R5aanS5nsetXw93PJE4GQdR/rbleOXL
	O9zwGlm4ddLfWU6IAR8q1Zj3hLHU8iILrRxj8ngPrj40kmittcTrn9XW9+wNnSKcXyWTpWAjYPE
	pTeqWQ4h1U5SM67dnhxGIuVyh1a/nfIiywr9KFXLmmDvwZqsTWvwzUvK1DaTQPrAQk8+ic/Dn57
	F3RJh3TqFMk6/
X-Received: by 2002:a05:600c:4686:b0:4a0:b6:4619 with SMTP id 5b1f17b1804b1-4a1fd72e1e6mr17106685e9.0.1792560650270;
        Tue, 20 Oct 2026 22:30:50 -0700 (PDT)
Received: from [10.11.72.5] (bip-static-148.213-81-147.telecom.sk. [213.81.147.148])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1f8016c93sm85779985e9.5.2026.10.20.22.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 22:30:49 -0700 (PDT)
From: Petr Chmelar <petr.chmelar@innovatrics.com>
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>,
    Paulo Alcantara <pc@manguebit.org>,
    Matthew Wilcox <willy@infradead.org>,
    Namjae Jeon <linkinjeon@kernel.org>,
    Marc Dionne <marc.dionne@auristor.com>,
    Stefan Metzmacher <metze@samba.org>,
    Eric Van Hensbergen <ericvh@kernel.org>,
    Dominique Martinet <asmadeus@codewreck.org>,
    Ilya Dryomov <idryomov@gmail.com>,
    netfs@lists.linux.dev,
    linux-afs@lists.infradead.org,
    linux-cifs@vger.kernel.org,
    linux-nfs@vger.kernel.org,
    ceph-devel@vger.kernel.org,
    v9fs@lists.linux.dev,
    linux-fsdevel@vger.kernel.org,
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 4/5] cachefiles: Don't rely on backing fs storage map
 for most use cases
Message-ID: <20261021.cachefiles-mainline-confirmed.pchmelar@innovatrics.com>
In-Reply-To: <2648476.1792482342@warthog.procyon.org.uk>
References: <20260910220242.2165023-1-dhowells@redhat.com>
 <20260910220242.2165023-5-dhowells@redhat.com>
 <20261011.cachefiles-partial-zeros.pchmelar@innovatrics.com>
 <1655268.1791878098@warthog.procyon.org.uk>
 <20261013.cachefiles-partial-zeros-trace.pchmelar@innovatrics.com>
 <1995693.1791971125@warthog.procyon.org.uk>
 <2648476.1792482342@warthog.procyon.org.uk>
Date: Wed, 21 Oct 2026 05:30:48 +0000
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"

David Howells <dhowells@redhat.com> wrote:

> Note that these patches are now upstream with this change incorporated.

Thanks, David, and sorry for the slow reply to your question about
the fix - I was on vacation.

I've now tested mainline (72a16bcff2) with the same reproducers as in
my earlier mail, and it fixes the problem.  All 4096 blocks read back
correctly on both full reads, and the reads were served from the
cache:

 - 9p, cache=fscache: 0 wrong blocks (936 on 13e340e397).
 - NFSv4.2 loopback with fsc: 0 wrong blocks (817 on 9f8b64f66),
   also after a server-side rewrite of half the file and after
   truncating and regrowing it through the mount.

Thanks again for the quick fix.

Petr
