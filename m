Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B94B1E76;
	Mon, 19 May 2025 02:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747623375; cv=none; b=YTC4U9t7EchU/1/t6Z3I375jtXlY5mQ8rocTt73dcpHAQytZ/3ca+hd6vpkEozDl5BkKr/vWwjhysGk2WiXu3IDaw/ZIsZV3UJMbu/TFfq8yArx5K4Ul0QdTjaizsooIQqzmuXjOvEz+nd/fY/fgwgQl+JWizCgtxs5Qwga3u8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747623375; c=relaxed/simple;
	bh=rTO6mvDpiFMP6dgUjgUzJPPdrt45WbaKTI860/kI5dg=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=Rkpw8ktJ9Jtu5eEcaeLOXZ0sJmUGsNNkyE0r33Fi8tGXzUHseKGF82ypdHUwVFeHn9dSUdzIQX5SQ3c8JTJj5roTZvHGo5+rWA5Dzmj6N1D6KspxN3N4FoaLHdu6mV0VQCNJGjaBQksuzqjd8rjEcezRmMcL5t+08u6wjXOknmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4b12Nn4MKDz1jBV7;
	Mon, 19 May 2025 10:55:21 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 981271A0171;
	Mon, 19 May 2025 10:56:10 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 19 May 2025 10:56:09 +0800
Message-ID: <c1e693c6-573f-49d4-b6cf-cc308c339f06@huawei.com>
Date: Mon, 19 May 2025 10:56:09 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] smb: client: Fix use-after-free in readdir
To: Steve French <smfrench@gmail.com>, Paulo Alcantara <pc@manguebit.com>
CC: <sfrench@us.ibm.com>, <linux-cifs@vger.kernel.org>,
	<samba-technical@lists.samba.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
References: <20250516091256.2756826-1-wangzhaolong1@huawei.com>
 <860a4f7600814b17e48dbabe1ae19f68@manguebit.com>
 <CAH2r5mvo1e3034LpCWUAuE0=dDBb7R0bMCmt80dGRWKMegRV+Q@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAH2r5mvo1e3034LpCWUAuE0=dDBb7R0bMCmt80dGRWKMegRV+Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemg500010.china.huawei.com (7.202.181.71)





> Merged into cifs-2.6.git for-next
> 
> I was only able to reproduce the rmmod problem once though (without
> the patch) so been tricky to test.  What server were you testing
> against (I tried current Samba and ksmbd)?
> 

I initialized the Samba server using the `samba` package provided by the
Debian Trixie distribution.

Best regards,
Wang Zhaolong
