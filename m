Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0D60C433B4
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 18:39:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F5061408
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Apr 2021 18:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241122AbhD2SkM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Apr 2021 14:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbhD2SkM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Apr 2021 14:40:12 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF300C06138B
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 11:39:24 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id c11so2388393lfi.9
        for <linux-cifs@vger.kernel.org>; Thu, 29 Apr 2021 11:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tZhwg6jpiGwejPtU4vB5ZQzdh3q+pfO366ow6R419v8=;
        b=hcOhjUthXEbvwIsr7TUibOQ6or2Sx49VQhpU307UhoGLHlPCFdirbddXqm9Ny+/lXg
         bmnHPmsXFXX05+J2qKYHvYDAaqfISo8/60P323He1X/dQOFiC/sGmkzF/spT6kvcX3lA
         XyWjOGTMcRTdS1AOV1IzTrlwQSjv+wAcvck818InA1+Qq0l6+RmL2wqQH9oMNYaDcNbY
         8L3XwjBOix0bntBiixBVZwjx5jgi9NQI8Hnlw0ZelSom7gs216mU/WyO9dLFA3CGmTNS
         G0vDJwiE+j5P5kiQJ/Tm5HBdTyAal63LXPglQSpED10nekNEiizaCKXfgtY3YYcrVztz
         mhaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tZhwg6jpiGwejPtU4vB5ZQzdh3q+pfO366ow6R419v8=;
        b=BLU1/9u5vBPD6VhfFVsy0MuuNfL7Y7SHQb8MmXhgV83aZMCpWt48/JJL/SZBf8ZVnt
         20bCdt0bhjZmkOqxDq5bFvc7VhCOIIk0/cb2ogON/i9G/xVQn4OgQdwPLyrT6PEq3dqB
         cFQzZWVb5Cr3nPJRCnQ1qdvk4bFUYzKGVROcicTiMWxkv6MFfH8oUceSJ7atsrdun3Wc
         uDA/FLjw/coSVwihgmkddr5e1u7CXtGYhnw8ZrD3wVN6snVfctVR6AIuSct4ftkmIAwK
         HRNNOkS1KcjXM1vWfEqom5jbxpH0N49kQ4x5z9ZeHyXKqnniFRWxUxbphNSMMEvroUqI
         0gCQ==
X-Gm-Message-State: AOAM5317ziLc6JXUhDvp0l316np3Zh3qxxlTeKs9s8feh40uTyh1CjBW
        SFhzqruZxzBRPeCItGsejr0DWtQj2xJFNDeds4UCbN9q49w=
X-Google-Smtp-Source: ABdhPJzPVHsCMaugSI07HqZ6l28e1ThY1+FMXM8m33pW/cDiddwc0vd3vbHN5BR6mc0jQWpNgILG1yeq5s0S8TUoH10=
X-Received: by 2002:a19:f504:: with SMTP id j4mr627240lfb.307.1619721563371;
 Thu, 29 Apr 2021 11:39:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mvKfohJ=NkkCM7AxqRYq2+D8kRMTxP3VdG=W0s72Cdh0A@mail.gmail.com>
 <8735v9wiad.fsf@suse.com>
In-Reply-To: <8735v9wiad.fsf@suse.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 29 Apr 2021 13:39:12 -0500
Message-ID: <CAH2r5msnQ4YjJee2FSKPRknNEWsD61V-hvw15m7L3_qBY+Nk1g@mail.gmail.com>
Subject: Re: [PATCH] cifs: add shutdown support
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

You are correct - I have to add the code to clear the bit on remount

I have added your other changes and will send updated patch after lunch

