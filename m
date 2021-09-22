Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7396BC433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 13:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57E4F610A1
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 13:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbhIVNwi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 09:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232720AbhIVNwf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 09:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2618E610A1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 13:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632318665;
        bh=zoz+nDVzECzLxzwW4g3RphAzOkJ1+Q+iU/cs8J49OKE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=BWBqUEU1kFlscZ6PMlYxKBiCmPjazQOVGH3dPrtz+REa/8b+gelNgwkQjz690ckCH
         6d73wnYxzUJr831ojQpkGETSCCKonj1vZ+eBjpwkXOgMTt6CTdLJvRCKTJi3cUFwfu
         BQbUvm3gq1HAWvFoGGEYIh2g4UbaKpRwB52+UQU3ynKoyCX1pcIDCTPcvQNbGgiiz5
         giYCyA4Xwac3GysiniAT1twYxkpZRKdAeQ6ANlGM90egH03Lph/8nJ+l01zca7Guv4
         CEGnU1LVxnUPXwr7L0jTSjLwbdw4aOOBvD4L4f9JW/3lNh0WGnwrjhofhTMKCcqQhb
         eSxXKIRthloaQ==
Received: by mail-vs1-f49.google.com with SMTP id o124so3023802vsc.6
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 06:51:05 -0700 (PDT)
X-Gm-Message-State: AOAM530ou2P9/FN94uZ+ZjFLyL7B6fcyc89yLSIIwz7TE6XWZ46xZDoi
        HWJl5or9jy3lUacPJAGEmmsOISJsYLHuFADz32E=
X-Google-Smtp-Source: ABdhPJwn4q9+daE+CoCNU8RKWoHUoFzphi6ec2TC2U7HRrWIcvIChERL3LugfCr+m0NvnkJ2YUW2P1vP/7B2Mxy1KaY=
X-Received: by 2002:a67:eb51:: with SMTP id x17mr15729449vso.8.1632318664385;
 Wed, 22 Sep 2021 06:51:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6102:48e:0:0:0:0 with HTTP; Wed, 22 Sep 2021 06:51:03
 -0700 (PDT)
In-Reply-To: <aec0390e-fca6-bb2b-f8e5-3b2336042e48@samba.org>
References: <20210922041932.663796-1-linkinjeon@kernel.org> <aec0390e-fca6-bb2b-f8e5-3b2336042e48@samba.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 22 Sep 2021 22:51:03 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-WNjxrBRCqVLSeHRi_5_GNQ1fn3pjpiHJJbL-HohPWuQ@mail.gmail.com>
Message-ID: <CAKYAXd-WNjxrBRCqVLSeHRi_5_GNQ1fn3pjpiHJJbL-HohPWuQ@mail.gmail.com>
Subject: Re: [PATCH v3] ksmbd: add request buffer validation in smb2_set_info
To:     Ralph Boehme <slow@samba.org>
Cc:     linux-cifs@vger.kernel.org, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-22 22:39 GMT+09:00, Ralph Boehme <slow@samba.org>:
> Hi Namjae,
>
> patch looks great. One nitpick.
>
> Am 22.09.21 um 06:19 schrieb Namjae Jeon:
>> Add buffer validation in smb2_set_info, and remove unused variable
>> in set_file_basic_info. and smb2_set_info infolevel functions take
>> structure pointer argument.
>> ...
>> +struct smb2_file_basic_info { /* data block encoding of response to level
>> 18 */
>> +	__le64 CreationTime;	/* Beginning of FILE_BASIC_INFO equivalent */
>> +	__le64 LastAccessTime;
>> +	__le64 LastWriteTime;
>> +	__le64 ChangeTime;
>> +	__le32 Attributes;
>> +	__u32  Pad1;		/* End of FILE_BASIC_INFO_INFO equivalent */
>> +} __packed;
>> +
>
> adding struct smb2_file_basic_info and the fix in the handler should be
> done in a preceeding commit.
Well, This structure is added for buffer check. There is no problem
using smb2_file_all_info as before if there is no buffer check.

Thanks!
>
> Thanks!
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba
>
>
