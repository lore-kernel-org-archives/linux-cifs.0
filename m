Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792669749;
	b=x/HJ54Swkzf1VczWzTsv6CvcQ8MzbpTvOX5Z+Pv0xOV343KezSMSa3lBTwuWjCY2+DWA
	 xbM31UHN/KgGTewbzsfxzywfZnu8XjMLJ0CLmEEYi+QGc1nldqiguC0sGy/+UfL6CLc8r
	 bmAPy6OBIhXyEZAmyl0kUj54cEQ4C2zDd9tMrdKuI2qPQS2uv/M1zol+f6QH5BN/8t6s4
	 5S/GC4w3RSkEARU/XaRMMMhT8vWoKTdrfRy1CfhLoFU6t7RVsRV+XZ8LCyXnmBBwqplbG
	 gzUXfVfH71QhXbrXn8aMZXCKmK5RKat0g0SDCndhFqJHjv+84l2jCr/V/vnqjDZyWvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792669749;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=D3pqen6XtofwE5K6hZVB/4ljEI0gtaGv/M0XzvrbPe4=;
	b=xAwBStd35nhtOdo8cE0qeE3vo6Ld2ySleou7j3nnMGDbnvAvR4lrhPpuO5u6V6zzzdIf
	 7Q33aK/KvbhKQmf57WpDYdYHLOLpewuxLSOxQA59EBn93spbQ1rEMhapmQqMR/4ll2rPq
	 PAAKhOR0JL+OJbQGENZ18DWj7IXx87bxZ83843I4h2axkmRQ/QmsrZAwxUY63qrwqWXpn
	 cpcBaFyPFJMysBcTAWVYB5+Gr0YAGQWl9366/xZTKrXiKbdEc1xwo/p6Tuc2YDCISYNTq
	 rxAZzejwYbzope9ZI6hEZGZO7kA2HpofDiE29TfNWRmegt0DUYUzFIU1TLtS7vJNekA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRSMXNLL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E90606A319
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 11:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QRSMXNLL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F7301F000C7
	for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 11:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792669748;
	bh=D3pqen6XtofwE5K6hZVB/4ljEI0gtaGv/M0XzvrbPe4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=QRSMXNLLnqYfwvBj9SRe2RkGdQJc0AEECJGc/6lDCWM37e76OouJ6wmRbHY5XctRS
	 sh7DORNxi7DmMdlrIpcSg8Sn6mdUngCAN3/xwFgIuNC6CvLxgSH/7AkIBPzPUHc5u3
	 ihDE+W69NfqLGL1vOA3a1bHtP2GnHQInQM9KvLINPbau+FdFmIIS2pgIZvL4CZvuTs
	 wERe1WYxSiICjDX6JtXFOWsMLXKSl5GzHF4DMAhl0Pjh74S1wLYprUyhEpph0CVsQN
	 zA/sCIWa98tXlPBUJ9rfdd75yBodUhE0d+7P3/WGJLDrepdSkWjDPHiwZlOLgqN0Jn
	 BWrXiL7XTBK0Q==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c2afa22e1dcso224096966b.1
        for <linux-cifs@vger.kernel.org>; Thu, 22 Oct 2026 04:49:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzoKzoQEWlu4xQaQFV5KnrOWiyzBXqUGC1ZM9iZ2I05mCLACpBSfxeqVu26puMBki8a3EFtYdIIO5l6@vger.kernel.org
X-Gm-Message-State: AFq9FYIxjFya5YG8Q2ItxEydgD9JdwfvKTmpw71TQjOGBjcSyBlLIIVM
	LoCigOmI7/oirDncCFDFYmLK0MQ9cN22Sn3VPKyF8Ec/nuirZHmiNqQmMRhHLTx++nYvNsKJOGk
	OaGAYegUApoCXwyDwlDj1ZTJp4+iEH/0=
X-Received: by 2002:a17:907:6d12:b0:c31:8984:7fad with SMTP id
 a640c23a62f3a-c4679611ee4mr506777366b.15.1792669746875; Thu, 22 Oct 2026
 04:49:06 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261021115400.30885-1-mike.michalo@gmail.com> <CAO+rqLj5rF8MGMTRSav1n43NqLbazwyuPsPKgiQT2qtP+EDxeQ@mail.gmail.com>
In-Reply-To: <CAO+rqLj5rF8MGMTRSav1n43NqLbazwyuPsPKgiQT2qtP+EDxeQ@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 22 Oct 2026 20:48:51 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-D=8fK8rT0aCrpPEe7ezQ7Q6qdOiAy_tSp6Yy0z4T8cQ@mail.gmail.com>
X-Gm-Features: AclHuK94t22vzU3h4aqXcwOpvZpOlnnNQW9zL_24PA0tOKWccvisgbBgdOZ6eMg
Message-ID: <CAKYAXd-D=8fK8rT0aCrpPEe7ezQ7Q6qdOiAy_tSp6Yy0z4T8cQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: restore Kerberos logins with released ksmbd-tools
To: mixalhs <mike.michalo@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, regressions@lists.linux.dev, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 11:14=E2=80=AFPM mixalhs <mike.michalo@gmail.com> w=
rote:
>
> The ksmbd-tools side is up as
> https://github.com/cifsd-team/ksmbd-tools/pull/347
Okay, I will apply this.
Thanks!
>
> Michalis
