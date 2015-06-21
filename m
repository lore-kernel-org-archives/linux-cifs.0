From: Niels Basjes <Niels-WkKhAqUkEt5mR6Xm/wNWPw@public.gmane.org>
Subject: Re: CentOS cifs client sees Windows 2012 deduplicated files as symlinks
Date: Sun, 21 Jun 2015 21:43:55 +0200
Message-ID: <CADoiZqr=NjgLMrt9o5WUL6zCnRz9bgtBmmcJBWhPd6XRmMkLNA@mail.gmail.com>
References: <CADoiZqqHT1eh7-BvxpbSg8a5S+kLqBmBi-CXWp562BeXooVLgA@mail.gmail.com>
	<CADoiZqqc1Opge73nADG=xPtzvAE2oyK5bf6w3nCZ6n8k6bcfag@mail.gmail.com>
	<CAH2r5msRpHM7yCHEN5J=osLSnfp+PFepsM8tse8dbJ9FugTvHQ@mail.gmail.com>
	<CADoiZqrt0z7f7zs7917e2tCzFb7UFTvN2kaeYRj-A+F4Nmc7LA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADoiZqrt0z7f7zs7917e2tCzFb7UFTvN2kaeYRj-A+F4Nmc7LA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Just to let you know:

I upgraded from CentOS 7.0 to 7.1 and even though the kernel is still
3.10 the problem is now gone.

Thanks for all your help.

Niels Basjes

On Mon, Jun 15, 2015 at 12:38 PM, Niels Basjes <Niels-WkKhAqUkEt5mR6Xm/wNWPw@public.gmane.org> wrote:
> I tried adding the option 'vers=2.1' to the mount but that gave an error:
>      mount error(38): Function not implemented
>
> I do not understand why I saw the files as 'chinese letters' before.
> After my tests and experiments I have been unable to see them this
> way.
> Right now I always see them as a symlink to an empty directory (as you
> indicated).
>
> A few days ago someone posted on serverfault that in fact this is a
> known bug that has been fixed (in kernel 3.13), yet the CentOS 7
> distribution has not yet picked up on this problem because it is
> running kernel 3.10.
>
> See:
> https://bugs.centos.org/view.php?id=7897
> http://serverfault.com/questions/697393/centos-cifs-client-sees-windows-2012-deduplicated-files-as-symlinks
>
> Right now I'm considering to install something like this
> http://elrepo.org/tiki/kernel-ml and run on Linux Kernel 4.x which
> should no longer have this problem.
>
> Niels Basjes
>
>
> On Thu, Jun 11, 2015 at 6:17 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Out of curiosity what happens when you mount with smb2 or later (e.g.
>> vers=2.1 on mount) - I expect that they will be recognized
>> differently.
>>
>> Copy on write symlinks are reparse points but I would expect them to
>> look like empty directories.
>>
>> On Thu, Jun 11, 2015 at 6:53 AM, Niels Basjes <Niels-WkKhAqUkEt5mR6Xm/wNWPw@public.gmane.org> wrote:
>>> Hi,
>>>
>>> Last week I ran into a serious problem from my CentOS 7 system using
>>> the cifs client to mount a volume on a Windows 2012-R2 server.
>>> I posted this a problem on ServerFault (
>>> http://serverfault.com/q/697393 ) a few days ago but I thought that it
>>> is usefull to ask here too.
>>> I included some screenshots in the serverfault page so that may be
>>> useful to have a look at.
>>>
>>> The essence of my problem is that the local Windows sysadmin turned on
>>> a feature to deduplicate files on an existing Windows server volume.
>>> After that my Linux system started seeing all the files that were
>>> deduplicated as symlinks to what I can only describe as 'chinese
>>> letters'.
>>> Under Windows 7 everything works fine.
>>>
>>> The way I currently look at this is that what is apparently some kind
>>> of 'copy-on-write hardlink' on the Windows server is interpreted as a
>>> softlink by the cifs client in my CentOS system.
>>>
>>> I have been experimenting with some mount settings but I have been
>>> unable to fix this problem (other than turning off the deduplication).
>>>
>>> My current (Client) setup:
>>> - CentOS 7.0
>>> - samba-client-4.1.1-38.el7_0.x86_64
>>> - samba-common-4.1.1-38.el7_0.x86_64
>>> - samba-libs-4.1.1-38.el7_0.x86_64
>>> - cifs-utils-6.2-7.el7.x86_64
>>>
>>> The command in my /etc/fstab
>>>
>>> \\xxxxxxxx\file\video /var/www/html/wp-content/uploads cifs
>>> nouser_xattr,nounix,iocharset=utf8,credentials=/etc/fstab.cifs.sa_video.credentials,_netdev,uid=apache,gid=apache,rw,auto
>>> 0 0
>>>
>>> How do I get the Linux to see these files as files again?
>>>
>>>
>>> --
>>> Best regards / Met vriendelijke groeten,
>>>
>>> Niels Basjes
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>
>
>
> --
> Best regards / Met vriendelijke groeten,
>
> Niels Basjes



-- 
Best regards / Met vriendelijke groeten,

Niels Basjes
