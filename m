From: sean finney <seanius-ADwgVSpYHhHR7s880joybQ@public.gmane.org>
Subject: Re: cifs and win2k8
Date: Sun, 23 Oct 2011 12:30:03 +0200
Message-ID: <20111023103003.GA6132@cobija.connexer.com>
References: <4EA154FC.3090601@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Terrence Shipclark <terrence.shipclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4EA154FC.3090601-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Terrence,

On Fri, Oct 21, 2011 at 07:18:20AM -0400, Terrence Shipclark wrote:
> I have been attempting to get the cifs kernel modules to mount the
> win2k8 dfs at my workplace.   I did finally manage to get
> the dfs to mount after modifying the kernel module with this small patch

I believe this should already be fixed (in a more correct fashion) in >= 3.0.

> Within the dfs tree there is a referral to //server/share$/folder.
> My user has access to //server/share$/folder, however do not have
> access to
> //server/$share.  While following the referral the cifs module does a
> QUERY_PATH_INFO on \\server\share$\folder, and then is followed up
> by a QUERY_PATH_INFO on \\server\share$\ which rightfully returns a
> STATUS_ACCESS_DENIED from the server.

I've also noticed that the mounting process seems to query more than
it should, but I've taken the easy way out and asked the local windows
admin to add "traverse filesystem" and "read attributes" permissions on
the parent folders, which should be enough.  I suspect that there is a
"real fix" to avoid this, but haven't looked too hard myself.


	sean
