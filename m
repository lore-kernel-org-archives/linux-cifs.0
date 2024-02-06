Received: from air.basealt.ru (air.basealt.ru [194.107.17.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242874A3C;
	Tue,  6 Feb 2024 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707237240; cv=none; b=T7LKeS2p+tzfeM4FN25gp56CMdElFsukf6S2/aRApZEIVMoP18MjR2dDurLMVvt22N2ZEaVrYqD3AeSw3POFmVOhhqrdscIDWdeKZ+8EU6/o1pTLbI04kodiwZfjkt6Sd7Ofx/Lp0JzktiBtQZbhMvQmEo6vlWX9k/C2yGcOUvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707237240; c=relaxed/simple;
	bh=xnyKCGVGW+vNEKJDrqf0/JVto/qSmvt6WM5rkiIILRM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D/lnS1P/9y6dS+9NZG2QQHuOqDbbygRpOK4hjNIul53lqG1RzVjps0Y74/kWGuZ6uR782VD0PVq/uzGV+0P4rdrXkwJvkYNBvXQXiS1HPPLiqjlv0qi02SZmN6XOHOUKErZ4Ud9UOQNnQyfxwr5PYYhpGqDV74b1pqRtqOzpQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: by air.basealt.ru (Postfix, from userid 490)
	id 586D22F20280; Tue,  6 Feb 2024 16:33:56 +0000 (UTC)
X-Spam-Level: 
Received: from [10.88.144.178] (obninsk.basealt.ru [217.15.195.17])
	by air.basealt.ru (Postfix) with ESMTPSA id EBB8F2F20247;
	Tue,  6 Feb 2024 16:33:53 +0000 (UTC)
Message-ID: <7903fc0a-d0c5-20bf-20cc-d9f092e5c498@basealt.ru>
Date: Tue, 6 Feb 2024 19:33:53 +0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [REGRESSION 6.1.70] system calls with CIFS mounts failing with
 "Resource temporarily unavailable"
Content-Language: en-US
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Salvatore Bonaccorso <carnil@debian.org>,
 "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>
Cc: Paulo Alcantara <pc@manguebit.com>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "leonardo@schenkel.net" <leonardo@schenkel.net>,
 "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "m.weissbach@info-gate.de" <m.weissbach@info-gate.de>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 "sairon@sairon.cz" <sairon@sairon.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Steve French <smfrench@gmail.com>, Darren Kenny <darren.kenny@oracle.com>
References: <53F11617-D406-47C6-8CA7-5BE26EB042BE@amazon.com>
 <9B20AAD6-2C27-4791-8CA9-D7DB912EDC86@amazon.com>
 <2024011521-feed-vanish-5626@gregkh>
 <716A5E86-9D25-4729-BF65-90AC2A335301@amazon.com>
 <ZbnpDbgV7ZCRy3TT@eldamar.lan>
 <848c0723a10638fcf293514fab8cfa2e@manguebit.com>
 <3bfc7bc4-05cd-4353-8fca-a391d6cb9bf4@amazon.com>
 <Zb5eL-AKcZpmvYSl@eldamar.lan>
 <61fde07c-f767-42b0-9bfa-ef915b28fb77@oracle.com>
From: kovalev@altlinux.org
In-Reply-To: <61fde07c-f767-42b0-9bfa-ef915b28fb77@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello everyone,

06.02.2024 10:46, Harshit Mogalapalli wrote:
>
> Adding kovalev here(who backported it to 5.10.y)
I adapted the commit "smb3: Replace smb2pdu 1-element arrays with 
flex-arrays" for 5.15.y and sent patch[1].


[1] 
https://lore.kernel.org/lkml/20240206161111.454699-1-kovalev@altlinux.org/T/#u

-- 
Regards,
Vasiliy Kovalev

