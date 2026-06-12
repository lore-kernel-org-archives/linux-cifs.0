Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D87936AB5A
	for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 19:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781293066; cv=pass; b=QnqMtLGUZgrrqx77fIrY1Pr4zP3mQEsbCS2/1lf2Ek3wj0j5+a3ntUVFO9TDGDw6XX/44g/WamNLlgrCfJZZpkW/zTB4gmF0IV71YF6COgn0cdJXGGg/FVLlYshfQLAtCe6HRv4uCjFWr9eIrwsJ1tnZu3PY0BMfe2FeTMMSaSM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781293066; c=relaxed/simple;
	bh=QEUU0s90pEvT4hfT4qXSU5rJ24bOjblDhPsz3FQQoIs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=edLyCHGhXhztmVYf+tRLilQiq5ZfU9N7gLgDwP3Qs4/BjbPYUCYpog9Pca9PFxokWSr9of+xI1rpIZs8Abvhiyjeu5frx+uFqyq0rK2CBOdyo3H934SjKwg7RdrB9OSWghd2umqposT8mqAnWZxKD8OatSRwANeYFB/QN/OM2fM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pPeK0p1p; arc=pass smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pPeK0p1p"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c8587427468so573726a12.1
        for <linux-cifs@vger.kernel.org>; Fri, 12 Jun 2026 12:37:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781293065; cv=none;
        d=google.com; s=arc-20240605;
        b=SooAqtVRbzQcSph+JS1IJQZBHiUPYnQu3xTM2jPBCcOoegr+kIUAQG4gguVljZEGjZ
         Yotb6i3yuJ2UqxvvrZG/FbSiExXlgRbexr+D99JXvxt2KdWnjGP1H0cQZimgri6rA/NQ
         Rx3v24PgYTYVFYHI5wDCDfn+oOSs0mmgcQibYRRgLydUlq+yu7cbxsPFVXNcLWVajfCN
         TYRQ5bM7H9BhSrNZH4GWlBdEFhdBofsOOLJ66G8HKbZ0lzIVUA84kc7qQli5lextBlRB
         M0Iaa7A94ArRF44RQURh20eosKogKXkEUKksu2SKZbHBRQ1AqH5jMOU9LOVBdBrg3rF+
         ptdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QEUU0s90pEvT4hfT4qXSU5rJ24bOjblDhPsz3FQQoIs=;
        fh=yduhiOJ9Z0xteEiK4a1t5EJMxthqIX0VSWY5wAyFEWk=;
        b=JRP+jl887YTeZRngJy66wRAvYYeEscQE+SeZl9xrqiPIC86uoAyah8EegtKmc8jlkn
         OsBHIzfcYbkGGAryQyD4qQU80Bc/n7JJ1qdZRmRH5c95F9UbZU+KOqJeOJWv20n9+FfH
         Dgb5F6feFWq5OASGuhCJ8YgmvvE/Rs8hcP8IXyxud3JbYZ+MAwEMFGlf0pu0VZnTFKTZ
         4UF8BsPLU2D+79Ugc7mhxlArvyRyQLxv2bj/p5C+yQYTsKEmrVRZNDLwhbF4vvemxGwX
         DXF+3CcBWJFy2lpun+wK8f0kmPA271AFGwFz6NlIv0wuTLmkvH263wSNFVDmqUdg3SVZ
         rcHw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781293065; x=1781897865; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QEUU0s90pEvT4hfT4qXSU5rJ24bOjblDhPsz3FQQoIs=;
        b=pPeK0p1p+H2Stw/gIDmIEtvzYV7T8dn0cxMytCd4A88Z4lvAWO+BCS2RSElRBNQ9i4
         iI+Ky+99b3tUnqTLGLiXpbnPzDJ2+gmBg27EGCMOMxOfmenUofUi7jlVUlzJJgErv+vm
         VBzVw+fNQ2JAzPDUWUYubHrAkGYv5v9anvl4I+elqoBnM/wccdPdZjJ/Sz2J82iGl3pP
         Ezn3/TgI5qw7JFysi/CF4Xre5+kgajC6q9D0z+/rbXhFBqO5nSvh9PfS606o7K0S1yKW
         bk8slfH4rettH7FKzJeHTQLgI8vEgwpIzAkjFoeO5TC09FDuIUpRtnK3EmEEcfL/bNmN
         ynXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781293065; x=1781897865;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEUU0s90pEvT4hfT4qXSU5rJ24bOjblDhPsz3FQQoIs=;
        b=pKyGc1L0z1wUR+riTxQ2g3UxN6hmx5P6gD3LsUqByyjQa4lu1EzANunyTXBWnmHYNg
         4kN+eWURY7zRDOrdTvSxWrMWQWjGm+uuBrOjT2RXZM7452pkx4uYssMoKXzvtYL7pb7t
         9polrU/a7mIu6lj2DvUECmRFlV0W9C5JY7J6F/oca8eF9CQzJJumaoWg4pdatrhf1Roa
         teDYgtVLDiVnhIAkI1AruzySm3+yRdGO+vaMjPRjelO8eOZ66kLYC5wNFuHO96hRradQ
         uZT0LvVc7QRnqpaO8yzdIB6KONoEDQE8CVwdJJTwx2OdUVaPawZHJPkSSTWS1Byc4v7Z
         A8Pw==
