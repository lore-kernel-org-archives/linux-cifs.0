From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] CIFS: add SFM mapping for 0x01-0x1F
Date: Wed, 28 Jun 2017 00:02:28 -0500
Message-ID: <CAH2r5msDp046AGiSTXjxfCrkwZoAA7HS7UkhSL8SqAkGaSRP_w@mail.gmail.com>
References: <20170601090006.GA21508@SerNet.DE> <mps4lw0t5o8.fsf@aaptelpc.suse.de>
 <9c69c458-07a8-cd52-df30-72eb28fde38a@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: =?UTF-8?B?QmrDtnJuIEphY2tl?= <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9c69c458-07a8-cd52-df30-72eb28fde38a-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged into cifs-2.6.git

JRA had some security concerns about allowing \ mapping so we need to
be careful in deciding how we want Samba to handle that too

On Thu, Jun 1, 2017 at 5:04 AM, Bj=C3=B6rn Jacke <bjacke-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Hi Aur=C3=A9lien,
> On 01.06.2017 11:31, Aur=C3=A9lien Aptel wrote:
>> Are these mappings documented somewhere? Now that Windows has a new
>> Linux subsystem I wonder if any of these SFM/SFU mappings have changed.
>>
>> Cheers,
>>
>
> it once was documentd in MS KB117258 ... which disappeared
> unfortunately, wayback machine still has is though:
>
> https://web-beta.archive.org/web/20150315001238/http://support.microsoft.=
com:80/en-us/kb/117258
>
> I also verified that current OS X clients use these mappings for SMB.
>
> The only remaining mapping which needs fixing in the cifs module is the
> backslash now.
>
> Bj=C3=B6rn
>
>



--=20
Thanks,

Steve
