Received: from mta1.migadu.com (out-92.mta1.migadu.com [95.215.58.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E81A23EA97
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 07:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787038642; cv=none; b=NRqpGfo4lZVnr4g05DjwfA4r4TKkBxj7wuybfXogf3H4QD3Vbkkvh59VfO2zP8i4DtF9TNUuGXgBYuTgWWG5pvcOAlV2mOSwnL2cYvg5kmDnPoB87dXsvN7E6digVmw/nM/E4n/Lq+bQmPeFbGXgTDhkKbSX3i0US9jtEaZC0rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787038642; c=relaxed/simple;
	bh=ymkI5orLZghKoSiMF348EW7IqUGDaHb0J3fVQpwFL20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V0epkY1ftsJQ88k6FALyGyBInqrNZtqk02iHP4fZh2NJLEdcDbABaGFkiS84EkZg3cwaK4htymOi2nnNnvp2JPqSzkd9jJCcGGWWcBwtQPbPzKNr1RLdkA0Y6+r5ERJy8bi8NGo5wWrkot/FXeloOAywz2/dah5P+yIZjcN0QM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Zb7twGS6; arc=none smtp.client-ip=95.215.58.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Zb7twGS6"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ymkI5orLZghKoSiMF348EW7IqUGDaHb0J3fVQpwFL20=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787038638; v=1; x=1787643438;
 b=Zb7twGS6i/eLQXZGjjj9Phjs7QUMnWHLCx18l8nkMYMjOSwK6qA/hzc2226L66MjjRCp3my4
 CYFwB27JsG6qgQFfiDluJJDAiulWufOtKYvjIz3U5jJZS1Nl4zF4F120Nfq+BcTum/gQyYKR89i
 F3q1PsPjnjZlBkVo06xudAzA=
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.3.165] (116.128.244.171)
	by smtp.migadu.com with ESMTPS id 3b7e649179b15c41;
	Tue, 18 Aug 2026 07:37:08 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <78f86195-d860-4ec5-bfd2-68cf2a716b6f@linux.dev>
Date: Tue, 18 Aug 2026 15:36:58 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] smb/client: mark file sparse before emulating insert
 range
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, chenxiaosong@kylinos.cn,
 linux-cifs@vger.kernel.org
References: <20260813132136.366532-1-huiwen.he@linux.dev>
 <20260813132136.366532-3-huiwen.he@linux.dev>
 <CAKYAXd9=LsiPNG3=+-x44fvowpT0oXWtHwL0eYy8zEtLGR4POQ@mail.gmail.com>
Content-Language: en-US
From: hehuiwen <huiwen.he@linux.dev>
In-Reply-To: <CAKYAXd9=LsiPNG3=+-x44fvowpT0oXWtHwL0eYy8zEtLGR4POQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Namjae,

Thanks for the review. I have also found a few other issues in the
FALLOC_FL_INSERT_RANGE path and am working on further improvements to
this series. I will send a v2 as soon as it is ready.

Thanks,
Huiwen

在 2026/8/18 15:12, Namjae Jeon 写道:
> Shouldn't this error be propagated? Unlike ordinary file extension,
> FALLOC_FL_INSERT_RANGE is required to create an unallocated hole. If
> SET_SPARSE fails, SET_ZERO_DATA only writes allocated zeroes, but the
> operation still returns success...

