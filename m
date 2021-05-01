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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FCC1C433B4
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 04:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FDFD613CD
	for <linux-cifs@archiver.kernel.org>; Sat,  1 May 2021 04:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbhEAEBh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 1 May 2021 00:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbhEAEBg (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 1 May 2021 00:01:36 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A88C06174A
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 21:00:46 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id w3so126131ejc.4
        for <linux-cifs@vger.kernel.org>; Fri, 30 Apr 2021 21:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+4TWlII0PbWvuuYjwsLJfy5HRgAwAy4zrIJ50WY+RM=;
        b=c9SaLpULYfBmzVGURa4DgCSXYFu1J0yIp0cHmC0YWGkw1i7SuPlVXyz4apf6FQA+ci
         +kiuJgqMLNH7+vYpJH4TVOvWfDgFAv6B16ZrvfAGdBl07EuFShcaohCFb8RIMm1atFMk
         oHUbRNdRbaWcSh7/11xFzCCwg8rilVtoooXkc2kFtsidneaNx2Gu4zcYcSsEEre5USi0
         +bsJqro4n0G/Pzz2/QXwj30zSYZ4+TtWkpVEykNM6V9kohuwGn9RkrfLScmCbWFgIWFa
         7ImvqiMrWkjJkbZ+mGg9YRQs7b9gyZmaIld9iEMEyETmBeEjU/pCpk6BhSyevz8C4hPr
         6xtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+4TWlII0PbWvuuYjwsLJfy5HRgAwAy4zrIJ50WY+RM=;
        b=kN55KBHufePjqNV0aNHKRfbK4BUbwe8yKBOA4vpJri9UW5qmg8WWP2xqd66XWDUpcd
         qCNXMbLLIDP0+KeNicqDOiZmxUxNd3cUIMVPK4t1bH8riQIhjd6c8978zu1+pMnAfWwQ
         1uyf3oL9bP2Jk4BQx0tHnxwigQNge2fjJccS8Zo/8T/EJ0bkCVaInjZptjBe2JwzXTK2
         9Wh46sSLi4Ty7uinQcpgzMfHAT1sEI9CIUYF9N0QA3agNymWg1pIYuebUwjJmsowuW4U
         8EKJnWMPJh4kbFzoR46SexSF2X+Gi0JHZsjT6o3N1p8b7JVkqoIzQYkthej5tUFjVDyQ
         p5Nw==
X-Gm-Message-State: AOAM532y0KRWGqvOv1+/M1TMa5z8SQw8pQdfuQYXZ7aM2wKO/64tPM2J
        pFWH2asnUw+VMUKs2TYpSfGdUsZzWtz+qD5l/m/Iburzc5I=
X-Google-Smtp-Source: ABdhPJxTHGzYASBgn9+0iE3W05IyhiRvJ6IiD+m2kK1d8o35rOxBRdIBuHVxE5pPSZfcqYoD09onAqvGoF9CuHnmnG8=
X-Received: by 2002:a17:907:7283:: with SMTP id dt3mr7440546ejc.47.1619841645258;
 Fri, 30 Apr 2021 21:00:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
In-Reply-To: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Sat, 1 May 2021 14:00:33 +1000
Message-ID: <CAN05THQzSCZwypBWg9YZAarjrsQ74qowp4Bneo3crW9FfqVqPA@mail.gmail.com>
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve debugging
 of encrypted shares
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        COMMON INTERNET FILE SYSTEM SERVER 
        <linux-cifsd-devel@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

These elements should probably be [32] and not
+ __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];

Because this is now visible to userspace and we can not allow this to
ever change.
Because when GCM512 is eventually released, if we bump
SMB3_ENC_DEC_KEY_SIZE to a larger value we suddenly break userspace.


