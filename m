Return-Path: <SRS0=6quT=36=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D82C2BA83
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 01:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ABAF20838
	for <linux-cifs@archiver.kernel.org>; Mon, 10 Feb 2020 01:11:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ve2SbpN6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgBJBLh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 9 Feb 2020 20:11:37 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:40316 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725943AbgBJBLh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 9 Feb 2020 20:11:37 -0500
Received: by mail-il1-f196.google.com with SMTP id i7so4334240ilr.7
        for <linux-cifs@vger.kernel.org>; Sun, 09 Feb 2020 17:11:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CeNtkSklQ6Pd35h7IwiK0RqaUEPuBFk0L5GWDWJ0x2E=;
        b=ve2SbpN6cjkmq5onzGvvROk811eat3PZ9/f6C4CgwcCWxeBpJgFb+D3y0dG+NtMei1
         gCIeTrW2aWZiYVe2H2g+IX7QUkdzSxJOYhiHkxSghO6ctBiirlHv3McFHcZkbO+BChTO
         XBG612Z1YR8Qcq79shFXBGFPPRs3iPeZaftlxcf6HpISaii9Yyy+CNluuOsyOY+tho8S
         DRtP+NfTHO3nrrwLkno51gT+4TIAwWHtET+cycnXu1XyWSK6hU7R8cFKF13e3tC84+/O
         Kp2VK52kCCc/QCM0cinhnex89h7AssQsMX3pNh1H2sNOwlO7Ud9nAqQPus53IvmjEMI7
         IeqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CeNtkSklQ6Pd35h7IwiK0RqaUEPuBFk0L5GWDWJ0x2E=;
        b=CZ1FuV6rbnOyUUqJ0kGNxyz7nWbF7cSX1zsaRhIEV84QfvdevG14oGTnHT1CIQ0Sl4
         rAWNhktyqnqpBXpLv2FpYKMR/YoSDLrD1oh4a04YxOAiTBPm9JRb9o8QHl+yzkBeQVbZ
         Y2GzMbAWk/fPZdQyBjPt7pnaCTFde6zgOLI4A+aRdEIOz87RkrgrF8L6APxNBtmfccUX
         Br/dNyXlj3+vDCun+gC33rhi8OcEJ54oV37bTT2tNomBbDaaTy84SnMNPQ7drqbfLw5A
         /e6vnCsutU58ifeRGfqGkTEw/xLxKpMTTOCvOpC9Xi5jO45CEFIQwimhkg9cnaC1iKTU
         R7gw==
X-Gm-Message-State: APjAAAU1sGHpDjk2haD+L2rmuUr9DzoFGVhTRtJFircfKvX5HI1WSHe2
        e03pkWiz+0/JwXhY1cgt0VvlfEGzLWnMfxGKjD8=
X-Google-Smtp-Source: APXvYqyi1zWfrUwai7RorIs+sQOjF5vn5OGv48C93lvXzzl4GY3hqdX82bTobEz1UuPkeYEaX78BhJeOrhvRHKtqtyM=
X-Received: by 2002:a92:7301:: with SMTP id o1mr9945745ilc.272.1581297096599;
 Sun, 09 Feb 2020 17:11:36 -0800 (PST)
MIME-Version: 1.0
References: <20200208145058.10429-1-aaptel@suse.com> <CAH2r5mvSBraHGj=ZcjK3QqUbdya67uYs8vScyh_Bh5dKKmzfYg@mail.gmail.com>
In-Reply-To: <CAH2r5mvSBraHGj=ZcjK3QqUbdya67uYs8vScyh_Bh5dKKmzfYg@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 9 Feb 2020 19:11:25 -0600
Message-ID: <CAH2r5mv+cPyQkLgNOyYexSF4Z1KUDMbmx2hQHNxoT6e2NJ1HEg@mail.gmail.com>
Subject: Re: [PATCH 1/3] cifs: rename posix create rsp
To:     Aurelien Aptel <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Also FYI - I cleaned up a few checkpatch warnings and sparse compile warnings

