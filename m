Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403D1200110
	for <linux-cifs@vger.kernel.org>; Wed, 10 Dec 2025 04:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765341273; cv=none; b=Nl6pHUjb7m4K6gCl44Ai45A4nmnT+ew7vMdS90/bTmNhkZmuMKLSev/OMds3Y2s6OH1Ex33hHXRVyjXoMt6UHOpAm80oPMt4r/IWmOe2bArkEXzSi5y2ijpSsGQsmqE6gj/gpQjj4VgEkHIysiD5DnhJnSWCKHib2VG6ICbozzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765341273; c=relaxed/simple;
	bh=NOpPfac8HllyOEfDMlVJ0O9I3GTIt7fwPUP90o86SHY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sOS9fw/0pDnU7xpFsXKYUOEWz+9l8pWHcxsZRfBmgxyS9HPdHQpPU7R+3k/rD1swqTqCM26YNg7sxOq6Yd8ZKbP1+IQW2bdecNWzqVXS13VFsm9aiykdYZhqx1rS1SvBldBzqSJ6sYAgU78Xrh7dBAk1SfX133Tf4muRp7c/Xtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=v/wcJCxl; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="v/wcJCxl"
Message-ID: <88f9bfb3-4f8e-4ddc-9fb5-fcd12c9c93dc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765341268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7kItuku8GNZDhTk0LtpWkpM5IYZfAbW+9v0Ie8AyYIY=;
	b=v/wcJCxlHGfCHbPlD5P+ccW8H2t/qgohfZzzZPuJTVCtklzRc2uNMdeIY25tb9I4lnjaZG
	zKndkKN8ja/BnlFhOQv4h8W1HtsSFCpEuA+Nh7sHiqsMaeB8xm3ZtHEJL62yrP59BuvdaP
	c1b8pwVFIqBUNMHMUbdDwTx9Lykblc8=
Date: Wed, 10 Dec 2025 12:34:22 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 00/13 smb: move duplicate definitions into common header
 file, part 2
To: sfrench@samba.org, smfrench@gmail.com, linkinjeon@kernel.org,
 linkinjeon@samba.org
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
 liuzhengyuan@kylinos.cn, huhai@kylinos.cn, liuyun01@kylinos.cn
References: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251209011020.3270989-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Steve and Namjae,

I have tested all patches using KUnit tests, xfstests, and smbtorture, 
and no additional test failures were observed. The detailed test results 
can be found in: https://chenxiaosong.com/en/smb-test-20251210.html

For more detailed information about the patches to be reviewed, please 
see the link: https://chenxiaosong.com/en/smb-patch.html

Thanks,
ChenXiaoSong.

On 12/9/25 09:10, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> I'm currently working on implementing the SMB2 change notify feature in
> ksmbd, and noticed several duplicated definitions that exist on both client
> and server. Maybe we can clean these up first.
> 
> This is a continuous effort to move duplicated definitions in both client
> and server into common header files, which makes the code easier to
> maintain.
> 
> The previous work is here:
> https://lore.kernel.org/linux-cifs/20251117112838.473051-1-chenxiaosong.chenxiaosong@linux.dev/
> 
> ChenXiaoSong (7):
>    smb: add documentation references for smb2 change notify definitions
>    smb: move notify completion filter flags into common/smb2pdu.h
>    smb: move SMB2 Notify Action Flags into common/smb2pdu.h
>    smb: move file_notify_information to common/fscc.h
>    smb: move File Attributes definitions into common/fscc.h
>    smb: update struct duplicate_extents_to_file_ex
>    smb/server: add comment to FileSystemName of
>      FileFsAttributeInformation
> 
> ZhangGuoDong (6):
>    smb: move smb3_fs_vol_info into common/fscc.h
>    smb: move some definitions from common/smb2pdu.h into common/fscc.h
>    smb/client: remove DeviceType Flags and Device Characteristics
>      definitions
>    smb: introduce struct create_posix_ctxt_rsp
>    smb: introduce struct file_posix_info
>    smb: move some SMB1 definitions into common/smb1pdu.h
> 
>   fs/smb/client/cifspdu.h    |  67 +-----
>   fs/smb/client/inode.c      |  22 +-
>   fs/smb/client/readdir.c    |  28 +--
>   fs/smb/client/reparse.h    |   4 +-
>   fs/smb/client/smb2pdu.c    |   9 +-
>   fs/smb/client/smb2pdu.h    |  21 +-
>   fs/smb/common/fscc.h       | 419 ++++++++++++++++++++++++++++++++++-
>   fs/smb/common/smb1pdu.h    |  59 +++++
>   fs/smb/common/smb2pdu.h    | 433 ++-----------------------------------
>   fs/smb/common/smbglob.h    |   2 -
>   fs/smb/server/oplock.c     |   8 +-
>   fs/smb/server/smb2pdu.c    |  91 ++++----
>   fs/smb/server/smb2pdu.h    |  27 +--
>   fs/smb/server/smb_common.h |   9 +-
>   14 files changed, 589 insertions(+), 610 deletions(-)
>   create mode 100644 fs/smb/common/smb1pdu.h
> 

