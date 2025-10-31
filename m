Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0824C9D
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 01:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761874940; cv=none; b=QvbQWzKF4z6pe/z6ww4y/G1RhbR27y51uBeKjY9Ngt9bo+mumX600cJKBUHoNkS3rIzOSzqCjPOO+zq+ozKy/4u3B32Ve1nde5xiOglUhLiD1mksBKcO8LVNLnXFqA9VLJhkTK1lxTOpeyZA1Rj7r4n3TiqNzb4GKdhIB/rpTDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761874940; c=relaxed/simple;
	bh=NdF/5rJM0j5OPWw44GZANVRkOgMlktUfwzO+La+5zHQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iX0GvhiTYKKeY9cy6N1sZkTDTpku8RPHZOddT9Wt2K90XNqWNTm4luvSJCXcYshP7WtOtVyJNpzS3DNJmCPcv3kWUjDHwi0Y9E8F0oP7bK4d7lpi/cfvh41KYKH4UVerCN1eebC7KOFUzT9bCwckw66mPF+p5gqZYRMTuM5n0nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UPHEqcW+; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UPHEqcW+"
Message-ID: <a0d97e2d-91f5-448c-883c-4d0930375f82@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761874925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GCYrDBcE+YrmiGBoOlXRYwdmc8Z2PMQgBrg8K27fepM=;
	b=UPHEqcW+IxkoJpImSx3ZDl83BQDa0VpwRS5cOBOket+1geFYsKMMqLiKLmYr1ZjIkNSWte
	mX5s4p28m+HjYkcXHIS5rFoUQKcmOhY+Wid1ejPes2utKXC7NX4vqwrqraXQ6UuN2xuc0m
	TpZl4+OzAIfqOOyO9hZGN04Eok9CiEo=
Date: Fri, 31 Oct 2025 09:41:20 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 15/24] smb: move FILE_SYSTEM_POSIX_INFO to
 common/smb1pdu.h
To: chenxiaosong.chenxiaosong@linux.dev, sfrench@samba.org,
 smfrench@gmail.com, linkinjeon@kernel.org, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027072206.3468578-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251027072206.3468578-1-chenxiaosong.chenxiaosong@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Hi Namjae and Steve,

I couldn’t find the definition of FILE_SYSTEM_POSIX_INFO in any of the 
following MS documents:

   - MS-FSCC: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-fscc%2Ftoc.json
   - MS-CIFS: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-cifs%2Ftoc.json
   - MS-SMB: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb%2Ftoc.json
   - MS-SMB2: 
https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb2%2Ftoc.json

Is this structure defined in other MS document?

