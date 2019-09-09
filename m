Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1808C4740C
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 18:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 895F8218AF
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 18:33:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AC4GpmrY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbfIISdQ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 14:33:16 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41447 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfIISdP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 9 Sep 2019 14:33:15 -0400
Received: by mail-lf1-f66.google.com with SMTP id j4so11311213lfh.8
        for <linux-cifs@vger.kernel.org>; Mon, 09 Sep 2019 11:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QjskRMnPO53a31StHOlftdIgNIEtKBWmmNDfsJ6BjIc=;
        b=AC4GpmrYHHhDRjoUpJlW1ZZ7ZT67R90+eD44/1WqG6CNdQ2sK2gCcOFAW7XTYL7t6/
         IbZSjVbRLvMGRY/TLMkkuYW6v4l+07BaJzZwPpKLw6tg8+ljMGSzTRolLBYlNRQsY4Gs
         LWcILBemtP4A6drgTRqnUuJuxUs455aEC/A7vZL5vZuiPhlJv7KW4xxveXbgN011eN7R
         /fFEWjxhttOaz9aCjviG5+2GiFITkj3iiYaiaPHSxaw00FKFzt2cBOazqqOcdfoKm+U3
         xN6EdJ/DuAgmzwQeJeh4LKHDL2AUw6vjgysOYYrZQXdJdz0MPVlk+yPVvkyzvzgoVELO
         JZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QjskRMnPO53a31StHOlftdIgNIEtKBWmmNDfsJ6BjIc=;
        b=RMvYMUt+gm2A3nAcr8Rtz99t2WSPtIKxpV4Oyx72JRczLSa6KRDhnFRSew1ArHFBiy
         LL4AgfDnzRmGYjjEjeqJ+lb+duvbGb7gkVWRRATRxBAvhpY118gsL15bUibs7bKyeihc
         bLveMy5DZld0oE/YrYTJs6LlUhayxfsriNPsIMH0DpignnzXa7FSr3jphK4rzNyz/jrO
         EiINAkGTCg4j4rFVf/9pPzkwYqNWwjNykau34fY2fe9AaVrihuRor7pu1Q0VkV4BRhDD
         ifVAHOz1xF/ygui4qgNaVHIu+Ha4AgcY4GeahNe/l6QNTiFntV/cLOEM1viBprH4us2P
         udfw==
X-Gm-Message-State: APjAAAWJkyzLWMGqp5I706ZDKZ1mrVuo6IS2JXV5jwnf1ov0gHA4//XU
        xckZpG2XmEO3KnJEuw4I7JZK1K7Wk7g++xhWAvI8i6E=
X-Google-Smtp-Source: APXvYqzXm7rpHtGsrn3gHcIuHXBOyIgKWGVe9xwO/uurG6gJiSAS8HtzVeL/ya3z25ite4is2U1RhvJnzNu1CxEg3JI=
X-Received: by 2002:a19:3805:: with SMTP id f5mr17246503lfa.173.1568053992354;
 Mon, 09 Sep 2019 11:33:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5msbRyGMY2XQifbxB0iU3a3EPp8UcemO8QE5bhq9HPMqBQ@mail.gmail.com>
 <CAH2r5mv=6dR+5nxJbw19C0QZf3wJQOc5j4CTGTZ=OABqMdQDpw@mail.gmail.com>
In-Reply-To: <CAH2r5mv=6dR+5nxJbw19C0QZf3wJQOc5j4CTGTZ=OABqMdQDpw@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 9 Sep 2019 11:33:01 -0700
Message-ID: <CAKywueTt4=vhQRUoVUPsLhJuHdaucB1avgdiY_oPEdrUi-akVw@mail.gmail.com>
Subject: Re: [SMB3][PATCHes] parallelizing decryption of large read responses
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 9 =D1=81=D0=B5=D0=BD=D1=82. 2019 =D0=B3. =D0=B2 07:21, Steve =
French <smfrench@gmail.com>:
>
> Had a minor typo in patch 2 - fixed in attached
>
> On Sun, Sep 8, 2019 at 11:31 PM Steve French <smfrench@gmail.com> wrote:
> >
> > I am seeing very good performance benefit from offload of decryption

This is great news!

> > of encrypted SMB3 read responses to a pool of worker threads
> > (optionally).  See attached patches.
> >
> > I plan to add another patch to only offload when number of requests in
> > flight is > 1 (since there is no point offloading and doing a thread
> > switch if no other responses would overlap in the cifsd thread reading
> > from the socket).

Good idea. The 2nd path looks good. See feedback from the 1st patch below:

+ mid =3D smb2_find_mid(dw->server, dw->buf);
+ if (mid =3D=3D NULL)
+ cifs_dbg(VFS, "mid not found\n"); /* BB FIXME? change to FYI? */

Yes, let's keep it the same - FYI - as the non-offloaded scenario.
---------------------

I think there is a race on mid structure between offloaded work items
and the demultiplex thread.

+ mid =3D smb2_find_mid(dw->server, dw->buf);

^^^
Here we took a reference to the mid...

+ if (mid =3D=3D NULL)
+ cifs_dbg(VFS, "mid not found\n"); /* BB FIXME? change to FYI? */
+ else {
+ mid->decrypted =3D true;
+ rc =3D handle_read_data(dw->server, mid, dw->buf,
^^^
...and the above call will dequeue the mid from the list. Between this
two steps the demultiplex thread might hit reconnect (cifs_reconnect)
and fire the mid callback.

+       dw->server->vals->read_rsp_size,
+       dw->ppages, dw->npages, dw->len);
+ }
+
+ dw->server->lstrp =3D jiffies;

The mid callback for async reads will fail the read request and then
call DeleteMidQEntry which resets the mid state to MID_FREE and do
other things we don't want to be done at this point.

So, I think the following needs to be done to avoid it:
1) dequeue the mid inside analog of smb2_find_mid() - let's say
smb2_find_mid_dequeue() and call it instead.
2) refactor handle_read_data() into two parts to separate mid handling
(part 1) and dequeue'ing (part2) - note, that the latter is being
called in non-negative return code cases.
3) call only the part 1 in the offloaded case because the mid has been
already dequeue'ed at the step 1.

+ mid->callback(mid);
+
+ cifs_mid_q_entry_release(mid);
+
+free_pages:
+ for (i =3D dw->npages-1; i >=3D 0; i--)
+ put_page(dw->ppages[i]);
+
+ kfree(dw->ppages);
+ cifs_small_buf_release(dw->buf);
+
+/* FIXME Do we need the equivalent of this? */

No, we don't need this because the entire packet has been received by
this point.

+/* discard_data:
+ cifs_discard_remaining_data(server); */
+}

--
Best regards,
Pavel Shilovsky
