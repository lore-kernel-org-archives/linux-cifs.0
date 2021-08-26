Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B691DC432BE
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 18:07:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B7C460F4A
	for <linux-cifs@archiver.kernel.org>; Thu, 26 Aug 2021 18:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235411AbhHZSIO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 26 Aug 2021 14:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbhHZSIO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 26 Aug 2021 14:08:14 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8EBC061757
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 11:07:26 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id u14so8095395ejf.13
        for <linux-cifs@vger.kernel.org>; Thu, 26 Aug 2021 11:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tO0fDFfzVqCpFSh7jDAJRClUEDYWSYEy1PQeh6Xd5NU=;
        b=aUHHsgHPCEFtThTUQ1pWMTbRyD6SWsKFihGIEAdv/NqfAVkd/du3stdJy0RmfgQOFI
         rk9/5wLNw0PP4oWhktJk/WXnhppWlAOOrqY9o4BMtbHdPhieziwjKY2gxA1Pm17egwPF
         fQFjwfddkRqwx7OhADbOi6ixfevLPhIIAKcKv4BTL7mWrOKRkzGATLNSBDOtVwCUxpwX
         DWslGOKL3Xm+1c0PR35nOmDpEM9H2W5nzFizqDZHQrC3tJTAjPS0Dkq7szwLSJFFIwSy
         TPMtUj9GR20mxs6/RVndG+//SEKjkEXxLlrP3hs9sUEDQvZezHWIykqIjVU52C3APfJu
         FaVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tO0fDFfzVqCpFSh7jDAJRClUEDYWSYEy1PQeh6Xd5NU=;
        b=YkSs6hskj5QAGcSeM+ogGv4gjyg7fRKvZJJt7szatyhDKuB/L6uNRA3y/5scKTOYTh
         fZq2+3QGkSoCB3nhFeYkNF+e9NDYOwr9LcAW+8+QvnoGvG6EdtEqcIoTqdPqAW6LmB+J
         crOWzUgVubjrNjKYCaZNYEHF77F6pbVYuNI3Uq88/k0ObykMeLmyuHi+6SNIsfXhRgtn
         lQu33RZl5I+tdOFtoRD5hgwWtsFkzgWPzWyukbOtwpAkwSfcRzEnDK9s2WBQEhhoNGTr
         59UmDKhb0v3L1BXl7SqN7U19ttFoFXZK0aS8E6/j8XNaYTjH+2xiPW/6aIUiN1pmSk0h
         4x/A==
X-Gm-Message-State: AOAM531usuRLVGID8fWc7Zte1jc+gWkgjBv2zu2z9ajmhsECaMyLkXMP
        PPq73S/kHex1UlDJ2++Uv1OfK3Rz1JPEMsqZ87M=
X-Google-Smtp-Source: ABdhPJzGEB/rqcpNsZL/ztQZKvuHOFrrVIGiHvoW5koBLjzm21rIF3GSMmIrZzo/2tWj2BBRs2fiqmuHLUuyTX3vv8Q=
X-Received: by 2002:a17:906:ae4f:: with SMTP id lf15mr5533555ejb.124.1630001244885;
 Thu, 26 Aug 2021 11:07:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210825111656.1635954-1-lsahlber@redhat.com> <20210825111656.1635954-2-lsahlber@redhat.com>
 <CAH2r5ms2KzVf-7ei2+m_GbwcvZ7PHTCbv33bhNaH9dXXWcVO1w@mail.gmail.com> <CANT5p=pU449WrEOpC5iGSrZAMqmM223vZSwxfLf51pN9=B0Sng@mail.gmail.com>
