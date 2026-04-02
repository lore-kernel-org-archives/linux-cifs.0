Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2ED3C1418
	for <linux-cifs@vger.kernel.org>; Thu,  2 Apr 2026 08:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775119166; cv=none; b=QS5GyBPzYc70ePv1OTQr4zFen+NV2MnV7F5tpyFBVRawXBRQ0JPxE8dHov9DTHCEnUL8qS8g6lq6iImR6glJtOEtII745k6iMdKhz1htNmwX4MLZOSbqYqc8G0ilIXH8nbYc/9HXkCldlh8SP0IjQqrhB2ph7cnSr/zA+rbUMLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775119166; c=relaxed/simple;
	bh=jeqPbCJFq6E4/uAZmZs1vzk0bbhVf9kD1rh5mmSVlps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rOxc86DdhxI2ejLtTz8Vxve6sUSO6RQ9r0XZg/xcyGDnzbKoT+/1AD6PtLnRGDanC3OFMRbK6Mmry8niRmoc5tsbEOkP6/QCK+BGtFsvj5ltW6/r82pAN8qU6AsdG0tLaC9NC70kV9GgvLeoG2hqyNPfbZrOEoAa6CJl12yqTuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=JXaTk9jA; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="JXaTk9jA"
Message-ID: <3e974a68-628d-48da-9f1b-6feb02bc2a97@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1775119160;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4u0f0Yyy1YsqRBmgdOsjnJVlBZKOA9OXxW8TfnAXZhA=;
	b=JXaTk9jAHg/cU5pX66jr92IQ2w5CqFfnzD3nOuOs2uX3tGuNM31rFKhANFDeG42r3VxROA
	gPtmyOYshhnhBI2camseRgDC3AbBUSD2u1HP4ljbipjTY36qSKYpX7Sdmuwt5M9eVPTG0P
	KpRbFXWUN1z0XjwSPW4sAT8SL+Pf5+NOvt3aXGteyBvTnFV0+SsCeHYz885TixcZCQhy7e
	5Bb+i89Fs6anRCaDBizT8JE+6IPUyr4QVvM8SnYNu/TAj6bEx7a8GoWK+eqwEWgS7yJ6LX
	IoyDYLXunoPvzKGefcnJEKtdySnEBU6fAN0357ptk3XnBTZ8QoEGIakKNCFw9A==
Date: Thu, 2 Apr 2026 16:38:28 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 00/12] smb: improve search speed of SMB1 maperror
To: huiwen.he@linux.dev, smfrench@gmail.com, linkinjeon@kernel.org,
 pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com,
 tom@talpey.com, bharathsm@microsoft.com, senozhatsky@chromium.org,
 dhowells@redhat.com, chenxiaosong@kylinos.cn, tangyouling@kylinos.cn
Cc: linux-cifs@vger.kernel.org, Huiwen He <hehuiwen@kylinos.cn>
References: <20260401072912.355072-1-huiwen.he@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260401072912.355072-1-huiwen.he@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Huiwen and Youling,

I wrote some additional temporary test cases (not intended to be merged):
https://chenxiaosong.com/en/smb1maperror-test.html

These test cases copy the three arrays from before the patchset and 
compare them with those after the patchset. The test cases failed, 
please fix them.

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 4/1/26 15:29, huiwen.he@linux.dev wrote:
> From: Huiwen He <hehuiwen@kylinos.cn>
> 
> v1->v2:
>    - Sort arrays at build time
>    - Merge nt_errs to ntstatus_to_dos_map
>    - Check if arrays are sorted in smb1_init_maperror()
> 
> v1: https://lore.kernel.org/linux-cifs/20251208062100.3268777-1-chenxiaosong.chenxiaosong@linux.dev/
> 
> When searching for the last element, the comparison counts are shown in the table below:
> 
> +--------------------+--------+--------+
> |                    |Before  |After   |
> |                    |Patchset|Patchset|
> +--------------------+--------+--------+
> | ntstatus_to_dos_map|   533  |    9    |
> +--------------------+--------+--------+
> |mapping_table_ERRDOS|    34  |    5   |
> +--------------------+--------+--------+
> |mapping_table_ERRSRV|    37  |    5   |
> +--------------------+--------+--------+
> 
> The following patches from v1 have already been merged into the mainline:
>    - a71a4aab4834 smb/client: add parentheses to NT error code definitions containing bitwise OR operator
>    - a9adafd40165 smb/client: add 4 NT error code definitions
>    - 98def4eb0244 smb/server: remove unused nterr.h
>    - 9f99caa8950a smb/client: fix NT_STATUS_UNABLE_TO_FREE_VM value
>    - b2b50fca34da smb/client: fix NT_STATUS_DEVICE_DOOR_OPEN value
>    - a1237c203f17 smb/client: fix NT_STATUS_NO_DATA_DETECTED value
> 
> Huiwen He (8):
>    smb/client: annotate nterr.h with DOS error codes
>    smb/client: autogenerate SMB1 NT status to DOS error mapping
>    smb/client: replace nt_errs with ntstatus_to_dos_map
>    smb/client: refactor ntstatus_to_dos() to return mapping entry
>    smb/client: use binary search for NT status to DOS mapping
>    smb/client: annotate smberr.h with POSIX error codes
>    smb/client: autogenerate SMB1 DOS/SRV to POSIX error mapping
>    smb/client: use binary search for SMB1 DOS/SRV error mapping
> 
> Youling Tang (4):
>    smb/client: check if ntstatus_to_dos_map is sorted
>    smb/client: introduce KUnit test to check ntstatus_to_dos_map search
>    smb/client: check if SMB1 DOS/SRV error mapping arrays are sorted
>    smb/client: introduce KUnit tests to check DOS/SRV err mapping search
> 
>   fs/smb/client/.gitignore          |    3 +
>   fs/smb/client/Kconfig             |   11 +
>   fs/smb/client/Makefile            |   25 +-
>   fs/smb/client/cifsfs.c            |    6 +
>   fs/smb/client/gen_smb1_mapping    |  109 +++
>   fs/smb/client/nterr.c             |  704 -------------------
>   fs/smb/client/nterr.h             | 1082 +++++++++++++++--------------
>   fs/smb/client/smb1maperror.c      |  873 +++++------------------
>   fs/smb/client/smb1maperror_test.c |   83 +++
>   fs/smb/client/smb1proto.h         |    9 +
>   fs/smb/client/smberr.h            |  415 +++++++----
>   11 files changed, 1232 insertions(+), 2088 deletions(-)
>   create mode 100644 fs/smb/client/gen_smb1_mapping
>   delete mode 100644 fs/smb/client/nterr.c
>   create mode 100644 fs/smb/client/smb1maperror_test.c
> 

