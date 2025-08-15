Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A532425DB06
	for <linux-cifs@vger.kernel.org>; Fri, 15 Aug 2025 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755261923; cv=none; b=lY3dhZFd0fX5W1xw8u6wqEK9h7GFtb/k5XdivXpEgDDSceH4vjAT80V+qBJvnSEk9H5stQtfOlR46Dp7UwbJBAXI7lUVgBsXHMoAPmCsIsCE/M3m4t44/C4S62PffE8LmCU6SNCuIqOU/Dn5QwX08v0ryb70ypAx931glzUYfJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755261923; c=relaxed/simple;
	bh=pkhADcm4d2zUamJn3W0p3Eq2a5cPGqHLCMuEn42tPQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QD0aL4OmOUEWZq2qUwcGAf3F2Tt3Q3hgrKb3PfynFl2b0QqRv0LlvpiewJHxAYwdH4tszdiarywnfr60sIRPY79nJF+ZRLaQVvIrjCkUvYogH++TmYYHjhJKtrNwuupktNTZLDvQ0l4wyr59tU4oqtt0SmhBarAXrDmyyqY7+9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=WuiCfmcI; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="WuiCfmcI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=nZ2IGzRayrl8xt2kkonIr9cFYZvI/Yf/w4ZRxOOUMbM=; b=WuiCfmcI1BQDkRrZ1ZZfSmD/0c
	wm47jYkOJUIedi+vzbq2rbSjWc2ph3dtdLtJ3pQLK8lMXsd4sf4/AeOIxY9J4Jheu2YfDqHqcBmV3
	29B4PxGf09hdLOYkQ3fF0Q9jzdGHzCeL8lIAn2tlNxOnPTw6ZVaS4MIXWI5y/i4XnZhMlJCahN695
	G8I7H4Lf/ZoMX8evAhcZ5M6COqlySB49QtOpOcutF8lXEV0SGgdytOKB3ScFfuqJJVgbAv4BcqD0x
	xtgd4/CGo+47nettmQvnkepcGU2xKFzcOBDorx9jYlw7plVwipPs/MvVUagF27y8w0QzqCc+GpGd8
	7Yw+ub6LhbRWtrtGyIr11nOvbiu+W7FqnTNyCj3pVoJSOKJVOvwtZk2bIA/TGcKpSbfO1k1mR+Q34
	dkQeuRbGPhyHfgvptKc4N2rNoqrNY/JH0DqN/rb4E0s1QtJ4cdJiTsX07tR9bPhB+salluRiamLtJ
	lw/GjZyH3CP6hYencnMHY/LY;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1umto1-002zyG-24;
	Fri, 15 Aug 2025 12:45:13 +0000
Message-ID: <706b8f8e-57f2-4d34-a6f8-c672c921e4f2@samba.org>
Date: Fri, 15 Aug 2025 14:45:13 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smb: server: split ksmbd_rdma_stop_listening() out of
 ksmbd_rdma_destroy()
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>
References: <20250812164546.29238-1-metze@samba.org>
 <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <cwxjlestdk3u5u6cqrr7cpblkfrwwx3obibhuk2wnu4ttneofm@y3fg6wpvooev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pedro,

>> +void ksmbd_rdma_destroy(void)
>> +{
>>   	if (smb_direct_wq) {
>>   		destroy_workqueue(smb_direct_wq);
>>   		smb_direct_wq = NULL;
>> diff --git a/fs/smb/server/transport_rdma.h b/fs/smb/server/transport_rdma.h
>> index 0fb692c40e21..659ed668de2d 100644
>> --- a/fs/smb/server/transport_rdma.h
>> +++ b/fs/smb/server/transport_rdma.h
>> @@ -13,13 +13,15 @@
>>   
>>   #ifdef CONFIG_SMB_SERVER_SMBDIRECT
>>   int ksmbd_rdma_init(void);
>> +void ksmbd_rdma_stop_listening(void);
>>   void ksmbd_rdma_destroy(void);
>>   bool ksmbd_rdma_capable_netdev(struct net_device *netdev);
>>   void init_smbd_max_io_size(unsigned int sz);
>>   unsigned int get_smbd_max_read_write_size(void);
>>   #else
>>   static inline int ksmbd_rdma_init(void) { return 0; }
>> -static inline int ksmbd_rdma_destroy(void) { return 0; }
>> +static inline void ksmbd_rdma_stop_listening(void) { return };
>                                                       ^^ return; (nothing at all would be even better)
> This seems to have broken our internal linux-next builds.

Sorry for that!

Steve can you remove 'return' so that the line is this:
static inline void ksmbd_rdma_stop_listening(void) { }

Thanks!
metze
