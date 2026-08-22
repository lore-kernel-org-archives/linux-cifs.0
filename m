Received: from mta1.migadu.com (out-132.mta1.migadu.com [95.215.58.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B70A2C1584
	for <linux-cifs@vger.kernel.org>; Sat, 22 Aug 2026 10:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787396100; cv=none; b=ADMp/m0k5lyWCZs6g24Mj43Wbn691DXiKMQ4qqLR7qAqjX059xqbfVHLaTYNlnZy4EOfKNiAP4zaYmil1mepwZ3pdTVViZ5ne9i9jcXUbMLG8vVmaOjR79EteJ85Ded60If4EWq4OWiHoG3g04MPPzD8ArQwB15VuVabQXlO7jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787396100; c=relaxed/simple;
	bh=9RDiG1MLVrTGAYLv/Or3Ix+LXnF5YsREJmoIjkB74xI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HtJvHaCwR56RmiQFfVKTXxxMQFnYzl8GGx8wYc/hr+poFaOP4/tyJukjtN3aAqiRj9B382CSeUEr9+NtfUqNRwhKnhzigtoUiMTj8Ko2ZA2WP6sFHiZE8Z4cPKpw+XphPqS5g/ag6Tvo/OHD+hiKAL3SOs/zXmXIbGJHZHi1J7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=a2vpvj+/; arc=none smtp.client-ip=95.215.58.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="a2vpvj+/"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9RDiG1MLVrTGAYLv/Or3Ix+LXnF5YsREJmoIjkB74xI=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787396092; v=1; x=1788000892;
 b=a2vpvj+/Vi8HLL9JdlaKu7Z+KOGmnrBRedw8m3swlRz86DnN4iYo/K5h87Q2siFQn/GrjmFV
 DgrcP8+8XHqfoCb25YGQzvb/sRlZgzTF6d520Eka2pgc2H/qiJAGIPJ8oZy2MOw/BoWvDuXcaMp
 +d5ksA2PYgEsrHoapJn5i/b3fQMZZLMv7BaAtqKfYIFZr+syL/2p+7zzAt453RafZmIpZDLKpqp
 40o7OGkJhX6aPFZQ8BfKA1aRpknuWf0InnwyAd+E71PpEuZlNllsr8CwuchZjHfTDZfVw4iZ6Sm
 036k/rbnGZKxJfwp/+zEfVbaFYyDT/D8/lU/d45p4XSwA==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.0.104] (220.202.230.161)
	by smtp.migadu.com with ESMTPS id c6f2b55471186e3a;
	Sat, 22 Aug 2026 10:54:42 +0000
X-Mizu-Trace-ID: c6f2b55471186e3a
X-Migadu-Flow: FLOW_OUT
Message-ID: <6322b50a-6351-42cd-bc9f-ff85c72847a8@chenxiaosong.com>
Date: Sat, 22 Aug 2026 18:54:37 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] smb/client: fix stale page cache in
 insert/collapse range
To: Namjae Jeon <linkinjeon@kernel.org>, Huiwen He <huiwen.he@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com,
 senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org
References: <20260820071526.826926-1-huiwen.he@linux.dev>
 <20260820071526.826926-7-huiwen.he@linux.dev>
 <CAKYAXd9Fe5EUYjmf9dp-aHw55YpaxuiKwZibcx8ePQYkJ+E0=Q@mail.gmail.com>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <CAKYAXd9Fe5EUYjmf9dp-aHw55YpaxuiKwZibcx8ePQYkJ+E0=Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Huiwen has updated the patch and will send out v3 soon.

On 8/22/2026 6:45 PM, Namjae Jeon wrote:
> Could we also invalidate the fscache ? If yes, we need to check
> collapse range, zero range and punch hole as well.

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

