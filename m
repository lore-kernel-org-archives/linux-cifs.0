From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cifs srcaddr-v4] cifs: Allow binding to local IP address.
Date: Fri, 3 Sep 2010 17:21:53 -0500
Message-ID: <AANLkTins-m95_tjyxgQGjzDQ+bMehGpAMinAKap_pPF1@mail.gmail.com>
References: <1283367606-14030-1-git-send-email-greearb@candelatech.com>
	<20100901171418.44685b74@tlielax.poochiereds.net>
	<4C7EC614.6020505@candelatech.com>
	<20100901203836.2628ce57@tlielax.poochiereds.net>
	<4C7F3111.80808@candelatech.com>
	<20100902065602.6a62825c@corrin.poochiereds.net>
	<AANLkTi=ezVf0b1Cu+HBKRb7Sns5+bDeFwpV649Ub_RAs@mail.gmail.com>
	<4C807886.6010908@candelatech.com>
	<AANLkTimo-jibAy-D6j1oVy0d5-VwXrtz=Cnxvv6=g5a_@mail.gmail.com>
	<4C81724C.9030702@candelatech.com>
	<AANLkTimGmcSeQEfS_u221RBzR04L_q25kWO31zvouxFM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimGmcSeQEfS_u221RBzR04L_q25kWO31zvouxFM-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Sep 3, 2010 at 5:21 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote=
:
>
> Good point - I need to update the smb2 howto ...
>
> If you have Windows 2008, Windows Vista or Windows 7 - smb2 just work=
s (it is the default for current Windows) but for Samba (version 3.5 or=
 later, but current Samba 3.6 server is better and passes Microsoft's (=
and our) functional tests as a server - the client side in the kernel i=
s farther behind) there is an smb.conf entry to add. =A0 A recent blog =
entry summarized the server side for Samba:
>
> With Windows 7 Microsoft have introduce a new variant of the CIFS pro=
tocol, SMB2. Samba is keeping pace, with a sample implementation of SMB=
2 which will be released for early adopters to test in Samba 3.5.0. A f=
ully finished production version is expected to be available in Samba 3=
=2E6.0. Testing SMB2 in Samba 3.5.0 is as simple as setting :
>
> max protocol =3D SMB2
>
> in the [global] section of your smb.conf
>
> On the client side, you need smb2.ko from my smb2.git tree (which cur=
rently has some changes I need to put in to address some sideeffects of=
 the Google Summer of Code smb2 async write performance improvements) -=
 and if you don't want to use ip addresses (mount -t smb2 //127.0.0.1/s=
omeshare /mnt .... etc) then you need to recompile mount.cifs.c as moun=
t.smb2 and put mount.smb2 in /sbin
> The smb2 development tree for the kernel client is at:
> http://git.kernel.org/?p=3Dlinux/kernel/git/sfrench/smb2.git;a=3Dsumm=
ary
> I have 3 patches from Pavel to integrate still and a few other fixes =
(one for unmount in particular) that need to be posted. =A0I expect it =
to be more stable usable by next week (I have been out much of this wee=
k)
> On Fri, Sep 3, 2010 at 5:10 PM, Ben Greear <greearb-my8/4N5VtI7c+919tysfdA@public.gmane.org> =
wrote:
>
> >> since SMB2 is more common with newer systems, and in particular
> >> systems more likely to be running IPv6 and thus seem to export mor=
e
> >> interfaces...am also interested in an SMB2 version of this (we wil=
l be
> >> testing SMB2 extensively in three weeks at the annual Storage
> >> Developer Conference) - smb2.git on kernel.org
> >
> > Is there a howto for configuring an smb2 server and client?
> >
> > I'm very slowly bisecting an O_DIRECT bug for NFS, but might
> > can start working on smb2 while waiting for compiles.
>
>
> --
> Thanks,
>
> Steve
>



--
Thanks,

Steve
