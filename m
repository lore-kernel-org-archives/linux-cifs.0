Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794678148;
	b=wJxyfGHN5rKVC0MYT60HDj+cfVCH8YfHjdR89cnWOUuagtKZQQHhifKbPWPvgNoLLRSn
	 fpG8TKhUJgQTQ7lsKaaqsvUDVtLNr8ECdhsGXpR34jBHvGZNrw4VeayczjSgJQUVQ5ma+
	 Zmnl1oH+gcH+zoBsuYkI1F+vMGNw5iohsCDzVlmqsSY9CVx+lcq8XQFJ/VFaFS2AJDSO1
	 mcb9i+9O4SucPzra700tx1v2W2+CYmeKLpS5kOkEHFXqu6yh5grp83pK0m9whOwmdQY3/
	 femVckJKFBkhyHjzs9z391YX9tkqX/euRcz+oTt90KjJikg5bzlhBSbUyDXnMnBUTzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794678148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=SP2UdcMIP5VB9DhKwSmYYPd7qcwbd0CEJPW2lwFlVpM=;
	b=MLasL1M3GyV43X8wxDjCNjp422sTt86nhjKhM64fS+MvejQNjMU+4KxYVOaknZnVoZgE
	 YcSfmco2SlgM7n52XGTSxntyrreCn6VucE4dltM3tGK55oIRPavnDjPQ2YU+kmhD5l13+
	 DMYJtaIqE8bREg2Y5zZ/KoxLghSzMZHI7F3s1xD/WGu2YDk10V5ZzGoWu9NOBlv0dU7T6
	 JtzGxVPCr77fVXc84+2m6L55ummR5HSrjodLsnhtpH6xai4Na1e0Oc+uJqjG0LJGN8RMY
	 3XQJh4RUJNlmiv2X3mvGga/1bwHq0bo4QamS/L7HPKZUlUgbGBtAdRwOqp/FxH9VRnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LFfZbYCv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726E0606A327;
	Sat, 14 Nov 2026 17:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LFfZbYCv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAD71F000C5;
	Sat, 14 Nov 2026 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794678148;
	bh=SP2UdcMIP5VB9DhKwSmYYPd7qcwbd0CEJPW2lwFlVpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFfZbYCvv6RJXd6atmjDGirIasv6pjuUR0HGjgo4ofTdLqwJaecIOMbHZdpOt0dV3
	 i9+1K7izagVaoQPsb397lafsF5qYxkcatr/+0/BuMeXSzsn3XkLR3YIzE9Sl+wTosR
	 B1upQzGyxdhcOjbsuUxQcP48TVQWj8IPUr8wphddu81L5IQtqf3KXRwbVi5Aife1XV
	 ymknfR66KHXn/pkRO9qLDaJ1pTGMkVo96cQfdsevw7wB7kZ5Q+9IxpykNhqi9rUjsX
	 72SW+MZknrQYjVm3AxtueW9fijt5i9gIcV8ji8A+MKirjYMvZKpDXPpn32llZ3sGSF
	 MgqwZYZeWHoGw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	linkinjeon@kernel.org,
	sfrench@samba.org,
	stfrench@microsoft.com,
	senozhatsky@chromium.org,
	tom@talpey.com,
	mmakassikis@freebox.fr,
	linux-cifs@vger.kernel.org,
	jsingh@cloudlinux.com
Subject: Re: [PATCH 6.1.y] ksmbd: fix NULL pointer dereference in opinfo_put()
Date: Sat, 14 Nov 2026 12:42:14 -0500
Message-ID: <draft-agent5-0003-re-ksmbd-opinfo-put-61@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261114114943.5122-1-jsingh@cloudlinux.com>
References: <20261114114943.5122-1-jsingh@cloudlinux.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 2026-11-14, Jaskaran Singh <jsingh@cloudlinux.com> wrote:
> The problem does not exist upstream; this fix is for 6.1.y only.

Thanks. Since this has no upstream commit and only exists for 6.1.y, I would
like an ack from the ksmbd maintainers before queueing it.

Namjae, could you take a look?

-- 
Thanks,
Sasha
