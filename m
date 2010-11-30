From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 11:04:50 -0600
Message-ID: <AANLkTinwtjkL_Exr57wDjRiKQTzVFwjuv=kBOw7s5mgS@mail.gmail.com>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl>
	<AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>
	<alpine.DEB.2.00.1011301739010.31075@awakenings.cable.ziggo.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1011301739010.31075-56sTcPfcKMhJlCS1zhbguEjk2N/pv5CcZkel5v8DVj8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 30, 2010 at 11:00 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrot=
e:
> Hi Shirish,
>
> On Tue, 30 Nov 2010, Shirish Pargaonkar wrote:
>
>> On Tue, Nov 30, 2010 at 7:35 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wr=
ote:
>>>
>>> Here is an overview of what I tested:
>>>
>>> =A0 =A0 =A0 =A0 =A02 =A0 =A0 =A0 =A0 ) =A0 2008 (+DF =A0 2008 (+DFS=
)
>>> NTLM =A0 =A0 =A0 =A0(1) =A0 =A0 =A0OK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 OK
>>> NTLMv2 =A0 =A0 =A0(1) =A0 =A0 =A0(2) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
(2)
>>> NTLMSSP =A0 =A0 (3) =A0 =A0 =A0(3) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(=
3)
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
>> It must be related to bits in flag2 that that client sends in type 1
>> ntlmssp
>> session setup that server eitther expects from client but is missing=
 or
>> does not support/like one of the flags2 bits.
>> Is 10.0.0.7 a box that runs cifs client?
>
> Yes, 10.0.0.7 is an Debian box with vanilla 2.6.37-rc3 kernel and mou=
nt.cifs
> 4.5.
>
>> ntlmv2 is not going to work as it is against Windows 2008, it will r=
eturn
>> invalid parameter error.
>> Jeff Layton had pointed to this which you can try (I have not tried =
it
>> yet)
>> http://support.microsoft.com/kb/957441/en-us
>
> Ok, this registry fix indeed fixes mount.cifs sec=3Dntlmv2 auth on bo=
th my
> 2008 and 2008R2 DC's.
>
> So, now I have:
>
> =A0 =A0 =A0 =A0 =A02003sp2 =A0 2008r2 (+DFS) =A0 2008 (+DFS)
> NTLM =A0 =A0 =A0 =A0(1) =A0 =A0 =A0OK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 OK
> NTLMv2 =A0 =A0 =A0(1) =A0 =A0 =A0OK(2) =A0 =A0 =A0 =A0 =A0 =A0 =A0OK(=
2)
> NTLMSSP =A0 =A0 (3) =A0 =A0 =A0(3) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(3)
>
> =A01 =3D Fails with "Required key not available"
> =A02 =3D Works after applying KB957441 regfix on DC's
> =A03 =3D Fails with "NT_STATUS_NOT_SUPPORTED"
>
> Do you also have an idea on (1), the resolving problem?
>
> Best regards,
> Robbert

That is good to know.  Thanks Jeff.

Robbert, did you send me a wireshark trace with that error?
I do not see that error in any of the trace files you sent.
