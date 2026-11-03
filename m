Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793717539;
	b=IMPJJr5EpA+yVbN/bOEVPL21Kk2A4fNja7ybmV3irtSkK+oMIfScKoKhMkuimxV20RaM
	 m6lmTnAHxBt8M38LlFZ9gfwhHP4Bqn3oDMWcL82JY+KZtbSvf95iaN1Y3nok+QeNhWZUw
	 o+nUocXVcEAzeysloO1sCs9jdJU6p47cwaPMM4bHCP99l0ez+1QJF/HAzs/JcB+KzCLKQ
	 Eo/FF1vXyqvpc/bMgx8kXrczzVqAC/8n5IJJxrqR6J3DXBFTnVtYhv22qM+6rWwBzIVzK
	 +j4zNCxVEixMQdrmF6X1FFwfEYOQYWfrtTFKutqmISLM0ZKkMTd51WTLvdG24/hQlZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793717539;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=/z15uDLBdE6P9EagLShWc1HhmDJ69kTe5j2d0GSah+U=;
	b=P6jx00nYoFzKAa1VpXzZ8Sk9GkaJ2ncew6ywjdVuDRixCqM0DZE9mJfvwPK5awR+bV9O
	 f3OF1sbpMeyjih1d9n8cFa/qsaZfrc/1NpK+chOiIbY8VFyby3C7mITnx7GmS03pAHcFw
	 VaHec4mtabYmSFWB67pQMu2wF5TiQI2Xbanqz5wB6oQfd5CExHPMJUmdVuqQM4P0uWfgN
	 N9iyd7Ho2rgSoQP2XLJ4L8nloT28aHNtMIik1oT0XIzb88RzuyFFngfeqwWrlnxDdGmtM
	 AbULtecoWt9jdJO7898DkWVNaKv4siOzHflA187BPBUlJlJLOmqXuRIEuHrEnj3Qqcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZLOS2yT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE76B606B25D;
	Tue,  3 Nov 2026 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IZLOS2yT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA8691F0093A;
	Tue,  3 Nov 2026 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717538;
	bh=/z15uDLBdE6P9EagLShWc1HhmDJ69kTe5j2d0GSah+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZLOS2yTNHD3rtXKQcilP+WB81sz2Uc0UO5Xw7CG9fm/uPBxbCWUMC72X1ujlxOxz
	 JhjsmMWR/njsGOq50IMthL07VdYnOk+nwWp8nzeYVB7Vx9egD10ce5JRNxtwFQ9iUD
	 eCABV7hTAzWTzXjq+gK31ikpMEkyTn6Ts/+vbvMDwZptw+kAUp82kzX9SukRdURDXK
	 Ka8EUSz3THqLnfQjmjF9cgPq8upSJQj/a9OF33N/8BxEJcpZSeSoCN06jjm7TeNBVj
	 JRIN8AccQXHdjcXpLaEoyElj9XrOsq/FMZemN43kpbdof6jt8GBTOZpHUtb9tm/jdW
	 YhVs4u5Co8c1w==
From: Sasha Levin <sashal@kernel.org>
To: Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	stable@vger.kernel.org,
	linux-cifs@vger.kernel.org,
	Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: Re: [PATCH 6.6.y RESEND] smb: client: base punch-hole EOF decision on server_eof
Date: Tue,  3 Nov 2026 09:51:54 -0500
Message-ID: <2026-11-03-1-daily-reply-0006-re-smb-punch-hole-server-eof@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261103092918.2363406-1-joseph.qi@linux.alibaba.com>
References: <20261103092918.2363406-1-joseph.qi@linux.alibaba.com>
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

> smb3_punch_hole() decides whether to move the server EOF marker by
> comparing against netfs_inode(inode)->remote_i_size.  Nothing on this
> base keeps that field up to date

This is a stable-only fix, so I need an ack from a cifs maintainer (Steve
French or Paulo Alcantara) on the list before I can queue it. Sashiko also
flags a possible race with writeback and a stale server_eof in
smb3_punch_hole(); please address that too.

-- 
Thanks,
Sasha
