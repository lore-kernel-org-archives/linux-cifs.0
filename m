From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs: ls of mount point gives input/output error (probably
 related to CIFS: getdents() broken for large dirs)
Date: Thu, 29 Dec 2011 00:40:50 -0600
Message-ID: <CADT32e+DsLkz2=Tf7vSpY90A_Cf6HLag8ozvb_MJdpXzyBY5oQ@mail.gmail.com>
References: <4EFBAF99.3010208@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Konstantinos Skarlatos <k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFBAF99.3010208-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Dec 28, 2011 at 6:08 PM, Konstantinos Skarlatos
<k.skarlatos-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I mount via cifs a windows XP share, df gives me correct sizes, but w=
hen I
> ls the mount point i get input/output error.
> strace: http://pastebin.com/WXf8M1nu
>
> mount --verbose -t cifs -o username=3Dadministrator,password=3Dblahbl=
ah
> //192.168.0.11/jobs /mnt/backups/montaz/jobs
> mount.cifs kernel mount options:
> ip=3D192.168.0.11,unc=3D\\192.168.0.11\jobs,,ver=3D1,user=3Dadministr=
ator,pass=3D********
>
> df
> //192.168.0.11/jobs =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 114464 =A0105196
> =A09268 =A092% /mnt/backups/montaz/jobs
>
> ls /mnt/backups/montaz/jobs/
> ls: reading directory /mnt/backups/montaz/jobs/: Input/output error
> total 0
>
> the fun thing is that i can cd to a lower level directory, and ls wor=
ks fine
> there! only the mount point has the problem
>
> ls /mnt/backups/montaz/jobs/test
> total 44K
> drwxr-xr-x 1 root root =A0 =A00 Apr 30 =A02010 blah blah/e
>
> kernel version 3.2rc7
>
> this seems to be related to :
> https://lkml.org/lkml/2011/8/1/427
> Re: [3.0.0+][Regression][Bisected] CIFS: getdents() broken for large =
dirs
>
> Please CC because i am not subscribed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

I was working on phrasing a question for MS.
Noticed this problem too.

MS-CIFS - v20101001, in section 2.2.2.3.1, does not list
info level codes higher than 0x104 for Trans2 subcommand
Trans2_find_first2.

Yet servers such as Windows 2008 and Windows 7, respond
to info levels such as 0x105 correctly. But Windows XP responds
to this info level (0x105) incorrectly.  The Find_First2 data
has fewer entries than the ones listed in search Count field of
=46ind First2 parameters.

Servers such as Windows XP and 2000 should return
an error EOPNOTSUPP for info levels higher than 0x104 but
they do not.


http://msdn.microsoft.com/en-us/library/cc246806(v=3Dprot.13).aspx says=
 that
Windows XP does not handle SMB_FIND_FILE_ID_FULL_DIRECTORY_INFO.

"<66> Section 2.2.8.1.2: The SMB_FIND_FILE_ID_FULL_DIRECTORY_INFO
Information Level was introduced in Windows Server 2003 and is not
present in Windows 2000 Server and Windows XP."
