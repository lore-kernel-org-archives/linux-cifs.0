From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: GSoC -- Possible projects
Date: Thu, 25 Apr 2013 13:24:58 -0500
Message-ID: <CAH2r5mvmee7nraPFMFadsKDfaKCVXfwF33DsEeX-nuRwbuwuYQ@mail.gmail.com>
References: <CA+5B0FPVdGwobN5Jrc+kzRz2vc3DhL=EiSrkLJep3Dkw9QpVzg@mail.gmail.com>
	<20130425125933.10b51b3a@f163.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: =?ISO-8859-1?Q?Aur=E9lien_Aptel?= <aurelien.aptel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130425125933.10b51b3a-c9q3rVCHQSqoYr4blSSd5g@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Also FYI - Trond mentioned a much improved Linux nfs stats gathering
tool last week (during the Linux File System Summit) - I think it was
NFSometer (not certain).  See

http://wiki.linux-nfs.org/wiki/index.php/NFSometer

Would be useful to check on this. The linux nfs git tools repositories
or linux-nfs mailing list might have more info.  Presumably better
than iostat and nfsstat which are also worth examining to see if
similar could be done for cifs/smb2/smb3 kernel stats.

On Thu, Apr 25, 2013 at 5:59 AM, David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org> wrote=
:
> On Tue, 23 Apr 2013 23:06:55 +0200
> Aur=E9lien Aptel <aurelien.aptel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> - Create GUI or command-line tools for displaying /proc/fs/cifs
>> statistics and and mount/session status
>>
>> I was thinking about a simple script that outputs a pretty html/css
>> file. This should be a small task.
>
> FWIW, I'd suggest adding the proc file parser to an existing monitori=
ng
> tool such as PCP[1], which already provides a graphical front-end and
> logging functionality. PCP monitoring agents for Samba[2] and CTDB[3]
> are already available.
>
> Cheers, David
>
> 1. Performance Co-Pilot
>    http://oss.sgi.com/projects/pcp/index.html
> 2. Samba monitoring agent
>    http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dpcp/pcp.git;a=3Dblob;f=3D=
src/pmdas/samba/pmdasamba.pl;hb=3Drefs/heads/master
> 3. CTDB monitoring agent
>    https://git.samba.org/?p=3Dctdb.git;a=3Dblob;f=3Dutils/pmda/pmda_c=
tdb.c;hb=3DHEAD



--=20
Thanks,

Steve
