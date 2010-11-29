From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2
Date: Mon, 29 Nov 2010 09:05:49 -0600
Message-ID: <AANLkTimaLdKa5OVEjQEbkS+TWVsF1cKRHPaBTaooYCdp@mail.gmail.com>
References: <alpine.DEB.2.00.1011291143280.21269@awakenings.cable.ziggo.nl>
	<AANLkTi=MqT4Fkw2FJZJHvXmwGn1MtB_Gq=aMXwj6Q7Fg@mail.gmail.com>
	<alpine.DEB.2.00.1011291513080.21269@awakenings.cable.ziggo.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1011291513080.21269-56sTcPfcKMhJlCS1zhbguEjk2N/pv5CcZkel5v8DVj8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Nov 29, 2010 at 8:20 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote=
:
> Hi Shirish,
>
> Thanks for your reply.
>
> The DFS root is on 3 domain controllers, one 2003SP2 (10.0.0.11), one=
 2008
> (10.0.0.12) and one 2008R2 (10.0.0.13).
>
> sec=3Dntlmssp gives me STATUS_NOT_SUPPORTED:
>
> =A0fs/cifs/cifsfs.c: Devname: //sox.local/company/ flags: 64
> =A0fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 215 with uid: 0
> =A0fs/cifs/connect.c: Domain name set
> =A0fs/cifs/connect.c: Username: kouprie
> =A0fs/cifs/connect.c: UNC: \\sox.local\company ip: 10.0.0.11
> =A0fs/cifs/connect.c: Socket created
> =A0fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
> =A0fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 216 with =
uid: 0
> =A0fs/cifs/connect.c: Existing smb sess not found
> =A0fs/cifs/cifssmb.c: secFlags 0x80
> =A0fs/cifs/cifssmb.c: NTLMSSP only mechanism, enable extended securit=
y
> =A0fs/cifs/transport.c: For smb_command 114
> =A0fs/cifs/transport.c: Sending smb: =A0total_len 82
> =A0fs/cifs/connect.c: Demultiplex PID: 1860
> =A0fs/cifs/connect.c: rfc1002 length 0xb4
> =A0fs/cifs/cifssmb.c: Dialect: 2
> =A0fs/cifs/asn1.c: OID len =3D 7 oid =3D 0x1 0x2 0x348 0xbb92
> =A0fs/cifs/asn1.c: OID len =3D 7 oid =3D 0x1 0x2 0x348 0x1bb92
> =A0fs/cifs/asn1.c: OID len =3D 8 oid =3D 0x1 0x2 0x348 0x1bb92
> =A0fs/cifs/asn1.c: OID len =3D 10 oid =3D 0x1 0x3 0x6 0x1
> =A0fs/cifs/asn1.c: Need to call asn1_octets_decode() function for
> soxdft01$@SOX.LOCAL
> =A0fs/cifs/cifssmb.c: Signing disabled
> =A0fs/cifs/cifssmb.c: negprot rc 0
> =A0fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x8001f3fd Tim=
eAdjust:
> -3600
> =A0fs/cifs/sess.c: sess setup type 3
> =A0fs/cifs/sess.c: ntlmssp session setup phase 1
> =A0fs/cifs/transport.c: For smb_command 115
> =A0fs/cifs/transport.c: Sending smb: =A0total_len 198
> =A0fs/cifs/connect.c: rfc1002 length 0x27
> =A0Status code returned 0xc00000bb NT_STATUS_NOT_SUPPORTED
> =A0fs/cifs/netmisc.c: Mapping smb error code 50 to POSIX err -22
> =A0fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
> =A0fs/cifs/sess.c: ssetup freeing small buf f0d05500
> =A0CIFS VFS: Send error in SessSetup =3D -22
> =A0fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid =3D 216=
) rc =3D -22
> =A0fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D 215) rc =3D=
 -22
> =A0CIFS VFS: cifs_mount failed w/return code =3D -22
>
> By the way:
>
> # cat /proc/fs/cifs/Experimental
> 2
>
> Regards,
>
> --
> Robbert
>
> On Mon, 29 Nov 2010, Shirish Pargaonkar wrote:
>
>> On Mon, Nov 29, 2010 at 6:33 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wr=
ote:
>>>
>>> Hi all,
>>>
>>> I am trying to mount our DFS root using NTLMv2, but this fails when
>>> resolving the DFS target. Surprisingly, when I use NTLM, it does wo=
rk.
>>>
>>> This fails:
>>>
>>> # mount -t cifs //sox.local/company /mnt/bla/ -o
>>> username=3Dkouprie,dom=3Dsox,sec=3Dntlmv2
>>>
>>> This works:
>>>
>>> # mount -t cifs //sox.local/company /mnt/bla/ -o
>>> username=3Dkouprie,dom=3Dsox,sec=3Dntlm
>>>
>>> I am using linux kernel 2.6.37-rc3 and cifs-utils 4.5-2.
>>> I have keyutils 1.4 =A0installed and configured correctly (obviousl=
y, since
>>> it
>>> works when using sec=3Dntlm).
>>> The domain is configured to "Send NTLMv2 response only. Refuse LM".
>>>
>>> # cat /proc/fs/cifs/DebugData
>>> Display Internal CIFS Data Structures for Debugging
>>> ---------------------------------------------------
>>> CIFS Version 1.68
>>> Features: dfs lanman posix spnego xattr
>>> Active VFS Requests: 0
>>> Servers:
>>>
>>> Log exempt:
>>>
>>> =A0fs/cifs/cifsfs.c: Devname: //sox.local/company/ flags: 64
>>> =A0fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 6 with uid: 0
>>> =A0fs/cifs/connect.c: Domain name set
>>> =A0fs/cifs/connect.c: Username: kouprie
>>> =A0fs/cifs/connect.c: UNC: \\sox.local\company ip: 10.0.0.11
>>> =A0fs/cifs/connect.c: Socket created
>>> =A0fs/cifs/connect.c: sndbuf 16384 rcvbuf 87380 rcvtimeo 0x6d6
>>> =A0fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 7 with =
uid: 0
>>> =A0fs/cifs/connect.c: Existing smb sess not found
>>> =A0fs/cifs/cifssmb.c: secFlags 0x4
>>> =A0fs/cifs/connect.c: Demultiplex PID: 1395
>>> =A0fs/cifs/transport.c: For smb_command 114
>>> =A0fs/cifs/transport.c: Sending smb: =A0total_len 82
>>> =A0fs/cifs/connect.c: rfc1002 length 0x6b
>>> =A0fs/cifs/cifssmb.c: Dialect: 2
>>> =A0fs/cifs/cifssmb.c: Signing disabled
>>> =A0fs/cifs/cifssmb.c: negprot rc 0
>>> =A0fs/cifs/connect.c: Security Mode: 0x3 Capabilities: 0x1f3fd Time=
Adjust:
>>> -3600
>>> =A0fs/cifs/sess.c: sess setup type 2
>>> =A0fs/cifs/transport.c: For smb_command 115
>>> =A0fs/cifs/transport.c: Sending smb: =A0total_len 316
>>> =A0fs/cifs/connect.c: rfc1002 length 0xb5
>>> =A0fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
>>> =A0fs/cifs/sess.c: UID =3D 8192
>>> =A0fs/cifs/sess.c: bleft 135
>>> =A0fs/cifs/sess.c: serverOS=3DWindows Server 2003 3790 Service Pack=
 2
