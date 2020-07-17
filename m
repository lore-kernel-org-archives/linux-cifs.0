Return-Path: <SRS0=/bCA=A4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AC5C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 17:21:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F5BC20704
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Jul 2020 17:21:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="vF36z8f0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgGQRVV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Jul 2020 13:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgGQRVV (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Jul 2020 13:21:21 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827C5C0619D2
        for <linux-cifs@vger.kernel.org>; Fri, 17 Jul 2020 10:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=9hEwf/DBGBj301jBG1GYW5QsQKcLrrnV28VPCrllGAY=; b=vF36z8f0pDnivhbw0i+V24YhFL
        693xgiv6FGYOzdP7yTvznUtorM8NoDxajIpeTIwThN1mEBRSC1oX3KJ0h5zVqBxmqAnrQPQN2YqwY
        JnqessuaZ5Q8tzVWTk0PIB8f6JIYJOSEPXXk9n4TryuD6VDLL04ZCHU0BXWeuFkjsQgyAwZ/6Z+6V
        MErLkrUzv23CZuPO6l+urnRNi5k0d9wNFONqxsbGCJcb+FwQiQX7jsp701VjQyPRC4jLOKU/GYqa9
        xQDjoxWbTFrsMUPqTSJ49fJBff6nlIVuYhWHiRNGQpFOx6urbJdhvJQHAinq3eT5HUYEg+NYZI6ys
        TdZ9WOzOmULNFQbSJ6nW7NurU7UdsyYOwRcUA6RpdSxu/5I6aa80YHnwfM9sc9txZSx6RDYZQKuKA
        nLC+1M7HE+dO1s65g65MSsE+gZ7CtfhvJ0o3/ykva9cPtri8z/htihO6HQScfCLwVPDc/huoPt/fa
        eutWxrA1/4lGppboKZ9V6eNB;
Received: from [2a01:4f8:192:486::6:0] (port=40902 helo=hr6.samba.org) 
        by hr2.samba.org with esmtps (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1jwU2w-0004CM-6m
        for cifs-qa@samba.org; Fri, 17 Jul 2020 17:21:18 +0000
Received: from [::1] (port=26860 helo=bugzilla.samba.org)
        by hr6.samba.org with esmtp (Exim 4.93)
        (envelope-from <samba-bugs@samba.org>)
        id 1jwU2v-006U27-M2
        for cifs-qa@samba.org; Fri, 17 Jul 2020 17:21:17 +0000
From:   samba-bugs@samba.org
To:     cifs-qa@samba.org
Subject: [Bug 14442] Shell command injection vulnerability in mount.cifs
Date:   Fri, 17 Jul 2020 17:21:17 +0000
X-Bugzilla-Reason: QAcontact
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: None
X-Bugzilla-Product: CifsVFS
X-Bugzilla-Component: kernel fs
X-Bugzilla-Version: 2.4
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: major
X-Bugzilla-Who: pc@cjr.nz
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P5
X-Bugzilla-Assigned-To: sfrench@samba.org
X-Bugzilla-Target-Milestone: ---
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-14442-10630-6ZWPinY5i4@https.bugzilla.samba.org/>
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

--- Comment #5 from Paulo Alcantara <pc@cjr.nz> ---
Did some changes after testing and reviewing with Aurelien:

diff --git a/mount.cifs.c b/mount.cifs.c
index 40918c18649f..6c98b9432f10 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1695,6 +1695,73 @@ drop_child_privs(void)
        return 0;
 }

+#ifdef ENABLE_SYSTEMD
+static int get_passwd_by_systemd(const char *prompt, char *input, int
capacity)
+{
+       int fd[2];
+       pid_t pid;
+       int offs =3D 0;
+       int rc =3D 1;
+
+       if (pipe(fd) =3D=3D -1) {
+               fprintf(stderr, "Failed to create pipe: %s\n",
strerror(errno));
+               return 1;
+       }
+
+       pid =3D fork();
+       if (pid =3D=3D -1) {
+               fprintf(stderr, "Unable to fork: %s\n", strerror(errno));
+               close(fd[0]);
+               close(fd[1]);
+               return 1;
+       }
+       if (pid =3D=3D 0) {
+               close(fd[0]);
+               dup2(fd[1], STDOUT_FILENO);
+               if (execlp("systemd-ask-password", "systemd-ask-password",
prompt, NULL) =3D=3D -1) {
+                       fprintf(stderr, "Failed to execute
systemd-ask-password: %s\n",
+                               strerror(errno));
+               }
+               exit(1);
+       }
+
+       close(fd[1]);
+       for (;;) {
+               if (offs+1 >=3D capacity) {
+                       fprintf(stderr, "Password too long.\n");
+                       kill(pid, SIGTERM);
+                       rc =3D 1;
+                       break;
+               }
+               rc =3D read(fd[0], input + offs, capacity - offs);
+               if (rc =3D=3D -1) {
+                       fprintf(stderr, "Failed to read from pipe: %s\n",
strerror(errno));
+                       rc =3D 1;
+                       break;
+               }
+               if (!rc)
+                       break;
+               offs +=3D rc;
+               input[offs] =3D '\0';
+       }
+       if (wait(&rc) =3D=3D -1) {
+               fprintf(stderr, "Failed to wait child: %s\n", strerror(errn=
o));
+               rc =3D 1;
+               goto out;
+       }
+       if (!WIFEXITED(rc) || WEXITSTATUS(rc)) {
+               rc =3D 1;
+               goto out;
+       }
+
+       rc =3D 0;
+
+out:
+       close(fd[0]);
+       return rc;
+}
+#endif
+
 /*
  * If systemd is running and systemd-ask-password --
  * is available, then use that else fallback on getpass(..)
@@ -1714,27 +1781,11 @@ get_password(const char *prompt, char *input, int
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

--=20
You are receiving this mail because:
You are the QA Contact for the bug.=
