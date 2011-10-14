From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [v3 PATCH 0/6] Implement byte-range lock caching
Date: Fri, 14 Oct 2011 16:25:47 +0400
Message-ID: <CAKywueT2FMfH72E4Qthfxatsa83tWQ1YQ2C63xmHETX9ubkukg@mail.gmail.com>
References: <1318016059-29306-1-git-send-email-piastry@etersoft.ru>
	<20111014070506.10f0a0b7@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111014070506.10f0a0b7-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/10/14 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> On Fri, =A07 Oct 2011 23:34:13 +0400
> Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
>
>> This patchset is going to simplify brlocking code and add the cachin=
g support for exclusive oplock cases. I splitted it into several indepe=
ndent parts - so, each can be applied separately once it's reviewed.
>>
>> This version of the patchset includes some code style improvements i=
n patch #3.
>>
>> Any comments and testing are welcome!
>>
>
> The above description is a bit vague. Is this just a generic cleanup =
of
> the code, or does it represent any behavioral changes?
>

This patchset consists of cleanup patches as well as the new feature
(lock cache capability). The behavior for the end user is unchanged (I
didn't include the patch that changes unlock call behavior - we
discussed it in "broken mandatory locking behavior" thread).

Thanks for the review of #1, #2 and #3! Could you comment on the others=
, please?

--=20
Best regards,
Pavel Shilovsky.
