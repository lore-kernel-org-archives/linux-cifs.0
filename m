Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6771945E
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 19:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="jT+c4W7M"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14040211B
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 11:41:05 -0800 (PST)
Message-ID: <147809311fa1593993c7852e32fa52fd.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699472463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FQKGVpUiF1mpGEKJ24/XP7V2zEfiT2wTo0saMsGm4lI=;
	b=jT+c4W7MaOW7e5XyeIoPinzfANk6VYN8EJs3v349PsqQGLm9gxpmM8bLRGXNo2b/ULj7mL
	uQ9BuCjcJXsXRgUIaW8MtJg+VpriWA8Ax00+E80l0Ls9MoQHs27sMNH3a1cWgw0SoNN9Zx
	8Z4WtJGg1ZMLbU42Mh/uhC7ZL2B2oDBvR3+Yvltz8w7sTeVvUrEqZfvISMTDRDNIWrW88z
	Iv/OrAaOGNTTXolVCta8Aiwt8PgheRiRJSD23sMGrUx9C96o9u7tBpKRmUmgtXKzviPuCb
	G+d6HIW8c+mLjwm8rUxo/cvuaoUg5t5xkS/Cd7ybsf168B4Pv548mKxvDjX51g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699472463; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FQKGVpUiF1mpGEKJ24/XP7V2zEfiT2wTo0saMsGm4lI=;
	b=h8IYCxOQJgi9PWvmYhp77nWxA4sagnFtzxA+QxOIXQypUAIqB8fuEsrwRPNVTu9UBZloVf
	n0Ke7RIaZpJLT+GaK5OefCSmKjXGWlrGxJus17nJUZtLGuD2fqu1y5ZnX0gXq0bi3E41en
	rqWTTdbU8jy58ZMXHTWVnjqa6vo2rqemJwC0kMRg6W/lt5h8T4+ttCz0G0ZD9pe/51Zowk
	tCIKK+PJT1oop/b2whAiswkY53ykxRsXqFqneCooqM3AH0T0H01Hkj3jKWmVly1QqaoZTV
	phx9bFZeirQkZ8h59WWcEJO8hN8d4YCHz3srDSbXPj0pMjGf685H+IkAaZ/YPw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699472463; a=rsa-sha256;
	cv=none;
	b=rKxa0sHa6b8ja8daIbbdOxQx0nrTVRm5+8NkPnw4OUElTbtyT9ixVcOkJL4PmBnNbbz52k
	r1jDUBdhh0tS8r5qX4Qes0fhQzXRiYmGDNtfYWndOWWlgWEHWqDcdvBkXqWlmX44/V62X0
	Im0tVjzD1gSrwQ2ZImN2PMBhdlYPyirdVki3W4DxCIL8zdrCNZZKrMGQERVyHxBhF53NEU
	73jAN0DRK7q6+Z3Mt77tV5x/kQTmFFLAgOgj92hO+Xjr55qEqdsqM1+rTlvzg6pn9tescB
	9Awt49StmtD5amg/o0KcTncQMsqIEXVXUYf7hQ9sL06YYjyf9B4WwoGnPOTn/A==
From: Paulo Alcantara <pc@manguebit.com>
To: nspmangalore@gmail.com, smfrench@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting
 multichannel
In-Reply-To: <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-12-sprasad@microsoft.com>
 <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com>
Date: Wed, 08 Nov 2023 16:41:00 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

> and leaked server connections
>
> 	Display Internal CIFS Data Structures for Debugging
> 	---------------------------------------------------
> 	CIFS Version 2.46
> 	Features: DFS,FSCACHE,STATS2,DEBUG2,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL,WITNESS
> 	CIFSMaxBufSize: 16384
> 	Active VFS Requests: 0
> 	
> 	Servers: 
> 	1) ConnectionId: 0x70e Hostname: w22-root2.gandalf.test 
> 	ClientGUID: 44DAE383-3E91-3042-85FE-87D6F17298B7
> 	Number of credits: 1,1,1 Dialect 0x210
> 	Server capabilities: 0x300007
> 	TCP status: 4 Instance: 77
> 	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840 
> 	In Send: 0 In MaxReq Wait: 0
> 	DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link10
> 	
> 	        Sessions: 
> 	                [NONE]
> 	2) ConnectionId: 0x706 Hostname: w22-root2.gandalf.test 
> 	ClientGUID: C8CF45E4-F70D-DF40-8821-0234A2E20DD4
> 	Number of credits: 1,1,1 Dialect 0x210
> 	Server capabilities: 0x300007
> 	TCP status: 4 Instance: 81
> 	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840 
> 	In Send: 0 In MaxReq Wait: 0
> 	DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link6
> 	
> 	        Sessions: 
> 	                [NONE]
> 	3) ConnectionId: 0x6ae Hostname: w22-root1.gandalf.test 
> 	ClientGUID: AB059CDD-12FF-B94D-B30C-9E1928ACBA95
> 	Number of credits: 1,1,1 Dialect 0x210
> 	Server capabilities: 0x300007
> 	TCP status: 4 Instance: 96
> 	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840 
> 	In Send: 0 In MaxReq Wait: 0
> 	DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link9
> 	
> 	        Sessions: 
> 	                [NONE]
>         ...

I ended up with a simple reproducer for the above

        mount.cifs //srv/share /mnt/1 -o ...,echo_interval=10
        iptables -I INPUT -s $srvaddr -j DROP
        stat -f /mnt/1
        # check dmesg for "BUG: sleeping function called from invalid context"
        iptables -I INPUT -s $srvaddr -j ACCEPT
        stat -f /mnt/1
        umount /mnt/1
        # check /proc/fs/cifs/DebugData for leaked server connection
