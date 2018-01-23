From: Kenneth Dsouza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: manpage: update mount.cifs manpage with info about echo_interval option.
Date: Tue, 23 Jan 2018 23:07:16 +0530
Message-ID: <CAA_-hQJ=DsbeVWU7mr-W0sTRiPXnCC3vznmznQwBedQLtE0s_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by:  Kenneth D'souza <kdsouza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

diff --git a/mount.cifs.rst b/mount.cifs.rst
index 023ff34..efd7055 100644
--- a/mount.cifs.rst
+++ b/mount.cifs.rst
@@ -385,6 +385,14 @@ mfsymlinks
   option. Minshall+French symlinks are used even if the server supports
   the CIFS Unix Extensions.

+echo_interval=n
+  sets the interval at which echo requests are sent to the server on an
+  idling connection. This setting also affects the time required
+  for a connection to an unresponsive server to timeout.
+  Here n is the echo interval in seconds. If this option is not given then
+  the default value of 60 seconds is used.
+  The minimum tunable value is 1 second and maximum can go up to 600 seconds.
+
 serverino
   Use inode numbers (unique persistent file identifiers) returned by the
   server instead of automatically generating temporary inode numbers on




Kind Regards,
Kenneth D'souza
