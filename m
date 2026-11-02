Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793634647;
	b=HOmAGkeNjLnf1Gcx3AwtKLFSAJpSSC9h0e5yZJmBbyv63h4gO7NU8nZFRXH8Nt9L5sCa
	 q/Lcodhns9T1YQp91/f2Fim15Mq2aqfewT4fmk2te/FTrLIRzcKiyNeJ95pki0IqkEUSJ
	 pR0Gi82idHqOyIOOOdvQvvmUDltM5KG525CWupAay6J/6H1NG2s6LZOft++OED9nKcoYX
	 pvlBTFvyOZLmOW29g5YfwdTpUns8PcMXIe8ZVXq7erpzmeoVYtwfV57AUdypZpJeJV/Z4
	 dluuc86Wu2ZoqUakwRIF6oak0WGXKU3Dw5ozqDrbc2drGaA7BlgZSNEtcFLRZ992raQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793634647;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=KCRjIWqQ1NmnTBG0QfMnSgZnbWrsKVXtmjLZBW4Nj1o=;
	b=D1rKLLMoTVmVAJojx5ecisMQq6p4VZBRfRhLl2FrICyu+bYWddGvigVXhqnlRJFCiTqc
	 fpRbjO2CVVtqdIyGpB4GkaRKVOj6d1Vggr3RgfkrOsGomZ4jP7k6dB07kNfDdzXhFhlOi
	 1gIIndbjF8hNOBgEL747aSWcYq87Y3mc/FCNNPf1PrBOsQDB8MX26U/cgBo+RRSAvyk7w
	 wJkcgTKdNzfQDJ90HggALHsWmumBZpEjO8cQYBfS5tiukLPl1B4ab9QdFcI3VYT2GyXjF
	 8tciY35Vpm/lkFgHuFTKXOYKcBpg+pwzlXRH7wbQpEYSrl6eYl6S00dnRn9hUYoF6Aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YqLyEHWz;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5DC6079917;
	Mon,  2 Nov 2026 15:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0B5DC6079917
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=YqLyEHWz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KCRjIWqQ1NmnTBG0QfMnSgZnbWrsKVXtmjLZBW4Nj1o=; b=YqLyEHWzamtDEyNzW0cemnNw4l
	wGMiYpWiN6avzBFUlRS1YZsu97esp5gVoQ+Z3X4aC0y3HcBZ41heCgZYLHzi2/chikHHkAAnDi23+
	9wdySaD4Bxm1I3XxgZHUGk1S5kRQvamFU7+tiUQ9lBcajiA2mtvTRvDo9hMwkI0alAz5Nb5B2j6qY
	/5FPNjqy7b/isehsshVA7meXShoxXIh6cWRFydLoBaYDykQa2rdb/Rhwhsy27bmqxSqIC96gXrAzg
	3VJ2vKnDifAwjrT/6MWrOBF5WFWSqLQ5fICdUGCyfYf8sja5VJw05Ox7NhLZU3bxRVNUJeZf9RvEi
	UxIjiSSA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xNuIz-00000000aym-01Mr;
	Mon, 02 Nov 2026 12:50:42 -0300
Message-ID: <163d44f3913471e4a52ac06c2d93b47a@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org, netfs@lists.linux.dev, David Howells
 <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Ronnie Sahlberg
 <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom
 Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, Christian
 Brauner <brauner@kernel.org>
Subject: Re: [PATCH 00/15] smb: client: fix data loss in writeback
In-Reply-To: <20261102151525.925058-1-pc@manguebit.org>
References: <20261102151525.925058-1-pc@manguebit.org>
Date: Mon, 02 Nov 2026 12:50:41 -0300
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

Please ignore this; I'll send v2 with Sashiko's comments[1] addressed.

[1] https://sashiko.dev/#/patchset/20261102151525.925058-1-pc%40manguebit.org
