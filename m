From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: long cifs timeout when share becomes unavailable
Date: Thu, 24 May 2012 06:31:31 -0400
Message-ID: <20120524063131.5bc93ecf@tlielax.poochiereds.net>
References: <4FBDD189.6040402@telros.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FBDD189.6040402-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 24 May 2012 10:13:29 +0400
Sergey Urushkin <urushkin-MKmKHxvQ5r6HXe+LvDLADg@public.gmane.org> wrote:

> Hi,
> 
> there are issues with cifs share mounted via mount.cifs (with recent
> kernels): the first 'ls' on the dir where cifs share is mounted after the
> server becomes unavailable 1) hangs (can't be interrupted with ^C) and 2)
> lasts about 5 minutes. The first problem appears everywhere I tested
> (ubuntu 10.04 with any distributed kernel, ubuntu 12.04, fedora 17), but
> with old kernels (tested with ubuntu 10.04 2.6.32 and 2.6.35) 'ls' is
> uninterruptable but hangs only for about 25 seconds (which makes this
> problem really less complex for old kernels). And with new kernels (ubuntu
> 10.04 3.0, ubuntu 12.04 3.2, fedora 17 3.3) I'm facing very long hangs of
> 'ls' (the second problem). And many GUI applications (e.g. nautilus,
> firefox, gnome-panel,mc) that query that directory for some reason appears
> to act the same way as 'ls', so the system becomes unusable for 5(!)
> minutes. When the server (tested with samba 3.6, win2003) becomes
> unavailable nothing is written on the mounted directory, so I can't
> understand why this timeout is so big. Here is how I tested this:
> 
>  # mount.cifs //fsrv/home /mnt "-ouser=test,dom=wg,soft"
>  Password:
>  # time ls /mnt
>  Desktop Documents Program Files WINDOWS
> 
>  real 0m0.019s
>  user 0m0.004s
>  sys 0m0.012s
>  # iptables -I OUTPUT -d 172.17.0.65 -j DROP
>  # time ls /mnt # This 'ls' cannot be interrupted
>  ls: cannot access /mnt: Host is down
> 
>  real 4m51.668s
>  user 0m0.004s
>  sys 0m0.016s
>  # time ls /mnt # This 'ls' and all others after can be interrupted
>  ls: cannot access /mnt: Host is down
> 
>  real 0m10.014s
>  user 0m0.008s
>  sys 0m0.004s
> 
> I see these messages in syslog:
> 
>  kernel: [ 1625.552044] CIFS VFS: Server fsrv has not responded in 300
> seconds. Reconnecting...
>  kernel: [ 1655.509422] CIFS VFS: Unexpected lookup error -112
> 
>  ...
> 
>  And I can not see any timeout options for mount.cifs (except acl timeout).
> So, the actual questions are: 1) is there a way to avoid these hangs
> (analog of 'intr'?) and 2) how can I reduce this unreachable-host timeout
> (analog of 'timeo'?)? Maybe there are some variables in the sources?
> 
> Thanks.
> 

You can try setting the echo_retries kernel module parameter to 1,
which should cut down the wait time to 60s. In 3.4, we've removed
that parm and it's now set to 1 always. The timeout between echo
requests (which is how we detect whether the server is still
responding) is not currently tunable.

-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
