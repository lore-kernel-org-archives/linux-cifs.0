Return-Path: <SRS0=TBB8=72=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EBA8C433DF
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 15:23:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7358C2078A
	for <linux-cifs@archiver.kernel.org>; Sat, 13 Jun 2020 15:23:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgFMPX7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 Jun 2020 11:23:59 -0400
Received: from neujmin.uberspace.de ([185.26.156.74]:38528 "EHLO
        neujmin.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbgFMPX6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 Jun 2020 11:23:58 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Jun 2020 11:23:58 EDT
Received: (qmail 26540 invoked from network); 13 Jun 2020 15:17:15 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by neujmin.uberspace.de with SMTP; 13 Jun 2020 15:17:15 -0000
MIME-Version: 1.0
Date:   Sat, 13 Jun 2020 15:17:14 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.13.0
From:   "Marco Pantel" <marco@pantel.eu>
Message-ID: <ab981c0afaa83091923e94df23e91037@pantel.eu>
Subject: get_existing_cc returns the wrong krb-cache under ubuntu 20.04
To:     linux-cifs@vger.kernel.org
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello!

I try to automount a cifs folder on an ubuntu 20.04 client from my nas (QNAP running Samba 4.7.12) using the respective user's kerberos ticket. I hunted the problem down to the method "get_existing_cc" in cifs.upcall which returns the path "/tmp/krb5cc_{uid}" although that filed is named "/tmp/krb5cc_{uid}_abcdef". Env variables $KRB5CCNAME and /proc/{pid}/environ hold that latter name, by the way, so I don't know why "get_existing_cc" comes up with the wrong
cache filename.

> Jun 13 17:04:11 desktop-linux kernel: CIFS: Attempting to mount //nas/homes/DOMAIN=HOME/Administrator
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: key description:
> cifs.spnego;0;0;39010000;ver=0x2;host=nas;
> ip4=172.16.20.20;sec=krb5;uid=0x2715;creduid=0x2715;user=administrator;pid=0x16ce
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: ver=2
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: host=nas
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: ip=172.16.20.20
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: sec=1
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: uid=10005
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: creduid=10005
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: user=administrator
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: pid=5838
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: get_cachename_from_process_env: pathname=/proc/5838/environ
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: get_existing_cc: default ccache is FILE:/tmp/krb5cc_10005
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: get_tgt_time: unable to get principal
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: krb5_get_init_creds_keytab: -1765328174
> Jun 13 17:04:11 desktop-linux cifs.upcall[5845]: Exit status 1
> Jun 13 17:04:11 desktop-linux mount[5838]: mount error(2): No such file or directory
> Jun 13 17:04:11 desktop-linux mount[5838]: Refer to the mount.cifs(8) manual page (e.g. man mount.cifs) and kernel log messages (dmesg)
> Jun 13 17:04:11 desktop-linux kernel: CIFS VFS: \\nas Send error in SessSetup = -126
> Jun 13 17:04:11 desktop-linux kernel: CIFS VFS: cifs_mount failed w/return code = -2
> Jun 13 17:04:11 desktop-linux systemd[1]: home-administrator-Ablage.mount: Mount process exited, code=exited, status=32/n/a

With a symlink named "/tmp/krb5cc_{uid}" to the correct cache file the automount works flawlessly, but that extra six characters being a security feature (from what I read about it) I would not necessarily want to work around it.
Besides that, I have seen the method returning the correct name during some of my tests, but I'm not able to reconstruct the fstab entry that I used. But every time I put the "noauto" in /etc/fstab, it only returns the shortened cache file name, which of course does not exist.

Is there any advice on how I can fix this problem or is this a bug in cifs.upcall?


Best regards
Marco
