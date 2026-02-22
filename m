Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531E91E7C03
	for <linux-cifs@vger.kernel.org>; Sun, 22 Feb 2026 15:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771773990; cv=none; b=aS2eIwxRDfZVD9dilocpnyR9/KQbDm1FnxfbU2HW6ULO1+LI9vI/BgpKvocu5exZVEbXBWSwoEfxrQl7ZXOE73PRinF0Hq/pvNET0AxWaLKl3/3IiepaBKmux/BwW0eYntP7br80mNOjc2IO/wkxfCPTn8g8U/FJrVl50Y4etUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771773990; c=relaxed/simple;
	bh=yncgU8v/ODnGI4L6Pj6IddrbJDF1Ty+AAigKvOvgaOU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gzUN9mc8LTlfBGm6CGpB8jnhaF9NQFDK1wLsgyAOjFuhHCN7lSlWlVJayWBInbH2bc4jZHbKVr2ZGlux9OlYAgvSVpOAS9yw2lvIQ8JPCiDmiVjDRgguOTLw0lyDZsYaksktBojk1joKY8CvlMdqCZ47o11WHXrMw6Kp2yC6XbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=VRGMhveG; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="VRGMhveG"
Message-ID: <2b43ccf3-9b2b-4f9a-8cbf-4213b0cdc484@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1771773984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bs1T1utWZULGQhGcOdN4Gb6wDvkZ88NgeMhyhgjZjJc=;
	b=VRGMhveGrIwSVYlmHEUMqmAq3dG6BJn6rcjm7sHOjKIuUPJw/bLUVigjwn1vorOlO7gOSB
	Rl9tFnziaFFRcKmbEcl5CMf+aQj/4YR11AxXEOehcSWM7em5sd51024QrdU1204f74NCOp
	TFjzHpuzq+/ry/jjK09iBZeo8TPYYthtLK9YjZiWP5z8P9hqAhjqBOun3qPyMrj7QE5Uz5
	FH3mMN6SMI63Xkfco1YU0j78EGL+iwzStoys9tvy1+S+0iHjuG4zzAXMGCYwYneJ8VY+Wi
	p14dqWqeqJK5NesLh7u3/RY0/1tGgyIZKOYFawqrOxgFjCt5LgLn+c7PdM/HQQ==
Date: Sun, 22 Feb 2026 23:26:03 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 0/5] smb: move duplicate definitions into common header
 file, part 2
To: Namjae Jeon <linkinjeon@kernel.org>, smfrench@gmail.com,
 zhang.guodong@linux.dev
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, chenxiaosong@kylinos.cn, linux-cifs@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>
References: <20260216082018.156695-1-zhang.guodong@linux.dev>
 <CAKYAXd_MuUe9R4vnkmGEkWxG7endJFqGDiEprLcvgJDixakX2A@mail.gmail.com>
 <5481d68d-9864-457c-9589-3bfd4cb6a54d@chenxiaosong.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <5481d68d-9864-457c-9589-3bfd4cb6a54d@chenxiaosong.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

`num_subauth` is incremented by 1 at the end of `id_to_sid()`, so the 
code is correct.

Thanks,
ChenXiaoSong <chenxiaosong@chenxiaosong.com>

On 2026/2/22 15:39, ChenXiaoSong wrote:
> Hi Namjae and Steve,
> 
> In server-side create_posix_rsp_buf(), there is the following comment:
> 
>   * SidBuffer(44) contain two sids(Domain sid(28), UNIX group sid(16)).
>   * Domain sid(28) = revision(1) + num_subauth(1) + authority(6) +
>   *                  sub_auth(4 * 4(num_subauth)) + RID(4).
>   * UNIX group id(16) = revision(1) + num_subauth(1) + authority(6) +
>   *                     sub_auth(4 * 1(num_subauth)) + RID(4).
> 
> However, according to the SID description in the link below (Link[1]), 
> the relative identifier (RID) seems to be the last subauth item 
> (consistent with the client-side posix_info_sid_size()). Should we 
> remove RID(4)? Please let me know if my understanding is incorrect.
> 
> Link[1]: 
> https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-security-identifiers#sid-architecture
> 
> Thanks,
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> On 2026/2/20 09:27, Namjae Jeon wrote:
>>> ZhangGuoDong (5):
>>>    smb: move smb3_fs_vol_info into common/fscc.h
>>>    smb: move some definitions from common/smb2pdu.h into common/fscc.h
>>>    smb: move file_basic_info into common/fscc.h
>>>    smb: introduce struct create_posix_ctxt_rsp
>>>    smb: introduce struct file_posix_info
>> For patches 0004 and 0005, please move the complete definition to the
>> common header instead of a partial split. So we should also use a
>> flexible array member for this, and ensure that all related code is
>> updated to handle the flexible array correctly.
>> Thanks.
