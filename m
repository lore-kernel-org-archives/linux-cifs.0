Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63429C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 05:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D2A6611B0
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 05:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231908AbhIVFgn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 01:36:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232187AbhIVFgn (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 22 Sep 2021 01:36:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C968611B0
        for <linux-cifs@vger.kernel.org>; Wed, 22 Sep 2021 05:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632288914;
        bh=UPFlQixmorWd13IwM+CAFBFO2XUjAZs65OTx6EWwVNE=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=rBARetmw3+9Rp2elI0lEXSvMXsijNeheQNlaP766KsPYkLyw9mygWkNKPdaImTgUU
         Yo0xpRwKsIWWFLFbNERu992Da/6o/cMhcTa4ZROHycDySB5Um9AS/c9gn5xEhgpx5Z
         ZlUSO3uhMnMziJVTxQYNFNGF6OgO/uENwPMv68ad+F+fh1B1a8QxgPGBBsJ/Ev4e17
         i5KXxboEuA9twKfvwRipdI64Eqwd8P0HgOsOWsUxsv3uO4pevAsbgMZL8cy8KjwzAz
         ByaqFkjPRfUpTTb4TYL02BbX0YZhRe45j0sMWgJak+h5Kc1ylCY76bwIQQM1WsZ7uX
         4M6Gc505FRZsw==
Received: by mail-oi1-f176.google.com with SMTP id a3so2785945oid.6
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 22:35:14 -0700 (PDT)
X-Gm-Message-State: AOAM531YQDbSCx1/UeAcz/2GeS3aE53VgcfBRibpnGFXz7kZt9JbcD8m
        TJylTocr8l8/Ttv94WNFjSHCCuRrIyADYhFQZW4=
X-Google-Smtp-Source: ABdhPJwG3hY4PD1Iz+cpTAKSCh0MirrS7ni2K1G/8A5fij+VdK7CczdYlWLTpOyUNwW/oHm3tCKHxnbuzrFTwHo0RMw=
X-Received: by 2002:a05:6808:21a7:: with SMTP id be39mr1164416oib.138.1632288913426;
 Tue, 21 Sep 2021 22:35:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Tue, 21 Sep 2021 22:35:12
 -0700 (PDT)
In-Reply-To: <CAN05THST2Avwo4PebF4YmH65SrO-T3nS=jrs5cQMwT-vCW17-Q@mail.gmail.com>
References: <20210921225109.6388-1-linkinjeon@kernel.org> <20210921225109.6388-3-linkinjeon@kernel.org>
 <CAN05THSRTAC4Na+_cMwTFEJ3WrmKQMUjq_0Tmn44RE2KHhVA3A@mail.gmail.com>
 <CAKYAXd9aXjjG==AExp5ydbLjQm_WsU9Ev_aPokhqhTwTFTvX4g@mail.gmail.com> <CAN05THST2Avwo4PebF4YmH65SrO-T3nS=jrs5cQMwT-vCW17-Q@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Wed, 22 Sep 2021 14:35:12 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-_DXbu6q_osn5_qq9yie8ZCjRnyCMjF=bFdgraD7Pcfw@mail.gmail.com>
Message-ID: <CAKYAXd-_DXbu6q_osn5_qq9yie8ZCjRnyCMjF=bFdgraD7Pcfw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ksmbd: fix invalid request buffer access in
 compound request
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2021-09-22 13:56 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> On Wed, Sep 22, 2021 at 2:35 PM Namjae Jeon <linkinjeon@kernel.org> wrote=
:
>>
>> 2021-09-22 9:39 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
>> > On Wed, Sep 22, 2021 at 8:51 AM Namjae Jeon <linkinjeon@kernel.org>
>> > wrote:
>> >>
>> >> Ronnie reported invalid request buffer access in chained command when
>> >> inserting garbage value to NextCommand of compound request.
>> >> This patch add validation check to avoid this issue.
>> >>
>> >> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
>> >> Cc: Ralph B=C3=B6hme <slow@samba.org>
>> >> Cc: Steve French <smfrench@gmail.com>
>> >> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
>> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
>> >> ---
>> >>  v2:
>> >>   - fix integer overflow from work->next_smb2_rcv_hdr_off.
>> >>
>> >>  fs/ksmbd/smb2pdu.c | 7 +++++++
>> >>  1 file changed, 7 insertions(+)
>> >>
>> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
>> >> index 1fe37ad4e5bc..cae796ea1148 100644
>> >> --- a/fs/ksmbd/smb2pdu.c
>> >> +++ b/fs/ksmbd/smb2pdu.c
>> >> @@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work
>> >> *work)
>> >>
>> >>         hdr =3D ksmbd_req_buf_next(work);
>> >>         if (le32_to_cpu(hdr->NextCommand) > 0) {
>> >> +               if ((u64)work->next_smb2_rcv_hdr_off +
>> >> le32_to_cpu(hdr->NextCommand) >
>> >> +                   get_rfc1002_len(work->request_buf)) {
>> >> +                       pr_err("next command(%u) offset exceeds smb
>> >> msg
>> >> size\n",
>> >> +                              hdr->NextCommand);
>> >> +                       return false;
>> >> +               }
>> >> +
>> >>                 ksmbd_debug(SMB, "got SMB2 chained command\n");
>> >>                 init_chained_smb2_rsp(work);
>> >>                 return true;
>> >
>> > Very good, reviewed by me.
>> Sorry for late response, Thanks for your review!
>> > The conditional though, since you know there will be at least a full
>> > smb2 header there you could already check that change it to
>> >> +               if ((u64)work->next_smb2_rcv_hdr_off +
>> >> le32_to_cpu(hdr->NextCommand) >
>> >> +                   get_rfc1002_len(work->request_buf) +  64) {
>> Ah, I didn't understand why we should add + 64(smb2 hdr size)...
>> As I know, NextCommand offset included smb2 header size..
>
> This is what I meant.
> +               if ((u64)work->next_smb2_rcv_hdr_off +
> le32_to_cpu(hdr->NextCommand) + 64 >
> +                   get_rfc1002_len(work->request_buf)) {
>
> It could just be an early check that what hdr->NextCommand points to
> has at least 64 bytes.
> I.e. an early test that "does the next PDU have at least a full smb2
> header?"
>
> I mean, since you already test that NextCommand is valid,  you could
> at the same time also
> test that the next pdu is at least 64 bytes.
Understood, I will update it on v3.

Thanks!
>
>> >
>> >
>> > Which leads to another question.  Where do you check that the buffer
>> > contains enough data to hold the smb2 header and the full fixed part
>> > of the request?
>> ksmbd_smb2_check_message() in smb2misc.c should check it.
>>
>> > There is a check that you have enough space for the smb2 header in
>> > ksmbd_conn_handler_loop()
>> > that there is enough space for the smb2 header
>> > (ksmbd_pdu_size_has_room()) but that function assumes that the smb2
>> > header always start at the head of the buffer.
>> > So if you have a compound chain, this functrion only checks the first
>> > pdu.
>> I think that is_chained_smb2_message() will check all pdu as well as fir=
st
>> pdu.
>> there is loop do { } while (is_chained_smb2_message(work)); in server.c
>> >
>> >
>> > I know that the buffer handling is copied from the cifs client.  It
>> > used to also do these "just pass a buffer around and the first 4 bytes
>> > is the size" (and still does for smb1)  and there was a lot of
>> > terrible +4 or -4 to all sort of casts and conditionals.
>> > I changed that in cifs.ko to remove the 4 byte length completely from
>> > the buffer.
>> > I also changed it as part of the compounding to pass an array of
>> > requests (each containing an iovector) to the functions instead of
>> > just one large byte array.
>> > That made things a lot easier to manage since you could then assume
>> > that the SMB2 header would always start at offset 0 in the
>> > corresponding iovector, even for compounded commands since they all
>> > had their own private vector.
>> > And since an iovector contains both a pointer and a length there is no
>> > need anymore to read the first 4 bytes/validate them/and covnert into
>> > a length all the time.
>> Right. fully agreed.
>>
>> >
>> > I think that would help, but it would be a MAJOR amount of work, so
>> > maybe that should wait until later.
>> Agreed, I will do that after fixing current urgent issues first!
>>
>> > That approach is very nice since it completely avoids keeping track of
>> > offset-to-where-this-pdu-starts which makes all checks and
>> > conditionals so much more complex.
>> Thanks!
>> >
>> >
>> > regards
>> > ronnie sahlberg
>> >
>> >
>> >> --
>> >> 2.25.1
>> >>
>> >
>
