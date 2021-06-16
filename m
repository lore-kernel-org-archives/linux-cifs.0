Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 187C1C48BE6
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 06:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBA55613BF
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 06:09:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhFPGLo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Jun 2021 02:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhFPGLo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Jun 2021 02:11:44 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8139C061574;
        Tue, 15 Jun 2021 23:09:37 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id o21so572595pll.6;
        Tue, 15 Jun 2021 23:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KxC5nTXTGywsFfFP80F8r7S66ACFSaP2lRpWZ/+uxEA=;
        b=Ceh6VHeSRbD/KZlHbz/UYOPdumZdASc/KYIx7lG5Qy+5k+C/FuuVr1mu76GKRcVXPq
         fybyCuUVKKEqkxuTnBLFjrCQ+jCNQZzZhrL3+mz2ivhMjASFH9pZfEOrtIzMki97jZHt
         FOXALYv8AObdHv5gpgYaxHqmfg98biusEjZ1G6BAu6TgobOnQ3wmWe9pbnvopCNoe192
         3SLhihR5lOKoDEluHPDJWBrpl1nbYK1MmF40z8TV1Ba/NdyS3hY6yAKhh+SaY4fItRBh
         R1c5xXoCaTSWpYVEWlvgco9qsYXuRnzn4bPh9mQS4yfnxSdKvtB0YL48u3BscSE1aVPs
         KINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KxC5nTXTGywsFfFP80F8r7S66ACFSaP2lRpWZ/+uxEA=;
        b=V0QIa2b0+KZNRDKlhK9Ae/iXv+wJC+YaS6Qe/q2pnL3S5DiE6lTxN1mhjaCm3T581R
         jWO60PaWdiUiB237NSMfIcfQ/dKJ79qnVhIJ/ogErm+QcyizrTZ+qujn15rRXBaNTmOB
         i4oyhwBVvJK+/0Fe9oocexD9/qpUdTedhVqhZhRgQiFK7/YKnu6b93gXMiHjn9YEJFo0
         Z3T4IDdPe8I/NPnEv4ev/jQKjT+9mkRIXXAARJCuoN19QPEMYn7X7YzQO2T1Mew4nas9
         rCE+c0/a9Zi+qn/qWD8RMoMYnru8t/m8MgzCgxqSHnm6K0STIb3Etnw3M0NjuCIQUqL1
         UBxg==
X-Gm-Message-State: AOAM532W2V4DnwGkHVLQB9TUp1aIBSOQid4Q9dbxVxnDBgnsPe8g3Zrd
        eqQkWu2x8SLCPVlzUi9dK9zG2yzSZ+d8BCONYCYiG6cb
X-Google-Smtp-Source: ABdhPJyzvTToZlLX952QnytxhKuBRfEvwoeC82sCK2S8KriGkGuGT6EO3vA1RiqAfTepRZ8roRSXWy43IlLsmre9oKk=
X-Received: by 2002:a17:902:e751:b029:106:65ba:5c80 with SMTP id
 p17-20020a170902e751b029010665ba5c80mr6054587plf.36.1623823777191; Tue, 15
 Jun 2021 23:09:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210615164256.173715-1-trbecker@gmail.com>
