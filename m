Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7B522A1E1
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 21:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754516062; cv=none; b=g/hyROMVym4RJam+TY+nVU5ImT3IyupFe2XLgX0ci4dP9DdkCdWySOp8Ozp2p92xfXyjHVCn0/0ewz9t01lN0aqE3+U9HLpbaX4bMxA5lTNI5loc7hABrSK1WuGWw4StiVsE+3EwRFt0kt+q00eoL9Y7dmLDuLt79jvLwISP4Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754516062; c=relaxed/simple;
	bh=qLodcPBa/Sn0fQGQ2RFvl62cvjRzOzF3euxD8Zpw/dY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sEXfo+wg+Ekq3BGXEWCMvXFSfYtTqMtVLysdIQZlyhyUOMNQ6uIvnyXTknlCP+679DhKe74stcIcAzWlhhWRvQqjt58Uah7mcozrpxoAtHyrpgXRd+RTX8ToEBpyPBfrp2x9MpKykBcCZ6z247fyHSNl/WI15dO+ekSrwMGyN/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ej/jYa64; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ej/jYa64"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754516057;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=um36FIteZbpN+9FvU2uxmQ00AfZur1L+jdys6L8kSUI=;
	b=ej/jYa64fkxtzFyPCGaTii9pY1YfQyCvUmGi1EbGl8ynmAuXsjZfH98DrBRLQbYVwG6e7h
	lCHKoNdskO9Lv3/bvlcQZJQDBwt2e2UyQspN+9J4pDkSd+G8+qTzwbjaiVwe/qJeO67Oya
	axRvsbCj6RHk/eBO7PMAogkmy4CDkLg=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-472--_kkZdHwMH-gddaqLXUGYg-1; Wed, 06 Aug 2025 17:34:15 -0400
X-MC-Unique: -_kkZdHwMH-gddaqLXUGYg-1
X-Mimecast-MFC-AGG-ID: -_kkZdHwMH-gddaqLXUGYg_1754516055
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-478f78ff9beso10018141cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 14:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754516055; x=1755120855;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=um36FIteZbpN+9FvU2uxmQ00AfZur1L+jdys6L8kSUI=;
        b=JTVKuYDu4u2FV1OhQQCOkG2XlZhxG2S6rVi01hXt75705Kl/vPQubVI9rYrTQQA6+o
         8diUkX3CZLyvnEnM3w2K8c/C+kbSesonya//ZO03pVIyzzK4Lm008gzx8rFtZI5rCkyB
         ZfjCYhxoh4Ftw1WIFeAKHmrLmiCrglB913kgEZmETyxTDUy9kKn3dswRSXKS/bi/vh6+
         xDslJk2Kn0/O+iojROjUuxuYT/hE2xWl0o4vIypbgNV5Ipy+XLJ7sWCfU4J18d/2fKN4
         oD1/1j63cIGmUzG3HNyhM3XNyVqmcFzF1vbfDTkUaKr5J+IaSLacjiVUwRoqywQlfaAe
         2VCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRoyBhJSehQTxUa7kTx+4NEm849y0CGfms4jr2NCmALOaLkgtBLXuDg5ZVltbWAnS8MBAFzPxBr16a@vger.kernel.org
X-Gm-Message-State: AOJu0Yyf2pWsiN+aLby88BEzs3aHRFz+YLq8VHQGOSLAmvrlPSh2Vbe9
	T3quFUP0FdBtILs0AgnrHTq+xbZB3J+l0/6TvRY2NvGDEQJuReNkdjbV1OV+/WD477ZRy8qqk9g
	kvYEeiOWq5KMD8xg1xUzvaZqh3/95G7TdhxpcYJ2t/PtLiT71hb4RKDv/agte68A=
X-Gm-Gg: ASbGnctnUBcFMNwtuAdYEiHPz+ZjBP9TULzhRj174f3xoHpfTimFeIpAOsN4uNjbiSc
	FohzUHrNhT1JPvJnnK0Uerod0kaD7+dasgdp9AQRDqdBPe85kmg6UejpF++HDii44ppmfpGxJNp
	ZtuhjCNS0Wd6efcm0k9R7I+lsH5PJmfbvY2Lhz3hr4dE/so18QMT+ofgE+CUF3YPSPNpLvXBj9/
	T2wz7o7XmIXLhPLFeOksqbTHhKx818nQrO6hvPmBPw8zGxxzmtV4ALIDA8Cu5+A1JnAMwE4WAog
	9Lt7uGdH7DFtRCo1YtJS1UlSoOew2zca5benF8SLHzeuIonrxidtTU3brIN1tqX6RL5MLLXnKl2
	el2c=
