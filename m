Received: from mta0.migadu.com (out-148.mta0.migadu.com [91.218.175.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3643730F94B
	for <linux-cifs@vger.kernel.org>; Mon, 28 Sep 2026 01:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790558863; cv=none; b=aMhULyp6sfTs8A80bOcZ/D4UXJ56+nrdLaDGcnvjJGuMBojiS9QETeQl3dtl+8oj8ou3zxQj85bL/xynvrcPkqznQboqaRsflPX1zyZS4rxwKBZB4ojNi+ggWgjoraPGy/lsitwH5xdzJofWTGacsTrzJvanrMxRoTCK8xdqw6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790558863; c=relaxed/simple;
	bh=qBuw3P10cyk7hqxwawfF3KVpPN1JMrZ5HAcv/JozHb0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tRvy4dRPbP8wwslLMlYv5B3droov6dFFDkGG8rFmlEMzU9pggtcU2DXjXzBOz1dVlvzGVdfSN0O+jNexifZt6z6A2dOSX/dXt+QE6Cj3rOLgc7Bd9mW7gcbeEcpDLtIgEmNxaNJxeL7G6iX/e75vmKN/odJegejBbhGxURD/FYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=DtQIhr7U; arc=none smtp.client-ip=91.218.175.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="DtQIhr7U"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qBuw3P10cyk7hqxwawfF3KVpPN1JMrZ5HAcv/JozHb0=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790558854; v=1; x=1791163654;
 b=DtQIhr7UgH/s2WqBP4ynNVhz2Oy3t+hrziS+9Z0Lw/Bb6RtWRq/oUHSbv5Tq0qMlgdsIb/z3
 bH5+phZMYkQWz71LCWXiqMgSHVJo8zL6fGBuSj5bRp/s3KQLKVdE/8qAtBGrsQ1M9yP/UsBshRx
 pUGh4v+pPUw5GpV62n7yxjyUPFLylG3eASo53ar5FKuGSh07dnnGPHarx5dRgnpWIR/hQmrAR9c
 IyooEDjZAaS2SSYPXil28Is0YqkHRUy9QIUhjipGrkFf14oCj+bBaWyYzSFUFmh/4ZjtZa9pv/t
 xpNTfrOYfq8znBpNeojdX1rUZCPixn/wf2e74ZEVod6IQ==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 88de1fd6fa0ed042;
	Mon, 28 Sep 2026 01:27:24 +0000
X-Mizu-Trace-ID: 88de1fd6fa0ed042
X-Migadu-Flow: FLOW_OUT
Message-ID: <c11e87c1-8388-4ce1-b929-2a9e42ecb9f4@chenxiaosong.com>
Date: Mon, 28 Sep 2026 09:27:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] smb/server: save simple notify events
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: tom@talpey.com, senozhatsky@chromium.org, linux-cifs@vger.kernel.org,
 ChenXiaoSong <chenxiaosong@kylinos.cn>,
 ChenXiaoSong <chenxiaosong@chenxiaosong.com>
References: <20260926090518.78547-1-chenxiaosong@chenxiaosong.com>
 <20260926090518.78547-8-chenxiaosong@chenxiaosong.com>
 <CAKYAXd8A3GB7QPUvevFaGOA2MNWcy++6nyEJTkhUnwqjUHdfhg@mail.gmail.com>
Content-Language: en-US
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd8A3GB7QPUvevFaGOA2MNWcy++6nyEJTkhUnwqjUHdfhg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Okay, I will add a limit on the number of events in the next version.

On 9/27/26 18:31, Namjae Jeon wrote:
> Could we put a per-open limit on the memory used by notify->events?

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

