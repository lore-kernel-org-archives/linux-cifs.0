Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38400C19F2B
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Aug 2022 20:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238739AbiHCUaX convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Aug 2022 16:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238748AbiHCUaM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Aug 2022 16:30:12 -0400
Received: from smtp.polymtl.ca (smtp.polymtl.ca [132.207.4.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DE965B7AE
        for <linux-cifs@vger.kernel.org>; Wed,  3 Aug 2022 13:30:08 -0700 (PDT)
Received: from comms3.kousu.ca (comms3.kousu.ca [46.23.90.174])
        by smtp.polymtl.ca (8.14.7/8.14.7) with ESMTP id 273KU0ww005565
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 3 Aug 2022 16:30:05 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.polymtl.ca 273KU0ww005565
Received: from comms.kousu.ca (localhost [127.0.0.1])
        by comms3.kousu.ca (OpenSMTPD) with ESMTP id 8b26d21d;
        Wed, 3 Aug 2022 22:29:59 +0200 (CEST)
MIME-Version: 1.0
Date:   Wed, 03 Aug 2022 20:29:59 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: RainLoop/1.16.0
From:   "Nick Guenther" <nick.guenther@polymtl.ca>
Message-ID: <57efeb6859dbc2a38714fba882a7635b@polymtl.ca>
Subject: Re: [PATCH] pam_cifscreds, tmux and session keyrings
To:     "CIFS" <linux-cifs@vger.kernel.org>
Cc:     "Shyam Prasad N" <nspmangalore@gmail.com>,
        "Steve French" <smfrench@gmail.com>
In-Reply-To: <CAH2r5mu187eVH3pH=Ltzf8ZKaumydYEbMTjz5jxa2BdkoWYoaQ@mail.gmail.com>
References: <CAH2r5mu187eVH3pH=Ltzf8ZKaumydYEbMTjz5jxa2BdkoWYoaQ@mail.gmail.com>
 <774233f766bf26976c0d923cc1dc53c7@polymtl.ca>
 <705265ea-37a3-6029-362a-572bbaab6639@gmail.com>
 <0371d16e831be9cd9595c443d142e5fc@polymtl.ca>
X-Poly-FromMTA: (comms3.kousu.ca [46.23.90.174]) at Wed,  3 Aug 2022 20:30:00 +0000
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

August 1, 2022 12:10 AM, "Steve French" <smfrench@gmail.com> wrote:

> Adding Shyam to this discussion - interesting questions worth investigating.
> 
> On Thu, Jul 28, 2022 at 9:50 PM Nick Guenther <nick.guenther@polymtl.ca> wrote:
>> I've figured out a workaround, but I'm unsure about it and I could really use some advice from
>> people with more insight.
>> 
>> I just to remove the 'revoke' option and the problem goes away:
>> 
>> # cat /etc/pam.d/sshd | grep keyinit
>> session optional pam_keyinit.so force
>> 
>> This keeps the session-keyring(7) working even after reattaching [to tmux]
>> 
>> Would there be interest in switching to KEY_SPEC_USER_KEYRING? Would it be a good idea? Can I
>> assume the kernel CIFS code would need a matching change?

I've written a patch that switches cifs-utils to KEY_SPEC_USER_KEYRING. It seems to behave -- `keylist list @u` shows the cifs key instead of `keyctl list @s` -- but it doesn't solve my problem without being combined with the 'revoke' workaround, because the kernel is still using KEY_SPEC_SESSION_KEYRING.

I'm sending it anyway to see if there's any interest. I've never touched kernel-adjacent code before, so honestly I'm kind of scared of this. Maybe it'd be better to solve this in tmux -- is there some way to make tmux pin the keyring? Copy the existing keyring it inherits to a new KEY_SPEC_SESSION_KEYRING when it starts? But if you agree with the systemd people (https://github.com/systemd/systemd/issues/1299#issuecomment-141937177), please consider this.

I've also never used `git send-email` or `git format-patch` before, so I don't know if this is the right ettiquette for attaching a patch. Hopefully you can be patient as I figure it out.


From c73603f67bc945708e997e7e9585fd76575542e2 Mon Sep 17 00:00:00 2001
From: Nick Guenther <nick.guenther@polymtl.ca>
Date: Thu, 28 Jul 2022 11:00:15 -0400
Subject: [PATCH] Switch pam_cifscreds to user-keyring(7).

This makes CIFS credentials persist even in detached
shells like screen(1) or tmux(1) that outlive the
original login shell that spawned them.

However, the CIFS code in the kernel needs a patch
to match this change for this to be any use.
---
cifscreds.c | 39 +------
cifskey.h | 2 +-
pam_cifscreds.c | 290 +++++++++++++++++++++++++++++++-----------------
3 files changed, 194 insertions(+), 137 deletions(-)

diff --git a/cifscreds.c b/cifscreds.c
index 32f2ee4..afea136 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -279,7 +279,7 @@ static int cifscreds_clear(struct cmdarg *arg)

/*
* search for same credentials stashed for current host
- * and unlink them from session keyring
+ * and unlink them from keyring
*/
currentaddress = addrstr;
nextaddress = strchr(currentaddress, ',');
@@ -326,7 +326,7 @@ static int cifscreds_clearall(struct cmdarg *arg __attribute__ ((unused)))
int count = 0, errors = 0;

/*
- * search for all program's credentials stashed in session keyring
+ * search for all program's credentials stashed in keyring
* and then unlink them
*/
do {
@@ -386,7 +386,7 @@ static int cifscreds_update(struct cmdarg *arg)
return EXIT_FAILURE;
}

- /* search for necessary credentials stashed in session keyring */
+ /* search for necessary credentials stashed in keyring */
currentaddress = addrstr;
nextaddress = strchr(currentaddress, ',');
if (nextaddress)
@@ -428,36 +428,6 @@ static int cifscreds_update(struct cmdarg *arg)
return EXIT_SUCCESS;
}

-static int
-check_session_keyring(void)
-{
- key_serial_t ses_key, uses_key;
-
- ses_key = keyctl_get_keyring_ID(KEY_SPEC_SESSION_KEYRING, 0);
- if (ses_key == -1) {
- if (errno == ENOKEY)
- fprintf(stderr, "Error: you have no session keyring. "
- "Consider using pam_keyinit to "
- "install one.\n");
- else
- fprintf(stderr, "Error: unable to query session "
- "keyring: %s\n", strerror(errno));
- return (int)ses_key;
- }
-
- /* A problem querying the user-session keyring isn't fatal. */
- uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_SESSION_KEYRING, 0);
- if (uses_key == -1)
- return 0;
-
- if (ses_key == uses_key)
- fprintf(stderr, "Warning: you have no persistent session "
- "keyring. cifscreds keys will not persist "
- "after this process exits. See "
- "pam_keyinit(8).\n");
- return 0;
-}
-
int main(int argc, char **argv)
{
struct command *cmd, *best;
@@ -531,8 +501,5 @@ int main(int argc, char **argv)
if (arg.user == NULL)
arg.user = getusername(getuid());

- if (check_session_keyring())
- return EXIT_FAILURE;
-
return best->action(&arg);
}
diff --git a/cifskey.h b/cifskey.h
index ed0c469..8217e58 100644
--- a/cifskey.h
+++ b/cifskey.h
@@ -36,7 +36,7 @@
#define DOMAIN_DISALLOWED_CHARS "\\/:*?\"<>|"

