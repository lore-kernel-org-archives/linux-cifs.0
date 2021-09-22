Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80B00C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 23:15:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CBC261153
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 23:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhIVXQn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 19:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238293AbhIVXQm (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 19:16:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 628A060F24
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 23:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632352512;
        bh=VcgtLw8KpstqMGTrCTxUHOBKFBeKcg117yySaoz9Aog=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Y0MUyOf6oeKAgIpG4F2jEx+O+zaB4zM1qDWbfn7svH/wd79MX7ZgLZeZ9HYUJOxpt
         01CRwV92RcLqs6lZJi0qkGVCxxPQ2L/vW3Y5FVGOU+A7lH4gNP0KX/6WzjGt4mojAl
         dgNrQJyALPnnK8LN0UpkX020Tnrqf77sPWKdUS5SsOoT180e5Mz6Xfmm5tewpIw91N
         yd/4oNSGCiYQa6HJ1AP/GqR1QM/yXNT1yhVg2sEowM3beXVL2ys6XDDa6o61BJ/7Qr
         uubYTDrS6OFfVhqhp1h4nD2KDuuJ7PAFtw2A5DdJGKTk2xC1m7oBirtDvYq21U9ou/
         qNys5004yNt6w==
Received: by mail-oi1-f175.google.com with SMTP id u22so6996413oie.5
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 16:15:12 -0700 (PDT)
X-Gm-Message-State: AOAM530gpHTotHjB04riB2waHlGphg1gYC6il8iDhPwEQjEPD/QnKzjp
        6Ushw1cvAbAGogK/1MbeVwFnmo8ycCmLwWxHl44=
X-Google-Smtp-Source: ABdhPJwpGaCs2O10mv3UJXrgS9z61WeEJYo2Y6q/wzeYR2r4ppKfsCj9sRYvkRnfBHL28VJDiPEPwnsa6Aetsemd5y8=
X-Received: by 2002:a05:6808:1a29:: with SMTP id bk41mr10136504oib.167.1632352511796;
 Wed, 22 Sep 2021 16:15:11 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Wed, 22 Sep 2021 16:15:11
 -0700 (PDT)
In-Reply-To: <447d958e-2470-4ddb-2064-0aeaf1a47ba0@samba.org>
References: <20210922120143.45953-1-linkinjeon@kernel.org> <447d958e-2470-4ddb-2064-0aeaf1a47ba0@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Sep 2021 08:15:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8S7Vc7MpOgHQ5+u0Fje92c417Ti48vDdZsPv8FTcwVwQ@mail.gmail.com>
Message-ID: <CAKYAXd8S7Vc7MpOgHQ5+u0Fje92c417Ti48vDdZsPv8FTcwVwQ@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: fix invalid request buffer access in compound request
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-22 23:23 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Am 22.09.21 um 14:01 schrieb Namjae Jeon:
>> Ronnie reported invalid request buffer access in chained command when
>> inserting garbage value to NextCommand of compound request.
>> This patch add validation check to avoid this issue.
>>
>> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> ---
>>    v2:
>>     - fix integer overflow from work->next_smb2_rcv_hdr_off.
>>    v3:
>>     - check next command offset and at least header size of next pdu at
>>       the same time.
>>   fs/ksmbd/smb2pdu.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> index 4f11eb85bb6b..3d250e2539e6 100644
>> --- a/fs/ksmbd/smb2pdu.c
>> +++ b/fs/ksmbd/smb2pdu.c
>> @@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work
>> *work)
>>
>>   	hdr =3D ksmbd_req_buf_next(work);
>>   	if (le32_to_cpu(hdr->NextCommand) > 0) {
>> +		if ((u64)work->next_smb2_rcv_hdr_off + le32_to_cpu(hdr->NextCommand) =
+
>> 64 >
>> +		    get_rfc1002_len(work->request_buf)) {
>
> is this safe from overflows on 32 bit arch?
Okay, will fix it on next version.

Thanks for your review!
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
