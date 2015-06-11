From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: CentOS cifs client sees Windows 2012 deduplicated files as symlinks
Date: Thu, 11 Jun 2015 11:17:45 -0500
Message-ID: <CAH2r5msRpHM7yCHEN5J=osLSnfp+PFepsM8tse8dbJ9FugTvHQ@mail.gmail.com>
References: <CADoiZqqHT1eh7-BvxpbSg8a5S+kLqBmBi-CXWp562BeXooVLgA@mail.gmail.com>
 <CADoiZqqc1Opge73nADG=xPtzvAE2oyK5bf6w3nCZ6n8k6bcfag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Niels Basjes <Niels-WkKhAqUkEt5mR6Xm/wNWPw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADoiZqqc1Opge73nADG=xPtzvAE2oyK5bf6w3nCZ6n8k6bcfag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Out of curiosity what happens when you mount with smb2 or later (e.g.
vers=2.1 on mount) - I expect that they will be recognized
differently.

Copy on write symlinks are reparse points but I would expect them to
look like empty directories.

On Thu, Jun 11, 2015 at 6:53 AM, Niels Basjes <Niels-WkKhAqUkEt5mR6Xm/wNWPw@public.gmane.org> wrote:
> Hi,
>
> Last week I ran into a serious problem from my CentOS 7 system using
> the cifs client to mount a volume on a Windows 2012-R2 server.
> I posted this a problem on ServerFault (
> http://serverfault.com/q/697393 ) a few days ago but I thought that it
> is usefull to ask here too.
> I included some screenshots in the serverfault page so that may be
> useful to have a look at.
>
> The essence of my problem is that the local Windows sysadmin turned on
> a feature to deduplicate files on an existing Windows server volume.
> After that my Linux system started seeing all the files that were
> deduplicated as symlinks to what I can only describe as 'chinese
> letters'.
> Under Windows 7 everything works fine.
>
> The way I currently look at this is that what is apparently some kind
> of 'copy-on-write hardlink' on the Windows server is interpreted as a
> softlink by the cifs client in my CentOS system.
>
> I have been experimenting with some mount settings but I have been
> unable to fix this problem (other than turning off the deduplication).
>
> My current (Client) setup:
> - CentOS 7.0
> - samba-client-4.1.1-38.el7_0.x86_64
> - samba-common-4.1.1-38.el7_0.x86_64
> - samba-libs-4.1.1-38.el7_0.x86_64
> - cifs-utils-6.2-7.el7.x86_64
>
> The command in my /etc/fstab
>
> \\xxxxxxxx\file\video /var/www/html/wp-content/uploads cifs
> nouser_xattr,nounix,iocharset=utf8,credentials=/etc/fstab.cifs.sa_video.credentials,_netdev,uid=apache,gid=apache,rw,auto
> 0 0
>
> How do I get the Linux to see these files as files again?
>
>
> --
> Best regards / Met vriendelijke groeten,
>
> Niels Basjes
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks,

Steve
