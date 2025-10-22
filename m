Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865D8190477
	for <linux-cifs@vger.kernel.org>; Wed, 22 Oct 2025 05:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761112552; cv=none; b=ipihJhVJ5ZEU1U/rKeJTI5TSptm7/zQIp0mQUgLMdLw+oJQlK6uzmzM1wDv1YR3qTTgGpyunhnQdpAcVwZYITqokUmOfbn5yg2i6wKxcjTQxFE18B3PKarnjZlgOEPUir3V8rnKgIPI+XuFP/6YO/DOSsY0m5gP1bgE0nh/Akq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761112552; c=relaxed/simple;
	bh=CAE35DJcjLYj2/oXjadiEL4ZX4qY39eziNS80KbwbhQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nJi/17iIimIlnUxOFK+iza3iOZbu9wM3+3RO8zet4sO+i3V7ZEITmNlEtJKrWqyY6tTJ7d5v1pLeAL3VO6FHD96gcTuVsCeaQHQF43XwUtM/GjPpVTLM/Y8poweF5/OZmt0nhP5DZ8LhidlsiMyQtQZIc3wzQvQumauWOTURyL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ejh+DcD0; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ejh+DcD0"
Message-ID: <bc56789f-7caa-45d8-814b-f9f169519959@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761112548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O9v8uzOZ2BjUR4zUy5fKDZn7QBtnMzhYGRU6pZ93UAA=;
	b=Ejh+DcD0uofz+F23p0ULeC77nHIN/vp21YzT60jryIE4l8GESqxhtAu34b8BgLXWpY4sm8
	o4oKr4BAgfztUEre4kEVoSMtxjKqy+CjKP+AwYMU4R3i7CyqJmLGkTGYQRKHpkhrqzSn6K
	yAxjIAR7QiSuXEn6F1hY1FrhWJRYLX0=
Date: Wed, 22 Oct 2025 13:55:25 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 13/22] smb: move file access permission bits
 definitions to common/cifspdu.h
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: stfrench@microsoft.com, metze@samba.org, pali@kernel.org,
 smfrench@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
 tom@talpey.com, pc@manguebit.org, ronniesahlberg@gmail.com,
 sprasad@microsoft.com, bharathsm@microsoft.com,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251014071917.3004573-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251014072856.3004683-3-chenxiaosong.chenxiaosong@linux.dev>
 <CAKYAXd-4oA1JV7zjrdKqw835ErnOU9ge7RYfbL7ij9X-OAY9hQ@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAKYAXd-4oA1JV7zjrdKqw835ErnOU9ge7RYfbL7ij9X-OAY9hQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Should we move all file access permission bit definitions to 
common/cifspdu.h?

Perhaps in the future we can change them to be the same.

On 10/20/25 1:27 PM, Namjae Jeon wrote:
>> +
>> +#define CLIENT_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA | FILE_WRITE_EA \
>> +                               | FILE_READ_ATTRIBUTES \
>> +                               | FILE_WRITE_ATTRIBUTES \
>> +                               | DELETE | READ_CONTROL | WRITE_DAC \
>> +                               | WRITE_OWNER | SYNCHRONIZE)
>> +#define SERVER_SET_FILE_READ_RIGHTS (FILE_READ_DATA | FILE_READ_EA \
>> +                               | FILE_READ_ATTRIBUTES \
>> +                               | DELETE | READ_CONTROL | WRITE_DAC \
>> +                               | WRITE_OWNER | SYNCHRONIZE)
>> +#define CLIENT_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
>> +                               | FILE_READ_EA | FILE_WRITE_EA \
>> +                               | FILE_READ_ATTRIBUTES \
>> +                               | FILE_WRITE_ATTRIBUTES \
>> +                               | DELETE | READ_CONTROL | WRITE_DAC \
>> +                               | WRITE_OWNER | SYNCHRONIZE)
>> +#define SERVER_SET_FILE_WRITE_RIGHTS (FILE_WRITE_DATA | FILE_APPEND_DATA \
>> +                               | FILE_WRITE_EA \
>> +                               | FILE_DELETE_CHILD \
>> +                               | FILE_WRITE_ATTRIBUTES \
>> +                               | DELETE | READ_CONTROL | WRITE_DAC \
>> +                               | WRITE_OWNER | SYNCHRONIZE)
> What's the reason for moving it if the smb client and server don't share it?

-- 
Thanks,
ChenXiaoSong.

