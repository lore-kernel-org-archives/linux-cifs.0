From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Ubuntu SecurityFlags at boot
Date: Mon, 1 Oct 2012 21:48:48 -0400
Message-ID: <20121001214848.45781bb3@corrin.poochiereds.net>
References: <506A17EB.2050908@appcomsci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Lott, Christopher M" <clott-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506A17EB.2050908-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 01 Oct 2012 18:23:39 -0400
"Lott, Christopher M" <clott-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org> wrote:

> I hope it's not too late to reply to this thread from August 2012, and 
> that someone can please find time to explain to me how to set security 
> flags for CIFS.
> 
> In a nutshell I'm trying to connect a freshly installed ubuntu 12.04 
> desktop as a client to get files from an old samba server that demands 
> passwords as plaintext.  No printing, nothing fancy, just file service.
> 
> Is there still a feature in Ubuntu 12.04 to allow this, possibly by 
> manipulating these security flags?
> 
> I'm basically doing just this:
> 
> sudo mount -t cifs //myoldtiredserver/lott /mnt
> 
> And watching /var/log/kern.log I see this:
> 
> Oct  1 18:14:57 cltp kernel: [ 3397.554888] CIFS VFS: Server requests 
> plain text password but client support disabled
> Oct  1 18:14:57 cltp kernel: [ 3397.616357] CIFS VFS: cifs_mount failed 
> w/return code = -13
> 
> All attempts to echo a value to a magic file in /proc/fs/cifs such as 
> the one shown below are met with permission denied, even with sudo:
> 
> $ sudo echo 0x30030 > /proc/fs/cifs/SecurityFlags
> bash: /proc/fs/cifs/SecurityFlags: Permission denied
> 
> Please let me know if I'm not asking sensible questions.  :/  Thanks in 
> advance for any help!
> 
> 

The sudo in the above command just covers the echo command. The shell
redirection (and hence the write to SecurityFlags) is done as the
original user, which is why you're getting EACCES. You probably want
to do something like this to ensure that the shell redirection is done
as root as well:

    $ sudo sh -c "echo 0x30030 > /proc/fs/cifs/SecurityFlags"

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
