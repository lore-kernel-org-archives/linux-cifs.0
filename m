From: Werner Maes <Werner.Maes-UiU5zyVfpuo0a//2gYcwQw@public.gmane.org>
Subject: Mount.cifs cannot access Netapp fileshare (ontap 7.3.x)
Date: Mon, 4 Apr 2011 15:31:42 +0200
Message-ID: <9F990792DAA5FF4F96FD0B95C9C44C0B010E1F37A751@ICTS-S-EXC1-CA.luna.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hello

I have an issue with mount.cifs that cannot access a netapp cifs fileshare. There is no problem with smbclient, mount_smbfs in FreeBSD or Mac OSX.

I have compiled the latest kernel (2.6.38.2) with all CIFS options enabled.

First, it works fine with smbclient as you can see below:

: kstestlinux64 / 15:07#; smbclient //server.DOMAIN.kuleuven.be/user -U "DOMAIN\user" 
Enter DOMAIN\user's password: 
Domain=[DOMAIN] OS=[Windows 5.0] Server=[Windows 2000 LAN Manager]
smb: \> ls
  OK.txt                              A        0  Wed Mar 30 14:22:42 2011

                40960 blocks of size 2097152. 40957 blocks available
smb: \>

Mount.cifs does not work
Default value of /proc/fs/cifs/SecurityFlags is 0x07007:

: kstestlinux64 / 15:12#; mount.cifs //server.DOMAIN.kuleuven.be/user /cifs -o username="DOMAIN\user" 
mount error(95): Operation not supported

Other values of the SecurityFlags don't work either:

: kstestlinux64 / 15:14#; echo 0x00007 > /proc/fs/cifs/SecurityFlags
: kstestlinux64 / 15:15#; mount.cifs //server.DOMAIN.kuleuven.be/user /cifs -o username="DOMAIN\user" 
mount error(13): Permission denied

: kstestlinux64 / 15:13#; echo 0x87087 > /proc/fs/cifs/SecurityFlags
: kstestlinux64 / 15:14#; mount.cifs //server.DOMAIN.kuleuven.be/user /cifs -o username="DOMAIN\user" 
mount error(5): Input/output error

This issue may be related to this bug https://bugzilla.samba.org/show_bug.cgi?id=8046

content of this bug below:

mount.cifs cannot do recent NLTM authentication, more specifically NTLMv2 in
NTLMSSP in SPNEGO in GSS-API.

I've asked Jeff Layton for confirmation last year (cfr. infra) and he referred
me to the mailinglist and here.  The problem seems to exist still.

> > Hello mr. Layton
> >
> > [...] It concerns authentication in mount.cifs.  Am I correct in stating
> > that authentication with NTLMv2 (and probably NTLM and LM) is always done
> > directly with hashes in the SMB header (I think you call it "raw NTLMSSP")
> > and there is no way to make mount.cifs use NTLMSSP in SPNEGO in GSS-API (I
> > think you call it "Extended Security" or "SPNEGO-wrapped NTLMSSP")?  Both
> > smbclient and Mac OS X's mount_smbfs do seem to be able to do the latter.

Actually "raw NTLMSSP" is NTLMSSP that's embedded in GSSAPI but without
SPNEGO. The hashes in the header are just plain old NTLMv2. You're
correct that CIFS doesn't support NTLMv2 in NTLMSSP at the moment.


> > Our problem is that we can connect with both smbclient and MacOSX's
> > mount_smbfs to our NetApp ONTAP filer, but not with mount.cifs.  The first
> > two use NTLMSSP in SPNEGO in GSS-API, the latter uses NTLMv2 hashes in the
> > SMB header and that fails.  [...]

Yeah, [...]
