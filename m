Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23172C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 19:54:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE8712183E
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 19:54:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lv1lFVfM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbfCUTyP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:54:15 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41422 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727997AbfCUTyP (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Mar 2019 15:54:15 -0400
Received: by mail-qt1-f196.google.com with SMTP id w30so8059818qta.8;
        Thu, 21 Mar 2019 12:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MRKLK9gBnoYYx6Y6j7M5HzDcfhy056wwZ+RSVQMIoLA=;
        b=Lv1lFVfM8CFxQ9gkG/NmyfcqMOvQHsMPC/41CeaQgKjuP1/6tQIgVMg18Uqk4g0SEb
         +0X/tCaoxw5Q/q1RFmsCxCMUjqyU8IOb3/dc9FM1yLWbUlXKx7k6nSHpLlBg8cA5xbEL
         HTBLLnqjbOxTLQOA9Z30a7orEy2qeLC4k4LgJEmSLIOojj8cfsNvi7rqgFr7amB9mOZY
         g860kapiB5o2qYdGZBKapWWwpWCKe5VmItrJhaNqUq28Hg4aqbq9/4eNd8qgvmDhaz7W
         0MoG01H49/XtjwJf2UaMdwWyS7jBQ1yPa8wEPlLUlp1t6phg/w+gHsMDzQnvANfYoS6F
         Z5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MRKLK9gBnoYYx6Y6j7M5HzDcfhy056wwZ+RSVQMIoLA=;
        b=arTgFKLycjI5ixrwhb2yG9hO4bmIQC2z2i0AE+oZ4qJasBLdepchhWI7zKuOcE8ZSW
         faZNZbvwBnFDl2pvCDBloU63O95QE10SJIJ02fwPIju91uFLT3gdqMAWuTxa4XiirFq2
         bCryfo7o/LjS1KD6vUHbHlUhkdZy3TDRF4ghtqtUFeWalVODXho7Da9eHYePAkK9AcML
         2otGgTQZRe4+NC1hjBj9PvtiycGf+AbKMxVxSxCJlSMuSFbp02pyVK2nqPAeuukePaOZ
         d6cSm0+T+4IfebCArTwcQ+AzJ1HZnGyaoINrUB6uku4d73G4n/qgxrp2M6i5Nbkg6ST6
         xkuQ==
X-Gm-Message-State: APjAAAUJwosi1h1iBcEIWcHBw8pu3EfDMuspkdb3yi4mn5Ivml4VZEWi
        w9MeIWmX2yW7YGAoESQ9TJ9IDjWAnO6wn/ajGKE=
X-Google-Smtp-Source: APXvYqxp7TUbvMmYd6TcGy/Wsd4CymegdQnoTChPDxulBzvbiAsol8/ICeHHIsJvW24Bgnicr584/ndH1KxFhpVlk18=
X-Received: by 2002:a0c:be81:: with SMTP id n1mr4702052qvi.226.1553198053183;
 Thu, 21 Mar 2019 12:54:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190321045902.14326-1-lsahlber@redhat.com> <CANYNYEHur0w8iNZBHUbc=NJopAH84gLb5k-Wv1ShU9--qREoCw@mail.gmail.com>
In-Reply-To: <CANYNYEHur0w8iNZBHUbc=NJopAH84gLb5k-Wv1ShU9--qREoCw@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 22 Mar 2019 05:54:01 +1000
Message-ID: <CAN05THSL-KCQ6QNm2fUERY1oHWC_jgfdWHuEO_0gnwLMM3TX1A@mail.gmail.com>
Subject: Re: [PATCH] cifs: allow guest mounts to work for smb3.11
To:     Andreas Hasenack <andreas@canonical.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Mar 22, 2019 at 3:13 AM Andreas Hasenack <andreas@canonical.com> wrote:
>
> Hello Ronnie,
>
> On Thu, Mar 21, 2019 at 1:59 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> >
> > Fix Guest/Anonymous sessions so that they work with SMB 3.11.
> >
> > In git commit 6188f28 tightened the conditions and forced signing for
> > the SMB2-TreeConnect commands as per MS-SMB2.
> > However, this should only apply to normal user sessions and not for
> > Guest/Anonumous sessions.
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > CC: Stable <stable@vger.kernel.org>
> > ---
> >  fs/cifs/smb2pdu.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > index c399e09b76e6..8e4a1da95418 100644
> > --- a/fs/cifs/smb2pdu.c
> > +++ b/fs/cifs/smb2pdu.c
> > @@ -1628,9 +1628,13 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
> >         iov[1].iov_base = unc_path;
> >         iov[1].iov_len = unc_path_len;
> >
> > -       /* 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1 */
> > +       /*
> > +        * 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1
> > +        * unless it is guest or anonymous user. See MS-SMB2 3.2.5.3.1
> > +        */
> >         if ((ses->server->dialect == SMB311_PROT_ID) &&
> > -           !smb3_encryption_required(tcon))
> > +           !smb3_encryption_required(tcon) &&
> > +           !(ses->session_flags & (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)))
> >                 req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
> >
> >         memset(&rqst, 0, sizeof(struct smb_rqst));
> > --
> > 2.13.6
> >
>
>
> I tried this patch with an ubuntu kernel
> (https://people.canonical.com/~tyhicks/disco-cifs.2/ specifically) but
> it didn't work, I'm still getting failures with smb3.11 and a guest
> mount.
>
> Maybe I'm missing some other fix, or a more up-to-date kernel? Shall I
> try with a self-compiled upstream one?

Try with the current version of Steve's for-next branch plus this patch.
I could reproduce the failure with 3.11 on for-next
but when I added this patch then the mount was successful.

At least that would verify that the current for-net works for you (or not).
There may be other things missing in older kernels that broke 3.11 guest mounts,
but lets check if for-next works first.

Regards
Ronnie Sahlberg

>
> dmesg: http://paste.ubuntu.com/p/JGhCsgBVcb/
>
> server logs (debug level 5, samba 4.10.0):
> log.: http://paste.ubuntu.com/p/jMDJ8DBfRM/
> log.smbd: http://paste.ubuntu.com/p/Z9W5z28BP9/
> smb.conf: http://paste.ubuntu.com/p/9HpSyFq8n8/
