Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2947AC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 12:12:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE7461166
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Oct 2021 12:12:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhJDMO2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Oct 2021 08:14:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232549AbhJDMO0 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 4 Oct 2021 08:14:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2514161181
        for <linux-cifs@vger.kernel.org>; Mon,  4 Oct 2021 12:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633349558;
        bh=oI+uvjOXMxjt5A9vo4n8127tkLZCtdr/aOee3MJgW0U=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=pkp5ZTYyj/Im60CMYrUy3E4xmUKPmNPO6ofPaG9iJ8bFBJkwWb8YLH3Ep6GIry/1a
         UXz708/0qHKdT/qPQwD8FMPgGb5Kyjg9YJRT0EYuyzfBFRTSKgHHAvLJ1uCeZFMp+v
         26MJL6mYrlyHlrELx0eVP+T0NCtLw0Gl8t9UGQ9yHg9qWXJxm+qFyQshfKBhWS20EN
         H25DmvupWnCeaIrEPUKOMSt4Hk955QIEhykvauTLZZ0SvH2fLIrI6iuxXGMklUeG1R
         kJT1gHlzk5JY0QAflggtkPa8FXCABymFuh2JdjAy0vWtNRnmzsRqlT8x1HqsjENLU3
         ZzqybWYnrMg1g==
Received: by mail-ot1-f54.google.com with SMTP id c26-20020a056830349a00b0054d96d25c1eso21190056otu.9
        for <linux-cifs@vger.kernel.org>; Mon, 04 Oct 2021 05:12:38 -0700 (PDT)
X-Gm-Message-State: AOAM533dRrJtkzsgernKKscKGbw1TN8SlclfkDvj7fBeP2kDBe3Qlhwk
        YrTG0ygwJGuHJ1UMB8g4hcoWMSLvkklZVxQIo2M=
X-Google-Smtp-Source: ABdhPJyH9Ij35xClvGXpXwaM9lJphbUv1snnfciyI8w1xeFx0OolOih4POkUM6TYW0QVV3AEHBjw6dZDb9PedF1+Bkc=
X-Received: by 2002:a05:6830:1147:: with SMTP id x7mr9192511otq.18.1633349556796;
 Mon, 04 Oct 2021 05:12:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:31e7:0:0:0:0:0 with HTTP; Mon, 4 Oct 2021 05:12:36 -0700 (PDT)
In-Reply-To: <20211004104544.GA25640@kili>
References: <20211004104544.GA25640@kili>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Mon, 4 Oct 2021 21:12:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-v8tM_56V0U2m3piUfUipB4EHe5-aCBbC=mJ0MP2J4XA@mail.gmail.com>
Message-ID: <CAKYAXd-v8tM_56V0U2m3piUfUipB4EHe5-aCBbC=mJ0MP2J4XA@mail.gmail.com>
Subject: Re: [bug report] ksmbd: add validation in smb2 negotiate
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-10-04 19:45 GMT+09:00, Dan Carpenter <dan.carpenter@oracle.com>:
> Hello Namjae Jeon,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 442ff9ebeb01: "ksmbd: add validation in smb2 negotiate"
> from Sep 29, 2021, leads to the following Smatch complaint:
>
>     fs/ksmbd/smb2pdu.c:8330 smb3_preauth_hash_rsp()
>     error: we previously assumed 'conn->preauth_info' could be null (see
> line 8310)
>
> fs/ksmbd/smb2pdu.c
>   8309		if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE &&
>   8310		    conn->preauth_info)
>                     ^^^^^^^^^^^^^^^^^^
> The patch adds a new check for "conn->preauth_info"
>
>   8311			ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
>   8312							 conn->preauth_info->Preauth_HashValue);
>   8313	
>   8314		if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE && sess) {
>   8315			__u8 *hash_value;
>   8316	
>   8317			if (conn->binding) {
>   8318				struct preauth_session *preauth_sess;
>   8319	
>   8320				preauth_sess = ksmbd_preauth_session_lookup(conn, sess->id);
>   8321				if (!preauth_sess)
>   8322					return;
>   8323				hash_value = preauth_sess->Preauth_HashValue;
>   8324			} else {
>   8325				hash_value = sess->Preauth_HashValue;
>   8326				if (!hash_value)
>   8327					return;
>   8328			}
>   8329			ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
>
Hi Dan,

First, Thanks for your report:)
> But it's not checked inside the ksmbd_gen_preauth_integrity_hash()
> function.
conn->preauth_info can not be NULL on smb3.1.1 session setup stage.

smb2 negotate(smb3.1.1, allocate conn->preauth_info) ->  smb3.1.1
session setup -> smb3_preauth_hash_rsp().

This is the check not to call ksmbd_gen_preauth_integrity_hash().
if (le16_to_cpu(rsp->Command) == SMB2_SESSION_SETUP_HE && sess) {

Let me know if I am missing something:)

Thanks!
>
>   8330							 hash_value);
>   8331		}
>   8332	}
>
> regards,
> dan carpenter
>
