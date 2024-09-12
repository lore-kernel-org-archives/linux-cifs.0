Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 788693A1DB;
	Thu, 12 Sep 2024 14:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726153089; cv=none; b=dVY5IPT0TnMRcGgoN0Kc0JkrHDQ6kWrhit8DQ64+y18Mq/vc87OklBR/JaEJNqjYgOYAGBAnnlBoKHIFUfGzouy1nwRi1zEG2CClBAQQcy/RQuTIbLMNlnFvtYNpm2cgpM+Wzici9wzqaf/3HaKOCDM7iT+GT/kijbznZVxeVLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726153089; c=relaxed/simple;
	bh=LWN0XQ8R0ISShbSDlS7uR86bs77bzSgfW7KPVHHxvTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lp/rSwfbtzgeUK6fx3sJdOWmRm9spW/vJ2lvaA3f4S8hvmc68eXgU1p6t5UMNNtPewvTDqdpNyRn4iko0IZVwaRV/xCRbmes7fvoJmBy8RDfeEHiNqwhuZ60kE/80bkv8hgJogy8yKSEmltusdianZbs/yQAt3RVVbavuTbUIH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JZFwLaZt; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JZFwLaZt"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a07b73cf4eso5017905ab.3;
        Thu, 12 Sep 2024 07:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726153087; x=1726757887; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EwSYGxGurQ2imcLaO+EzXdvdJa/BCUOpOoCzBs2qpDk=;
        b=JZFwLaZt9/z8kCnUz/ZrAntqsn3/zU9g41tOz7ce09H9orPv62nXLK17qltiZ9nYat
         Zh5N2BWfLj746rG6PcSK4X0L/O8a40bS9kyDTvz1w0n1VZPUjye+TLfrWrbwD4Q7rZEx
         i/qQFNRf++WU2YC8+S1F/3rxJbtFM8qTlAysdZNYApbz9LaQRmyV7jM1M8yawtdw6xDV
         wkTgiMr59yITr1CdEkBl8vGq9s2X+Z7IsyUUuQDyMzyS8r9xkisMQbwW32zHt4BH8TD6
         KGSQvb9gyOIvn411V+8L7/bLDjltTOB8iVkF16lUCrF328oPXiVs6/urvW129dZmQhOS
         gruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726153087; x=1726757887;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EwSYGxGurQ2imcLaO+EzXdvdJa/BCUOpOoCzBs2qpDk=;
        b=FgzoxTTKkjFS7y6DgKnihk7jN/5y9C25rcsEroQ0XlD4udNGxavrT/nkLN8sA6TfSU
         6wzv7wm3raDnupBWxOD/e1+rFq2/QmEJUi7QjQkgWjuEtnjUFO+VHjwRL5cYAokP+zZ9
         IcFJcqNANBgrqWekUy3rpnDJgZX+x7EQ9sQQC6wwaUEFChy941thQfuLYcRx4cBTYmJG
         dUzKtmGpS0J2Frt3cKXvo6PbkhBlRw7g2sLLpmRTIJRPa15rtrPiKiqVmyLTje8y2jbZ
         SayjMH48W2Ze/tSrxtg1SfUPJ//fFaWjNskhx6MnXQMkIOn+wV2r6Ve1e6ABzFz0CLsN
         OhsA==
X-Forwarded-Encrypted: i=1; AJvYcCW3ktLfCxH7f64E7JV1jW4uC7e4LNMGfWjSxWVNEHJNeP7pFgX/ShSZvtaZ8sj39GM+WxfEHIGLDOT7@vger.kernel.org
X-Gm-Message-State: AOJu0YzE8IOCmSewCCxxQs5pJmJCO8Wd2t9SFChNhsOU49oJ7qHs9YCv
	Fbth3wBxORNs5TT2s3iu898W2Agh0ovFZcUN21oFw1C80DELQzf+gPa0ZAxmBnh1psMOoA0Vlr6
	POYF1Ts1kRPVn7Mov91zsqHfCHwQsM483
X-Google-Smtp-Source: AGHT+IE1dcFJmRk8rOYMkareqk7kacw/NHqgZiQNqWPZ0okhMBzgiT14nXkJ9dpmaI41l53/EODcOsso9QaC/XpE904=
X-Received: by 2002:a05:6e02:154a:b0:382:b3f8:9f72 with SMTP id
 e9e14a558f8ab-3a084909691mr33962225ab.15.1726153087339; Thu, 12 Sep 2024
 07:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1725935420.git.lucien.xin@gmail.com> <887eb7c776b63c613c6ac270442031be95de62f8.1725935420.git.lucien.xin@gmail.com>
 <20240911170048.4f6d5bd9@kernel.org>
In-Reply-To: <20240911170048.4f6d5bd9@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 12 Sep 2024 10:57:56 -0400
Message-ID: <CADvbK_eOW2sFcedQMzqkQ7yhm--zasgVD-uNhtaWJJLS21s_aQ@mail.gmail.com>
Subject: Re: [PATCH net-next 4/5] net: integrate QUIC build configuration into
 Kconfig and Makefile
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 11, 2024 at 8:01=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon,  9 Sep 2024 22:30:19 -0400 Xin Long wrote:
> > This commit introduces build configurations for QUIC within the network=
ing
> > subsystem. The Kconfig and Makefile files in the net directory are upda=
ted
> > to include options and rules necessary for building QUIC protocol suppo=
rt.
>
> Don't split out trivial config changes like this, what's the point.
> It just make build testing harder.
I will move this to the Patch 3/5.

>
> Speaking of which, it doesn't build on 32bit:
>
> ERROR: modpost: "__udivmoddi4" [net/quic/quic.ko] undefined!
> ERROR: modpost: "__umoddi3" [net/quic/quic.ko] undefined!
> ERROR: modpost: "__udivdi3" [net/quic/quic.ko] undefined!
The tests were done on x86_64, aarch64, s390x and ppc64le.
Sorry for missing 32bit machines.

>
> If you repost before 6.12-rc1 please post as RFC, due to LPC / netconf
> we won't have enough time to review for 6.12 even if Linus cuts -rc8.
Copy that.

Thanks.
