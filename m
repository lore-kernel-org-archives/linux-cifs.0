Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60963195E0
	for <linux-cifs@vger.kernel.org>; Tue, 16 Dec 2025 03:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765857311; cv=none; b=YMwJnvDojGRnUtmBuivV2EiZdTxHTJATR9hnUYgwtVmFA3QGNleyX6TiviiTkk/dnmskde+4XSYqep4HBpRYTvwWYR9LY4pd6BjIJDglCIa6dUeax8ESINPL0+sXWDmWdSBTODs+IXyMWo6VQM4YtCbUPA/aEyaImii7i4i58SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765857311; c=relaxed/simple;
	bh=vD1lrTQl6NAMTe1688ynXjd5wCuk270yhMtYEm8tkE0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NviwBKxgnG9tfO6FghJ/u3gGwvurj2dwIQ3kBd1yAh7IGMlHPpuZjFBACr0qSRJdfRuqV2ou42MbUP7ahujyroQWV9ZWIq31c3pkOnGoL7uRy3Rnpn50G5N9761h5Ey6qVB8G9pSZKnT8UBxxc2H6j/6W+73Nq9eh69JcKUWzPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Cff3GDZz; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Cff3GDZz"
Message-ID: <40863d78-96a5-4a4e-954e-b10b52e2b742@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765857299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KlSOeAqzrtbh5m8dkjC1grWgXVAIpehtWjg/sL5WUBA=;
	b=Cff3GDZzrMFv3aqSQd7eoib3bO0l2Fb3kBrOtIH96Igq1yvNTYrXABzoXp8ATFn1n5nwQh
	Nu0sljwsvsmoiaRgw3WtbzlrcvHUWe0X4DfjsEQt+jfTQbysb0x0/XDybuI3DaCd7Bwbo7
	kKyxq8FHszX2ehCLVc1yI9mWVY1SKCs=
Date: Tue, 16 Dec 2025 11:54:06 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: Questions about SMB2 CHANGE_NOTIFY
To: Steve French <smfrench@gmail.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Namjae Jeon <linkinjeon@samba.org>,
 Steve French <sfrench@samba.org>, pc@manguebit.org,
 ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com,
 bharathsm@microsoft.com, senozhatsky@chromium.org,
 CIFS <linux-cifs@vger.kernel.org>
References: <d745d9cf-2dc6-4240-a4be-1982082c0d28@linux.dev>
 <a6c17d48-ca81-4318-966e-67fe7df9dda3@linux.dev>
 <CAH2r5msHiZWzP5hdtPgb+wV3DL3J31RtgQRLQeuhCa_ULt3PfA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5msHiZWzP5hdtPgb+wV3DL3J31RtgQRLQeuhCa_ULt3PfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Thanks for your reply. This is very helpful for my development of ksmbd 
change notify.

I will also try to add a notify tool to cifs-utils.

Thanks,
ChenXiaoSong.

On 12/16/25 11:25, Steve French wrote:
> I had posted a sample program for using the change notify ioctl on an
> smb3.1.1 mount (see attached).  It is fairly easy to write test
> programs to use  these - see e.g. the older simply notify on Linux
> cifs.ko - IIRC something like this should work.  We could really use
> someone to add a notify tool in cifs-utils (e.g. in smbinfo tool).
> 
> import fcntl
> 
> # constant for sizeof(int)
> INT = 4
> 
> CIFS_IOCTL_MAGIC = 0xCF
> CIFS_IOC_NOTIFY =  0x4005cf09
> 
> print("CIFS_IOCTL_MAGIC:", CIFS_IOCTL_MAGIC)
> print("CIFS_IOC_NOTIFY:", CIFS_IOC_NOTIFY)
> 
> # then change some files you don't mind destroying
> fd = open('/mnt1/somefile','rb')
> 
> ret = fcntl.ioctl(fd.fileno(), CIFS_IOC_NOTIFY, fd.fileno())
> print("Exiting: ", ret);
> 
> 
> 
> e.g. notice the original commit message, and then the second one which
> was added later to allow returning what was changed not just that
> there was a change to that directory:
> 
> Author: Steve French <stfrench@microsoft.com>
> Date:   Thu Feb 6 06:00:14 2020 -0600
> 
>      cifs: add SMB3 change notification support
> 
>      A commonly used SMB3 feature is change notification, allowing an
>      app to be notified about changes to a directory. The SMB3
>      Notify request blocks until the server detects a change to that
>      directory or its contents that matches the completion flags
>      that were passed in and the "watch_tree" flag (which indicates
>      whether subdirectories under this directory should be also
>      included).  See MS-SMB2 2.2.35 for additional detail.
> 
>      To use this simply pass in the following structure to ioctl:
> 
>       struct __attribute__((__packed__)) smb3_notify {
>              uint32_t completion_filter;
>              bool    watch_tree;
>       } __packed;
> 
>       using CIFS_IOC_NOTIFY  0x4005cf09
>       or equivalently _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
> 
>      SMB3 change notification is supported by all major servers.
>      The ioctl will block until the server detects a change to that
>      directory or its subdirectories (if watch_tree is set).
> 
> commit e3e9463414f610e91528f2b920b8cb655f4bae33 (tag:
> 6.1-rc-smb3-client-fixes-part2)
> Author: Steve French <stfrench@microsoft.com>
> Date:   Sat Oct 15 00:43:22 2022 -0500
> 
>      smb3: improve SMB3 change notification support
> 
>      Change notification is a commonly supported feature by most servers,
>      but the current ioctl to request notification when a directory is
>      changed does not return the information about what changed
>      (even though it is returned by the server in the SMB3 change
>      notify response), it simply returns when there is a change.
> 
>      This ioctl improves upon CIFS_IOC_NOTIFY by returning the notify
>      information structure which includes the name of the file(s) that
>      changed and why. See MS-SMB2 2.2.35 for details on the individual
>      filter flags and the file_notify_information structure returned.
> 
>      To use this simply pass in the following (with enough space
>      to fit at least one file_notify_information structure)
> 
>      struct __attribute__((__packed__)) smb3_notify {
>             uint32_t completion_filter;
>             bool     watch_tree;
>             uint32_t data_len;
>             uint8_t  data[];
>      } __packed;
> 
>      using CIFS_IOC_NOTIFY_INFO 0xc009cf0b
>       or equivalently _IOWR(CIFS_IOCTL_MAGIC, 11, struct smb3_notify_info)
> 
>      The ioctl will block until the server detects a change to that
>      directory or its subdirectories (if watch_tree is set).
> 
> 
> On Mon, Dec 15, 2025 at 6:30 PM ChenXiaoSong
> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>
>> Steve has already told me that I can use `smbinfo` (which is part of
>> cifs-utils) and libsmb2 (which is unrelated to Samba or cifs.ko).”
>>
>> Thanks,
>> ChenXiaoSong.
>>
>> On 12/15/25 9:11 PM, ChenXiaoSong wrote:
>>> Hi,
>>>
>>> I am currently using the following two methods to query a directory for
>>> change notifications on the client side:
>>>
>>>     - `smbclient`: https://chenxiaosong.com/en/smb2-change-
>>> notify.html#linux-client-env
>>>     - Windows "File Explorer": https://chenxiaosong.com/en/smb2-change-
>>> notify.html#win-client-env
>>>
>>> Are there any better tools to print detailed info about change
>>> notifications on the client side, or any userspace C program examples
>>> (using `ioctl`) available?
>>>
>>> Thanks,
>>> ChenXiaoSong.
>>>
>>
> 
> 