In-Reply-To: <CANT5p=pU449WrEOpC5iGSrZAMqmM223vZSwxfLf51pN9=B0Sng@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 27 Aug 2021 04:07:13 +1000
Message-ID: <CAN05THRdzjTMfOwp-oQwQFZg8+_8dySOqXFcPQj89w=XFh1ahg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Do not leak EDEADLK to dgetents64 for STATUS_USER_SESSION_DELETED
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 27, 2021 at 3:16 AM Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> On Thu, Aug 26, 2021 at 2:39 AM Steve French <smfrench@gmail.com> wrote:
> >
> > lightly updated to add short sleep before retry
> >
> >
> > On Wed, Aug 25, 2021 at 6:17 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > >
> > > RHBZ: 1994393
> > >
> > > If we hit a STATUS_USER_SESSION_DELETED for the Create part in the
> > > Create/QueryDirectory compound that starts a directory scan
> > > we will leak EDEADLK back to userspace and surprise glibc and the application.
> > >
> > > Pick this up initiate_cifs_search() and retry a small number of tries before we
> > > return an error to userspace.
> > >
> > > Cc: stable@vger.kernel.org
> > > Reported-by: Xiaoli Feng <xifeng@redhat.com>
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > ---
> > >  fs/cifs/readdir.c | 19 ++++++++++++++++++-
> > >  1 file changed, 18 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
> > > index bfee176b901d..4518e3ca64df 100644
> > > --- a/fs/cifs/readdir.c
> > > +++ b/fs/cifs/readdir.c
> > > @@ -369,7 +369,7 @@ int get_symlink_reparse_path(char *full_path, struct cifs_sb_info *cifs_sb,
> > >   */
> > >
> > >  static int
> > > -initiate_cifs_search(const unsigned int xid, struct file *file,
> > > +_initiate_cifs_search(const unsigned int xid, struct file *file,
> > >                      const char *full_path)
> > >  {
> > >         __u16 search_flags;
> > > @@ -451,6 +451,23 @@ initiate_cifs_search(const unsigned int xid, struct file *file,
> > >         return rc;
> > >  }
> > >
> > > +static int
> > > +initiate_cifs_search(const unsigned int xid, struct file *file,
> > > +                    const char *full_path)
> > > +{
> > > +       int rc, retry_count = 0;
> > > +
> > > +       do {
> > > +               rc = _initiate_cifs_search(xid, file, full_path);
> > > +               /*
> > > +                * We don't have enough credits to start reading the
> > > +                * directory so just try again.
> > > +                */
> > > +       } while (rc == -EDEADLK && retry_count++ < 5);
> > > +
> > > +       return rc;
> > > +}
> > > +
> > >  /* return length of unicode string in bytes */
> > >  static int cifs_unicode_bytelen(const char *str)
> > >  {
> > > --
> > > 2.30.2
> > >
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
> Hi Ronnie,
>
> EDEADLK is returned in wait_for_compound_request, when num of credits
> is 0, but there are no in flight requests to get more credits from.
> Why did we reach here in the first place? If we already found
> STATUS_USER_SESSION_DELETED, why are we waiting for another request?

USER_SESSION_DELETED means the session is bad and needs to be
reconnected which is why we can not get any credits.
We can't get any credits until later until later been reconnected.

If this happens from smb2_query_dir_first, the first attempt with
USER_SESSION_DELETED will cause the session to need a reconnect
and return -EAGAIN.
While we have a retry on -EAGAIN here in this function, I don;t it can
handle cases where we have both EAGAIN but also
a situation where the session is dead and needs reconnect (which also
means  no credits).
I think we are too deep in the call-stack and with too many things
locked that we can not reconnect the session right now.
Thus the retry on EAGAIN turns into a EDEADLK.

The EDEADLK is then returned through the stack all the way back to
cifs_readdir() where we don't have all these things locked and thus a
re-try will actually trigger a reconnect and we recover.


It is easy to reproduce with scrambla and the small error inject patch I posted.
Every third "ls /mountpoint" will return a USERS_SESSION_DELETED to
smb2_query_dir_first which you can then see leaking -EDEADLK to the ls
command if you strace it.


BTW. I really want to start using scrambla in our buildbot since it
will allow us to do a lot of error injection from server side and test
that we can recover correctly from them in the client.

(scrambla is ~5k lines of python3   and is a lot less intimidating to
patch to inject errors than full blown samba)


>
> --
> Regards,
> Shyam
