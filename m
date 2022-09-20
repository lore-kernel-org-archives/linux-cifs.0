Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D1DC54EE9
	for <linux-cifs@archiver.kernel.org>; Tue, 20 Sep 2022 04:36:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiITEgP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 20 Sep 2022 00:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiITEgO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 20 Sep 2022 00:36:14 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD7D4B0DB
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:36:13 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id c23so601823uan.5
        for <linux-cifs@vger.kernel.org>; Mon, 19 Sep 2022 21:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=twxg2EwBH6Th5xPwhS3wtFygdeXEDxqPlU3AW9rbD1c=;
        b=TMRK7esi+SxRL9WmVf+9T9nYjbQ+zybw6ushj+xT2PEwe/nG/mlYxd/p+sGYMG6xje
         AQPMOZHYrKPRYdV2QPPXbencwbwdcfq/axLgsAGTjRFRgjp2jx/ynrGwqpKfCxvPV9Nz
         qrf6IK0fNo//+kUgg8r0fZSszikqRIH3JwbnA8CIwbfZG0tDnz+F04NGd9NCJV7evDZo
         JAqyuQisSy3ZhO7H02y3BYm2pZFjahxJHBxiIvCtQOUgX75zBMLUXr+6heVuwpYMuJsJ
         EsLMmtYEMY/3N5oe3U0118tZ7hQQFQW+ZPmBvUEUmd11DC3lMfumlDpjbFAeRhfZUWlG
         BPtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=twxg2EwBH6Th5xPwhS3wtFygdeXEDxqPlU3AW9rbD1c=;
        b=VboDtnBum9qVj2WFUaDINmmbXanYLWDCnbGUKiePH18GBAh78uzx2EELgwcE3ZpEWC
         qIO6OPiiKkCMGPBb5LvC7EUNZ8d80XAbioFkaFDAfZvYDzc7bo8m6JFHKP8gT87KbSyw
         SZdo51l3RwXHc8AlopvsOUFSlvt0U9nlhKhyYmCHpBJNlCYy8Wy8N+Z1JlZ/OeGp7NRi
         WugqoZVfKCY1lEYVm6gRZuwA2ubT+kUGPeVh++MePA53Bgw6xFjZbhBTjwFIiA2YpeDX
         +uHLrX54klTS6vNFeJS3gyHr8uCyyFuhEximEMrhBue7J3uDbuT9QLyTqHMgUqjaWnaR
         PPnw==
X-Gm-Message-State: ACrzQf08bMB9UhPwOvAZ/T+2DdDy3JKC4HQr7DqmnLWJYgE0pcTK34YS
        xQ6pfed3luWEWW+XTCWEok2Bvv+1RN92g3GrBdw=
X-Google-Smtp-Source: AMsMyM4AlYpoA2908+N7zkFo8iOCPmEzGHYRmapsgBbR81FmoIyjIiPl5tkJhQnOaiWqWCaTJwbn4veVlygFB/J1d78=
X-Received: by 2002:ab0:3f0c:0:b0:383:f357:9c02 with SMTP id
 bt12-20020ab03f0c000000b00383f3579c02mr7742410uab.19.1663648572249; Mon, 19
 Sep 2022 21:36:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220916235705.14044-1-ematsumiya@suse.de> <CAN05THQbwrs0Y0OmfeoBDb9Gf109BoKx8vPrmUuzBC726CMX5A@mail.gmail.com>
In-Reply-To: <CAN05THQbwrs0Y0OmfeoBDb9Gf109BoKx8vPrmUuzBC726CMX5A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 19 Sep 2022 23:36:01 -0500
Message-ID: <CAH2r5mveDGZi=5AkuSBM339GWDJgq6M1Un8E=EHVVYuu8ukB0A@mail.gmail.com>
Subject: Re: [PATCH] cifs: return correct error in ->calc_signature()
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
        pc@cjr.nz, nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Sep 16, 2022 at 8:04 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> reviewed by me
>
> On Sat, 17 Sept 2022 at 09:57, Enzo Matsumiya <ematsumiya@suse.de> wrote:
> >
> > If an error happens while getting the key or session in the
> > ->calc_signature implementations, 0 (success) is returned. Fix it by
> > returning a proper error code.
> >
> > Since it seems to be highly unlikely to happen wrap the rc check in
> > unlikely() too.
> >
> > Fixes: 32811d242ff6 ("cifs: Start using per session key for smb2/3 for signature generation")
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/cifs/smb2transport.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> > index 1a5fc3314dbf..4640fc4a8b13 100644
> > --- a/fs/cifs/smb2transport.c
> > +++ b/fs/cifs/smb2transport.c
> > @@ -225,9 +225,9 @@ smb2_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
> >         struct smb_rqst drqst;
> >
> >         ses = smb2_find_smb_ses(server, le64_to_cpu(shdr->SessionId));
> > -       if (!ses) {
> > +       if (unlikely(!ses)) {
> >                 cifs_server_dbg(VFS, "%s: Could not find session\n", __func__);
> > -               return 0;
> > +               return -ENOENT;
> >         }
> >
> >         memset(smb2_signature, 0x0, SMB2_HMACSHA256_SIZE);
> > @@ -557,8 +557,10 @@ smb3_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server,
> >         u8 key[SMB3_SIGN_KEY_SIZE];
> >
> >         rc = smb2_get_sign_key(le64_to_cpu(shdr->SessionId), server, key);
> > -       if (rc)
> > -               return 0;
> > +       if (unlikely(rc)) {
> > +               cifs_server_dbg(VFS, "%s: Could not get signing key\n", __func__);
> > +               return rc;
> > +       }
> >
> >         if (allocate_crypto) {
> >                 rc = cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
> > --
> > 2.35.3
> >



-- 
Thanks,

Steve
