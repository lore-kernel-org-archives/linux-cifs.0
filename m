Return-Path: <SRS0=7c9k=RZ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1D35C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Mar 2019 23:30:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 858D9218D3
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Mar 2019 23:30:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mKOYrMMD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726056AbfCVXaf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Mar 2019 19:30:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42892 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbfCVXaf (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Mar 2019 19:30:35 -0400
Received: by mail-pf1-f195.google.com with SMTP id r15so2504890pfn.9;
        Fri, 22 Mar 2019 16:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L7urqEfdLrcVYwroBy9HQZdRv87RuxWTvZzJgWcuFjU=;
        b=mKOYrMMDUFIwWq+3BgNbQnAt4rLnVcCdrnzXEDmDbkyBVisymJktrkwsdIoTial8Xu
         p4jcMWOE5FKKJHqi36mn4qBvkQhUr0EaUqk3Z8ylQn6Lctac4BYpfLXFK/ZarbM590AQ
         PQhpOa36CsO8WDK495j5rj3m9+BO+f1u0Cu7oRcp+JaFo/vKrAUrx1iPP5qmg4lRyeP4
         xYfUssfLHtRljIGpwsJ8nPda/Hf6LAHCRZnntTtA9urZLH2Cb80VeqytTJVZwaRbsk61
         8t0AmOBOuZ83niI5D4cYzNpUKHlv1H1OK1SfG8z+DbcDB4n/sr/+LVNYqhnH1GZIxy++
         UjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7urqEfdLrcVYwroBy9HQZdRv87RuxWTvZzJgWcuFjU=;
        b=DELmTFaR/mXCD3MRM2Q0bUVrmS0DHK1EsqYiqMIiU57wx+LqoN74zzZKxIzuqu952l
         +NtCBTp+LYSz/Q6zl9o/roA/Zyrh+FlwLIe58sR6pg8CW9hv1F8mFZVAL6rQcjjI0mrk
         lLJt6kj9wX5gEM8nm4yAH1tJA/ok5fHYZxGa8AkBpX+KNZh46EOQwUJ8+x0xpkUdtbmM
         kF9EWsv6D0IU1npuXQ+IcIIOnePaZhZ+8PkxS1fXyjQUHJEWVyBvSEFSw2jIyHlQvp16
         Xuea1bFwJg8mug+zYOubf6QUAqQN7qVcjT1DfvUP+GiL7z7haqKSa12tWg+iJdntvQ50
         sKnQ==
X-Gm-Message-State: APjAAAV44Nybh54kARK9bFhx3sodvjUdITEeIw//Kv3w+v3Hgh8D9564
        NaG8s5clSAkhLcFweco+w2bt1r4HoUU0/7nDyOVyKw==
X-Google-Smtp-Source: APXvYqzuqg8GAUNGZw4QNsLpFTAJPqMXDExL+JpU1M/f0U7vl+A6zdq+aIEgOFOEzMcUaHrmKGw7DDvQFFd9xPVihYY=
X-Received: by 2002:a17:902:b618:: with SMTP id b24mr11569532pls.73.1553297434652;
 Fri, 22 Mar 2019 16:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190321045902.14326-1-lsahlber@redhat.com> <CANYNYEHur0w8iNZBHUbc=NJopAH84gLb5k-Wv1ShU9--qREoCw@mail.gmail.com>
 <CAN05THSL-KCQ6QNm2fUERY1oHWC_jgfdWHuEO_0gnwLMM3TX1A@mail.gmail.com>
In-Reply-To: <CAN05THSL-KCQ6QNm2fUERY1oHWC_jgfdWHuEO_0gnwLMM3TX1A@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 22 Mar 2019 18:30:23 -0500
Message-ID: <CAH2r5mua942M3C=8Mionj_JbjRm5LRm+=+f1SW3404a-k6naFQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: allow guest mounts to work for smb3.11
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Andreas Hasenack <andreas@canonical.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I tried to Samba with guest mount and noted that Samba server did not
set the guest or null flags in the session setup response so we still
marked tcon as signed even with guest mount in my quick test (to Samba
4.10)

On Thu, Mar 21, 2019 at 2:54 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Fri, Mar 22, 2019 at 3:13 AM Andreas Hasenack <andreas@canonical.com> wrote:
> >
> > Hello Ronnie,
> >
> > On Thu, Mar 21, 2019 at 1:59 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > >
> > > Fix Guest/Anonymous sessions so that they work with SMB 3.11.
> > >
> > > In git commit 6188f28 tightened the conditions and forced signing for
> > > the SMB2-TreeConnect commands as per MS-SMB2.
> > > However, this should only apply to normal user sessions and not for
> > > Guest/Anonumous sessions.
> > >
> > > Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> > > CC: Stable <stable@vger.kernel.org>
> > > ---
> > >  fs/cifs/smb2pdu.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> > > index c399e09b76e6..8e4a1da95418 100644
> > > --- a/fs/cifs/smb2pdu.c
> > > +++ b/fs/cifs/smb2pdu.c
> > > @@ -1628,9 +1628,13 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
> > >         iov[1].iov_base = unc_path;
> > >         iov[1].iov_len = unc_path_len;
> > >
> > > -       /* 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1 */
> > > +       /*
> > > +        * 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1
> > > +        * unless it is guest or anonymous user. See MS-SMB2 3.2.5.3.1
> > > +        */
> > >         if ((ses->server->dialect == SMB311_PROT_ID) &&
> > > -           !smb3_encryption_required(tcon))
> > > +           !smb3_encryption_required(tcon) &&
> > > +           !(ses->session_flags & (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)))
> > >                 req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
> > >
> > >         memset(&rqst, 0, sizeof(struct smb_rqst));
> > > --
> > > 2.13.6
> > >
> >
> >
> > I tried this patch with an ubuntu kernel
> > (https://people.canonical.com/~tyhicks/disco-cifs.2/ specifically) but
> > it didn't work, I'm still getting failures with smb3.11 and a guest
> > mount.
> >
> > Maybe I'm missing some other fix, or a more up-to-date kernel? Shall I
> > try with a self-compiled upstream one?
>
> Try with the current version of Steve's for-next branch plus this patch.
> I could reproduce the failure with 3.11 on for-next
> but when I added this patch then the mount was successful.
>
> At least that would verify that the current for-net works for you (or not).
> There may be other things missing in older kernels that broke 3.11 guest mounts,
> but lets check if for-next works first.
>
> Regards
> Ronnie Sahlberg
>
> >
> > dmesg: http://paste.ubuntu.com/p/JGhCsgBVcb/
> >
> > server logs (debug level 5, samba 4.10.0):
> > log.: http://paste.ubuntu.com/p/jMDJ8DBfRM/
> > log.smbd: http://paste.ubuntu.com/p/Z9W5z28BP9/
> > smb.conf: http://paste.ubuntu.com/p/9HpSyFq8n8/



-- 
Thanks,

Steve
