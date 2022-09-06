Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 468CCECAAA1
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Sep 2022 23:50:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiIFXu1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Sep 2022 19:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiIFXu0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Sep 2022 19:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7977F11B
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 16:50:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D56E61728
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 23:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD26C433B5
        for <linux-cifs@vger.kernel.org>; Tue,  6 Sep 2022 23:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662508224;
        bh=gpC7uXedF1XsIJGCu+uu58ITw26IluYtfZkipSNDJ+Y=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Yc19ayT1QCNNAe6cgL1KwX/1XE1Jv60jw4yLs2W+9v2yQOh+7pr++WKgAmjiwnYYy
         aQenNo1b3h1GDZOmurzEw/P+W1Vk1Oa0UJ8XBLo5o0lgDjikqRCFsK4JdcpZXLKN6R
         pL/Rn1QK3SMP7rmRZXydVoIYkXjsBxV+yWkG9qq73p5OHflohC38gtyS8YaP/LA4SO
         jrfeDOXJ3vqkJwgRI07qGR9z6ElHK34cHu5eR60RSh1c/+rB+Brc6r/IKOrlV16QcC
         GyL5sadLX7q+IyGJjwtLU1ZR7XIj1Zvf9E+r0yc36+QpEa/DhprHxUwlP7URCPKwU8
         LkQX1fm6X8jqA==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-11ee4649dfcso32201645fac.1
        for <linux-cifs@vger.kernel.org>; Tue, 06 Sep 2022 16:50:24 -0700 (PDT)
X-Gm-Message-State: ACgBeo1G2f2xyaN0LGUdbPO29M9AgtSChiYdWznQGPDMs62LN1wD3UUL
        ZsmEw49MTPWYrs3aln9/6AH2tMLVqfzI5AhTnik=
X-Google-Smtp-Source: AA6agR65WgaHWvyWICxA+hSpOArTK+nFjevk+/Tkxt6EkRuMQX/ex6YcGfgQXDAWEsDAPEInndraDPab6rrkyLuEERg=
X-Received: by 2002:aca:1106:0:b0:34b:89c9:f5f8 with SMTP id
 6-20020aca1106000000b0034b89c9f5f8mr4549414oir.8.1662508223888; Tue, 06 Sep
 2022 16:50:23 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Tue, 6 Sep 2022 16:50:23
 -0700 (PDT)
In-Reply-To: <307b7cba-9c73-bcaf-d3f2-02c40ebaf836@huawei.com>
References: <20220901142413.3351804-1-zhangxiaoxu5@huawei.com>
 <20220901142413.3351804-3-zhangxiaoxu5@huawei.com> <6cf00762-f446-490c-5e88-79382962e985@talpey.com>
 <CAKYAXd_FioX1ivG_cv=QTehaTw0ecAQA_-H0Y13Aqbaq=hB=Zg@mail.gmail.com> <307b7cba-9c73-bcaf-d3f2-02c40ebaf836@huawei.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 7 Sep 2022 08:50:23 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9hnFeP7arBT75TdZ_gj=MCUiA3ebRYCFVWpsQZj6v+HQ@mail.gmail.com>
Message-ID: <CAKYAXd9hnFeP7arBT75TdZ_gj=MCUiA3ebRYCFVWpsQZj6v+HQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] ksmbd: Remove the wrong message length check of FSCTL_VALIDATE_NEGOTIATE_INFO
To:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Cc:     Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        sfrench@samba.org, pc@cjr.nz, lsahlber@redhat.com,
        sprasad@microsoft.com, rohiths@microsoft.com, smfrench@gmail.com,
        hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-05 11:29 GMT+09:00, zhangxiaoxu (A) <zhangxiaoxu5@huawei.com>:
>
>
> =E5=9C=A8 2022/9/2 22:47, Namjae Jeon =E5=86=99=E9=81=93:
>> 2022-09-02 22:28 GMT+09:00, Tom Talpey <tom@talpey.com>:
>>> On 9/1/2022 10:24 AM, Zhang Xiaoxu wrote:
>>>> The struct validate_negotiate_info_req change from variable-length
>>>> array
>>>> to reguler array, but the message length check is unchanged.
>>>>
>>>> The fsctl_validate_negotiate_info() already check the message length,
>>>> so
>>>> remove it from smb2_ioctl().
>>>>
>>>> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break,
>>>> and
>> I think the fixes tag is wrong. Isn't the below correct?
>> Fixes: f7db8fd03a4bc ("ksmbd: add validation in smb2_ioctl")
>
> Before commit c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock brea=
k,
> and
> move its struct to smbfs_common"), the struct defined in
> fs/ksmbd/smb2pdu.h:
>
>    struct validate_negotiate_info_req {
>           __le32 Capabilities;
>           __u8   Guid[SMB2_CLIENT_GUID_SIZE];
>           __le16 SecurityMode;
>           __le16 DialectCount;
>           __le16 Dialects[1]; /* dialect (someday maybe list) client aske=
d
> for */
>    } __packed;
>
> After this commit, the struct defined in fs/smbfs_common/smb2pdu.h:
>    struct validate_negotiate_info_req {
>           __le32 Capabilities;
>           __u8   Guid[SMB2_CLIENT_GUID_SIZE];
>           __le16 SecurityMode;
>           __le16 DialectCount;
>           __le16 Dialects[4]; /* BB expand this if autonegotiate > 4
> dialects */
>    } __packed;
>
> The 'Dialects' array length from 1 change to 4.
Okay, Do you think that your patch is not needed without commit c7803b05f74=
b ?
I understood that the InputCount check doesn't take the DialectCount
into account and it's already a duplicate check, So you try to remove
that.

>
> Before commit c7803b05f74b, the message should contain at lease 1 dialect=
s,
> but after this commit, it changed to should contain at lease 4 dialects.
>
> So the fixes tag should be c7803b05f74b.