X-Forwarded-Encrypted: i=1; AFNElJ84pbujey/Y+swv+40+CCrnDJQ7pgMEgx+l64nyWiZa0ZnJe7DSxLBnVDxUXb5eSJKq7Sanv++F+LvI@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0kx9t6TFsSXqPmyDLivpSCCyLzv1j0vXY0Fb9qyRfSL4e3clT
	4ApH0glP94jeJp2whw02ix1th2sj1w8EN+R662xjZ5GLwZxAZ98htio6wnvrpfvH//V0PEXdp0L
	jGa428lFFH7SmQuofA3yLjprq4cEm0PE=
X-Gm-Gg: Acq92OE6LYLKi/BJZ/Qim6RljXNZsGQfaJ3mzMZPWGk6hTkUGYm4gZK37dS289D836o
	liXNxlUCVAzXIxLnCRvr6tkO5xdqVgbx/isjzVcz5AVaa6thyirNtJCoA0wZ7wUX/FNw0RJAR7A
	Tud8h5wqwMgf+x8fBZrCyEJIexCRAZPc+PBA3REtsB+V65CNAYUVNi3dN2pimeV25tfP+EZBtzI
	NRy5pGWMqAnC5LFzamxuebh5sYSeYh7PzzJgde0d73B0myUZqC+Agi+KYUB6pderGEfbxyfPO+i
	et4uFiZYYAgd0HfrFpco5HY1t80IzOwk9lrEqYGQYrSnadXX/+FofxWWBhiUheeJLZPWNlNZHds
	IMsrgxA==
X-Received: by 2002:a05:6a00:1391:b0:82a:5d55:5807 with SMTP id
 d2e1a72fcca58-8434cb01ac7mr4736200b3a.6.1781293064808; Fri, 12 Jun 2026
 12:37:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780855296.git.lucien.xin@gmail.com> <465489e5fafa9326b4a21c4851e420d344bbfdfe.1780855297.git.lucien.xin@gmail.com>
In-Reply-To: <465489e5fafa9326b4a21c4851e420d344bbfdfe.1780855297.git.lucien.xin@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 12 Jun 2026 15:37:33 -0400
X-Gm-Features: AVVi8CcBYZ4beNIIRotqS0HdShlGTPsplHhO3h8wRDUTXq00moRwOci60wjQJnA
Message-ID: <CADvbK_c_qBNuad6HkYTZe0MpgMSbMdYSsSAz62DhEYaEapaCTg@mail.gmail.com>
Subject: Re: [PATCH net-next v13 09/15] quic: add congestion control
To: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev
Cc: davem@davemloft.net, kuba@kernel.org, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"

[sashiko-gemini]

> + case QUIC_CONG_CONGESTION_AVOIDANCE:
> + /* cong->window is never zero; it is initialized by
> + * quic_packet_route() during connect/accept.
> + */
> + cong->window += cong->mss * bytes / cong->window;
Can this arithmetic permanently stall congestion window growth or cause an
overflow? Since all variables are 32-bit integers, the division could
truncate to 0 as the window grows larger than cong->mss * bytes. Also,
if bytes is large due to coalesced ACKs, could the multiplication wrap
around U32_MAX?

This looks a legit one, will confirm and fix it.

Thanks.
