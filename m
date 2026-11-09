Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794251547;
	b=H3Vf0NL6ZsX8rKbzjadRkJ0hLFK885oeUaH+UxRtgPJieAQH1bmi+kZfA5Gj3kuepDjK
	 XPHADQJy9h9vSfIv/3fb9VisMli0l/72OTqgoj4bA4eRz4BMzF2g2NT1EZqijeoeimPHN
	 ynfTduDzQR6wlIYF3Tznp2F2aHXjMzIcWnsqEA5SowHED89v3ywQ3+wPb7uyamqF09qB7
	 LRydwqt1ZYUjvJwhIjDS95ylpKXO2XEHSD2ojrWnuW44TaVCXSQ7+edxu3ZgSboRPaYwA
	 A1RWCLBONog3vwzOQD+AYuVFWSGqVZrRyMoC6hiaPrWfB7TxfSB8b7FDS8DQwH/ct+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794251547;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=iDbXTgguYxJP6pzU6QfRyBYR+dcD++wKGFFljJ+0QiQ=;
	b=Po+1PX9+wpVwdiqDt1SDxVXh0YAhYPDTR/FYDcMwb4XLFYSG9EjwyhLZOHFdV0DaBTxH
	 vGZB00MkEC2X0Tr70BP15Bg351ZsQfjO3HY1Fw17hpnj6mTNKDiR6DKpWI6zCbuP3NSrP
	 M4PIUO+aU6+4dPyTxM5xTCLAznG4uN8oYnu0KndgO4FgaokrENgyvTV08vNqGakmg7ma2
	 ypA3xkffzUtUjTUUPIW/pEb4LsdLlUaWFC1YgFmQznuRS46QKWwNsWInc+SAoEiH5Oogv
	 gnDYCGCym6nO5h4ewlS0R3WnLjwdiXb8YR0LM6J9uXg7ROz9/f4L/Cqmex79d2/FUfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=hVhgVGxD;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76110606A31C;
	Mon,  9 Nov 2026 19:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76110606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=hVhgVGxD
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:From:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=iDbXTgguYxJP6pzU6QfRyBYR+dcD++wKGFFljJ+0QiQ=; b=hVhgVGxDFLF41YpCLUNWrS+PTg
	1tJrqObdJa5xerjSzXGPt4RxI/Tw2kkhLZstFXuJjqi7V4JgySG6m9yHuQiWSW1yhXMS5/4Mu1N+j
	c9SCcZqCErA63BtwwmhYz5p7QAnrxXl863eGvBk/wlve7GbDyBNcreSp8C7Uxa6yof43gqeHaUeqw
	vJGBncDk+nVMaI/U4lNFrX8yqwrz8PORmTclLTA3kmMQAY6aLCeUrGEw0ROHrEi3j7ooKbFU9lSEb
	6E4W1n5axGd0UsmjrvIUQl4syh2FXj/wOgBUjCvod+wX3Wg9+2jV2hBUifctAfAvOYsmmgolc6S/8
	Xm9iD4IA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xQUmt-00000001HIj-0qH6;
	Mon, 09 Nov 2026 16:12:16 -0300
Message-ID: <b0fecf98c80a78b4b40488e44dd73ebe@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: =?utf-8?Q?Iv=C3=A1n?= Ezequiel Rodriguez <ivanrwcm25@gmail.com>, David
 Howells
 <dhowells@redhat.com>, netfs@lists.linux.dev
Cc: Shyam Prasad N <sprasad@microsoft.com>, Steve French
 <stfrench@microsoft.com>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH netfs v2 1/2] netfs: preserve prepare_write errno on
 reissue
In-Reply-To: <20261102150656.207612-2-ivanrwcm25@gmail.com>
References: <20261028181229.1408342-1-ivanrwcm25@gmail.com>
 <20261102150656.207612-1-ivanrwcm25@gmail.com>
 <20261102150656.207612-2-ivanrwcm25@gmail.com>
Date: Mon, 09 Nov 2026 16:12:15 -0300
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Iv=C3=A1n Ezequiel Rodriguez <ivanrwcm25@gmail.com> writes:

> prepare_write() may call netfs_prepare_write_failed() (FAILED + errno)
> before write_retry calls netfs_reissue_write().  Clearing subreq->error
> to 0 for a clean I/O reissue (82e8885bd763) then makes
> netfs_do_issue_write() terminate with 0.  The collector copies
> front->error into stream->error and mapping_set_error(), which ignores
> 0, so writeback failure is silent.
>
> Skip clearing error when NETFS_SREQ_FAILED is already set;
> do_issue_write() already terminates FAILED subrequests.
>
> Fixes: 82e8885bd763 ("netfs: when subreq is marked for retry, do not chec=
k if it faced an error")
> Cc: Shyam Prasad N <sprasad@microsoft.com>
> Cc: Steve French <stfrench@microsoft.com>
> Signed-off-by: Iv=C3=A1n Ezequiel Rodriguez <ivanrwcm25@gmail.com>

Applied with R-b from Dave.