On 10/27/25 3:21 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
> 
> Rename "struct filesystem_posix_info" to "FILE_SYSTEM_POSIX_INFO",
> then move duplicate definitions to common header file.
> 
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
> ---
>   fs/smb/client/cifspdu.h    | 22 ----------------------
>   fs/smb/common/smb1pdu.h    | 23 +++++++++++++++++++++++
>   fs/smb/server/smb2pdu.c    |  4 ++--
>   fs/smb/server/smb_common.h | 23 -----------------------
>   4 files changed, 25 insertions(+), 47 deletions(-)
> 
> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
> index d106c6850807..55aaae6dbc86 100644
> --- a/fs/smb/client/cifspdu.h
> +++ b/fs/smb/client/cifspdu.h
> @@ -1875,28 +1875,6 @@ typedef struct {
>   
>   #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for new QFSInfo */
>   
> -typedef struct {
> -	/* For undefined recommended transfer size return -1 in that field */
> -	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
> -	__le32 BlockSize;
> -    /* The next three fields are in terms of the block size.
> -	(above). If block size is unknown, 4096 would be a
> -	reasonable block size for a server to report.
> -	Note that returning the blocks/blocksavail removes need
> -	to make a second call (to QFSInfo level 0x103 to get this info.
> -	UserBlockAvail is typically less than or equal to BlocksAvail,
> -	if no distinction is made return the same value in each */
> -	__le64 TotalBlocks;
> -	__le64 BlocksAvail;       /* bfree */
> -	__le64 UserBlocksAvail;   /* bavail */
> -    /* For undefined Node fields or FSID return -1 */
> -	__le64 TotalFileNodes;
> -	__le64 FreeFileNodes;
> -	__le64 FileSysIdentifier;   /* fsid */
> -	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> -	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> -} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
> -
>   /* DeviceType Flags */
>   #define FILE_DEVICE_CD_ROM              0x00000002
>   #define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
> index 82331a8f70e8..38b9c091baab 100644
> --- a/fs/smb/common/smb1pdu.h
> +++ b/fs/smb/common/smb1pdu.h
> @@ -327,6 +327,29 @@ typedef struct {
>   	__le32 BytesPerSector;
>   } __packed FILE_SYSTEM_INFO;	/* size info, level 0x103 */
>   
> +typedef struct {
> +	/* For undefined recommended transfer size return -1 in that field */
> +	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
> +	__le32 BlockSize;
> +	/* The next three fields are in terms of the block size.
> +	 * (above). If block size is unknown, 4096 would be a
> +	 * reasonable block size for a server to report.
> +	 * Note that returning the blocks/blocksavail removes need
> +	 * to make a second call (to QFSInfo level 0x103 to get this info.
> +	 * UserBlockAvail is typically less than or equal to BlocksAvail,
> +	 * if no distinction is made return the same value in each
> +	 */
> +	__le64 TotalBlocks;
> +	__le64 BlocksAvail;       /* bfree */
> +	__le64 UserBlocksAvail;   /* bavail */
> +	/* For undefined Node fields or FSID return -1 */
> +	__le64 TotalFileNodes;
> +	__le64 FreeFileNodes;
> +	__le64 FileSysIdentifier;   /* fsid */
> +	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> +	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> +} __packed FILE_SYSTEM_POSIX_INFO;
> +
>   /* See MS-CIFS 2.2.8.2.5 */
>   typedef struct {
>   	__le32 DeviceType;
> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
> index 47fab72a3588..dc0f0ed4ccb6 100644
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -5633,14 +5633,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>   	}
>   	case FS_POSIX_INFORMATION:
>   	{
> -		struct filesystem_posix_info *info;
> +		FILE_SYSTEM_POSIX_INFO *info;
>   
>   		if (!work->tcon->posix_extensions) {
>   			pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
>   			path_put(&path);
>   			return -EOPNOTSUPP;
>   		} else {
> -			info = (struct filesystem_posix_info *)(rsp->Buffer);
> +			info = (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
>   			info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
>   			info->BlockSize = cpu_to_le32(stfs.f_bsize);
>   			info->TotalBlocks = cpu_to_le64(stfs.f_blocks);
> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
> index 6141ca8f7e1c..61048568f4c7 100644
> --- a/fs/smb/server/smb_common.h
> +++ b/fs/smb/server/smb_common.h
> @@ -108,29 +108,6 @@ struct file_id_both_directory_info {
>   	char FileName[];
>   } __packed;
>   
> -struct filesystem_posix_info {
> -	/* For undefined recommended transfer size return -1 in that field */
> -	__le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
> -	__le32 BlockSize;
> -	/* The next three fields are in terms of the block size.
> -	 * (above). If block size is unknown, 4096 would be a
> -	 * reasonable block size for a server to report.
> -	 * Note that returning the blocks/blocksavail removes need
> -	 * to make a second call (to QFSInfo level 0x103 to get this info.
> -	 * UserBlockAvail is typically less than or equal to BlocksAvail,
> -	 * if no distinction is made return the same value in each
> -	 */
> -	__le64 TotalBlocks;
> -	__le64 BlocksAvail;       /* bfree */
> -	__le64 UserBlocksAvail;   /* bavail */
> -	/* For undefined Node fields or FSID return -1 */
> -	__le64 TotalFileNodes;
> -	__le64 FreeFileNodes;
> -	__le64 FileSysIdentifier;   /* fsid */
> -	/* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
> -	/* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
> -} __packed;
> -
>   struct smb_version_ops {
>   	u16 (*get_cmd_val)(struct ksmbd_work *swork);
>   	int (*init_rsp_hdr)(struct ksmbd_work *swork);

