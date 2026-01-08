Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C702D7DDF
	for <linux-cifs@vger.kernel.org>; Thu,  8 Jan 2026 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767894297; cv=none; b=VzsVVlQfMKFv5AK/mvQu1VqDpsQsml79Goj38Cya4dROyngAUVlBQwu6FR+mNrBfk5h85D9lxzXZGsYL4zqTYescZGjdDFbLfqNlLBkAvwbuSRN1bulMWGmgetX7oVsY6ULUCx8lUx9R308D5TvduOVpDo5+sO1ym5RkRYnKts0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767894297; c=relaxed/simple;
	bh=ss/QmZtegoT8QUE92ql/8y/No8UIkLe6lLm4BxyGzgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gmyxxGgw40Yw/iuph60Wn3MA9i84SUdlYVmgARWSU7sVGIK8lFRr6OR5J2xqjx6fBwQQ/mjClVb1lIeiC+X0EOeRof8n4tDI3ij+3723ZX/8HLa0gzomskujwUzUtHmpblGlp2EhXlIOk/rBrfae2DzsLMOYPmuPTpUIlz7gaxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=grvXtx+Y; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="grvXtx+Y"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2a0c09bb78cso17850495ad.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 Jan 2026 09:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767894291; x=1768499091; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ss/QmZtegoT8QUE92ql/8y/No8UIkLe6lLm4BxyGzgg=;
        b=grvXtx+YX8ETlnBUL7z97klEGcrQd5hbLXDFB6kjGgEdItZ619Go+VlsWbhhoAzeI5
         W1e/egTR6d67EoApj4JvkyxtIfI/CLaI9EDUXKvAJVENV3d45e/INBnWMGrLjlyfrwVJ
         uHwkKuMFS2Ubvxs+1MRSxu90lugbcMCsHc+MuruVLLGnMxCSR2ELGnGsPTqXpPdbhIxn
         nqrUqlXh4qXT27DCjttxbqg99aNK81pEJQr4KG20LCtk89AvjnxqKT4a3bEYDnyP45cw
         Aq/d6YM2Z9IwvvZtYAVQsy4V5+P9qr5rLx9aCcqsFj/F08MWGIHbyNbgucep6oiwWamY
         7kpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767894291; x=1768499091;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ss/QmZtegoT8QUE92ql/8y/No8UIkLe6lLm4BxyGzgg=;
        b=XdSNDZ7v3ZgJQ5to99NrBnmwQfQuzebKcb2ap+h66DnPZPGkGTcMklaTjk53z+Kbt3
         uRoAuhwt2kgqDC/4iQylO/sLJw/SmE1fxEWc+ZvxsUm7AkgKCbqBNS68sSxOfcIsc7mK
         HTdaNW45wNV1er5gWmEWWNhMESfbGhnkQoXl3XshmE2SSl9Q+4Owg23JfWUmeZJQUypa
         gMdRbSF6HvbR5t05LXdf91zPtPhBJHo7zLcIHKSHLa3ZtdhcKIn6hbMM2NFISsX6bIZT
         lshGQP5hPa3zWvD+J0ELT75CzWgsfuKrDQhnp4IhAEcBvmlQrO0IHblP1svI5CBoWsle
         SQdg==
X-Forwarded-Encrypted: i=1; AJvYcCWa7BfpcqxQsklOWTWfH3YoFOBIB1mQnszlFi64TISDqg+9Nru2mngDgLdrhCi6dqQPjv+PInb+g3l2@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+Iezmko7q8/DpEonTs8mDBvzjw3DN+8uCxFuVCu/n9kmRpluG
	MpkxDD51TQrUM6vec4AsDM9YgSbLyrn6lfd5Xj/hXejp9pwaEdOda5+6EZlqEz3zvvnsMrC+iOL
	2wW56sYtQZLMO9m26OeSxk8i4lItOjyY=
X-Gm-Gg: AY/fxX7j2ogLdAwBHFN3vJuUOLEXhDU+6csoCk4pZnTRuQbaowtxOWM3Vg6TRUYejje
	p/1g2SeLfHUCYEio9V2a5k0OMOxxGJbrofLb/QknfCwNv93YGUeS0pi5WWqyYDBX90gzSXabcZR
	RDg9qGHAAXa5a7ZFICBBjJP3outphIGFG/eB6B3QoHmHcsVuMUE8UAGGZYLrt+y1lKszKIydQl7
	vxfutjSfsso3KekB0rt3hWE8I3bljIzUr4Y/n0QCCqnDShoV/FBZ9EzI9XkPYskpF48BYg/Hsg9
	yIwmJhz+1KUp15c1WzrcwHrbSDtCs4XoRBRjalA=
X-Google-Smtp-Source: AGHT+IGo23JTAhDe6YZ04HEPRhsvfMI0iFv39hHhbnRbHjZlEOShm5/5yd/f68zNrStyS0OL76jXKcU4YQTPqscbaUY=
X-Received: by 2002:a17:902:d4d1:b0:2a0:b432:4a6 with SMTP id
 d9443c01a7336-2a3edb775abmr78034655ad.15.1767894290166; Thu, 08 Jan 2026
 09:44:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1767621882.git.lucien.xin@gmail.com> <127ed26fc7689a580c52316a2a82d8f418228b23.1767621882.git.lucien.xin@gmail.com>
 <1f31a9ac-01dd-4bb1-9a5a-ec67b381c5c0@redhat.com>
In-Reply-To: <1f31a9ac-01dd-4bb1-9a5a-ec67b381c5c0@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 8 Jan 2026 12:44:37 -0500
X-Gm-Features: AQt7F2o6dW95jyJ167axiY2PfCkYBHxaTuo-Pd8v15qVpoBoDqajatltW2Rygls
Message-ID: <CADvbK_c2YE8KfXE2KP0=a_zaUm-AWNOwpmyeDCQURA3AtbDpOQ@mail.gmail.com>
Subject: Re: [PATCH net-next v6 05/16] quic: provide quic.h header files for
 kernel and userspace
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 10:01=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 1/5/26 3:04 PM, Xin Long wrote:
> > This commit adds quic.h to include/uapi/linux, providing the necessary
> > definitions for the QUIC socket API. Exporting this header allows both
> > user space applications and kernel subsystems to access QUIC-related
> > control messages, socket options, and event/notification interfaces.
> >
> > Since kernel_get/setsockopt() is no longer available to kernel consumer=
s,
> > a corresponding internal header, include/linux/quic.h, is added.
>
> Re-adding kernel_get/setsockopt() variants after removal, but just for a
> single protocol is a bit ackward. The current series does not have any
> user.
>
> Do such helpers save a lot of duplicate code? Otherwise I would instead
> expose quic_do_{get,set}sockopt().
>
Not much, just when using quic_do_{get,set}sockopt(), KERNEL_SOCKPTR()
will be used around the optval and optlen.

It should be fine to change to expose quic_do_{get,set}sockopt().

Thanks.
