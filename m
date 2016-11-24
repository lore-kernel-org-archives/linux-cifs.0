From: =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] CIFS: Fix a possible memory corruption during reconnect
Date: Thu, 24 Nov 2016 17:43:50 +0100
Message-ID: <mps8ts8u8u1.fsf@suse.com>
References: <1478820683-2954-1-git-send-email-pshilov@microsoft.com> <CAKywueR-0h7i2-8OVaC8+KKh1Yjq_otdpuFu582bW=0xQ=+E9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
        Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKywueR-0h7i2-8OVaC8+KKh1Yjq_otdpuFu582bW=0xQ=+E9Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Pavel,

Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:
> 2016-11-10 15:31 GMT-08:00 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> We can not unlock/lock cifs_tcp_ses_lock while walking through ses
>> and tcon lists because it can corrupt list iterator pointers and
>> a tcon structure can be released if we don't hold an extra reference.
>> Fix it by moving a reconnect process to a separate delayed work
>> and acquiring a reference to every tcon that needs to be reconnected.
>> Also do not send an echo request on newly established connections.

I don't fully understand what's going on here but I've successfully
tested your patch.

I've applied your patch and triggered a reconnexion on a smb2 mount by
virtually unplugging/waiting/replugging the network cable (via qemu
set_link <name> on/off). I did not notice any issues.

Let us know if you have a better scenario to test this or a way to
reproduce the previous issue.

Tested-by: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
