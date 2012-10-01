From: "Lott, Christopher M" <clott-as7a0GIpyE2tG0bUXCXiUA@public.gmane.org>
Subject: Re: Ubuntu SecurityFlags at boot
Date: Mon, 01 Oct 2012 18:23:39 -0400
Message-ID: <506A17EB.2050908@appcomsci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I hope it's not too late to reply to this thread from August 2012, and 
that someone can please find time to explain to me how to set security 
flags for CIFS.

In a nutshell I'm trying to connect a freshly installed ubuntu 12.04 
desktop as a client to get files from an old samba server that demands 
passwords as plaintext.  No printing, nothing fancy, just file service.

Is there still a feature in Ubuntu 12.04 to allow this, possibly by 
manipulating these security flags?

I'm basically doing just this:

sudo mount -t cifs //myoldtiredserver/lott /mnt

And watching /var/log/kern.log I see this:

Oct  1 18:14:57 cltp kernel: [ 3397.554888] CIFS VFS: Server requests 
plain text password but client support disabled
Oct  1 18:14:57 cltp kernel: [ 3397.616357] CIFS VFS: cifs_mount failed 
w/return code = -13

All attempts to echo a value to a magic file in /proc/fs/cifs such as 
the one shown below are met with permission denied, even with sudo:

$ sudo echo 0x30030 > /proc/fs/cifs/SecurityFlags
bash: /proc/fs/cifs/SecurityFlags: Permission denied

Please let me know if I'm not asking sensible questions.  :/  Thanks in 
advance for any help!


 > It would be possible to build cifs.ko to enable plain text passwords
 > permanently, but may be simpler to just set this in one of the init
 > scripts.  Generally we want to discourage anyone from using
 > authentication types other than ntlmv2 and kerberos for obvious
 > security reasons.
 >
 > On Sun, Aug 5, 2012 at 6:31 AM,  <blueduck@...> wrote:
 > > Hi,
 > >
 > > Looking at fs/cifs/README, I managed to mount shares with plaintext 
 > passwords (using Kubuntu 12.04)
 > with "echo 0x30030 > /proc/fs/cifs/SecurityFlags". But it as to be 
done after each boot.
 > >
 > > Is there any configuration file to modify to make the change permanent?
