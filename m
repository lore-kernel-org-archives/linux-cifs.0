Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14EE4258EF3
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 21:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787346588; cv=none; b=Grz41kwiY9BZv4RMqhS+L6PBaCBpoCMeKLDN/Vy9xrgiiSh2NyKdkZxDQwxokCBWQC/g+OXtAne3w6qzIByuELHm2ISWTibOiQ4x//ou9poSUb26ViJolBFXR47CBm6igRLp5lHdEFPdvxDefVe1M6ZmhN/6uUgXQ1x+FchyvKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787346588; c=relaxed/simple;
	bh=7GdTHQ5dM8bFTfyK7ZBwYs1Hdqz1nChKDU0kaXSG4Wc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=N5lrlSE7R7eDMYOiUy+BylJO0w7KY2P57TAQKaW9yZvUwJYaMApP2Wr33+ToVjxJckyXUIVLmgtW2UqAiD3LeZHMl87pQ2xYOIKr/vToCil33140yDAi8dBpLKYxkSCjOLyJB8YoKhRnYmhu413Mtc0D4urHrzIet2Rcydxy6Tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZttffsPY; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=a7ZePmou; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZttffsPY";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7ZePmou"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787346586;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RqtdfT1ATXA1/0BUw37kG/PV9gR6XlRVJ/VESnJTw4I=;
	b=ZttffsPYUuA+cawJbmcE5XJXHYoHzwibxd5/1zBz8rag1f69hQh9Fg6uIXA+1dNFyBIOGe
	KNpmDM3x6qNrUplpZbcrlnk22I3VavYEHfszzU3+6ZQFE2oWaOKBUEl+DRE3UE+TPnOSvR
	Or57UD4CNSi0RIhqqYYFTAvHIi9D3O4=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-601-fZgupYFTMGaeTNZZEFMUaw-1; Fri, 21 Aug 2026 17:09:44 -0400
X-MC-Unique: fZgupYFTMGaeTNZZEFMUaw-1
X-Mimecast-MFC-AGG-ID: fZgupYFTMGaeTNZZEFMUaw_1787346584
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-52827090cc5so19663921cf.0
        for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 14:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1787346584; x=1787951384; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RqtdfT1ATXA1/0BUw37kG/PV9gR6XlRVJ/VESnJTw4I=;
        b=a7ZePmouGW1U7GqU3WhhXthgKmpqeftqxNpyTewRlnG02tpwoGDIJtJUzw6emkGCaL
         q4wBthTygGfslyRHXpq1vQfWzbYfhxLxEFMDwNV++1WdICo5P9vXOxDosFjwDq0fvJ8C
         Oy/hrAGCUG01vMOAssczQRviV+ohSHSAO9ijbHqqGP8hbhtRrf3p1zUQfGq9o3lhJa69
         WkcJwyERmi4BTvIV6Q8E9uDSSsBhc1bYx5qYxZhzGWAIi4ncALZ1+cdwgFgBRNRr21Zf
         sdi9SBcjrukj7/txOm6FrR3nJIYPeUXJNAZf7+5Phb135fk1FQzsF0oUTF4Fvt7PA+aL
         HPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787346584; x=1787951384;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RqtdfT1ATXA1/0BUw37kG/PV9gR6XlRVJ/VESnJTw4I=;
        b=qtKYOvBd7hZ9qNZszx39KJuYOEjg4eWmepJtzNGMGnSXOG8WjNv+ffIJL8mA+UFxoi
         RXB0tGpDq3YbYJMra9l6sfCQn3eN5Wuxi2WWxZnlj2qD8rjNndmRydkNxMNGi1EIb37y
         ERLfQnhKFdiCSkbNIGG+b0qruZb9WJw/8GRWZV8BXi0jBgumJ5hgHClFDSDKMPN3chkJ
         crTebqt2sOaGOfaofFkmDWUaB70x/0cLVSsOLf5O6MAySMDoM0XUYzkdO7Qtp5DLadc8
         VDVw7msrFO1mVr5Q+vLt78JydHabc2ASzwjcnamO7pFRMKRNJtlenldyuH0eHHpLjejo
         wFCg==
X-Gm-Message-State: AFuF++klaMnOrCoZw8ygW5Sjln0YpIy2+9tGFXHNAOUYt6zJEkxTE9WI
	Ptp8AcvndlyXCFjrufeSiKmjs8eF0ZdUMTcFPIEXZv/7yfb5HLMCUDF1GyyTS3VQ2j6mEXpLtWg
	IQrJs01LK9v3Xn3FI1OPjWYZwgVfI9sKQTAlIZcHpVThDoApkXdOYmNtfgI8IAYM=
