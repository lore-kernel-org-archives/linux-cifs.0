Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A10D0C6FD1D
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 04:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjCWEKc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 00:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjCWEKb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 00:10:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6149110CA
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 21:10:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0CDFB81EDA
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 04:10:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E05C4339B
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 04:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679544627;
        bh=VvcopK0AfIub25/v2xbmwGPlKgCpM1csI3cYpzrz4YE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=FoV5EstK+0QwwS+FLV2bp2jEK2o/tS3ZIWwBsSbGJtpCXbH2bPxFZEnj3EDOuEDcu
         7+cqmABPvRmASE5M2lh3sYnuuXC9jznYNSIr1H1X0xbS0sj2qlolyHxOasE+AxhuFf
         0AApyIacEHMaxFDSPeJkw6ORR0Ao20ZKMBPrXVqBTiXCL6M7qMa+dsKAC0ZROfpSAr
         sdFj6RvU4jsr0Fku4iOsWkby5xi3aiEABArzyYy68sr0JeQESOcAMhECa5qQWNwD7T
         Lqb5UWXTcuJsJnx0VTQ8lNPoP1i/UEbi/HrTAHB9C/2vand0GanMQsL3gtrsLeCZFS
         37iGv1eIXWPjg==
Received: by mail-oi1-f178.google.com with SMTP id v17so5534850oic.5
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 21:10:27 -0700 (PDT)
X-Gm-Message-State: AO0yUKWP0Eg2z3fr4uoynJtXnpT092Y93BNSrFyd+a2SXJi77WLMDeRV
        kQ0tOVPPMFr75oUSokNXQdQMMv2kQTMLlQSm62Q=
X-Google-Smtp-Source: AK7set8+zE0W+ETOVte0sFu6ZAUm85F7TmE5dqEt42PeGFMoa3fQsBCvYN/BI1GCK8+fYCH+ObJbiVwvR3/DNWyJMk0=
X-Received: by 2002:aca:2b06:0:b0:384:23ce:10e7 with SMTP id
 i6-20020aca2b06000000b0038423ce10e7mr1753293oik.1.1679544626624; Wed, 22 Mar
 2023 21:10:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:774e:0:b0:4c8:b94d:7a80 with HTTP; Wed, 22 Mar 2023
 21:10:25 -0700 (PDT)
In-Reply-To: <20230323025319.GA3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230321133312.103789-3-linkinjeon@kernel.org> <20230323025319.GA3271889@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Mar 2023 13:10:25 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-PQFcVq=b_KNq6P5imBV-Y+PQ5LBZCzH-mH7dmZAav+w@mail.gmail.com>
Message-ID: <CAKYAXd-PQFcVq=b_KNq6P5imBV-Y+PQ5LBZCzH-mH7dmZAav+w@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: return unsupported error on smb1 mount
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-23 11:53 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (23/03/21 22:33), Namjae Jeon wrote:
> [..]
>> @@ -442,9 +442,26 @@ static int smb_handle_negotiate(struct ksmbd_work
>> *work)
>>  {
>>  	struct smb_negotiate_rsp *neg_rsp = work->response_buf;
>>
>> -	ksmbd_debug(SMB, "Unsupported SMB protocol\n");
>> -	neg_rsp->hdr.Status.CifsError = STATUS_INVALID_LOGON_TYPE;
>> -	return -EINVAL;
>> +	ksmbd_debug(SMB, "Unsupported SMB1 protocol\n");
>> +
>> +	/*
>> +	 * Remove 4 byte direct TCP header, add 1 byte wc, 2 byte bcc
>> +	 * and 2 byte DialectIndex.
>> +	 */
>> +	*(__be32 *)work->response_buf =
>> +		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
>
> 	In other words cpu_to_be32(sizeof(struct smb_hdr)).
Yes, that's possible too, but wouldn't this make the comments easier
to understand..?
>
>> +	neg_rsp->hdr.Status.CifsError = STATUS_SUCCESS;
>> +
>> +	neg_rsp->hdr.Command = SMB_COM_NEGOTIATE;
>> +	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
>
> 	I assume this should say cpu_to_le32(SMB1_PROTO_NUMBER).
SMB1_PROTO_NUMBER is declared as:
#define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)

Thanks!
>
