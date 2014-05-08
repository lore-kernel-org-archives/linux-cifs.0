From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Inode issue with latest install of Red Hat 5 kernel
Date: Thu, 08 May 2014 11:44:28 +0100
Message-ID: <1399545868.2850.9.camel@sachin-laptop>
References: <031b01cf6a35$1138a690$33a9f3b0$@talinotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tjones-MlT6x/s43OEqDJ6do+/SaQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <031b01cf6a35$1138a690$33a9f3b0$@talinotech.com>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello Tony,

Can you please open a Red Hat support case. We will be able to support
you better from that channel. Please point them to this discussion when
you do open a case.

There have been several changes between 2.6.18-164.el5 and
2.6.18-371.8.el5 kernels. Maybe you could try installing the
intermediate versions and try to determine where the changes took place.

Can you also expand on the following statement.
>When I perform "ls -i /path/to/folder" or stat filename /path/to/folder
> the file or files have an inode - a number greater than 0, but when I
> execute a command like "grep", the inode is 0.

Can you show the outputs from both the working kernel and the newer
kernel which doesn't seem to work properly. I can use this to create a
reproducer on my test machines.

Sachin Prabhu

On Wed, 2014-05-07 at 16:43 -0400, Tony Jones wrote:
> Hi,
> 
> I just installed the latest kernel 2.16.18-371.6.1.el5 on my Red Hat 5.8
> Linux 64-bit server and when I mount a Windows Server 2008 R2  Enterprise
> 6.1 Service Pack 1 share, I lose the inode when I run any commands like
> "grep", "less" or "find" on any file on the share.  This doesn't happen on
> the old kernel 2.16.18-164.el5 that I have installed as well.  I've set the
> /proc/fs/cifs/cifsFYI to 3 for debugging info and can send the output of the
> dmesg's file, if you want to review it.  I'm mounting the share with the
> command "mount -t cifs -o user=name //ip_address/software /path/to/folder.
> When I perform "ls -i /path/to/folder" or stat filename /path/to/folder the
> file or files have an inode - a number greater than 0, but when I execute a
> command like "grep", the inode is 0.  So, the inode is getting lost on the
> new kernel update.  The Red Hat Linux Server 5.8 is a VM running on VmWare
> Workstation 9.0.2 build 1031769. 
> 
> I imported the OVF of the Red Hat 5.8 VM on my Windows 2008 Server R2
> Standard Version Service Pack 1 and installed the latest and same kernel -
> 2.16.18-371.6.1.el5 and everything works fine.  I can "grep" a file or "ls"
> a file and the inode is unchanged.
> 
> This is really strange and was hoping someone may have an idea.  It's not a
> big deal, I can use the old kernel, but would like to know if there's a fix
> for this problem.  If you need more information, please let me know and I
> can send the output of the dmesg > boot.messages file. 
> 
> fs/cifs/sess.c: serverOS=Windows Server 2008 R2 Enterprise 7601 Service Pack
> 1
> fs/cifs/sess.c: serverNOS=Windows Server 2008 R2 Enterprise 6.1
> fs/cifs/connect.c: disk share connection
> fs/cifs/connect.c: nativeFileSystem=NTFS
> 
> Thanks,
> Tony
> 
> Tony Jones
> Talino Technology, Inc.
> tjones-MlT6x/s43OEqDJ6do+/SaQ@public.gmane.org
> O: (703) 436-1467
> C: (703) 927-8158
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
