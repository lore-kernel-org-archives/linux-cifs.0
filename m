Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C689CC0015E
	for <linux-cifs@archiver.kernel.org>; Wed, 26 Jul 2023 17:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjGZRtj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 Jul 2023 13:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjGZRti (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 Jul 2023 13:49:38 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39233121
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 10:49:37 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 38308e7fff4ca-2b9b5ee9c5aso15457411fa.1
        for <linux-cifs@vger.kernel.org>; Wed, 26 Jul 2023 10:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690393775; x=1690998575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xtHGJcxA0BwveoHcF09gNsufnYQmNMRUhlbUeH6uahE=;
        b=LIe9/RWk0GOftxXD6/OiM4JdkEmMDj2vrN2RblqePChsUSfEiPSeJdUVicDGX+VHtw
         R6fUmGgPcnWapIFfD80/aLklUECjCKmeAvkA8XLBkyqypRH7abe459jCWNonxiYEFxiH
         tf9SgCLvhOd/YwBXcCY07zSXGBa6kCix2IdEvRqxhpKA20p+bsgGVLeIkciHvmukz0iP
         1JJ6Ok+bjMVMB1Dxj+Nod7X3Y/JI3qkodjVNbIsG1pNrcBjyW++ki99+JBgj/AY7n/iF
         CyR7P8rCWNHEJvFnyOpujY2MSJngvXmz9QmVkN5/O6OiAISKjmCCXOkgr0fEla1XoQK7
         80TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690393775; x=1690998575;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xtHGJcxA0BwveoHcF09gNsufnYQmNMRUhlbUeH6uahE=;
        b=M7rNjxMqP7P5/KOmtfXTxE6AGiNYcl6pfUlT4FzilOdMcr5QK9HenP/eGKPbPJLpgQ
         6c4TGQsduvLmIJ0IvOiwbunBQ9D+uy8RlqcnQnaJ02Vje6OMVhQak9QU5oyR34AwW54t
         MB7ePwoHV06Ve/5TxK43F2THRWrAlbwiNOTEiBwt3byLqayiqV/IIG279RZf8h0hQ5qL
         eqPGVq0JvlsefqmcxzGWcl/0bHv3+BGS0q8GBMfI6GLZzrOSyyO+5p16FbnunbqlOpQ+
         Zgyt81fBjFxQW56xqXtlzJH2iqtNlGxINShtb85D5UNRZrJ3WlOsBQvNulzFqmazY12Q
         rSiA==
X-Gm-Message-State: ABy/qLYzSn1xNaTMoKPIt9ma5ULh8EsvqpeuKVBOGze8SPXjR2wkVOCu
        YamKXrFxtkLliNN/BwTU43tXRp7mO6RrKOBkeTs=
X-Google-Smtp-Source: APBJJlFY06gtWzgeJXOxFzIq5onqX45aR3tZmM+hZVtudaZJ2WzZFTew2X8L6/GSu4Qevf3vpPkGBFsZ+IqrLGjvlgA=
X-Received: by 2002:a2e:6e11:0:b0:2b9:563b:7e3a with SMTP id
 j17-20020a2e6e11000000b002b9563b7e3amr2066843ljc.32.1690393775089; Wed, 26
 Jul 2023 10:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <CANT5p=po=GSwj+bD_-uFWZ0r_ww5XbaV1pAauZecbmuzShmcpw@mail.gmail.com>
 <d14f85d1-ff05-94da-24bb-6a1e1afe29f6@talpey.com> <CANT5p=omTgEfjiXcpWjhg7h8GcBwGa7jOqHyjc5OmaeHQtMPEg@mail.gmail.com>
 <2515b155-ad0e-a147-b174-21bd25619a06@talpey.com>
In-Reply-To: <2515b155-ad0e-a147-b174-21bd25619a06@talpey.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Wed, 26 Jul 2023 23:19:23 +0530
Message-ID: <CANT5p=q=nJeTyobrxi28wOF-Op51rWc2pDxueyD=BRN_BQcFDQ@mail.gmail.com>
Subject: Re: Potential leak in file put
To:     Tom Talpey <tom@talpey.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Bharath SM <bharathsm.hsk@gmail.com>,
        Paulo Alcantara <pc@cjr.nz>,
        Enzo Matsumiya <ematsumiya@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Jul 21, 2023 at 7:21=E2=80=AFPM Tom Talpey <tom@talpey.com> wrote:
>
> On 7/21/2023 7:13 AM, Shyam Prasad N wrote:
> > Hi Tom,
> >
> > Thanks for these points.
> >
> > On Thu, Jul 20, 2023 at 8:21=E2=80=AFPM Tom Talpey <tom@talpey.com> wro=
te:
> >>
> >> On 7/19/2023 8:10 AM, Shyam Prasad N wrote:
> >>> Hi all,
> >>>
> >>> cifs.ko seems to be leaking handles occasionally when put under some
> >>> stress testing.
> >>> I was scanning the code for potential places where we could be
> >>> leaking, and one particular instance caught my attention.
> >>>
> >>> In _cifsFileInfo_put, when the ref count of a cifs_file reaches 0, we
> >>> remove it from the lists and then send the close request over the
> >>> wire...
> >>>           if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
> >>>                   struct TCP_Server_Info *server =3D tcon->ses->serve=
r;
> >>>                   unsigned int xid;
> >>>
> >>>                   xid =3D get_xid();
> >>>                   if (server->ops->close_getattr)
> >>>                           server->ops->close_getattr(xid, tcon, cifs_=
file);
> >>>                   else if (server->ops->close)
> >>>                           server->ops->close(xid, tcon, &cifs_file->f=
id);
> >>>                   _free_xid(xid);
> >>>           }
> >>>
> >>> But as you can see above, we do not have return value from the above =
handlers.
> >>
> >> Yeah, that's a problem. The most obvious is if the network becomes
> >> partitioned and the close(s) fail. Are you injecting that kind of
> >> error?
> >
> > So this was revealed with a stress testing setup where the mount was
> > done against a server that gave out only 512 credits per connection.
> > The connection was pretty much starved for credits, which threw up
> > out-of-credits errors occasionally.
> > I've confirmed that when it happens for close, there are handle leaks.
>
> Interesting. 512 credits doesn't seem like starvation, but it will
> definitely stress a high workload. Good!
>
> >> Still, the logic is going to grow some serious hair if we start
> >> retrying every error. What will bound the retries, and what kind
> >> of error(s) might be considered fatal? Tying up credits, message
> >> id's, handles, etc can be super problematic.
> >>
> >> Also, have you considered using some sort of laundromat? Or is it
> >> critical that these closes happen before proceeding?
> >>
> >
> > Steve and I discussed this yesterday. One option that came out was...
> > We could cleanup the handle locally and then keep retrying the server
> > close as a delayed work a fixed number of times.
> > If a specified limit is exceeded, reconnect the session so that we star=
t afresh.
>
> Sounds reasonable, but things might get a little tricky if the
> server-side handle has a lease or some other state still attached.
> A subsequent client create on the same file might encounter an
> unexpected conflict? It's critical to think that through.

