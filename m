Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7728936AF6
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 19:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="NSYxispb"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD5E1FD6
	for <linux-cifs@vger.kernel.org>; Wed,  8 Nov 2023 11:13:20 -0800 (PST)
Message-ID: <5890a4eec52f50b271ba8188f1ace1c9.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699470799;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ou9KQUrClMN3Sb7XT7/A2L70fkRJAOQvDFKgrPmJRPE=;
	b=NSYxispbJ4Ov/Dgi1zNFJBafWQiB+vK1esgOtBNP87JxXhIJ3bq36FPN3MPbNMNMhohNZg
	iT1cJbpjrL5ObWLZ/HMztOekuJRgfABvfGgOpmR13jJQhlownGHxFLQb3q13wJPP4/1rWG
	JznzO2tdEJf6K2jA6hZW+9XvFs2XMmQBVx194kKODm2M+46JF9j9D0qxIGcbxBO5eOBhFL
	ncstSLPT7F96cRdv7zYVkCtbiKXLfoGdAYFksKNdhplfZphqurmFHMfhyg6QIRujPiX03f
	PIuBQA7UDAwhTEXwHE+Ll8CMKhcBhLhCnJxp5Wwjkosxc9N9zP6CyflhbSGZbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1699470799; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ou9KQUrClMN3Sb7XT7/A2L70fkRJAOQvDFKgrPmJRPE=;
	b=UG+a5LoIRNY5I5TxfVYnQl6LSoXOBbHX1qQusEwJL2Y46wNOVaqDlehTVkVi1Y0hbwBT/p
	0fzIWvZPzsLrz2WU2ntl4o23sNnexQROZ5NHcwt3YIwPXrQkhd11Y1WnsRHaqPeVMls/RZ
	wD610LBN1U7T+zquj5xsqLJNA1Brwyfqxngn0DfyN67wIF17TLTQSdYrsbmp2esqJ50UyX
	QLtajmhwVf/35pdtvdZz4Ibwdvb+tcQX8+2SizDLAAR6qITBpDBHUWcocBIQT3Ij90xmIu
	7vNmfxwobMX47ZRxOIl/3wxGkfaAqAkwEVsIbOnsVErkm9CPaK1VixRIQ5Nc6Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1699470799; a=rsa-sha256;
	cv=none;
	b=IxbT/31gngAMUX40xw6lIWZAy8OcdTdyUuxOd6/9RhQD+tHQtiZ1AFlIyg3QpRaoOV2JK9
	Ggo0KcDQLQULLidxgD9vzamvmLertUkg47FcVDp86UTf8ERtdsd7jHoqdLCkTDGREC959m
	GaStX9S+cJsDxEcJ/sc4BsXPiEA/GHsZf1CC2q+4TRfoYANY6wOd7ofE2sU15Xtl/6e3rK
	dyS2gAEbbvpCJTN/uPQoe2vMkumoFjdOpSkoCgoRDm4uQSrQv1KF9lVur7z2Jao346Iqwf
	lINfajUGEe6lnjO9zZ+Ql0VKXxb9xVlLKvViHAE4D9kBZkpSSb7EuLiAMlGO7A==
From: Paulo Alcantara <pc@manguebit.com>
To: nspmangalore@gmail.com, smfrench@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 12/14] cifs: handle when server stops supporting
 multichannel
In-Reply-To: <notmuch-sha1-9ed0289358ca5c90903408ad9c0ac0310afee598>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-12-sprasad@microsoft.com>
Date: Wed, 08 Nov 2023 16:13:16 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Also found memory leaks

        ...
	unreferenced object 0xffff88801c8ca600 (size 192):
	  comm "python3", pid 14002, jiffies 4300343883 (age 4393.481s)
	  hex dump (first 32 bytes):
	    f0 a2 8b 17 80 88 ff ff f0 a2 8b 17 80 88 ff ff  ................
	    01 00 00 00 00 00 00 00 00 ca 9a 3b 00 00 00 00  ...........;....
	  backtrace:
	    [<ffffffff8144e3f5>] __kmem_cache_alloc_node+0x295/0x2d0
	    [<ffffffff813ab1aa>] kmalloc_trace+0x2a/0xc0
	    [<ffffffffc016178d>] parse_server_interfaces+0x4ed/0xcc0 [cifs]
	    [<ffffffffc016ae13>] SMB3_request_interfaces+0x163/0x2b0 [cifs]
	    [<ffffffffc016b0dd>] smb3_qfs_tcon+0x16d/0x2c0 [cifs]
	    [<ffffffffc01102c1>] cifs_mount_get_tcon+0x3b1/0x550 [cifs]
	    [<ffffffffc01a2471>] dfs_mount_share+0xcc1/0xfa0 [cifs]
	    [<ffffffffc011089a>] cifs_mount+0xda/0x4c0 [cifs]
	    [<ffffffffc01006d5>] cifs_smb3_do_mount+0x1e5/0xcc0 [cifs]
	    [<ffffffffc01954cd>] smb3_get_tree+0x16d/0x380 [cifs]
	    [<ffffffff8147c1ad>] vfs_get_tree+0x4d/0x190
	    [<ffffffff814bdbc3>] fc_mount+0x13/0x60
	    [<ffffffffc019aae4>] cifs_do_automount.isra.0+0x3c4/0x4d0 [cifs]
	    [<ffffffffc019ae3d>] cifs_d_automount+0x4d/0x1b0 [cifs]
	    [<ffffffff8148b01c>] __traverse_mounts+0xcc/0x300
	    [<ffffffff8149350b>] step_into+0x54b/0xd30

and leaked server connections

	Display Internal CIFS Data Structures for Debugging
	---------------------------------------------------
	CIFS Version 2.46
	Features: DFS,FSCACHE,STATS2,DEBUG2,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL,WITNESS
	CIFSMaxBufSize: 16384
	Active VFS Requests: 0
	
	Servers: 
	1) ConnectionId: 0x70e Hostname: w22-root2.gandalf.test 
	ClientGUID: 44DAE383-3E91-3042-85FE-87D6F17298B7
	Number of credits: 1,1,1 Dialect 0x210
	Server capabilities: 0x300007
	TCP status: 4 Instance: 77
	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840 
	In Send: 0 In MaxReq Wait: 0
	DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link10
	
	        Sessions: 
	                [NONE]
	2) ConnectionId: 0x706 Hostname: w22-root2.gandalf.test 
	ClientGUID: C8CF45E4-F70D-DF40-8821-0234A2E20DD4
	Number of credits: 1,1,1 Dialect 0x210
	Server capabilities: 0x300007
	TCP status: 4 Instance: 81
	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840 
	In Send: 0 In MaxReq Wait: 0
	DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link6
	
	        Sessions: 
	                [NONE]
	3) ConnectionId: 0x6ae Hostname: w22-root1.gandalf.test 
	ClientGUID: AB059CDD-12FF-B94D-B30C-9E1928ACBA95
	Number of credits: 1,1,1 Dialect 0x210
	Server capabilities: 0x300007
	TCP status: 4 Instance: 96
	Local Users To Server: 1 SecMode: 0x1 Req On Wire: 0 Net namespace: 4026531840 
	In Send: 0 In MaxReq Wait: 0
	DFS leaf full path: \\W22-ROOT1.GANDALF.TEST\dfstest3\link9
	
	        Sessions: 
	                [NONE]
        ...

while running reconnect tests.
