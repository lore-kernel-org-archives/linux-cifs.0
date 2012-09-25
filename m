From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] manpage: clarify the user of the username= option
Date: Tue, 25 Sep 2012 06:52:46 -0400
Message-ID: <1348570366-17466-1-git-send-email-jlayton@samba.org>
Cc: walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Specifying the username as "user=" can confuse some versions of /bin/mount,
and cause it to append noexec to the mount string. Also, remove the blurb
about how cifs.ko will accept abbreviations -- it's just bad practice.

A wonderful example of this confusion was reported by Stefan here:

    https://bugzilla.redhat.com/show_bug.cgi?id=860154

Reported-by: Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mount.cifs.8 | 24 ++----------------------
 1 file changed, 2 insertions(+), 22 deletions(-)

diff --git a/mount.cifs.8 b/mount.cifs.8
index cca6048..5629e84 100644
--- a/mount.cifs.8
+++ b/mount.cifs.8
@@ -52,33 +52,13 @@ command displays the version of cifs mount helper\&.
 command displays the version of cifs module\&.
 .SH "OPTIONS"
 .PP
-user=\fIarg\fR
+username=\fIarg\fR
 .RS 4
 specifies the username to connect as\&. If this is not given, then the environment variable
 \fIUSER\fR
 is used\&.
 .PP
-Earlier versions of mount.cifs also allowed one to specify the username in a "user%password" or "workgroup/user" or "workgroup/user%password" to allow the password and workgroup to be specified as part of the username. Support for those alternate username formats is now deprecated and should no longer be used. Users should use the discrete "pass=" and "dom=" to specify the username.
-.if n \{\
-.sp
-.\}
-.RS 4
-.it 1 an-trap
-.nr an-no-space-flag 1
-.nr an-break-flag 1
-.br
-.ps +1
-\fBNote\fR
-.ps -1
-.br
-The cifs vfs accepts the parameter
-\fIuser=\fR, or for users familiar with smbfs it accepts the longer form of the parameter
-\fIusername=\fR\&. Similarly the longer smbfs style parameter names may be accepted as synonyms for the shorter cifs parameters
-\fIpass=\fR,\fIdom=\fR
-and
-\fIcred=\fR\&.
-.sp .5v
-.RE
+Earlier versions of mount.cifs also allowed one to specify the username in a "user%password" or "workgroup/user" or "workgroup/user%password" to allow the password and workgroup to be specified as part of the username. Support for those alternate username formats is now deprecated and should no longer be used. Users should use the discrete "password=" and "domain=" to specify those values. While some versions of the cifs kernel module accept "user=" as an abbreviation for this option, its use can confuse the standard mount program into thinking that this is a non-superuser mount.
 .RE
 .PP
 password=\fIarg\fR
-- 
1.7.11.4
