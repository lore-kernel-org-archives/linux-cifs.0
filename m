Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DEB33B6CB
	for <linux-cifs@vger.kernel.org>; Fri, 20 Feb 2026 10:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771584851; cv=none; b=cMns/XQaOKqyZ7WIpFcf8V8Viw+0avH+1WTsf+RDv1eQ9m5kFu1o7bpvb/bjQ3JkMGSxYkq/oBJPBNTPY2o3MjzW8WqSR2e3wZD49c3HxmxsDOO6FUwWqTzHe8qvxAeNatSbPYoEVCc5T2H1A096kVw3R6aakpj1zUDRMt4dmx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771584851; c=relaxed/simple;
	bh=RQp56ukDZhQQIj04CawJc11JfLzj+Sk7LGsne9lm7Ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eplir7t7Uzn9jZm2AhY8FpQhLGxuF8zChxNeFp0sFRE4HRhOUTH6sDe8LHTTFfRvrw2wOTUrtO5cHvoL4hQcBg7myTqtQCpamEE+bt4UugQJQLjDVw44xLdxZzgba4MyMRMAS5lZ3NBPZrq2r54/HfH7DzETAZDultiGysCeVQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FB9VadXS; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FB9VadXS"
Message-ID: <2eaa0078-5117-4dd2-bcb5-91ce01b1f911@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771584847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RQp56ukDZhQQIj04CawJc11JfLzj+Sk7LGsne9lm7Ac=;
	b=FB9VadXS+be1suqQU+3Q+RCC3Sovetp+LwJAFmkaUVrXBY/ZwuZRsFqotnMw8WsW38vDVP
	iqHd8Uu8cmLjsN8IBQXJReOp3iGZdKR8eQEX1/MKPuJRLk33myXx/NNOGjPYep9b+Y4Pm7
	JcZyxvRD9Il+Qr1iBKVho3A0I+3FR64=
Date: Fri, 20 Feb 2026 18:54:01 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/5] smb: move duplicate definitions into common header
 file, part 2
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, chenxiaosong@kylinos.cn,
 chenxiaosong.chenxiaosong@linux.dev, linux-cifs@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
 <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Got it, thanks for your suggestions.

On 2026/2/20 09:27, Namjae Jeon wrote:
> For patches 0004 and 0005, please move the complete definition to the
> common header instead of a partial split. So we should also use a
> flexible array member for this, and ensure that all related code is
> updated to handle the flexible array correctly.
> Thanks.
