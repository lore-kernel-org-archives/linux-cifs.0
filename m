Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793074797;
	b=TflpZSJXqb3Uqji+Ds4+tIdICWdVRxFWqt5kpoMkPUlCsAty40IfuzbylnhBKU1asaKC
	 Yv3KBw7dbT2nnAJd3D2+oSYXG/FGjI2uRyDihNbbMM3OkZeetvr+hmDDcctRqrF06W5a+
	 WCv0hACPXHrZF2a3ebJVWaOzmpLCwuNUngzKir8PD9ROo739x5bGalseGkgwfRyguvb2l
	 MAuG7ty2Bg85Sxu/PYW9SSoA2P81wpFu8DbN1BjBnJY/3YJxnnII0kQ1U3xSIiGP2WmAx
	 Gew8Ud2t6r3GXk8K9ipmpC3eoHa+gT9t65KsQyBRvPSvyfdw8YqODjFoqjHPeTLM8PQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793074797;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=2IKPabMjevdIrFHwPzaYFWyTHibi0SlAr68tYluFRSM=;
	b=E0sa2iI8I840zvKgOEKkg2DJPB9891944IdNHx8SxK5+CVUDod/Ze56sJsjd7rF37AhN
	 wLxzCRRFuHPnrwU5OCWEZiKt/zo+3zJ5dqER2VMIDz+sfrsbg659JFNDIEs0LLIwdd9AG
	 TZOjod85ceEuxGcmQP8GuY9kNm6t0Cor1+HMnQGtStmQO34RoWTp+1Lne42QiLTIzQZHD
	 lBkVgxIOsiHc1V27Y2LSpTI8ClAQ2D64VMmcoGfK1GI8sCCIcoitErppwEYCPRNX+Jsoy
	 nqkUfh/PcAV4dBqTn3Cy8teENA/8ndzyPcx5bV7W95TDvsiol1ihsHdmBeysA5knq2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lrbO2PNs;
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E61C60A2618
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 04:19:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E61C60A2618
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=lrbO2PNs
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-14394530ec6so4458759c88.1
        for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 21:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793074796; x=1793679596; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2IKPabMjevdIrFHwPzaYFWyTHibi0SlAr68tYluFRSM=;
        b=lrbO2PNstJSFZ68SLpP4XGxtXDa9+Juz0L9If8HZ2DXeH/oibvaaZmfC3HzSO0ne/f
         soLDJQcQG1sFdovslAO6/STxQF9gk+gLzz2HpZuCLQP4sDijxOAZnu/iVTiQ6WKjNjxU
         PE6YjL+TKEDoQnsnJCryJ18UV2khJyAlEd3I4OeawzAWfP3jG0UmpF/4FUjx5DGimZiW
         jxvNS0hi8lGgC3rH2gjowO04Wu4EWOFrUx8qDhbjLvvO0pBvyYPrLFttg5Gpg+rmR50h
         Kqo0itbd9EN9yIHW7TsVNwlfOLYwEcE+9wDWmR+UPYq/q4J+xA/pYDodWqSV1Cw13yfy
         1tmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074796; x=1793679596;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2IKPabMjevdIrFHwPzaYFWyTHibi0SlAr68tYluFRSM=;
        b=Ouer3c60OtbUzdV+4ycr9RNC4LJCPow7ZAIPYgLFjZ1OML9wFCkxbl1d5yT+19y713
         XJaSzLrFVpnZ7WJZ+mEcOSQxEVaS/HUTNQ6TtOgiaBEitsmRqPGYFNFa1EiJ+E47F8aM
         HidDXatY2io5m8Mq8u9NvrnpR1xzqOTnFYrlgzYLDWCHGH8orzwPEC8EpnCepS+O8q3N
         1cQx6c2WHSwGS6TpDDiYfIS6wfPC3f8fgM+fVRbIh4vXJOwTyzVEClD1YzvjCAkwvEwD
         PV0aOREMmrr5fs5mDLUId0YHPREvlsd4hDZBn/SDw6KgSLsYDrDulZYXA9u7uCkNRpzo
         zQrA==
X-Forwarded-Encrypted: i=1; AKwUvBwFYLKZW0tTF630d5nHYOln7WSwQc+Zu90E2vipd6crJqZ8FeuHWP4Fahbh8Wtx7DRHsvu36Tjjycqp@vger.kernel.org
X-Gm-Message-State: AFq9FYKH9h6DThBC9eCmVdnqMRwE+fNdxZ3m/iDg1qZcXVKBW44e5xzX
	0nbi6GYHB5a/Yl5e3l1fFUDoAs9R7c2gA4hnkEwbq9pu3DZMMQJ/iX7nF/aPkcM1YDDPwg==
