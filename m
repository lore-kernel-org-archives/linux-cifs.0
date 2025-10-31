Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB582E6CDC
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 02:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761877928; cv=none; b=TsW2XfGJHiU3Ys+OAaCiCTpWdAaWJUGGqNlsmYGJDQ+klMw+P+6XawGQHsz2pXsPzM6K3p9p0I1YfqXPxfumCnrUv4dqBtSBR6gYkeSo1KGg2mME4DXU4PKdMp5bu+pE0MP/Jo1TwFZmtj8s6ZHUrU9G+DFAbF2MzdCML6xEkEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761877928; c=relaxed/simple;
	bh=dQyxJ1d91572THsFTNh3JwQBfOdXBE8nxpCAVZ8Hy84=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CX/8Hnwj6gSsgeVfEJuUe53hoHGrTWeAj5ckQgTF1ucXGve6RE/vTmWJ8yKk7plgvu2RaNXuPpAZKDvn2KT+Wi33Pp0b0lMhbobqCGN4LwI41xQrxJTHuSBJGZzE+MMljQ3FUaQzCE8nQOUzo3cmmdw/bQyummVKGMcnEiGsZvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AZCR+5QV; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AZCR+5QV"
Message-ID: <d1835c8a-f354-498f-a8c3-f43d7bb62548@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761877918;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZReHVNJ6NA73HQEk8o4tY+Q+SuvKfISP0Quo375SkgY=;
	b=AZCR+5QVtdA1uEk82UZAlFWEBpeZaevkicPkVBjsSuLvCGWvXTRLoOpqtSnhftpdTwFrm2
	chvqN7wmDGnf8ci9bIODkTPKgAzYAeA8VfNO4F4oLxaPdtb4SjCKrkQ4fmHHGOeVaPNYqE
	dy9DEzTiaI2pAChplDUNFXmg0lqs8ck=
Date: Fri, 31 Oct 2025 10:31:04 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v4 15/24] smb: move FILE_SYSTEM_POSIX_INFO to
 common/smb1pdu.h
To: Steve French <smfrench@gmail.com>, =?UTF-8?Q?Ralph_B=C3=B6hme?=
 <slow@samba.org>
Cc: sfrench@samba.org, linkinjeon@kernel.org, linkinjeon@samba.org,
 christophe.jaillet@wanadoo.fr, linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251027071316.3468472-1-chenxiaosong.chenxiaosong@linux.dev>
 <20251027072206.3468578-1-chenxiaosong.chenxiaosong@linux.dev>
 <a0d97e2d-91f5-448c-883c-4d0930375f82@linux.dev>
 <CAH2r5mtHXDuKUSvZ5TZU1f6WnQaH5Dz59=z29ABJsOYmric+1Q@mail.gmail.com>
 <CAH2r5muwP4uyELKDNrRGU+8YgwNurb1+jQb+5CYOcU74LZhj3w@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <CAH2r5muwP4uyELKDNrRGU+8YgwNurb1+jQb+5CYOcU74LZhj3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This GitLab repository seems to be more up to date than the one on 
samba.org: https://git.samba.org/?p=slow/smb3_posix_spec.git;a=shortlog

Thanks,
ChenXiaoSong.

