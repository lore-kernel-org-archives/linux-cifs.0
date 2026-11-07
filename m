Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794072763;
	b=SQn08NBJspd+oOs6HhWKljGhEBI0tHA9mLQwLq8d7DseTBqPbcmgjgcBYzN66NvD+VJx
	 STYe9wslA6iY2UMBEMxUmqDVOHNPVmWZso+EWOIY8XkSTaMNcjKqP+552PebOi/8eBsJ+
	 VJGvPjk+R0dwRyyczLCFlG3uABd+U1rX60tovz1objfvJYfLXUgr4qRC/c9ZhktjnVfgM
	 Imi1GACkwApHuH22TiUpve4A7Bl8iyQGtKH9rVBZDGcK4LCkr+PxGXNDSu866IivlCGPe
	 7WqKrGTdW9jEIFV3+WmKJXJrNB1K7wJXGd5ZQqhuDAZyv1PVxw8/FrQ8XPLoVA3xpdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794072763;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=h7g0fZDvTTFAP3aBkpm+qlciQI0R4Bce4Byhiy1gOzQ=;
	b=dHaqp21MmyFutkH7019AktYgvolLraqfQr5jb9kU9iQ06Ic4HbAj8PHfL7jo5FBuFbjv
	 oQhJ/ya6rpeafnLlXl5MgtEK7kGBzEqOtmbsQgDHAplsS/qwkR9ozyhrpqh9P94lz/jqx
	 d4QkdzYH9/1lp6sByE5o1XhtKB2V/PCDiWl2psLYHZIq6BdN4fa0+/IaUvs0ipDBAOhQv
	 ulrB5ovsR6vQ+Ll0iEK+rK68wGJfGdDi4C5hxygkSo4+GEL0XUjdC9V+IlyoPfNyiozqn
	 6/FiEO66VdoPeYKDBdGu5ycXvz7oVX+retyfgHGKLQVud57C/Ik05k0NK7uVvkzkxlg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=H+MJXxmx;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BB64606A338;
	Sat,  7 Nov 2026 17:32:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8BB64606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=H+MJXxmx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=h7g0fZDvTTFAP3aBkpm+qlciQI0R4Bce4Byhiy1gOzQ=; b=H+MJXxmxatLmB3FJQ8bqC/44YZ
	xlu+pVAwaKvd8Rc3MARURSJuC/SxOrQChiLtOa06cDVWgIZtXGEu+kJzUclELpf69GA5nGPy0UEEe
	vQN/X1ZKLOEfAwfzCbdAmBacnMeBPQDQr1BmLmMehtGVeWnB1OrSWqtlNkzc5M7YTjYmgZap/GI1z
	9tUPm8/Gkw2+SmtieUo5h3+kHaYW273io5Ke/ycGirEthv+o6ctkfLUficrJMyp7X9on2bNiJnZCL
	ws9LLWogmzKDVunCqzFXCPuoRXEXyUoNr8MSdWxAfzdNKc/u8vj59snXJqL1P02PH78POFOF8OA7l
	/fxmGvXg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPkHQ-000000017rn-3OXl;
	Sat, 07 Nov 2026 14:32:41 -0300
Message-ID: <0b67e7977e3bc6c2f910d28d78f917d9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] smb: client: skip NULL channel in __cifs_put_smb_ses()
In-Reply-To: <20261103091558.2342761-2-joseph.qi@linux.alibaba.com>
References: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
 <20261103091558.2342761-2-joseph.qi@linux.alibaba.com>
Date: Sat, 07 Nov 2026 14:32:41 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Joseph Qi <joseph.qi@linux.alibaba.com> writes:

> cifs_chan_skip_or_disable() clears a secondary channel's slot in the
> session (ses->chans[chan_index].server = NULL) without lowering
> chan_count when the server stops supporting multichannel.  When the
> session is later released, __cifs_put_smb_ses() walks every slot up to
> chan_count and calls cifs_put_tcp_session() on it, which dereferences
> the server pointer immediately, so a slot left NULL by the skip path
> makes the release crash with a NULL pointer dereference.
>
> Clearing a slot without lowering chan_count is older than
> cifs_chan_skip_or_disable(): cifs_chan_update_iface() could already
> do the same since b54034a73baf9 ("cifs: during reconnect, update
> interface if necessary"), and the release loop has been unguarded
> since then.  12d1e301bdfd1 ("cifs: do not let cifs_chan_update_iface
> deallocate channels") later removed that trigger, but the crash is
> reachable through it on older kernels.
>
> cifs_decrease_secondary_channels() already guards the same put with
> if (server).  Add the same guard to the release loop so a skipped
> channel slot is left alone.
> ...

Applied.