root@smfrench-ThinkPad-P52:~# mount | grep cifs
//localhost/test on /mnt1 type cifs
(rw,relatime,vers=3D3.1.1,cache=3Dstrict,username=3Dsmfrench,uid=3D0,noforc=
euid,gid=3D0,noforcegid,addr=3D127.0.0.1,file_mode=3D0755,dir_mode=3D0755,s=
oft,nounix,serverino,mapposix,noperm,rsize=3D4194304,wsize=3D4194304,bsize=
=3D1048576,echo_interval=3D60,actimeo=3D1)
root@smfrench-ThinkPad-P52:~# touch /mnt1/file
root@smfrench-ThinkPad-P52:~# ~smfrench/xfstests-dev/src/godown /mnt1/
root@smfrench-ThinkPad-P52:~# touch /mnt1/file
touch: cannot touch '/mnt1/file': Input/output error
root@smfrench-ThinkPad-P52:~# mount -o remount /mnt1
root@smfrench-ThinkPad-P52:~# touch /mnt1/file
touch: cannot touch '/mnt1/file': Input/output error

On Thu, Apr 29, 2021 at 4:29 AM Aur=C3=A9lien Aptel <aaptel@suse.com> wrote=
:
>
>
> Do we need to add code to clear the flag on remount or is it implicitely
> cleared by not copying it?
>
> Steve French <smfrench@gmail.com> writes:
> >  #define CIFS_MOUNT_MODE_FROM_SID 0x10000000 /* retrieve mode from
> > special ACE */
> >  #define CIFS_MOUNT_RO_CACHE 0x20000000  /* assumes share will not chan=
ge */
> >  #define CIFS_MOUNT_RW_CACHE 0x40000000  /* assumes only client accessi=
ng */
> > +#define SMB3_MOUNT_SHUTDOWN 0x80000000
>
> While I totally understand wanting to remove the "cifs" name, those
> flags are specific to the kernel & filesystem and have nothing to do
> with the wire protocol so in this case I would rather use CIFS_ prefix
> because SMB3_ is misleading and all the other flags are already using CIF=
S_.
>
> One day we should do s/CIFS/SMBFS/i on the whole tree where CIFS refers
> to kernel stuff (not protocol) and rename the module smbfs. But that's a
> story for another day I guess.
>
> >
> >  struct cifs_sb_info {
> >   struct rb_root tlink_tree;
> > diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> > index 153d5c842a9b..a744022d2a71 100644
> > --- a/fs/cifs/cifs_ioctl.h
> > +++ b/fs/cifs/cifs_ioctl.h
> > @@ -78,3 +78,19 @@ struct smb3_notify {
> >  #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_in=
fo)
> >  #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug=
_info)
> >  #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
> > +#define SMB3_IOC_SHUTDOWN _IOR ('X', 125, __u32)
>
> Same
>
> > +
> > +/*
> > + * Flags for going down operation
> > + */
> > +#define SMB3_GOING_FLAGS_DEFAULT                0x0     /* going down =
*/
> > +#define SMB3_GOING_FLAGS_LOGFLUSH               0x1     /* flush log
> > but not data */
> > +#define SMB3_GOING_FLAGS_NOLOGFLUSH             0x2     /* don't
>
> Same
>
> > flush log nor data */
> > +
> > +static inline bool smb3_forced_shutdown(struct cifs_sb_info *sbi)
>
> Same
>
> > +     cifs_dbg(VFS, "shut down requested (%d)", flags); /* BB FIXME */
> > +/*   trace_smb3_shutdown(sb, flags);*/
>
> What is there to fix? It's doing like ext4 so it's fine no?
>
> > +
> > +     /*
> > +      * see:
> > +      *   https://man7.org/linux/man-pages/man2/ioctl_xfs_goingdown.2.=
html
> > +      * for more information and description of original intent of the=
 flags
> > +      */
> > +     switch (flags) {
> > +     /*
> > +      * We could add support later for default flag which requires:
> > +      *     "Flush all dirty data and metadata to disk"
> > +      * would need to call syncfs or equivalent to flush page cache fo=
r
> > +      * the mount and then issue fsync to server (if nostrictsync not =
set)
> > +      */
> > +     case SMB3_GOING_FLAGS_DEFAULT:
> > +             cifs_dbg(VFS, "default flags\n");
>
> Should this be removed, less verbose or more info should be printed?
>
> Cheers,
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg,=
 DE
> GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=
=BCnchen)
>


--=20
Thanks,

Steve