在 2025/10/31 09:53, Steve French 写道:
> Sorry forgot to attach the link
> 
> https://gitlab.com/samba-team/smb3-posix-spec
> 
> On Thu, Oct 30, 2025 at 8:53 PM Steve French <smfrench@gmail.com> wrote:
>>
>> Ralph,
>> Is this link current? or do you have the link to a more current
>> version of the POSIX extensions documentation?
>>
>> On Thu, Oct 30, 2025 at 8:42 PM ChenXiaoSong
>> <chenxiaosong.chenxiaosong@linux.dev> wrote:
>>>
>>> Hi Namjae and Steve,
>>>
>>> I couldn’t find the definition of FILE_SYSTEM_POSIX_INFO in any of the
>>> following MS documents:
>>>
>>>     - MS-FSCC:
>>> https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-fscc%2Ftoc.json
>>>     - MS-CIFS:
>>> https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-cifs%2Ftoc.json
>>>     - MS-SMB:
>>> https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb%2Ftoc.json
>>>     - MS-SMB2:
>>> https://learn.microsoft.com/pdf?url=https%3A%2F%2Flearn.microsoft.com%2Fen-us%2Fopenspecs%2Fwindows_protocols%2Fms-smb2%2Ftoc.json
>>>
>>> Is this structure defined in other MS document?
>>>
>>> On 10/27/25 3:21 PM, chenxiaosong.chenxiaosong@linux.dev wrote:
>>>> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>>
>>>> Rename "struct filesystem_posix_info" to "FILE_SYSTEM_POSIX_INFO",
>>>> then move duplicate definitions to common header file.
>>>>
>>>> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>>>> ---
>>>>    fs/smb/client/cifspdu.h    | 22 ----------------------
>>>>    fs/smb/common/smb1pdu.h    | 23 +++++++++++++++++++++++
>>>>    fs/smb/server/smb2pdu.c    |  4 ++--
>>>>    fs/smb/server/smb_common.h | 23 -----------------------
>>>>    4 files changed, 25 insertions(+), 47 deletions(-)
>>>>
>>>> diff --git a/fs/smb/client/cifspdu.h b/fs/smb/client/cifspdu.h
>>>> index d106c6850807..55aaae6dbc86 100644
>>>> --- a/fs/smb/client/cifspdu.h
>>>> +++ b/fs/smb/client/cifspdu.h
>>>> @@ -1875,28 +1875,6 @@ typedef struct {
>>>>
>>>>    #define CIFS_POSIX_EXTENSIONS           0x00000010 /* support for new QFSInfo */
>>>>
>>>> -typedef struct {
>>>> -     /* For undefined recommended transfer size return -1 in that field */
>>>> -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
>>>> -     __le32 BlockSize;
>>>> -    /* The next three fields are in terms of the block size.
>>>> -     (above). If block size is unknown, 4096 would be a
>>>> -     reasonable block size for a server to report.
>>>> -     Note that returning the blocks/blocksavail removes need
>>>> -     to make a second call (to QFSInfo level 0x103 to get this info.
>>>> -     UserBlockAvail is typically less than or equal to BlocksAvail,
>>>> -     if no distinction is made return the same value in each */
>>>> -     __le64 TotalBlocks;
>>>> -     __le64 BlocksAvail;       /* bfree */
>>>> -     __le64 UserBlocksAvail;   /* bavail */
>>>> -    /* For undefined Node fields or FSID return -1 */
>>>> -     __le64 TotalFileNodes;
>>>> -     __le64 FreeFileNodes;
>>>> -     __le64 FileSysIdentifier;   /* fsid */
>>>> -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
>>>> -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
>>>> -} __attribute__((packed)) FILE_SYSTEM_POSIX_INFO;
>>>> -
>>>>    /* DeviceType Flags */
>>>>    #define FILE_DEVICE_CD_ROM              0x00000002
>>>>    #define FILE_DEVICE_CD_ROM_FILE_SYSTEM  0x00000003
>>>> diff --git a/fs/smb/common/smb1pdu.h b/fs/smb/common/smb1pdu.h
>>>> index 82331a8f70e8..38b9c091baab 100644
>>>> --- a/fs/smb/common/smb1pdu.h
>>>> +++ b/fs/smb/common/smb1pdu.h
>>>> @@ -327,6 +327,29 @@ typedef struct {
>>>>        __le32 BytesPerSector;
>>>>    } __packed FILE_SYSTEM_INFO;        /* size info, level 0x103 */
>>>>
>>>> +typedef struct {
>>>> +     /* For undefined recommended transfer size return -1 in that field */
>>>> +     __le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
>>>> +     __le32 BlockSize;
>>>> +     /* The next three fields are in terms of the block size.
>>>> +      * (above). If block size is unknown, 4096 would be a
>>>> +      * reasonable block size for a server to report.
>>>> +      * Note that returning the blocks/blocksavail removes need
>>>> +      * to make a second call (to QFSInfo level 0x103 to get this info.
>>>> +      * UserBlockAvail is typically less than or equal to BlocksAvail,
>>>> +      * if no distinction is made return the same value in each
>>>> +      */
>>>> +     __le64 TotalBlocks;
>>>> +     __le64 BlocksAvail;       /* bfree */
>>>> +     __le64 UserBlocksAvail;   /* bavail */
>>>> +     /* For undefined Node fields or FSID return -1 */
>>>> +     __le64 TotalFileNodes;
>>>> +     __le64 FreeFileNodes;
>>>> +     __le64 FileSysIdentifier;   /* fsid */
>>>> +     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
>>>> +     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
>>>> +} __packed FILE_SYSTEM_POSIX_INFO;
>>>> +
>>>>    /* See MS-CIFS 2.2.8.2.5 */
>>>>    typedef struct {
>>>>        __le32 DeviceType;
>>>> diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
>>>> index 47fab72a3588..dc0f0ed4ccb6 100644
>>>> --- a/fs/smb/server/smb2pdu.c
>>>> +++ b/fs/smb/server/smb2pdu.c
>>>> @@ -5633,14 +5633,14 @@ static int smb2_get_info_filesystem(struct ksmbd_work *work,
>>>>        }
>>>>        case FS_POSIX_INFORMATION:
>>>>        {
>>>> -             struct filesystem_posix_info *info;
>>>> +             FILE_SYSTEM_POSIX_INFO *info;
>>>>
>>>>                if (!work->tcon->posix_extensions) {
>>>>                        pr_err("client doesn't negotiate with SMB3.1.1 POSIX Extensions\n");
>>>>                        path_put(&path);
>>>>                        return -EOPNOTSUPP;
>>>>                } else {
>>>> -                     info = (struct filesystem_posix_info *)(rsp->Buffer);
>>>> +                     info = (FILE_SYSTEM_POSIX_INFO *)(rsp->Buffer);
>>>>                        info->OptimalTransferSize = cpu_to_le32(stfs.f_bsize);
>>>>                        info->BlockSize = cpu_to_le32(stfs.f_bsize);
>>>>                        info->TotalBlocks = cpu_to_le64(stfs.f_blocks);
>>>> diff --git a/fs/smb/server/smb_common.h b/fs/smb/server/smb_common.h
>>>> index 6141ca8f7e1c..61048568f4c7 100644
>>>> --- a/fs/smb/server/smb_common.h
>>>> +++ b/fs/smb/server/smb_common.h
>>>> @@ -108,29 +108,6 @@ struct file_id_both_directory_info {
>>>>        char FileName[];
>>>>    } __packed;
>>>>
>>>> -struct filesystem_posix_info {
>>>> -     /* For undefined recommended transfer size return -1 in that field */
>>>> -     __le32 OptimalTransferSize;  /* bsize on some os, iosize on other os */
>>>> -     __le32 BlockSize;
>>>> -     /* The next three fields are in terms of the block size.
>>>> -      * (above). If block size is unknown, 4096 would be a
>>>> -      * reasonable block size for a server to report.
>>>> -      * Note that returning the blocks/blocksavail removes need
>>>> -      * to make a second call (to QFSInfo level 0x103 to get this info.
>>>> -      * UserBlockAvail is typically less than or equal to BlocksAvail,
>>>> -      * if no distinction is made return the same value in each
>>>> -      */
>>>> -     __le64 TotalBlocks;
>>>> -     __le64 BlocksAvail;       /* bfree */
>>>> -     __le64 UserBlocksAvail;   /* bavail */
>>>> -     /* For undefined Node fields or FSID return -1 */
>>>> -     __le64 TotalFileNodes;
>>>> -     __le64 FreeFileNodes;
>>>> -     __le64 FileSysIdentifier;   /* fsid */
>>>> -     /* NB Namelen comes from FILE_SYSTEM_ATTRIBUTE_INFO call */
>>>> -     /* NB flags can come from FILE_SYSTEM_DEVICE_INFO call   */
>>>> -} __packed;
>>>> -
>>>>    struct smb_version_ops {
>>>>        u16 (*get_cmd_val)(struct ksmbd_work *swork);
>>>>        int (*init_rsp_hdr)(struct ksmbd_work *swork);
>>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
> 
> 
> 

