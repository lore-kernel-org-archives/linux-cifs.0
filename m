From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH] CIFS: Fix mkdir/rmdir bug for the non-POSIX case
Date: Sun, 12 Feb 2012 22:47:42 +0400
Message-ID: <CAKywueQQe5AbHvucDhQBQN1acZ5w-VoVT=PMHnSPjHPW6ms54w@mail.gmail.com>
References: <1328810892-21925-1-git-send-email-piastry@etersoft.ru>
	<20120210132216.03badf59@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120210132216.03badf59-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/2/10 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Thu, =A09 Feb 2012 21:08:12 +0300
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> Currently we do inc_nlink/drop_nlink for a parent directory for ever=
y
>> mkdir and rmdir calls. That's wrong when POSIX extensions are disabl=
ed
>> because in this case a server doesn't do the same things and returns
>> the old value on the next QueryInfo request. As the result, we updat=
e
>> our value with the server one and then decrement it on every rmdir
>> call - go to negative nlink values.
>>
>> Fix this by doing inc_nlink/drop_nlink for parent directory in mkdir
>> and rmdir in POSIX case only. Also add cERROR when nlink value <=3D =
2
>> and we still try to decrement it (possible broken servers).
>>
>
> Rather than doing that, I think it would be better not to do the
> inc/dec_nlink in either case and instead to set cifsi->time on the
> parent to 0 for both cases.
>
> That should force it to have the directory attributes refetched at th=
e
> next opportunity. Since we're not doing that now, we're likely missin=
g
> out on stuff like directory mtime changes as well.
>

I think this is a good idea, thanks! I'll try it and post a patch if it=
's ok.

--=20
Best regards,
Pavel Shilovsky.
