Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 178A5C2FB
	for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 17:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737395701; cv=none; b=Pg3SJ79znRcqpEFdfm3gq+fMs82jKW6DZNvDFiBqOZ+m3XioaXI4MxTa40OGJQcXU+BqZ0QojFbfktJX+fvjeFQmwaIgu2e5XSp1qcvpi97kCOw0X8qqqd4nEUpX6GCcxsfyl9A9RErxTRhoiqWhXdQsGbJPTiH158zObak8MYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737395701; c=relaxed/simple;
	bh=QBooFMKoR184ZCShjMr38mmwx7WUgrYrWjn4TEv8Hfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IdLrpBTTqQGHSLnvh22rF+mEVqMBtkTL/UVLkDWEMledfkk15isfY0nA09pt8a9iGDOJCailvZJmpNqLGc6xhomDScuLPeB4kXRV1l+gs5shf2KEU8silsRiosb/d2qkb7umS872wdEkiLQjmzZQV4MJQOAF0s11IutIyDkffrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qXGXdAjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qXGXdAjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3C6C4CEDD;
	Mon, 20 Jan 2025 17:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737395700;
	bh=QBooFMKoR184ZCShjMr38mmwx7WUgrYrWjn4TEv8Hfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qXGXdAjyxLqtYB//pNCNnkezwKElempp1w3NvpHCJsn9RDZ9/Srbe+k86Ca+3dwgn
	 JGS/zU3mmkFhfF9AMipnWh2FhaEkDe1KQuO51Y12QoSNmgiK9ovT1XPytk4l4TpJoP
	 psyWTqmNCkNJQG+kdtXUIsKuMC9M5viKTYKSNqBtI7B/CVane7FzVAdWrnzTxHDIwK
	 /PP/QlYpwkKUps3SVhAOZROTgxkiL+gkk6m7tZM2DFpgF8gTeb4LtOAS4zUUxn88Yg
	 SrrTiWxeXXIessCfqvTr/Xjz0rlTfrlbgQs+tsKgUuWM+4vqi9RHY9tW26UBXBFpa3
	 tO0GMHbZ6ylFg==
Received: by pali.im (Postfix)
	id E9C66A28; Mon, 20 Jan 2025 18:54:49 +0100 (CET)
Date: Mon, 20 Jan 2025 18:54:49 +0100
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
Subject: Re: [PATCH] cifs: Fix printing Status code into dmesg
Message-ID: <20250120175449.5i2a3bdd7xk2xjm3@pali>
References: <CAH2r5msUp2xqY062MRRXkNApwekZ_CJYL3q_J0boGFPzw4W1LQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAH2r5msUp2xqY062MRRXkNApwekZ_CJYL3q_J0boGFPzw4W1LQ@mail.gmail.com>
User-Agent: NeoMutt/20180716

Just to note that I have sent this patch in series with "cifs: Add
missing NT_STATUS_* codes from nterr.h to nterr.c" patch which is adding
also NT_STATUS_STOPPED_ON_SYMLINK (mentioned in commit message):

https://lore.kernel.org/linux-cifs/20241227173709.22892-1-pali@kernel.org/t/#u

On Sunday 19 January 2025 19:48:39 Steve French wrote:
> Any thoughts on the attached patch (which is tentatively in
> cifs-2.6.git for-next)?
> 
> NT Status code is 32-bit number, so for comparing two NT Status codes is
> needed to check all 32 bits, and not just low 24 bits.
> 
> Before this change kernel printed message:
> "Status code returned 0x8000002d NT_STATUS_NOT_COMMITTED"
> 
> It was incorrect as because NT_STATUS_NOT_COMMITTED is defined as
> 0xC000002d and 0x8000002d has defined name NT_STATUS_STOPPED_ON_SYMLINK.
> 
> With this change kernel prints message:
> "Status code returned 0x8000002d NT_STATUS_STOPPED_ON_SYMLINK"
> 
> Signed-off-by: Pali Rohár <pali@kernel.org>
> 
> 
> -- 
> Thanks,
> 
> Steve
