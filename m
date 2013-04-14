From: steve <steve-dZ4O0aZtNmBWk0Htik3J/w@public.gmane.org>
Subject: Re: kerberised cifs must have root krb5cc_0 cache?
Date: Mon, 15 Apr 2013 01:28:39 +0200
Message-ID: <516B3BA7.1090700@steve-ss.com>
References: <1933147666.1014.1365943484239.JavaMail.root@hendelman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Robert J. Hendelman Jr" <rob-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1933147666.1014.1365943484239.JavaMail.root-LqVPM+lxSZAcWVvVuXF20w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi everyone and thanks for the input.

On 14/04/13 14:44, Robert J. Hendelman Jr wrote:
> The other option which worked for me was using the KRB5 credentials of the machine account to do the mount.
>
> A few months ago Mr. Layton point this out to me and I did eventually end up getting it to work fairly well.  If you are root & need to browse around, you'll need to kinit as somebody (unless root is not just a local account but a domain user as well).
>
> My setup is samba 3.6.3 connected to AD, but I imagine it should work the same if you have a samba4 DC.
>
> My fstab looks something like:
>
> //server/share /localmntpoint cifs cache=strict,sec=krb5i,multiuser,acl,username=MACHINENAME$ 0 2
>
> THis is in ubuntu 12.10.
We've got around it for the moment by extracting a keytab and keeping 
the cache alive by using k5start. It's pretty ugly but it'll do until we 
get some time to tidy it up. I must admit that your solution is better. 
It's further complicated for us as we use autofs. Any reasons why it 
wouldn't adapt to the automounter? Will test and report back anyway if I 
get the time.
>
> The only 2 issues I've found are:
>
> 1) Wwhen logging in via xfce I have to log-in twice.  I login/logout so infrequently it doesn't matter much to me.  I'm not sure why this is, but it only happens when I have my homedir on a samba mount using the above mounting line.
Same here with LXDM. 2 logins are required. This has to be a DM issue 
since KDM logs in fine. The problem there is that you need most of KDE 
to get it installed.  It's more of an issue for us as users on the 
clients are constantly logging in and out. Do you think this is worth a 
bug report? Reproducible on openSUSE. Maybe the XFCE DM and LXDM have 
something in common.
>
> 2) Just after setting up this mountpoint, I experienced it not mounting at startup, however logging in with a localuser and doing "mount -a", it would then work & things would work normally.  This no longer happens (or doesn't happen regularly - race condition in ubuntu startup?) so I mostly had forgotten about it until I started typing this out.
Unfortunately our hardware isn't up to maintaining permanent mounts, so 
we have to use the automounter. Maybe the latter could be an interim 
solution for you until the bug is fixed?
>
> For #2 I've opened a bug on launchpad:
> https://bugs.launchpad.net/ubuntu/+source/upstart/+bug/1130781
>
> Thanks,
>
> Robert
Cheers,
Steve
