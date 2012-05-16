From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [Samba] Trouble with mount.cifs while smbclient works (Ubuntu 12.04)
Date: Wed, 16 May 2012 16:31:22 -0500
Message-ID: <CADT32eLOskZ5iWUTfztAE71G99K2CKr1yXhXqxRqxrxszFPf+w@mail.gmail.com>
References: <B284DF0EE72EBA488F6C7ED035128BF5105B547675@AUSX7MCPS302.AMER.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Scott_Purcell-8PEkshWhKlo@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B284DF0EE72EBA488F6C7ED035128BF5105B547675-aIqoxSDCDnzHZ6aSvHnYXgVY21JRvFwKV6yJEvX+wlw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, May 16, 2012 at 3:52 PM,  <Scott_Purcell-8PEkshWhKlo@public.gmane.org> wrote:
> I just upgraded from Ubuntu 11.04 to 12.04 and am working to restore =
access to the windows shares I use at work.
>
>
>
> smbclient connects immediately:
>
>
>
> =A0 =A0 sudo smbclient //server/share -A /etc/.smb_creds.txt
>
>
>
> mount.cifs fails (with "mount error(13): Permission denied"):
>
>
>
> =A0 =A0 sudo mount.cifs //server/share /mnt/ -o credentials=3D/etc/.s=
mb_creds.txt
>
>
>
>
>
> my credentials file is as follows (with the proper values, of course)=
:
>
>
>
> =A0 =A0 username=3Dmynamehere
>
> =A0 =A0password=3Dpassword
>
> =A0 =A0 domain=3DMyDomain
>
>
>
>
>
> I remember on a previous occasion having resolved a problem by includ=
ing a mount option "noserverino". I've tried that to no effect. I've al=
so tried "sec=3Dntlmv2"
>
>
>
> The syslog contains this message in response to each failed attempt:
>
>
>
> =A0 =A0 CIFS VFS: cifs_mount failed w/return code =3D -13
>
>
>
> Whatever this glitch is, it seems pervasive. =A0smbclient is the ONLY=
 way I've been able to successfully connect to my shares so far. Failed=
 methods attempted include:
>
>
>
> * mounting with "mount -t cifs ..."
>
> * mounting with "mount -t smbfs ..."
>
> * mounting directly with "mount.cifs ..."
>
> * configuring smbnetfs (supposed to make the windows network browsabl=
e from a =A0single mountpoint -- I could see the servers and shares, bu=
t not directories on the shares)
>
> * configuring fusesmb
>
> * Nautilus' "Connect to Server" functionality
>
> * Nautilus' "smb:///..." browsing
>
>
>
> It seems like smbclient is handling authentication in one way (workin=
g) and everything else is doing it in some different way.
>
>
>
>
>
>
>
>
>
> I'm baffled and appreciative of any suggestions you can provide. Than=
ks in advance.
>
>
>
>
>
> Scott Purcell
>
> Dell | GSD Learning & Development
>
>
> Scott Purcell
> Content Development: Linux, Virtualization, and Cloud Solutions
> Dell | GSD Learning & Development
> All about me on PeopleSearch<http://peoplesearch.dell.com/pages/profi=
le.aspx?accountname=3DAMERICAS\SCOTT_PURCELL> | Follow me on Chatter<ht=
tps://na7.salesforce.com/_ui/core/userprofile/UserProfilePage?u=3D005A0=
000000buOq>
>
> --
> To unsubscribe from this list go to the following URL and read the
> instructions: =A0https://lists.samba.org/mailman/options/samba

What is the Windows server?  Can you try a command like

mount -t cifs //servername/sharename <mount_point> -o sec=3Dntlmsspi,
user=3D<username>,pass=3D<password>

You can paste your smb.conf that smbclient uses as well.

Regards,

Shirish