/* destination keyring */
-#define DEST_KEYRING KEY_SPEC_SESSION_KEYRING
+#define DEST_KEYRING KEY_SPEC_USER_KEYRING
#define CIFS_KEY_TYPE "logon"
#define CIFS_KEY_PERMS (KEY_POS_VIEW|KEY_POS_WRITE|KEY_POS_SEARCH| \
KEY_USR_VIEW|KEY_USR_WRITE|KEY_USR_SEARCH)
diff --git a/pam_cifscreds.c b/pam_cifscreds.c
index 5d99c2d..ba3aea9 100644
--- a/pam_cifscreds.c
+++ b/pam_cifscreds.c
@@ -25,13 +25,16 @@
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
+#include <stdbool.h>
#include <string.h>
#include <syslog.h>
#include <sys/types.h>
-/*
-#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>
+#include <pwd.h>
+
+/*
+#include <signal.h>
*/

#include <keyutils.h>
@@ -192,72 +195,126 @@ static int cifscreds_pam_add(pam_handle_t *ph, const char *user, const char
*pas
return PAM_SERVICE_ERR;
}

- /* search for same credentials stashed for current host */
- currentaddress = addrstr;
- nextaddress = strchr(currentaddress, ',');
- if (nextaddress)
- *nextaddress++ = '\0';

