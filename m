From: H Han <hanhanzhiyeqianke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: A patch to fix the segment fault when no sub-command
Date: Sun, 15 Nov 2015 09:25:11 +0800
Message-ID: <CAK7bb8a7iGrJ6WPQqrCnWdXwwFKpd7E68CqLs3vFQ7noZOMF5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Bug is reported on Redhat Bugzilla, id 1278543.
When use the invalid command like:
# cifscreds -u root
Will get a segment fault.
Add a argument check to avoid the segment fault when no sub-command, and
return with stderr 'Need command'.

diff --git a/cifscreds.c b/cifscreds.c
index 5d84c3c..bb63369 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -488,6 +488,13 @@ int main(int argc, char **argv)
        }

        /* find the best fit command */
+
+        /* check if there is sub-command */
+        if (argv[optind] == NULL) {
+                fprintf(stderr, "Need command\n");
+                return EXIT_FAILURE;
+        }
+
        best = NULL;
        n = strnlen(argv[optind], MAX_COMMAND_SIZE);
