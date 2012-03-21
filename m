From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: use standard token parser for mount options
Date: Wed, 21 Mar 2012 13:38:55 -0400
Message-ID: <20120321133855.52901c60@redhat.com>
References: <1331307197.10670.2.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1331307197.10670.2.camel@localhost>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 09 Mar 2012 15:33:17 +0000
Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> Use the standard token parser instead of the long if confidtion to parse
> cifs mount options.
> 
> This was first proposed by Scott Lovenberg
> http://lists.samba.org/archive/linux-cifs-client/2010-May/006079.html
> 
> Mount options have been grouped together in terms of their input types.
> Aliases for username, password, domain and credentials have been added.
> The password parser has been modified to make it easier to read.
> 
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 


In testing this today, I found a problem. I tried to mount up a share
with sec=none as the options. With that, I got this error:

    CIFS: Unknown mount option pass=

The problem is that the mount.cifs helper will pass a blank "pass="
option to the kernel. It seems like the standard option parser doesn't
have a way to allow you to specify an optional argument. That may need
to be added in order for this to work.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
