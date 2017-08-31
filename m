From: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Subject: RFC: Revert move default dialect from CIFS to to SMB3"
Date: Thu, 31 Aug 2017 23:01:38 +0200
Message-ID: <1504213298-27431-1-git-send-email-linux@leemhuis.info>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This reverts commit eef914a9eb5eb83e60eb498315a491cd1edc13a1 (
[SMB3] Improve security, move default dialect to SMB3 from old CIFS), 
as it confuses users: https://bugzilla.kernel.org/show_bug.cgi?id=196599

It was a patch to improve security by switching to SMB3 by default and
support SMB1 (aka CIFS) only when explicitly requested, as the latter
is not considered secure anymore (see below for details). This is one of
the rare cases where regressions are unavoidable and accepted in Linux.
But that's bad enough already, so we at least should make it easy for
people to get an idea why something suddenly stopped working with a
newer kernel version. That's not the case, because due to eef914a9eb5e
a mount of a server that only supports CIFS/SMB1 with mount.cifs fails
with a misleading message:

> mount error(112): Host is down > Refer to the mount.cifs(8) manual
> page (e.g. man mount.cifs)

The corresponding message in the kernel log is just as unhelpful:

> CIFS VFS: cifs_mount failed w/return code = -112

This needs to be improved. Hence remove this for now, as the world won't
end suddenly if this gets delayed one or two cycles and resubmitted in
a way that leads to a more helpful error message.

For completeness, here are parts from the original patch description:

> Due to recent publicity about security vulnerabilities in the much
> older CIFS dialect, move the default dialect to the widely accepted
> (and quite secure) SMB3.0 dialect from the old default of the CIFS
> dialect.
>
> We do not want to be encouraging use of less secure dialects, and
> both Microsoft and CERT now strongly recommend not using the older
> CIFS dialect (SMB Security Best Practices "recommends disabling
> SMBv1").
>
> SMB3 is both secure and widely available: in Windows 8 and later,
> Samba and Macs.
>
> Users can still choose to explicitly mount with the less secure
> dialect (for old servers) by choosing "vers=1.0" on the cifs mount

Signed-off-by: Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
CC: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
CC: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/connect.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 59647eb..6ab261cd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1272,9 +1272,9 @@ static int cifs_parse_security_flavors(char *value,
 
 	vol->actimeo = CIFS_DEF_ACTIMEO;
 
-	/* FIXME: add autonegotiation for SMB3 or later rather than just SMB3 */
-	vol->ops = &smb30_operations; /* both secure and accepted widely */
-	vol->vals = &smb30_values;
+	/* FIXME: add autonegotiation -- for now, SMB1 is default */
+	vol->ops = &smb1_operations;
+	vol->vals = &smb1_values;
 
 	vol->echo_interval = SMB_ECHO_INTERVAL_DEFAULT;
 
-- 
1.8.3.1
