Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36B8ECF
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jan 2024 01:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NG22Gmh7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EB3C433A6
	for <linux-cifs@vger.kernel.org>; Wed, 10 Jan 2024 01:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704851391;
	bh=Vn7ITDolSUNz/TurkXQRAUxsU0qF5RHK16tiOjkRIGE=;
	h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
	b=NG22Gmh78Elp5frONF23slw8GNTFzscH6lvjcB6JeABPMJFd8xw+ZR08+YU4w3dun
	 nZefSIRRcSMjUpOxmea+AhNFtPASoZCiA5b8W4ECZcV+gw1NjcSm1CJI30tx3YK7M8
	 55Il3JsfndMMaIpxQmu/Usd2wEdPVhhSbdRFl4DnLsWlZF8QDxbTS2C9PzOQxvUinB
	 RCKNnJVql5oTrNPXLMC3HTW6o6bvui+GsSVK6MTZzc631AFnxNwdDCSYGo7teaRqnN
	 6dptsAZ4UqEvj7kvSjcHvPUYVFfH52W3/Kaxsf6XBtMgwCZ5lPEisgRUdDHwAbpzm5
	 J5uvjyGfY87Kw==
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6dc36e501e1so2538241a34.1
        for <linux-cifs@vger.kernel.org>; Tue, 09 Jan 2024 17:49:51 -0800 (PST)
X-Gm-Message-State: AOJu0YzgCQSoXKJ//2QC2EJD4wtN3tB7gK9nRB0ecaE1nEwT1Jo/gTH5
	oLf6bTpCO4EZE959pyMbxK9/sts6zLZbWuiLI0I=
X-Google-Smtp-Source: AGHT+IFUzWNKqudkCbvHAZSpZU7LR+u8kd2utqId6x1uCNs5j/9c0MhrlQ7xT2z56FaZMPcAnM7l/kbk313VhTffHkg=
X-Received: by 2002:a05:6808:6405:b0:3bc:3699:3634 with SMTP id
 fg5-20020a056808640500b003bc36993634mr379060oib.13.1704851390611; Tue, 09 Jan
 2024 17:49:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:a8a:d4d:0:b0:511:f2c1:11ee with HTTP; Tue, 9 Jan 2024
 17:49:49 -0800 (PST)
In-Reply-To: <20231217134137.3111553-1-haokexin@gmail.com>
References: <20231217134137.3111553-1-haokexin@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 10 Jan 2024 10:49:49 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9uoxosJ2wft=bOW0zu=m8ZH8jogcGn_+YraqL7JNMiTw@mail.gmail.com>
Message-ID: <CAKYAXd9uoxosJ2wft=bOW0zu=m8ZH8jogcGn_+YraqL7JNMiTw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Add missing set_freezable() for freezable kthread
To: Kevin Hao <haokexin@gmail.com>
Cc: Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset="UTF-8"

2023-12-17 22:41 GMT+09:00, Kevin Hao <haokexin@gmail.com>:
> The kernel thread function ksmbd_conn_handler_loop() invokes
> the try_to_freeze() in its loop. But all the kernel threads are
> non-freezable by default. So if we want to make a kernel thread to be
> freezable, we have to invoke set_freezable() explicitly.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Sorry for late response. Applied it to #ksmbd-for-next-next.
Thanks for your patch!
