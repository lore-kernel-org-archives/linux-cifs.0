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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75CAEC433B4
	for <linux-cifs@archiver.kernel.org>; Sun,  2 May 2021 04:06:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 491BD61408
	for <linux-cifs@archiver.kernel.org>; Sun,  2 May 2021 04:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbhEBEGu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 May 2021 00:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhEBEGu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 May 2021 00:06:50 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3609C06174A
        for <linux-cifs@vger.kernel.org>; Sat,  1 May 2021 21:05:59 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id n138so3168012lfa.3
        for <linux-cifs@vger.kernel.org>; Sat, 01 May 2021 21:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d3Mx25mIfY/NWQQXEqlAycCuo/zi3tJ4++mdSAEETq0=;
        b=rAn88flmBrpuNZW+vCLhNf7UUbnNkxqGOgoVmkpBh8OJpK3DxGKscjdYnj4+70R4+4
         M2sepISORmBq2TcxoBlYR4OVy/SHsQPdZmF9/V15kXLh/UOukI/wK1lHjYD3PHSxrIR8
         ecut88yQ5oncNywlSEdQTAJ6kRiBOKt0GYcarId82uCb6u7nYS0JOvWYzc/64yf4wBqz
         66Qc9Eklt1CTsxRMS1bQpLrikBsw5aXzjT6Vf619Js3wJWdLmThtiejO6DLkEPBH2q8j
         W9fd/O+zU0OXVbJH1G7C9tryk60NnRLumkbLz287q4DH4/gacsRRZ7n1Wcv6FV75z9k5
         6iXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d3Mx25mIfY/NWQQXEqlAycCuo/zi3tJ4++mdSAEETq0=;
        b=q143U8YCiplPrQSWPNuJDRbxr2IeKKBfDG/4zmvF9qh8T4383fX59dkrF2rc6Xg1jU
         +/nWYMrdHmhBxiwSwzbAQ5+hKf1gDugRknBZVXtjv1hWuYG9zdLkur/mmhuXlu/LcOGX
         Xgzq/nVGT9xrPCiHS7xp5AeM311H5om7hwuPvMUQ5oAmbMOl5xk6/81HrHln6E92fpWl
         ksiLfn6leO5ytO9cRXbPL0XDIxBXZ7f0jays0NbqWQN/QquAAaU3Bc223yfspeuYQ0P+
         lS46vuSYrVmKBrumGchuBoTxXuVjNZDHaFlquGV3x4irQf9Ba+gB6dM5CG+4zL3wxjDn
         mKXQ==
X-Gm-Message-State: AOAM530Wv9gLTKcVMQnhVsfUdzVnKzG9zMwiw7ww9HKPCZ6MywG52Wsc
        V1NJCUe2Euli5lrbCHK1D8TL0qSkRgdhU+DsZ04=
X-Google-Smtp-Source: ABdhPJzmF0alC1S/wWz4TigdR5VYpPYghRpp9P8e6LVuqPsCihIIVnfxq9iWWni8MKS9OjYTXn66oiIgh/5r3U1V2gA=
X-Received: by 2002:a19:e21d:: with SMTP id z29mr4309446lfg.175.1619928357792;
 Sat, 01 May 2021 21:05:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
 <CAN05THQzSCZwypBWg9YZAarjrsQ74qowp4Bneo3crW9FfqVqPA@mail.gmail.com>
 <CAH2r5muu3YiBAk1Mf_xOFQJih8Ms7sQhNUKwUrFreggK-Mmr-A@mail.gmail.com>
 <CANT5p=rGGNdVjBSTZm1OsecEW=-5edZhZwBjSU1Q8d8dO+JsPA@mail.gmail.com> <CAN05THTmZCNXsH4_i=0CO6CaVOYuZ=z5XHW+U_=q3Djxz6XxBA@mail.gmail.com>
