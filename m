From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: multiuser mount without initial mount credentials
Date: Thu, 14 Nov 2013 08:14:07 -0500
Message-ID: <20131114081407.559ab169@tlielax.poochiereds.net>
References: <528407E4.3030205@cora.nwra.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <528407E4.3030205-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 13 Nov 2013 16:14:44 -0700
Orion Poplawski <orion-CVdf0l11yl+B+jHODAdFcQ@public.gmane.org> wrote:

> Is there any possibility of removing the requirement to have an initial set of 
> credentials when mounting a cifs filesystem as multiuser?  I'd like to have an 
> automount driven multiuser configuration without the need to have a separate 
> set of credentials just for mounting.  Could we imaging some way for the 
> automount process to access a keyring stored credential for use in mounting?
> 

One possibility would be to teach the kernel how to use an anonymous
logon (equivalent to what we do with sec=none) for the initial mount.
That would take a bit of reengineering but it's possible.

Also, if you pass credentials to the mount command then those
credentials will just be used for root access. e.g. something like this:

    sec=ntlmssp,username=foo,password=bar,multiuser

You probably don't want to put that in a mount command, but you could
use a credentials file (see mount.cifs(8)).

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
