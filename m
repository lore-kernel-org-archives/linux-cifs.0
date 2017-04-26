From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Unable to mount windows share as administrator
Date: Wed, 26 Apr 2017 05:50:33 -0500
Message-ID: <CADT32eLveM3g5qwKrOyR=prRtqSgeC3nsyq__yw+HGdFdJx5Kg@mail.gmail.com>
References: <CAJvXCJfBq=iLK=pPXuwQN1fZ4exVkrp2QP5cywWhygpMoKZPLA@mail.gmail.com>
 <af6f37b9-fb85-da5d-7867-8aaec8f05f7a@citrix.com> <mpsvaqlhhes.fsf@aaptelpc.suse.de>
 <CAJvXCJddxTCSxOV25XesKn6=EeiJ=MpZ4DGpx9BUbQJ-ZK3S9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel-IBi9RG/b67k@public.gmane.org>,
        Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>,
        linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jon Scott <jonzanscott-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJvXCJddxTCSxOV25XesKn6=EeiJ=MpZ4DGpx9BUbQJ-ZK3S9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If authentication works for a regular domain user, it should work for
another domain user albeit with more privileges, do not think
authentication is affected by privileges, just the credentials.
Can you mount this share from another Windows box for user RONE/root?

On Mon, Apr 3, 2017 at 8:26 PM, Jon Scott <jonzanscott-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> smbclient works great as a regular user, but fails as root (which is
> the name of an administrator on the Windows 10 machine).
>
> Thank you very much!
>
> On Mon, Apr 3, 2017 at 7:14 AM, Aur=C3=A9lien Aptel <aaptel-IBi9RG/b67k@public.gmane.org> wro=
te:
>> Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org> writes:
>>> Before the right guys would answer more appropriately than me:
>>>
>>> 1) are the 2 users credentials stored in the same domain?
>>> 2) what is the difference in the packet trace between the successful
>>>    one and the failing one?
>>> 3) what does the kern.log (or dmesg) says when the cifs module verbosit=
y
>>>    is increased?
>>
>> Also, does it work using smbclient?
>>
>> --
>> Aur=C3=A9lien Aptel / SUSE Labs Samba Team
>> GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
>> SUSE Linux GmbH, Maxfeldstra=C3=9Fe 5, 90409 N=C3=BCrnberg, Germany
>> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton, HRB 21284 (AG =
N=C3=BCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
