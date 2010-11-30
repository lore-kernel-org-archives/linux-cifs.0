From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 18:00:25 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011301739010.31075@awakenings.cable.ziggo.nl>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl> <AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="1448329734-529101430-1291136425=:31075"
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1448329734-529101430-1291136425=:31075
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi Shirish,

On Tue, 30 Nov 2010, Shirish Pargaonkar wrote:

> On Tue, Nov 30, 2010 at 7:35 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote:
>>
>> Here is an overview of what I tested:
>>
>>           2 =A0 =A0 =A0   ) =A0 2008 (+DF   2008 (+DFS)
>> NTLM        (1)      OK                 OK
>> NTLMv2      (1)      (2)                (2)
>> NTLMSSP     (3)      (3)                (3)
>>
>> 1 =3D Fails with "Required key not available"
>> 2 =3D Fails with "NT_STATUS_INVALID_PARAMETER"
>> 3 =3D Fails with "NT_STATUS_NOT_SUPPORTED"
>>
>> I will send you some detailed logs and pcaps off-list.
>>
>> Regards,
>> Robbert
>
> This is strange wrt ntlmssp.  In negotiate protocol response, server
> does state NTLMSSP as one of the mechanism types.
> It must be related to bits in flag2 that that client sends in type 1 ntlm=
ssp
> session setup that server eitther expects from client but is missing or
> does not support/like one of the flags2 bits.
> Is 10.0.0.7 a box that runs cifs client?

Yes, 10.0.0.7 is an Debian box with vanilla 2.6.37-rc3 kernel and=20
mount.cifs 4.5.

> ntlmv2 is not going to work as it is against Windows 2008, it will return
> invalid parameter error.
> Jeff Layton had pointed to this which you can try (I have not tried it ye=
t)
> http://support.microsoft.com/kb/957441/en-us

Ok, this registry fix indeed fixes mount.cifs sec=3Dntlmv2 auth on=20
both my 2008 and 2008R2 DC's.

So, now I have:

           2003sp2   2008r2 (+DFS)   2008 (+DFS)
NTLM        (1)      OK                 OK
NTLMv2      (1)      OK(2)              OK(2)
NTLMSSP     (3)      (3)                (3)

  1 =3D Fails with "Required key not available"
  2 =3D Works after applying KB957441 regfix on DC's
  3 =3D Fails with "NT_STATUS_NOT_SUPPORTED"

Do you also have an idea on (1), the resolving problem?

Best regards,
Robbert
--1448329734-529101430-1291136425=:31075--
