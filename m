Received: from mail-gw01.astralinux.ru (mail-gw01.astralinux.ru [37.230.196.243])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F658185935;
	Wed, 19 Mar 2025 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=37.230.196.243
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394589; cv=none; b=m/OPcSfWGERozUSZ8Kz8bFHq9v+CDajf8YYxWeH06qBLmhNvO564Yx1vL1ZYRMePhi0JB8Aj41EHSuHaFEfc+Z+VkJeq1niexDY+AScB7TeCziZwlvclkLyH8UtUVJUkF4k9MSrN/yzvLZyoSB3Ak5p5mtIEr6JLQ6OKcypxt8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394589; c=relaxed/simple;
	bh=gJO0u3hxyvpib82VNNauGf/zSAu6xI/C9h6UCsTUl+I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uFIPndyEKg5vhhPumDaf+Q9QwO3ZdixjGbdYMrekaUSVQuTzTdYOCecXonYqyikNz6AJpI1kCoX1+2A3jsMcJVKlR9/Trmtod7JIPifG9mmbuVDxUT9zcwHAVEU4oVK/RYHZnrkB9nJKYw8Wff/g33sbxFkHW/GUI05pjUB4vww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru; spf=pass smtp.mailfrom=astralinux.ru; arc=none smtp.client-ip=37.230.196.243
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=astralinux.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=astralinux.ru
Received: from gca-sc-a-srv-ksmg01.astralinux.ru (localhost [127.0.0.1])
	by mail-gw01.astralinux.ru (Postfix) with ESMTP id 37CBC25022;
	Wed, 19 Mar 2025 17:20:04 +0300 (MSK)
Received: from new-mail.astralinux.ru (gca-yc-ruca-srv-mail05.astralinux.ru [10.177.185.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail-gw01.astralinux.ru (Postfix) with ESMTPS;
	Wed, 19 Mar 2025 17:20:01 +0300 (MSK)
Received: from [10.198.18.214] (unknown [10.198.18.214])
	by new-mail.astralinux.ru (Postfix) with ESMTPA id 4ZHrSt0cmJz1c0v1;
	Wed, 19 Mar 2025 17:19:58 +0300 (MSK)
Message-ID: <6249e342-f379-4257-8a19-52b888e02c09@astralinux.ru>
Date: Wed, 19 Mar 2025 17:19:52 +0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: RuPost Desktop
Subject: Re: [lvc-project] [PATCH] cifs: avoid NULL pointer dereference in dbg
 call
Content-Language: ru
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.com>,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>,
 samba-technical@lists.samba.org, Aurelien Aptel <aaptel@suse.com>,
 linux-kernel@vger.kernel.org, Tom Talpey <tom@talpey.com>,
 Bharath SM <bharathsm@microsoft.com>,
 Ronnie Sahlberg <ronniesahlberg@gmail.com>,
 Pavel Shilovsky <pshilov@microsoft.com>, lvc-project@linuxtesting.org
References: <20250319123110.21814-1-adiupina@astralinux.ru>
 <ci4fhara55ka4mh65zn7x5vp3zjcqcytghupjzz2izudvjjejn@6qggfqf2qsxc>
From: Alexandra Diupina <adiupina@astralinux.ru>
In-Reply-To: <ci4fhara55ka4mh65zn7x5vp3zjcqcytghupjzz2izudvjjejn@6qggfqf2qsxc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-KSMG-AntiPhishing: NotDetected
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Envelope-From: adiupina@astralinux.ru
X-KSMG-AntiSpam-Info: LuaCore: 51 0.3.51 68896fb0083a027476849bf400a331a2d5d94398, {Tracking_from_domain_doesnt_match_to}, d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;astralinux.ru:7.1.1;new-mail.astralinux.ru:7.1.1;127.0.0.199:7.1.2, FromAlignment: s
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiSpam-Lua-Profiles: 191942 [Mar 19 2025]
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Version: 6.1.1.11
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.1.0.7854, bases: 2025/03/19 09:15:00 #27801794
X-KSMG-AntiVirus-Status: NotDetected, skipped
X-KSMG-LinksScanning: NotDetected
X-KSMG-Message-Action: skipped
X-KSMG-Rule-ID: 1




19/03/25 16:20, Fedor Pchelkin пишет:
> On Wed, 19. Mar 15:31, Alexandra Diupina wrote:
>> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
>> index f3c4b70b77b9..c02aab58aade 100644
>> --- a/fs/smb/client/smb2misc.c
>> +++ b/fs/smb/client/smb2misc.c
>> @@ -816,11 +816,12 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon, __u64 persistent_fid,
>>   		WARN_ONCE(tcon->tc_count < 0, "tcon refcount is negative");
>>   		spin_unlock(&cifs_tcp_ses_lock);
>>   
>> -		if (tcon->ses)
>> +		if (tcon->ses) {
>>   			server = tcon->ses->server;
>> -
>> -		cifs_server_dbg(FYI, "tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
>> -				tcon->tid, persistent_fid, volatile_fid);
>> +			cifs_server_dbg(FYI,
>> +							"tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",
>> +							tcon->tid, persistent_fid, volatile_fid);
>> +		}
> Something is wrong with the indentation. Usually scripts/checkpatch.pl
> can give some feedback on this, too.
>
> CHECK: Alignment should match open parenthesis
> #32: FILE: fs/smb/client/smb2misc.c:822:
> +			cifs_server_dbg(FYI,
> +							"tid=0x%x: tcon is closing, skipping async close retry of fid %llu %llu\n",

In the *.patch file, everything was fine with indents,
so the checkpatch.pl script completed without errors.
But when sending, the indents got corrupted for some
reason. I'll send the second version
>
>>   
>>   		return 0;
>>   	}
>> -- 
>> 2.30.2

