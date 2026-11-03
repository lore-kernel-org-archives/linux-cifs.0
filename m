Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717550;
	b=olzNrevtSexXwFGPLm9c0mNw8tTaaYTbTwuLG88RzrX6sLeJ7QXuPUuk+S/hJkFwuBBu
	 aAyF7M3y9A5No/gBjOi/kjPEedILjIfbFSwZQLCqTqSfKPqFfBDpoMq7yFt58w7xXH/sx
	 X9BAY4MN5an/r6bFtToVdkvWwSa9eUChePyN69orkV7LlMF8wGgp9aeQtzMssJrwF6Irx
	 wwOrwQD0yTQ1JYkbG9eM44gRLH/+V4Pojon1F5tUG1Oie3NCR8BsRbS4n6uyRhRNhc8g8
	 j85krcjiGenr9EeiakAtzBnW54cwpBTlNTbMwUeasISFqMKbBSvDkDdpq7f60XUFE7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717550;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=AJ1WNah6upJaca386WWHlJshW9ICPmM2oD8/Sgenk20=;
	b=NCav488LT+aNQCzuUm6ATrtJMeJwMMtam7LBtsZZlQPj2kn8L6PZgSqU1PsFOyayA5BR
	 kv+qlgsR8GFxQlFAWoZfofyzqbRLWYF20qQXoeeSBySd8XkMyXAbbU73zwVfoO0Jrmn26
	 OtSgfWRTU13mOn63Rm8dfRIwYX7jul+lADD2OeV/l/4pN+NVDHMqFZgVc1OjrZ46VBv/9
	 9+HATn4Jb92J7/QNRuCXUgGxxHmgC+2vmQXDHtBJ+9QNgaF2vtm2GjYjw8Pde9y4t6ycX
	 s6BGjOKaHPK5+EyDVn0ky/MtNdkg306sIlazHNEn/PlszPQXgt9DVRgEq9+RoZ7Fl2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jYUY5Zyf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B91C606BA0F;
	Tue,  3 Nov 2026 14:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jYUY5Zyf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9798C1F00919;
	Tue,  3 Nov 2026 14:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717550;
	bh=AJ1WNah6upJaca386WWHlJshW9ICPmM2oD8/Sgenk20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jYUY5ZyfoOJRN2d3S4i1I88kEP1E9sCQjXpsW3afPmkxfvTByN6fFPsypCTLB7UcU
	 kiDW8TlLaPcchufTRbfcp/lGb9kq7lFgyPSfzTrMSZIFhzD+3VpHyasGp7oGETQJzC
	 7FHYyV3uWhQaa1KlUAoFeWZYwbUJOslhSdqwxtZxKFAAFKZvJ+/CseyP/bh71ZE+pv
	 p6MLo4GOThLr9Of9hAZmgM/XuLJp6I4MdZSALRiQ2KujaNEzs/Hd1bNNsfTpXfVg2e
	 L0r8UiczTZ6RbS0SfLEhRXWFOPQSvqkG9Y/HfUDCvGtBMGsmLMwjE7QpKkXk6ZV264
	 xfSu+cV0XgKBA==
From: Sasha Levin <sashal@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y] ksmbd: fix breaking_cnt leak on early return in oplock_break()
Date: Tue,  3 Nov 2026 09:52:02 -0500
Message-ID: <2026-11-03-1-daily-reply-0014-re-ksmbd-breaking-cnt-leak@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103110803.2517085-1-joseph.qi@linux.alibaba.com>
References: <20261103110803.2517085-1-joseph.qi@linux.alibaba.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

> For leases, oplock_break() increments breaking_cnt before calling
> oplock_break_pending(), and returns early when the pending check
> reports nothing to break

This is a stable-only fix, so I need an ack from Namjae Jeon on the list before
queueing it. 6.18 and 6.12 have the identical bug and this patch applies there
unchanged, so once it is acked I will queue it for 6.18, 6.12 and 6.6 together.

-- 
Thanks,
Sasha