X-Gm-Gg: AYBFou03zZ8cNgTOo7P1adLOJ5bueJSrg1m9rtWcltJVsC9vEMZqh2g6/21yQ9my/dO
	2UTXpqypKBoVXoUgFr6hpvEnJJzT3owbAkhfb8t46k8AU2t0qlMIDQg6Epu2gE+lFeYxRj/6Df4
	CRqX7dXzsq8eA7mdmb6qyQNf/m2jSsmLlXkDnrbe5ZfM8/EuCSGo6BjbKdMmQTCAWd/1ZU2wVrH
	q8RcPbOLvxhpHOevpdGhUOnbxjkACDHaPNLkAJQakUfZVbsSqVDFuqsw2J0lDd697183G0QlDs/
	/4wkb0ZoUyNiPhNUes3ODfZbE4ujnI1nLtR7aS0Eqd9CHwpTIij6Y+ER9VuKl4Adj/PTKZm5++F
	bb9l4UIgZwfKPlS857ppU++UrY1RIgcDa8Yu0IJBZ9MsJJ6phTcTfpdYbs7c08ZgwxisGEczTZb
	LFj4U++6qc9ZcNZukcwGZQEpN25D4M2wkfPslYTL2LLuGtVLeUZ33oupKAYe8alWPjHapWz49VD
	IS0iIurJc8xIpDA2ki+tlmvQWyDQmbxhS/rsvArIKpBgr9I
X-Received: by 2002:a05:7022:7f12:b0:179:a1d0:be39 with SMTP id a92af1059eb24-19935fcba5amr12404995c88.29.1793074795876;
        Mon, 26 Oct 2026 21:19:55 -0700 (PDT)
Received: from [198.18.0.1] ([38.182.104.55])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a01fa4c58sm32351783eec.21.2026.10.26.21.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Oct 2026 21:19:55 -0700 (PDT)
Message-ID: <a2d84436-1b28-4fdc-8c27-d8022356013e@gmail.com>
Date: Tue, 27 Oct 2026 12:19:47 +0800
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
Subject: Re: [PATCH v3 2/2] ksmbd: fix named-pipe reply loss with small output
 buffers
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
 linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <SEYPR02MB69642EAEE79F3CF02F782597E6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <SEYPR02MB69641633E70AC3FBF14BB14FE6612@SEYPR02MB6964.apcprd02.prod.outlook.com>
 <CAKYAXd9vAUH6J_Mbx3ZTzGT9U+unoOsdDL4j_Q8UsDypW3a82g@mail.gmail.com>
 <af546d6b-d1c0-45df-8f81-ad839e7e4d6d@gmail.com>
 <CAKYAXd-OpiRi2uQzK81rJpHis0VkS-gTaZpQWJ4TZH_RJFzL6g@mail.gmail.com>
Content-Language: en-US
From: Wang Zhaolong <wangzhaolong633@gmail.com>
In-Reply-To: <CAKYAXd-OpiRi2uQzK81rJpHis0VkS-gTaZpQWJ4TZH_RJFzL6g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit


>>
>> Thanks for catching this.
>>
>> I reproduced the sequence you described and confirmed the problem.
>>
>> For the READ path, your suggested STATUS_BUFFER_OVERFLOW check looks
>> appropriate when a positive-length read leaves unread bytes from
>> the same reply.
>>
>> For TRANSCEIVE, I think the correct fix needs some discussion.
>> One possibility is to return STATUS_PIPE_BUSY when cached reply
>> data remains, without issuing another IPC request or consuming the
>> cached data. The client would need to drain that reply through READ
>> before submitting another transaction. MS-FSCC §2.3.48[1] lists
>> PIPE_BUSY for a pipe containing unread data.
>>
>> However, I would like to confirm that this is the intended behavior
>> for this SMB2 path before preparing v4. Simply omitting the WRITE
>> and returning cached data would still silently discard the input.
>>
>> Would rejecting the transaction with STATUS_PIPE_BUSY be appropriate
>> here, or would you prefer a different approach?
> I think the former is correct.
> 
> Thanks.

Okay, I will use the solution and send V4 after thorough testing.

Best regards,
Wang Zhaolong
