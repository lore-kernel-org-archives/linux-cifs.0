From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: queued patches for 3.10
Date: Fri, 24 May 2013 07:49:37 -0400
Message-ID: <20130524074937.0f225d12@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I just noticed that this patch is still not in mainline:

    cifs: only set ops for inodes in I_NEW state

...is there a problem with it? It really needs to go in soon if not.

Also, I posted a few other patches on Tuesday that need to go into 3.10
as well:

    cifs: fix error handling when calling cifs_parse_devname
    cifs: allow sec=none mounts to work against servers that don't support extended security
    cifs: stop printing the unc= option in /proc/mounts

...this one also needs to go to stable:

    cifs: fix potential buffer overrun when composing a new options string

...and the last version of this patch that I posted should have had a
[PATCH v3] in the subject, but I forgot to add that:

    cifs: fix composing of mount options for DFS referrals

...that patch is based on top of the previous patch that's slated for
stable. All of these patches are in my cifs-3.10 branch if you want to
just cherry-pick them from there:

    http://git.samba.org/?p=jlayton/linux.git;a=shortlog;h=refs/heads/cifs-3.10

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