On Sat, May 1, 2021 at 8:20 AM Steve French <smfrench@gmail.com> wrote:
>
> Previously we were only able to dump CCM or GCM-128 keys (see "smbinfo
> keys" e.g.)
> to allow network debugging (e.g. wireshark) of mounts to SMB3.1.1 encrypted
> shares.  But with the addition of GCM-256 support, we have to be able to dump
> 32 byte instead of 16 byte keys which requires adding an additional ioctl
> for that.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/cifs_ioctl.h | 19 +++++++++++++++++++
>  fs/cifs/ioctl.c      | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
>
> diff --git a/fs/cifs/cifs_ioctl.h b/fs/cifs/cifs_ioctl.h
> index f262c64516bc..9f2ed9cccb08 100644
> --- a/fs/cifs/cifs_ioctl.h
> +++ b/fs/cifs/cifs_ioctl.h
> @@ -57,6 +57,12 @@ struct smb_query_info {
>   /* char buffer[]; */
>  } __packed;
>
> +/*
> + * Dumping the commonly used 16 byte (e.g. CCM and GCM128) keys still supported
> + * for backlevel compatibility, but is not sufficient for dumping the less
> + * frequently used GCM256 (32 byte) keys (see the newer "CIFS_DUMP_FULL_KEY"
> + * ioctl for dumping decryption info for GCM256 mounts)
> + */
>  struct smb3_key_debug_info {
>   __u64 Suid;
>   __u16 cipher_type;
> @@ -65,6 +71,18 @@ struct smb3_key_debug_info {
>   __u8 smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
>  } __packed;
>
> +/*
> + * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
> + * is needed if GCM256 (stronger encryption) negotiated
> + */
> +struct smb3_full_key_debug_info {
> + __u64 Suid;
> + __u16 cipher_type;
> + __u8 auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
> + __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> + __u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> +} __packed;
> +
>  struct smb3_notify {
>   __u32 completion_filter;
>   bool watch_tree;
> @@ -78,6 +96,7 @@ struct smb3_notify {
>  #define CIFS_QUERY_INFO _IOWR(CIFS_IOCTL_MAGIC, 7, struct smb_query_info)
>  #define CIFS_DUMP_KEY _IOWR(CIFS_IOCTL_MAGIC, 8, struct smb3_key_debug_info)
>  #define CIFS_IOC_NOTIFY _IOW(CIFS_IOCTL_MAGIC, 9, struct smb3_notify)
> +#define CIFS_DUMP_FULL_KEY _IOWR(CIFS_IOCTL_MAGIC, 10, struct
> smb3_full_key_debug_info)
>  #define CIFS_IOC_SHUTDOWN _IOR ('X', 125, __u32)
>
>  /*
> diff --git a/fs/cifs/ioctl.c b/fs/cifs/ioctl.c
> index ef41fa878793..e4321e2a27d2 100644
> --- a/fs/cifs/ioctl.c
> +++ b/fs/cifs/ioctl.c
> @@ -218,6 +218,7 @@ long cifs_ioctl(struct file *filep, unsigned int
> command, unsigned long arg)
>  {
>   struct inode *inode = file_inode(filep);
>   struct smb3_key_debug_info pkey_inf;
> + struct smb3_full_key_debug_info pfull_key_inf;
>   int rc = -ENOTTY; /* strange error - but the precedent */
>   unsigned int xid;
>   struct cifsFileInfo *pSMBFile = filep->private_data;
> @@ -354,6 +355,38 @@ long cifs_ioctl(struct file *filep, unsigned int
> command, unsigned long arg)
>   else
>   rc = 0;
>   break;
> + /*
> + * Dump full key (32 bytes instead of 16 bytes) is
> + * needed if GCM256 (stronger encryption) negotiated
> + */
> + case CIFS_DUMP_FULL_KEY:
> + if (pSMBFile == NULL)
> + break;
> + if (!capable(CAP_SYS_ADMIN)) {
> + rc = -EACCES;
> + break;
> + }
> +
> + tcon = tlink_tcon(pSMBFile->tlink);
> + if (!smb3_encryption_required(tcon)) {
> + rc = -EOPNOTSUPP;
> + break;
> + }
> + pfull_key_inf.cipher_type =
> + le16_to_cpu(tcon->ses->server->cipher_type);
> + pfull_key_inf.Suid = tcon->ses->Suid;
> + memcpy(pfull_key_inf.auth_key, tcon->ses->auth_key.response,
> + 16 /* SMB2_NTLMV2_SESSKEY_SIZE */);
> + memcpy(pfull_key_inf.smb3decryptionkey,
> +       tcon->ses->smb3decryptionkey, SMB3_ENC_DEC_KEY_SIZE);
> + memcpy(pfull_key_inf.smb3encryptionkey,
> +       tcon->ses->smb3encryptionkey, SMB3_ENC_DEC_KEY_SIZE);
> + if (copy_to_user((void __user *)arg, &pfull_key_inf,
> + sizeof(struct smb3_full_key_debug_info)))
> + rc = -EFAULT;
> + else
> + rc = 0;
> + break;
>   case CIFS_IOC_NOTIFY:
>   if (!S_ISDIR(inode->i_mode)) {
>   /* Notify can only be done on directories */
>
> --
> Thanks,
>
> Steve
