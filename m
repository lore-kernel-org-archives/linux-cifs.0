From: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Subject: Re: Fwd: cifs ignores sysct setting
Date: Mon, 10 Oct 2011 18:36:15 +0530
Message-ID: <4E92EDC7.30101@suse.com>
References: <02d643a6-776c-4ab4-9561-591934939ae8@absint.swen.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <02d643a6-776c-4ab4-9561-591934939ae8-VJN6hnAnNNsoZRmjwiK4Kw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On 10/10/2011 03:02 PM, Alexander Swen wrote:
> 
> Hi Steve and other CIFS developers, 
> 
> please help me with the following: 
> 1. fix the bug I explain below ;-) 
> 2. tell me to what bug tracking system I should to file it to. 
> 
> so, imho this is a bug: when I load the cifs module it insists in setting oplockenabled to 1 while we want to have locking disabled (due to our poormen's nas who's performance sinks to subzero when we do serious io ;-) 
> 
> I've filed this bug at Debian: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=644135 
> 
> I paste all details over here as well: 
> <paste> 
> Package: linux-mage
> Version: 2.6.32-5-amd64
> 
> cifs.ko module (which is included in the kernel pkg as far as i know)
> cifs driver version 1.61
> 
> when cifs module loads oplock is enabled by default.
> so I can do
> echo 0 >/proc/fs/cifs/OplockEnabled
> but that won't persist through a driver reload. so we tried adding this to /etc/sysctl.conf:
> fs.cifs.OplockEnabled = 0
> however:
> 
> root@nl14s0008-vm1:~# echo 0 >/proc/fs/cifs/OplockEnabled
> root@nl14s0008-vm1:~# cat /proc/fs/cifs/OplockEnabled
> 0
> root@nl14s0008-vm1:~# modprobe -r cifs
> root@nl14s0008-vm1:~# tail -1 /etc/sysctl.conf
> fs.cifs.OplockEnabled = 0

IIUC, CIFS OplockEnabled is not a proper sysctl, it is just a proc
entry. Sysctls are listed below /proc/sys/ directory.

For e.g. try
   sysctl -w fs.cifs.OplockEnabled=0

you'll see the error: "/proc/sys/fs/cifs/OplockEnabled: No such file or
directory". Also,

   sysctl -p

will throw the error: "/proc/sys/fs/cifs/OplockEnabled: No such file or
directory"

It is not clear to me why do you want to unload and reload cifs module
often? The general usage is load module during boot or on first use and
the module lives on till the machine goes down.

I'm not seeing an justification for making it an module parameter. Could
you please explain more on how it will be useful?


-Suresh
