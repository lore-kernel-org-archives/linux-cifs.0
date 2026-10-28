Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793189280;
	b=yHed/TL2dJu6KevCMAiMM/a1WoXfm305F7fPt7oWTfrLoMSQFY7gubTPy5iga1mLAtc3
	 gOssoXRy8PMyDjHIf7MhcxzmHyvmabiHjwoFAlgGW3QPwfnYcq6WlDhmggZ7imTbtAbQR
	 evgUYOEYAgY2lonEah3qG+Mk7s6d6dqMAg5oALzJZE1MZo+o8cDKlBLGI7eQjKMFgamPs
	 fxElHu0VCFPWRwE5BnSf4f0WVl+IJGJzxmUQf+MxJ3dOTCwr/fGDSA0mh3vjyUKeTO48P
	 vNplBWOHMaRzPCYAdZXFxHURFL0Q/Jleh1fhG8eTJri6zyrbaPyw+u/wQL/qVbaZ7ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793189280;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=dBdYya1daOMCSnh2pTh6bN/xWaoccKgg98csDreqiOs=;
	b=qYpN36CcYvwMEtO2GyV5R3oQ1zV/fivTC2LIsBz0XMaKRsbrKLa/Oz5FOnUzDYweFb3W
	 x5GOyIVAZLk5El9zSUrcGQJmd+OMaFFF1tkIt0m6J4CGN0+KrVRIRCubx50s2ezW8dNMo
	 6qF606aFJZQmhYxyUQgicbosQoYB+eXnwszdioXdWv54tJ8cD/vcaSUsXz0e1Gytbv+7U
	 yVNa0bzwFgRwDmjnCjWgTy/3Lt1GzPEaYQJMlGeaGN1hDIsbccGSS30yfixLe9n/CB2JL
	 9H3taZrMBPg2czf74UdwIqT0a3Exc1GgY55ZOYRo5u7WtTqFLYczoc4AqSfNMshSgkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chenxiaosong.com;
	spf=pass smtp.mailfrom=chenxiaosong.com;
	dkim=pass header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=MetWiHXr;
	arc=none smtp.remote-ip=91.218.175.47
Received: from mta0.migadu.com (out-47.mta0.migadu.com [91.218.175.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CA8606A31A
	for <linux-cifs@vger.kernel.org>; Wed, 28 Oct 2026 12:07:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 27CA8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.a=rsa-sha256 header.s=key1 header.b=MetWiHXr
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VoV7voGegWJd9VxzIwWGHAYUKdGI1CtLDkX7rPTqAqU=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793189275; v=1; x=1793794075;
 b=MetWiHXrB+aCMwJdGMHiqzTFx3KhLKQ7oyjFbqEi407FDNRPUEbhE3QcerhC6Blb9wRBHAqN
 +135WLpWMElOAj7fM7fpR3MmaQ2ATDOx6U3vWl7kA4KFt21SdCQC5CxT7cQgIJEq9uaPaC4y/ih
 xVZQONtgayEMAMHKYEmKL+PJlz8WdNi4sNXCIJTYx/JBUF10LZ01/dAGp+C+2qT7TaZaF5NHtym
 pKoRalHj7cbg5yN1I0q1d8Xhtgif4NfbPcZEUMKEv7nCWoLIgfuildzoThOLa/wAucHT3RT68OJ
 qvZl9Cm5xz/qsCaubC1xHvaevxsHECUC1o3a0VaBzAi0g==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id d81dfed7e1c9c140;
	Wed, 28 Oct 2026 12:07:55 +0000
X-Mizu-Trace-ID: d81dfed7e1c9c140
X-Migadu-Flow: FLOW_OUT
Message-ID: <44fc7448-e1bd-4e48-a688-42aa8d30b3c4@chenxiaosong.com>
Date: Wed, 28 Oct 2026 20:07:45 +0800
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/13] smb/server: change notify support
To: Namjae Jeon <linkinjeon@kernel.org>,
 ChenXiaoSong <chenxiaosong@kylinos.cn>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org
References: <20261025083450.212604-1-chenxiaosong@chenxiaosong.com>
 <CAKYAXd9pbMrBHmSH7SSj3GkGqtPJkFTek0+MFcpyELReTE_qUA@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9pbMrBHmSH7SSj3GkGqtPJkFTek0+MFcpyELReTE_qUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I am already modifying it.

On 10/28/26 20:04, Namjae Jeon wrote:
> Can you check the review comments from sashiko ?
> 
> https://sashiko.dev/#/patchset/20261025083450.212604-1- 
> chenxiaosong%40chenxiaosong.com

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

