Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 938B5C6FD1C
	for <linux-cifs@archiver.kernel.org>; Thu, 23 Mar 2023 05:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjCWFEa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 Mar 2023 01:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCWFEa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 Mar 2023 01:04:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E339FDBE8
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 22:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78B5EB81F07
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 05:04:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CFCBC433EF
        for <linux-cifs@vger.kernel.org>; Thu, 23 Mar 2023 05:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679547866;
        bh=nf/RSj+aK6CIgzz0EfLQy5S6HB9s3wr0k9k4SdydN3c=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=svtMEbvd0aJBldWC8g03mv3sSSrp/Xvo+i70qn47DxTqiMh/i8w9ODf/KUJYIXkMQ
         0DiVESVBJCXqgwUYJl4qFsSwdzxMuaKWS+zDoDyFYDgHnzj9gMXX5VevX1763dmP4O
         4J23lNHVmbtylqxKJRJfXt8fM6xS8ddoM+uTlpGqQuSb1L3DbooCZlu/CveuUbRcX2
         TTGKuqwwLkaAqZxqDWfP18Z0Qo8fhtpBmL6wUR2R/KyTZ40uGCcIF1tKkVbSyhY0WP
         6KTmWbQGM63PdQQ86wtrJdAbkx0mjNoOPOhBIISIdBBzqF6mTeRL51AmDC2KT5FgyH
         uZzl0zZuy7m3A==
Received: by mail-ot1-f42.google.com with SMTP id w21-20020a9d6755000000b00698853a52c7so11552979otm.11
        for <linux-cifs@vger.kernel.org>; Wed, 22 Mar 2023 22:04:26 -0700 (PDT)
X-Gm-Message-State: AO0yUKUuHGzXenXXKR+XHxQcT39Db3RjwOcl6IAVHBvGY3nEffdy9WSe
        ot6fk/EoZ+25J3zQuVA2k+JLE6r5XjOlaojjYEs=
X-Google-Smtp-Source: AK7set9+WGOM/5AI/U2f9pIxGod3hkr0KrGPc0w4LlP+tWR4GhN1N8qg1Sx9VX/3SGLRpggBqBZRM6JSxv7xfO/ywZo=
X-Received: by 2002:a05:6830:1e26:b0:69a:b32c:9882 with SMTP id
 t6-20020a0568301e2600b0069ab32c9882mr1848510otr.3.1679547865243; Wed, 22 Mar
 2023 22:04:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:774e:0:b0:4c8:b94d:7a80 with HTTP; Wed, 22 Mar 2023
 22:04:24 -0700 (PDT)
In-Reply-To: <20230323050006.GB3271889@google.com>
References: <20230321133312.103789-1-linkinjeon@kernel.org>
 <20230321133312.103789-3-linkinjeon@kernel.org> <20230323025319.GA3271889@google.com>
 <CAKYAXd-PQFcVq=b_KNq6P5imBV-Y+PQ5LBZCzH-mH7dmZAav+w@mail.gmail.com> <20230323050006.GB3271889@google.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 23 Mar 2023 14:04:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_GK_Tpk8cP-L-BjxenMFpBjGwrZ3E_6xHMVoLUfYNnjg@mail.gmail.com>
Message-ID: <CAKYAXd_GK_Tpk8cP-L-BjxenMFpBjGwrZ3E_6xHMVoLUfYNnjg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: return unsupported error on smb1 mount
To:     Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com,
        atteh.mailbox@gmail.com, Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-03-23 14:00 GMT+09:00, Sergey Senozhatsky <senozhatsky@chromium.org>:
> On (23/03/23 13:10), Namjae Jeon wrote:
> [..]
>> >> +	/*
>> >> +	 * Remove 4 byte direct TCP header, add 1 byte wc, 2 byte bcc
>> >> +	 * and 2 byte DialectIndex.
>> >> +	 */
>> >> +	*(__be32 *)work->response_buf =
>> >> +		cpu_to_be32(sizeof(struct smb_hdr) - 4 + 2 + 2);
>> >
>> > 	In other words cpu_to_be32(sizeof(struct smb_hdr)).
>> Yes, that's possible too, but wouldn't this make the comments easier
>> to understand..?
>
> Maybe, but the comment says "-4 + 1 + 2 + 2", which doesn't match the code.
wc is included in smb_hdr struct. Hm.. I will update the comment.

>
>> >> +	*(__le32 *)neg_rsp->hdr.Protocol = SMB1_PROTO_NUMBER;
>> >
>> > 	I assume this should say cpu_to_le32(SMB1_PROTO_NUMBER).
>> SMB1_PROTO_NUMBER is declared as:
>> #define SMB1_PROTO_NUMBER		cpu_to_le32(0x424d53ff)
>
> Oh, I see.
>
