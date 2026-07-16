Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196292DC78C
	for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2026 02:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784169287; cv=none; b=kz4O/4ZKZd7L2N8wxXiv7U+DrH+ERdYWKwKblNDyBmbWN9OzOt6kH7h6U+TaZrCFGiPttvSptCT9gl9eY//f6qEpLuSfORjnx43SjhWdBNcCHVL9idthzwC4Fc9fhjXQDOQJ1fSlh9G5uxy2daEXI06Z4LLLfrn//WlNqRrCEJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784169287; c=relaxed/simple;
	bh=RHC2vbBC9Olrd9ezRsv5vuKvrjb0sMgnKC5hLBp5cMc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=pde9dn4LOSp0P1q7HLtLbPj5hL7rqe++PDOYfMKrf8yIvMtS74nL1X2VB1o4cWbziWmyPdcnS+gWJQtuvWoKbDC2ia5cXXVVI3/44fx1qRZIg7SN6X3fXmAPxC0l7jihJGW5DAMcNDoyr8t+6NIo1vWRwomSNZcG4XNlxrDekok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=ayrYNjCq; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="ayrYNjCq"
Message-ID: <7ed2f03d-6e8f-4f61-9024-deeff4a757f7@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784169280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fS6pxZDdex16/D6E1R1Entj06T2gsBS9Nq++DMrUOMY=;
	b=ayrYNjCq/ahV2wQtgyaaT6NQfThnym1zAiXQiYZIyI+Ft70+NX3rbQa8bxmKWOXYGav5fN
	sykoqRwqGJ0X3VJbYUOBVYlwSAYkrC6PLWgBFKB3Qh+Q058M6/0RrbCVAvzqtq+nJzhuOG
	kBewHeF59cBQsImhm8ohehBknpbD0zUOlsX4sTzMfMGiqpeHaVwu1Bsd6BpHQXocCmmtmb
	s5M8TukmL15ONQIOwRlLRRkbFlOsrnm6CPlnjqswg7Fv8SpAT7QjT2Ujho5KJelvpL4kEP
	wW0iFykYPDhO4M3H9+7Ycr26JlJnMnvFpxXDeobF3jffVo0TXY7X8d5MfYc8dA==
Date: Thu, 16 Jul 2026 10:33:39 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Subject: Re: [PATCH v2 3/3] smb/server: stop new async work when closing
 connection
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org,
 gael.blivet@gmail.com, andriy.shevchenko@linux.intel.com,
 linux-cifs@vger.kernel.org, ChenXiaoSong <chenxiaosong@kylinos.cn>
References: <20260716001156.671587-1-chenxiaosong@chenxiaosong.com>
 <20260716001156.671587-4-chenxiaosong@chenxiaosong.com>
 <CAKYAXd-UsvUOK6A_8k8pdtYXANKeve+yDpVwXyRFa0wpyQ=nRw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAKYAXd-UsvUOK6A_8k8pdtYXANKeve+yDpVwXyRFa0wpyQ=nRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Gaël will update his patch "ksmbd: defer CHANGE_NOTIFY completion 
instead of STATUS_NOT_IMPLEMENTED". Maybe the next version he won't use 
synthetic in_work.

On 7/16/26 10:25, Namjae Jeon wrote:
> setup_async_work() protects only work items registered through that
> helper. However, smb2_notify() later creates a synthetic in_work and
> adds it directly to conn->async_requests. Therefore, the
> connection-close path can finish scanning and cancelling the existing
> async requests before in_work is added. in_work is then registered
> after the connection enters the releasing state and is not cancelled.
> So, we need to protect this direct registration with the same
> connection-state check, or use a common helper for all async request
> registrations.
> Thanks!

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