You make a good point. I did think about this.
There are several cases here.
1. If the subsequent open is from another client B: This would force
the server to send a lease break to this client A. But since the
client has closed all local data for the handle (only the server close
is pending), the lease break would go unrecognized. That is not a good
thing to do. So we'll need to keep zombie handles lying around (and in
the list) till the file is actually closed on the server. We just need
to make sure we mark these handles as zombies so future opens to the
file do not reuse this handle.
2. If the subsequent open is from the same client A: If the client
cannot find the handle, it can try an open on the server. However,
that open could fail depending on the open mode by earlier handle. So
I think we could use the above idea of zombie handles here too, where
the new opens could be failed with a retriable error (EAGAIN?).

Do you see a problem with this approach?

>
> > I guess this is what you meant by laundromat?
>
> So by laundromat I meant background processing to handle the
> close. It would have some sort of queued work list, and it
> would process the work items and wash-dry-fold the results.
>
> The main motivation would be to release the thread that fell
> into the refcnt =3D=3D 0 so the calling application may continue.
> Stealing the thread for a full server roundtrip might be
> worth avoiding, in all cases.
>
> OTOH, if the tricky stuff above is risky or wrong, then forget
> the laundromat and don't return until the close is done. But
> then, think about ^C!
>
> Tom.
>
> >>> What would happen if the above close_getattr or close calls fail?
> >>> Particularly, what would happen if the failure happens even before th=
e
> >>> request is put in flight?
> >>> In this stress testing we have the server giving out lesser credits.
> >>> So with the testing, the credit counters on the active connections ar=
e
> >>> expected to be low in general.
> >>> I'm assuming that the above condition will leak handles.
> >>>
> >>> I was thinking about making a change to let the above handlers return
> >>> rc rather than void. And then to check the status.
> >>> If failure, create a delayed work for closing the remote handle. But
> >>> I'm not convinced that this is the right approach.
> >>> I'd like to know more comments on this.
> >>>
> >
> >
> >



--=20
Regards,
Shyam
