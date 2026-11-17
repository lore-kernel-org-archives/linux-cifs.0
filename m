Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.97
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794905509;
	b=EwJHUntJZzX3quH2PDzp3yalkJ9bnixHm4mHx0CBsGaj/B6ZZfE8A2nrTvjIJDC0w5iB
	 VdePEipKzPvrC2sKA2rKEqHA4etlOeRBV1JAxERaUDPyeoh5nFLtTOvOnpJS7YYKlNrEK
	 wQT15QYh7J4Ql+eOVcSshSHePzb9WUCctAAO+FGvXCUdLEZVmLlmo0ARF4FzOIWmR8Mm0
	 uvvukrCvZLZhj6TgMZhL3TdZozY22+VHqZ2v+qNs0MhgiA3ne1qRc/DWn8eXmQBEPw7xf
	 RO+X36vX08xUiqNNdC+UrTFBfuq7Cn/UMa1gpe2BBC9p+CSCaWBwcsDYpE9lHfXKoYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794905509;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=s4yCKzF4YDIiI5PlcqBi7tYBGUxCwcilhm4zOkc48Yg=;
	b=YnEKYB9BqZQQnajE3yIGN9GmJvAjQV+uY61LzR2NHHG4k4DF7xo3mIbhDThibHr8TQ5T
	 fDXEA03f1XutXpNXqpLiqYimlwMNCOBMjjETzzo2ayhqivYKeKdj7lbZiBy5DvBBC4mwP
	 Z7GfU7m7MJcDo/JrY1h1hWmETAoaKlHD90aNDLpGDlsJL/1hIIkyfpYXG+ijFAB+9BT1E
	 AU/9/tIPzAlkw+/wVfb4szklnit8kpYRENQZIgXGUWbzHuZ2uKogqE3rM4l1M63N6EF9K
	 uJHH5kn0Ri8Hn6Vgd0OLpHMMo2PieDyScnuQsuv5ogjjgAGqzYkAX9UHOFXIjF4Ks2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=hB58cieY;
	arc=none smtp.remote-ip=209.85.216.97
Received: from mail-pj1-f97.google.com (mail-pj1-f97.google.com [209.85.216.97])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D083606A882
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 08:51:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8D083606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=hB58cieY
Received: by mail-pj1-f97.google.com with SMTP id 98e67ed59e1d1-3b37951a397so2169570a91.0
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 00:51:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794905508; x=1795510308;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:dkim-signature
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=s4yCKzF4YDIiI5PlcqBi7tYBGUxCwcilhm4zOkc48Yg=;
        b=XwHdEG42KM63AkoSQ84nftQN9RlT6vJnohmgiAn2F1P6RjQ75SUt278y4UYVOFXJrt
         /E/o6fOEeUxiPqIuzd5SHczOmbypcrjAdEJQR2LwwLLe6MT6oiOdKrdxNAdyzDaLW3Ok
         OIro8p66cqBCSM4HZxmEKP7j5wwTlI8f+dGqPRMKx2SAOengyZlvIoN2Mlfo+fI80JVx
         Fxsg6f3iSZB27F5ij2oefwJ7D0wkltid6cyc/3PRYKWuKZfkUSfuNbJ/zTa8On1jcOJ6
         8ABmbM5TQt++Sgn+vB2Z7t5JeXLT71hqlkcrqwA3fWbbEaZl+aGL1Hul122/nQeCCxjo
         M/Yg==
X-Forwarded-Encrypted: i=1; AL+hErFsariFDLrCqphN776pyvBh9AC2tZ1XE/XKo0lmkU6up4zjT3Ptbu0xoEqh4rhvvh1DKp6k3an34z+L@vger.kernel.org
X-Gm-Message-State: APuU4Z/eflt8z58g3rNspcsZ47c9LvoMj2BqaJHjRPmbR/rrPvp5BnDU
	gUAc+BvlUY0pzvJxP+kfBEWpUk4I8Lilyujk+MVmPjvnmLzRcNPZ8vGqoDMYpSgfiA/QSnSVM08
	Ym0HJwQzD/0zvJMjLu+QlGlq4VlLifpFPhscKyLmWcyNktuDHJY9RO0cIWU5sK7RHV7P0Dq2BLL
	U+THWCKYqWDOBAB2ctXLLSQQXom42Dj6FyWHuWEyKRfe9yXDog6eWsOkmRVvAZ5vVogjKQWiuhs
	jMJxX100joXZcJ4nNw=
X-Gm-Gg: AZFdTZcbDTz91iVcQWl9TytZ5SlGXPy9Svto02IEy2mOSGAljk4SLiRQ2IK/b7caLxH
	5aKhkYMAbS5BUt6J9zJ9+DRxJcUAdv57HQwuoMnNgmLUa5JYWKSx+SPwH3NIyvqMXVy8BDIe08G
	fv9VAQXLP7/H1DSsEKxq2lJpsHvCE9PYVFhRfvMKLbkaxNtPRB7+C/DOkr3LcCsrcl2IjkwdBdp
	pFa3WVBJ96OINQYV7oPKDEWP6SzfN27KK6DI5PhzypCQQ5g6ZLwXHQuUGuj9YkbgaxVtXxkvfvt
	GKjgyYTqnCfDX36fKLV/8em0YiiRvoqjJnFKyP0ADP0wxNitdai5Qb0Np7C4FGDg2KwsM5pr/cs
	gCBL9XcWzV+OAIchnLuZbExTTUvrMpmbehJLOlaWcMitR6cyUrRS9unHhD6BKcY/k3pvt3op7gz
	3VUP8znwKxiCVZVujjPWcuMx9l660FGEf+RHpqfA==
