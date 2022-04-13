Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57B7C433FE
	for <linux-cifs@archiver.kernel.org>; Wed, 13 Apr 2022 14:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233309AbiDMOeL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 13 Apr 2022 10:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbiDMOeK (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 13 Apr 2022 10:34:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC215676A
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 07:31:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A05061BF5
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 14:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA89FC385A6
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 14:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649860307;
        bh=mQDlNHouaS+OGAVP+edObc6Ud+43ibWS+PAGJ3Qr7vY=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=K4uhMt93Oa1Raf8iE5TWDLXirXQEOxyaNSD/+OwAvXrFIMI0ciAulwjmM6IaFnjyy
         KxM1uX07D5aOYPoCnLjtETxPtrBCdO5lhPe4RaYqqSuRRzR1WSZJWrjPu21IzzkvAF
         0zQ26ytXQ801U52pms2WAfcP8n6/TQsdiZJ2YQwIJ5jM5NliDxM2Rr04qTsGELXj1g
         gLInSUME3hfAPNRKos5CjTvs96La9cgK6qO0JqKhsQ4suZ5B8Vrk9A0UlFh/Ps9+V2
         S0VITjJMGOWb8juf3Iv0aJOgg/FqrDXwGfgqEwshr/wKpMNAP9VFW7G5+yCdTLnI/F
         k06LCyJczAUqw==
Received: by mail-wr1-f51.google.com with SMTP id b19so2885644wrh.11
        for <linux-cifs@vger.kernel.org>; Wed, 13 Apr 2022 07:31:47 -0700 (PDT)
X-Gm-Message-State: AOAM531tlR4X3m47NJLHeswWHsFT1v6WGixnhH2+bjAKB5e96hbArNDE
        qJXVfwpH2w9kMyA8eDrcryi5NyXQIqo4gvwPN44=
X-Google-Smtp-Source: ABdhPJzpd7KnMKyHIPggzODR/ECCxmaYzQ9KsMQJM3olgPqt6ZZihU43/oCv7pDWDGVcWT7bgxCtFonFTK5X5jzAosY=
X-Received: by 2002:adf:eb07:0:b0:207:8534:2ef6 with SMTP id
 s7-20020adfeb07000000b0020785342ef6mr24789321wrn.62.1649860306158; Wed, 13
 Apr 2022 07:31:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:64aa:0:0:0:0:0 with HTTP; Wed, 13 Apr 2022 07:31:45
 -0700 (PDT)
In-Reply-To: <66e6f078-43d9-7e46-d6d3-767a5ac0a557@talpey.com>
References: <20220412225806.5647-1-linkinjeon@kernel.org> <d7771443-f935-357f-3606-c09920a2341f@talpey.com>
 <CAKYAXd_Esmq__t6JCYCYT0rFS5EdrvUOtGitX-b9MV4ogg3dAw@mail.gmail.com> <66e6f078-43d9-7e46-d6d3-767a5ac0a557@talpey.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 13 Apr 2022 23:31:45 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-nwujt17_X4-C=8hZ9C4ZRtUjfEuZyC_4saxFpSCgRxA@mail.gmail.com>
Message-ID: <CAKYAXd-nwujt17_X4-C=8hZ9C4ZRtUjfEuZyC_4saxFpSCgRxA@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: set fixed sector size to FS_SECTOR_SIZE_INFORMATION
To:     Tom Talpey <tom@talpey.com>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, hyc.lee@gmail.com,
        senozhatsky@chromium.org, Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-04-13 21:25 GMT+09:00, Tom Talpey <tom@talpey.com>:
> On 4/12/2022 11:23 PM, Namjae Jeon wrote:
>> 2022-04-13 10:40 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 4/12/2022 6:58 PM, Namjae Jeon wrote:
>>>> Currently ksmbd is using ->f_bsize from vfs_statfs() as sector size.
>>>> If fat/exfat is a local share, ->f_bsize is a cluster size that is too
>>>> large to be used as a sector size. Sector sizes larger than 4K cause
>>>> problem occurs when mounting an iso file through windows client.
>>>>
>>>> The error message can be obtained using Mount-DiskImage command,
>>>>    the error is:
>>>> "Mount-DiskImage : The sector size of the physical disk on which the
>>>> virtual disk resides is not supported."
>>>>
>>>> This patch reports fixed sector size as 512B logical/4K physical to
>>>> windows client to avoid poking into the block device.
>>>>
>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>>>> ---
>>>>    fs/ksmbd/smb2pdu.c | 9 ++++-----
>>>>    1 file changed, 4 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>>> index 62cc0f95ab87..28ff7c058bc4 100644
>>>> --- a/fs/ksmbd/smb2pdu.c
>>>> +++ b/fs/ksmbd/smb2pdu.c
>>>> @@ -4998,12 +4998,11 @@ static int smb2_get_info_filesystem(struct
>>>> ksmbd_work *work,
>>>>
>>>>    		info =3D (struct smb3_fs_ss_info *)(rsp->Buffer);
>>>>
>>>> -		info->LogicalBytesPerSector =3D cpu_to_le32(stfs.f_bsize);
>>>> -		info->PhysicalBytesPerSectorForAtomicity =3D
>>>> -				cpu_to_le32(stfs.f_bsize);
>>>> -		info->PhysicalBytesPerSectorForPerf =3D cpu_to_le32(stfs.f_bsize);
>>>> +		info->LogicalBytesPerSector =3D cpu_to_le32(512);
>>>> +		info->PhysicalBytesPerSectorForAtomicity =3D cpu_to_le32(4096);
>>>> +		info->PhysicalBytesPerSectorForPerf =3D cpu_to_le32(4096);
>>>>    		info->FSEffPhysicalBytesPerSectorForAtomicity =3D
>>>> -				cpu_to_le32(stfs.f_bsize);
>>>> +				cpu_to_le32(4096);
>>>
>> Hi Tom,
>>> So, this sounds like a great approach, much better than returning 128K.
>> Thanks:)
>>>
>>> However, it's not at all universally true that 4K is going to be atomic=
.
>> Could you please elaborate more ? Is the atomic size not 4K for 4K
>> native storage?
>
> Where is it guaranteed that the physical storage is 4K??
->s_blocksize will be set to 4K on 4K native.
If you check v2 patch, the sector size is set to min(->s_blocksize, 4096).

>
>>> And min(stfs.f_bsize, 4096) might be problematic too. Is there any
>>> better
>>> option??
>> There is no option than to poke into block layer, but Christoph
>> pointed out that this will also give the wrong answer for file systems
>> with multiple device support (btrfs, f2fs, xfs).
>
> And I agree. Did you read the discussion in MS-FSCC by the way?
>
>> A client can interpret this field as the unit for which NTFS guarantees =
an
>> atomic
>> operation. NTFS calculates the value of this field as follows:
>> =EF=82=A7 Retrieve the physical sector size the device reports for atomi=
city, and
>> store in x.
>> =EF=82=A7 Validate that the value x is greater than or equal to the logi=
cal sector
>> size. If it is not, set x to the
>> logical sector size.
>> =EF=82=A7 Validate that the value x is a power of two. If it is not, set=
 x to the
>> logical sector size.
>> =EF=82=A7 Validate that the value x is less than or equal to the system =
page size
>> defined in [MS-FSA] section
>> 2.1.1.1. If it is not, set x to the system page size defined in [MS-FSA]
>> section 2.1.1.1.
>
> That's just the Windows/NTFS approach, of course.
value x is ->s_blocksize in NTFS of linux kernel.

>
>> So we need to select fixed size as between 512B ~ 4KB. I think the v2
>> patch looks a bit better...
>
> "A bit better"? So what's the actual fix going to be?
I think that setting it to fixed logical 512B, physical 4K can report
the wrong sector size for 4K native storage. Because it has to be
logical 4K, physical 4K.
->s_blocksize is probably a good alternative, set 4K as the maximum
sector size for unusual ->s_blocksize like ZFS. Because I haven't seen
a device with hw sector size larger than 4K.

>
> Tom.
>
>> Thanks!
>>>
>>> Tom.
>>>
>>>
>>>>    		info->Flags =3D cpu_to_le32(SSINFO_FLAGS_ALIGNED_DEVICE |
>>>>    				    SSINFO_FLAGS_PARTITION_ALIGNED_ON_DEVICE);
>>>>    		info->ByteOffsetForSectorAlignment =3D 0;
>>>
>>
>
