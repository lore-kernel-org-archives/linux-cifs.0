From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can't mount Windows DFS root using NTLMv2 (fwd)
Date: Tue, 30 Nov 2010 09:45:15 -0600
Message-ID: <AANLkTinHDfxNhKLSEwHtH7oM+EUCj_HB97Ch-9RQXjTj@mail.gmail.com>
References: <alpine.DEB.2.00.1011301428530.15277@awakenings.cable.ziggo.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.00.1011301428530.15277-56sTcPfcKMhJlCS1zhbguEjk2N/pv5CcZkel5v8DVj8@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Nov 30, 2010 at 7:35 AM, Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org> wrote=
:
> Hi Shirish,
>
> Find attached some detailed problem info and pcaps on the different f=
ailing
> scenario's.
>
> Please note our setup is not standard, as we're using a BIND DNS serv=
er, and
> we have a mix of 3 DC's where only 2 are DFS root.
>
> Do note however that Windows clients do not have any problem with thi=
s
> setup.
>
> If I can be of more help/need to test something, please let me know.
>
> Thanks!
> --
> Robbert
>
> ---------- Forwarded message ----------
> Date: Tue, 30 Nov 2010 14:18:37 +0100 (CET)
> From: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
> To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Can't mount Windows DFS root using NTLMv2
>
> Hi Shirish,
>
> On Mon, 29 Nov 2010, Shirish Pargaonkar wrote:
>
>> Robert, does sec=3Dntlmssp without =A0dom=3Dsox helps?
>> A wireshark trace when you issue mount command would be useful.
>
> With or wihout dom=3Dsox does not make a difference.
>
> Here is an overview of what I tested:
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A02003sp2 =A0 =A0 =A0 =A0 2008r2 (+DFS) =
=A0 2008 (+DFS)
> NTLM =A0 =A0 =A0 =A0 =A0 =A0(1) =A0 =A0 =A0 =A0 =A0 =A0 OK =A0 =A0 =A0=
 =A0 =A0 =A0 =A0OK
> NTLMv2 =A0 =A0 =A0 =A0 =A0(1) =A0 =A0 =A0 =A0 =A0 =A0 (2) =A0 =A0 =A0=
 =A0 =A0 =A0 (2)
> NTLMSSP =A0 =A0 =A0 =A0 (3) =A0 =A0 =A0 =A0 =A0 =A0 (3) =A0 =A0 =A0 =A0=
 =A0 =A0 (3)
>
>
> 1 =3D Fails with "Required key not available"
> 2 =3D Fails with "NT_STATUS_INVALID_PARAMETER"
> 3 =3D Fails with "NT_STATUS_NOT_SUPPORTED"
>
> I will send you some detailed logs and pcaps off-list.
>
> Regards,
> Robbert

This is strange wrt ntlmssp.  In negotiate protocol response, server
does state NTLMSSP as one of the mechanism types.
It must be related to bits in flag2 that that client sends in type 1 nt=
lmssp
session setup that server eitther expects from client but is missing or
does not support/like one of the flags2 bits.
Is 10.0.0.7 a box that runs cifs client?

ntlmv2 is not going to work as it is against Windows 2008, it will retu=
rn
invalid parameter error.
Jeff Layton had pointed to this which you can try (I have not tried it =
yet)
 http://support.microsoft.com/kb/957441/en-us
