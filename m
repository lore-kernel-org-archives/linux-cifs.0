Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792949397;
	b=tedNb8Ys+V1M/k21N44ygiWP8u18pCjwkrLFOmsbvDgeNI4gy2GEUAmu19st8EmBgscc
	 8Y9gE/iuG2zwSMsBVgLpE95ho5ErqVlMtePNMeu+8tjUEGJYg4AXBaUOhxRK2w1KHrMn9
	 /70AklnQkm/uahaCfPk3wt8Ve0T6VdDrlFSfSdxpI2y9150QsJIYWIMXtGrMuX0903auF
	 Ulsse/dTh+UjUGJl8HzzSIaUQELUM7jMRQrqtMaAgb/+2XtXXzhQs9srrzxT5nBG27l+T
	 SRX26OAOmDm+STZrcKsKdBxGWIw9he0w4fLh+rjf1iX0H/9Ak/Zr3BNNOlFXA1eXTkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792949397;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:Date:MIME-Version:Content-Type;
	bh=la2/IIwHo5riC6klYWe715LEcKCpUi+ndCFEC0sGyHQ=;
	b=MhiaabC8KKcCu3yCR3FUM/XWEKQv5bPUF0BeRSrWY1r2U+8N3MIiZ3gUk3eC+q+n2Eg9
	 EmljI3lKyBRcuvtmWqwIe+cuMyLLz4MZeuT/gvfXRV9IaRDxy8IOYJ3P1iKB1XA/4n7qJ
	 lyEF5bxpc25AUGdhDB5FclmmAYqiklLUDj5Nb+0GyKz0xHEXvl8dnoHT0QX9dAG7nO7Md
	 cJABr1sybYXOH5I0kAFXFl6EHbr7kMFKL+dsCTDophTnnFsZ7RY7pAd+sjVoRP9lTwVeM
	 2N+o23qmk4ajcC7f4Bo0DK7N8m/AMUCjbnfS4Gw7O9k6eE3cE3YKzI9qzVvpbgGEqEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="h/rvqepR";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14424606A31A;
	Sun, 25 Oct 2026 17:29:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14424606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=h/rvqepR
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=la2/IIwHo5riC6klYWe715LEcKCpUi+ndCFEC0sGyHQ=; b=h/rvqepRqmErIV7vWfhqQuI5V3
	HN3oI69i3amobcdd1zAMiXl3u1MaFBcgDYk/dFNWS6mCi2DvTRvDcEtN7sBI8oOvuVOGOv+6if2gb
	OY1/ZkjJeXVOryMcojOD77cSTnXUICS+a2IoS0o8ireUSiAvYWq235tLq3wb9/zA2pIgBqVA4WeZc
	kdfLgWTSN/8fPayvilsCYFy7eMtOPDkZe7tqC+kc+dbK/8D8+yORK/xMGmq8CMZpPvoF5pI23Jrxy
	IcxxpfoKhGVXiqGPJd8ZnD4XXnSC7IkwLi/IJhWJ8IJ1Mt2qA80/UJ6da5jH8wBx8v5DMbPr9RtUF
	MRZ/7OUQ==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xL22U-00000000CpA-0lk2;
	Sun, 25 Oct 2026 14:29:46 -0300
Message-ID: <e071a5df45f7ccf80a9d899749e09e11@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Cc: bharathsm@microsoft.com, linkinjeon@kernel.org,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 ronniesahlberg@gmail.com, samba-technical@lists.samba.org,
 sprasad@microsoft.com,
 syzbot+c2ec61adfbcb24e5ec20@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, tom@talpey.com, Michail Andreas
 Michalopoulos <mike.michalo@gmail.com>
Subject: Re: [syzbot] [cifs?] KASAN: slab-use-after-free Read in
 cifs_crypto_secmech_release
In-Reply-To: <20261024184605.44432-1-mike.michalo@gmail.com>
References: <8bb0534e33a5f5d152d2b1768d1fd7c6@manguebit.org>
 <20261024184605.44432-1-mike.michalo@gmail.com>
Date: Sun, 25 Oct 2026 14:29:45 -0300
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

Hi Michail,

Thanks for testing it.

I ended up merging Eduard's fix instead of mine.

Could you please try your reproducer against

        git://git.manguebit.org/linux.git cifs-next

Thanks.
