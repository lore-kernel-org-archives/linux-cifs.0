Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF083ABDA4
	for <linux-cifs@vger.kernel.org>; Fri, 21 Aug 2026 14:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322926; cv=none; b=m7rhRm4ZK+6ctmSJr/ivQhau5k7yfzq7xwpuhJ7+BdUrUCH1c2En0XQNc5MoNun9M3nSMb3+2XB/WVndYTWVyGY1vyqqIRkgiuiO6FLHhPdmj2chBaUOb/l9vj7WSft0Ssjbbg2k/VrLdSqmTbILqI+xG4spv6Ju1svfCXeq3l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322926; c=relaxed/simple;
	bh=bS7xtK3Y10mb7sXERGKBIW/BwuKG0NF2Ds5Nq9AAhMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9nfkZurLLNBZIcpxk16sBGVErbDI7wolqFIibLYXuqIfSh6SBaWVnVJSXyEqcdNZlnfGgY6ZIATMYoKE7nHY2yetcAQVHO/k42A4x2JGYmGQemq/uQPmmBt6p9PRZJ+Lx/PD3lgvZoL/QPcLTkx0TcW8tz4AuphOMaa5z82UWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=vqkPkbWn; arc=none smtp.client-ip=95.215.58.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="vqkPkbWn"
X-Envelope-To: linux-cifs@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=bS7xtK3Y10mb7sXERGKBIW/BwuKG0NF2Ds5Nq9AAhMQ=;
 c=simple/simple; d=chenxiaosong.com;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787322919; v=1; x=1787927719;
 b=vqkPkbWnchZy/MDhE+gRCT46XPGz+OWIqhbWOMBnNDvAUS7/LHqXvCjKb04eqOe0jZwslKfz
 i8h65p/Zj2q6VHhTetmHFUNHY7tNZ9DxhHHMbi1uKnd9ZZoWbwsS3Me/ivSLq7GesyOIZ60dOCP
 O+S4XX9fuwqNqRM/isBTGFNrhkqRaOlbyFIeKFIgbKXe3jgJ+4TtCikDdMVt2xxP3HLr5lC21Wi
 V3+4JyYbj4IXBzRxDHmVhc9KVp4xj/QWbviiNerejxKUAYT3EYhMj1c94UCNmoTODBLWlbsWeL3
 hy0UjONx9D0VqKD8j77Af6lHoTFsSH3b/h9r8zXaWy5Kg==
X-Envelope-To: linux-cifs@vger.kernel.org
Received: from [192.168.0.104] (220.202.230.161)
	by smtp.migadu.com with ESMTPS id b2935cdeee3e02eb;
	Fri, 21 Aug 2026 14:35:02 +0000
X-Mizu-Trace-ID: b2935cdeee3e02eb
X-Migadu-Flow: FLOW_OUT
Message-ID: <51d4f1ec-381d-4566-a1c8-96fd03e3520d@chenxiaosong.com>
Date: Fri, 21 Aug 2026 22:34:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ksmbd: zero the object ID before filling
 FS_OBJECT_ID_INFORMATION
To: Aleksandr Khromov <haa@amicon.ru>, linkinjeon@kernel.org,
 sfrench@samba.org
Cc: senozhatsky@chromium.org, tom@talpey.com, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, rrv@amicon.ru
References: <20260821135801.3790290-1-haa@amicon.ru>
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260821135801.3790290-1-haa@amicon.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Should we clear `info`? Will `info->extended_info.version_string` also leak?

```
7437         case FS_OBJECT_ID_INFORMATION:
7438         {
7439                 struct object_id_info *info;
7440
7441                 info = (struct object_id_info *)(rsp->Buffer);
...
7454                 memcpy(info->extended_info.version_string, "1.1.0", 
strlen("1.1.0"));
7455                 rsp->OutputBufferLength = cpu_to_le32(64);
...
7458         }
```

On 8/21/2026 9:58 PM, Aleksandr Khromov wrote:
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -6093,6 +6093,7 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>   
>   		info = (struct object_id_info *)(rsp->Buffer);
>   
> +		memset(info->objid, 0, sizeof(info->objid));
>   		if (path.mnt->mnt_sb->s_uuid_len == 16)
>   			memcpy(info->objid, path.mnt->mnt_sb->s_uuid.b,
>   					path.mnt->mnt_sb->s_uuid_len);

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

