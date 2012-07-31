From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: warning about default security mechanism
Date: Tue, 31 Jul 2012 07:34:00 -0400
Message-ID: <20120731073400.7f1f17a1@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Now that the 3.6 merge window is open, perhaps it's time to do
something about this warning message which is still popping? What's the
plan with this thing? Can we go ahead and pull the trigger on this or
what?

[ 1663.969662] CIFS VFS: default security mechanism requested.  The
default security mechanism will be upgraded from ntlm to ntlmv2 in
kernel release 3.3

Note that I also see this with SMB2 mounts which is really goofy.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
