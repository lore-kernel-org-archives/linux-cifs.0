Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794233477;
	b=HBKUDjO8HL818iZQCNLkn8Wjt2YrTQvvV2xNqAQvefUnTW8dsr5fijxePTlU9c8TX8aM
	 OZSCcQfnoUQantAGm6rnVJ32CmF8bImiPJ0vkkZ/Y6u5uKGYtCkRxREZjxrSSyI6w8Ut0
	 0fNsbaORf2fx98YDygb014j292qXvbGhT8vjXXyDVAWQ1W5jLc73lTJtO3mUmQLqHQjYt
	 ldpNA+3wE1G8JJQG4g9Fz1RTfagnGU5TVG6ChpJRPzEFdBh7f+tBo5jqgFA1BrF4AFxLs
	 H9hGL1jPXYaAc+o0QV3Xiic/7AzogMCseo1bGOIVMfXgzfkNIbWYTlNV5zOKwnBgFVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794233477;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=hb3VA2ky0l8x+jYMU/yaZ+IaniFv6bm/V5/0Nahxh5w=;
	b=MsKiMi4e91Lw++9X2Sun+Zck2RrbZX7xsvNQRPTEpL44KoKtT+ey8V//HVx6uYuIHNLP
	 Zvf/DpZy5sslOr5GATxZLU4rSLU0nq7ix9m7DsvmevUz/705EG7TYhZmuFMB1gTI7z6Dg
	 uvuCZtpO3bGgywihu+e/hpt8rUH3MOkRbsi8KIbvpXtjBTjZUXoVnmbFwBcAD8BlDbTQ4
	 Dwzh4sP8//mVvjQsqqe8jvKV0nL0eSQ81a1jwAsFZDBlQ3sTWt2+Jb2UePiRccaxge6ds
	 bXZHFVuJNFFaNciokFqC+d1HRWqDa1Ct9V8t9ps3ghB9/ft8ac+m/ajyXgk553q7eoQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="zil/aWz2";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F0C606A31C;
	Mon,  9 Nov 2026 14:11:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5F0C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=zil/aWz2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hb3VA2ky0l8x+jYMU/yaZ+IaniFv6bm/V5/0Nahxh5w=; b=zil/aWz2b00etxa4TV4SpNFtYJ
	T8tJ77loIPK7ZHMb07dqAc9TldzoJwrr6SDipzFO8AIZnxgTG3KvtokTRvw8fCJofTT+CnROS/mF8
	lzoLCQmjVcPj80BwxqpSGAxGvwFCBVPUY08gV022P64CtEQyY3n09lXRqgmqlb9d8aBhu7M6tzeye
	u0SE1/PWcrKet6qPGl2HNBnIeCkUbVa1r+Obsd71SMHTH0oBU3fwXhw+8PCuHA1uLlwQ1omPqp3eE
	MBdZt8e1fkTkP57NhvAZYA/XNkCyy6/5EDQcct6OxH7bQDxZTHwlpPnpP78tbwe92IUr5K9YIkhzs
	uIHLxUkA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xQQ5X-00000001FsD-0lt1;
	Mon, 09 Nov 2026 11:11:12 -0300
Message-ID: <c144ecdd74cb7f659c36ae55c3cd3503@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] smb: client: hold server ref while queueing
 reconnect work
In-Reply-To: <54a1224e-abc6-4042-8979-2c21441fb4ff@linux.alibaba.com>
References: <20261103091558.2342761-1-joseph.qi@linux.alibaba.com>
 <7e2543c16b6b75edb8c55b138175dcd8@manguebit.org>
 <54a1224e-abc6-4042-8979-2c21441fb4ff@linux.alibaba.com>
Date: Mon, 09 Nov 2026 11:11:11 -0300
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

> So what's your opinion?

LGTM.  Thanks for looking into it.

I've applied it.
