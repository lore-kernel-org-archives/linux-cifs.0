From: "Q (Igor Mammedov)" <niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mounting DFS
Date: Fri, 25 Feb 2011 21:46:07 +0300
Message-ID: <AANLkTinYz7xA4C677Q8z8Of6ZrLkgWXqu7WGqYc5LVse@mail.gmail.com>
References: <4D654BE7.11698.1C98C6C7@Heinrich.Mislik.univie.ac.at>
	<AANLkTinrUrKZ0e26vOGF5RZvTR1BfEXfR8biuE6FeQNK@mail.gmail.com>
	<4D67C586.23676.2643DA29@Heinrich.Mislik.univie.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Heinrich Mislik <Heinrich.Mislik-4JhlDu4IDl0juwv8T7myQQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D67C586.23676.2643DA29-g/LCwZFXqzxQP/zxiyEj5OCYZQ7uCA5dI7sL/E+5skE@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Heinrich,

I guess you are out of luck with msdfs proxy option.
If we look at samba code, it fails here:
[samba.git] / source3 / smbd / service.c

       /* Handle non-Dfs clients attempting connections to msdfs proxy =
*/
         if (lp_host_msdfs() && (*lp_msdfs_proxy(snum) !=3D '\0'))  {
                 DEBUG(3, ("refusing connection to dfs proxy share '%s'=
 "
                           "(pointing to %s)\n",
                         service, lp_msdfs_proxy(snum)));
                 *status =3D NT_STATUS_BAD_NETWORK_NAME;
                 return NULL;
         }

where lp_msdfs_proxy(snum) returns pointer to value of "msdfs proxy",
which obviously isn't empty. And logs message like:
      'refusing connection to dfs proxy share 'dfs' (pointing to
\\127.0.0.1\tmp)'
I don't see how it could work with this code anyway.

As far as I remember it is possible to mount remote DFS root (i.e. virt=
ual root
that returns error STATUS_PATH_NOT_COVERED) and even a chain of them
with your kernel. But server must reply on tree connect to a such share=
 with
error STATUS_PATH_NOT_COVERED and samba don't do it in this case.

sbmclient works because of it dumbly tries to get referrals for every s=
hare it
connects to, and after that it simply connects to a referral if
available or to the
share it was requested to connect.

Workarounds:
1. the easy way to solve issue is use conventional symlink based dfs wh=
ich
works as expected.
2 Or for suicidal ones, hack the kernel and force it to accept
STATUS_BAD_NETWORK_NAME as STATUS_PATH_NOT_COVERED.
It can be done here fs/cifs/connect.c, look for keyword EREMOTE for
places to 'enhance'.

Of cause the right way is to fix samba, but you should probably ask the
author of those lines of code on samba list. I believe it is samba's is=
sue.

--
Regards,
 Igor

On Fri, Feb 25, 2011 at 5:06 PM, Heinrich Mislik
<Heinrich.Mislik-4JhlDu4IDl0juwv8T7myQQ@public.gmane.org> wrote:
> On 25 Feb 2011 at 14:25, Q (Igor Mammedov) wrote:
>
>> > mount -t cifs //someserver/share2 -ouser=3Dsomeuser /mnt
>> Hi Heinrich,
>>
>> Network packets dump of mount attempt would be helpful,
>> so that I can see what exactly going on.
>
> Four Files
>
> smbclient.share1.pcap
> smbclient.share2.pcap
> mount.share1.pcap
> mount.share2.pcap
>
> attached for the following commands:
>
> smbclient -U mi //share99.univie.ac.at/dfs/share1
> smbclient -U mi //share99.univie.ac.at/share2
> mount -t cifs -o user=3Dmi //share99.univie.ac.at/dfs/share1 /mnt cce=
ss
> mount -t cifs -o user=3Dmi //share99.univie.ac.at/share2 /mnt
>
> the last command failed with:
>
> Retrying with upper case share name
> mount error(6): No such device or address
> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>
> Relevant part of smb.conf on share99.univie.ac.at:
>
> [dfs]
> =C2=A0 msdfs root =3D yes
> # symlink exists: /home/dfs/share1 -> msdfs://share.univie.ac.at/zid
> =C2=A0 path =3D /home/dfs
> [share2]
> =C2=A0 msdfs root =3D yes
> =C2=A0 msdfs proxy =3D \share.univie.ac.at\zid
>
> The IP-Adresses are:
>
> 131.130.1.215 ... Server holding dfs-referrals
> 131.130.1.217 ... Server holding actual share
> 131.130.1.80 =C2=A0... client
>
> Hope this helps
>
> Cheers
>
> Heinrich
> --
> Heinrich Mislik
> Zentraler Informatikdienst der Universitaet Wien
> A-1010 Wien, Universitaetsstrasse 7
> Tel.: (+43 1) 4277-14056, Fax: (+43 1) 4277-9140
>
>
> The following section of this message contains a file attachment
> prepared for transmission using the Internet MIME message format.
> If you are using Pegasus Mail, or any other MIME-compliant system,
> you should be able to save it or view it from within your mailer.
> If you cannot, please ask your system administrator for assistance.
>
> =C2=A0 ---- File information -----------
> =C2=A0 =C2=A0 File: =C2=A0smbclient.share1.pcap
> =C2=A0 =C2=A0 Date: =C2=A025 Feb 2011, 14:15
> =C2=A0 =C2=A0 Size: =C2=A07009 bytes.
> =C2=A0 =C2=A0 Type: =C2=A0Unknown
>
> The following section of this message contains a file attachment
> prepared for transmission using the Internet MIME message format.
> If you are using Pegasus Mail, or any other MIME-compliant system,
> you should be able to save it or view it from within your mailer.
> If you cannot, please ask your system administrator for assistance.
>
> =C2=A0 ---- File information -----------
> =C2=A0 =C2=A0 File: =C2=A0smbclient.share2.pcap
> =C2=A0 =C2=A0 Date: =C2=A025 Feb 2011, 14:15
> =C2=A0 =C2=A0 Size: =C2=A06757 bytes.
> =C2=A0 =C2=A0 Type: =C2=A0Unknown
>
> The following section of this message contains a file attachment
> prepared for transmission using the Internet MIME message format.
> If you are using Pegasus Mail, or any other MIME-compliant system,
> you should be able to save it or view it from within your mailer.
> If you cannot, please ask your system administrator for assistance.
>
> =C2=A0 ---- File information -----------
> =C2=A0 =C2=A0 File: =C2=A0mount.share1.pcap
> =C2=A0 =C2=A0 Date: =C2=A025 Feb 2011, 14:15
> =C2=A0 =C2=A0 Size: =C2=A06724 bytes.
> =C2=A0 =C2=A0 Type: =C2=A0Unknown
>
> The following section of this message contains a file attachment
> prepared for transmission using the Internet MIME message format.
> If you are using Pegasus Mail, or any other MIME-compliant system,
> you should be able to save it or view it from within your mailer.
> If you cannot, please ask your system administrator for assistance.
>
> =C2=A0 ---- File information -----------
> =C2=A0 =C2=A0 File: =C2=A0mount.share2.pcap
> =C2=A0 =C2=A0 Date: =C2=A025 Feb 2011, 14:15
> =C2=A0 =C2=A0 Size: =C2=A04692 bytes.
> =C2=A0 =C2=A0 Type: =C2=A0Unknown
>
>
