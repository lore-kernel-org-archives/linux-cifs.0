From: =?ISO-8859-15?Q?G=FCnter_Kukkukk?= <linux-KQewbsS9MvBBDgjK7y7TUQ@public.gmane.org>
Subject: mount.cifs fails when the share name must be converted to uppercase
 - e.g. for OS/2
Date: Wed, 11 Jun 2014 01:38:09 +0200
Message-ID: <539796E1.3020602@kukkukk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

As discussed in this thread
   https://lists.samba.org/archive/samba/2014-June/182107.html
recent mount.cifs does not allow mounting of OS/2 shares, when
the share name has not been specified in uppercase.

After the first failing mount attempt, mount.cifs then converts
  - host
  - share name
  - prefix
to uppercase and retries the mount.
This worked in former versions - but is failing now.

Using "strace" and looking at the source of mount.cifs.c
      rc =3D mount(orig_dev, ".", cifs_fstype, parsed_info->flags, opti=
ons);
i noticed that the passed "orig_dev" parameter (e.g. //server/share) wa=
s
not converted to uppercase.

I also converted orig_dev to uppercase and it was working again:

diff --git a/mount.cifs.c b/mount.cifs.c
index 497665d..3535096 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -2097,7 +2097,8 @@ mount_retry:
                        if (!already_uppercased &&
                            uppercase_string(parsed_info->host) &&
                            uppercase_string(parsed_info->share) &&
-                           uppercase_string(parsed_info->prefix)) {
+                           uppercase_string(parsed_info->prefix) &&
+                           uppercase_string(orig_dev)) {
                                fprintf(stderr,
                                        "Retrying with upper case share=
 name\n");
                                already_uppercased =3D 1;


I'm not a mount expert and only had a short look at the source, but
probably this is the culprit.

Should i open a bug report for this?

Cheers, G=FCnter
--=20
