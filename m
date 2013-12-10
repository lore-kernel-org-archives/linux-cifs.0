From: Patrick Noffke <patrick-0qqNeQ6W4hOzQB+pC5nmwQ@public.gmane.org>
Subject: Re: hung system with cifsd, cannot reduce timeout
Date: Tue, 10 Dec 2013 09:15:41 -0600
Message-ID: <3540393.5GuVZWBWRs@dingofarm.qg.com>
References: <52A0EA24.9000600@noffke.me> <52A0F1CB.5060709@noffke.me> <1774674.CzhmRQMMgZ@dingofarm.qg.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1774674.CzhmRQMMgZ-J5+zLgb4AZ5BQzcUTsrH4w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Friday, December 06, 2013 09:50:27 AM Patrick Noffke wrote:
> 
> 
> It seems like the "Getting info on" log message is missing a filename.  Would 
> this explain why it's hung until the server sends a RST?
> 
> There are also logs like the following before the cable is reattached:
> fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> 

In inode.c, in the cifs_revalidate_dentry_attr function, if I add a check for an empty full_path (returning -ENOENT if empty), then the system recovers much faster, but my process gets an error opening the file it was trying to open when the cable was disconnected.  I noticed cifs logs following trying to call cifs_revalidate_dentry_attr with the last file path, but there is a NULL inode for several such calls.

I added this right after the check for a NULL full_path:

	if (0 != strcmp(full_path, "")) {
		cFYI(1, "Got empty full_path");
		rc = -ENOENT;
		goto out;
	}

I don't propose this as a patch -- I'm just curious if I'm on the right track.  Could I return something else, or is there some other way to help the file system recover faster?

Thanks,
Patrick