X-Gm-Gg: AR+sD135PF7NjIl5m1vpKlalgLT3QehEUVdCy8kF9VAlJ9vsKoHsV5vTNm07Axza83r
	61iTAqYX18AZp2LNoFVWbtwk6eI2VwQvtMccP0/TZZi5Ct3AFOPmC4SNKgZGcGA/zA5dc5r2xm8
	d4SdLFCpcnPr0ElG3jit8Y2hd7yQhKN8jigB5FnjfkGfhN5hf/gZ+hi8RxY8gPOtDq4U/tqTdeD
	bnOXv7eN2ksbGGDYzh6Fgq9aDXk9owccD+3fiHrNLNgk8kJcmpAsir2b5tC7AB9Zhgagcy0ypYw
	NjpOYsfdGh/SThS4+/s/ACG85qhIoVd1VyVRoJjtEzTEgvRkdno7P0oscv8FSzpsEwLJgy2zc6D
	cqLpstWC/4HlpaeD+aO1APp5p40q5shlEqBeLHvN2
X-Received: by 2002:a05:622a:1b28:b0:517:6fc2:4760 with SMTP id d75a77b69052e-52de2fb21dbmr177401901cf.9.1787346584173;
        Fri, 21 Aug 2026 14:09:44 -0700 (PDT)
X-Received: by 2002:a05:622a:1b28:b0:517:6fc2:4760 with SMTP id d75a77b69052e-52de2fb21dbmr177401221cf.9.1787346583749;
        Fri, 21 Aug 2026 14:09:43 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c5f2b5ccesm71569156d6.46.2026.08.21.14.09.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 14:09:43 -0700 (PDT)
Message-ID: <512e7a00-5306-41a3-b336-3c75377a7d0d@redhat.com>
Date: Fri, 21 Aug 2026 16:09:42 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [PATCH] smb: client: fix OOB array access in __smb2_calc_size()
 on unknown Command
To: Tom Talpey <tom@talpey.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org, linkinjeon@kernel.org,
 stable@vger.kernel.org
References: <20260821142946.1728452-1-sorenson@redhat.com>
 <32cea692-1aa7-4eac-8f6f-eb39db63777a@talpey.com>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <32cea692-1aa7-4eac-8f6f-eb39db63777a@talpey.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 8/21/26 12:08 PM, Tom Talpey wrote:
> The SMB3 protocol often specifies closing the connection on invalid messages, is there some reason you are opting to ignore this field?
>
> Tom.

Examining the paths into __smb2_calc_size() more closely, I don't see a 
call path that feeds an unvalidated Command into __smb2_calc_size(); 
either smb2_check_message() pre-validates it (and tears down the 
connection as you expected), or the caller is operating on already-known 
data.

So at this point, the OOB is unreachable, and this patch is unnecessary.

My apologies; this patch should be disregarded.


Frank


> Aug 21, 2026 10:45:35 AM Frank Sorenson <sorenson@redhat.com>:
>
>> has_smb2_data_area[] is indexed by the server-supplied shdr->Command
>> with no bounds check:
>>
>>      if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
>>
>> The array has NUMBER_OF_SMB2_COMMANDS (0x13) entries; any Command value
>>> = 0x13 reads past the end into adjacent read-only data.
>> Add an upper-bound check before the lookup; commands outside the valid
>> range have no data area, so treat them as false.
>>
>> Fixes: 093b2bdad322 ("CIFS: Make demultiplex_thread work with SMB2 code")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Frank Sorenson <sorenson@redhat.com>
>> ---
>> fs/smb/client/smb2misc.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/smb/client/smb2misc.c b/fs/smb/client/smb2misc.c
>> index 9068175e57cd..26b41ea3b72b 100644
>> --- a/fs/smb/client/smb2misc.c
>> +++ b/fs/smb/client/smb2misc.c
>> @@ -451,7 +451,8 @@ __smb2_calc_size(void *buf, bool *have_data, bool *data_area_overlap)
>>       */
>>      len += le16_to_cpu(pdu->StructureSize2);
>>
>> -   if (has_smb2_data_area[le16_to_cpu(shdr->Command)] == false)
>> +   if (le16_to_cpu(shdr->Command) >= ARRAY_SIZE(has_smb2_data_area) ||
>> +       !has_smb2_data_area[le16_to_cpu(shdr->Command)])
>>          goto calc_size_exit;
>>
>>      smb2_get_data_area_len(&offset, &data_length, shdr);
>> -- 
>> 2.55.0

-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

