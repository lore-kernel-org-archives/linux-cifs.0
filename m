From: "Samuel Kidman" <Samuel.Kidman-Z3GdMYdHZ+HQT0dZR+AlfA@public.gmane.org>
Subject: RE: How do I get the version of CIFS vfs with the backuid and backupgid on my system?
Date: Mon, 13 Aug 2012 16:53:25 +0800
Message-ID: <2017228CAF598D4F8B68E7555B958761024E21DD@pr-pro-exch01-3.SMY.local>
References: <2017228CAF598D4F8B68E7555B958761024E21C5@pr-pro-exch01-3.SMY.local> <CAH2r5msnjMsDtLEiKY6DfAbZnS1uaayyBh6adO==f55bbNapmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <CAH2r5msnjMsDtLEiKY6DfAbZnS1uaayyBh6adO==f55bbNapmA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi thanks for your reply.

My /etc/fstab line-
//prldata/profiles      /home/nagios/cifs2   cifs
noauto,ro,user,credentials=/home/nagios/nagios.filereader.cred,backupuid
=Nagios.FileReader 0   0

If I attempt to mount-
$ mount.cifs //prldata/profiles /home/nagios/cifs2
mount error(22): Invalid argument
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)

Remove 'backupuid' option from fstab:
$ mount.cifs //prldata/profiles /home/nagios/cifs2
$
Mount succeeds.

However-
$ strings cifs.ko | grep 'backup'
<3>CIFS VFS: %s: Invalid backupuid value
<3>CIFS VFS: %s: Invalid backupgid value
backupuid
backupgid

So something is not right. Why can't I use the backupuid option?

Regards, Sam

-----Original Message-----
From: Steve French [mailto:smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] 
Sent: Friday, 10 August 2012 10:42 PM
To: Samuel Kidman
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: How do I get the version of CIFS vfs with the backuid and
backupgid on my system?

3.1 kernel included the backupuid and backupgid mount options.  The
3.4 kernel included a fix for this so that readdir ("ls" command) passes
the backup intent flag.  Version 12.04 of Ubuntu includes at least a 3.2
kernel and would be fine for some backup applications, but if you are
running the previous version it does appear that there are various
apt-get repositories which contain newer kernels.

On Thu, Aug 9, 2012 at 10:03 PM, Samuel Kidman
<Samuel.Kidman-Z3GdMYdHZ+HQT0dZR+AlfA@public.gmane.org> wrote:
> Hello
>
> My system is-
>
> 3.0.0-23-generic-pae #39-Ubuntu SMP Thu Jul 19 19:39:19 UTC 2012 i686
> i686 i386 GNU/Linux
>
> My goal is to mount a CIFS share and utilise backup intent to get read

> access to the CIFS share. However it seems that the version of CIFS 
> vfs or the version of cifs-utils on my system isn't up to date enough 
> to use this functionality. What is the correct version of CIFS vfs to 
> install to get the backupuid and backupgid mounting options? How can 
> this be installed in Ubuntu?
>
> Thanks.
>
> Sam Kidman
> IT System Administrator
>
>
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" 
> in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html



--
Thanks,

Steve