X-Received: by 2002:ac8:5a4b:0:b0:4a7:189a:7580 with SMTP id d75a77b69052e-4b091403909mr67584401cf.26.1754516054985;
        Wed, 06 Aug 2025 14:34:14 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGapniQB0fSFWxRBBmtOsRSPwI5YaTVdX/oEAXr2F0Y0BydffJP9WqzafzJTRlT1rEZaxjk1w==
X-Received: by 2002:ac8:5a4b:0:b0:4a7:189a:7580 with SMTP id d75a77b69052e-4b091403909mr67583851cf.26.1754516054166;
        Wed, 06 Aug 2025 14:34:14 -0700 (PDT)
Received: from [172.16.0.69] (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7093dd53d58sm62219376d6.13.2025.08.06.14.34.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 14:34:13 -0700 (PDT)
Message-ID: <96e06395-c610-40d8-91c4-63774b66aaf4@redhat.com>
Date: Wed, 6 Aug 2025 16:34:12 -0500
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: sorenson@redhat.com
Subject: Re: [Samba] Sequence of actions resulting in data loss
To: Ralph Boehme <slow@samba.org>, Jean-Baptiste Denis <jbdenis@pasteur.fr>,
 Steve French <smfrench@gmail.com>
Cc: "samba@lists.samba.org" <samba@lists.samba.org>,
 CIFS <linux-cifs@vger.kernel.org>
References: <16aeb380-30d4-4551-9134-4e7d1dc833c0@pasteur.fr>
 <a70fe80e-5563-467a-8c1f-9fd635662be4@samba.org>
 <fac383c2-2835-448c-a3fc-561f8aec02fa@pasteur.fr>
 <dd2f2bf1-f68d-496d-bca6-3f68672952aa@pasteur.fr>
 <6309360d-088e-49c1-b2db-9ef3169a32d4@pasteur.fr>
 <39705f0a-eb2d-42a1-a135-8751c8c851b0@samba.org>
 <86ae837a-3d30-4450-b91c-3186098178ca@pasteur.fr>
 <20250801121517.32376ad4@devstation.samdom.example.com>
 <62884dd9-0667-4111-afe6-f22ea7468d8e@pasteur.fr>
 <2d2289d7-f536-462f-9505-0ba700ad40b7@samba.org>
 <20250801134029.28a4d9a9@devstation.samdom.example.com>
 <fa99ce33-4eb7-4928-bdb8-8ff162f79856@pasteur.fr>
 <50971413-289b-46af-8f74-b77ca7e94d22@samba.org>
 <d6ff088e-21b1-4cae-bb9f-289f37979f02@pasteur.fr>
 <165cbcb9-f93d-481d-b974-17349311d1ea@samba.org>
 <4f20c584-aa44-4c8f-a3bd-6a7d72abf5e2@redhat.com>
 <37ac126a-c241-4e1c-86d7-3669b8ad42ff@samba.org>
From: Frank Sorenson <sorenson@redhat.com>
Content-Language: en-US
In-Reply-To: <37ac126a-c241-4e1c-86d7-3669b8ad42ff@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/6/25 3:06 PM, Ralph Boehme wrote:
> On 8/6/25 9:48 PM, Frank Sorenson wrote:
>>> If I understand correctly, SMB has no atomic operation to replace/
>> overwrite a file through a SetInfo FILE_INFO/SMB2_FILE_RENAME_INFO 
>> operation,
>
> it has.
>
>> so it's accomplished by the two-step process of 1) removing the 
>> target file; and 2) renaming the source filename to the target filename.
>
> no. This is not needed.
>
> -slow
>
Okay, thanks for correcting me.



-- 
Frank Sorenson
sorenson@redhat.com
Principal Software Maintenance Engineer, filesystems
Red Hat