- while (currentaddress) {
- if (key_search(currentaddress, keytype) > 0) {
- pam_syslog(ph, LOG_WARNING, "You already have stashed credentials "
- "for %s (%s)", currentaddress, hostdomain);
+ // Impersonate target user.
+ //
+ // PAM runs as root, so if DEST_KEYRING == KEY_SPEC_USER_KEYRING or
+ // KEY_SPEC_USER_SESSION_KEYRING, the credentials would be cached by root,
+ // uselessly. This isn't needed for DEST_KEYRING == KEY_SPEC_SESSION_KEYRING
+ // which gets inherited by the child process tree of the ultimate login shell.
+ //
+ // The main work has to be done in a subprocess, because only the real UID has rights to edit
that UID's keyring
+ // so we have to call setuid(), but we can't un-setuid() later, yet we still need to be root for
the other PAM modules to behave.
+ errno = 0;
+ struct passwd *pwnam = getpwnam(user);
+ if(pwnam == NULL) {
+ pam_syslog(ph, LOG_ERR, "getpwnam(): %s", strerror(errno));
+ return PAM_SERVICE_ERR;
+ }

- return PAM_SERVICE_ERR;
- }
+ pid_t keyring_process = fork();
+ if(keyring_process == -1) {
+ pam_syslog(ph, LOG_ERR, "fork(): %s", strerror(errno));
+ return PAM_SERVICE_ERR;
+ } else if(keyring_process == 0) {
+ // child process

- switch(errno) {
- case ENOKEY:
- /* success */
- break;
- default:
- pam_syslog(ph, LOG_ERR, "Unable to search keyring for %s (%s)",
- currentaddress, strerror(errno));
- return PAM_SERVICE_ERR;
+ if(setgid(pwnam->pw_gid) < 0) {
+ pam_syslog(ph, LOG_ERR, "setegid(): %s", strerror(errno));
+ exit(PAM_SERVICE_ERR);
}
-
- currentaddress = nextaddress;
- if (currentaddress) {
- *(currentaddress - 1) = ',';
- nextaddress = strchr(currentaddress, ',');
- if (nextaddress)
- *nextaddress++ = '\0';
+ if(setuid(pwnam->pw_uid) < 0) {
+ pam_syslog(ph, LOG_ERR, "seteuid(): %s", strerror(errno));
+ exit(PAM_SERVICE_ERR);
}
- }

- /* Set the password */
- currentaddress = addrstr;
- nextaddress = strchr(currentaddress, ',');
- if (nextaddress)
- *nextaddress++ = '\0';
-
- while (currentaddress) {
- key_serial_t key = key_add(currentaddress, user, password, keytype);
- if (key <= 0) {
- pam_syslog(ph, LOG_ERR, "error: Add credential key for %s: %s",
- currentaddress, strerror(errno));
- } else {
- if ((args & ARG_DEBUG) == ARG_DEBUG) {
- pam_syslog(ph, LOG_DEBUG, "credential key for \\\\%s\\%s added",
- currentaddress, user);
+ /* search for same credentials stashed for current host */
+ currentaddress = addrstr;
+ nextaddress = strchr(currentaddress, ',');
+ if (nextaddress)
+ *nextaddress++ = '\0';
+
+ while (currentaddress) {
+ if (key_search(currentaddress, keytype) > 0) {
+ pam_syslog(ph, LOG_WARNING, "You already have stashed credentials "
+ "for %s (%s)", currentaddress, hostdomain);
+
+ exit(PAM_SERVICE_ERR);
+ }
+
+ switch(errno) {
+ case ENOKEY:
+ /* success */
+ break;
+ default:
+ pam_syslog(ph, LOG_ERR, "Unable to search keyring for %s (%s)",
+ currentaddress, strerror(errno));
+ exit(PAM_SERVICE_ERR);
+ }
+
+ currentaddress = nextaddress;
+ if (currentaddress) {
+ *(currentaddress - 1) = ',';
+ nextaddress = strchr(currentaddress, ',');
+ if (nextaddress)
+ *nextaddress++ = '\0';
}
- if (keyctl(KEYCTL_SETPERM, key, CIFS_KEY_PERMS) < 0) {
- pam_syslog(ph, LOG_ERR,"error: Setting permissons "
- "on key, attempt to delete...");
-
- if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
- pam_syslog(ph, LOG_ERR, "error: Deleting key from "
- "keyring for %s (%s)",
- currentaddress, hostdomain);
+ }
+
+ /* Set the password */
+ currentaddress = addrstr;
+ nextaddress = strchr(currentaddress, ',');
+ if (nextaddress)
+ *nextaddress++ = '\0';
+
+ while (currentaddress) {
+ key_serial_t key = key_add(currentaddress, user, password, keytype);
+ if (key <= 0) {
+ pam_syslog(ph, LOG_ERR, "error: Add credential key for %s: %s",
+ currentaddress, strerror(errno));
+ } else {
+ if ((args & ARG_DEBUG) == ARG_DEBUG) {
+ pam_syslog(ph, LOG_DEBUG, "credential key for \\\\%s\\%s added",
+ currentaddress, user);
+ }
+ if (keyctl(KEYCTL_SETPERM, key, CIFS_KEY_PERMS) < 0) {
+ pam_syslog(ph, LOG_ERR,"error: Setting permissons "
+ "on key, attempt to delete...");
+
+ if (keyctl(KEYCTL_UNLINK, key, DEST_KEYRING) < 0) {
+ pam_syslog(ph, LOG_ERR, "error: Deleting key from "
+ "keyring for %s (%s)",
+ currentaddress, hostdomain);
+ }
}
}
+
+ currentaddress = nextaddress;
+ if (currentaddress) {
+ nextaddress = strchr(currentaddress, ',');
+ if (nextaddress)
+ *nextaddress++ = '\0';
+ }
+
+ }
+
+ exit(0);
+ } else {
+ // parent process
+ int wstatus;
+ if(waitpid(keyring_process, &wstatus, 0) < 0) {
+ pam_syslog(ph, LOG_ERR, "waitpid(): %s", strerror(errno));
+ return PAM_SERVICE_ERR;
}

- currentaddress = nextaddress;
- if (currentaddress) {
- nextaddress = strchr(currentaddress, ',');
- if (nextaddress)
- *nextaddress++ = '\0';
+ if(WIFEXITED(wstatus)) {
+ if(WEXITSTATUS(wstatus) != 0) {
+ pam_syslog(ph, LOG_ERR, "keyring subprocess failed: %x", WEXITSTATUS(wstatus));
+ return WEXITSTATUS(wstatus);
+ }
+ } else {
+ pam_syslog(ph, LOG_ERR, "keyring subprocess terminated abnormally: %x", wstatus);
+ return PAM_SERVICE_ERR;
}
}

@@ -311,34 +368,86 @@ static int cifscreds_pam_update(pam_handle_t *ph, const char *user, const
char *
return PAM_SERVICE_ERR;
}

- /* search for necessary credentials stashed in session keyring */
- currentaddress = addrstr;
- nextaddress = strchr(currentaddress, ',');
- if (nextaddress)
- *nextaddress++ = '\0';
-
- while (currentaddress) {
- if (key_search(currentaddress, keytype) > 0)
- count++;
-
- currentaddress = nextaddress;
- if (currentaddress) {
- nextaddress = strchr(currentaddress, ',');
- if (nextaddress)
- *nextaddress++ = '\0';
- }
+ // Impersonate target user.
+ //
+ // PAM runs as root, so if DEST_KEYRING == KEY_SPEC_USER_KEYRING or
+ // KEY_SPEC_USER_SESSION_KEYRING, the credentials would be cached by root,
+ // uselessly. This isn't needed for DEST_KEYRING == KEY_SPEC_SESSION_KEYRING
+ // which gets inherited by the child process tree of the ultimate login shell.
+ //
+ // The main work has to be done in a subprocess, because only the real UID has rights to edit
that UID's keyring
+ // so we have to call setuid(), but we can't un-setuid() later, yet we still need to be root for
the other PAM modules to behave.
+ errno = 0;
+ struct passwd *pwnam = getpwnam(user);
+ if(pwnam == NULL) {
+ pam_syslog(ph, LOG_ERR, "getpwnam(): %s", strerror(errno));
+ return PAM_SERVICE_ERR;
}

- if (!count) {
- pam_syslog(ph, LOG_ERR, "You have no same stashed credentials for %s", hostdomain);
+ pid_t keyring_process = fork();
+ if(keyring_process == -1) {
+ pam_syslog(ph, LOG_ERR, "fork(): %s", strerror(errno));
return PAM_SERVICE_ERR;
- }
+ } else if(keyring_process == 0) {
+ // child process
+
+ if(setgid(pwnam->pw_gid) < 0) {
+ pam_syslog(ph, LOG_ERR, "setegid(): %s", strerror(errno));
+ exit(PAM_SERVICE_ERR);
+ }
+ if(setuid(pwnam->pw_uid) < 0) {
+ pam_syslog(ph, LOG_ERR, "seteuid(): %s", strerror(errno));
+ exit(PAM_SERVICE_ERR);
+ }

- for (id = 0; id < count; id++) {
- key_serial_t key = key_add(currentaddress, user, password, keytype);
- if (key <= 0) {
- pam_syslog(ph, LOG_ERR, "error: Update credential key for %s: %s",
- currentaddress, strerror(errno));
+ /* search for necessary credentials stashed in session keyring */
+ currentaddress = addrstr;
+ nextaddress = strchr(currentaddress, ',');
+ if (nextaddress)
+ *nextaddress++ = '\0';
+
+ while (currentaddress) {
+ if (key_search(currentaddress, keytype) > 0)
+ count++;
+
+ currentaddress = nextaddress;
+ if (currentaddress) {
+ nextaddress = strchr(currentaddress, ',');
+ if (nextaddress)
+ *nextaddress++ = '\0';
+ }
+ }
+
+ if (!count) {
+ pam_syslog(ph, LOG_ERR, "You have no same stashed credentials for %s", hostdomain);
+ exit(PAM_SERVICE_ERR);
+ }
+
+ for (id = 0; id < count; id++) {
+ key_serial_t key = key_add(currentaddress, user, password, keytype);
+ if (key <= 0) {
+ pam_syslog(ph, LOG_ERR, "error: Update credential key for %s: %s",
+ currentaddress, strerror(errno));
+ }
+ }
+
+ exit(0);
+ } else {
+ // parent process
+ int wstatus;
+ if(waitpid(keyring_process, &wstatus, 0) < 0) {
+ pam_syslog(ph, LOG_ERR, "waitpid(): %s", strerror(errno));
+ return PAM_SERVICE_ERR;
+ }
+
+ if(WIFEXITED(wstatus)) {
+ if(WEXITSTATUS(wstatus) != 0) {
+ pam_syslog(ph, LOG_ERR, "keyring subprocess failed: %x", WEXITSTATUS(wstatus));
+ return WEXITSTATUS(wstatus);
+ }
+ } else {
+ pam_syslog(ph, LOG_ERR, "keyring subprocess terminated abnormally: %x", wstatus);
+ return PAM_SERVICE_ERR;
}
}

@@ -426,7 +535,6 @@ PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, int flags
__attribute__((un
const char *hostdomain = NULL;
uint args;
int retval;
- key_serial_t ses_key, uses_key;

args = parse_args(ph, argc, argv, &hostdomain);

@@ -460,24 +568,6 @@ PAM_EXTERN int pam_sm_open_session(pam_handle_t *ph, int flags
__attribute__((un
return PAM_SERVICE_ERR;
}

- /* make sure there is a session keyring */
- ses_key = keyctl_get_keyring_ID(KEY_SPEC_SESSION_KEYRING, 0);
- if (ses_key == -1) {
- if (errno == ENOKEY)
- pam_syslog(ph, LOG_ERR, "you have no session keyring. "
- "Consider using pam_keyinit to "
- "install one.");
- else
- pam_syslog(ph, LOG_ERR, "unable to query session "
- "keyring: %s", strerror(errno));
- }
-
- /* A problem querying the user-session keyring isn't fatal. */
- uses_key = keyctl_get_keyring_ID(KEY_SPEC_USER_SESSION_KEYRING, 0);
- if ((uses_key >= 0) && (ses_key == uses_key))
- pam_syslog(ph, LOG_ERR, "you have no persistent session "
- "keyring. cifscreds keys will not persist.");
-
return cifscreds_pam_add(ph, user, password, args, hostdomain);
}

--
2.34.1