In-Reply-To: <CAN05THTmZCNXsH4_i=0CO6CaVOYuZ=z5XHW+U_=q3Djxz6XxBA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 1 May 2021 23:05:46 -0500
Message-ID: <CAH2r5msrS0Ox86NgpfUrwv_MPEU7pYGdG=JfYwK9Btia6W8PLA@mail.gmail.com>
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve debugging
 of encrypted shares
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I think it is reasonably easy to read in an optional SUID (smb session
uid) as a parm on the new "DUMP_FULL_KEY" ioctl - less code to add in
the followon patch.  Will spin something up later tonight

On Sat, May 1, 2021 at 3:49 PM ronnie sahlberg <ronniesahlberg@gmail.com> wrote:
>
> On Sat, May 1, 2021 at 8:53 PM Shyam Prasad N <nspmangalore@gmail.com> wrote:
> >
> > Looks good to me.
> >
> > On a related note, we need a way for the root user to dump keys for
> > another SMB session to the same path. This will be useful for
> > mutli-user scenario.
> > i.e. for dumping keys for SMB session as another user.
> > Since we're adding a new IOCTL, perhaps we should add another arg
> > which identifies the user? Maybe based on the UID:GID of the user
> > session, in addition to the path supplied?
>
> Or as an alternative, dump an array of ALL user sessions with
> information about which user and which part of a multi-channel
> connection that the keys belong to.
> And let userspace sort out "which keys do I need for my wireshark session".
>
> >
> > Regards,
> > Shyam
> >
> > On Sat, May 1, 2021 at 9:49 AM Steve French <smfrench@gmail.com> wrote:
> > >
> > > changed as suggested - see attached
> > >
> > > On Fri, Apr 30, 2021 at 11:00 PM ronnie sahlberg
> > > <ronniesahlberg@gmail.com> wrote:
> > > >
> > > > These elements should probably be [32] and not
> > > > + __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> > > >
> > > > Because this is now visible to userspace and we can not allow this to
> > > > ever change.
> > > > Because when GCM512 is eventually released, if we bump
> > > > SMB3_ENC_DEC_KEY_SIZE to a larger value we suddenly break userspace.
> > > >
> > > >
> > > > On Sat, May 1, 2021 at 8:20 AM Steve French <smfrench@gmail.com> wrote:
> > > > >
> > > > > Previously we were only able to dump CCM or GCM-128 keys (see "smbinfo
> > > > > keys" e.g.)
> > > > > to allow network debugging (e.g. wireshark) of mounts to SMB3.1.1 encrypted
> > > > > shares.  But with the addition of GCM-256 support, we have to be able to dump
> > > > > 32 byte instead of 16 byte keys which requires adding an additional ioctl
> > > > > for that.
> > > > >
> > > > > Signed-off-by: Steve French <stfrench@microsoft.com>
> > > > > ---
> > > > >  fs/cifs/cifs_ioctl.h | 19 +++++++++++++++++++
> > > > >  fs/cifs/ioctl.c      | 33 +++++++++++++++++++++++++++++++++
> > > > >  2 files changed, 52 insertions(+)
> > > > >
> > > > > diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> > > > > index f262c64516bc..9f2ed9cccb08 100644
> > > > > --- a/fs/cifs/cifs_ioctl.h
> > > > > +++ b/fs/cifs/cifs_ioctl.h
> > > > > @@ -57,6 +57,12 @@ struct smb_query_info {
> > > > >   /* char buffer[]; */
> > > > >  } __packed;
> > > > >
> > > > > +/*
> > > > > + * Dumping the commonly used 16 byte (e.g. CCM and GCM128) keys still supported
> > > > > + * for backlevel compatibility, but is not sufficient for dumping the less
> > > > > + * frequently used GCM256 (32 byte) keys (see the newer "CIFS_DUMP_FULL_KEY"
> > > > > + * ioctl for dumping decryption info for GCM256 mounts)
> > > > > + */
> > > > >  struct smb3_key_debug_info {
> > > > >   __u64 Suid;
> > > > >   __u16 cipher_type;
> > > > > @@ -65,6 +71,18 @@ struct smb3_key_debug_info {
> > > > >   __u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
> > > > >  } __packed;
> > > > >
> > > > > +/*
> > > > > + * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
> > > > > + * is needed if GCM256 (stronger encryption) negotiated
> > > > > + */
> > > > > +struct smb3_full_key_debug_info {
> > > > > + __u64 Suid;
> > > > > + __u16 cipher_type;
> > > > > + __u8 auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
> > > > > + __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> > > > > + __u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> > > > > +} __packed;
> > > > > +
> > > > >  struct smb3_notify {
> > > > >   __u32 completion_filter;
> > > > >   bool watch_tree;
> > > > > @@ -78,6 +96,7 @@ struct smb3_notify {
> > > > >  #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info)
> > > > >  #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug_info)
> > > > >  #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
> > > > > +#define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct
> > > > > smb3_full_key_debug_info)
> > > > >  #define CIFS_IOC_SHUTDOWN _IOR ('X', 125, __u32)
> > > > >
> > > > >  /*
> > > > > diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> > > > > index ef41fa878793..e4321e2a27d2 100644
> > > > > --- a/fs/cifs/ioctl.c
> > > > > +++ b/fs/cifs/ioctl.c
> > > > > @@ -218,6 +218,7 @@ long cifs_ioctl(struct file *filep, unsigned int
> > > > > command, unsigned long arg)
> > > > >  {
> > > > >   struct inode *inode = file_inode(filep);
> > > > >   struct smb3_key_debug_info pkey_inf;
> > > > > + struct smb3_full_key_debug_info pfull_key_inf;
> > > > >   int rc = -ENOTTY; /* strange error - but the precedent */
> > > > >   unsigned int xid;
> > > > >   struct cifsFileInfo *pSMBFile = filep->private_data;
> > > > > @@ -354,6 +355,38 @@ long cifs_ioctl(struct file *filep, unsigned int
> > > > > command, unsigned long arg)
> > > > >   else
> > > > >   rc = 0;
> > > > >   break;
> > > > > + /*
> > > > > + * Dump full key (32 bytes instead of 16 bytes) is
> > > > > + * needed if GCM256 (stronger encryption) negotiated
> > > > > + */
> > > > > + case CIFS_DUMP_FULL_KEY:
> > > > > + if (pSMBFile == NULL)
> > > > > + break;
> > > > > + if (!capable(CAP_SYS_ADMIN)) {
> > > > > + rc = -EACCES;
> > > > > + break;
> > > > > + }
> > > > > +
> > > > > + tcon = tlink_tcon(pSMBFile->tlink);
> > > > > + if (!smb3_encryption_required(tcon)) {
> > > > > + rc = -EOPNOTSUPP;
> > > > > + break;
> > > > > + }
> > > > > + pfull_key_inf.cipher_type =
> > > > > + le16_to_cpu(tcon->ses->server->cipher_type);
> > > > > + pfull_key_inf.Suid = tcon->ses->Suid;
> > > > > + memcpy(pfull_key_inf.auth_key, tcon->ses->auth_key.response,
> > > > > + 16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
> > > > > + memcpy(pfull_key_inf.smb3decryptionkey,
> > > > > +       tcon->ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
> > > > > + memcpy(pfull_key_inf.smb3encryptionkey,
> > > > > +       tcon->ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZE);
> > > > > + if (copy_to_user((void __user *)arg, &pfull_key_inf,
> > > > > + sizeof(struct smb3_full_key_debug_info)))
> > > > > + rc = -EFAULT;
> > > > > + else
> > > > > + rc = 0;
> > > > > + break;
> > > > >   case CIFS_IOC_NOTIFY:
> > > > >   if (!S_ISDIR(inode->i_mode)) {
> > > > >   /* Notify can only be done on directories */
> > > > >
> > > > > --
> > > > > Thanks,
> > > > >
> > > > > Steve
> > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> >
> >
> >
> > --
> > Regards,
> > Shyam



-- 
Thanks,

Steve