In-Reply-To: <20210615164256.173715-1-trbecker@gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Wed, 16 Jun 2021 16:09:25 +1000
Message-ID: <CAN05THQqBdT-uvVS+jq1Hv8MwDVCTJFHhzan8M0+4ztNbpCZ0g@mail.gmail.com>
Subject: Re: [PATCH] cifs: retry lookup and readdir when EAGAIN is returned.
To:     Thiago Rafael Becker <trbecker@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks good to me.

Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Wed, Jun 16, 2021 at 2:44 AM Thiago Rafael Becker <trbecker@gmail.com> wrote:
>
> According to the investigation performed by Jacob Shivers at Red Hat,
> cifs_lookup and cifs_readdir leak EAGAIN when the user session is
> deleted on the server. Fix this issue by implementing a retry with
> limits, as is implemented in cifs_revalidate_dentry_attr.
>
> Reproducer based on the work by Jacob Shivers:
>
>   ~~~
>   $ cat readdir-cifs-test.sh
>   #!/bin/bash
>
>   # Install and configure powershell and sshd on the windows
>   #  server as descibed in
>   # https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview
>   # This script uses expect(1)
>
>   USER=dude
>   SERVER=192.168.0.2
>   RPATH=root
>   PASS='password'
>
>   function debug_funcs {
>         for line in $@ ; do
>                 echo "func $line +p" > /sys/kernel/debug/dynamic_debug/control
>         done
>   }
>
>   function setup {
>         echo 1 > /proc/fs/cifs/cifsFYI
>         debug_funcs wait_for_compound_request \
>                 smb2_query_dir_first cifs_readdir \
>                 compound_send_recv cifs_reconnect_tcon \
>                 generic_ip_connect cifs_reconnect \
>                 smb2_reconnect_server smb2_reconnect \
>                 cifs_readv_from_socket cifs_readv_receive
>         tcpdump -i eth0 -w cifs.pcap host 192.168.2.182 & sleep 5
>         dmesg -C
>   }
>
>   function test_call {
>         if [[ $1 == 1 ]] ; then
>                 tracer="strace -tt -f -s 4096 -o trace-$(date -Iseconds).txt"
>         fi
>         # Change the command here to anything apropriate
>         $tracer ls $2 > /dev/null
>         res=$?
>         if [[ $1 == 1 ]] ; then
>                 if [[ $res == 0 ]] ; then
>                         1>&2 echo success
>                 else
>                         1>&2 echo "failure ($res)"
>                 fi
>         fi
>   }
>
>   mountpoint /mnt > /dev/null || mount -t cifs -o username=$USER,pass=$PASS //$SERVER/$RPATH /mnt
>
>   test_call 0 /mnt/
>
>   /usr/bin/expect << EOF
>         set timeout 60
>
>         spawn ssh $USER@$SERVER
>
>         expect "yes/no" {
>                 send "yes\r"
>                 expect "*?assword" { send "$PASS\r" }
>         } "*?assword" { send "$PASS\r" }
>
>         expect ">" { send "powershell close-smbsession -force\r" }
>         expect ">" { send "exit\r" }
>         expect eof
>   EOF
>
>   sysctl -w vm.drop_caches=2 > /dev/null
>   sysctl -w vm.drop_caches=2 > /dev/null
>
>   setup
>
>   test_call 1 /mnt/
>   ~~~
>
> Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
> ---
>  fs/cifs/dir.c     | 4 ++++
>  fs/cifs/smb2ops.c | 5 +++++
>  2 files changed, 9 insertions(+)
>
> diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> index 6bcd3e8f7cda..7c641f9a3dac 100644
> --- a/fs/cifs/dir.c
> +++ b/fs/cifs/dir.c
> @@ -630,6 +630,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>         struct inode *newInode = NULL;
>         const char *full_path;
>         void *page;
> +       int retry_count = 0;
>
>         xid = get_xid();
>
> @@ -673,6 +674,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>         cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
>                  full_path, d_inode(direntry));
>
> +again:
>         if (pTcon->posix_extensions)
>                 rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
>         else if (pTcon->unix_ext) {
> @@ -687,6 +689,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
>                 /* since paths are not looked up by component - the parent
>                    directories are presumed to be good here */
>                 renew_parental_timestamps(direntry);
> +       } else if (rc == -EAGAIN && retry_count++ < 10) {
> +               goto again;
>         } else if (rc == -ENOENT) {
>                 cifs_set_time(direntry, jiffies);
>                 newInode = NULL;
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 21ef51d338e0..d241e6af8fe4 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2325,6 +2325,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
>         struct smb2_query_directory_rsp *qd_rsp = NULL;
>         struct smb2_create_rsp *op_rsp = NULL;
>         struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
> +       int retry_count = 0;
>
>         utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
>         if (!utf16_path)
> @@ -2372,10 +2373,14 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
>
>         smb2_set_related(&rqst[1]);
>
> +again:
>         rc = compound_send_recv(xid, tcon->ses, server,
>                                 flags, 2, rqst,
>                                 resp_buftype, rsp_iov);
>
> +       if (rc == -EAGAIN && retry_count++ < 10)
> +               goto again;
> +
>         /* If the open failed there is nothing to do */
>         op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
>         if (op_rsp == NULL || op_rsp->sync_hdr.Status != STATUS_SUCCESS) {
> --
> 2.31.1
>
