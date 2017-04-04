From: Jon Scott <jonzanscott-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unable to mount windows share as administrator
Date: Mon, 3 Apr 2017 21:26:35 -0400
Message-ID: <CAJvXCJddxTCSxOV25XesKn6=EeiJ=MpZ4DGpx9BUbQJ-ZK3S9w@mail.gmail.com>
References: <CAJvXCJfBq=iLK=pPXuwQN1fZ4exVkrp2QP5cywWhygpMoKZPLA@mail.gmail.com>
 <af6f37b9-fb85-da5d-7867-8aaec8f05f7a@citrix.com> <mpsvaqlhhes.fsf@aaptelpc.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <mpsvaqlhhes.fsf-zpEvHKhluMwYitT5tn2FcQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

smbclient works great as a regular user, but fails as root (which is
the name of an administrator on the Windows 10 machine).

Thank you very much!

On Mon, Apr 3, 2017 at 7:14 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wrote=
:
> Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> writes:
>> Before the right guys would answer more appropriately than me:
>>
>> 1) are the 2 users credentials stored in the same domain?
>> 2) what is the difference in the packet trace between the successful
>>    one and the failing one?
>> 3) what does the kern.log (or dmesg) says when the cifs module verbosity
>>    is increased?
>
> Also, does it work using smbclient?
>
> --
> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG N=
=C3=BCrnberg)
