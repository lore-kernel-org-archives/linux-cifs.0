From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mount.cifs cannot access Netapp fileshare (ontap 7.3.x)
Date: Mon, 4 Apr 2011 08:42:53 -0500
Message-ID: <BANLkTik=+OP_i+1X2Chk69hh463p7xqXOQ@mail.gmail.com>
References: <9F990792DAA5FF4F96FD0B95C9C44C0B010E1F37A751@ICTS-S-EXC1-CA.luna.kuleuven.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Werner Maes <Werner.Maes-UiU5zyVfpuo0a//2gYcwQw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9F990792DAA5FF4F96FD0B95C9C44C0B010E1F37A751-clsrj0FXZP67QO2/8GOYwipU80OuX9B3ZICT/w5XTPo@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Apr 4, 2011 at 8:31 AM, Werner Maes
<Werner.Maes-UiU5zyVfpuo0a//2gYcwQw@public.gmane.org> wrote:
> Hello
>
> I have an issue with mount.cifs that cannot access a netapp cifs file=
share. There is no problem with smbclient, mount_smbfs in FreeBSD or Ma=
c OSX.
>
> I have compiled the latest kernel (2.6.38.2) with all CIFS options en=
abled.
>
> First, it works fine with smbclient as you can see below:
>
> : kstestlinux64 / 15:07#; smbclient //server.DOMAIN.kuleuven.be/user =
-U "DOMAIN\user"
> Enter DOMAIN\user's password:
> Domain=3D[DOMAIN] OS=3D[Windows 5.0] Server=3D[Windows 2000 LAN Manag=
er]
> smb: \> ls
> =A0OK.txt =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
A =A0 =A0 =A0 =A00 =A0Wed Mar 30 14:22:42 2011
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A040960 blocks of size 2097152. 40957 bl=
ocks available
> smb: \>
>
> Mount.cifs does not work
> Default value of /proc/fs/cifs/SecurityFlags is 0x07007:
>
> : kstestlinux64 / 15:12#; mount.cifs //server.DOMAIN.kuleuven.be/user=
 /cifs -o username=3D"DOMAIN\user"
> mount error(95): Operation not supported
>
> Other values of the SecurityFlags don't work either:
>
> : kstestlinux64 / 15:14#; echo 0x00007 > /proc/fs/cifs/SecurityFlags
> : kstestlinux64 / 15:15#; mount.cifs //server.DOMAIN.kuleuven.be/user=
 /cifs -o username=3D"DOMAIN\user"
> mount error(13): Permission denied
>
> : kstestlinux64 / 15:13#; echo 0x87087 > /proc/fs/cifs/SecurityFlags
> : kstestlinux64 / 15:14#; mount.cifs //server.DOMAIN.kuleuven.be/user=
 /cifs -o username=3D"DOMAIN\user"
> mount error(5): Input/output error
>
> This issue may be related to this bug https://bugzilla.samba.org/show=
_bug.cgi?id=3D8046
>
> content of this bug below:
>
> mount.cifs cannot do recent NLTM authentication, more specifically NT=
LMv2 in
> NTLMSSP in SPNEGO in GSS-API.
>
> I've asked Jeff Layton for confirmation last year (cfr. infra) and he=
 referred
> me to the mailinglist and here. =A0The problem seems to exist still.
>
>> > Hello mr. Layton
>> >
>> > [...] It concerns authentication in mount.cifs. =A0Am I correct in=
 stating
>> > that authentication with NTLMv2 (and probably NTLM and LM) is alwa=
ys done
>> > directly with hashes in the SMB header (I think you call it "raw N=
TLMSSP")
>> > and there is no way to make mount.cifs use NTLMSSP in SPNEGO in GS=
S-API (I
>> > think you call it "Extended Security" or "SPNEGO-wrapped NTLMSSP")=
? =A0Both
>> > smbclient and Mac OS X's mount_smbfs do seem to be able to do the =
latter.
>
> Actually "raw NTLMSSP" is NTLMSSP that's embedded in GSSAPI but witho=
ut
> SPNEGO. The hashes in the header are just plain old NTLMv2. You're
> correct that CIFS doesn't support NTLMv2 in NTLMSSP at the moment.
>
>
>> > Our problem is that we can connect with both smbclient and MacOSX'=
s
>> > mount_smbfs to our NetApp ONTAP filer, but not with mount.cifs. =A0=
The first
>> > two use NTLMSSP in SPNEGO in GSS-API, the latter uses NTLMv2 hashe=
s in the
>> > SMB header and that fails. =A0[...]
>
> Yeah, [...]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Can you try with mount option sec=3Dntlm or sec=3Dntlmi or sec=3Dntlmv2=
 or sec=3Dntlmv2i
or sec=3Dntlmssp or sec=3Dntlmsspi
