Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C3CECAAD8
	for <linux-cifs@archiver.kernel.org>; Sun, 18 Sep 2022 23:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiIRXpl (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 18 Sep 2022 19:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiIRXpj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 18 Sep 2022 19:45:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A7E13CC5
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 16:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA9716162A
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 23:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 307DAC43470
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 23:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663544735;
        bh=j/MzyfjGmuJBN2VNZWE+uBC9zyB0ZyvULLEhY2wxNEI=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=dRM3MvyapKEpQ0iTJk2vkcGwGzNebYlMireITDpbiX3VvlSIpgCNLCe0qTzSNWbNz
         0FBLjeJeF/2omX/OXR7mA4SgKqFFoFX9kmG/h+nL9yy/ee9LSFY1Ud0QiZlCT8PDMc
         uQsqKw8ukDBHeasRdhyDXlTP0qy/SK1o72bOlY3jnk8Kdar+B5kTNlxYgdnTIa7Ljh
         TIpvDbzqB5VwF6vRXDm3zA7L7u2bgOjIMQv/FsDo2W6Rh4i1FcGPESaIxh4Kfv+BpO
         bQjVrkC7/j7kWjkUf6aCqVNoym3THvGZejgVwc7qlkTx7b9r1lDIC4GmD/v/WZlhvq
         5CnHmKE6wVryQ==
Received: by mail-ot1-f44.google.com with SMTP id f20-20020a9d7b54000000b006574e21f1b6so10248568oto.5
        for <linux-cifs@vger.kernel.org>; Sun, 18 Sep 2022 16:45:35 -0700 (PDT)
X-Gm-Message-State: ACrzQf2JAqGJT8OmgiFoz4lxfkpwKNDiSdM5RTS6rPoCgP+Ur/zDkcIt
        To1MtORutkP84OixiRGObrIJirJH48PhcTpMbus=
X-Google-Smtp-Source: AMsMyM5l2lgtiS08v9+WHPQPXA4Pyqc4OsU5wvfQi2ITcT+6MPEvjPOz31zlj4kv0ShLKc5cTKy3OBwjlG7nl4WomHo=
X-Received: by 2002:a9d:da6:0:b0:655:dd4e:7afc with SMTP id
 35-20020a9d0da6000000b00655dd4e7afcmr6821691ots.339.1663544734290; Sun, 18
 Sep 2022 16:45:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:27c7:0:0:0:0 with HTTP; Sun, 18 Sep 2022 16:45:33
 -0700 (PDT)
In-Reply-To: <560f7201-3703-d2d4-88e3-0604c35dbdb3@huawei.com>
References: <20220914021741.2672982-1-zhangxiaoxu5@huawei.com>
 <20220914021741.2672982-4-zhangxiaoxu5@huawei.com> <CAKYAXd-g8E8wpJDPSdiW7W_0JGudxUTJj6wr7C5wcnBUUTZF0A@mail.gmail.com>
 <560f7201-3703-d2d4-88e3-0604c35dbdb3@huawei.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 19 Sep 2022 08:45:33 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8p4FkJAz8AYszmquptK9Bxp9RwErgyCFxsVM0zDkusTQ@mail.gmail.com>
Message-ID: <CAKYAXd8p4FkJAz8AYszmquptK9Bxp9RwErgyCFxsVM0zDkusTQ@mail.gmail.com>
Subject: Re: [PATCH v6 3/5] ksmbd: Fix FSCTL_VALIDATE_NEGOTIATE_INFO message
 length check in smb2_ioctl()
To:     "zhangxiaoxu (A)" <zhangxiaoxu5@huawei.com>
Cc:     linux-cifs@vger.kernel.org, sfrench@samba.org, pc@cjr.nz,
        lsahlber@redhat.com, sprasad@microsoft.com, rohiths@microsoft.com,
        smfrench@gmail.com, tom@talpey.com, hyc.lee@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2022-09-16 20:20 GMT+09:00, zhangxiaoxu (A) <zhangxiaoxu5@huawei.com>:
>
>
> =E5=9C=A8 2022/9/16 8:26, Namjae Jeon =E5=86=99=E9=81=93:
>> 2022-09-14 11:17 GMT+09:00, Zhang Xiaoxu <zhangxiaoxu5@huawei.com>:
>>> The structure size includes 4 dialect slots, but the protocol does not
>>> require the client to send all 4. So this allows the negotiation to not
>>> fail.
>>>
>>> Fixes: c7803b05f74b ("smb3: fix ksmbd bigendian bug in oplock break, an=
d
>>> move its struct to smbfs_common")
>> NACK. I am still thinking this tag is wrong.
> Thanks for your comments.
>
> In the v2, I remove the validation expression, and as your comments
> in v2, duplicate check is unneed.
>
> I add it back in v6 because tom's comments, we should ensure the req
> has 'DialectCount', before validate the req has enough 'Dialects',
> otherwise, dereferencing 'neg_req->DialectCount' will be OOB read.
>
> Maybe the validation expression as below much better:
> @@ -7640,7 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>    ...
>    if (in_buf_len < offsetof(struct validate_negotiate_info_req,
> Dialects[1]))
>
> If even there's no one Dialects, 'the fsctl_validate_negotiate_info'
> still return -EINVAL:
>
>    fsctl_validate_negotiate_info
>      ksmbd_lookup_dialect_by_id(neg_req->DialectCount=3D0)
>        return BAD_PROT_ID
>      ret =3D -EINVAL;
>
> Same as before commit c7803b05f74b.
Sorry, I don't understand what you say.
>
> Could you give me more help about the fix tag.
Please change a tag to commit f7db8fd03a4bc in this patch.

Thanks.
>
> Thanks.
> Zhang Xiaoxu
>>
>>> Signed-off-by: Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>   fs/ksmbd/smb2pdu.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>>> index b56d7688ccf1..09ae601e64f9 100644
>>> --- a/fs/ksmbd/smb2pdu.c
>>> +++ b/fs/ksmbd/smb2pdu.c
>>> @@ -7640,7 +7640,8 @@ int smb2_ioctl(struct ksmbd_work *work)
>>>   			goto out;
>>>   		}
>>>
>>> -		if (in_buf_len < sizeof(struct validate_negotiate_info_req)) {
>>> +		if (in_buf_len < offsetof(struct validate_negotiate_info_req,
>>> +					  Dialects)) {
>>>   			ret =3D -EINVAL;
>>>   			goto out;
>>>   		}
>>> --
>>> 2.31.1
>>>
>>>
>
