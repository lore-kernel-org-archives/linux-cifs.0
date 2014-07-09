From: Kyle Harrigan <kwharrigan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Seemingly random loss of permissions to krb5i multiuser mounts
Date: Wed, 9 Jul 2014 17:04:24 -0400
Message-ID: <CAFknXfCGLi7w63_+kDPt+vq20-4qftaLLX=CBkRpWkaQWS0=WQ@mail.gmail.com>
References: <CAFknXfDUNPpha-do8rXswkMfJzZeDeL4p3La-V4CuA2vQD=nwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFknXfDUNPpha-do8rXswkMfJzZeDeL4p3La-V4CuA2vQD=nwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sun, Jun 22, 2014 at 11:55 AM, Kyle Harrigan <kwharrigan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Greetings,
>
> I've got a small set (12) of RHEL 6.5 boxes connecting to a WS2008
> share using mount.cifs, krb5i, multiuser.
>
> I don't have my specific fstab in front of me, but to recollection it is:
>
> //server.name/share /share cifs sec=krb5i,multiuser,user=MACHINE$ 0 0
> for each machine.
>
> Packet signing was required-- would not mount without krb5i.
>
> /etc/request-key.conf contains the appropriate cifs upcall commands as
> described in the man page.
>
> The machines are joined to the AD domain, and each machine has a good
> /etc/krb5.keytab and good Kerberos operation.
>
> First, the good:
>
> All machines, upon bootup, achieve a good multiuser mount.  Users can
> login, obtain appropriate kerberos tickets, and access the share
> without issue.  Permissions enforcement is correct.  I can tell it is
> working right because multiple users can create files which are owned
> by them.  Users cannot access folders they should not be able to based
> on MSAD permissions setup.  kdestroy causes loss of access to the
> mount as expected... etc.  Smells like victory.
>
> The bad:
>
> Users are experiencing what seem like fairly random loss of
> permissions accessing the share.  After some period of time, users
> begin obtaining "Permission denied" errors when accessing the share.
> It does not happen on all machines.  Some machines seem to stay
> working for a week, while others may go down after only a few hours.
> The only solution once this happens is to mount is to umount and mount
> the share, at which points it immediately works again.  Reboot also
> solves the problem.  The kerberos tickets still appear to be valid, so
> I do not think that is the problem.  In addition, any subsequent
> kdestroy and kinit do not fix it.  So do not believe related to
> Kerberos expiration though have not ruled it out entirely.
>
> The only lead I have right now is I am still seeing some "CIFS VFS:
> Server requires packet signing to be enabled" messages in dmesg even
> though I am mounting as krb5i.  I noticed the default in
> /proc/fs/cifs/SecurityFlags was 0x7 (may use NTLMv2,may use packet
> signing, may use NTLM) , so I attempted to modify to 0x9009 which I
> thought might solve the problem.  My math (hopefully correct :-> )
> there was:
>
>    must use packet signing                         0x01001
> + must use Kerberos                                 0x08008
> ---------------------------------------------------------
>
>                                                   0x09009
>
> I probably owe you version numbers of the module and some more
> specific debug information.  But was hoping to get the thread started
> with a few of the smart guys to see if we can't get the obvious things
> out of the way.
>
> Should I continue to attempt to hunt and resolve any packet signing
> error messages?  Could they somehow be eventually causing the
> permissions errors?  What specific log messages would be helpful?
> I've turned on cifsFYI and looked over DebugData but there is
> obviously a lot there and nothing stuck out.
>
> Any help or guidance would be appreciated.
>
> --
> -Kyle

It has been a little while, so I'm bumping this.

I am still experiencing this issue.

-- 
-Kyle
