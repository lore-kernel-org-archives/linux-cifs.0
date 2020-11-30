Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A50C63777
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 16:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08557206F9
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Nov 2020 16:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="PZgCGP4X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgK3Qe4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Nov 2020 11:34:56 -0500
Received: from mx.cjr.nz ([51.158.111.142]:19908 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728581AbgK3Qe4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 30 Nov 2020 11:34:56 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 80BDC7FD0A;
        Mon, 30 Nov 2020 16:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1606754054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WTa0ff6cwem8cj8OVg4AlsqrsW3370neU/TwedmOKco=;
        b=PZgCGP4Xt306kvHisOCuTSHgQA26/PRiZIH5L3smah05ty1BtpuTFq0tRUTfFm5CL48WU9
        jppbhSWUWZU9ReGuIUQO8YszGZGro8a0Q41u7cWKspa7O5TsdYpwSF08T48r5qHknKQoqx
        xPNTBuLL0DSTyv1GMSaT7b0d8xqCV317OVH4X6l4ZxmlWcUkVkQZS8CERWzoCKXjp3ChRd
        K6VkE+cvnT+g5QiYG46EwzrZTXDDvWnRvyGH+u15q7c60RtovmPtnV50sS+P30UpKNgD+J
        PnXezgIzulIG49GaH35vaBa1YUf5wYOkyZagQXaPQt7gnBh2/1W5j0C+/ayG5Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Steve French <smfrench@gmail.com>
Cc:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] cifs: allow syscalls to be restarted in __smb_send_rqst()
In-Reply-To: <CAH2r5msicAhu-NDzf+JxghVEj8dBRrDnMjGEKkE-DbrW=Dm64A@mail.gmail.com>
References: <20201128185706.8968-1-pc@cjr.nz> <87sg8rdtoj.fsf@suse.com>
 <87pn3vhua0.fsf@cjr.nz>
 <CAH2r5msicAhu-NDzf+JxghVEj8dBRrDnMjGEKkE-DbrW=Dm64A@mail.gmail.com>
Date:   Mon, 30 Nov 2020 13:34:09 -0300
Message-ID: <87pn3uhkhq.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Steve French <smfrench@gmail.com> writes:

> On Mon, Nov 30, 2020 at 7:02 AM Paulo Alcantara <pc@cjr.nz> wrote:
>>
>> Aur=C3=A9lien Aptel <aaptel@suse.com> writes:
>>
>> > Paulo Alcantara <pc@cjr.nz> writes:
>> >> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
>> >> index e27e255d40dd..55853b9ed13d 100644
>> >> --- a/fs/cifs/transport.c
>> >> +++ b/fs/cifs/transport.c
>> >> @@ -338,10 +338,8 @@ __smb_send_rqst(struct TCP_Server_Info *server, =
int num_rqst,
>> >>      if (ssocket =3D=3D NULL)
>> >>              return -EAGAIN;
>> >>
>> >> -    if (signal_pending(current)) {
>> >> -            cifs_dbg(FYI, "signal is pending before sending any data=
\n");
>> >> -            return -EINTR;
>> >> -    }
>> >> +    if (signal_pending(current))
>> >> +            return -ERESTARTSYS;
>> >
>> > Can we keep the debug message call?
>>
>> Yes.
>>
>> Steve, could you please update for-next with above debug msg?
>
> Done. Please check to see if my lightly modified debug message text is ok.

OK for me.  Thanks!
