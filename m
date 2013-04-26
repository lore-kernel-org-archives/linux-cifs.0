From: Venkateswararao Jujjuri <jvrao@us.ibm.com>
Subject: Re: GSoC -- Possible projects
Date: Thu, 25 Apr 2013 17:26:17 -0700
Message-ID: <OF0274EB1C.D2061E77-ON88257B59.0001068D-88257B59.000267CC@us.ibm.com>
References: <CA+5B0FPVdGwobN5Jrc+kzRz2vc3DhL=EiSrkLJep3Dkw9QpVzg@mail.gmail.com>	<20130425125933.10b51b3a@f163.suse.de>
	<CAH2r5mvmee7nraPFMFadsKDfaKCVXfwF33DsEeX-nuRwbuwuYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: David Disseldorp <ddiss@suse.de>, samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5mvmee7nraPFMFadsKDfaKCVXfwF33DsEeX-nuRwbuwuYQ@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Yeah, this is really nice tool and there was good presentation at cthon on 

this.

http://nfsv4bat.org/Documents/ConnectAThon/2013/NFStest.pdf


Venkateswararao Jujjuri (JV)
IBM Master Inventor
TL - NFS-Ganesha  Filesystems
LTC, Beaverton, OR



From:
Steve French <smfrench@gmail.com>
To:
David Disseldorp <ddiss@suse.de>,=20
Cc:
Aur=E9lien Aptel <aurelien.aptel@gmail.com>,=20
samba-technical@lists.samba.org, linux-cifs@vger.kernel.org
Date:
04/25/2013 11:30 AM
Subject:
Re: GSoC -- Possible projects



Also FYI - Trond mentioned a much improved Linux nfs stats gathering
tool last week (during the Linux File System Summit) - I think it was
NFSometer (not certain).  See

http://wiki.linux-nfs.org/wiki/index.php/NFSometer

Would be useful to check on this. The linux nfs git tools repositories
or linux-nfs mailing list might have more info.  Presumably better
than iostat and nfsstat which are also worth examining to see if
similar could be done for cifs/smb2/smb3 kernel stats.

On Thu, Apr 25, 2013 at 5:59 AM, David Disseldorp <ddiss@suse.de> wrote:
> On Tue, 23 Apr 2013 23:06:55 +0200
> Aur=E9lien Aptel <aurelien.aptel@gmail.com> wrote:
>
>> - Create GUI or command-line tools for displaying /proc/fs/cifs
>> statistics and and mount/session status
>>
>> I was thinking about a simple script that outputs a pretty html/css
>> file. This should be a small task.
>
> FWIW, I'd suggest adding the proc file parser to an existing monitoring
> tool such as PCP[1], which already provides a graphical front-end and
> logging functionality. PCP monitoring agents for Samba[2] and CTDB[3]
> are already available.
>
> Cheers, David
>
> 1. Performance Co-Pilot
>    http://oss.sgi.com/projects/pcp/index.html
> 2. Samba monitoring agent
>   =20
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=3Dpcp/pcp.git;a=3Dblob;f=3Dsrc/pmda=
s/samba/pmdasamba.pl;hb=3Drefs/heads/master

> 3. CTDB monitoring agent
>   =20
https://git.samba.org/?p=3Dctdb.git;a=3Dblob;f=3Dutils/pmda/pmda=5Fctdb.c;h=
b=3DHEAD



--=20
Thanks,

Steve