X-Received: by 2002:a17:90b:2245:b0:3ab:24b2:9016 with SMTP id 98e67ed59e1d1-3b1b0b8c09dmr13575379a91.25.1794905507719;
        Tue, 17 Nov 2026 00:51:47 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-28.dlp.protect.broadcom.com. [144.49.247.28])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3b1b25dd0d5sm5979977a91.0.2026.11.17.00.51.47
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Nov 2026 00:51:47 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a065e2933fso5900951b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 00:51:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1794905506; x=1795510306; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s4yCKzF4YDIiI5PlcqBi7tYBGUxCwcilhm4zOkc48Yg=;
        b=hB58cieY5b8UwhK1MBXmQ8KGG0LZz8/e5NSGWg6whcFiDUdWJ3ilIoNekl+HyBk0Dd
         qjsFbLQ8yyU9+rMOplOuiPp4mR7t5V+zOU66yJGPVJESgEh2RWlOY0arvu0YQBGVRKuZ
         7cpC3C1yzjKHMiQSkRxarMVSAyY80Q6QlP/9Y=
X-Forwarded-Encrypted: i=1; AL+hErHXQv27peOI5LGM5xmQZaNjANaq2p6jxnsfqtHzEgKbYEncr/Etd7XdxJ74KfzUUT+pGg7LzvKYgfki@vger.kernel.org
X-Received: by 2002:a05:6a00:4215:b0:883:71f6:5fb with SMTP id d2e1a72fcca58-8beb5bacc27mr13819088b3a.13.1794905505990;
        Tue, 17 Nov 2026 00:51:45 -0800 (PST)
X-Received: by 2002:a05:6a00:4215:b0:883:71f6:5fb with SMTP id
 d2e1a72fcca58-8beb5bacc27mr13819068b3a.13.1794905505604; Tue, 17 Nov 2026
 00:51:45 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261116074849.475815-1-stefan.chulski@broadcom.com>
 <CAKYAXd9KT=1vLYsnRKxmiM6pLJQNACXuodD8wNQzb8S5apiuRQ@mail.gmail.com>
 <CA+Fu+LPL7xqpV_vjjjehedOFtuuBqgZHZTSqJ+FgweUpYo2uBw@mail.gmail.com> <CAKYAXd--x9UajLQwzRUwxRZ7PFW5T02xyHdSAnThAo326p_kxw@mail.gmail.com>
In-Reply-To: <CAKYAXd--x9UajLQwzRUwxRZ7PFW5T02xyHdSAnThAo326p_kxw@mail.gmail.com>
From: Stefan Chulski <stefan.chulski@broadcom.com>
Date: Tue, 17 Nov 2026 10:51:33 +0200
X-Gm-Features: AclHuK_RHNY-A8YWsfLMtfZRg8kMifDdxlLsMR_xEYE8xYRbaSFIuqvBKZGGKlU
Message-ID: <CA+Fu+LPnXMd9rMtywkZL77XzLq8n+8AiBW2T8Cau10YnVbofiQ@mail.gmail.com>
Subject: Re: [PATCH RFC v1] ksmbd: add use_unbound_wq module parameter for the
 ksmbd-io workqueue
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ilya Lifshits <ilya.lifshits@broadcom.com>, Huiwen He <hehuiwen@kylinos.cn>, 
	Gil Benamar <gil.benamar@broadcom.com>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	bcm-kernel-feedback-list@broadcom.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, Nov 17, 2026 at 3:34=E2=80=AFAM Namjae Jeon <linkinjeon@kernel.org>=
 wrote:
>
> On Mon, Nov 16, 2026 at 9:52=E2=80=AFPM Stefan Chulski
> <stefan.chulski@broadcom.com> wrote:
> >
> > On Mon, Nov 16, 2026 at 2:10=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.=
org> wrote:
> >
> > While both address the underlying scheduling limitations of per-CPU
> > workqueues for ksmbd, my patch introduces the `use_unbound_wq` module
> > parameter rather than changing the behavior unconditionally. Because
> > the optimal behavior (cache locality vs. load balancing) heavily
> > depends on the specific workload and platform, this approach keeps the
> > existing per-CPU behavior as the default while allowing platforms to
> > easily opt-in to the unbound workqueue when it yields better
> > performance.
> Could you provide the benchmark setup and actual results? If
> WQ_UNBOUND generally performs better across representative workloads,
> We could make it the default and provide a module parameter to opt
> into WQ_PERCPU instead.

These are the results from our embedded systems featuring dual-core ARM CPU=
s.
The benchmark setup is fairly simple: writing to a USB disk over the
network. Because the network traffic is a single 5-tuple TCP stream,
it is pinned to one of the CPUs (depending on the 5-tuple hash).

We tested this on two different platforms and saw the following
throughput improvements:
Platform 1: Improved from 178 MB/s to 210 MB/s
Platform 2: Improved from 215 MB/s to 263 MB/s

Regards,
Stefan
