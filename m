From: Alexander Swen <alex-UE4+9DRHXtc@public.gmane.org>
Subject: Fwd: cifs ignores sysct setting
Date: Mon, 10 Oct 2011 11:32:45 +0200 (CEST)
Message-ID: <02d643a6-776c-4ab4-9561-591934939ae8@absint.swen.nu>
References: <1e802d3a-c72d-43a7-8bcb-ddf5534968f9@absint.swen.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1e802d3a-c72d-43a7-8bcb-ddf5534968f9-VJN6hnAnNNsoZRmjwiK4Kw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>


Hi Steve and other CIFS developers, 

please help me with the following: 
1. fix the bug I explain below ;-) 
2. tell me to what bug tracking system I should to file it to. 

so, imho this is a bug: when I load the cifs module it insists in setting oplockenabled to 1 while we want to have locking disabled (due to our poormen's nas who's performance sinks to subzero when we do serious io ;-) 

I've filed this bug at Debian: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=644135 

I paste all details over here as well: 
<paste> 
Package: linux-mage
Version: 2.6.32-5-amd64

cifs.ko module (which is included in the kernel pkg as far as i know)
cifs driver version 1.61

when cifs module loads oplock is enabled by default.
so I can do
echo 0 >/proc/fs/cifs/OplockEnabled
but that won't persist through a driver reload. so we tried adding this to /etc/sysctl.conf:
fs.cifs.OplockEnabled = 0
however:

root@nl14s0008-vm1:~# echo 0 >/proc/fs/cifs/OplockEnabled
root@nl14s0008-vm1:~# cat /proc/fs/cifs/OplockEnabled
0
root@nl14s0008-vm1:~# modprobe -r cifs
root@nl14s0008-vm1:~# tail -1 /etc/sysctl.conf
fs.cifs.OplockEnabled = 0
root@nl14s0008-vm1:~# lsmod|grep cifs
root@nl14s0008-vm1:~# modprobe cifs
root@nl14s0008-vm1:~# !l
lsmod |grep cifs
cifs 262528 0
nls_base 6377 3 cifs,nls_utf8,usbcore
root@nl14s0008-vm1:~# !cat
cat /proc/fs/cifs/OplockEnabled
1

So, when I read the modinfo of cifs, there are a few module options, but no oplock option.
I would like to add something like:
options cifs oplocksenabled=0
to /etc/modprobe.d/aliases.conf

Is it feasible to add that param as an option?

I use the cifs 1.61 module on 2.6.32-5-amd64 kernel on Debian 6.0 (Debian 2.6.32-35squeeze2)

</paste> 
so, Ben is partly right, me request to add a param option is a wishlist thing, but the behaviour of the sysctl setting is a bug imho. 

thanks for your response! 
Alex 




Met vriendelijke groet, 
Alexander Swen 

Met vriendelijke groet, Alexander Swen 


Met vriendelijke groet, 
Alexander Swen 

----- Original Message ----- 


From: "Ben Hutchings" <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org> 
To: "Alexander Swen" <alex-UE4+9DRHXtc@public.gmane.org> 
Cc: 644135-61a8vm9lEZVf4u+23C9RwQ@public.gmane.org 
Sent: Friday, 7 October, 2011 7:03:59 AM 
Subject: Re: cifs ignores sysct setting 

On Mon, 2011-10-03 at 09:46 +0200, Alexander Swen wrote: 
> Package: linux-mage 
> Version: 2.6.32-5-amd64 
> 
> cifs.ko module (which is included in the kernel pkg as far as i know) 
> cifs driver version 1.61 
> 
> when cifs module loads oplock is enabled by default. 
> so I can do 
> echo 0 >/proc/fs/cifs/OplockEnabled 
> but that won't persist through a driver reload. so we tried adding 
> this to /etc/sysctl.conf: 
> fs.cifs.OplockEnabled = 0 
[...] 
> So, when I read the modinfo of cifs, there are a few module options, 
> but no oplock option. 
> I would like to add something like: 
> options cifs oplocksenabled=0 
> to /etc/modprobe.d/aliases.conf 
> 
> Is it feasible to add that param as an option? 
[...] 

You should ask the upstream developers (Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> 
and linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org) for this feature. 

Ben. 

-- 
Ben Hutchings 
For every action, there is an equal and opposite criticism. - Harrison 
