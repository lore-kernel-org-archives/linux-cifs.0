Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0B420DE0
	for <linux-cifs@vger.kernel.org>; Tue, 19 Dec 2023 14:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="eo9aVJJs"
Message-ID: <3b34f59a0f89fb09dec5e1b04f74b70d@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702997826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gOkAB0mtxVue5kaFMSSkV8+JBktLRuPm95L6EMwrwfA=;
	b=eo9aVJJsy+PWQ1wdLk7nVgjXSvH7KmnuwYVj6L93pWeXhKLmxbPWSd47uWg1hDuQTsqf0/
	7xD8Hc2++PXGLrDPkOS6Qx0HEIneelwRDjWmxR0fzRWn5GFEKFyxZQX8PlmRewLpSyfLt1
	FjIfVl+TcVGCz82ccCSC2Zd84vC2L9S0VKZrvPZ2+QGm9WKFjkWycVtaO2PzebK3rpUq/j
	UAzirD+WQTT0qYtK94LdWhFuM/f7dqhAOtd6WLGspiZQ64F0q8/FRnvNZYAD89Mp+tdSJI
	ngB3weX09rjENqfHOflvdihSnXgy3WbG2Pnk2G9oqn6cErptA6aqa/2p+lqhSg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1702997826; a=rsa-sha256;
	cv=none;
	b=K3Z0ppJ5J6vh8DLz5CnWD0qoHuBev477/JrgRV/Oxkh1mDw8s/qZBvCunRX46iab2zzIq2
	BLLOAxhdEZr69iT8NF/H6P0iaTUHgKxXdDTEzeCsT4PzLZNqTr+Ujqf4IOdUnXcVSrnoh5
	pI6xHUvgwSn5z/zsBxK9954FNxavhkIYEt9n04DMNiSyMhDuWyohnvvFiK3ZJ7TOFvHxHu
	OevLqDVprE19QyRjnUvDcIdVDjjuc2lxMoEX9Do5KG+/w3Sc1UXIMIukL5ci1aap3P17G0
	Lcknw6cRsyNrynnAdd9+n27Oeoq2Qqy8nqhkuYiWtKCnCrtUW4qZeiDiawRtIQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1702997826; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gOkAB0mtxVue5kaFMSSkV8+JBktLRuPm95L6EMwrwfA=;
	b=tD/Diy2dVAYSLKAji4sw9TuafaCJi9rFJRiX1t/lAXfz76MDbpBGe4n9a2w1urNrtSeqVx
	uFE38C0btZO8tKzj+LEzXjqKCLDOyErr3Ughl2BEg5QBgoaDlGBvLFBNOubiSWPV54t3YU
	eY4fFAln2anPTqErJm8NyB0PnR7Q8GwpcfGCgCvCMZGZU1if8tx/gkDFaAdRogKGoMgrkM
	5N6YDNytg4xvrKxGweJinjP3EVOp2wXz1apTTjqYD7p/g28vPe1CSlIBuAJB5DT93greJm
	6386J13X1HpHfBJXT0OiGxRD2RoBkbXPIvUucJi51rQt7oiha2Sb9suCyzQ0Dw==
From: Paulo Alcantara <pc@manguebit.com>
To: Maximilian Heyne <mheyne@amazon.de>
Cc: smfrench@gmail.com, linux-cifs@vger.kernel.org, j51569436@gmail.com
Subject: Re: [PATCH 2/2] smb: client: fix potential OOB in smb2_dump_detail()
In-Reply-To: <ZYGp5FL9UYY5lYHg@amazon.de>
References: <20231216041005.7948-1-pc@manguebit.com>
 <20231216041005.7948-2-pc@manguebit.com> <ZYGp5FL9UYY5lYHg@amazon.de>
Date: Tue, 19 Dec 2023 11:57:03 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Maximilian Heyne <mheyne@amazon.de> writes:

> On Sat, Dec 16, 2023 at 01:10:05AM -0300, Paulo Alcantara wrote:
>> Validate SMB message with ->check_message() before calling
>> ->calc_smb_size().
>> 
>> This fixes CVE-2023-6610.
>> 
>> Reported-by: j51569436@gmail.com
>> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218219
>> Signed-off-by: Paulo Alcantara <pc@manguebit.com>
>> ---
>>  fs/smb/client/smb2ops.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
>> index 62b0a8df867b..66b310208545 100644
>> --- a/fs/smb/client/smb2ops.c
>> +++ b/fs/smb/client/smb2ops.c
>> @@ -403,8 +403,10 @@ smb2_dump_detail(void *buf, struct TCP_Server_Info *server)
>>  	cifs_server_dbg(VFS, "Cmd: %d Err: 0x%x Flags: 0x%x Mid: %llu Pid: %d\n",
>>  		 shdr->Command, shdr->Status, shdr->Flags, shdr->MessageId,
>>  		 shdr->Id.SyncId.ProcessId);
>> -	cifs_server_dbg(VFS, "smb buf %p len %u\n", buf,
>> -		 server->ops->calc_smb_size(buf));
>> +	if (!server->ops->check_message(buf, server->total_read, server)) {
>
> Why is this check negated? Sorry for this stupid question. I'm not
> familiar with this code but only stumbled upon this commit due to a
> CVE.

Because smb2_check_message() returns 0 for a valid SMB response and then
it would be safe to call ->calc_smb_size() as we know the header has a
valid Command (< NUMBER_OF_SMB2_COMMANDS).
