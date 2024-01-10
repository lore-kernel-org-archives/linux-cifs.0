Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02DD4B5CB
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jan 2024 18:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dj0M7TTe"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a294295dda3so519971466b.0
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jan 2024 10:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1704912746; x=1705517546; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m3UJsqaOgk5eE2VQnILkdg8C0bn7x8fx0mLavVcEL4o=;
        b=dj0M7TTece/M/QVsuPimKT0XNEk/rCwQCicsBcOo/zK5UTjIdCDgPHDJpNLQ8Hh4Ic
         0KvcAJrCIyHNWQNK+evF9RQH+wmD/1SY88mH34RH0m5rM2T3Q5zkO/VRWZ7qVuXTPttg
         GqfmbbXMv8haRE5h2kLXskNPeCt0sDQVIS3r8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704912746; x=1705517546;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m3UJsqaOgk5eE2VQnILkdg8C0bn7x8fx0mLavVcEL4o=;
        b=psf9qNzulMgtJJx+EfoOoNmlp/wOAB9ccmJ1oXG1x0nMmg4IwprPbCeOlUjLFE8mio
         8kIqvcDv5OTCOz1YyffN2aEBPAPyF0YBU5DHYz/aFyON1uGJZ9q0+A7erbXG2mx1IZWC
         mX4I1N+deqebeL2TxxNrcpeMuUcRIlVOxuX9A0hg4KMIfo2O9BlFYbWEp5YVPnfCwNK0
         LrHGn0hDun6myWXW6IUDGNfKfDjSQeEIdTzKP/oLV255MX5HJlEBt9kzhuCMVi3WDhGy
         sotIS3GLGW67eChxHAJIcMHmT1WJnun4L3uDGv+HGObXGkAiwyKpE8vwveJeX4IKida8
         ILag==
X-Gm-Message-State: AOJu0YyfQO5PBlkYFZS6nJE9u9xVzbP2anHLf+TdfkQhfX4Kj1gz2mKT
	x/WUjcPTk0vay90Y5I8Y/GzHIUo+cZjIcZQP50hfxs/F1QP4JkbL
X-Google-Smtp-Source: AGHT+IFcgI5gVEiUR8OwQZ0hJ297GH2RL9zS3xtNx5Slx+EsihAfDJrk2Ak0p0YaUcNQABGEmPn5vw==
X-Received: by 2002:a17:906:4546:b0:a28:e66d:6df0 with SMTP id s6-20020a170906454600b00a28e66d6df0mr415028ejq.10.1704912745824;
        Wed, 10 Jan 2024 10:52:25 -0800 (PST)
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com. [209.85.128.49])
        by smtp.gmail.com with ESMTPSA id s9-20020a1709060c0900b00a2c189de7b8sm293628ejf.124.2024.01.10.10.52.24
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jan 2024 10:52:25 -0800 (PST)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-40e4582ed74so37434505e9.1
        for <linux-cifs@vger.kernel.org>; Wed, 10 Jan 2024 10:52:24 -0800 (PST)
X-Received: by 2002:a7b:cb45:0:b0:40e:4ada:b377 with SMTP id
 v5-20020a7bcb45000000b0040e4adab377mr402184wmj.62.1704912744493; Wed, 10 Jan
 2024 10:52:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZZ4fyY4r3rqgZL+4@xpf.sh.intel.com> <CAHk-=wgJz36ZE66_8gXjP_TofkkugXBZEpTr_Dtc_JANsH1SEw@mail.gmail.com>
 <1843374.1703172614@warthog.procyon.org.uk> <20231223172858.GI201037@kernel.org>
 <2592945.1703376169@warthog.procyon.org.uk> <1694631.1704881668@warthog.procyon.org.uk>
 <ZZ56MMinZLrmF9Z+@xpf.sh.intel.com> <1784441.1704907412@warthog.procyon.org.uk>
In-Reply-To: <1784441.1704907412@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 10 Jan 2024 10:52:07 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiyG8BKKZmU7CDHC8+rmvBndrqNSgLV6LtuqN8W_gL3hA@mail.gmail.com>
Message-ID: <CAHk-=wiyG8BKKZmU7CDHC8+rmvBndrqNSgLV6LtuqN8W_gL3hA@mail.gmail.com>
Subject: Re: [PATCH] keys, dns: Fix missing size check of V1 server-list header
To: David Howells <dhowells@redhat.com>
Cc: Pengfei Xu <pengfei.xu@intel.com>, eadavis@qq.com, Simon Horman <horms@kernel.org>, 
	Markus Suvanto <markus.suvanto@gmail.com>, Jeffrey E Altman <jaltman@auristor.com>, 
	Marc Dionne <marc.dionne@auristor.com>, Wang Lei <wang840925@gmail.com>, 
	Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	linux-afs@lists.infradead.org, keyrings@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	heng.su@intel.com
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jan 2024 at 09:23, David Howells <dhowells@redhat.com> wrote:
>
> Meh.  Does the attached fix it for you?

Bah. Obvious fix is obvious.

Mind sending it as a proper patch with sign-off etc, and we'll get
this fixed and marked for stable.

           Linus
