From: Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH RESEND] cifs: file: initialize oparms.reconnect before
 using it
Date: Mon, 29 Jul 2013 18:35:32 +0200
Message-ID: <20130729163532.GA4254@jack.whiskey>
References: <1375088293-14110-1-git-send-email-andi@etezian.org>
 <20130729093241.437315e1@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Shyti <andi-ahk0KpmfxKRAfugRpC6u6w@public.gmane.org>, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	mikko.rapeli-X3B1VOXEql0@public.gmane.org, pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130729093241.437315e1-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> > +	oparms.tcon = tcon;
> > +	oparms.cifs_sb = cifs_sb;
> > +	oparms.desired_access = desired_access;
> > +	oparms.create_options = create_options;
> 
> This patch just moves the brokenness around. You're
> setting .desired_access here to an unintialized variable.
> create_options also looks like it may potentially be wrong at this
> point.

Urrrca! This is what I achieve when I do one last fix before
going to sleep.

I spent a bit of time more going through the cifs/smb code and
the most sensful fix looks this

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 1e57f36..7e36ae3 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -647,6 +647,7 @@ cifs_reopen_file(struct cifsFileInfo *cfile, bool can_flu
                                     oflags, &oplock, &cfile->fid.netfid, xid
                if (rc == 0) {
                        cifs_dbg(FYI, "posix reopen succeeded\n");
+                       oparms.reconnect = true;
                        goto reopen_success;
                }
                /*

There is only one case when reconnect becames false, that is when
open = smb2_open_file and calls SMB2_open() that calls
add_durable_context() that sets reconnect = false with some
nested ifs in between, and still only in case
everything succeeds. We are checking reconnect only for this
case, otherwise we could get rid of the if (oparms.reconnect) and
not falling into the unknown state.

If it makes sense, I can send the above suggestion.

Thanks,
Andi
