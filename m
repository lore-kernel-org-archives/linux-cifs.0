Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD652C05027
	for <linux-cifs@archiver.kernel.org>; Sun, 12 Feb 2023 20:44:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBLUoC (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 12 Feb 2023 15:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBLUoB (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 12 Feb 2023 15:44:01 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAB3F757
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 12:44:00 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id w11so16209227lfu.11
        for <linux-cifs@vger.kernel.org>; Sun, 12 Feb 2023 12:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FwYkWsEo44WGpLJHfXDsH9W6jLzggKTKdUui1Ypn3EQ=;
        b=jPUiiWhvwm04tzVeiTPPOUZm62lGvWCjQsp7HeH4S45DpPOrCS3YzPJbGMSpcFA3bx
         hubwjs61x5a2D36+iEZ0eMyWOPPSvHno8I9U/7IHBVai16MQQYutpoOkYr9PN7e2DQmK
         zaOHMD/O19kidaw5VWp7CBVcYTigBeqiknRopKoEkh/Nw+3TTj0YSpUrhpKreTovqw7d
         puv3ZLVGsBvS7CpdvdBDrGnFRhbGagd+Tl0FoIf8YbK1pWb907pkS6ON3yM0OPZ/Sq9p
         PM0M9rLrzJ1vVoZ61EWI6j8Ir4uE+HLRJMzjHLndBe7Wut1+9sKl+fvW1QWC+HvfkFZ1
         7TgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FwYkWsEo44WGpLJHfXDsH9W6jLzggKTKdUui1Ypn3EQ=;
        b=6E0cFsDdoxWQEvTj9GDE2zjvxFjYxZFugxvUdPjsCiBp9DcKW6pDxH5mwd9asH7uuM
         /cyTQqTeJclQxkFnTo2aZidTzpbf/iEm1znvTiJDbs5Hf0pTCRdCm11JK2Ag7CNO78RB
         sW1Q6ms8MkDYQXzIndyKO0GqwEb4DsD0ssK7Y3EnJ3ldGKzUDosw8HW6V4HNzMfw+Xsw
         ehmtQB55PqXOmMavQZ/zkYTcIupMakOHVhW/HqmA4AD4wpWToyDunYjk7QRkj2RETE+L
         4Qg8pfvAPpNrvEo49giTHjESkdl1A97l2f3ou4MIFV5nTn2TCltMpgnTRn7CLX6SObzO
         iwUQ==
X-Gm-Message-State: AO0yUKVje8f2dlgYnu2XtMO5f8+K0RZb42I/eoLHWta6qEtQh4LzMifz
        XWpW3iIKoVofRwsE3I8eD8XXpsoiRZRriQsy3i8=
X-Google-Smtp-Source: AK7set/yV+3rXqQOqfT480T8aemi+JZmp3RuZcw1M1MjG7xcBJbeFO+rfsEaep+BRfMS17w6910bUWyrZ9LghWlti50=
X-Received: by 2002:ac2:4f8d:0:b0:4d8:696d:6ab0 with SMTP id
 z13-20020ac24f8d000000b004d8696d6ab0mr4166385lfs.152.1676234638284; Sun, 12
 Feb 2023 12:43:58 -0800 (PST)
MIME-Version: 1.0
References: <20230208094104.10766-1-linkinjeon@kernel.org> <CAH2r5mvGspRdByLkuC79oHfNkirKj2hEFSODDHKvXtQkV9KdEQ@mail.gmail.com>
 <CAKYAXd_h7QyFFRn689+_jFzSOJBYLc9xJRTh-UbZ3MrR0oNpYg@mail.gmail.com>
In-Reply-To: <CAKYAXd_h7QyFFRn689+_jFzSOJBYLc9xJRTh-UbZ3MrR0oNpYg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 12 Feb 2023 14:43:46 -0600
Message-ID: <CAH2r5mvZe-SgMeTmT53Qeu3Zw6yPU+gJ6Whq+7-G4nHvH7yrDA@mail.gmail.com>
Subject: Re: [PATCH 1/2] ksmbd: do not allow the actual frame length to be
 smaller than the rfc10024 length
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs@vger.kernel.org, senozhatsky@chromium.org,
        tom@talpey.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

seems reasonable to merge the client fix - I will doublecheck it later
today or tomorrow and add it to for-next

On Sat, Feb 11, 2023 at 8:01 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2023-02-12 5:53 GMT+09:00, Steve French <smfrench@gmail.com>:
> > Did you see any examples other than (SMB3) tree connect where the
> > Linux client padded a request beyond end of SMB/SMB3 frame?
> Yes. libsmb,  but rfc1002 length is 8byte-aligned frame length. (i.e.
> ALIGN(clc_len, 8) == len) but cifs don't do that about smb2 tree
> connect, just frame length + 2.
> And I can not understand why cifs pad smb2 tree connect to 2bytes.
>
> note that smbclient, windows, MacOs, and Nautilus clients do not pad
> smb2 tree connect request.
>
> >
> > On Wed, Feb 8, 2023 at 3:41 AM Namjae Jeon <linkinjeon@kernel.org> wrote:
> >>
> >> ksmbd allowed the actual frame length to be smaller than the rfc1002
> >> length. If allowed, it is possible to allocates a large amount of memory
> >> that can be limited by credit management and can eventually cause memory
> >> exhaustion problem. This patch do not allow it except SMB2 Negotiate
> >> request which will be validated when message handling proceeds.
> >> Also, cifs client pad smb2 tree connect to 2bytes.
> >>
> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >> ---
> >>  fs/ksmbd/smb2misc.c | 23 +++++++++++------------
> >>  1 file changed, 11 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
> >> index a717aa9b4af8..fc44f08b5939 100644
> >> --- a/fs/ksmbd/smb2misc.c
> >> +++ b/fs/ksmbd/smb2misc.c
> >> @@ -408,20 +408,19 @@ int ksmbd_smb2_check_message(struct ksmbd_work
> >> *work)
> >>                         goto validate_credit;
> >>
> >>                 /*
> >> -                * windows client also pad up to 8 bytes when
> >> compounding.
> >> -                * If pad is longer than eight bytes, log the server
> >> behavior
> >> -                * (once), since may indicate a problem but allow it and
> >> -                * continue since the frame is parseable.
> >> +                * SMB2 NEGOTIATE request will be validated when message
> >> +                * handling proceeds.
> >>                  */
> >> -               if (clc_len < len) {
> >> -                       ksmbd_debug(SMB,
> >> -                                   "cli req padded more than expected.
> >> Length %d not %d for cmd:%d mid:%llu\n",
> >> -                                   len, clc_len, command,
> >> -                                   le64_to_cpu(hdr->MessageId));
> >> -                       goto validate_credit;
> >> -               }
> >> +               if (command == SMB2_NEGOTIATE_HE)
> >> +                       goto validate_credit;
> >> +
> >> +               /*
> >> +                * cifs client pads smb2 tree connect to 2 bytes.
> >> +                */
> >> +               if (clc_len + 2 == len)
> >> +                       goto validate_credit;
> >>
> >> -               ksmbd_debug(SMB,
> >> +               pr_err_ratelimited(
> >>                             "cli req too short, len %d not %d. cmd:%d
> >> mid:%llu\n",
> >>                             len, clc_len, command,
> >>                             le64_to_cpu(hdr->MessageId));
> >> --
> >> 2.25.1
> >>
> >
> >
> > --
> > Thanks,
> >
> > Steve
> >



-- 
Thanks,

Steve
