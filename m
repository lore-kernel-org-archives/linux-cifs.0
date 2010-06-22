From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: your mount.cifs patch
Date: Mon, 21 Jun 2010 20:52:08 -0400
Message-ID: <20100621205208.61327751@corrin.poochiereds.net>
References: <AANLkTil8VYcSFyOFKa7vALHc60K0njtNCeZ7YwYJuKuE@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John M Rulnick <john-euQKGi/78XpBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTil8VYcSFyOFKa7vALHc60K0njtNCeZ7YwYJuKuE-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 21 Jun 2010 20:12:33 -0400
John M Rulnick <john-euQKGi/78XpBDgjK7y7TUQ@public.gmane.org> wrote:

> Jeff,
> 
> I'm trying to understand your patch posted Mar. 26.  I'm using mount.cifs
> (smbmount) and getting "Unable to find suitable address" intermittently.
>  What would cause this error when trying to mount a guest share y on host x
> via 'smbmount //x/y /my/mountpoint'.  I always use the exact same command;
> sometimes I'm able to mount the remote share, and sometimes I get the
> aforementioned error -- no apparent pattern.
> 
> Debian *testing* client and samba server, small local network.  Cifs-utils
> package 2:4.5-2, kernel 2.6.32-5 on client; kernel 2.6.32-15 on server.
> 
> Thank you for any insight you can provide.
> 
> John

(cc'ing linux-cifs mailing list)

mount.cifs will first resolve the hostname to a list of addresses and
then hand each off to the kernel in turn until the mount succeeds. If
none of them work, you'll get that error.

You may want to turn up client side debugging:

http://wiki.samba.org/index.php?title=LinuxCIFS_troubleshooting&redirect=no

...and see why the mounts are failing.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
