Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCC59C43334
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jul 2022 20:54:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbiGUUyn convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 16:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiGUUyn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 16:54:43 -0400
X-Greylist: delayed 569 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jul 2022 13:54:41 PDT
Received: from smtp.polymtl.ca (smtp.polymtl.ca [132.207.4.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB63D8FD76
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 13:54:41 -0700 (PDT)
Received: from comms3.kousu.ca (comms3.kousu.ca [46.23.90.174])
        by smtp.polymtl.ca (8.14.7/8.14.7) with ESMTP id 26LKj51q006100
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 16:45:10 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.polymtl.ca 26LKj51q006100
Received: from comms.kousu.ca (localhost [127.0.0.1])
        by comms3.kousu.ca (OpenSMTPD) with ESMTP id 0c7b1788
        for <linux-cifs@vger.kernel.org>;
        Thu, 21 Jul 2022 22:45:03 +0200 (CEST)
MIME-Version: 1.0
Date:   Thu, 21 Jul 2022 20:45:03 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.16.0
From:   "Nick Guenther" <nick.guenther@polymtl.ca>
Message-ID: <774233f766bf26976c0d923cc1dc53c7@polymtl.ca>
Subject: pam_cifscreds, tmux and session keyrings
To:     linux-cifs@vger.kernel.org
X-Poly-FromMTA: (comms3.kousu.ca [46.23.90.174]) at Thu, 21 Jul 2022 20:45:05 +0000
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have set up pam_cifscreds and multiuser samba mounts for my users, which seemed to work well, until some of my users started complaining that their overnight batch jobs were failing.

The common feature is running their jobs in tmux.

It seems tmux sometimes has access to the keyring that pam_cifscreds uses, but isn't able to put a lock on it. So, only overnight when no one is looking (which is of course the worst time to debug), when mount.cifs's connection drops, it isn't able to reconnect because it has no password available.

I would like to have your wisdom on this situation. Can I configure pam_cifscreds to set a longer expiry on the credentials? Can I put something in tmux's startup script to make it lock in the session keyring? Is this a bug in pam_cifscreds?



Here's the setup:

$ cat /etc/pam.d/sshd
[...]
# Create a new session keyring.
session    optional     pam_keyinit.so force revoke
[...]

$ cat /etc/pam.d/common-session
[...]
session [default=1]                     pam_permit.so
session requisite                       pam_deny.so
session required                        pam_permit.so
session optional                        pam_umask.so
session required        pam_unix.so 
session optional                        pam_sss.so 
session optional    pam_cifscreds.so host=duke.neuro.polymtl.ca
session optional        pam_systemd.so 
session optional                        pam_mkhomedir.so umask=0077


$ cat /etc/fstab
[...]
//duke.neuro.polymtl.ca/projects /mnt/duke/projects cifs vers=3.0,nobrl,file_mode=0644,multiuser,credentials=/etc/activedirectory-credentials,nofail,_netdev 0 0
//duke.neuro.polymtl.ca/temp /mnt/duke/temp cifs vers=3.0,nobrl,file_mode=0644,multiuser,credentials=/etc/polygrames-credentials,nofail,_netdev 0 0



Here's a demo:

If someone sshes in, pam_cifscreds stashes their password in the keyring

p115628@davis:~$ keyctl list @s
2 keys in keyring:
452396344: --alswrv 703204575 65534 keyring: _uid.703204575
626459666: ----sw-v     0     0 logon: cifs:a:132.207.65.200

and it forwards their password to the CIFS server so they can access its contents:
 
p115628@davis:~$ ls -l /mnt/duke/projects/pmj/pmj_csa/results.txt 
-rw-r--r-- 1 p115628 domain users 831 Jul  5  2021 /mnt/duke/projects/pmj/pmj_csa/results.txt


Both commands work inside of a tmux session as well.

However if I make a tmux session, _detach_ it, and then log out

p115628@davis:~$ keyctl list @s
2 keys in keyring:
452396344: --alswrv 703204575 65534 keyring: _uid.703204575
293860075: ----sw-v     0     0 logon: cifs:a:132.207.65.200
p115628@davis:~$ tmux
[detached (from session 0)]
p115628@davis:~$ 
logout
Shared connection to davis.neuro.polymtl.ca closed.


and then **wait** for the CIFS connection to time out (or, plan to access the CIFS share that is not yet open) and then back in again:

[kousu@laptop ]$ ssh davis
p115628@davis:~$ tmux attach
p115628@davis:~$ keyctl list @s
keyctl_read_alloc: Key has been revoked
p115628@davis:~$ ls -l /mnt/duke/temp 
ls: cannot access '/mnt/duke/temp': Permission denied
^Bd

But outside of tmux, the connection works, because it has access to the reinitialized keyring:

[detached (from session 0)]
p115628@davis:~$ keyctl list @s
2 keys in keyring:
452396344: --alswrv 703204575 65534 keyring: _uid.703204575
462100230: ----sw-v     0     0 logon: cifs:a:132.207.65.200
p115628@davis:~$ ls -l /mnt/duke/temp 
total 0
drwxr-xr-x 2 p115628 domain users 0 Jun  7 18:10 user1
drwxr-xr-x 2 p115628 domain users 0 Jun 20 18:14 user2


which then makes the share temporarily available inside of tmux as well, at least until it times out again.



Lennart Poettering and co. have the same problem, because `systemd --user` sessions also lose access to the pam_cifscreds keyring: https://github.com/systemd/systemd/issues/1299. They think it's your bug. They offered a fix too, but I want to hear your opinion on it: use user-keyring(7) instead of user-session-keyring(7), or:


diff --git a/cifscreds.c b/cifscreds.c
index 32f2ee4..9ba298d 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -446,7 +446,7 @@ check_session_keyring(void)
        }
 
        /* A problem querying the user-session keyring isn't fatal. */
-       uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_SESSION_KEYRING, 0);
+       uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_KEYRING, 0);
        if (uses_key == -1)
                return 0;
 
diff --git a/pam_cifscreds.c b/pam_cifscreds.c
index 5d99c2d..3c127bb 100644
--- a/pam_cifscreds.c
+++ b/pam_cifscreds.c
@@ -473,7 +473,7 @@ PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, int flags __attribute__((un
        }
 
        /* A problem querying the user-session keyring isn't fatal. */
-       uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_SESSION_KEYRING, 0);
+       uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_KEYRING, 0);
        if ((uses_key >= 0) && (ses_key == uses_key))
                pam_syslog(ph, LOG_ERR, "you have no persistent session "
                                "keyring. cifscreds keys will not persist.");


I see in this old thread https://www.spinics.net/lists/linux-cifs/msg18249.html that you actually want to go the _other_ direction, and isolate your sessions even more:

> > multiuser SMB connections should also be initiated per session, same like the
> > keyring. Currently the cifs SMB connections are accessible also from other all
> > sessions.
>
> That needs to be implemented indeed.

but that doesn't sound like it would make my users happy. In their perspective, tmux should be the same environment as ssh or as the GUI, just more persistent. And I tend to agree.

Anyway, I hope this isn't too intricate or confusing for you. I would really appreciate a second opinion, and maybe a consideration of that patch, if that patch is actually the right answer.

-Nick Guenther
Associé de Recherche
NeuroPoly, Polytechnique de Montréal
