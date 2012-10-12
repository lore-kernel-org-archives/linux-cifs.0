From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: IPv6 mount support
Date: Fri, 12 Oct 2012 07:39:10 -0400
Message-ID: <CAFB9KM2GbrVzE+UEatrV5-QH_iT_Vu4Z0=o3GmezEJo_uKsyWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In mount.cifs.c's parse_unc(), there's a FIXME to support IPv6 path
parsing.  Is there any reason that simply grabbing the last instance
of the ':' character wouldn't work?  Something like this:
@@ -1342,7 +1342,7 @@ static int parse_unc(const char *unc_name,
struct parsed_mount_info *parsed_info
                 * FIXME: IPv6 addresses?
                 */
                host = unc_name;
-               share = strchr(host, ':');
+               share = strrchr(host, ':');
                if (!share) {
                        fprintf(stderr, "mount.cifs: bad UNC (%s)\n", unc_name);
                        return EX_USAGE;


I'm reasonably sure that somebody smarter than myself has already
thought of this, so there must be more to the problem that I'm seeing.
--
Peace and Blessings,
-Scott.