On Sun, Feb 9, 2020 at 7:00 PM Steve French <smfrench@gmail.com> wrote:
>
> tentatively merged into cifs-2.6.git for-next pending more testing
>
> On Sat, Feb 8, 2020 at 8:51 AM Aurelien Aptel <aaptel@suse.com> wrote:
> >
> > little progress on the posix create response.
> >
> > * rename struct to create_posix_rsp to match with the request
> >   create_posix context
> > * make struct packed
> > * pass smb info struct for parse_posix_ctxt to fill
> > * use smb info struct as param
> > * update TODO
> >
> > What needs to be done:
> >
> > SMB2_open() has an optional smb info out argument that it will fill.
> > Callers making use of this are:
> >
> > - smb3_query_mf_symlink (need to investigate)
> > - smb2_open_file
> >
> > Callers of smb2_open_file (via server->ops->open) are passing an
> > smbinfo struct but that struct cannot hold POSIX information. All the
> > call stack needs to be changed for a different info type. Maybe pass
> > SMB generic struct like cifs_fattr instead.
> >
> > Signed-off-by: Aurelien Aptel <aaptel@suse.com>
> > ---
> >  fs/cifs/smb2pdu.c | 13 +++++++++----
> >  fs/cifs/smb2pdu.h |  9 ++++++---
> >  2 files changed, 15 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index 1234f9ccab03..7d4d7cdb2eb4 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -1940,13 +1940,18 @@ parse_query_id_ctxt(struct create_context *cc, struct smb2_file_all_info *buf)
> >  }
> >
> >  static void
> > -parse_posix_ctxt(struct create_context *cc, struct smb_posix_info *pposix_inf)
> > +parse_posix_ctxt(struct create_context *cc, struct smb2_file_all_info *info)
> >  {
> > -       /* struct smb_posix_info *ppinf = (struct smb_posix_info *)cc; */
> > +       /* struct create_posix_rsp *posix = (struct create_posix_rsp *)cc; */
> >
> > -       /* TODO: Need to add parsing for the context and return */
> > +       /*
> > +        * TODO: Need to add parsing for the context and return. Can
> > +        * smb2_file_all_info hold POSIX data? Need to change the
> > +        * passed type from SMB2_open.
> > +        */
> >         printk_once(KERN_WARNING
> >                     "SMB3 3.11 POSIX response context not completed yet\n");
> > +
> >  }
> >
> >  void
> > @@ -1984,7 +1989,7 @@ smb2_parse_contexts(struct TCP_Server_Info *server,
> >                         parse_query_id_ctxt(cc, buf);
> >                 else if ((le16_to_cpu(cc->NameLength) == 16)) {
> >                         if (memcmp(name, smb3_create_tag_posix, 16) == 0)
> > -                               parse_posix_ctxt(cc, NULL);
> > +                               parse_posix_ctxt(cc, buf);
> >                 }
> >                 /* else {
> >                         cifs_dbg(FYI, "Context not matched with len %d\n",
> > diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> > index fa03df130f1a..c84405ed603c 100644
> > --- a/fs/cifs/smb2pdu.h
> > +++ b/fs/cifs/smb2pdu.h
> > @@ -1604,11 +1604,14 @@ struct smb2_file_id_information {
> >  extern char smb2_padding[7];
> >
> >  /* equivalent of the contents of SMB3.1.1 POSIX open context response */
> > -struct smb_posix_info {
> > +struct create_posix_rsp {
> >         __le32 nlink;
> >         __le32 reparse_tag;
> >         __le32 mode;
> > -       kuid_t  uid;
> > -       kuid_t  gid;
> > +       /*
> > +         var sized owner SID
> > +         var sized group SID
> > +       */
> > +} __packed;
> >  };
> >  #endif                         /* _SMB2PDU_H */
> > --
> > 2.16.4
> >
>
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
