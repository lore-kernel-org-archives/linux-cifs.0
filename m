Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E741EA7CE;
	Sun,  5 Oct 2025 13:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759672363; cv=none; b=TeQsDMFrDlo1Cz+PC2W3XyRzGa+/C2dar/l08LbtS3ow7xPX4AsNQdhhvjqSfp96U6fdCCGSMXM3i1+Wt5oxTm3yYIeyV3JGn8ZJvjqI5XkuoKbginj1nLoCsG20yCp6x1oNeh8aTZY9eRpWkwHk06wYvxVl5taP7sad6CFcOMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759672363; c=relaxed/simple;
	bh=fQdQWY5g46NxSisspRkkYJxgdteAG6yAeRwHCdL2AcY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jskzCIUCkTc0gP5KcqP0o96UadRGj07tNvc3cKTcEBuiHCsNupUQ+d4z+epEZFLUHpDOaw3etidI3aCGQPvpYnQy1e+b+/2gH4Pw1nQNNNIW+fSDIsTA0mXtrQ2wswieZ6H8UHbmXQQWha4Vnkyr72EkfcbPao+Sf3MzV/bjbaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: Fushuai Wang <wangfushuai@baidu.com>
To: <markus.elfring@web.de>
CC: <bharathsm@microsoft.com>, <linux-cifs@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <pc@manguebit.org>,
	<ronniesahlberg@gmail.com>, <samba-technical@lists.samba.org>,
	<sfrench@samba.org>, <sprasad@microsoft.com>, <tom@talpey.com>,
	<wangfushuai@baidu.com>
Subject: Re: [PATCH] cifs: Fix copy_to_iter return value check
Date: Sun, 5 Oct 2025 21:51:32 +0800
Message-ID: <20251005135132.33612-1-wangfushuai@baidu.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <912d867a-f08f-40d3-bbd3-9ada24f468fd@web.de>
References: <912d867a-f08f-40d3-bbd3-9ada24f468fd@web.de>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="y"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: bjkjy-exc8.internal.baidu.com (172.31.50.52) To
 bjkjy-exc17.internal.baidu.com (172.31.50.13)
X-FEAS-Client-IP: 172.31.50.13
X-FE-Policy-ID: 52:10:53:SYSTEM

>> The return value of copy_to_iter() function will never be negative,
>> it is the number of bytes copied, or zero if nothing was copied.
> …
> 
> Why do you propose to preserve the comparison operator part “<” then?
> Would the condition check “!length” be nicer at this place?

Yes, you are right. I will send a v2 shortly.

Regards,
Wang.
