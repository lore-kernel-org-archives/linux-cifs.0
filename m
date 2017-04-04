From: Jon Scott <jonzanscott-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unable to mount windows share as administrator
Date: Mon, 3 Apr 2017 21:22:54 -0400
Message-ID: <CAJvXCJdEbWByRsViSTj1RajM1PSVBUqdq4EzQZW=uH5Bz6yB0w@mail.gmail.com>
References: <CAJvXCJfBq=iLK=pPXuwQN1fZ4exVkrp2QP5cywWhygpMoKZPLA@mail.gmail.com>
 <af6f37b9-fb85-da5d-7867-8aaec8f05f7a@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <af6f37b9-fb85-da5d-7867-8aaec8f05f7a-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

1) Same domain.

2) Packet trace on successful one:

 11 0.025874817  192.168.1.4 -> 192.168.1.2  TCP 66 60038 =E2=86=92 445 [AC=
K]
Seq=3D83 Ack=3D410 Win=3D30336 Len=3D0 TSval=3D534260 TSecr=3D1048034385
 12 0.025925659  192.168.1.4 -> 192.168.1.2  SMB 276 Session Setup
AndX Request, NTLMSSP_NEGOTIATE
 13 0.026379329  192.168.1.2 -> 192.168.1.4  SMB 321 Session Setup
AndX Response, NTLMSSP_CHALLENGE, Error:
STATUS_MORE_PROCESSING_REQUIRED
 14 0.026477102  192.168.1.4 -> 192.168.1.2  SMB 450 Session Setup
AndX Request, NTLMSSP_AUTH, User: RONE\fred
 15 0.027490596  192.168.1.2 -> 192.168.1.4  SMB 193 Session Setup AndX Res=
ponse
 16 0.027539762  192.168.1.4 -> 192.168.1.2  SMB 146 Tree Connect AndX
Request, Path: \\RONE\Users
 17 0.027830569  192.168.1.2 -> 192.168.1.4  SMB 132 Tree Connect AndX Resp=
onse
 18 0.027869958  192.168.1.4 -> 192.168.1.2  SMB 138 Trans2 Request,
QUERY_FS_INFO, Query FS Device Info
 19 0.028056566  192.168.1.2 -> 192.168.1.4  SMB 134 Trans2 Response,
QUERY_FS_INFO
 20 0.028093720  192.168.1.4 -> 192.168.1.2  SMB 138 Trans2 Request,
QUERY_FS_INFO, Query FS Attribute Info
 21 0.028242894  192.168.1.2 -> 192.168.1.4  SMB 146 Trans2 Response,
QUERY_FS_INFO
 22 0.028282004  192.168.1.4 -> 192.168.1.2  SMB 158 Tree Connect AndX
Request, Path: \\192.168.1.2\IPC$
 23 0.028427268  192.168.1.2 -> 192.168.1.4  SMB 126 Tree Connect AndX Resp=
onse
 24 0.028467215  192.168.1.4 -> 192.168.1.2  SMB 164 Trans2 Request,
GET_DFS_REFERRAL, File: \RONE\Users
 25 0.028585940  192.168.1.2 -> 192.168.1.4  SMB 105 Trans2 Response,
GET_DFS_REFERRAL, Error: STATUS_FS_DRIVER_REQUIRED
 26 0.028625329  192.168.1.4 -> 192.168.1.2  SMB 144 Trans2 Request,
QUERY_PATH_INFO, Query File All Info, Path:
 27 0.028863338  192.168.1.2 -> 192.168.1.4  SMB 214 Trans2 Response,
QUERY_PATH_INFO
 28 0.028900213  192.168.1.4 -> 192.168.1.2  SMB 144 Trans2 Request,
QUERY_PATH_INFO, Query File All Info, Path:
 29 0.029113359  192.168.1.2 -> 192.168.1.4  SMB 214 Trans2 Response,
QUERY_PATH_INFO
 30 0.029179566  192.168.1.4 -> 192.168.1.2  SMB 144 Trans2 Request,
QUERY_PATH_INFO, Query File All Info, Path:
 31 0.029390198  192.168.1.2 -> 192.168.1.4  SMB 214 Trans2 Response,
