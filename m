From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 10:59:33 -0600
Message-ID: <AANLkTinzJ670wHmVeW2ADhx3v0c641fkXeu--Rta9V=N@mail.gmail.com>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl>
	<AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>
	<AANLkTi=c11fiqZkOkdrdNB6KbsDLV4XSfmPjE3_SScOj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=c11fiqZkOkdrdNB6KbsDLV4XSfmPjE3_SScOj-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 30, 2010 at 10:38 AM, Shirish Pargaonkar
<shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Tue, Nov 30, 2010 at 9:45 AM, Shirish Pargaonkar
> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> On Tue, Nov 30, 2010 at 7:35 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wr=
ote:
>>> Hi Shirish,
>>>
>>> Find attached some detailed problem info and pcaps on the different=
 failing
>>> scenario's.
>>>
>>> Please note our setup is not standard, as we're using a BIND DNS se=
rver, and
>>> we have a mix of 3 DC's where only 2 are DFS root.
>>>
>>> Do note however that Windows clients do not have any problem with t=
his
>>> setup.
>>>
>>> If I can be of more help/need to test something, please let me know=
=2E
>>>
>>> Thanks!
>>> --
>>> Robbert
>>>
>>> ---------- Forwarded message ----------
>>> Date: Tue, 30 Nov 2010 14:18:37 +0100 (CET)
>>> From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
>>> To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> Subject: Re: Can't mount Windows DFS root using NTLMv2
>>>
>>> Hi Shirish,
>>>
>>> On Mon, 29 Nov 2010, Shirish Pargaonkar wrote:
>>>
>>>> Robert, does sec=3Dntlmssp without =A0dom=3Dsox helps?
>>>> A wireshark trace when you issue mount command would be useful.
>>>
>>> With or wihout dom=3Dsox does not make a difference.
>>>
>>> Here is an overview of what I tested:
>>>
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02003sp2 =A0 =A0 =A0 =A0 2008r2 (+DFS=
) =A0 2008 (+DFS)
>>> NTLM =A0 =A0 =A0 =A0 =A0 =A0(1) =A0 =A0 =A0 =A0 =A0 =A0 OK =A0 =A0 =
=A0 =A0 =A0 =A0 =A0OK
>>> NTLMv2 =A0 =A0 =A0 =A0 =A0(1) =A0 =A0 =A0 =A0 =A0 =A0 (2) =A0 =A0 =A0=
 =A0 =A0 =A0 (2)
>>> NTLMSSP =A0 =A0 =A0 =A0 (3) =A0 =A0 =A0 =A0 =A0 =A0 (3) =A0 =A0 =A0=
 =A0 =A0 =A0 (3)
>>>
>>>
>>> 1 =3D Fails with "Required key not available"
>>> 2 =3D Fails with "NT_STATUS_INVALID_PARAMETER"
>>> 3 =3D Fails with "NT_STATUS_NOT_SUPPORTED"
>>>
>>> I will send you some detailed logs and pcaps off-list.
>>>
>>> Regards,
>>> Robbert
>>
>> This is strange wrt ntlmssp. =A0In negotiate protocol response, serv=
er
>> does state NTLMSSP as one of the mechanism types.
>> It must be related to bits in flag2 that that client sends in type 1=
 ntlmssp
>> session setup that server eitther expects from client but is missing=
 or
>> does not support/like one of the flags2 bits.
>> Is 10.0.0.7 a box that runs cifs client?
>>
>> ntlmv2 is not going to work as it is against Windows 2008, it will r=
eturn
>> invalid parameter error.
>> Jeff Layton had pointed to this which you can try (I have not tried =
it yet)
>> =A0http://support.microsoft.com/kb/957441/en-us
>>
>
> I think more than fields flags and flags2 in the smb header, it could=
 be
> something to do with flags field in ntlmssp_negotiate (type 1) packet
> sent by the cifs client to Windows server that server does not suppor=
t.
> But then server would return the flags it supports in ntlmssp_challen=
ge
> (type 2) response instead of returning an error.
> So it is perhaps something else that is not supported by the server.
>
> I just mounted a share using sec=3Dntlmssp from a Windows 2008 server=
=2E
> The flags field in ntlmssp_negotiate request from client has same exa=
ct
> value that is in the file 3.pcap capture (0xa0000205), entire
> ntlmssp_negotiate request in both the cases is same yet it fails in
> your installation and it succeeds at the installation I have.
>
> It would be useful to compare with the ntlmssp_negotiate packet that =
a
> Windows client sends to this Windows server.
> And something could be logged in Event Logger on the Windows server.
>

security blob in ntlmssp negotiate request between what cifs client sen=
ds
and what Windows client sends is little different.
cifs client does not encode OIDs for SPNEGO and NTLMSSP mech type
in the request. That could be a cause of error at the setup you have bu=
t at
the setup I have, Windows 2008 server seems to be OK with it.

I can make that change, encode them using asn.1 and see if that helps.
But meanwhile  if even logger is flagging anything, that would be
useful to know.