>>> =A0fs/cifs/sess.c: serverNOS=3DWindows Server 2003 5.2
>>> =A0fs/cifs/sess.c: serverDomain=3DSOX
>>> =A0fs/cifs/sess.c: ssetup freeing small buf f0c40000
>>> =A0fs/cifs/connect.c: CIFS Session Established successfully
>>> =A0fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid =3D 7=
) rc =3D 0
>>> =A0fs/cifs/connect.c: file mode: 0x1ed =A0dir mode: 0x1ed
>>> =A0fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 8 with uid=
: 0
>>> =A0fs/cifs/transport.c: For smb_command 117
>>> =A0fs/cifs/transport.c: Sending smb: =A0total_len 94
>>> =A0fs/cifs/connect.c: rfc1002 length 0x27
>>> =A0Status code returned 0xc0000257 NT_STATUS_PATH_NOT_COVERED
>>> =A0fs/cifs/netmisc.c: Mapping smb error code 3 to POSIX err -66
>>> =A0fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid =3D 8) r=
c =3D -66
>>> =A0fs/cifs/connect.c: CIFS Tcon rc =3D -66
>>> =A0fs/cifs/connect.c: Getting referral for: \\sox.local\company
>>> =A0fs/cifs/transport.c: For smb_command 117
>>> =A0fs/cifs/transport.c: Sending smb: =A0total_len 88
>>> =A0fs/cifs/connect.c: rfc1002 length 0x3c
>>> =A0fs/cifs/connect.c: CIFS Tcon rc =3D 0 ipc_tid =3D 4100
>>> =A0fs/cifs/cifssmb.c: In GetDFSRefer the path \sox.local\company
>>> =A0fs/cifs/transport.c: For smb_command 50
>>> =A0fs/cifs/transport.c: Sending smb: =A0total_len 112
>>> =A0fs/cifs/connect.c: rfc1002 length 0x11c
>>> =A0fs/cifs/cifssmb.c: Decoding GetDFSRefer response BCC: 225 =A0Off=
set 56
>>> =A0fs/cifs/cifssmb.c: num_referrals: 2 dfs flags: 0x3 ...
>>>
>>> =A0cifs.upcall: key description: dns_resolver;0;0;3f000000;SOXSRV03=
\C
>>> =A0cifs.upcall: unable to resolve hostname: SOXSRV03\C [Name or ser=
vice not
>>> known]
>>>
>>> =A0CIFS VFS: dns_resolve_server_name_to_ip: unable to resolve: SOXS=
RV03\C
>>> =A0CIFS VFS: cifs_compose_mount_options: Failed to resolve server p=
art of
>>> \\SOXSRV03\Company to IP: -126
>>> =A0fs/cifs/connect.c: cifs_put_smb_ses: ses_count=3D1
>>>
>>> =A0fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 9 with =
uid: 0
>>> =A0fs/cifs/cifssmb.c: In SMBLogoff for session disconnect
>>> =A0fs/cifs/transport.c: For smb_command 116
>>> =A0fs/cifs/transport.c: Sending smb: =A0total_len 43
>>> =A0fs/cifs/connect.c: rfc1002 length 0x2b
>>> =A0fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid =3D 6) rc =3D=
 -126
>>> =A0CIFS VFS: cifs_mount failed w/return code =3D -126
>>>
>>> As you can see above, upcall tries to resolve "SOXSRV03\C", which i=
s
>>> obviously the hostname including the first letter of the share.
>>>
>>> Does anyone know how I can fix this?
>>>
>>> Best regards,
>>>
>>> --
>>> Robbert
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-cif=
s" in
>>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>> You can try sec=3Dntlmssp. =A0What kind of Windows box is this?
>>
>>
>

Robert, does sec=3Dntlmssp without  dom=3Dsox helps?
A wireshark trace when you issue mount command would be useful.

Regards,

Shirish
