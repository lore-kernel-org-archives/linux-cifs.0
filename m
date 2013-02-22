From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: kernel: CIFS VFS: Send error in Flush/Close = -9
Date: Fri, 22 Feb 2013 09:37:09 -0500
Message-ID: <20130222093709.21c46332@tlielax.poochiereds.net>
References: <1633991966.227.1361541137779.JavaMail.root@hendelman.net>
	<106758567.419.1361542484469.JavaMail.root@hendelman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <106758567.419.1361542484469.JavaMail.root-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 22 Feb 2013 08:14:44 -0600 (CST)
"Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org> wrote:

> I'm getting some strange error messages in /var/log/kern.log.
> 
>  kernel: [66276.873095] CIFS VFS: Send error in Flush = -9
>  kernel: [66287.828329] CIFS VFS: Send error in Flush = -9
>  kernel: [66287.829180] CIFS VFS: Send error in Flush = -9
>  kernel: [66289.243979] CIFS VFS: Send error in Flush = -9
> 
> My desktop is Ubuntu 12.10 and has kernel 3.5.0-24-generic w/ cifs module version 1.78 (as per modinfo cifs).
> 
> I've mounted a test server share (Ubuntu 12.04) with the following options as per "cat /etc/fstab"
> 
> //cifserver/data	/data	cifs	noauto,strictcache,sec=krb5i,multiuser,acl,username=MYDESKTOP$	0	2
> 
> Other than this, the share seems to work fine.
> 
> Is this something I should be concerned with or is it more informational?
> 
> Robert

-9 is EBADF. I suspect that means that the server is returning an error
that got translated to that, which probably means it didn't like the
file-id (FID) that the client sent for some reason. This request is for
a SMB_COM_FLUSH which is something like an fsync() in POSIX-land. It
tells the server to commit outstanding data for this open file to
stable storage.

It might be interesting to see a capture of the data between client and
server when you get this, so we can see what error the server is
actually returning.

    https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Wire_Captures

If you do that, it might be best to open a bug at bugzilla.samba.org so
we have a place to track this info. Feel free to CC me on that bug if
you do so.

Thanks,
-- 
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
