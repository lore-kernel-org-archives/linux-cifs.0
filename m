From: Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org>
Subject: Re: CIFS mount twice
Date: Wed, 16 Nov 2011 11:09:49 +0530
Message-ID: <20111116110949.Horde.6gCcWVwlEB5Ow0ylU6mSLSA@mail.linuz.in>
References: <20111114172138.Horde.60sJZ1wlEB5OwQDKknIWLdA@mail.linuz.in>
 <loom.20111115T070545-916@post.gmane.org>
 <20111115054504.550248e0@tlielax.poochiereds.net>
 <20111115175612.Horde.N_P5LFwlEB5Owlpkz20HVLA@mail.linuz.in>
 <4EC28EB0.6040100@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EC28EB0.6040100-IBi9RG/b67k@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Quoting Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>:
>> On 11/15/2011 05:56 PM, Aravind M D wrote:
>   >> Quoting Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
>   >>
>   >>> On Tue, 15 Nov 2011 06:07:39 +0000 (UTC)
>   >>> Aravind M D <aravind-f8yKZFm1E5Q@public.gmane.org> wrote:
>   >>>
>   >>>> Aravind M D <aravind@...> writes:
>   >>>>
>   >>>>
>   >>>> >
>   >>>> > Hi,
>   >>>> >
>   >>>> >=A0 =A0I have some cifs mount points configured on my /etc/fs=
tab.
>   >>>> >
>   >>>> >=A0 =A0When i am doing mount -a command mount points are mout=
ing again.
>   >>>> >
>   >>>> >=A0 =A0If mount command is issued mount point is showing twic=
e.
>   >>>> >
>   >>>> >=A0 =A0If i use mount through command line also i am facing t=
he =20
> same issue.
>   >>>> >
>   >>>> >=A0 =A0Please help me.
>   >>>> >
>   >>>> >=A0 =A0Rgds,
>   >>>> >=A0 =A0Aravind M D
>   >>>> >
>   >>>>
>   >>>> Can someone help me with the below issue.
>   >>>>
>   >>>> Thanks in Advance
>   >>>>
>   >>>
>   >>> Not with the description you've given as there's just hardly an=
ything
>   >>> there in the way of details...
>   >>>
>   >>> I set up my fedora rawhide test box with a cifs mount in /etc/f=
stab and
>   >>> then ran mount -a several times. It was only mounted once.
>   >>>
>   >>> IIUC, it's the job of /bin/mount to only attempt to mount files=
ystems
>   >>> that have not already been mounted when mount -a is run. If tha=
t's not
>   >>> happening on your machine then it sounds like something is =20
> broken there.
>   >>>
>   >>> --
>   >>> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>   >>
>   >> Hi Jeff,
>   >>
>   >> I have SLES 11 SAP systems on which some CIFS FS are configured =
on
>   >> /etc/fstab.
>   >>
>   >> ~#cat /etc/fstab
>   >> //oese-sc1-osi01/osiris1=A0 =A0 =A0 =A0/oese-sc1-osi01/osiris1/
>   >> cifs=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 username=3Duser1,passwor=
d=3Dpass1,uid=3D200,gid=3D200
>   >> //oese-sc1-osi02/osiris2=A0 =A0 =A0 =A0/oese-sc1-osi02/osiris2/
>   >> cifs=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 username=3Duser1,passwor=
d=3Dpass1,uid=3D200,gid=3D200
>   >> //oese-sc1-osi99/osiris0=A0 =A0 =A0 =A0/oese-sc1-osi99/osiris0/
>   >> cifs=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 username=3Duser1,passwor=
d=3Dpass1,uid=3D200,gid=3D200
>   >>
>   >> Already these FS are mounted on my system. When i run mount -a a=
nd mount
>   >> command below is the output.
>   >>
>   >> ~#mount
>   >>
>   >> //oese-sc1-osi01/osiris1 on /oese-sc1-osi01/osiris1 type cifs (r=
w,mand)
>   >> //oese-sc1-osi02/osiris2 on /oese-sc1-osi02/osiris2 type cifs (r=
w,mand)
>   >> //oese-sc1-osi99/osiris0 on /oese-sc1-osi99/osiris0 type cifs (r=
w,mand)
>   >> //oese-sc1-osi01/osiris1 on /oese-sc1-osi01/osiris1 type cifs (r=
w,mand)
>   >> //oese-sc1-osi02/osiris2 on /oese-sc1-osi02/osiris2 type cifs (r=
w,mand)
>   >> //oese-sc1-osi99/osiris0 on /oese-sc1-osi99/osiris0 type cifs (r=
w,mand)
>   >>
>   >> Mounts are showing twice.
>   >>
>   >> I have tested the same on Debian 6 also i have faced same =20
> problem. But in
>   >> the debian 6 i tried upgrading the cifs-utils to the latest vers=
ion.
>   >>
>   >> Once cifs-utils was upgraded the mount -a will mount partition =20
> only once.
>   >>
>   >
>   > Looks like you are hitting problems with older version of cifs-ut=
ils.
>   >
>   > I ran the "mount -a" tests on openSUSE 11.4 and SLES11 SP1 but I =
could
>   > reproduce this problem. I don't have a SLES11 setup. I'll see if =
I could
>   > get one. Some useful information that'll help include
>   >
>   > a) version of cifs-utils/cifs-mount
>   > b) version of util-linux
>   > c) mount -a -vvv output
>   >
>   >
>   > OTOH, if you have a support contract with SUSE/Novell, please ope=
n a bug
>   > report on https://bugzilla.novell.com agaist the product and incl=
ude me
>   > in the Cc.
>   >
>   >
>   >
>   > Thanks
>   > Suresh

Hi Suresh,

Please find the details of CIFS configuration i am using.

Debian
------------

root@ser1[1]:~# cat /etc/debian_version
6.0
root@ser1[1]:~# mount.cifs -V
mount.cifs version: 4.5

root@ser1[1]:~# dpkg -l | grep util-linux
ii  util-linux                           2.17.2-9                      =
=20
  Miscellaneous system utilities

mount -a -vvv output for debian is on the below link

http://pastebin.com/E0a4NW46

SLES
------------

ser2:~ # cat /etc/SuSE-release
SUSE Linux Enterprise Server 11 (x86_64)
VERSION =3D 11
PATCHLEVEL =3D 1

ser2:~ # mount.cifs -V
mount.cifs version: 1.12-3.4.3-1.17.2-2359-SUSE-CODE11

ser2:~ # rpm -qa | grep util-linux
util-linux-lang-2.16-6.8.2
util-linux-2.16-6.8.2

mount -a -vvv output for SLES is on the below link

http://pastebin.com/uWaYSqqD


- Aravind



Links:
------
[1] #
