From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [[PATCH v1] 02/37] [CIFS] SMBD: Add structure for SMBD transport
Date: Mon, 14 Aug 2017 15:41:04 +0200
Message-ID: <61ab1564-d699-e8f2-631e-67a6c28b678b@samba.org>
References: <1501704648-20159-1-git-send-email-longli@exchange.microsoft.com>
 <1501704648-20159-3-git-send-email-longli@exchange.microsoft.com>
 <9632c208-d6a5-2c47-b583-274d046d97bd@samba.org>
 <MWHPR21MB019089DF6B0B68C5C2F4FE56CE8E0@MWHPR21MB0190.namprd21.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="Wlhc6bDPnqKSkcktf1RjJqGt9MkbL6J3S"
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
        "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <MWHPR21MB019089DF6B0B68C5C2F4FE56CE8E0-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Wlhc6bDPnqKSkcktf1RjJqGt9MkbL6J3S
Content-Type: multipart/mixed; boundary="npcWNCPcXEWnfKBrgGRWiExisTCAPmhwE";
 protected-headers="v1"
From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Long Li <longli-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
 "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org" <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
 "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
 Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Message-ID: <61ab1564-d699-e8f2-631e-67a6c28b678b-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [[PATCH v1] 02/37] [CIFS] SMBD: Add structure for SMBD transport
References: <1501704648-20159-1-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
 <1501704648-20159-3-git-send-email-longli-Lp/cVzEoVyZiJJESP9tAQJZ3qXmFLfmx@public.gmane.org>
 <9632c208-d6a5-2c47-b583-274d046d97bd-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 <MWHPR21MB019089DF6B0B68C5C2F4FE56CE8E0-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
In-Reply-To: <MWHPR21MB019089DF6B0B68C5C2F4FE56CE8E0-saRRjQKJ25M/hL2NnenhuM1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>

--npcWNCPcXEWnfKBrgGRWiExisTCAPmhwE
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi Long,

>> It seems that the new transport is tied to it's caller regarding struc=
tures and
>> naming conventions.
>>
>> I think it would be better to strictly separate them, as I'd like to u=
se the
>> SMBDirect transport also from the userspace for the client side e.g. i=
n
>> Samba's '[lib]smbclient', but also in Samba's server side code 'smbd'.=

>=20
> Thank you for reviewing the patch set.
>=20
> I think it is possible to separate the common code that implements the =
SMBDirect transport. There are some challenges to reuse the same code for=
 both kernel and user spaces.
> 1. Kernel mode RDMA verbs are similar but different to user-mode ones.
> 2. Some RDMA features (e.g Fast Registration Work Request) are not avai=
lable in user-mode.
> 3. Locking and synchronization mechanism is different
> 4. Memory management is different.
> 5. Process creation/scheduling and data sharing between processes are d=
ifferent, and there is no user-mode code running in interrupt/softirq.
>=20
> Those needs to be abstracted through a layer, the rest of the code can =
be shared. I can work on this after patch set is reviewed.

I guess this is a misunderstanding...

I don't want to use that code and run it in userspace,
I have a userspace prototype more or less working here, see
https://git.samba.org/?p=3Dmetze/samba/wip.git;a=3Dshortlog;h=3Drefs/head=
s/master3-rdma
and
https://git.samba.org/?p=3Dmetze/samba/wip.git;a=3Dblob;f=3Dlibcli/smb/sm=
b_direct.c;h=3D9cc0d861ccfcbb4df9ef6ad85a7fe3d262e549c0;hb=3D85d46de6fdbb=
a041d3e8004af46865a72d2b8405

I goal is that we'll have an api that allows userspace
code to use the kernel code SMBDirect code. This
userspace code would get a file descriptor from the kernel
and would be able to use it similar to a tcp socket.
If the kernel would simulate the 4 byte length header,
it's trivial to get to a stage were smbclient and smbd
are able to support SMBDirect without much changes.
We only need to replace connect(), listen(), accept() and a few more
by SMBDirect versions.

For the real data transfer we might be able to use memfd_create()
or something similar to share the buffers between userspace and kernel.

I guess this is a long way, but having the basic SMBDirect code in
dependently in the kernel would help a lot.

>> Would it be possible to isolate this in
>> smb_direct.c and smb_direct.h while using
>> smb_direct_* prefixes for structures and functions? Also avoiding the =
usage
>> of other headers from fs/cifs/*.h, expect for something generic like n=
terr.h.
>=20
> Sure I will make naming changes and clean up the header files.

Thanks!

>> I guess 'struct cifs_rdma_info' would then be 'struct smb_direct_conne=
ction'.
>> And it won't have a reference to struct TCP_Server_Info.
>=20
> I will look for ways to remove reference to struct TCP_Server_Info . Th=
e reason why it has a reference to TCP_Server_Info is that: TCP_Server_In=
fo represents a transport connection, although it also has many other TCP=
 related code. SMBD needs to get to this connection TCP_Server_Info and s=
et the transport status on shutdown (and maybe other situations).
>=20

Wouldn't it be better to provide a way to ask for the connection state
and let the caller ask for the state instead of changing the callers
structure?

metze


--npcWNCPcXEWnfKBrgGRWiExisTCAPmhwE--

--Wlhc6bDPnqKSkcktf1RjJqGt9MkbL6J3S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJZkahzAAoJEA219WEoab1WwEAP/2Lsf1gqk+zm/O9/7a5KMj+h
0MTYS38aD7X4G7EE3h6Z2qhbLyFEnyOHyULcBaUy3fqVep1xqpcuIc6ZW+KxvkYi
84yL8gnu+UCQFry81Cql8DRouqD8oGEvBYQ+I9Op3Tk3e8GEcqXLP9brImQNtRAJ
f8ouR5JrcwnH+D/07cf3hQ3rn1j3arvoDcbFdJM3Z5hKzolyuFQO3Si7ITqwcrrQ
COMHUk5UMijcXtwo1hY/oWsi/Kto+c/S+pa10H+Hotu/F6OG7mC5G9ECnpFI1p5+
4zx0WoATxlZPVlLBHwpV1Xxx6i/orOZrUHmn5wMbKlWXyyd3iMHjihoH4zB2hwHX
TYzVrIWme3M/M9QhoqkobW/Zd/FOzOuMKtRGa1w3/LGEG6R+U4vwtiKvRGjQ4k81
kqIfXZgq3x3qhTRi39rbsJr4CPpIe++neh2UjANO8t1yTmI7gJV0tk3qU6kYKGUn
aTaMBCl02imliBaIRjwPRWjEpi0sscBQkY8mbyQWZK7/G8fSyT3R7S37ebonoLkR
XPRk5Yz4mtE+hyjDzKakqOMsJ6d85mrxMySMqSUd5Ygqvp4drYzrv1VCtJuAmvAF
lnVsBf8lX5W1sItU4hHIWvU2TQ4X4FIZgQkMk5MR6Kj3GFs1RkbeWz0f9gh/TkmX
PiLJzOuizaiFQVSpi0KY
=5Xey
-----END PGP SIGNATURE-----

--Wlhc6bDPnqKSkcktf1RjJqGt9MkbL6J3S--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
