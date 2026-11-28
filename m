Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795832891;
	b=c3kYcczT/C42C0mAkrdoxGg7TIVCwu97Vj1Rhyy8Lbv8WEx5aDqsd850qFX4xufiCnnm
	 6IttyZAOoFfTa3oNVSUCn60v3az2pZuzks6cWTIC6ZYjPtfW12IP2UWfi8WP8bCo3+q0L
	 udID1SdHD49L3TqlTMJqlii9coswfct3l6EIZjIXpxeb/xuCBY3j7at+Q80yroJ62ZKKg
	 fD6wMvzjOk6k7pA6Au+JT8JMOLMGqq7L92+g44sDzApn9JbTeYbqQlA5AvQSlD1Lr7+wn
	 h4UFLCEYQLP7rjwJ5u3iqpioNlJrSAgdFpCg9aB8qPjHUtTj6sP8DZAvTMVxjXX332g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795832891;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type;
	bh=c1c/DesJfIYeB0WsoQ8tXGiEzQczhVXU/PKcW1gWX3k=;
	b=w6MBvWc9f0iW92Vwp9WeNNSaTeNI+1ngmbp+8rwDei7onUeeuDd6/vQ0FT4EW0igpDWN
	 HzSp+CYWhoqF7hNHWRLJVS22mq3KDHsgc9+g/jM+rmZkjgDor+Erx7ZNlDlNFOXPfB1BM
	 a2onQlLNMQGj/gQ28f0OrGJ96L2YfzZhL+Tr2Zw4/cGRwr8v2NKJwTOJbFIaNcc+VQin7
	 4k2CpodiVjBBSsKRaTYomvFdG0C1eOAhiZVCh9uPJG1LR4vpsWI2OWGytSqrUKiW59L2Y
	 bB2pixHfWP94Ht4bKQzrNPmzx1G1lr0dCVzcsuUlf8kHMPhmQtpVl9Rht5LOKhQPV8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EGYoA9hh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176FC606A333
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 02:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EGYoA9hh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884021F0089A
	for <linux-cifs@vger.kernel.org>; Sat, 28 Nov 2026 02:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795832890;
	bh=c1c/DesJfIYeB0WsoQ8tXGiEzQczhVXU/PKcW1gWX3k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=EGYoA9hhCjowWdIAbP7tXR7N3fUr4v+CF3Lg6C9dczDRQRvDBJPnfyBjAFIjKVrsV
	 CvKjxO/JZ7+LVw6Uw4nIOhDQmh5MvUeItBXvDiazTiMrR3JQP+nx6IC1InwcJz1huz
	 wc9HKHi52k+wq7HYllG+tw7VXo6seoVEiADiScI5QeSClu3fv1Xjz1ZMg7vHYmZZ83
	 TDk2ScXKL1/yx4hdSRM4onuQypX0OFAJdu8NcNq12oTs59Op1m0lwro+YH6mbWluI9
	 B3gbNd85MSLuuqMc8osMx4SOni8rdcr+LQ3Oy3PlxhHVXcB3OAea2c2NqcNaDocezD
	 UuTkyFHvXdkmA==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c513a854320so501038966b.0
        for <linux-cifs@vger.kernel.org>; Fri, 27 Nov 2026 18:28:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGllSguk/0113X2Aqf7zJdevB042z6Jps8gRtAngmb8w2Mn04qUyipGIa9ong1Y1blwaG3iP0fr2Ffx@vger.kernel.org
X-Gm-Message-State: APuU4Z9S7q3jZKT2NJsau1k7VWiv41iGAZRKHD4RsDjsm/4RzdRGDhJ9
	JSadYS5eCjr9irS6Gw4WZpmzds8tmJX17ZSjsDvMp0xV1M5UF7YJQO23wchSbprqIAm7of0iGUJ
	Qf8q1DxCWn8GCkY3bdBQcSEqecYEpMqg=
X-Received: by 2002:a17:907:3e88:b0:c26:1648:a06b with SMTP id
 a640c23a62f3a-c513aae0416mr2230275866b.38.1795832889217; Fri, 27 Nov 2026
 18:28:09 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261128013952.1691873-1-icb@fastmail.org>
In-Reply-To: <20261128013952.1691873-1-icb@fastmail.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 28 Nov 2026 11:27:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-qC2UZbsOUEWvt3mhViwOyvHEqHt9hLK5+aiiuMC-4iQ@mail.gmail.com>
X-Gm-Features: Aa3M54ooocUz19P9sN5SRm16xxX0RdiCpiepjGD7Php6t0kAfJjqhfTnDb74ptk
Message-ID: <CAKYAXd-qC2UZbsOUEWvt3mhViwOyvHEqHt9hLK5+aiiuMC-4iQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: return the cause of a failed link
To: Ian Bridges <icb@fastmail.org>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> @@ -8967,8 +8965,6 @@ static int smb2_create_link(struct ksmbd_work *work,
>                         goto out;
>         }
>         rc = ksmbd_vfs_link(work, target_name, link_name);
> -       if (rc)
> -               rc = -EINVAL;
When smb2_create_link() passes through errors from the backing
filesystem, smb2_set_info() needs to map them to the appropriate
NTSTATUS values for FileLinkInformation. For example, vfs_link()
returns -EPERM when the filesystem has no ->link operation, as on
exFAT. With this patch, ksmbd returns STATUS_ACCESS_DENIED. The
expected status is STATUS_NOT_SUPPORTED. Also, -EMLINK should map to
STATUS_TOO_MANY_LINKS. We should check the NTSTATUS mappings for the
other errors this patch propagates as well...

Thanks.
>  out:
>
>         if (!IS_ERR(link_name))
>
> base-commit: 4543a3349127baa8395397b7f4aa930d9a4f8dd5
> --
> 2.47.3
>