QUERY_PATH_INFO
 32 0.029428470  192.168.1.4 -> 192.168.1.2  SMB 144 Trans2 Request,
QUERY_PATH_INFO, Query File Internal Info, Path:

and from the unsuccessful one:

 22 3.000713055  192.168.1.4 -> 192.168.1.2  TCP 74 60028 =E2=86=92 445 [SY=
N]
Seq=3D0 Win=3D29200 Len=3D0 MSS=3D1460 SACK_PERM=3D1 TSval=3D515405 TSecr=
=3D0 WS=3D128
 23 3.000913071  192.168.1.2 -> 192.168.1.4  TCP 74 445 =E2=86=92 60028 [SY=
N,
ACK] Seq=3D0 Ack=3D1 Win=3D8192 Len=3D0 MSS=3D1460 WS=3D256 SACK_PERM=3D1
TSval=3D1047958967 TSecr=3D515405
 24 3.000953577  192.168.1.4 -> 192.168.1.2  TCP 66 60028 =E2=86=92 445 [AC=
K]
Seq=3D1 Ack=3D1 Win=3D29312 Len=3D0 TSval=3D515405 TSecr=3D1047958967
 25 3.001067552  192.168.1.4 -> 192.168.1.2  SMB 148 Negotiate Protocol Req=
uest
 26 3.001643576  192.168.1.2 -> 192.168.1.4  SMB 475 Negotiate Protocol Res=
ponse
 27 3.001672349  192.168.1.4 -> 192.168.1.2  TCP 66 60028 =E2=86=92 445 [AC=
K]
Seq=3D83 Ack=3D410 Win=3D30336 Len=3D0 TSval=3D515405 TSecr=3D1047958967
 28 3.001726264  192.168.1.4 -> 192.168.1.2  SMB 276 Session Setup
AndX Request, NTLMSSP_NEGOTIATE
 29 3.002076572  192.168.1.2 -> 192.168.1.4  SMB 321 Session Setup
AndX Response, NTLMSSP_CHALLENGE, Error:
STATUS_MORE_PROCESSING_REQUIRED
 30 3.002505936  192.168.1.4 -> 192.168.1.2  SMB 450 Session Setup
AndX Request, NTLMSSP_AUTH, User: RONE\root
 31 3.003142299  192.168.1.2 -> 192.168.1.4  SMB 105 Session Setup
AndX Response, Error: STATUS_LOGON_FAILURE
 32 3.006003702  192.168.1.4 -> 192.168.1.2  SSH 150 Server: Encrypted
packet (len=3D96)
 33 3.006105106  192.168.1.4 -> 192.168.1.2  SSH 118 Server: Encrypted
packet (len=3D64)
 34 3.006198689  192.168.1.4 -> 192.168.1.2  SSH 166 Server: Encrypted
packet (len=3D112)


3)  Using --verbose, dmesg produces:
[19192.774047] Status code returned 0xc000006d NT_STATUS_LOGON_FAILURE
[19192.774065] CIFS VFS: Send error in SessSetup =3D -13
[19192.774277] CIFS VFS: cifs_mount failed w/return code =3D -13

Thank you very much!

On Mon, Apr 3, 2017 at 6:09 AM, Germano Percossi
<germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> wrote:
> Hi,
>
> Before the right guys would answer more appropriately than me:
>
> 1) are the 2 users credentials stored in the same domain?
> 2) what is the difference in the packet trace between the successful
>    one and the failing one?
> 3) what does the kern.log (or dmesg) says when the cifs module verbosity
>    is increased?
>
> Cheers,
> Germano
>
> On 04/02/2017 11:39 PM, Jon Scott wrote:
>> I'm able to mount a share from Windows 10 without problems if my
>> .smbcredentials file contains a username and password of a regular
>> user on the Windows system.  However, if I change the credentials to
>> an administrator on the Windows system, I get:
>>
>> mount error(13): Permission denied
>> Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
>>
>> Here's the relevant /etc/fstab entry:
>> //RONE/Users/fran /rone_users cifs
>> credentials=3D/home/jon/.smbcredentials,ro,iocharset=3Dutf8 0 0
>>
>> 4.4.0-71-generic
>> mount.cifs version: 6.4
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
