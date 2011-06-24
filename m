From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Call id to SID mapping functions to change
 owner/group (try #2)
Date: Fri, 24 Jun 2011 13:43:00 -0400
Message-ID: <20110624134300.2b9411bc@tlielax.poochiereds.net>
References: <1308607283-17038-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308607283-17038-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 20 Jun 2011 17:01:23 -0500
shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:

> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> 
> 
> Now build security descriptor to change either owner or group at the
> server.  Initially security descriptor was built to change only
> ACL, that functionality has been extended.
> 
> When either an Owner or Group of a file object at the server is changed,
> rest of security descriptor remains same (DACL etc.).
> 
> To set security descriptor, it is essential to open that file
> with WRITE_DAC as well as WRITE_OWNER (Take Ownership) permission bits.
> Function set_cifs_acl_by_fid() has been removed since we can't be
> sure how a file was opened for writing, a valid request can fail
> if the file was not opened with two above mentioned permissions.
> 
> It is the server that decides whether a set security descriptor with
> either owner or group change succeeds or not.
> 

I'd like to see an explanation for what problem this solves and why
this is useful.

Why should I care about this set? With this, what can I do that I
couldn't do before -- chown()/chgrp()? Also, how was this set tested?
In particular I'd like to understand how you tested the part that
handles chown(). Doesn't that require mounting as a user that has
elevated permissions?

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
