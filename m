Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B0B1E878;
	Mon, 26 Feb 2024 22:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708988058; cv=none; b=fkdm7lCmScaFFf6U1RbpnUhiIi/0+Q1ZuaY4tQh6u/M+k9k2Ag8sGhd4+WqvT1GC2X+6cbHlHu70UATc4t2Ui9DqLl+hP2UltLnRJhkuwypU8nHD2TCCYBLSndKCEPlgu+G2JINCnr+g7U1NzpQak0ERgZXwPHAUdS6OBIjIdmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708988058; c=relaxed/simple;
	bh=R7yJHhMUzALWUVwkqwEb0QPTmDVjJOjmsFPrpsU34/s=;
	h=Subject:Message-ID:Date:MIME-Version:To:CC:References:From:
	 In-Reply-To:Content-Type; b=WwgELkyiQS4csYc+1YE50gf83Jf6E0eAvL8lIRMqxp95/HYYEhi+E2mdsq3DWniVEqCJPJCkvU3nTq5kk9/a7mzLWYh5nJ4oyd9vGuyEXdHLmWI8ZNked0D5XK17fNChMGYlzN42wTDma/1P7EiWG7Tl7OQFbFeRPcxOuwX20R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b=pkl4HWtD; arc=none smtp.client-ip=99.78.197.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="pkl4HWtD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1708988057; x=1740524057;
  h=message-id:date:mime-version:to:cc:references:from:
   in-reply-to:content-transfer-encoding:subject;
  bh=EBOK6+JFDrs7P79a2vp69jn0JzK7kVNq2lvjt1XUtPg=;
  b=pkl4HWtD023Oa4Y88bQNxdZrEHkpxk2XuL/zACHCAIJotQfDo8dCKLNT
   S+kJrXIx6AXFgMtafbUKHTB7eiv/lMTlWsORCcd0ZeaPC0VBHfZS5IAzI
   PSwlQJD6DAb3+ci7kFl/agG4/BhAIOUyO2O3llrbOtYOLdU29B1LaRVHa
   E=;
X-IronPort-AV: E=Sophos;i="6.06,186,1705363200"; 
   d="scan'208";a="276895848"
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with "Resource
 temporarily unavailable"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO smtpout.prod.us-east-1.prod.farcaster.email.amazon.dev) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2024 22:54:15 +0000
Received: from EX19MTAEUA001.ant.amazon.com [10.0.43.254:51768]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.45.210:2525] with esmtp (Farcaster)
 id 42027716-0bfb-4a9f-a713-883e7afe5f50; Mon, 26 Feb 2024 22:54:13 +0000 (UTC)
X-Farcaster-Flow-ID: 42027716-0bfb-4a9f-a713-883e7afe5f50
Received: from EX19D018EUA004.ant.amazon.com (10.252.50.85) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Mon, 26 Feb 2024 22:54:13 +0000
Received: from [192.168.17.69] (10.106.82.23) by EX19D018EUA004.ant.amazon.com
 (10.252.50.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1258.28; Mon, 26 Feb
 2024 22:54:13 +0000
Message-ID: <fd3af426-ee53-45be-9220-2ff253ea255b@amazon.com>
Date: Mon, 26 Feb 2024 22:54:12 +0000
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: Linux regressions mailing list <regressions@lists.linux.dev>, "SeongJae
 Park" <sj@kernel.org>, "pc@manguebit.com" <pc@manguebit.com>,
	"leonardo@schenkel.net" <leonardo@schenkel.net>, "linux-cifs@vger.kernel.org"
	<linux-cifs@vger.kernel.org>, "m.weissbach@info-gate.de"
	<m.weissbach@info-gate.de>, "sairon@sairon.cz" <sairon@sairon.cz>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20240126191351.56183-1-sj@kernel.org>
 <2ab43584-8b6f-4c39-ae49-401530570c7a@leemhuis.info>
 <fd0174a5-8319-436d-bf05-0f6a3794f6f9@amazon.com>
 <2024022604-encrypt-dullness-8127@gregkh>
From: "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
In-Reply-To: <2024022604-encrypt-dullness-8127@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EX19D008EUA003.ant.amazon.com (10.252.50.155) To
 EX19D018EUA004.ant.amazon.com (10.252.50.85)

On 26/02/2024 14:55, gregkh@linuxfoundation.org wrote:

> 
> Please send this as a patch series, in a new thread, so we can properly
> track this, we have too many different threads here (and the subject
> line is wrong...)
> 
> thanks,
> 
> greg k-h

Thanks Greg and apologize for the noise, I figured out that this has 
something to do with our test environment setup. I have redone the test 
manually and a looks good so I'd say we can close this thread for now :)

Hazem

