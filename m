Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04AD1C27;
	Sat, 14 Sep 2024 01:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726275945; cv=none; b=p0sdqh4OxsAhwd5mgYDRkl+lztUbQkrBFHjNixigLmfW/CXPs7Aj9dUC7RFVbOeXMTrZbp0oNp+FEvPupFmYY6yiJnmLM/QAfrh6c75O6mGiZHlc8kvtGKGx2lWBCMkh7jFELKZPxkGEvKB0/omy8Q0E3KKbynsq/g1iZ3U192I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726275945; c=relaxed/simple;
	bh=9gy7LiB1QQHwZI+Pdhi5cz/26o44zIsBi1OE+6liICY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DLccan7ezcv1/NJIVUGQkkijt0qTpuZ8tnSlW7NZN4WzBOw5TTlnnA8vOceroufi2lcBfa71QzF94Q+IOR9uu2OnHR02mvM3L3uaLEkReCalTrwWJoYfYcVXfAc5ykA9gD9scid6JG8qVP4NDnijrPq9Jfz+pMwlwdD/B3igJsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cqZJKQHA; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cqZJKQHA"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-20551e2f1f8so16828425ad.2;
        Fri, 13 Sep 2024 18:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726275943; x=1726880743; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GkiDsRe4AiGLxd5SW64hD1FIKOllYw7LyinEu6P1pMI=;
        b=cqZJKQHA8KHvTixK+X+0SsZkIkTC2eK5+Yw1cB7VTD+ziZANLcJ5eIdSzOaor06kr8
         Z01dRG2yFzsq2flfEzxZvQIz4whvl7/b9JVsAU4xo5WoGPmRlPXhB28Sf6OyFsg7y+xp
         3U+5GoXC91BOLiH8vTpaKNTBj2ijVErdSdj6palfAtONpOqTpghbzxPbfnANronQWWSq
         56LoY0BtFi6oYG5mAeVkAbWHoVhdaphKiqKSQmYzUEHl3KwHnSiQqzHuuA0fNBAhrc/F
         I6YFqgJvK/yQVnku3vRjk+MoPAyXzGsmv48BJjNi465jNpbWZZEL9nknOqmeXPpLhjzI
         jFdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726275943; x=1726880743;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GkiDsRe4AiGLxd5SW64hD1FIKOllYw7LyinEu6P1pMI=;
        b=BQaYj0guZVaCxoozdPO/8p4VAeVfcAYJ0Oi0fl4xE841rC0wBT1L/Q1Qn5DrfArsNk
         nWNu1ns6Z82XOdsMxC8wYY8sQsllK7WQrYojPNsMff4pGQbEY3+X7vI40WF4UwK6oKsc
         NAhW/Yh3OeKHb0YqQh1+QijLKpatF4u8iQdwCOnKlj5siPvxuBqc6i/ezerlT1wquNVH
         ABMwXvVyXMQR6wd961PuBH7/1EHwjjV2pe5HJ8ylhjS1QuV5uv7rOXPRoUnrGcP9CsPx
         +wd7LWKrc0OLZCM3y89NKvhMOHvcMZNSilhAmUcPibn7MUIpFkrWx/sWbgUIwdhq0AIk
         ytDA==
X-Forwarded-Encrypted: i=1; AJvYcCWl7nBEsIt2uhFSGlPRcYtB0l5Jh+YAt0Hy6LibxBf5YetX+07aZBDSfen7HAGpm6T9l1UCABNZvKJC@vger.kernel.org
X-Gm-Message-State: AOJu0YyxHUnGotrkxJfrc067W7p4w+7/dywOstWk0dhKy/PH1HmuhqPP
	G21vtG59TghM4w/nA8CrUECMPdOsy7zQ/mg4c/ULqfjKLsz2LgW8ier5Hswpfds=
X-Google-Smtp-Source: AGHT+IFumMGTNCHfWNRCOO+XP+esgYojDUGb/+5tHXyYx7D6FCQQ/vya83X52c7WIjgKSX/L0q8ryA==
X-Received: by 2002:a17:902:e84a:b0:1fb:57e7:5bb4 with SMTP id d9443c01a7336-20782a69aa5mr67763765ad.37.1726275943018;
        Fri, 13 Sep 2024 18:05:43 -0700 (PDT)
Received: from localhost ([2601:647:6881:9060:97be:e4c7:7fc1:f125])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207947365ddsm1937725ad.283.2024.09.13.18.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 18:05:42 -0700 (PDT)
Date: Fri, 13 Sep 2024 18:05:41 -0700
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Moritz Buhl <mbuhl@openbsd.org>,
	Tyler Fanelli <tfanelli@redhat.com>,
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org,
	Steve French <smfrench@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Stefan Metzmacher <metze@samba.org>,
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>,
	kernel-tls-handshake@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>,
	Hannes Reinecke <hare@suse.de>,
	Alexander Aring <aahringo@redhat.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Daniel Stenberg <daniel@haxx.se>,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next 0/5] net: implement the QUIC protocol in linux
 kernel
Message-ID: <ZuThZdPILnCKpOmO@pop-os.localdomain>
References: <cover.1725935420.git.lucien.xin@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1725935420.git.lucien.xin@gmail.com>

On Mon, Sep 09, 2024 at 10:30:15PM -0400, Xin Long wrote:
> 4. Performance testing via iperf
> 
>   The performance testing was conducted using iperf [5] over a 100G
>   physical NIC, evaluating various packet sizes and MTUs:
>   
>   - QUIC vs. kTLS:
>   
>     UNIT        size:1024      size:4096      size:16384     size:65536
>     Gbits/sec   QUIC | kTLS    QUIC | kTLS    QUIC | kTLS    QUIC | kTLS
>     ────────────────────────────────────────────────────────────────────
>     mtu:1500    1.67 | 2.16    3.04 | 5.04    3.49 | 7.84    3.83 | 7.95
>     ────────────────────────────────────────────────────────────────────
>     mtu:9000    2.17 | 2.41    5.47 | 6.19    6.45 | 8.66    7.48 | 8.90
>   
>   - QUIC(disable_1rtt_encryption) vs. TCP:
>   
>     UNIT        size:1024      size:4096      size:16384     size:65536
>     Gbits/sec   QUIC | TCP     QUIC | TCP     QUIC | TCP     QUIC | TCP
>     ────────────────────────────────────────────────────────────────────
>     mtu:1500    2.17 | 2.49    3.59 | 8.36    6.09 | 15.1    6.92 | 16.2
>     ────────────────────────────────────────────────────────────────────
>     mtu:9000    2.47 | 2.54    7.66 | 7.97    14.7 | 20.3    19.1 | 31.3
>   
>   
>   The performance gap between QUIC and kTLS may be attributed to:
> 
>   - The absence of Generic Segmentation Offload (GSO) for QUIC.
>   - An additional data copy on the transmission (TX) path.
>   - Extra encryption required for header protection in QUIC.
>   - A longer header length for the stream data in QUIC.
> 

This is not appealing.

However, I can offer you one more possible advantage of in-kernel QUIC.
You can think about adding iouring support for QUIC socket, because that
could possibly chain the socket fastpath operations together which opens
the door for more optimization.

Just my two cents.

Thanks!
