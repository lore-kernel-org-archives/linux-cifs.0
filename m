Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794162745;
	b=NVt0BchWR7N+DrhJ75ZYT4yaYvC26Zvp2kCf8YCVRUe/AyryWoGPMQ2TblLj+1UpzLK5
	 FCP6A3Q5gGdvPf2VlFAGNIIgpI3gBEuZDYhFrTFskSB9Crl4uxVsZhBi8VH2nbOA5rGuC
	 J+I3nf3GdWGSD92uQqXHHRPN/2qIonjOwm+sFnqAYWWWRHAWfdxcRa0EIzDpa4jrYgzc1
	 MRso39WBbTY2RsokNWSfqQJadRYgW8sVA/T1iiIcUeaaMQgdMaxAKXa/XHAbhqghyqj1H
	 DHRCrHIXR/xKf6bvyYDxsH0T1wTU9935N2Knmr36lq+/O0FSKxJzg+lW7l0XK0K6LcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794162745;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=BK6vetzL9rat9eHKrTopeArt41nfOHdiT0NPE90Ad2Q=;
	b=BL/M6NtZm61XlnoO2M675wjyG4Wr+ojS4RxgOtaStczhqbOO4heKxlE3UE4bDP7YTZnN
	 ONLUPj/LWoRObBKT5MBG9oGvG6zc1n57r8fBdwKyECsVzentRtmHEWJpdNN9i9MSwrjCd
	 1AgXMpMQkcNnLC3zUzElfH7gffmV078gbq0bJvac0c4X2LRbda3/t6UL+252IxasMM0OY
	 qbNEvu8rqRTP0Nm3r6nqmwt7AkbbNAtTP+pfs0XvLpjzSjXgsMvLlbeRlBTz5A07/Yq4i
	 6d13YPrjRPKGH6j5Uvwoky/ppZGFvfAy6J8cI5FHQrEfg+DO7zCl/kWNCV6+k2GHQiA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vwvl+7KA;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACC6606A31C;
	Sun,  8 Nov 2026 18:32:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8ACC6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=vwvl+7KA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=BK6vetzL9rat9eHKrTopeArt41nfOHdiT0NPE90Ad2Q=; b=vwvl+7KAyai9yQg6QVFsJauHf7
	goBkCLn3rwfdXHo1+ur6QoAzJLXVr++dg5sAsM6gq3mEpgPW1oeGqE2RPKMPCzysULzVByaXnY87A
	RsUjWIIdnXfGNzladi3g6Ljuno2Bai6NAMHNr9f6kpNd+m2/daprmjAP9DM69u1Y4kuhr2F++xGkS
	26c4FQxKR1pU3tLaJGNkS+3wc8XPfz9YTG0vooHlYXfJmpsKufBYWR+8n89l3g4VqAwQ13BD/kbs+
	MIL1dvazBxFyTED3bEg5sWyBri6p5vKQJTuFepWAcHH1YGI5wwwipvGAqi/LH2eV/v1tNqLM/A5le
	iZlnkG0A==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xQ7gc-00000001Bkj-05wW;
	Sun, 08 Nov 2026 15:32:15 -0300
Message-ID: <173fb0ba5a3b968783dde74560d10bf9@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: liuyong <pkfxxxing@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 security@kernel.org
Subject: Re: [PATCH 0/2] smb: client: validate ACL lengths and compare
 encoded SIDs
In-Reply-To: <20261106104842.441067-1-pkfxxxing@gmail.com>
References: <20261106104842.441067-1-pkfxxxing@gmail.com>
Date: Sun, 08 Nov 2026 15:32:14 -0300
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

liuyong <pkfxxxing@gmail.com> writes:

> Hello,
>
> This series fixes two memory-safety issues in the CIFS/SMB3 client,
> reproduced on mainline commit f66469d9905b39d2c260a15d7d6db450f4db67c1:
>
> 1. A zero-length security-query response can bypass the caller's minimum
>    and return ZERO_SIZE_PTR, causing an Oops during an ownership change.
> 2. populate_new_aces() compares variable-length SIDs over the maximum
>    structure size, causing a KASAN out-of-bounds read during chmod.
> ...

Applied with MID_SID_LEN and MIN_SEC_DESC_LEN removed as there were left
unused after patch 1/2.
