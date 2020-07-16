Return-Path: <SRS0=Z9xR=A3=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A20C433F8
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F21208D5
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Jul 2020 23:10:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="JPoBHfbR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728154AbgGPXKA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Jul 2020 19:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727965AbgGPXJU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Jul 2020 19:09:20 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4A8C08C5EE
        for <linux-cifs@vger.kernel.org>; Thu, 16 Jul 2020 15:40:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=l2t0qqpiX5gSyGPBUYB9W3E6d0GDTwZaXsu5sygKZHY=; b=JPoBHfbRWD2nL1r0ePtQkYZeG+
        ikRJqe8tHYSkc5eXoj52LXKwPnxAuCu5fjf66/4rV7OllLbNadRIUW84wwVR06FbC0Y2vwBz2KzhN
        OXb64++LfCTzT1hPVfxkcsy0nc2fikau/mLjZlrRatWoSVRakQAEepBELf36/Y2CutIEiHunrBwLJ
        iVA3pNaOlg7dydjjHWqOLG2EQFm+beYZgsSYXGjrA/lGEBYzhWtu16QnNyVff4Nz3V9M90nsRD2YS
        liii/In/RVTxyIF7fmuQgHTGvHJ5V3bnmovYujDgnOAybdm73CKFXmdmbR6nrRUUuHTWE7+nX8h5L
        f09KZGlG/HnH0r/iqQDt5AYLn/vxNh2a0eve0CpCp3LS+Sa1D8fsVpkdoTm2TVoLaytvHyRa3Sj6e
        A6GfScqAv7UqLbUnpmlrgZMfYDpK/YeWEJU+Kj/rkRf5hqBR0t8UPVy5pIp/qSLotJvfEGGQxl/oe
        Vjj6Uw+Y+vSaSwm7iQCimMya;
Received: from [2a01:4f8:192:486::6:0] (port=40404 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jwCXv-0004EB-Ac
        for cifs-qa@samba.org; Thu, 16 Jul 2020 22:40:07 +0000
Received: from [::1] (port=26364 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jwCXu-006Oo6-UW
        for cifs-qa@samba.org; Thu, 16 Jul 2020 22:40:06 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Thu, 16 Jul 2020 22:40:06 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: palcantara@suse.de
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-ueNWUIRejS@https.bugzilla.samba.org/>
In-Reply-To: <bug-14442-10630@https.bugzilla.samba.org/>
References: <bug-14442-10630@https.bugzilla.samba.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.samba.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

https://bugzilla.samba.org/show_bug.cgi?id=3D14442

--- Comment #1 from Paulo Alcantara <palcantara@suse.de> ---
Hi Vadim,

Thanks for the report!

I was able to reproduce it and ended up with the following changes:

diff --git a/mount.cifs.c b/mount.cifs.c
index 40918c18649f..bb8a7e958898 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1695,6 +1695,43 @@ drop_child_privs(void)
        return 0;
 }

+#ifdef ENABLE_SYSTEMD
+static int get_passwd_by_systemd(const char *prompt, char *input, int
capacity)
+{
+       int fd[2];
+       pid_t pid;
+       int rc;
+
+       if (pipe(fd) =3D=3D -1) {
+               fprintf(stderr, "Failed to create pipe: %s\n",
strerror(errno));
+               return -1;
+       }
+
+       pid =3D fork();
+       if (pid =3D=3D -1) {
+               fprintf(stderr, "Unable to fork: %s\n", strerror(errno));
+               return -1;
+       }
+
+       if (pid =3D=3D 0) {
+               close(fd[0]);
+               dup2(fd[1], STDOUT_FILENO);
+               execlp("systemd-ask-password", "systemd-ask-password", prom=
pt,
NULL);
+       }
+
+       close(fd[1]);
+       wait(&rc);
+       if (!WIFEXITED(rc))
+               return 1;
+       if (read(fd[0], input, capacity) =3D=3D -1) {
+               fprintf(stderr, "Failed to read from pipe: %s\n",
strerror(errno));
+               return 1;
+       }
+
+       return 0;
+}
+#endif
+
 /*
  * If systemd is running and systemd-ask-password --
  * is available, then use that else fallback on getpass(..)
@@ -1714,27 +1751,11 @@ get_password(const char *prompt, char *input, int
capacity)
                && (lstat("/sys/fs/cgroup/systemd", &b) =3D=3D 0)
                && (a.st_dev !=3D b.st_dev);

-       if (is_systemd_running) {
-               char *cmd, *ret;
-               FILE *ask_pass_fp =3D NULL;
-
-               cmd =3D ret =3D NULL;
-               if (asprintf(&cmd, "systemd-ask-password \"%s\"", prompt) >=
=3D 0)
{
-                       ask_pass_fp =3D popen (cmd, "re");
-                       free (cmd);
-               }
-
-               if (ask_pass_fp) {
-                       ret =3D fgets(input, capacity, ask_pass_fp);
-                       pclose(ask_pass_fp);
-               }
-
-               if (ret) {
-                       int len =3D strlen(input);
-                       if (input[len - 1] =3D=3D '\n')
-                               input[len - 1] =3D '\0';
-                       return input;
-               }
+       if (is_systemd_running && !get_passwd_by_systemd(prompt, input,
capacity)) {
+               int len =3D strlen(input);
+               if (input[len - 1] =3D=3D '\n')
+                       input[len - 1] =3D '\0';
+               return input;
        }
 #endif


---
Before the patch:

$ sudo ./mount.cifs -o username=3D"test \$(id)" //1 /mnt
Password for test uid=3D0(root) gid=3D0(root) groups=3D0(root)@//1:  (press=
 TAB for
no echo)

After the patch:

$ sudo ./mount.cifs -o username=3D"test \$(id)" //1 /mnt
Password for test $(id)@//1:  (press TAB for no echo)

Let me know what you think.

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
