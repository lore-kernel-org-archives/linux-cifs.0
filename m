Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0C58C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 03:23:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbiDMDZ5 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 12 Apr 2022 23:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiDMDZ4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 12 Apr 2022 23:25:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448452E097
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 20:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2C5161A6D
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 03:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32804C385AD
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 03:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649820216;
        bh=ZZ6sD3LcgQ4UQnuLILFUZP+1xY20ef7WvzKDro8i2jY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Qe+CSgRldsVgtUV+S0a+O23KZZJ6uIwsH3dikmdOpudSUy6SM9hZqDWZCEqAz/cEH
         QdVvlE/DDiv6+VkiCEXh48yCi5eDNTOs30ftm6Y9m0Z5qJEp3YMIlLMzhtUjh2qi2G
         sCOm+imHsgz6IqGshV2MemZFOKK/MvQ78Kzm8nJOEtOhsBoeMKEXj54ri1Zslk218u
         wYk/2vQ9upLh4WzMtUOlHpTVJDwUJoaab0V6m6v9wG+nUoEF3k90I9pFqDPNYGCSeM
         UGxmcAX/W8mOawtS1YSvtp9oUYoqNxxkYfP1cpCkI9m7FVT30qbxSpGJGtmkAxsUKD
         6zRXRZVFNBv+g==
Received: by mail-wr1-f51.google.com with SMTP id b19so684754wrh.11
        for <linux-cifs@vger.kernel.org>; Tue, 12 Apr 2022 20:23:36 -0700 (PDT)
X-Gm-Message-State: AOAM530OfSFa/zsaU3pTLI80/BlHXcNOqPrLJVY+zCv+o5bDricb2nc3
        kH6sRmxKRPQQFVcpLZ0bMBaOPOc+2+iyPpJ7vCw=
X-Google-Smtp-Source: ABdhPJwUKkmjbKgjSlE2BhssZHeMIHP0Hoapgy/Uqz5YqGestJ7iAvUVrVh8wO3rsy13Wd1bSInhxDgb+KdylMczBx4=
X-Received: by 2002:adf:eb07:0:b0:207:8534:2ef6 with SMTP id
 s7-20020adfeb07000000b0020785342ef6mr22924602wrn.62.1649820214376; Tue, 12
 Apr 2022 20:23:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64aa:0:0:0:0:0 with HTTP; Tue, 12 Apr 2022 20:23:33
 -0700 (PDT)
In-Reply-To: <d7771443-f935-357f-3606-c09920a2341f@talpey.com>
References: <20220412225806.5647-1-linkinjeon@kernel.org> <d7771443-f935-357f-3606-c09920a2341f@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 13 Apr 2022 12:23:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_Esmq__t6JCYCYT0rFS5EdrvUOtGitX-b9MV4ogg3dAw@mail.gmail.com>
Message-ID: <CAKYAXd_Esmq__t6JCYCYT0rFS5EdrvUOtGitX-b9MV4ogg3dAw@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-04-13 10:40 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 4/12/2022 6:58 PM, Namjae Jeon wrote:
>> Currently ksmbd is using ->f_bsize from vfs_statfs() as sector size.
>> If fat/exfat is a local share, ->f_bsize is a cluster size that is too
>> large to be used as a sector size. Sector sizes larger than 4K cause
>> problem occurs when mounting an iso file through windows client.
>>
>> The error message can be obtained using Mount-DiskImage command,
>>   the error is:
>> "Mount-DiskImage : The sector size of the physical disk on which the
>> virtual disk resides is not supported."
>>
>> This patch reports fixed sector size as 512B logical/4K physical to
>> windows client to avoid poking into the block device.
>>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>   fs/ksmbd/smb2pdu.c | 9 ++++-----
>>   1 file changed, 4 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 62cc0f95ab87..28ff7c058bc4 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -4998,12 +4998,11 @@ static int smb2_get_info_filesystem(struct
>> ksmbd_work *work,
>>
>>   		info = (struct smb3_fs_ss_info *)(rsp->Buffer);
>>
>> -		info->LogicalBytesPerSector = cpu_to_le32(stfs.f_bsize);
>> -		info->PhysicalBytesPerSectorForAtomicity =
>> -				cpu_to_le32(stfs.f_bsize);
>> -		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(stfs.f_bsize);
>> +		info->LogicalBytesPerSector = cpu_to_le32(512);
>> +		info->PhysicalBytesPerSectorForAtomicity = cpu_to_le32(4096);
>> +		info->PhysicalBytesPerSectorForPerf = cpu_to_le32(4096);
>>   		info->FSEffPhysicalBytesPerSectorForAtomicity =
>> -				cpu_to_le32(stfs.f_bsize);
>> +				cpu_to_le32(4096);
>
Hi Tom,
> So, this sounds like a great approach, much better than returning 128K.
Thanks:)
>
> However, it's not at all universally true that 4K is going to be atomic.
Could you please elaborate more ? Is the atomic size not 4K for 4K
native storage?

> And min(stfs.f_bsize, 4096) might be problematic too. Is there any better
> option??
There is no option than to poke into block layer, but Christoph
pointed out that this will also give the wrong answer for file systems
with multiple device support (btrfs, f2fs, xfs).
So we need to select fixed size as between 512B ~ 4KB. I think the v2
patch looks a bit better...

Thanks!
>
> Tom.
>
>
>>   		info->Flags = cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
>>   				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
>>   		info->ByteOffsetForSectorAlignment = 0;
>
