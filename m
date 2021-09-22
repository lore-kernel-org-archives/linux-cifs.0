Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4DB8C433F5
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A95D0611C6
	for <linux-cifs@archiver.kernel.org>; Wed, 22 Sep 2021 04:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231718AbhIVE6e (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhIVE6d (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 22 Sep 2021 00:58:33 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CC4C061574
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 21:57:04 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id v10so437116edj.10
        for <linux-cifs@vger.kernel.org>; Tue, 21 Sep 2021 21:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xBAIVuXfmdsp7irpFqrlsEPbHk81Q/Op0npMNkgH5YE=;
        b=jOOm9Fk5CUj27TDmqaeDtqnAerbh8fj/8kVrVfHkic8YXtja4IRaf6MqtN8ihnELTo
         atRiN6TUH+7iTw71z+MGxjviJsAz40Re5E9LkvdYF/CFeeJGwsrV/2UXMos8s+dBEYEG
         h6k1t4O7vRN/+EDYBQxMnS/xGxts4P5q/vPy6h9S+mTuesYKFUpG6GAaPyvTKIJpOXKw
         6GJ5DbK1ysgd94rAIx1RhkShKaW5sjblO8qqQaLQeEp8t+tzyl7ph/FsCX03UmDWMnIp
         Qd2B/MNspJ7mfu2fpeVaXUtTSelZcpzbcvPl0/soLxAp08JLfgRQ2ND4L3fkNh+eHqGE
         50vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xBAIVuXfmdsp7irpFqrlsEPbHk81Q/Op0npMNkgH5YE=;
        b=k37PRLDsF8pN0XHJJENgEmQWxPzaLvAbeD4+saEdvvMB7shrstUvpGkZ/EcfUOftKg
         7dna8PT//FKhzITUrZVSVWqKf2ISacmlxpkrVb/joBMWTuNIuqg/MKVcsEDaQ0oYq+h6
         HvN899nQFO43k1BPRtxP6vPAFVuTfguDDAQekJWEfTdY6Czt1biu0GR1DOykJVMlnNbc
         ketyrhwXx+aoNbMVTICdmpdb4J36haIV/Ucx9vj8Dn0gAuozYCF+ZJNw5qNQrqTr/uur
         CB/N22apaXBPCmoo9S2WdWJDaOehfX9TIARfA48beqznl/f/b8ewtcsAZ1XG0ywL2LLE
         yE5w==
X-Gm-Message-State: AOAM5326+WcciyYBNe/40xihBptV3AiHPJ+MFVXGtRGuviQqE4FSvPTq
        hQtQdMg7QNP9AoIhGfKY5G1wHkjUSs8Q/+LEe0c=
X-Google-Smtp-Source: ABdhPJwykwwKy5X+DTz1rPj8UYSmFSrHWXax2F15uVgcoONiMehxUHK4UscReZhE3Hn2IuQY1Wd0j4GW53l4bWWEoD8=
X-Received: by 2002:a17:906:aeda:: with SMTP id me26mr39530036ejb.83.1632286622732;
 Tue, 21 Sep 2021 21:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210921225109.6388-1-linkinjeon@kernel.org> <20210921225109.6388-3-linkinjeon@kernel.org>
 <CAN05THSRTAC4Na+_cMwTFEJ3WrmKQMUjq_0Tmn44RE2KHhVA3A@mail.gmail.com> <CAKYAXd9aXjjG==AExp5ydbLjQm_WsU9Ev_aPokhqhTwTFTvX4g@mail.gmail.com>
In-Reply-To: <CAKYAXd9aXjjG==AExp5ydbLjQm_WsU9Ev_aPokhqhTwTFTvX4g@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 22 Sep 2021 14:56:50 +1000
Message-ID: <CAN05THST2Avwo4PebF4YmH65SrO-T3nS=jrs5cQMwT-vCW17-Q@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ksmbd: fix invalid request buffer access in
 compound request
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Wed, Sep 22, 2021 at 2:35 PM Namjae Jeon <linkinjeon@kernel.org> wrote:
>
> 2021-09-22 9:39 GMT+09:00, ronnie sahlberg <ronniesahlberg@gmail.com>:
> > On Wed, Sep 22, 2021 at 8:51 AM Namjae Jeon <linkinjeon@kernel.org> wro=
te:
> >>
> >> Ronnie reported invalid request buffer access in chained command when
> >> inserting garbage value to NextCommand of compound request.
> >> This patch add validation check to avoid this issue.
> >>
> >> Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
> >> Cc: Ralph B=C3=B6hme <slow@samba.org>
> >> Cc: Steve French <smfrench@gmail.com>
> >> Reported-by: Ronnie Sahlberg <lsahlber@redhat.com>
> >> Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
> >> ---
> >>  v2:
> >>   - fix integer overflow from work->next_smb2_rcv_hdr_off.
> >>
> >>  fs/ksmbd/smb2pdu.c | 7 +++++++
> >>  1 file changed, 7 insertions(+)
> >>
> >> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> >> index 1fe37ad4e5bc..cae796ea1148 100644
> >> --- a/fs/ksmbd/smb2pdu.c
> >> +++ b/fs/ksmbd/smb2pdu.c
> >> @@ -466,6 +466,13 @@ bool is_chained_smb2_message(struct ksmbd_work
> >> *work)
> >>
> >>         hdr =3D ksmbd_req_buf_next(work);
> >>         if (le32_to_cpu(hdr->NextCommand) > 0) {
> >> +               if ((u64)work->next_smb2_rcv_hdr_off +
> >> le32_to_cpu(hdr->NextCommand) >
> >> +                   get_rfc1002_len(work->request_buf)) {
> >> +                       pr_err("next command(%u) offset exceeds smb ms=
g
> >> size\n",
> >> +                              hdr->NextCommand);
> >> +                       return false;
> >> +               }
> >> +
> >>                 ksmbd_debug(SMB, "got SMB2 chained command\n");
> >>                 init_chained_smb2_rsp(work);
> >>                 return true;
> >
> > Very good, reviewed by me.
> Sorry for late response, Thanks for your review!
> > The conditional though, since you know there will be at least a full
> > smb2 header there you could already check that change it to
> >> +               if ((u64)work->next_smb2_rcv_hdr_off +
> >> le32_to_cpu(hdr->NextCommand) >
> >> +                   get_rfc1002_len(work->request_buf) +  64) {
> Ah, I didn't understand why we should add + 64(smb2 hdr size)...
> As I know, NextCommand offset included smb2 header size..

This is what I meant.
+               if ((u64)work->next_smb2_rcv_hdr_off +
le32_to_cpu(hdr->NextCommand) + 64 >
+                   get_rfc1002_len(work->request_buf)) {

It could just be an early check that what hdr->NextCommand points to
has at least 64 bytes.
I.e. an early test that "does the next PDU have at least a full smb2 header=
?"

I mean, since you already test that NextCommand is valid,  you could
at the same time also
test that the next pdu is at least 64 bytes.

> >
> >
> > Which leads to another question.  Where do you check that the buffer
> > contains enough data to hold the smb2 header and the full fixed part
> > of the request?
> ksmbd_smb2_check_message() in smb2misc.c should check it.
>
> > There is a check that you have enough space for the smb2 header in
> > ksmbd_conn_handler_loop()
> > that there is enough space for the smb2 header
> > (ksmbd_pdu_size_has_room()) but that function assumes that the smb2
> > header always start at the head of the buffer.
> > So if you have a compound chain, this functrion only checks the first p=
du.
> I think that is_chained_smb2_message() will check all pdu as well as firs=
t pdu.
> there is loop do { } while (is_chained_smb2_message(work)); in server.c
> >
> >
> > I know that the buffer handling is copied from the cifs client.  It
> > used to also do these "just pass a buffer around and the first 4 bytes
> > is the size" (and still does for smb1)  and there was a lot of
> > terrible +4 or -4 to all sort of casts and conditionals.
> > I changed that in cifs.ko to remove the 4 byte length completely from
> > the buffer.
> > I also changed it as part of the compounding to pass an array of
> > requests (each containing an iovector) to the functions instead of
> > just one large byte array.
> > That made things a lot easier to manage since you could then assume
> > that the SMB2 header would always start at offset 0 in the
> > corresponding iovector, even for compounded commands since they all
> > had their own private vector.
> > And since an iovector contains both a pointer and a length there is no
> > need anymore to read the first 4 bytes/validate them/and covnert into
> > a length all the time.
> Right. fully agreed.
>
> >
> > I think that would help, but it would be a MAJOR amount of work, so
> > maybe that should wait until later.
> Agreed, I will do that after fixing current urgent issues first!
>
> > That approach is very nice since it completely avoids keeping track of
> > offset-to-where-this-pdu-starts which makes all checks and
> > conditionals so much more complex.
> Thanks!
> >
> >
> > regards
> > ronnie sahlberg
> >
> >
> >> --
> >> 2.25.1
> >>
> >
