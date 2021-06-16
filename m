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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AABDAC48BE5
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 17:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 790B460FF1
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Jun 2021 17:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbhFPRMO (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Jun 2021 13:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbhFPRMO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Jun 2021 13:12:14 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D8FC061574;
        Wed, 16 Jun 2021 10:10:07 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id q20so5527537lfo.2;
        Wed, 16 Jun 2021 10:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kzLgEH6t1F9FwDhew1fvgEplwZC1Y2awnnPiUyPzJKA=;
        b=UKm5apkYwCa1USsIuMM6UuLl7ssUYngCQR9tEhU6x397zCTOG+DndbQqbd7fRyCAEi
         ij5qmkTA7YREM0/tS8kITOyUa0yKrlNuvwU5bBxZ/WYKVaQWsHlzbFo3fhPo75+48eoc
         mKMeWtaczx8NHSEQ1QUbPz1e/kmcCmpMrndkpzS+Vj3jx0nQwNWQ1iFBzgjybA25JcBo
         6AS3t8gS9UL/PQ/t95ijWehqVQCyrJqGMi7qfcLwn+Ur/bjgl0Cip3wjlaJosrBW/a6/
         fpPQBq1JSIaCyMmN6V089hGobSPSM00XA0/ZRuTSkCQTawoapYqT5KMFReiqxdrHJvBM
         DWTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kzLgEH6t1F9FwDhew1fvgEplwZC1Y2awnnPiUyPzJKA=;
        b=pPcEyJ94STfl1xiL316BUVYp91ZpFsNo1pHllQVANxu0ro0ikg1nsdl+SDahPzS0iD
         X/u7q03CVVAZ9viAZxjRWv3COG/OIbXXQRsrRgT8/fsveN/5V+j/32PbYDZul2x07alb
         IpOVXfdtEjlBeLF3ufwXoL3785SdBvAnoxsnSK1xdojiCIdB73342Ad75sATIMV7gAZ3
         tD2zC0uKyRj3Uk8EeMZYJd3jKBXCjXtVymbHt2z4aiRxPxUg6qvyr58zz1YLOoCOBm0H
         48lG0KrYjeu1crUqk/O/kZG077YWCyKyaCwCQp1aZoDoX4cplBe9EDFMV8ycQXshyumb
         2rgg==
X-Gm-Message-State: AOAM5337EFYzry0xaTa349fQqcT0Il0WlPfk1PFQYs/ahrurr76H2NXm
        08h5eeZOKWMkdTAcJKPbpto5nzOsq9hruOZ5iAU=
X-Google-Smtp-Source: ABdhPJx+XZwj7cQUGXh0rqQenQDojUuhgBl8Ak2BBiOpr2NTkR9X7/zuDWKlv6eOCcAFMOxvnroRnVSwHAd22qwDNe0=
X-Received: by 2002:a05:6512:344f:: with SMTP id j15mr506482lfr.175.1623863405248;
 Wed, 16 Jun 2021 10:10:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210615164256.173715-1-trbecker@gmail.com> <CAN05THQqBdT-uvVS+jq1Hv8MwDVCTJFHhzan8M0+4ztNbpCZ0g@mail.gmail.com>
In-Reply-To: <CAN05THQqBdT-uvVS+jq1Hv8MwDVCTJFHhzan8M0+4ztNbpCZ0g@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 16 Jun 2021 12:09:54 -0500
Message-ID: <CAH2r5mtBb6jZ5rAy2KY9H=aaB6J+=Ti1GyLoNoiWeLGSGNxNVg@mail.gmail.com>
Subject: Re: [PATCH] cifs: retry lookup and readdir when EAGAIN is returned.
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Thiago Rafael Becker <trbecker@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending testing and any
more review feedback

On Wed, Jun 16, 2021 at 1:09 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Looks good to me.
>
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> On Wed, Jun 16, 2021 at 2:44 AM Thiago Rafael Becker <trbecker@gmail.com> wrote:
> >
> > According to the investigation performed by Jacob Shivers at Red Hat,
> > cifs_lookup and cifs_readdir leak EAGAIN when the user session is
> > deleted on the server. Fix this issue by implementing a retry with
> > limits, as is implemented in cifs_revalidate_dentry_attr.
> >
> > Reproducer based on the work by Jacob Shivers:
> >
> >   ~~~
> >   $ cat readdir-cifs-test.sh
> >   #!/bin/bash
> >
> >   # Install and configure powershell and sshd on the windows
> >   #  server as descibed in
> >   # https://docs.microsoft.com/en-us/windows-server/administration/openssh/openssh_overview
> >   # This script uses expect(1)
> >
> >   USER=dude
> >   SERVER=192.168.0.2
> >   RPATH=root
> >   PASS='password'
> >
> >   function debug_funcs {
> >         for line in $@ ; do
> >                 echo "func $line +p" > /sys/kernel/debug/dynamic_debug/control
> >         done
> >   }
> >
> >   function setup {
> >         echo 1 > /proc/fs/cifs/cifsFYI
> >         debug_funcs wait_for_compound_request \
> >                 smb2_query_dir_first cifs_readdir \
> >                 compound_send_recv cifs_reconnect_tcon \
> >                 generic_ip_connect cifs_reconnect \
> >                 smb2_reconnect_server smb2_reconnect \
> >                 cifs_readv_from_socket cifs_readv_receive
> >         tcpdump -i eth0 -w cifs.pcap host 192.168.2.182 & sleep 5
> >         dmesg -C
> >   }
> >
> >   function test_call {
> >         if [[ $1 == 1 ]] ; then
> >                 tracer="strace -tt -f -s 4096 -o trace-$(date -Iseconds).txt"
> >         fi
> >         # Change the command here to anything apropriate
> >         $tracer ls $2 > /dev/null
> >         res=$?
> >         if [[ $1 == 1 ]] ; then
> >                 if [[ $res == 0 ]] ; then
> >                         1>&2 echo success
> >                 else
> >                         1>&2 echo "failure ($res)"
> >                 fi
> >         fi
> >   }
> >
> >   mountpoint /mnt > /dev/null || mount -t cifs -o username=$USER,pass=$PASS //$SERVER/$RPATH /mnt
> >
> >   test_call 0 /mnt/
> >
> >   /usr/bin/expect << EOF
> >         set timeout 60
> >
> >         spawn ssh $USER@$SERVER
> >
> >         expect "yes/no" {
> >                 send "yes\r"
> >                 expect "*?assword" { send "$PASS\r" }
> >         } "*?assword" { send "$PASS\r" }
> >
> >         expect ">" { send "powershell close-smbsession -force\r" }
> >         expect ">" { send "exit\r" }
> >         expect eof
> >   EOF
> >
> >   sysctl -w vm.drop_caches=2 > /dev/null
> >   sysctl -w vm.drop_caches=2 > /dev/null
> >
> >   setup
> >
> >   test_call 1 /mnt/
> >   ~~~
> >
> > Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
> > ---
> >  fs/cifs/dir.c     | 4 ++++
> >  fs/cifs/smb2ops.c | 5 +++++
> >  2 files changed, 9 insertions(+)
> >
> > diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
> > index 6bcd3e8f7cda..7c641f9a3dac 100644
> > --- a/fs/cifs/dir.c
> > +++ b/fs/cifs/dir.c
> > @@ -630,6 +630,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
> >         struct inode *newInode = NULL;
> >         const char *full_path;
> >         void *page;
> > +       int retry_count = 0;
> >
> >         xid = get_xid();
> >
> > @@ -673,6 +674,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
> >         cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
> >                  full_path, d_inode(direntry));
> >
> > +again:
> >         if (pTcon->posix_extensions)
> >                 rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
> >         else if (pTcon->unix_ext) {
> > @@ -687,6 +689,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
> >                 /* since paths are not looked up by component - the parent
> >                    directories are presumed to be good here */
> >                 renew_parental_timestamps(direntry);
> > +       } else if (rc == -EAGAIN && retry_count++ < 10) {
> > +               goto again;
> >         } else if (rc == -ENOENT) {
> >                 cifs_set_time(direntry, jiffies);
> >                 newInode = NULL;
> > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > index 21ef51d338e0..d241e6af8fe4 100644
> > --- a/fs/cifs/smb2ops.c
> > +++ b/fs/cifs/smb2ops.c
> > @@ -2325,6 +2325,7 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
> >         struct smb2_query_directory_rsp *qd_rsp = NULL;
> >         struct smb2_create_rsp *op_rsp = NULL;
> >         struct TCP_Server_Info *server = cifs_pick_channel(tcon->ses);
> > +       int retry_count = 0;
> >
> >         utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
> >         if (!utf16_path)
> > @@ -2372,10 +2373,14 @@ smb2_query_dir_first(const unsigned int xid, struct cifs_tcon *tcon,
> >
> >         smb2_set_related(&rqst[1]);
> >
> > +again:
> >         rc = compound_send_recv(xid, tcon->ses, server,
> >                                 flags, 2, rqst,
> >                                 resp_buftype, rsp_iov);
> >
> > +       if (rc == -EAGAIN && retry_count++ < 10)
> > +               goto again;
> > +
> >         /* If the open failed there is nothing to do */
> >         op_rsp = (struct smb2_create_rsp *)rsp_iov[0].iov_base;
> >         if (op_rsp == NULL || op_rsp->sync_hdr.Status != STATUS_SUCCESS) {
> > --
> > 2.31.1
> >



-- 
Thanks,

Steve
